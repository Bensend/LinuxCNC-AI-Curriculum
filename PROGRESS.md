# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through **S07 — restart/recovery/state integrity** are **GRADUATED** at 1000 level. Phase 8 is complete. **T01 — G-code interpreter architecture** is now the highest-priority unblocked module and has advanced to **EXPERIMENT** at pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`.

## T01 current evidence

The documentation/community baseline and first source/call-flow pass are durable:

- `guides/T01-interpreter-source-guide.md`
- `call-flows/T01-task-to-canonical-rapid.md`
- frozen experiment `experiments/T01-018-interpreter-canonical-and-error-plan.md`

Source-confirmed architecture at the pinned revision: Task reaches the pluggable interpreter through `emcTaskPlanRead()` / `emcTaskPlanExecute()`; `Interp::read()` and execution are distinct phases; `execute_block()` dispatches parsed semantics in defined execution order; representative motion conversion reaches canonical calls such as `STRAIGHT_TRAVERSE()`; the Task-side canonical implementation creates trajectory messages and appends them to `interp_list` through `tag_and_send()`. Therefore interpreter progress and machine execution progress are distinct evidence domains.

Current documentation independently describes interpreter-generated canonical operations as queued Task work and explicitly documents read-ahead. Community reports about remap/Python side effects occurring during read-ahead agree with that architecture but remain community evidence until a bounded Task-level test is run.

## S07 graduation checkpoint

S07-017 attempt 3, workflow `34162408769`, completed with lab exit code `0` and `S07-017 overall=PASS`. Runtime A began `joint.0.homed=FALSE`, established TRUE, and shut down through authenticated linuxcncrsh with `SHUTDOWN ACK`. The independent barrier then proved A launcher PID gone, TCP 5007 gone, and exact `halcmd getp joint.0.homed` lookup gone before B was started. Runtime B used a distinct launcher PID, initially exposed `homed=FALSE`, re-homed to TRUE, and the INI SHA-256 was unchanged across both runtimes.

Accepted reconciliation is in `experiments/S07-017-run-34162408769-accepted.md`; fresh-AI handoff and graduation audit are in `guides/S07-fresh-ai-handoff.md`.

Central graduated teaching: process identity, HAL lifetime, LinuxCNC homing state, persistent configuration, measurement provenance, physical position truth, actuator state, and independent safety state are distinct evidence domains. A successful software restart does not prove physical-machine recovery.

### S07 promotion queue

- Absolute-encoder driver/device-specific restart provenance: **2000 / HIGH**, non-blocking because the 1000-level architecture-specific revalidation rule remains valid under the counterfactual.
- Abnormal process death and backend-specific dangling-HAL cleanup: **2000 / MEDIUM**, non-blocking because orderly teardown was independently verified and S07 explicitly forbids PID-freshness => HAL-freshness inference.

Previously recorded S04–S06 promotion items remain active in their graduated handoffs.

## Current checkpoint / exact resume point

Resume **T01-018** without changing its frozen prediction or Gates A-E.

1. Implement the lab harness against the pinned build of `rs274`; prove executable/SHA provenance and keep valid and invalid fixtures in separate invocations.
2. Select a minimal valid `G0` fixture and an invalid fixture that the pinned executable itself proves illegal. Capture fixture hashes/text, command lines, stdout/stderr, and process exit codes.
3. Gate B requires successful canonical `STRAIGHT_TRAVERSE` output for the valid rapid move. Gate C requires a real interpreter failure for the invalid fixture and no false successful canonical motion corresponding to the invalid command. Wrong revision, distro interpreter, ambiguous output capture, or accidentally legal invalid fixture is HARNESS_INVALID.
4. Reconcile T01-018 against the frozen prediction. If it passes, decide whether a second Task/remap experiment is necessary to independently verify the read-ahead / `INTERP_EXECUTE_FINISH` boundary; do not infer Task timing from the standalone interpreter test.
5. Then complete the T01 adversarial exam, fresh-AI novel-scenario handoff, corrections, promotion queue, and counterfactual graduation audit.

Safety boundary remains unchanged: interpreter and Task synchronization behavior is ordinary machine-control behavior, not evidence of a safety-rated function.
