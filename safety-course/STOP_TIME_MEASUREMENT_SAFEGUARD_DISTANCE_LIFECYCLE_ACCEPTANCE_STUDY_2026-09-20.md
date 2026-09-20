# Stop-Time Measurement, Safeguard Distance, and Lifecycle Acceptance Study

Date: 2026-09-20
Active curriculum: 4000 safety course
Lane: independent safety curriculum B

## Question

What physical evidence is required to justify the distance between a presence-sensing safeguard and a hazardous movement, and what events require that evidence to be revisited?

This branch is deliberately independent of the primary lane's current SLS overspeed work. It addresses physical stopping performance as an input to safeguard placement, not safe-speed threshold monitoring.

## Authoritative manufacturer evidence

### Pilz — overrun measurement is physical/metrological evidence

Source: Pilz, `Overrun measurement`.
Official source: https://www.pilz.com/en-US/support/lexicon/articles/231033
Evidence classification: `DOC-CONFIRMED`.

Pilz defines overrun as the time and/or distance needed for hazardous movement to reach standstill after shutdown and states that total overrun time includes controller reaction plus mechanical stopping time. Its described measurement procedure uses a physical sensor/encoder, a measurement device, and an actuator/hand simulator that interrupts the safeguard while the application is at its highest speed. The procedure measures the resulting stop and repeats the test ten times; the worst result determines the minimum safety distance. Pilz then requires checking that the installed safeguard/scanner field distance actually corresponds to the measured result.

This provides a complete evidence chain:

**PROTECTIVE DEVICE TRIGGERED -> STOP INITIATED -> HAZARDOUS MOVEMENT PHYSICALLY OBSERVED -> STOP TIME/DISTANCE MEASURED -> WORST-CASE RESULT SELECTED -> REQUIRED DISTANCE DERIVED -> INSTALLED PHYSICAL DISTANCE VERIFIED.**

### SICK — stopping performance is a lifecycle quantity

Source: SICK, `Stop time measurement — Inspecting and determining the minimum distance`.
Official source: https://www.sick.com/media/docs/1/11/911/product_information_stop_time_measurement_en_im0077911.pdf
Evidence classification: `DOC-CONFIRMED`.

SICK states that a protective device provides sufficient protection only when the selected minimum distance ensures dangerous movement stops before the hazardous point throughout the machine life cycle. SICK identifies stop-time measurement before initial commissioning, after significant changes, and after expected usage-related changes such as brake wear. Its measurement is the interval between triggering the stop signal and cessation of dangerous machine movement, and the measured result is used to determine minimum distance.

This closes a major maintenance/revalidation gap:

**DISTANCE VALIDATED ONCE != DISTANCE VALID FOR LIFE.**

### Pilz — current ISO 13855:2024 calculation context

Source: Pilz, `EN ISO 13855 — Positioning of safeguards`.
Official source: https://www.pilz.com/en-GB/support/law-standards-norms/iso-standards/efficiency-guards/en-iso-13855
Evidence classification: `DOC-CONFIRMED`.

Pilz's current summary of ISO 13855:2024 describes safety distance as dependent on overall system response time and states that, when response time is measured, the highest value from ten measurements is used. It also identifies additional distance terms beyond response time. This is important because measured stopping time is an input to the placement decision, not the entire placement decision by itself.

## Durable architecture freezes

**SAFETY OUTPUT OFF != HAZARDOUS MOVEMENT PHYSICALLY STOPPED.**

**NOMINAL STOP TIME != MEASURED STOP TIME.**

**ONE STOP MEASUREMENT != WORST-CASE STOPPING PERFORMANCE.**

**MEASURED STOP TIME != REQUIRED SAFEGUARD DISTANCE BY ITSELF.**

**CALCULATED REQUIRED DISTANCE != INSTALLED PHYSICAL DISTANCE VERIFIED.**

**DISTANCE VALIDATED AT COMMISSIONING != DISTANCE VALID FOREVER.**

**BRAKE/DRIVE/HYDRAULIC/CONTROL CHANGE != PRIOR STOP-TIME EVIDENCE STILL VALID.**

