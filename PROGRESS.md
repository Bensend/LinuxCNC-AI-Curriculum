# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05** and **C01–C09** are **GRADUATED at 1000 level**. **D01 — coupled-control stability and tandem-joint authority is GRADUATED at 2000 level.**

**S02 — feedback integrity, diversity and common-cause reasoning has completed its authoritative experiment, Gates A–J, frozen adversarial exam, and counterfactual/promotion test.** Its sole remaining graduation requirement is the deliberately information-separated **fresh-AI handoff**; the current learner instance must not self-certify as fresh. S02 therefore remains graduation-pending rather than falsely marked `GRADUATED`.

**E20 — hm2_eth / HostMot2 watchdog recovery across versions is now TECHNICALLY ACCEPTED at 2000 level and graduation-pending only its information-separated fresh-AI handoff.** Its independent authoritative retained-evidence experiment passed unchanged Gates A–J 10/10; its already-frozen adversarial exam passed 20/20; its counterfactual/promotion test found no present basis for 3000 promotion. The current learner must not self-certify the fresh handoff.

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

## E20 technical closure / handoff pending

Durable research artifacts include `guides/E20-hm2-eth-watchdog-recovery-version-matrix.md`, `call-flows/E20-hm2-eth-soft-error-watchdog-recovery.md`, frozen `experiments/E20-001-transport-watchdog-recovery-boundaries.md`, preflight `lab-jobs/025-e20-transport-watchdog-preflight.sh`, authoritative wrapper `lab-jobs/026-e20-authoritative-transport-watchdog.sh`, `results/E20-001-preflight-reconciliation.md`, and frozen `evaluation/E20-adversarial-exam-draft.md`.

### Source/version findings

Historical source at commit `554fa0f3cc3ec05cf9a70ef077cdebb32b23e004` (2015-10-10) materially differs from current 2.9.x: queued reads used a fixed ~200 ms receive loop and the inspected path lacked the later packet-error accumulator/decay/`io_error` threshold state machine.

Current v2.9.x source used by the module has the later soft-error model: `record_soft_error()` sets `needs_soft_reset`, current packet error and cumulative/level evidence; reaching `packet-error-limit` asserts `io_error` / exceeded. Clean confirmed cycles call `decrement_soft_error()`, so a clean current cycle can coexist with nonzero accumulated history. Driver recovery is not machine motion authorization.

HostMot2 watchdog state remains a separate authority mechanism. A watchdog bite can disconnect physical I/O pins while internal FPGA module state continues, so internal activity cannot prove physical output-pin activity or machine-state validity.

### E20-001 authoritative result

The deterministic no-hardware model remained frozen against current-lineage distinctions using packet-error `limit=10`, increment `2`, decrement `1`, 1 ms realtime sampling, P0–P8 and Gates A–J.

Preflight workflow **`34397554426`**, job **`102620888697`**, artifact **`10122285082`** was independently verified as a non-authoritative preflight pass: 1,100 contiguous samples, zero producer overruns, complete retained component/HAL/topology/provenance and all intended P1–P8 discriminators. Gates remained unscored by the preflight.

Independent authoritative workflow **`34399792261`**, job **`102628547104`**, artifact **`10123146331`** completed successfully. `results/E20-002-authoritative-evidence-and-gates.md` independently inspected the retained artifact rather than trusting workflow status: **1,100 contiguous atomic samples (0..1099), `sampler-overruns=0`, complete fixture/source/topology/provenance evidence, and frozen Gates A–J 10/10 PASS**.

Key retained discriminators include:

- P1: one soft error gives level exactly 2 and revokes authorization without saturated `io_error`;
- first P2 clean sample: current error false while historical level remains exactly 1 and authorization remains false;
- P3: five consecutive errors produce levels 2/4/6/8/10, with `io_error`/exceeded first asserting at the fifth;
- P4: driver error state clears while machine authorization remains false;
- P5: clean current transport and advancing internal module state coexist with watchdog bite / physical I/O authority false;
- P6: transport/driver/watchdog/physical-I/O conditions are restored while state revalidation is false and motion remains unauthorized;
- P7: explicit state revalidation + explicit reauthorization request are required before authorization becomes true;
- first P8 fresh fault revokes authorization in the same retained realtime sample.

`results/E20-003-adversarial-exam-grade.md` records the already-frozen adversarial exam **20/20 PASS**, accepting none of the clean-transport, watchdog-reset, torn-observation, recorder-loss, version-generalization, restart, or functional-safety traps. No correction cycle was triggered.

`results/E20-004-counterfactual-promotion.md` completes the promotion test. Exact physical Mesa output restoration timing, hardware-specific Ethernet recovery characterization and any future custom FPGA recovery protocol remain conditional advanced candidates; none can overturn the central 2000-level authority-separation teaching if they differ from present expectation, so E20 does not presently open a 3000 prerequisite.

`evaluation/E20-fresh-ai-handoff-packet.md` is **READY / NOT YET EVALUATED** and contains a novel scenario without a prepared solution. The current learner instance must not certify itself as fresh.

## Exact next-work checkpoint

1. Preserve E20 and S02 as **graduation-pending fresh-AI handoff** rather than self-certifying either from the current learner instance.
2. Run `evaluation/E20-fresh-ai-handoff-packet.md` through a genuinely fresh, information-separated AI evaluator. Record the evaluator identity/session, confirm it had no prepared answer, score the declared pass criteria, and incorporate any required corrections before marking E20 `GRADUATED`.
3. Likewise complete S02's genuinely fresh-AI handoff before marking S02 `GRADUATED`.
4. While those information-separated evaluations are unavailable, resume the highest-priority dependency that does not require falsely graduating S02/E20. X01 should be selected next if its declared prerequisites remain satisfied; X02 follows X01.
5. Keep F02 blocked until S02's fresh handoff, E20's fresh handoff, and accepted X02 contracts are complete. Preserve delayed-retention/sealed-benchmark information separation.
