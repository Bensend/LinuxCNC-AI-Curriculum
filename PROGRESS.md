# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05** and **C01–C09** are **GRADUATED at 1000 level**. **D01 — coupled-control stability and tandem-joint authority is GRADUATED at 2000 level.**

**S02 — feedback integrity, diversity and common-cause reasoning has completed its authoritative experiment, Gates A–J, frozen adversarial exam, and counterfactual/promotion test.** Its sole remaining graduation requirement is the deliberately information-separated **fresh-AI handoff**; the current learner instance must not self-certify as fresh. S02 therefore remains graduation-pending rather than falsely marked `GRADUATED`.

The highest-priority currently executable dependency is **E20 — hm2_eth / HostMot2 watchdog recovery across versions**, state `EXPERIMENT`. Source/community/version-delta work, call-flow documentation, experiment freeze, implementation and non-authoritative preflight validation are complete. A separate independent authoritative execution is now running.

F02 remains blocked by completion/acceptance of S02, E20 and X02. X02 remains dependent on X01.

## Blind external-feedback state

- BL-DEV-001 VALID 10/10; BL-DEV-002 VALID 9/10; BL-DEV-002-TRANSFER-01 VALID 10/10.
- Delayed retention and the end-of-1000 sealed benchmark remain information-separated obligations. Do not inspect evaluator-hidden answers from the learner role merely to satisfy cadence.

## D01 closure

Authoritative workflow `34375315740`, job `102546527680`, artifact `10113726545` passed unchanged frozen Gates A–J. Retained evidence had 2,200 contiguous atomic samples with zero producer overruns and demonstrated low hidden duplicate disagreement, high duplicate-only following-error trip, principal-looking Cartesian feedback, and bounded global motion disable.

`results/D01-006-authoritative-evidence-and-exam.md` records Gates **10/10 PASS** and adversarial exam **20/20 PASS**. D01 did not justify promoting H30/custom FPGA-driver-distributed-realtime work to 3000.

## S02 technical closure / handoff pending

Pinned source baseline: LinuxCNC `8bf4605ae81042248add031e94c77300406e0413`.

Authoritative workflow **`34395556653`**, job **`102614270967`**, artifact **`10121464851`**, source commit `1a916e7ea4fb567d9606e6d46767031ca09163ad`, exact job runtime 2026-09-09T19:31:25Z–19:34:37Z = **3.2 min**.

`results/S02-004-authoritative-gate-reconciliation.md` independently inspected the retained artifact: **1,400 contiguous samples (0..1399), zero sampler overruns, Gates A–J 10/10 PASS**. `results/S02-005-adversarial-exam-grade.md`: frozen exam **20/20 PASS**. `results/S02-006-counterfactual-promotion.md`: no 3000 promotion; H30 remains a candidate. Fresh-AI handoff remains required.

## E20 active evidence

Durable artifacts include `guides/E20-hm2-eth-watchdog-recovery-version-matrix.md`, `call-flows/E20-hm2-eth-soft-error-watchdog-recovery.md`, frozen `experiments/E20-001-transport-watchdog-recovery-boundaries.md`, preflight `lab-jobs/025-e20-transport-watchdog-preflight.sh`, authoritative wrapper `lab-jobs/026-e20-authoritative-transport-watchdog.sh`, `results/E20-001-preflight-reconciliation.md`, and frozen ungraded `evaluation/E20-adversarial-exam-draft.md`.

### Source/version findings

Historical source at commit `554fa0f3cc3ec05cf9a70ef077cdebb32b23e004` (2015-10-10) materially differs from current 2.9.x: queued reads used a fixed ~200 ms receive loop and the inspected path lacked the later packet-error accumulator/decay/`io_error` threshold state machine.

Current **v2.9.10** has the later soft-error model: `record_soft_error()` sets `needs_soft_reset`, current packet error and cumulative/level evidence; reaching `packet-error-limit` asserts `io_error` / exceeded. Clean confirmed cycles call `decrement_soft_error()`, so a clean current cycle can coexist with nonzero accumulated history. Driver recovery is not machine motion authorization.

HostMot2 watchdog state remains a separate authority mechanism. A watchdog bite can disconnect physical I/O pins while internal FPGA module state continues, so internal activity cannot prove physical output-pin activity or machine-state validity.

### E20-001 frozen experiment and preflight result

The deterministic no-hardware model was frozen before implementation against v2.9.10/current-lineage distinctions using `limit=10`, increment `2`, decrement `1` and a 1 ms realtime sampler. Frozen P0–P8 and Gates A–J remain unchanged.

Preflight workflow **`34397554426`**, job **`102620888697`**, artifact **`10122285082`** completed successfully. `results/E20-001-preflight-reconciliation.md` independently inspected the retained artifact rather than trusting workflow status: **1,100 contiguous samples, zero producer sampler overruns, empty collector stderr**, complete retained component/HAL/topology/provenance, and all intended P1–P8 runtime discriminators present. It is classified **NON-AUTHORITATIVE PREFLIGHT PASS**; Gates A–J remain unscored by that run.

The P6 boundary was explicitly rechecked in retained component source: `needs_soft_reset` is the driver/board-recovery latch and is intentionally cleared during modeled P6 recovery, while `state_revalidated` remains a separate false machine-authority signal until P7. Transport/driver recovery therefore does not smuggle in machine revalidation.

`evaluation/E20-adversarial-exam-draft.md` is now **FROZEN / UNGRADED** before authoritative-result review.

Independent authoritative job `lab-jobs/026-e20-authoritative-transport-watchdog.sh` preserves the already-preflighted numeric contract, component logic, HAL topology, P0–P8 and assertions while changing only run/evidence classification labels and work-directory names. Workflow **`34399792261`** is currently **RUNNING**. Do not launch a duplicate.

## Exact next-work checkpoint

1. Inspect only authoritative workflow **`34399792261`**; do not launch a duplicate while it is running.
2. If it completes successfully, download its artifact and independently inspect actual retained evidence: fixture identity, atomic tag continuity, zero producer overruns, retained P1–P8 discriminators, topology/provenance and evidence completeness. Workflow success alone does not score a gate.
3. Score unchanged frozen Gates A–J only from the independently retained authoritative artifact.
4. Then execute and grade the already-frozen `evaluation/E20-adversarial-exam-draft.md`; do not alter questions/traps after seeing the authoritative result.
5. If authoritative evidence or the exam fails, classify the defect and follow the correction/three-attempt rules without retuning the frozen experiment to fit observations.
6. If E20 reaches technical acceptance, complete the required fresh-AI handoff and counterfactual promotion test without self-certifying information-separated evidence.
7. Keep F02 blocked until S02's fresh handoff plus accepted E20 and X02 contracts are complete. Preserve delayed-retention/sealed-benchmark information separation.
