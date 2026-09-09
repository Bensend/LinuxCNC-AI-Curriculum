# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05** and **C01–C09** are **GRADUATED at 1000 level**. **D01 — coupled-control stability and tandem-joint authority is GRADUATED at 2000 level.** Highest-priority unblocked work is now **S02 — feedback integrity, diversity and common-cause reasoning**, state `RESEARCH`.

## Blind external-feedback state

- BL-DEV-001 VALID 10/10; BL-DEV-002 VALID 9/10; BL-DEV-002-TRANSFER-01 VALID 10/10.
- Delayed retention remains separate. Preserve end-of-1000 sealed-benchmark information separation.

## D01 closure

Frozen experiment: `results/D01-002-frozen-runtime-experiment.md`.

Authoritative workflow `34375315740`, job `102546527680`, artifact `10113726545` passed unchanged frozen Gates A–J. Independent artifact inspection found the 2,200-row atomic trace, nonempty observer patch, pinned LinuxCNC SHA, INI/HAL, topology/thread order, LinuxCNC logs, collector state and producer recorder-health evidence. Sample tags were contiguous 0–2199 and producer overruns were zero. The retained trace reproduced the low hidden disagreement (`0.020 < 0.050`), high duplicate-only trip (`0.200`), principal-looking Cartesian Y, and bounded global motion-disable consequence.

`results/D01-006-authoritative-evidence-and-exam.md` records gate scoring, the frozen adversarial exam, counterfactual and promotion test. Gates: **10/10 PASS**. Frozen adversarial exam: **20/20**, no predeclared conceptual/safety trap accepted. No corrective teaching loop was required.

Accepted D01 boundary: duplicated-coordinate command agreement and principal-looking Cartesian feedback do not prove duplicate-joint agreement or physical tandem geometry. Joint-level following-error authority can revoke ordinary global motion while Cartesian feedback remains principal-looking. D01 does not establish physical geometry authentication, sensor diversity/common-cause integrity, actuator stopping performance, or functional-safety authority. The result is version-pinned where source/update-order details matter.

D01 did **not** justify promotion of custom FPGA/driver/distributed-realtime work to 3000. H30 remains only a candidate.

## S02 activation

D01 directly exposes S02 as the next prerequisite: independently available software feedback channels can still share a common cause, become stale/frozen, or agree while physical truth is wrong. S02 must distinguish detectable differential disagreement from undetectable-with-current-evidence common-mode error and must define explicit validity/freshness semantics before F02 can use feedback state in compound-fault sequencing.

### Exact next-work checkpoint

1. Inventory D01/C-series claims that currently treat feedback as evidence of achieved state.
2. Research pinned LinuxCNC feedback validity/freshness surfaces plus encoder/HostMot2 failure semantics; separate generic controller facts from hardware/version-specific behavior.
3. Add community/source analysis for encoder disconnect, stale/frozen counts, index/latch/error behavior and common-cause mechanical/sensor cases.
4. Freeze the S02 adversarial model **before implementation**. It must include at least: (a) ordinary differential disagreement, (b) one stale/frozen channel, and (c) a common-cause case where both software feedback channels agree while physical geometry is wrong.
5. Define which cases software-only evidence can detect and which require independent physical diversity or commissioning evidence. Do not claim functional-safety coverage.
6. Keep F02 blocked until S02, E20 and X02 establish accepted contracts. Preserve delayed-retention and sealed-benchmark obligations.
