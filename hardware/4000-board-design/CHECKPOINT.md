# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-23

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD59 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run: `BD59_EVIDENCE_CONSUMPTION_LOCKS_RELEASE_MANIFESTS_AND_STALE_PROOF_REJECTION.md`.

BD59 teaches:

`current claims + promoted evidence/proofs -> release evidence manifest -> exact consumption locks -> generation/release candidate -> dependency drift -> stale-proof rejection -> targeted recovery -> release promotion`

## BD59 hard student-material audit

Every repository file named to students as finished material by BD59 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for bounded claims used:

- Curriculum `README.md`
- Curriculum `WORK_SELECTION_POLICY.md`
- Curriculum `hardware/4000-board-design/BD58_EQUIVALENCE_PROOF_LIFECYCLE_REVIEW_EXPIRATION_AND_ASSUMPTION_DRIFT.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/REV1_RESOURCE_CONTRACT.yaml`
- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/manifest.yaml`

`ENGINEERING_REVIEW_NEEDED` as complete current-status authority:

- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/STATUS_CHECKLIST.md` — the authoritative checklist's `Evidence currently present` section does not name the already-current `REV1_RESOURCE_CONTRACT.yaml`. Its bounded electrical/readiness statements remain useful, but complete current evidence discovery cannot be proven from the status surface alone. This is status/evidence-index drift under `STATUS_RULES.md` maintenance expectations.

BD59 itself was re-opened from current main after commit.

## Rules frozen by BD59

- current evidence existing in a repository does not prove a release candidate consumed it;
- generation success does not prove input authority was current;
- a release evidence manifest is a claim-to-evidence lock, not merely a file list or BOM;
- exact repository/object identity and semantic authority relationship must both be locked;
- consumption states are `LOCKED_CURRENT`, `LOCKED_CURRENT_NARROWED`, `STALE_REJECT`, `BLOCKED_UNKNOWN`, `SUPERSEDED_REJECT`, `HISTORICAL_ONLY_REJECT`, and justified `NOT_REQUIRED`;
- required claims without an unambiguous eligible evidence state fail closed;
- generated schematic/PCB/FPGA/HAL/commissioning artifacts should trace to the exact release evidence manifest they consumed;
- dependency heads/digests must be rechecked immediately before promotion to prevent lock/generate/review/promote races;
- stale rejection triggers minimum typed regeneration/revalidation rather than automatic whole-project reruns;
- rejected candidates and renewal lineage remain immutable history;
- reusable block authority remains separate from board-specific connection/resource authority; and
- ordinary-control release evidence receives zero personnel-safety credit without separate safety-rated authority.

## Worked-example stress test

Current OpenPressBrake `modbus_rtu_rs485/REV1_RESOURCE_CONTRACT.yaml` publishes one nonisolated physical RS-485 port per primitive instance. Each populated port consumes two FPGA outputs (`UART_TX`, `RS485_DE`), one FPGA input (`UART_RX`), one UART TX/RX/driver-enable logical resource set, one differential A/B pair, <=3.0 mA operational `3V3`, and 0.1 uF local decoupling. Board scaling is parameterized by `N`; the reusable primitive does not embed the first-machine port count.

The contract also keeps topology/termination/reference/shield/isolation facts honest: DE defaults inactive through the frozen 10-kOhm pull-down, 120-ohm termination remains DNP until physical bus-end evidence exists, external failsafe bias is not defaulted, shield is not casually bonded to logic return, RS485_COM/reference requirements must be checked, and galvanic isolation requires a separately engineered variant when justified.

Current `manifest.yaml` agrees on the selected THVD1450DR/SM712 nonisolated architecture, three FPGA GPIO signals, per-port <=3 mA `3V3` operating demand, 100-nF decoupling, DNP termination, and board-owned connector/shield decisions. A board release may consume those reusable facts while separately locking actual population, FPGA ball mapping, connector/pin mapping, physical placement, termination decision, shield/chassis implementation and machine destination.

The adversarial finding is that the authoritative RS-485 status checklist does not yet name the new resource contract in its evidence list. A release consumer following only the checklist can miss current evidence; a consumer scanning for newest filenames can consume unreviewed evidence. BD59 therefore requires explicit semantic consumption locks rather than either heuristic.

## Catalog stress-test result

Classification: **ENGINEERING_REVIEW_NEEDED** for a machine-readable release-evidence system supporting stable claim/facet/evidence/proof IDs, exact authority/configuration digests, lifecycle eligibility, reusable-block plus board-connection composition, `VERIFY_AT_MACHINE` blockers, release-candidate identities, generated-artifact/toolchain locks, forward consumption plus reverse Show Where Used, race-safe pre-promotion recheck, selective regeneration, and immutable rejection/renewal lineage.

OpenPressBrake remained read-only because the RS-485 integration/resource-contract area had just advanced on current main. The status/evidence-index drift was recorded rather than racing active engineering work.

## Current repository reconciliation

At run start the board-design lane ended at BD58. Curriculum main also contained concurrent non-board-design curriculum work and was preserved. OpenPressBrake had advanced beyond the BD58 checkpoint through shared-ADC power work and to the current RS-485 machine-readable resource handoff.

BD59 was committed as `a133109db109efd6593d9bfca54085b62fc11914` and re-opened from current main. Immediately before this checkpoint write, curriculum main was that BD59 commit and OpenPressBrake main was `defdb2a7813047c0727bbee044ce0a0cb89df99a` (`rs485: publish machine-readable Rev1 resource contract`). OpenPressBrake stayed read-only.

## Next exact work

Build BD60 on **release-manifest closure, candidate completeness, and cross-domain promotion gates**:

`required board claims -> claim coverage matrix -> block/connection/resource/evidence locks -> generated electrical + FPGA + LinuxCNC/HAL artifacts -> unresolved-fact closure -> cross-domain consistency gate -> candidate completeness decision -> release handoff`

Stress a complete-controller candidate where every individual block appears usable but one board connection, FPGA allocation, power aggregation, HAL mapping, or physical-machine fact lacks an eligible current evidence lock. Teach that release completeness is the closure of all required claims, not the average maturity of the component blocks.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was required for BD59. No GitHub-hosted compute was initiated.

## Safety boundary

BD59 teaches release evidence consumption for ordinary board-design/controller authority. It does not establish PL/SIL/category, stopping performance, independent safety diagnostic coverage, final-element validation, or personnel-safety authority. Ordinary LinuxCNC/FPGA evidence remains zero-credit for personnel safety unless separate safety-rated design and validation explicitly establishes otherwise.
