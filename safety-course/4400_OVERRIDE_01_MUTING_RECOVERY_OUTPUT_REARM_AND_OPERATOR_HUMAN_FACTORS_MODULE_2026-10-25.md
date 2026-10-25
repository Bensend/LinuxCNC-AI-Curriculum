# 4400-OVERRIDE-01 — Recovery override is not a fresh safety authorization
**2026-10-25 | 4000 safety | NON-GRADUATED | paper/source lesson**

Read [direct SICK 2026 source audit](../research/4400_SICK_2026_MUTING_OVERRIDE_RESET_SHARED_CONTROL_AND_COUNTER_RESET_AUDIT_2026-10-25.md) after 2520 hazard/SRS, 2530 reset/restart, 2590 presence sensing, 4400-ESPE-02 blanking and 4400-TEACH-01 configuration-change review.

## Learning contract
Explain why **override-required -> override accepted -> OSSD ON -> downstream rearm -> fresh motion -> physical safe state** are separate propositions. An OEM recovery function may temporarily bypass field monitoring to clear material; it must not become a general machine operator's workaround for awkward guarding or a substitute for independent hydraulic holding.

## Exact-source distinctions
- **SICK deTec4 HG 8023856/1SWC/2026-02-05 pp.49–50:** an OEM muting override can make OSSDs ON after a fault; reset and override can share a configured control; a separate reset may not be required on exiting override when OSSDs remain active. These are **product-specific**, not claims about automatic press-brake motion.
- **Same OEM pp.49–50:** a consecutive-override counter can reset after an error-free cycle or startup. A counter limit cannot be used as a complete audit of bypass history.
- **Same OEM pp.68–70:** Smart Box Detection Override leaves the protective field unmonitored; its control requires outside-hazard location and visibility of the whole danger zone. The safety device may emit OSSD ON in override. The manual's material conveyor scenario is not a press-brake safety design.
- **Same OEM pp.49–51,69:** automatic field-width calibration under a blocked field can delay or defeat expected override termination; exact installed configuration and field-width conditions matter.

## Practical design and failure review
| Failure path | Human consequence | Safer design principle |
|---|---|---|
| Jam every few cycles; operators use override as routine | frequent exposure normalizes bypass | fix transport/fixture interference and allow tool-free safe access under isolation |
| Shared reset/override button with ambiguous labeling | technician assumes reset means stopped and safe | distinct status display and independent safety authorization; use qualified mode/role control |
| OSSD ON while a person remains behind curtain | possible hazardous reactivation | occupancy protection, clear-view recovery position, independent restart inhibit and fresh command |
| Counter resets on power-up | false assurance that no override occurred | independent maintenance/event log for diagnostics; never credit ordinary log as safety-rated control |
| Fault clears but hydraulic ram remains gravity-loaded | crushing hazard persists | independent physical load holding, isolation and mechanical restraints |
| Conveyor override logic reused on a press brake | different reach/stock and stopping geometry | new machine-specific SRS and qualified physical validation, no direct transfer |

## Technician decision exercise
For each recovery proposal, demand a documented hazard boundary, qualified manual/config revision, protective coverage while recovery is active, authorized operator location/visibility, reset/fresh command, actual final-element stop/hold and residual risk. Prefer a recovery path that is convenient **without** letting ordinary LinuxCNC control bypass personnel protection.

Use [12 public practice scenarios](4400_OVERRIDE_01_TWELVE_REARM_AND_BYPASS_INCENTIVE_PAPER_CASES_2026-10-25.md) as UNSCORED study material, not a blind test. No selected-machine physical evidence, evaluator score, PL/SIL or safe-to-operate conclusion exists. If the minimum safe-to-operate threshold is not demonstrated, no personnel-exposed operation; experimental motion only isolated/remote with people outside hazard and residual risk explicit.
