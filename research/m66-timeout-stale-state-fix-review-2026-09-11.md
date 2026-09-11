# M66 timeout stale-state correction and focused regression review

Date: 2026-09-11
Course context: dependency-safe 4600 preparation while F02 remains blocked
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Prerequisite runtime evidence: `experiments/M66-TIMEOUT-001-run079-independent-audit.md`
Related call flow: `call-flows/press-brake-M66-Q-supervisory-wait-timeout.md`

## Why this follow-up exists

Run 079 confirmed a specific Task-layer state-lifetime defect on the pinned revision: after an `M66 ... Q...` timeout, the documented interpreter result is correct (`#5399 = -1`), but the Task executor leaves the auxiliary-input wait index armed. A following `G4` uses the same `WAITING_FOR_DELAY` execution state and can therefore re-enter stale M66 input evaluation instead of behaving as a pure dwell.

This note reduces that evidence to the smallest maintainable source correction and one focused regression. It deliberately does **not** broaden into an M66 feature matrix or change any press-brake control architecture.

## Source facts

### 1. Timeout completion sets the timeout result but does not disarm the input waiter

Pinned `src/emc/task/emctaskmain.cc` owns process-lifetime static auxiliary wait bookkeeping:

- `emcAuxInputWaitIndex`, initialized to `-1`;
- `emcAuxInputWaitType`;
- `taskExecDelayTimeout`.

When `EMC_AUX_INPUT_WAIT_TYPE` is issued with a timed wait, Task records the wait type and input index, sets `task.input_timeout = 2`, and sets `taskExecDelayTimeout = etime() + timeout`.

In `EMC_TASK_EXEC::WAITING_FOR_DELAY`, expiration does this in the pinned source:

```cpp
emcStatus->task.delayLeft = taskExecDelayTimeout - etime();
if (etime() >= taskExecDelayTimeout) {
    emcStatus->task.execState = EMC_TASK_EXEC::DONE;
    emcStatus->task.delayLeft = 0;
    if (emcStatus->task.input_timeout != 0)
        emcStatus->task.input_timeout = 1; // timeout occurred
    emcTaskEager = 1;
}
```

The same state handler then continues into the auxiliary-input block whenever `emcAuxInputWaitIndex >= 0`. The timeout branch does **not** set the index back to `-1`.

Classification: **SOURCE-CONFIRMED** at the pinned revision and **TEST-CONFIRMED** by run 079.

### 2. Successful/immediate M66 paths do disarm the waiter

The same file clears `emcAuxInputWaitIndex = -1` when an immediate M66 is issued and when a waited-for digital condition succeeds. Therefore `-1` is already the established local sentinel for “no auxiliary input wait is active.”

Classification: **SOURCE-CONFIRMED**.

### 3. Clearing the index on timeout does not destroy documented `#5399 = -1`

Pinned `src/emc/task/emccanon.cc::GET_EXTERNAL_DIGITAL_INPUT()` and `GET_EXTERNAL_ANALOG_INPUT()` first test:

```cpp
if (emcStatus->task.input_timeout == 1)
    return -1;
```

Only after that do they read the selected input. Interpreter resynchronization therefore obtains the timeout sentinel from `task.input_timeout`, not from `emcAuxInputWaitIndex`.

**Consequence:** setting `emcAuxInputWaitIndex = -1` when the timeout completes can preserve `task.input_timeout = 1` and hence preserve the documented `#5399 = -1` result.

Classification: **SOURCE-CONFIRMED**; this is the key discriminator against the misleading idea that stale-index cleanup would erase timeout reporting.

### 4. `G4` shares the delay state but does not initialize M66 bookkeeping

`EMC_TRAJ_DELAY_TYPE` sets `taskExecDelayTimeout` and enters `EMC_TASK_EXEC::WAITING_FOR_DELAY`. It does not establish a new auxiliary-input wait and does not clear `emcAuxInputWaitIndex` first. Thus a stale nonnegative index inherited from a timed-out M66 is causally sufficient to contaminate the following dwell.

Classification: **SOURCE-CONFIRMED + TEST-CONFIRMED** by run 079.

### 5. Abort/reset lifetime is a separate concern

Pinned `src/emc/task/emctask.cc::emcTaskAbort()` aborts motion, clears the pending command and interpreter list, resets interpreter state, and sets `task.execState = DONE`. It does not write `task.input_timeout` and cannot directly clear the file-local static `emcAuxInputWaitIndex` in `emctaskmain.cc`.

A bounded assignment audit of the pinned `emctaskmain.cc` found explicit index clearing in immediate/success M66 paths but no generic abort cleanup.

Classification:

- **SOURCE-CONFIRMED:** `emcTaskAbort()` contains no explicit reset of the auxiliary-input timeout/status fields and the wait index is file-local to `emctaskmain.cc`.
- **INFERENCE / FOLLOW-UP:** an abort during an active M66 can plausibly leave stale auxiliary-wait bookkeeping available to a later shared delay state. This has not been promoted to TEST-CONFIRMED behavior in this lesson and should not be conflated with the already confirmed timeout defect.