## Practical acceptance worksheet

The exact machine-specific values remain `UNKNOWN` until measured or documented for that machine. A professional commissioning/return-to-service package should nevertheless preserve this evidence structure:

1. Identify the hazardous movement and the safeguard whose placement depends on stopping performance.
2. Identify the machine condition intended to produce the relevant worst stopping case; do not invent it from generic assumptions.
3. Identify safeguard/interface response-time contributions from authoritative device/configuration evidence.
4. Trigger the stop through the actual protective-device path rather than merely commanding a normal software stop.
5. Measure physical hazardous movement from protective-device actuation until cessation using suitable calibrated/traceable instrumentation.
6. Repeat enough trials for the governing method; for the cited Pilz/ISO 13855 context, preserve all ten and select the highest measured value.
7. Apply the applicable safeguard-positioning method, including all required approach/reach/geometry additions; do not treat stop time alone as the distance.
8. Measure the actual installed physical distance/field boundary to the hazard and compare it with the derived requirement.
9. Record machine state, tooling/load/speed/configuration and measurement setup sufficiently to make the result reproducible and auditable.
10. Define revalidation triggers. At minimum, significant machine/safety changes and deterioration mechanisms that can change stopping performance must not silently inherit old evidence.
11. After a relevant repair or modification, do not restore production merely because the controller reports `SAFE`, `READY`, `STO ACTIVE`, or similar. Re-establish the physical evidence affected by the change.

## Failure-path challenges

A validation plan should deliberately ask what happens when:

- one trial stops materially slower than the others;
- mechanical wear increases stopping time;
- a brake, drive, valve, contactor, controller, safety device, or relevant configuration is replaced or changed;
- machine speed/load/tooling changes the stopping condition;
- the protective device is physically moved;
- a scanner field is reconfigured without moving hardware;
- the stop signal changes correctly but hazardous movement does not stop as expected;
- the calculated requirement passes but the installed physical distance does not;
- historical stop-time evidence exists but its test configuration no longer matches the machine.

These are questions for evidence, not permission to invent thresholds.

## LinuxCNC / OpenPressBrake boundary

LinuxCNC and the normal FPGA can log commanded velocity, HAL states, timestamps, safety-status mirrors, or cycle context. Those are useful diagnostic provenance, but they are not substitutes for a validated physical stopping measurement where safeguard distance depends on actual hazardous movement.

For OpenPressBrake specifically, this study does **not** assign a stopping time, safety distance, approach speed, light-curtain location, ram speed, hydraulic response, or acceptance threshold. All such machine-specific values remain `UNKNOWN` until the actual safeguarding architecture and physical measurements exist.

A useful future implementation should keep these concepts separate in diagnostics:

- protective-device demand;
- independent safety-function response;
- final-element response;
- physical hazardous-motion cessation;
- measured stop time/distance;
- governing calculated minimum distance;
- actual installed distance;
- validation status and evidence date/configuration.

Do not collapse them into a generic `SAFE=true` indication.

## Provenance classes

- Manufacturer statements above: `DOC-CONFIRMED`.
- The reusable witness ladder and commissioning worksheet: `INFERENCE`, bounded by cited manufacturer procedures.
- Any future actual machine measurement: classify `TEST-CONFIRMED` only when the test record preserves setup, instrumentation, machine condition and result.
- Community examples may be `COMMUNITY-REPORTED` but cannot establish OpenPressBrake performance.
- Unmeasured OpenPressBrake stopping and distance values remain `UNKNOWN`.

## Information-gain status / next checkpoint

The generic physical stop-time-to-distance evidence chain is now materially established. Do not spend the next lane repeating generic safety-distance formulas.

Highest-value next evidence is a professional OEM/manufacturer return-to-service or periodic inspection procedure that connects a **specific machine change or wear condition -> repeated physical stop measurement -> worst-case disposition -> installed safeguard distance check -> failed-test lockout/correction -> successful revalidation -> production release**. Prefer a press/press-brake or other high-energy machine example, but do not infer press-brake values from another machine class.
