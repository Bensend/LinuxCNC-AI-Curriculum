# 25F0 — coverage audit and canonical learner route

## Contract audit

Audited against `research/25F0_MACHINE_SAFETY_CAPSTONE_CONTRACT_2026-09-23.md` and the current safety-course methodology.

| Required capstone capability | Durable coverage | Status |
|---|---|---|
| machine/lifecycle boundary | mill/VMC, lathe, robot/cell, press brake; plasma transfer | COVERED |
| hazardous energy/motion inventory | all capstones; process-energy delta added for plasma | COVERED |
| hazardous events / human exposure | machine-class artifacts + human-factors gates | COVERED |
| hierarchy before controls | capstone contract and inherited safety methodology | COVERED |
| plain-language safety functions / SRS | mill baseline, transfer matrices, press-brake matrix, plasma SRS skeleton | COVERED |
| physical safe-state propositions | explicit throughout; status-vs-physical-proof freezes | COVERED |
| authority allocation | LinuxCNC/FPGA vs monitoring vs independent safety vs final elements | COVERED |
| dependencies / CCF | robot/cell and press-brake work; PB-F11 explicit | COVERED |
| fault analysis | cross-machine adversarials; detailed press-brake SRS-linked matrix | COVERED |
| guarding / presence / human factors | mill/lathe/robot/press-brake plus inherited 25C0 method | COVERED |
| setup/recovery/maintenance/isolation | all major capstones; maintenance kept distinct from production safeguards | COVERED |
| SRS-derived validation with physical evidence | press-brake matrix is strongest worked example; method transfers | COVERED |
| proof-test/change reasoning | inherited 25E0 lifecycle method and capstone contract | COVERED |
| residual risk / UNKNOWN register | explicit in capstone artifacts | COVERED |
| safe-to-operate threshold | contract and machine-specific artifacts | COVERED |
| process-energy machine transfer | `25F0_PLASMA_CUTTING_SAFETY_TRANSFER_2026-09-24.md` | COVERED |

No material learner-facing 25F0 contract gap remains after the plasma/cutting safety delta. This does **not** reopen the graduated 3300 specialization.

## Press-brake physical-witness audit

`25F0_PRESS_BRAKE_SRS_VALIDATION_FAULT_MATRIX_2026-09-24.md` passes the physical-witness audit:

- PB-F01 requires ram/beam motion/position plus product-specific valve evidence and pressure/load-holding evidence where the SRS requires it.
- PB-F02 explicitly rejects the same valve feedback bit as independent physical proof.
- PB-F03 requires final-element state and ram/beam response, not channel diagnostics alone.
- PB-F04/F05 require physical beam/valve/pressure/holding observations and retain exact machine response as UNKNOWN.
- PB-F06 requires downstream final-element electrical state plus physical ram/beam cessation/holding.
- PB-F07 requires observation through restoration/rearm/start rather than a healthy boot/status screen.
- PB-F08 requires energy verification at the relevant trapped volume and restraint where required.
- PB-F09 requires actual restraint/holding and beam motion/position evidence.
- PB-F10 requires isolation/stored-energy/restraint evidence for maintenance.
- PB-F11 requires evidence matched to the shared dependency and physical response where safely testable.

No row credits ordinary LinuxCNC/HMI/controller status as proof of the physical safe state. Unsupported hydraulic truth tables, gravity behavior, pressure thresholds, stopping limits, diagnostic coverage, integrity targets and proof-test intervals remain UNKNOWN.

## Canonical learner route

A fresh learner should proceed in this order:

1. `research/25F0_MACHINE_SAFETY_CAPSTONE_CONTRACT_2026-09-23.md` — learn the mandatory cross-machine package and the rule against copying safety functions by name.
2. Mill/VMC baseline artifact(s) — establish the common template with spindle coast, access, axes, ATC and stored auxiliary energy.
3. Lathe/turning-center delta — learn workholding/ejection, rear bar-stock and support-retention differences.
4. Robot/automated-cell delta — learn protected-space occupancy, multi-person entry, manual/enabling behavior and coordinated peripheral hazards.
5. Press-brake boundary/professional architecture trace — learn gravity/stored-fluid/point-of-operation distinctions and professional separation of normal actuation from safety-related final elements.
6. `research/25F0_PRESS_BRAKE_SRS_VALIDATION_FAULT_MATRIX_2026-09-24.md` — practice SRS-linked fault validation where controller evidence can look healthy while the physical proposition fails.
7. `research/25F0_PLASMA_CUTTING_SAFETY_TRANSFER_2026-09-24.md` — prove transfer to process energy, fumes, fire, radiation, electrical and gas hazards without reopening manufacturing instruction.
8. Apply the complete method to a novel machine class. Preserve machine-specific facts as UNKNOWN unless evidence establishes them.

## Competency release gate

A fresh learner is ready for information-separated evaluation when it can:

- re-derive a machine's safety functions from hazardous events instead of copying an E-stop/STO/guard pattern;
- inventory electrical, mechanical, fluid, gravity, thermal/process and stored energy relevant to the actual machine;
- state the physical proposition each safety function must establish;
- allocate ordinary LinuxCNC/FPGA control, diagnostics, independent safety-related control and final physical elements without moving personnel-safety authority into normal control;
- find a shared dependency/CCF that defeats nominally independent channels;
- reject healthy controller, valve, drive, network or HMI status when it does not prove the physical proposition;
- distinguish production safeguarding from maintenance isolation/restraint;
- derive validation cases from SRS demands and identify an appropriate physical witness;
- reason about restart/rearm and power restoration without allowing unexpected hazardous motion/process initiation;
- preserve human-factors/defeat-pressure reasoning;
- refuse invented hydraulic truth tables, stopping values, pressure/speed thresholds, diagnostic coverage, PL/SIL/integrity targets and proof-test intervals;
- state the safe-to-operate threshold and require isolated/remote experimental operation when minimum attended-operation safeguards cannot be established.

## Release decision

25F0 is **READY FOR EXTERNAL/FRESH EVALUATION**, not self-graduated. The evaluator must remain information-separated from learner-readable expected answers. No executable compute is justified by the remaining gate.