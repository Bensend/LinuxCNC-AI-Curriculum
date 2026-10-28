# 4400-LIM/POS-TRUST-01 — Limit recovery, lost reference and independent safety: composition matrix
**2026-10-28 | source-backed design review, not a motion procedure or scored exam**

## Why these two source traces must be combined
The [pinned v2.9.10 shared-limit audit](../research/4400_LIM_01_LINUXCNC_2910_SHARED_HARD_LIMIT_OVERRIDE_DIRECTION_AND_STATUS_SCOPE_SOURCE_AUDIT_2026-10-28.md) shows that ordinary limit override may mask **all tripped** limit bits, cannot determine safe direction when a shared signal asserts both signs, and publishes a global any-override flag through joint-looking status pins. The [pinned v2.9.10 volatile-home audit](../research/4400_POS_TRUST_01_LINUXCNC_2910_VOLATILE_HOME_ESTOP_AND_PHYSICAL_REFERENCE_BOUNDARY_SOURCE_AUDIT_2026-10-28.md) shows that OFF/E-stop requests conditional software unhoming for flagged joints, with an all-or-none precheck. Neither ordinary LinuxCNC function is an independent personnel-protective safety function.

A builder trying to clear a hard-limit trip immediately after power loss or E-stop can encounter **both** an ambiguous escape direction and an untrusted position reference. The operator must not be forced to defeat a guard or guess direction to recover.

## Responsibility boundaries
| Layer | Legitimate role | Never infer |
|---|---|---|
| Normal LinuxCNC / HAL / HMI | Jog/homing requests, position coordinates, limit flags, `overrideLimitMask`, `homed` indication, diagnostics. | Safe access, safe direction from shared switch, physical ram holding, or personnel-safety reset. |
| Independent safety controller / safety inputs | Evaluate selected E-stop, guard, enabling/setup and reset safety functions; withdraw/allow selected safety outputs as designed. | That output status alone proves physical motion stopped or pressure absent. |
| Physical final elements and energy control | Independently justified valve/contact/brake/restraint and maintenance isolation; selected hazard-specific safe state. | A generic “solenoid off” or “pump off” guarantees gravity holding. |
| Qualified human/physical witness | Match actual as-built revision, machine mode, access geometry, load/energy paths, stop/hold/escape/restart evidence. | A public LinuxCNC example applies to OpenPressBrake without an installed-device match. |

## Paper-only negative-path composition review
| Case | Ordinary control observation / source premise | Independent safety / physical proposition to prove | Default decision and usability improvement |
|---|---|---|---|
| 1. Power restored; `homed=1`; gravity axis may have shifted | A nonvolatile joint may retain its software flag after OFF. | Actual position retention and load holding, protective state and clearance. | **HOLD** automatic motion. Make a no-exposure reference check easy and visible. |
| 2. E-stop during movement; `VOLATILE_HOME=1` | Task requests `-2`; unhome core has moving/homing early-return checks. | Independent stop/hold and reference state after fault; do not trust timing assumptions. | **HOLD** restart until qualified evidence; clearly label reference UNKNOWN if unresolved. |
| 3. Shared +/− limit asserted | `joint_jog_ok` cannot infer safe escape direction. | Physical location/obstruction, hard-stop margin, personnel exclusion. | **HOLD** routine override. Provide a marked inspection/repair route instead of a blind jog. |
| 4. Distinct + limit asserted | Ordinary source rejects farther + jog; - may pass local check. | Actual direction mapping, stopping/holding, guard and load condition. | Direction-aware software is **not** safe-to-move authority. |
| 5. `halui.joint.1.override-limits=1` while another joint tripped | Task sets per-joint boolean from global any-mask. | Which actual joint and direction are affected, and independent safety condition. | Do not use a per-joint green lamp as proof. Show “some override active / scope unverified.” |
| 6. `HOME_IGNORE_LIMITS=YES` with wrong-side start | Homing can ignore that joint's limit and manual warns of crash. | Home geometry, sensor meaning, travel envelope and independent stop. | **HOLD** uncontrolled homing; redesign reference path for inspectability. |
| 7. `HOME_ABSOLUTE_ENCODER=2` returns homed without final move | Software may set reference and finish without moving. | Actual encoder validity/coupling, gravity load holding, safe access. | No physical safety claim from a successful homing flag. |
| 8. Guard reinstalled after service; reset pressed | Ordinary software may show ready or homed. | Guard coverage, no one in zone, independent reset and **new** start demand. | Reset must not itself start hazardous motion; make reset sightline usable. |
| 9. Tooling/fixture change alters reachable crush zone | Limit and homed flags can remain unchanged. | New hazard/guard geometry, tooling retention and stop/hold requirement. | Trigger documented change review rather than retaining stale approval. |
| 10. Machine enters maintenance with drive off | LinuxCNC OFF and `VOLATILE_HOME` may change software state. | Electrical/hydraulic stored-energy isolation, positive gravity restraint and zero-energy verification. | **No maintenance entry** from OFF/HOMED/UNHOMED alone. |
| 11. Input/wiring replaced with shared signal to save one I/O | A formerly distinct directional limit becomes ambiguous. | Fault detectability, safe recovery path and any independently required protective channel. | Treat as architecture change; often cheaper to keep separate input than to create recurrent bypass risk. |
| 12. After successful reference recovery, operator holds cycle-start | Normal `homed` or ready is not a fresh protective reset/clearance proof. | Independent rearm, occupancy, correct mode and deliberate **new** cycle command. | Do not auto-restart on recovered home/limit/guard state. |

## Minimum evidence bundle for a real machine (do not publish private wiring)
A qualified reviewer should identify the **actual** LinuxCNC version, INI/HAL limit and homing topology, selected encoder/drive reference behavior, physical end stops, independent safety controller configuration, Y1/Y2 or other final elements, gravity/pressure restraint, guard/occupancy coverage and the approved no-exposure verification method. Record evidence IDs, revisions, contradictory states and acceptance ownership in the existing restricted Stage A A–G process; do **not** add another owner questionnaire.

## Human factors and no-operation threshold
- Prefer separate directional inputs and unmistakable fault labels where feasible. The cost of one I/O channel can be lower than repeated unsafe recovery and lost productivity.
- Design a **safe stop/inspect/repair/requalify** path that is easier than defeating a guard, spoofing a switch or entering a crush zone.
- Do not substitute ordinary LinuxCNC `jog-inhibit`, `homed`, software E-stop, hard-limit, or an HMI indicator for independent safety authority.
- If stop/hold/guard/access/restart evidence is missing, **do not operate with people exposed**. Any future experimental operation requires separate qualified isolated/remote containment with people outside the danger zone and residual risk recorded.

**Evidence:** SOURCE-CONFIRMED and DOC-CONFIRMED for the pinned software/manual facts in the linked audits. **INFERENCE** for the general architecture and usability decisions. **TEST-CONFIRMED none; selected OpenPressBrake as-built UNKNOWN; G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.** No new test, simulation, physical operation, or external competency evaluation.

**Additional final-move negative path:** after a safe reference search, a configured `HOME_FINAL_VEL` may be absent; pinned `homing.c` then sets the final-move planner `max_vel` to the joint's velocity limit. Do not infer that the final phase inherits slow search/latch velocity. The independent setup/guard/stop/hold architecture must cover the **whole** homing sequence. No physical velocity or stopping distance was measured.
