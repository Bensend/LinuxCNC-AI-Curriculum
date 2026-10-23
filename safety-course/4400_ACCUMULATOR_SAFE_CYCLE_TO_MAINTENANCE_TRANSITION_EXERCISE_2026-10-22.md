# 4400 — Conceptual state-transition exercise: stored energy can help a safe cycle but still endanger maintenance

**Scope:** design-reasoning exercise only; no machine-specific control sequence or hydraulic truth table. Based on Parker HY10-1632-M2/US pp. 1 and 15, HAWE B 5488 pp. 4, 7–8, 17, 22, and OSHA 1910.147(d)(5)–(6). See companion source audit.

## Problem

A machine designer proposes a hydraulic accumulator so a selected protective function can finish a controlled motion if the electric pump supply fails. The maintenance team expects hydraulic pressure to be discharged and locked out before access. Both objectives can be legitimate, but **the same stored energy cannot be assumed both available for protective motion and absent for personnel access at the same time**. The architecture must distinguish those phases and prove the physical transition.

## Conceptual phases — not commands for an actual machine

| Abstract phase | Engineering obligation | Safety authority and physical evidence | Unsafe shortcut to reject |
|---|---|---|---|
| P0 — Normal operation | Determine whether stored energy is intentionally available; define hazards and energy paths. | SRS/PHY, exact accumulator and valve architecture, monitoring coverage. | `pump running` proves safe accumulator state. |
| P1 — Protective demand | Determine whether a controlled motion or immediate inhibition is required by the actual hazard. | Independent safety controller and selected physical final elements; not LinuxCNC alone. | Always dump all energy instantly, regardless of gravity/controlled-stop consequences. |
| P2 — Protective motion / stopping | Establish whether the required physical safe state has actually been reached. | Independent motion, restraint and relevant energy witnesses; machine-specific validation. | Valve position, pressure switch or software `stop complete` proves beam physically held. |
| P3 — Restricted stopped state | Prevent automatic hazardous restart; retain faults and unresolved energy conditions. | Safety-related restart inhibit; physical-state witnesses; residual risks visible. | E-stop reset implies safe personnel access. |
| P4 — Maintenance isolation | Apply the task-specific lockable energy controls, control residual pressure/gravity and verify. | Authorized worker's energy-control procedure and physical isolation/restraint proof. | Reuse P2 controller status as maintenance lockout proof. |
| P5 — Temporary powered diagnostic window (only if justified) | Follow separately authorized test/positioning controls with personnel cleared; afterwards re-establish isolation before servicing. | OSHA 1910.147(f)(1) where applicable; independent protections and controlled transitions. | Leave access exposed while production motion is enabled for convenience. |
| P6 — Restoration / qualified rearm | Restore guards, prove safe hardware/configuration, check personnel clear, reset safety state separately from ordinary start. | Current physical validation, independent safety reset and deliberate ordinary motion demand. | Automatically resume held motion command on power restoration. |

**This is a requirements/verification decomposition, not a prescription that any specific accumulator must retain or discharge pressure in a particular phase.** The installed architecture might have different protective actions, multiple accumulators, mechanical restraints, or no accumulator at all. Every such physical fact remains UNKNOWN until selected evidence.

## Five adversarial challenges

**A — Lost pump power:** An HMI reports `pump off` while the cylinder moves. Does this disprove an accumulator-assisted protective cycle or reveal a failure? Answer: neither without knowing the SRS and actual motion witness; determine intended physical proposition, direction, hazard exposure and selected circuit. No personnel-exposed operation while unresolved.

**B — Discharge output expected:** The safety controller reports a discharge-valve command, and one gauge reads low. Is service isolation established? No; command, final-element position, gauge tap and all relevant trapped zones require separate evidence.

**C — Shared pilot supply:** A common pilot supply fault can make two valves fail or behave together. Does two-channel electrical monitoring prove independent hydraulic control? No; assess `DEP`/CCF and the actual final elements.

**D — Power restoration:** A previously queued LinuxCNC move remains requested. Does restoring the independent safety permissive authorize it? No; reset/rearm and fresh deliberate ordinary start must remain distinct under the selected SRS.

**E — Tool-change shortcut:** A technician repeatedly removes a guard because the approved pressure test point is behind a bolted cover. What is the engineering correction? Redesign safe test access/labeling and guard restoration so correct verification is convenient, not merely punish bypass after the fact.

## Evaluation matrix for fresh AI

The learner must (1) identify the physical proposition for each phase, (2) preserve the independent safety/normal-control split, (3) distinguish controlled protective motion from maintenance isolation, (4) reject inferred numerical pressure/stop-time criteria, (5) preserve reaccumulation and gravity risks, (6) identify fault/common-cause and feedback contradictions, and (7) carry unresolved `UNK/RR` through `VAL/PT/CHG` to the next handoff. This exercise is learner-visible; it is not a sealed evaluator key or blind test result.

## Minimal cost-conscious architecture principle

Prefer clearly labeled, accessible and protected isolation/test points, documented energy-zone maps, proven independent safety control, mechanical restraint when justified, and simple fault indication that does not require bypass. Low-cost components can reduce risk, but a component label, a schematic and an HMI status cannot substitute for physical verification of the actual machine.
