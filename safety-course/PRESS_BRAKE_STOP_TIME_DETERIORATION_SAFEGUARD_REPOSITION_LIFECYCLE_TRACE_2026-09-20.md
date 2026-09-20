# Press-Brake Stop-Time Deterioration, Safeguard Reposition, and Lifecycle Trace

Date: 2026-09-20
Active curriculum: 4000 safety course

## Question

Can the generic stop-time/safeguard-distance lifecycle be tied to an actual hydraulic press-brake control/safeguarding implementation, including what must happen when stopping performance deteriorates?

## Authoritative manufacturer/integrator evidence

### Rockford Systems — RHPS hydraulic press-brake control manual

Source: Rockford Systems, `INSTALLATION MANUAL FOR RHPS CONTROL SYSTEMS ON HYDRAULIC PRESS BRAKES`, KSL278.
Official source: https://rockfordsystems.com/wp-content/uploads/RHPS-Control-Systems-On-Hydraulic-Press-Brakes_KSL278.pdf
Evidence classification: `DOC-CONFIRMED`.

The RHPS manual states that total press-brake stopping time for two-hand control includes the control-system response plus the time required for ram motion to cease. It identifies stop time of the press from the final de-energized control element, control-system reaction time, two-hand/interface reaction time, and stopping-performance-monitor allowance as contributors to the safety-distance calculation. It states that the press stop signal should be applied on the downstroke at a point producing the longest stopping time.

Most importantly for lifecycle acceptance, the manual explicitly states that when the press stroke stop command changes because the machine is taking longer to stop, the safety distance should be recalculated, and the safeguarding device should be moved to a greater safety distance when stopping time/distance has increased.

This is a press-brake-specific physical lifecycle chain:

**PRESS BRAKE STOP PERFORMANCE DETERIORATES -> STOPPING TIME/DISTANCE INCREASES -> SAFETY DISTANCE RECALCULATED -> SAFEGUARD PHYSICAL LOCATION REASSESSED/MOVED OUTWARD AS REQUIRED.**

The same manual states that a failure affecting a safety-related function must not prevent a normal stop or must cause an immediate stop, and re-initiation of the press brake is prevented until the failure is corrected or the system/device is manually reset. Repetitive manual reset in the presence of a failure is not to be used for production operation.

This provides a separate failure-disposition boundary:

**FAULT PRESENT -> REPEATED RESET != ACCEPTABLE PRODUCTION WORKAROUND.**

### Rockford Systems — stop-time measurement lifecycle service guidance

Source: Rockford Systems, `Safety in Numbers: Stop Time Measurements` and current `Press Brake Stop-Time Measurement Testing for Machine Safety` service guidance.
Official sources:
- https://rockfordsystems.com/safety-articles/safety-in-numbers-stop-time-measurements/
- https://rockfordsystems.com/machine-safeguarding/service/stop-time-measurement/
Evidence classification: `DOC-CONFIRMED`.

Rockford identifies reciprocating machinery including hydraulic presses and press brakes as primary stop-time-measurement applications. It describes periodic validation because maintenance, brake wear, and alterations can increase stopping time; if the machine stops more slowly than at commissioning, components need adjustment so safeguarding remains correctly placed. Its current guidance recommends regular testing, including after preventive maintenance, and specifically identifies brake wear and stopping-distance concerns as detectable through stop-time measurement.

This closes a practical lifecycle trigger that generic commissioning-only evidence does not:

**PREVENTIVE MAINTENANCE / WEAR / ALTERATION != OLD STOP-TIME EVIDENCE AUTOMATICALLY VALID.**

## Durable freezes

**PRESS BRAKE SAFETY DISTANCE VALIDATED ONCE != VALID AFTER STOPPING PERFORMANCE DETERIORATES.**

**STOPPING TIME INCREASED != EXISTING SAFEGUARD POSITION STILL ACCEPTABLE.**

**CONTROL/SENSOR REPORTS STOP != RAM PHYSICALLY STOPPED WITHIN THE VALIDATED TIME.**

**FAILURE RESETTABLE != FAILURE ACCEPTABLE FOR PRODUCTION.**

**PREVENTIVE MAINTENANCE COMPLETE != SAFETY PERFORMANCE REVALIDATED WHEN THE MAINTENANCE CAN AFFECT STOPPING PERFORMANCE.**

**SAFETY DISTANCE RECALCULATED != SAFEGUARD PHYSICALLY REPOSITIONED/VERIFIED.**

## Return-to-service acceptance ladder

The combined manufacturer evidence supports the following reusable `INFERENCE` for a press-brake return-to-service package when work can affect stopping performance:

1. identify the change/wear/repair and why it can affect stop performance;
2. place the machine in a controlled commissioning/test condition;
3. exercise the actual safety stop path under the machine condition that produces the applicable worst stopping case; do not invent that condition if the OEM/risk assessment has not established it;
4. physically measure stopping performance with suitable instrumentation;
5. preserve repeated measurements and governing worst-case disposition required by the applicable method;
6. recalculate required safeguard distance using the applicable current method and all required response/geometry terms;
7. compare against the actual installed safeguard boundary/location;
8. if stopping performance has increased enough to invalidate placement, correct the machine and/or move the safeguard outward as the governing design permits;
9. physically verify the corrected installed distance/field and safety-function response;
10. do not use repeated reset to mask a persistent safety-related fault;
11. only after affected evidence is re-established may the independent safety system be rearmed and a fresh ordinary production start be accepted.

Steps 1-11 as a single workflow are `INFERENCE`; the underlying stop-time/distance deterioration and reset/fault statements are `DOC-CONFIRMED`.

## What remains UNKNOWN

The located RHPS manual does not provide an OpenPressBrake-specific stopping time, ram speed, hydraulic delay, safe distance, stopping-performance-monitor threshold, required measurement interval, tooling/load condition, or pass/fail number. None is imported here.

The located evidence also does not expose one single OEM checklist containing the entire sequence `specific component replacement -> repeated physical measurement -> failed-test lockout -> repair -> remeasurement -> signed production release`. That exact all-in-one witness remains `UNKNOWN`, although the press-brake-specific deterioration/reposition link is now documented.

## OpenPressBrake boundary

LinuxCNC and the normal FPGA may record ram command/state, timestamps, cycle condition, and mirrored safety status for diagnostic provenance. They do not get authority to declare the physical stopping test passed or to silently waive a changed safeguard-distance requirement.

A future OpenPressBrake commissioning UI should make stale evidence visible rather than convenient to ignore: if a declared maintenance/change event invalidates stop-time evidence, the UI can show `STOP-TIME REVALIDATION REQUIRED`, but independent safety authority and physical validation remain separate.

## Information-gain status

The specific gap `press brake stopping deterioration -> recalculate/reposition safeguard` is now materially closed at `DOC-CONFIRMED` level. Do not repeat generic stop-time formula searches.

Highest-value next work: seek a manufacturer integrated setup/service-mode acceptance sequence combining mode selection, enabling-device authority, safe-speed monitoring/physical challenge, abort behavior, exit from setup mode, safety rearm, and fresh production start; or another physical final-element acceptance witness not already covered. Reopen this branch only for a genuinely stronger complete return-to-service checklist or new press-brake OEM evidence.
