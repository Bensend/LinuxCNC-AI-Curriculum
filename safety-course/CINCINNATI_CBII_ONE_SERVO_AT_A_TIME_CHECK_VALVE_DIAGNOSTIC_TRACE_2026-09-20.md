# CINCINNATI CB II — One-Servo-at-a-Time Check-Valve Diagnostic Trace

Date: 2026-09-20

## Why this study exists

The active safety-course checkpoint asks for professional press-brake evidence showing how redundant hydraulic paths are tested without allowing a companion path to mask a failed element. The harder target remains a post-service, individual retaining/load proof for a named holding/safety valve. This study records a closely related OEM implementation that materially improves the test architecture while keeping its limits explicit.

## Source

Primary authoritative source:

- CINCINNATI INCORPORATED, *90–350 CB II Hydraulic Press Brake — Operation, Safety and Maintenance Manual*, EM-471 (N-02/01), for machines built after October 1, 2000. Official Cincinnati-hosted PDF: https://wwwassets.e-ci.com/PDF/Manuals/EM-471.pdf

Evidence classification in this study is `DOC-CONFIRMED` unless otherwise marked.

## OEM hydraulic architecture evidence

The manual identifies the main-manifold solenoids as separate right- and left-hand proportional valves, a pilot valve, a **safety dump valve**, a control valve for check valves, and a decompression valve. It also shows cylinder-side counterbalance/prefill/pilot-switching hardware and dedicated pressure-test ports.

The safety dump valve is not merely described as an ordinary process valve. CINCINNATI explicitly calls it a **safety valve** that prevents press down-motion when open and says it is connected to the palmbutton/footswitch operator-control path to provide redundant control of ram down motion.

## Position disagreement is actively monitored

A sensor reports dump-valve spool position. The control expects the sensor ON when the valve is closed. It also checks the opposite state: when the valve should be open, failure of the sensor to turn OFF can indicate that the valve is stuck closed.

This is important because a stuck-closed dump valve can be latent during ordinary operation: normal production motion may still appear to work. CINCINNATI therefore does not accept successful ordinary motion as proof that the redundant dump path is healthy.

Freeze:

**PRESS MOVES NORMALLY != SAFETY DUMP VALVE PROVED ABLE TO OPEN != REDUNDANT DOWN-MOTION INHIBIT HEALTHY.**

And:

**SOLENOID COMMAND != SPOOL POSITION SENSOR AGREEMENT != HYDRAULIC FLOW STATE PHYSICALLY PROVED != RAM MOTION/RETENTION PHYSICALLY PROVED.**

The first two states are directly documented; the latter separation is an engineering evidence boundary, not a claim that this manual supplies a physical-flow witness.

## OEM companion-path masking countermeasure

The strongest finding is the CB II's special SETUP-mode test. CINCINNATI says the control occasionally performs a special test in which **flow is provided by one servo valve at a time** to test the check valves associated with each side. If that test fails, the error identifies the side that failed.

This is a real press-brake implementation of a general validation rule:

**WHEN REDUNDANT/PARALLEL PATHS CAN MASK A FAULT, VALIDATION MAY HAVE TO EXERCISE ONE PATH AT A TIME.**

The significance is not that OpenPressBrake should copy the CB II sequence. The significance is that an OEM deliberately changes the hydraulic excitation during a diagnostic so a companion servo path cannot trivially make the check-valve test look healthy.

Freeze:

**AGGREGATE HYDRAULIC FUNCTION PASS != LEFT-SIDE CHECK PATH PROVED != RIGHT-SIDE CHECK PATH PROVED.**

**ONE-SERVO-AT-A-TIME DIAGNOSTIC PASS != STATIC LOAD-RETENTION PROOF != STOPPING-PERFORMANCE PROOF != PRODUCTION AUTHORITY.**

## Maintenance boundary

The same manual says reservoir- and cylinder-manifold hydraulic valves can be removed for service or replacement, and requires the ram blocked, machine power OFF, and electrical disconnect locked when servicing those valves.

That remains a service-isolation requirement, not post-service proof:

**RAM BLOCKED + POWER ISOLATED FOR SERVICE != REPLACEMENT VALVE FUNCTION PROVED AFTER REASSEMBLY.**

The accessible manual does not state that valve replacement automatically triggers the special one-servo-at-a-time test. It also does not state that the special test is a static load-retention test or give an allowable ram-drift/load-retention acceptance criterion. Those claims remain `UNKNOWN`.

## What this changes in the curriculum

The course should teach redundant hydraulic validation as an evidence matrix, not a single `HYDRAULICS OK` bit:

1. command/state disagreement monitoring;
2. individual-path exercise where another path could mask the fault;
3. physical final-element witness appropriate to the claimed property;
4. static load/retention proof when retention is safety-relevant;
5. dynamic stopping-performance proof when stopping distance/time is safety-relevant;
6. explicit fault disposition and requalification after service;
7. separate safety rearm and fresh ordinary production initiation.

A test can be excellent at one layer and still prove nothing at another.

## OpenPressBrake boundary

Do **not** transplant CB II valve identities, hydraulic truth tables, test timing, pressure values, or SETUP behavior into OpenPressBrake. The OpenPressBrake machine-specific hydraulic topology and required safety performance remain to be established from its own design and measurements.

The useful transferable design rule is narrower:

> If two hydraulic paths can conceal one another's failure, design commissioning/diagnostics so each safety-relevant path can be challenged without the companion path creating a false pass, and use a physical witness appropriate to the property being claimed.

## Remaining primary evidence gap

Still seek a press-brake OEM/manifold procedure that closes the full lifecycle:

`specific serviced holding/safety valve -> companion path controlled/disabled as required -> individual retaining/load challenge -> physical ram/load witness -> explicit acceptance/failure disposition -> any required dynamic stopping re-proof -> safety reset/rearm -> fresh production initiation`.

Specifically still `UNKNOWN`:

- whether CB II valve replacement invokes the special one-servo-at-a-time test;
- what event/cadence causes the manual's "occasionally" special test;
- whether Item 15 check-valve testing is intended as personnel-safety validation versus machine diagnostic integrity;
- whether there is a separate OEM static ram-retention test after check/dump/counterbalance valve service;
- whether a failed side can ever permit degraded operation (no such permission was found; do not infer it);
- whether and when the opposite side must be re-proved after service to one side.

## No lab required

No simulation or runtime test is justified by this finding. The unresolved questions are OEM/machine-specific documentation and physical validation questions; software simulation would not establish them.
