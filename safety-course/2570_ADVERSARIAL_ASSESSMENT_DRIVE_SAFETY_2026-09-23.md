# 2570 — Adversarial assessment: drive safety without label substitution

## Rules

Do not invent stopping times, brake torque, safe distances, PL/SIL, discharge time or undocumented drive behavior. Mark missing physical evidence `UNKNOWN` and state what would establish it.

For each scenario identify:
1. hazardous event;
2. physical safe-state proposition;
3. appropriate safety-function concept;
4. final element(s);
5. diagnostic witness and what it does not prove;
6. reset/restart behavior;
7. physical validation required;
8. LinuxCNC's allowed normal-control/diagnostic role versus independent safety authority.

## Scenario A — the green STO lamp

A large spindle VFD has certified STO. The guard-unlock PLC logic releases the door as soon as both STO channels report active. The spindle can visibly coast for an appreciable but unmeasured interval after STO.

Evaluate the architecture. Is `STO active` an adequate access-release proposition? Repair the reasoning without inventing a coast time. Compare at least two defensible architecture classes.

## Scenario B — vertical axis with SBC

A vertical servo axis has STO and Safe Brake Control. The integrator argues that STO plus SBC proves the suspended tooling cannot descend, so no brake-effect test or machine-level load validation is necessary.

Identify the category error. Explain what SBC establishes, what mechanical proposition remains unproved, and what evidence a brake-test/validation strategy would need.

## Scenario C — ordinary VFD retrofit

An older machine uses an ordinary VFD with no documented certified STO. A safety relay drops a single line-side contactor. The VFD's normal RUN command from LinuxCNC can remain asserted. There is no contactor feedback and nobody has documented DC-bus discharge behavior.

Do not merely say “add STO.” Develop a practical retrofit analysis. Address contactor selection and placement, welded-contact diagnostics, stored energy, retained RUN command, power restoration, reset versus restart, and the distinction between hazardous-motion control and maintenance isolation.

## Scenario D — misleading feedback

Two line contactors are drawn in series and their ordinary auxiliary contacts are wired into an EDM loop. A replacement contactor has the same coil voltage and current rating but its auxiliary contact is not documented as a mirror/force-guided relationship to the main poles.

Can the old EDM proposition simply be carried over? What evidence is missing? Explain why two contactors on a drawing do not automatically prove useful diagnostic independence.

## Scenario E — SS1 chosen by habit

A designer always chooses SS1 because a controlled stop “sounds safer” than STO. On one machine, continued powered deceleration after a certain fault could itself prolong exposure; on another, immediate torque removal creates a long dangerous coast.

Explain why neither STO nor SS1 is universally safer. Derive selection from the hazardous event and physical safe-state proposition rather than function prestige.

## Scenario F — maintenance confusion

An HMI shows `SOS ACTIVE`, and maintenance staff assume this means the drive is electrically safe to work on.

Explain the error. Distinguish safe monitored standstill, torque removal and electrical isolation.

## Critical failures

Any of the following is a critical assessment failure:
- treating STO status as proof of shaft standstill;
- treating STO/SOS as electrical isolation;
- treating SBC command as proof of mechanical brake effect;
- inventing machine stopping/brake/load numbers;
- claiming a contactor retrofit achieves a PL/SIL without complete evidence;
- allowing restoration/reset alone to restart hazardous motion;
- granting ordinary LinuxCNC/HAL personnel-safety authority without independent evidence.

## Transfer requirement

The learner must finish by producing one reusable decision rule that works for all six scenarios and preserves the chain:

`hazard -> physical safe-state proposition -> safety function -> final element -> diagnostic witness -> physical validation`.
