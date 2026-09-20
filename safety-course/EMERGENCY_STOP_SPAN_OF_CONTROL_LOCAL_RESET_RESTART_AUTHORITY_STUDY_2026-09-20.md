# Emergency-Stop Span of Control, Local Reset, and Restart Authority Study

Date: 2026-09-20
Lane: independent safety curriculum Lane B

## Why this study exists

The primary safety lane is currently advancing CINCINNATI hydraulic check/safety-valve diagnostics and unmasked physical hydraulic proof. This study deliberately uses a different evidence family and different files: emergency-stop architecture across machines/sections, local reset, and restart authority.

The practical problem is easy to flatten into one `ESTOP_OK` bit. Professional machinery guidance instead separates at least: which hazards an actuator controls, whether every relevant actuator has been manually released, whether the emergency condition is actually resolved, whether safety reset/requalification is permitted, and whether a new ordinary start is intentional.

## Evidence labels

- `SOURCE-CONFIRMED`: direct standards text or authoritative source text inspected for this study.
- `DOC-CONFIRMED`: manufacturer/professional documentation inspected for this study.
- `TEST-CONFIRMED`: reproduced physical/executable test result. None in this study.
- `COMMUNITY-REPORTED`: community account not independently verified. None used for a safety claim here.
- `INFERENCE`: engineering conclusion derived from confirmed evidence but not itself quoted as a machine-specific fact.
- `UNKNOWN`: fact requiring the actual machine risk assessment, wiring, safety logic, measurements, or OEM documentation.

## Source evidence

### ISO 13850:2015 — emergency-stop function

`SOURCE-CONFIRMED`: accessible ISO 13850:2015 text states that emergency stop is available in all operating modes, overrides other functions/operations without impairing other protective functions, remains active until manually reset, prevents start commands from being effective on stopped operations while active, and requires intentional human reset. Reset does not itself initiate machine startup.

Source: ISO 13850:2015, clauses visible in the public standards preview: https://standards.iteh.ai/catalog/standards/iso/80e4fa3f-9014-4ecc-94c0-b1d2a90f71d0/iso-13850-2015

### IDEC — span of control

`DOC-CONFIRMED`: IDEC's ISO 13850 guidance explains that the default span is the whole machine, but more than one span can be justified where stopping everything would create additional hazards or unnecessarily affect production. It records the key conditions: spans must be clearly defined/identifiable; devices must be associated with the relevant hazard; the span must be identifiable at the actuator; one span must not create additional hazards or prevent emergency-stop initiation in another span; and information for use must document the span.

Source: IDEC, ISO 13850 guidance: https://www.idec.com/en-eu/solutions/safety/law/iso-iec/iso13850

### Pilz — reset at the device that initiated the command

`DOC-CONFIRMED`: Pilz answers a multi-machine reset question by stating that emergency stop is reset directly at the emergency-stop device that initiated the command, by intentional human action. It also says resetting the emergency-stop device only prepares the machine for restart and must not automatically restart it. Where the affected area cannot be fully checked from that position, the risk assessment may require additional reset/start arrangements.

Source: Pilz FAQ, "Emergency stop is operated on a machine": https://www.pilz.com/en-US/support/faq/standards/articles/180045

### SICK — emergency stop is complementary, and reset is local

`DOC-CONFIRMED`: SICK's 2026 *Guide for Safe Machinery* describes emergency stop as a complementary protective measure, requires it to take priority over other functions/commands, requires actuated devices to remain off until reset, and states that actuated emergency-stop devices are reset by hand locally. Reset only prepares the machine to be put back into operation.

Source: SICK, *Guide for Safe Machinery*, 8007988, 2026-05-11: https://www.sick.com/media/docs/8/78/678/Special_information_Guide_for_Safe_Machinery_en_IM0014678.PDF

## Architecture freeze

The curriculum shall preserve these boundaries:

**E-STOP ACTUATOR RELEASED != EMERGENCY CONDITION RESOLVED != AFFECTED SPAN VERIFIED SAFE != SAFETY RESET/REQUALIFICATION COMPLETE != FRESH START AUTHORITY.**

**ONE E-STOP DEVICE RESET != ALL DEVICES IN THE RELEVANT SPAN RESET != ALL RELEVANT SAFETY FUNCTIONS READY.**

**GLOBAL HMI `ESTOP_OK` DISPLAY != EACH PHYSICAL ACTUATOR RELEASED != SAFETY EVALUATOR HEALTHY != FINAL ELEMENT SAFE != PHYSICAL HAZARD SAFE.**

**SPAN A RESET != SPAN B RESET != PLANT-WIDE PRODUCTION AUTHORITY.**

**E-STOP RESET != START.**

`INFERENCE`: LinuxCNC/HAL/ordinary FPGA logic may display which emergency-stop device/span is active and may inhibit ordinary commands, but personnel-safety authority must remain in the independent safety architecture selected for the actual machine. An ordinary software `estop-reset` state must not be treated as proof that a physical actuator was intentionally released, the hazard was inspected, or the safety function has requalified.

## Why span of control matters

A single-machine retrofit can tempt the designer to wire every red mushroom into one undifferentiated chain and expose one bit to LinuxCNC. A multi-section machine/cell can tempt the opposite mistake: divide spans for convenience without proving that the division is safe.

The evidence supports neither shortcut as a universal rule. `UNKNOWN` until risk-assessed for the actual machine:

- whether OpenPressBrake needs one span or more than one;
- which hazards/final elements each actuator must affect;
- whether auxiliary functions must remain energized to avoid a worse hazard;
- whether any neighboring machine/section exists in the same emergency-stop architecture;
- whether reset location provides adequate view of the affected zone;
- whether additional personnel-clear/reset controls are required;
- stop category, response time, stopping distance, PL/SIL/category/DC/CCF;
- hydraulic, electrical, pneumatic, or mechanical final-element behavior.

