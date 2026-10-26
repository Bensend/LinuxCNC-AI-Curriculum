# SNEAK-CUR-02 field module — Open contact, unintended current
**PUBLIC PAPER ONLY / NON-GRADUATED. 10 scenarios UNSCORED, 10 documentary gates NOT RUN.** [Original OMRON source audit](../research/4400_SNEAK_CUR_02_OMRON_SAFETY_RELAY_LEAKAGE_SNEAK_CURRENT_AND_SUPPRESSOR_LOCATION_SOURCE_AUDIT_2026-10-26.md).

## Learner objective
Identify **a path for current** before claiming an open contact has isolated a coil. Trace supply, return, parallel indicator/suppressor and cross-feed through adjacent loads. Do not infer coil hold from high-impedance voltage alone, or physical safety from a PLC bit.

## Ten public paper cases — UNSCORED
1. Output contact opens, a CR snubber is across it. Can current still flow? What exact load/circuit evidence determines the consequence?
2. Two coils share an unusual series return after other contacts open. Trace the possible sneak path without inventing its magnitude.
3. A technician moves a suppression part from load terminals to contact terminals. Which prior safety proof becomes stale?
4. A diagnostic LED remains illuminated with output commanded OFF. Distinguish leakage, LED polarity, actual coil current and valve position.
5. A high-impedance meter shows residual voltage. Why is voltage alone insufficient to prove that a valve is energized?
6. A contactor NC feedback is healthy while a second power source feeds an actuator. What did feedback actually prove?
7. A failed suppression diode shorts. What fault containment, diagnostics and independent final elements need review?
8. A convenience indicator lamp is added across an output. Why is this an electrical safety-function change rather than cosmetic HMI work?
9. A shared return and 24 V pilot feed are routed through an ordinary FPGA board. What common-cause risk must be addressed without granting FPGA personnel-safety authority?
10. An operator holds the pedal during a power cycle; an unintended path clears after reboot. Why must restart require a new deliberate authorization?

Each answer must identify a concrete **current path hypothesis**, discriminating documentary/qualified witness, uncertainty, physical safe-state proposition, change control and no-operation HOLD criterion.

## Ten documentary gates — NOT RUN
| ID | Qualified evidence required | Status |
|---|---|---|
| SNEAK-CUR-V01 | As-built safety-output and coil supply/return schematic | NOT RUN |
| V02 | Exact snubber/LED/diode and wiring location | NOT RUN |
| V03 | Cross-feed/parallel-load and shared-return analysis | NOT RUN |
| V04 | Coil pickup/dropout characteristics and output leakage limits | NOT RUN |
| V05 | Qualified safe-output off-state fault behavior | NOT RUN |
| V06 | Contact weld and redundant final-element coverage | NOT RUN |
| V07 | Actual valve/contactor physical witness independent of HMI | NOT RUN |
| V08 | Maintenance isolation and hidden-energy check | NOT RUN |
| V09 | Power-return/held-command/fresh-start rearm proof plan | NOT RUN |
| V10 | Technician-friendly labeling, replacements, change control and validation | NOT RUN |

**No live energized probing or simulated machine acceptance test authorized.** If machine cannot meet a basic safe-to-operate threshold, keep personnel outside hazard zone; only separately controlled isolated/remote experiments. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.
