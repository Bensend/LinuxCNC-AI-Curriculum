# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05** and **C01–C09** are **GRADUATED at 1000 level**. **D01 — coupled-control stability and tandem-joint authority is GRADUATED at 2000 level.** Highest-priority unblocked work is **S02 — feedback integrity, diversity and common-cause reasoning**, state `EXPERIMENT` after source/call-flow analysis and experiment freeze.

## Blind external-feedback state

- BL-DEV-001 VALID 10/10; BL-DEV-002 VALID 9/10; BL-DEV-002-TRANSFER-01 VALID 10/10.
- Delayed retention remains separate. Preserve end-of-1000 sealed-benchmark information separation.

## D01 closure

Frozen experiment: `results/D01-002-frozen-runtime-experiment.md`.

Authoritative workflow `34375315740`, job `102546527680`, artifact `10113726545` passed unchanged frozen Gates A–J. Independent artifact inspection found the 2,200-row atomic trace, nonempty observer patch, pinned LinuxCNC SHA, INI/HAL, topology/thread order, LinuxCNC logs, collector state and producer recorder-health evidence. Sample tags were contiguous 0–2199 and producer overruns were zero. The retained trace reproduced the low hidden disagreement (`0.020 < 0.050`), high duplicate-only trip (`0.200`), principal-looking Cartesian Y, and bounded global motion-disable consequence.

`results/D01-006-authoritative-evidence-and-exam.md` records gate scoring, the frozen adversarial exam, counterfactual and promotion test. Gates: **10/10 PASS**. Frozen adversarial exam: **20/20**, no predeclared conceptual/safety trap accepted. No corrective teaching loop was required.

Accepted D01 boundary: duplicated-coordinate command agreement and principal-looking Cartesian feedback do not prove duplicate-joint agreement or physical tandem geometry. Joint-level following-error authority can revoke ordinary global motion while Cartesian feedback remains principal-looking. D01 does not establish physical geometry authentication, sensor diversity/common-cause integrity, actuator stopping performance, or functional-safety authority. The result is version-pinned where source/update-order details matter.

D01 did **not** justify promotion of custom FPGA/driver/distributed-realtime work to 3000. H30 remains only a candidate.

## S02 active evidence

Pinned source baseline: LinuxCNC `8bf4605ae81042248add031e94c77300406e0413`.

`guides/S02-feedback-integrity-common-cause-research.md` and `call-flows/S02-feedback-transport-observability.md` now establish the key source boundary: hm2_eth transaction counters, response checks and packet-error surfaces can provide evidence about a current checked **board transport transaction**, but they do not prove per-encoder physical freshness, mechanical coupling, sensor independence or physical truth. HostMot2 watchdog state is a separate output/I/O authority mechanism and likewise is not a sensor-validity oracle.

The S02 experiment is now frozen before implementation. P0–P5 cover baseline, ordinary differential disagreement, one stale/frozen channel during modeled motion, stationary freshness ambiguity, common-mode false agreement, and a limited modeled quadrature diagnostic. Gates A–J require atomic evidence and force `UNKNOWN` where value-only evidence cannot establish sensor freshness. The common-mode phase requires both reported channels and transport to look clean while an explicitly synthetic physical oracle shows the physical state is wrong; the analysis must state that this oracle is laboratory-only and cannot be assumed in production.

### Exact next-work checkpoint

1. Implement the frozen S02 P0–P5/Gates A–J fixture without changing the model to fit results. Prefer a small deterministic realtime HAL component plus atomic sampler trace; synthetic physical truth must be explicit in signal names/artifacts.
2. Predeclare numeric thresholds, phase lengths and detection latency bounds before the first run. Preserve producer-side recorder-health evidence.
3. Run a non-authoritative preflight. Verify especially that P3 returns `UNKNOWN` for sensor freshness and P4 remains undetectable to the restricted detector using only reported A/B + transport health.
4. If preflight is valid, run an independent authoritative execution and score frozen Gates A–J from retained evidence.
5. Then freeze/execute the S02 adversarial exam, corrections if needed, fresh-AI handoff and counterfactual promotion test.
6. Keep F02 blocked until S02, E20 and X02 establish accepted contracts. Preserve delayed-retention and sealed-benchmark obligations.
