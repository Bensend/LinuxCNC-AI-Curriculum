# 4400-CYCLE-01 — A green safety output is not a continuously proven final element
**Practical safety course | 2026-10-26 | NON-GRADUATED | documentary teaching, no machine test**

## Read first
[Exact-edition Pilz/SICK original manufacturer audit](../research/4400_PILZ_PNOZS3_ON_CYCLE_DIAGNOSTIC_START_FEEDBACK_NOTICE_AND_SICK_RESET_BOUNDARY_AUDIT_2026-10-26.md). Existing [EDM-01](4400_EDM_01_CONTACTOR_FEEDBACK_RESET_EDGE_AND_FRESH_MOTION_MODULE_2026-10-25.md) and [Rockwell reset-edge audit](../research/4400_MSR142_RESET_EDGE_POWERUP_FEEDBACK_WIRING_SOURCE_AUDIT_2026-10-24.md) already teach reset semantics; this module adds **time-since-last-diagnostic-demand** and **limited feedback-loop coverage**.

## Objective
A fresh engineer must distinguish (a) relay output status, (b) diagnostic exercise of relay contacts, (c) final-element mirror/NC feedback, (d) actual physical stopping/holding, and (e) maintenance isolation. They must be able to reject an unjustified claim of continuous proof from an ON LED, identify the exact OEM interval as product-specific, and plan a qualified **documentary-first** validation.

## Five propositions to keep separate
| Layer | What it can establish with appropriate evidence | What it cannot establish alone |
|---|---|---|
| ON status / diagnostic LED | indicated electrical control state | recently exercised opening, actual load restraint |
| Relay internal self-monitoring | selected internal failure detection under specified operating conditions | continuously tested contacts while ON, unless exact OEM proves it |
| EDM/mirror feedback | selected contactor auxiliary relationship when correctly wired and rated | all downstream hydraulic paths, gravity holding or zero pressure |
| Physical safe-state witness | measured stop/hold/isolation for selected task and machine | future reliability without maintenance/change control |
| Personal isolation and restraint | lockable verified energy isolation and positive load support for a service task | automatic restart safety in production |

## Practical scenario
A press-brake safety panel has shown green for weeks. The operator says, “It must be safe because the relay checks itself.” **Not established.** The Pilz PNOZ s3 manual 21395-EN-19 says internal checking of its mechanical relay opening needs an OFF/ON demand; it also gives product/application-specific check intervals. No evidence establishes this relay is fitted to the press brake, that its test regimen applies, or that its downstream hydraulic safety function is proven. A qualified reviewer first checks part/edition, safety function, as-built feedback, maintenance history and physical stopping/holding. A machine-wide test is designed only after energy hazards, guarding and test isolation are understood.

## Make the safer practice easier
Give maintainers a single labeled, approved **proof/verification schedule** linked to the exact device manual and machine risk assessment. Keep documentary evidence and service logs where technicians can find them. Make a qualified check procedure practical to schedule with production stopped and people excluded from hazards; do not encourage repeated live E-stop presses as an unreviewed substitute. Explain fault status in plain language; keep guards and positive supports quick to use correctly. A forgotten temporary jumper or bypass must be visible and independently checked out before release.

## Safe-state design rule
No safety reset, power restoration, input clear, LED, software watchdog, or LinuxCNC UI action may by itself cause a new hazardous cycle. Independent safety logic retains the veto; a fresh intentional ordinary start is required after verified safe rearm. Hydraulic and mechanical retention remain separately proven.

## Learner challenge (unscored)
A reviewer sees a PNOZ s3 21395-EN-19 on a parts list, an HMI green status and an annual maintenance checklist. Determine which conclusions are DOC-CONFIRMED, which are only inferred, and which require the **actual selected machine** and manufacturer manual edition. Explain why neither a monthly test copied from a catalog nor an HMI-driven “test pulse” is acceptable without a qualified safety-function design. No hidden answer key or self-score.

## Evidence and graduation
**DOC-CONFIRMED:** exact OEM internal test limitation, conditional check frequency, reset-location and subsystem scope. **INFERENCE:** architecture and human-factors practices. **UNKNOWN:** selected OpenPressBrake device, PL/SIL, actual test interval, contactor/hydraulic final elements, physical stop/hold and competency. **TEST-CONFIRMED:** none. G0/G1 HOLD; 2520–25F0 external evaluation and 4400 unseen evaluator not run. No machine test authorized.

## Uncertainty queue
- **CRITICAL, blocks machine release:** as-built independent Y1/Y2 stop, gravity hold, pressure zones and guards.
- **HIGH, blocks device-specific claims:** actual relay order code, edition, diagnostic schedule, external feedback and qualified maintenance plan.
- **HIGH, blocks course competency claim:** independent unseen transfer evaluation.
- **MEDIUM:** manufacturer clarification of PNOZ s3 p.9 versus p.10 start/feedback short-detection wording. Never guess a coverage number.

**Counterfactual:** even if the selected machine has no PNOZ s3, the layered-proof principle holds. Product-specific intervals and diagnostic assumptions do not transfer. The generic module is useful but not a selected-machine release.

## 2026-10-28 source-depth continuation — duty and contact history
The [PZE X4P/Rockwell original-OEM addendum](../research/4400_CYCLE_LIFE_01_PILZ_PZE_X4P_CONTACT_DUTY_AND_ROCKWELL_OPERATOR_B10D_SOURCE_DEPTH_2026-10-28.md) and [technician card](4400_CYCLE_LIFE_01_CONTACT_DUTY_IS_NOT_A_PERPETUAL_PL_FIELD_CARD_2026-10-28.md) extend the **existing** CYCLE-01 diagnostic-cadence lesson, not a new competency. PZE X4P manual 1003201-EN-14 gives exact load-dependent output service-life graphs, a manufacturer example for 0.2 A AC15 inductive switching, a 20-year TM under specified conditions, and a prohibition on moving contacts previously used for high-current switching to low-current duty. Its monthly/yearly check conditions corroborate the *existing* PNOZ s3 lesson but are **product-specific**, not universal. Keep the contact-duty register and proof schedule separate from ordinary LinuxCNC cycle telemetry and from independent physical stop/hold validation. **No installed PZE, machine test or evaluator score is asserted.**

## 2026-10-28 coil-decay timing supplement — distinct from duty and proof cadence
The [COIL-DECAY-01 original OEM/source audit](../research/4400_COIL_DECAY_01_SUPPRESSION_DROPOUT_TIME_VS_CONTACT_LIFE_SOURCE_AUDIT_2026-10-28.md) and [short technician card](4400_COIL_DECAY_01_QUIET_CONTACTOR_CAN_BE_SLOW_FIELD_CARD_2026-10-28.md) add a **separate stop-time mechanism**: certain Schneider diode coil suppressors prolong external contactor drop-out relative to an unsuppressed coil, while Pilz recommends flywheel suppression to protect some safety-relay output contacts. An eventual EDM/NC transition does not establish a qualified response-time limit. Confirm exact coil, built-in suppression, output stage, physical contacts and actual Y1/Y2 stopping/holding before changing a safety-related coil assembly. This is **DOC-CONFIRMED exact OEM / INFERENCE machine transfer**, not an installed-device timing measurement or a new CYCLE-01 exam; G0/G1 HOLD.
