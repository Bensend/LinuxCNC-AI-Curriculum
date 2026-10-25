# 4400-CHUCK-01 — 14-gate no-energy retention, guard and change review
**DESK REVIEW ONLY | all selected gates UNKNOWN | no energization authorized**

| Gate | Inspectable question | State |
|---|---|---|
| 01 | Exact machine/chuck/actuator/jaw/fastener identities and service history? | UNKNOWN |
| 02 | Chuck maximum RPM distinguished from selected workpiece permissible RPM? | UNKNOWN |
| 03 | Special jaw mass, centroid, overhang and centrifugal effects reviewed? | UNKNOWN |
| 04 | Workpiece geometry/material/contact and cutting load approved? | UNKNOWN |
| 05 | Static force measured with qualified method/calibration? | UNKNOWN |
| 06 | Pressure sensing ports and isolated volumes mapped, not equated to jaw force? | UNKNOWN |
| 07 | Stroke switch target and fault behavior qualified? | UNKNOWN |
| 08 | Bolts, T-nuts, lubrication and collision inspection current? | UNKNOWN |
| 09 | Guard containment rated for credible workpiece/jaw ejection? | UNKNOWN |
| 10 | Entanglement, long bar, chip clearing and loading risks mapped? | UNKNOWN |
| 11 | Independent stop, coast, access release and restart safety functions reviewed? | UNKNOWN |
| 12 | Clamp energy isolated/verified for each maintenance task? | UNKNOWN |
| 13 | Jaw/part/pressure/speed changes mark affected evidence STALE? | UNKNOWN |
| 14 | Reset, guard closure and power return require fresh deliberate start? | UNKNOWN |

**Qualitative adversarial cut sets (INFERENCE):** pressure OK + lubrication loss; stroke OK + no jaw contact; nominal spindle speed + heavy special jaws; guard closed + inadequate impact class; spindle OFF + coast; reset + stale ordinary start; upstream gauge zero + trapped downstream pressure. These are NOT probability calculations or test results.

**Human-factors review:** observe unenergized loading and cleaning routines, ask which guards are bypassed and why, confirm easy guard reinstallation, practical jaw identification, convenient maintenance access and clear fault messages. Design away incentives to defeat protection. Prefer proven hardware and physical exclusion to clever normal-FPGA status logic.

**Decision:** G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 change/restart OPEN. No generic numerical acceptance criteria or selected-machine truth table.