Do not infer any of these from generic ISO 13850 guidance.

## Failure-path analysis

### 1. Wrong span assignment

Actuator E1 is physically beside hazard H1 but only stops a different or incomplete set of hazardous functions.

Required question: can the operator identify what E1 actually stops at the operating position, and does that span cover the hazard for which E1 would reasonably be used?

A green `ESTOP_OK` elsewhere does not answer this.

### 2. Cross-span coupling creates a new hazard

Stopping span A changes support, braking, transfer, pressure, clamping, extraction, or another dependency in span B.

Required question: does actuating any span create/increase a hazard elsewhere or prevent another span's emergency-stop function from being initiated?

### 3. Remote/global reset masks the physical actuator state

An HMI or supervisory controller says `reset`, but the initiating physical actuator has not been intentionally released locally.

Expected curriculum disposition: do not accept the ordinary reset command as equivalent evidence. Verify the actual emergency-stop device/evaluator behavior.

### 4. Reset becomes restart

A latched actuator is released and motion resumes because an ordinary START/CYCLE/JOG request remained asserted or was retained across the safety interruption.

Expected architecture: reset/release may restore readiness only. Hazardous motion requires the machine's separate, deliberate, fresh production/motion initiation sequence.

### 5. Multiple actuators, one still active

E1 and E2 are both actuated. E1 is released. A simplistic HMI or ordinary control path incorrectly considers the emergency condition cleared.

Expected challenge: safety authority remains inhibited until the relevant physical devices and safety logic meet the defined requalification conditions. Do not assume the exact circuit; test the installed architecture.

### 6. Power cycle while E-stop is actuated or ordinary start remains asserted

Power loss/restoration must not turn a previously asserted ordinary command into fresh hazardous-motion authority. Emergency-stop state and the machine's cold-start/restart policy must be challenged together.

### 7. E-stop used as routine safeguarding

Emergency stop is complementary. A successful E-stop test does not prove guards, interlocks, ESPE, two-hand control, safe motion, maintenance isolation, gravity retention, or other primary risk-reduction measures.

## Commissioning / validation worksheet

For each emergency-stop actuator, record rather than assume:

1. physical actuator identity/location;
2. intended hazard(s) and documented span of control;
3. safety input/evaluator channel identity;
4. final elements expected to respond;
5. physical hazardous-state witness appropriate to the claim;
6. effect on every neighboring span/dependent function;
7. indication presented to the operator;
8. local/manual actuator reset behavior;
9. behavior if a second actuator remains active;
10. behavior if START/CYCLE/JOG remains asserted through the demand;
11. behavior through power loss/restoration;
12. whether reset alone can cause any hazardous motion;
13. separate fresh-start behavior after safety readiness;
14. failed-test disposition and OUT OF SERVICE state until corrected;
15. revalidation after actuator, wiring, evaluator, final-element, safety configuration, or span-of-control changes.

### Question-driven tests

- Actuate each E-stop independently: does the documented span actually stop the claimed hazards?
- Where multiple spans exist, actuate each while the other span is operating under an approved safe test setup: is the boundary correct and free of newly created hazards?
- Actuate two devices, then release only one: does safety authority remain appropriately inhibited?
- Hold an ordinary START/CYCLE/JOG request through E-stop release/reset: can stale ordinary state create motion without a new deliberate start?
- Restore power with an E-stop still actuated; then with it released under the defined procedure: is the cold-start state conservative and explicit?
- After replacement/re-wiring/configuration change, repeat the physical span and final-element proof rather than checking only an HMI bit.

These tests require an approved machine-specific safe test method before execution. This document does not authorize live testing on OpenPressBrake.

## Evidence matrix

| Claim | Evidence status |
|---|---|
| E-stop reset must not itself initiate startup | SOURCE-CONFIRMED / DOC-CONFIRMED |
| Multiple spans of control can exist subject to defined conditions | SOURCE-CONFIRMED via ISO-derived manufacturer guidance / DOC-CONFIRMED |
| Span must be identifiable and associated with the hazard | DOC-CONFIRMED |
| Initiating E-stop device requires intentional local/manual release/reset | DOC-CONFIRMED |
| Emergency stop is complementary, not a substitute for primary safeguarding | SOURCE-CONFIRMED / DOC-CONFIRMED |
| OpenPressBrake needs multiple spans | UNKNOWN |
| OpenPressBrake E-stop final-element topology | UNKNOWN |
| OpenPressBrake stop category/performance | UNKNOWN |
| OpenPressBrake reset/start sequence | UNKNOWN |
| Any physical OpenPressBrake E-stop test has passed | UNKNOWN; no test performed |

## No compute justified

No simulation, synthesis, benchmark, or executable test can establish the missing machine-specific span, physical final-element response, stopping performance, or reset-location adequacy. No GitHub-hosted runner was used. The self-hosted runner is unnecessary for this documentation/source-tracing task.

## Precise next Lane-B checkpoint

Seek a professional complete machine/cell implementation that exposes:

`physical E-stop actuator -> explicitly documented span of control -> independent safety evaluator -> actual electrical/hydraulic/mechanical final elements -> physical hazard-state witness -> second-device/cross-span challenge -> local release/reset -> personnel/area-clear decision where applicable -> safety requalification -> stale ordinary-command challenge -> separate fresh production start`.

Prefer an OEM or integrator document with more than one emergency-stop span and an actual commissioning/fault procedure, especially a case showing why stopping the whole system would create a secondary hazard or why a span boundary was chosen.