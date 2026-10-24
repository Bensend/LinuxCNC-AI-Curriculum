# 4400-VAC-01 — Vacuum gripping, suspended-load retention and CNC clamp-enable safety
**4000 safety curriculum | 2026-10-24 | RESEARCH / NOT GRADUATED | physical/evaluator NOT RUN**

## Placement
Cross-machine 2580 fluid-power, 2590 guarding, 2520 SRS, 2570 drive stop and 25E0 restart; extends 4400-ACC-02 by reversing the stored-energy question: a vacuum reservoir can delay loss of suction but does not establish indefinitely safe holding. This is not routine controller-board work.

## Objective and evidence
Read [direct original Schmalz FMP/VOL/VAGG OEM audit](../research/4400_SCHMALZ_VACUUM_LOAD_DROP_RESERVOIR_AND_CLAMP_ENABLE_OEM_AUDIT_2026-10-24.md). A fresh AI engineer must distinguish normal gripper control, reserve vacuum, monitored vacuum indication, machine-enable interlock, independent safety-related stopping, physical load retention and personnel exclusion. It must recognize that cutting power can **increase** falling-load risk and that a machine-enable output is not automatically a certified safety output.

## Architecture requirements (not an installed design)
| Layer | Responsibility | Must not claim |
|---|---|---|
| LinuxCNC / ordinary FPGA | Grip/transport/clamp command, status, logging, coordinated normal pause | Certified personnel safety, guaranteed retention or safe restart |
| Independent safety logic | Hazard-specific stop/access/retention/rearm function under machine SRS | Physical gripper force, vacuum at cup or load caught from software bit alone |
| Physical elements | Selected vacuum generator, reservoir, non-return, cups, secondary restraint, guards | Infinite hold time, immunity to seal loss or hose break |
| Physical machine | Actual suspended-load behavior, workpiece movement, tool energy and occupied zones | Safe-to-enter solely from a gauge or HMI |
| Authorized service | Isolation, support/setdown, verified stored energy and controlled restart | A pressure/vacuum switch as personal lockout |

## Failure paths and release gates
- FMP-S E-stop drops compressed air: **OEM documents possible load release**; safety function must address the resulting drop zone and physical retention rather than assuming 'dump all air' is always safe.
- VOL gauge plausible: a leak or open cup may still defeat retention; OEM's exact device leak check is not a machine-specific holding proof.
- VAGG machine-enable output interrupted: normal machine enable may be inhibited, but spindle inertia/tool energy/workpiece motion and personnel protection require separate evidence.
- Loss of vacuum at the *workpiece* while reservoir remains charged: place measurement/verification where the load is actually gripped.
- Restart after vacuum restoration: prohibit retained robot move/spindle command from resuming solely because a sensor recovers; deliberate new start and area-clear review.
- Human-factor nuisance alarm: redesign filter/cup access and status visibility rather than bypass.

## Non-blind training and physical gate
Complete [16 PAPER cases](4400_VACUUM_GRIP_AND_CLAMP_STOP_TECHNICIAN_CARD_2026-10-24.md). For a selected machine, qualified engineering must freeze a falsifiable stop/retention/guard/restart question, safe remote/isolated witness, and acceptance basis **before** any physical test. Do not intentionally drop loads or expose people as an educational experiment. No numerical vacuum threshold, retention duration, load rating or safety integrity is transferred from an unrelated OEM product.

**DOC-CONFIRMED:** exact Schmalz source statements. **INFERENCE:** authority/fault design. **UNKNOWN:** all selected machine installation, SRS and physical outcomes. **TEST-CONFIRMED:** none. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD** for selected unverified machine. No personnel-exposed operation.
