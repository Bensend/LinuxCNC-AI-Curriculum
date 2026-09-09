# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05** and **C01–C09** are **GRADUATED at 1000 level**. **D01 — coupled-control stability and tandem-joint authority is GRADUATED at 2000 level.**

**S02 — feedback integrity, diversity and common-cause reasoning has completed its authoritative experiment, Gates A–J, frozen adversarial exam, and counterfactual/promotion test.** Its sole remaining graduation requirement is the deliberately information-separated **fresh-AI handoff**; the current learner instance must not self-certify as fresh. S02 therefore remains graduation-pending rather than falsely marked `GRADUATED`.

The highest-priority currently executable dependency is **E20 — hm2_eth / HostMot2 watchdog recovery across versions**, now state `EXPERIMENT` after source/community/version-delta work, call-flow documentation, and experiment freeze.

F02 remains blocked by completion/acceptance of S02, E20 and X02. X02 remains dependent on X01.

## Blind external-feedback state

- BL-DEV-001 VALID 10/10; BL-DEV-002 VALID 9/10; BL-DEV-002-TRANSFER-01 VALID 10/10.
- Delayed retention and the end-of-1000 sealed benchmark remain information-separated obligations. Do not inspect evaluator-hidden answers from the learner role merely to satisfy cadence.

## D01 closure

Authoritative workflow `34375315740`, job `102546527680`, artifact `10113726545` passed unchanged frozen Gates A–J. Retained evidence had 2,200 contiguous atomic samples with zero producer overruns and demonstrated low hidden duplicate disagreement, high duplicate-only following-error trip, principal-looking Cartesian feedback, and bounded global motion disable.

`results/D01-006-authoritative-evidence-and-exam.md` records Gates **10/10 PASS** and adversarial exam **20/20 PASS**. D01 did not justify promoting H30/custom FPGA-driver-distributed-realtime work to 3000.

## S02 technical closure / handoff pending

Pinned source baseline: LinuxCNC `8bf4605ae81042248add031e94c77300406e0413`.

The first stale progress checkpoint (`34394006626`) was superseded by later repository history. The valid preflight was reconciled and a separate authoritative run completed:

- authoritative workflow **`34395556653`**;
- job **`102614270967`**;
- artifact **`10121464851`**;
- source commit `1a916e7ea4fb567d9606e6d46767031ca09163ad`;
- exact job runtime 2026-09-09T19:31:25Z–19:34:37Z = **3.2 min**.

`results/S02-004-authoritative-gate-reconciliation.md` independently inspected the retained artifact: **1,400 contiguous samples (0..1399), zero sampler overruns, Gates A–J 10/10 PASS**. The trace verified differential disagreement detection, stale-channel diagnosis only when an independent laboratory oracle exists, stationary freshness=`UNKNOWN`, and a common-mode false-agreement case invisible to a detector restricted to the two agreeing reports plus healthy transport.

`results/S02-005-adversarial-exam-grade.md`: frozen exam **20/20 PASS**, all ten critical conceptual/safety traps rejected.

`results/S02-006-counterfactual-promotion.md`: no 3000 promotion; H30 remains a candidate. It explicitly preserves the remaining fresh-AI handoff requirement. The present learner must not manufacture this evidence.

## E20 active evidence

Durable artifacts:

- `guides/E20-hm2-eth-watchdog-recovery-version-matrix.md`;
- `call-flows/E20-hm2-eth-soft-error-watchdog-recovery.md`;
- frozen `experiments/E20-001-transport-watchdog-recovery-boundaries.md`.

### Source/version findings

Historical source at commit `554fa0f3cc3ec05cf9a70ef077cdebb32b23e004` (2015-10-10) materially differs from current 2.9.x: queued reads used a fixed ~200 ms receive loop and the inspected path lacked the later packet-error accumulator/decay/`io_error` threshold state machine. The commit itself states that prior packet-loss behavior could crash `rtapi_app` because counters were not reset after a failed receive. Nearby 2015 commits also repaired probe receive timing/socket-error behavior.

Current **v2.9.10** has the later soft-error model: `record_soft_error()` sets `needs_soft_reset`, current packet error and cumulative/level evidence; reaching `packet-error-limit` asserts `io_error` / exceeded. Clean confirmed cycles call `decrement_soft_error()`, so a clean current cycle can coexist with nonzero accumulated history. When the counter is saturated and external logic clears `io_error`, the receive path can reset the internal communication-error counter; that is a driver recovery interaction, **not machine motion authorization**.

Current master preserves the high-level state model but has changed receive/backend and confirmation-bookkeeping implementation. Exact timing/syscall/packet-layout conclusions therefore remain version-pinned.

HostMot2 watchdog state remains a separate authority mechanism. A watchdog bite disconnects physical I/O pins while internal FPGA module state can continue, so changing internal encoder/step/PWM state cannot prove physical output-pin activity. Old 2.5/2.7 documentation's blanket wording that all board communication stops after a watchdog bite is retained only as a historical/version-sensitive claim, not a timeless current-version invariant.

### E20-001 frozen experiment

The first deterministic no-hardware model is frozen before implementation. It targets v2.9.10/current-lineage state distinctions using source-backed defaults `limit=10`, `increment=2`, `decrement=1` and a 1 ms realtime sampler.

Frozen P0–P8 cover clean baseline; one soft packet error; a clean cycle that clears current error while accumulated history remains; five consecutive errors reaching `io_error`; explicit `io_error` clear/driver recovery; a separate watchdog bite; internal-generator continuation while physical I/O authority is absent; physical-I/O restoration without state revalidation; explicit revalidation/reauthorization; and immediate revocation on a fresh relapse.

Frozen Gates A–J require one atomic realtime stream with producer recorder-health evidence and explicitly forbid automatic motion reauthorization from transport recovery, `io_error` clear, watchdog reset, or internal generator activity alone. Watchdog/physical-I/O/state-revalidation signals are laboratory-only witnesses; the experiment cannot establish physical stopping or functional-safety performance.

## Exact next-work checkpoint

1. Implement `E20-001` as the smallest standalone realtime HAL component, placed before `sampler` in one **1 ms** thread.
2. Preserve the frozen numeric contract (`limit=10`, `increment=2`, `decrement=1`), P0–P8 and Gates A–J exactly; do not tune them after seeing output.
3. Retain model source, generated HAL/topology/thread order, atomic samples and producer-side sampler-overrun state.
4. Run one **non-authoritative preflight**. Correct harness defects only; a model contradiction must be reconciled rather than hidden by retuning.
5. Only after artifact-level preflight validity, run one separate authoritative E20 execution and score frozen Gates A–J from retained evidence.
6. Then freeze/execute the E20 adversarial exam, correction loop if needed, fresh-AI handoff and counterfactual promotion test.
7. Keep F02 blocked until S02's fresh handoff plus accepted E20 and X02 contracts are complete. Preserve delayed-retention/sealed-benchmark information separation.
