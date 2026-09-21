# 25E0 — Stopping-Time Physical Endpoint and Safeguard Revalidation

Date: 2026-09-21
Status: supporting commissioning evidence

## Why this matters

The heterogeneous-witness method requires special care for stopping performance because a controller can accurately timestamp its own output transition while still failing to measure when hazardous physical motion actually ceased.

## Evidence

- **DOC-CONFIRMED — Pilz, ISO 13855 safety-distance guidance:** safeguard positioning depends on the protective-device reaction time and machine stopping performance. Current Pilz guidance for ISO 13855:2024 describes overall response time as a combination of safety-related device response, machine stopping time, and tolerance factor; when measured, Pilz states that the highest value from 10 measurements is used under that guidance.
- **DOC-CONFIRMED — Pilz stop-time measurement service (2026):** safeguard placement is based on real stopping performance, and stopping performance can change with brake wear, mechanical degradation, tooling/load/speed changes, or control faults.
- **DOC-CONFIRMED — Rockwell safety application technique SAFETY-AT122A-EN-P:** application stopping time is installation-specific; its example separates hazardous-motion stopping time from safety relay/contactor response and says actual stopping time is measured by the user or taken from machine-maker documentation.
- **DOC-CONFIRMED — Rockwell PowerFlex 755T guidance:** drive safety reaction time is defined from the safety-related input event to initiation of the configured stop type. This is not automatically the same endpoint as cessation of hazardous mechanical motion.

## Commissioning rule

Name the endpoints of every time value.

Do not write simply `stop time = 180 ms`. Write what event starts the clock and what physical or logical event stops it, for example:

- protective-field interruption -> safety controller output transition;
- safety input event -> drive begins configured stop;
- protective-field interruption -> measured hazardous ram/motor/tool motion reaches the machine-specific safe endpoint;
- valve command -> monitored spool reaches expected position;
- brake command -> brake-state feedback transition.

These are different measurements and cannot be substituted without an engineering argument.

## Physical endpoint rule

If safeguard separation depends on cessation of hazardous motion, the validation chain must ultimately include a measurement that witnesses the relevant physical motion endpoint with suitable accuracy. A PLC trace of `STO=true`, `valve_safe=true`, or `motion_command=0` is useful sequence evidence but is not by itself a physical stopping-time measurement.

## Revalidation triggers

Reassess stopping-performance evidence when changes can affect the chain, including braking components, mechanical load/inertia, tooling, speed, transmission, drive stop configuration, hydraulic/pneumatic behavior, protective-device response, safety communications, or control/final-element response. The applicable machine standard/risk assessment determines the required retest scope and acceptance limits.

## Freeze

- **LOGIC OUTPUT TRANSITION != HAZARDOUS MOTION STOPPED.**
- **DRIVE SAFETY REACTION TIME != TOTAL MACHINE STOPPING TIME unless the documented endpoints are actually equivalent for the claim.**
- **ONE HISTORICAL STOP-TIME RESULT != PERMANENT STOPPING PERFORMANCE.**
- **SAFEGUARD POSITION VALIDATION DEPENDS ON THE ACTUAL STOPPING-PERFORMANCE EVIDENCE REQUIRED BY THE APPLICABLE DESIGN/STANDARD.**

## OpenPressBrake boundary

Do not import example stopping times, measurement counts, approach speeds, tolerance factors, or separation distances into an actual press-brake design without the applicable standard edition and machine-specific authority. This artifact teaches evidence structure, not a numeric design value.