## Minimal correction candidate

The narrowest correction for the confirmed timeout defect is to disarm the input waiter at the moment the timed wait becomes terminal while retaining the timeout status:

```cpp
if (etime() >= taskExecDelayTimeout) {
    emcStatus->task.execState = EMC_TASK_EXEC::DONE;
    emcStatus->task.delayLeft = 0;
    if (emcStatus->task.input_timeout != 0) {
        emcStatus->task.input_timeout = 1; // preserve M66 timeout result
        emcAuxInputWaitIndex = -1;        // disarm stale input waiter
    }
    emcTaskEager = 1;
}
```

This is a **patch candidate**, not an upstream claim. It changes only bookkeeping proven stale by the regression and preserves the status consumed by `GET_EXTERNAL_*_INPUT()`.

### Why not clear `task.input_timeout` on timeout?

Doing so would destroy the established mechanism by which the synchronized interpreter observes `-1` and sets `#5399 = -1`. That would trade one bug for a public-semantics regression.

### Why not fix only `G4` by clearing the index when a dwell starts?

That would suppress the observed symptom but leave a timed-out M66 incorrectly armed until some later command happens to sanitize it. Cleanup belongs at the terminal transition of the state being completed. A defensive clear at the start of unrelated delay commands could be considered separately, but it is not the minimum causal correction.

### Why not broaden this patch to abort lifetime now?

The timeout→dwell defect already has frozen runtime evidence. Abort lifetime currently has source evidence of missing explicit cleanup but lacks the same bounded runtime oracle. Mixing the two changes would make the focused regression less discriminating and would exceed the evidence needed for this correction. Preserve abort cleanup as a separate follow-up unless a maintainer chooses to centralize wait-state teardown.

## Focused regression definition

A single regression is sufficient to protect both public timeout semantics and stale-state cleanup:

1. configure one digital input so the requested M66 condition will not become true;
2. execute a timed wait, e.g. `M66 P0 L1 Q0.4`;
3. immediately assert/record that `#5399 == -1`;
4. execute `G4 P0.2`;
5. emit a deterministic marker after the dwell;
6. bound the whole test with an external watchdog comfortably longer than `Q + P` but short enough to fail a stuck Task state.

Required gates:

- **R1:** M66 reaches its timeout rather than input success.
- **R2:** synchronized interpreter result is exactly `#5399 = -1`.
- **R3:** the following G4 reaches its post-dwell marker.
- **R4:** elapsed dwell is not spuriously zero/negative and the external watchdog is not the mechanism that ends the run.

Pre-fix pinned behavior from run 079: R1 PASS, R2 PASS, R3 FAIL. The candidate correction is acceptable only if all four gates pass without changing M66's documented timeout result.

This should become an upstream-style Task/interpreter regression if the defect is proposed to LinuxCNC; there is no information gain in repeatedly running a broad curriculum simulation matrix first.

## Adversarial review

- **Claim:** “The bug is in G4 because G4 hangs.” **Rejected.** G4 exposes stale shared Task state; its own delay command does not create the stale M66 index.
- **Claim:** “Clear `input_timeout` to zero when M66 times out.” **Rejected.** That breaks the `GET_EXTERNAL_*_INPUT()` timeout sentinel and therefore `#5399 = -1`.
- **Claim:** “If `#5399` is already correct, the M66 implementation is correct.” **Rejected.** Run 079 demonstrates an externally visible downstream state-lifetime failure after the correct immediate result.
- **Claim:** “Abort behavior is proven broken by run 079.” **Rejected.** Run 079 proves timeout→G4 contamination. Abort cleanup is a source-level open risk and needs its own oracle if it becomes relevant to a patch.
- **Claim:** “Because M66 is non-realtime, this defect changes the press-brake safety architecture.” **Rejected.** M66 remains a supervisory/program wait only. The defect strengthens the requirement not to assign realtime Y1/Y2 or functional-safety authority to it, but it does not alter those layer boundaries.

## Current-version comparison

A bounded inspection of the LinuxCNC default branch on 2026-09-11 found the same `WAITING_FOR_DELAY` timeout form: timeout sets `task.input_timeout = 1` when nonzero and does not clear the auxiliary-input wait index before the subsequent input-wait block. This indicates the pattern is not merely historical to the pinned curriculum revision. The curriculum still treats the exact pinned SHA as authoritative for its source/test conclusion; default-branch observation is compatibility context only.

## Sufficiency decision

The confirmed timeout defect is reduced to a one-line causal cleanup plus a four-gate regression that preserves public semantics. No additional laboratory run is necessary for curriculum understanding before moving on: the pre-fix behavior is TEST-CONFIRMED, the proposed correction is SOURCE-JUSTIFIED, and its acceptance criterion is explicit.

The unresolved abort cleanup question is intentionally bounded as a separate source-level follow-up rather than allowed to reopen a broad M66 investigation.
