# 4400-ESPE-02 — Selected-machine optical blanking / restart / physical stop blank witness
**Status: EMPTY FIELD INTAKE / NOT PERFORMED / NOT APPROVAL.** Use only if the selected machine actually has a configurable optical protective device. If absent, mark device-specific fields **NOT APPLICABLE**, but still resolve point-of-operation and rear/side access protection.

## A. Identity, scope and change
- Machine, location, hazard and mode (restricted evidence pointer, no private schematic publication):
- Exact manufacturer/model/part/revision, safety manual edition, firmware/config ID/checksum:
- Current jurisdiction and applicable press-brake versus mechanical-power-press regulation/consensus edition:
- Sensor type: curtain / laser / scanner / other:
- Original commissioning reference and last qualified change record `CHG-*`:
- Who can change blanking and how access is controlled:
- Current evidence classification and known UNKNOWNs:

## B. Optical geometry and object semantics
| Mode / tooling / stock | Accessible side / approach | Physical resolution | Effective resolution **by zone** | Blanked zone bounds and type | Fixed/complete/partial object monitoring | Tolerance / expected absent-object behavior | Hard guard closing gap | Qualified evidence |
|---|---|---|---|---|---|---|---|---|
| | | | | | | | | |
| | | | | | | | | |

- Exact current sensing-plane to hazard geometry, including reach-over/under/around/through:
- Other access paths, pass-through/whole-body presence and restart inhibit:
- Actual object/fixture movement, removal, replacement, vibration, new tooling or workpiece whip-up:
- Why guard is easy to install/use; legitimate tasks that create incentive to defeat it:
- OEM configuration compatibility and prohibited feature combinations:

## C. Independent safety chain and physical proposition
| Requirement ID | Evidence / target | Status |
|---|---|---|
| `BND/ENE/HAZ` accessible dangerous motion and stored gravity/hydraulic energy | | UNKNOWN |
| `SF/SRS` protective field and fault response by mode | | UNKNOWN |
| `AUTH` safety-rated logic independent of LinuxCNC/FPGA | | UNKNOWN |
| `ARC/DEP` exact OSSD/safety-controller/final-element and shared supplies | | UNKNOWN |
| `PHY-STOP` actual qualified stop before hazard reach | | NOT RUN |
| `PHY-HOLD` independent Y1/Y2 gravity load/pressure safe-state | | NOT RUN |
| `PHY-ACCESS` side/rear/blanked hole and occupancy closure | | NOT RUN |
| `PHY-RESTART` deliberate reset/rearm/new ordinary start | | NOT RUN |
| `PHY-ENERGY` maintenance isolation/reaccumulation | | NOT RUN |
| `HF/CHG/RR/UNK` bypass incentives, change, residual risks | | OPEN |

## D. Physical validation plan — QUALIFIED / ISOLATED, NOT EXECUTED
| `VAL/PT` case | Test object / method per exact OEM (no person in hazard) | Required physical observation | Machine-specific acceptance criterion / source | Actual record/time | Status |
|---|---|---|---|---|---|
| Optical all protected sub-areas and edges | | | | | NOT RUN |
| Fixed object removed and substituted | | | | | NOT RUN |
| Floating complete versus partial object semantics | | | | | NOT RUN |
| Tooling/stock shifts and blanked-gap hard guard | | | | | NOT RUN |
| Effective-resolution test rod and separation review | | | | | NOT RUN |
| Mode switch / muting boundary / power restoration | | | | | NOT RUN |
| Actual independent physical stop / hold | | | | | NOT RUN |
| Retained start, deliberate reset and fresh command | | | | | NOT RUN |
| Rear/side/inside access and safe escape | | | | | NOT RUN |
| Maintenance isolation and gravity restraint | | | | | NOT RUN |

**No acceptance values are supplied by this worksheet.** A qualified machine-specific safety assessment must determine applicable current standards, test objects, distances, force/stopping thresholds, performance level and procedures. Do not use a person as the test target or introduce hazardous fault injection with exposed personnel.

## E. Gate decision
- Selected optical hardware exists? UNKNOWN / YES with evidence / NO-N/A
- Optical geometry and effective-resolution evidence: UNKNOWN
- Independent physical stop/hold/restart and energy isolation: NOT RUN
- External independent competency evaluation: NOT RUN
- `G0/G1 HOLD`; `G2 NOT RUN`; `G3/G4 NOT AUTHORIZED`; `G5 HOLD`.
- Safe-to-operate with people exposed: **NOT AUTHORIZED** pending the actual machine safety case.

Reference: [4400-ESPE-02](4400_ESPE_02_BLANKING_RESOLUTION_AND_PRESS_BRAKE_LATE_DETECTION_MODULE_2026-10-24.md), [OEM audit](../research/4400_SICK_C4000_BLANKING_OBJECT_MONITORING_EFFECTIVE_RESOLUTION_AUDIT_2026-10-24.md), [OSHA scope audit](../research/4400_OSHA_PRESS_BRAKE_VS_MECHANICAL_PRESS_LIGHT_CURTAIN_SCOPE_AND_LATE_DETECTION_AUDIT_2026-10-24.md).
