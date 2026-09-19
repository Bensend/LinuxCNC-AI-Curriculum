# Press-Brake Start-up Test Final-Element Coverage and Masking Audit — 2026-09-19

## Question

Does the existing Lazer Safe PCSS-A evidence prove that a serviced/replaced monitored hydraulic safety or holding valve receives an **individual, unmasked retaining-function proof** before production resumes?

## Result

**No. Keep that claim UNKNOWN.** The authoritative PCSS-A manuals provide strong evidence that start-up tests deliberately remove selected down-motion outputs and then measure actual beam stopping performance, but the exposed output groupings do not establish an individual static load-retention proof for every monitored hydraulic retaining element. In several configurations, multiple safety valves are switched as a group during a test. A successful machine stop therefore proves the configured stop chain met its measured stopping requirement; it does not by itself prove that each retaining element independently held the load without assistance from a companion element.

This is a useful narrowing, not a failure of the evidence.

## Evidence

### E1 — PCSS-A performs physical stopping tests before normal operation

**DOC-CONFIRMED — Lazer Safe PCSS-A Series Technical Manual v1.25, released 2024-09-12, §17.3.**

The PCSS-A normally performs two start-up tests to verify press-brake stopping performance. The tests deliberately initiate stops, record stopping distance/time, and prevent normal operation when stopping performance exceeds the configured limits. A failed test is repeated until it passes; after the second successful test, normal machine operation can begin.

This is physical beam-motion evidence, not merely a controller-state self-test.

### E2 — Start-up tests deliberately switch selected hydraulic-control outputs off

**DOC-CONFIRMED — PCSS-A Additions Technical Manual v1.18, released 2024-09-12.**

The down-enable option tables identify outputs intentionally switched off during the press-brake start-up tests. Examples include:

- Option 32: Test 1 removes Y1/Y2 Enable plus Safety Valve 1/2; Test 2 removes Y1/Y2 Enable plus Proportional Enable.
- Option 39: Test 1 removes Safety Valve 1/2; Test 2 removes Proportional Enable.
- Option 43: the same published table pattern removes Safety Valve 1/2 in Test 1 and Proportional Enable in Test 2.
- Other configurations use different groups such as high-speed, prefill, proportional-enable, quick-stop, or brake-set outputs.

The important engineering point is that test coverage is **configuration-specific**. The phrase “start-up test passed” does not identify which final elements were independently challenged unless the configured down-enable option and its test table are also known.

### E3 — Valve monitoring is individual switching-state evidence

**DOC-CONFIRMED — PCSS-A Additions Technical Manual v1.18, §7.**

Valve-monitoring options expose individual monitor inputs for safety, prefill, proportional and other configured valves. The fault tables treat command/monitor disagreement for any monitored valve as a valve fault. This is valuable final-element switching-state evidence.

However:

`INDIVIDUAL VALVE MONITOR AGREEMENT != INDIVIDUAL LOAD-RETENTION PROOF`.

A position/contact monitor can establish expected switching state; it does not establish that the valve seat, hydraulic path, cylinder, load or companion retaining path physically provides the required retention under the relevant load.

## Masking audit

For the configurations inspected here, the public tables do **not** establish a test in which each safety/holding valve is deliberately made the sole retaining element while its companion is positively removed from the proof path and physical ram/load retention is measured.

Therefore these claims remain **UNKNOWN**:

1. Every monitored safety/holding valve is statically proof-tested alone after service.
2. A companion retaining valve cannot mask leakage/failure of the valve under test.
3. Replacing any monitored hydraulic safety/holding valve automatically forces a particular PCSS start-up/stopping-test sequence.
4. A successful PCSS dynamic stopping test is accepted by the machine OEM as the complete post-replacement proof for a serviced retaining valve.
5. A failed B retaining element followed by B repair requires A to be re-proved, unless the specific OEM/service procedure says so.

## New curriculum freeze

`VALVE MONITOR PASS != START-UP TEST PASS != INDIVIDUAL RETAINING-ELEMENT PROOF != UNMASKED STATIC LOAD-RETENTION PROOF`.

And:

`TWO TESTS != TWO INDEPENDENT VALVE PROOFS` unless the actual configured test sequence demonstrates that each required retaining element is challenged independently with a physical witness capable of detecting its failure.

## Practical commissioning consequence

For a retrofit or service procedure, do not label a post-maintenance check “valve proof” merely because:

- the monitor contact changes correctly;
- Valve Zero becomes true;
- the PCSS start-up test passes; or
- the ram stops within its dynamic limit.

Those are distinct evidence layers. The machine-specific safety validation must identify what physical property is being proved and whether another element can hide the fault.

If an individual retaining function is safety-relevant and no authoritative machine procedure or engineered validation can prove it without masking, the conservative disposition is **no personnel exposure to the hazard / no production authority based on that unproven function**. Experimental work, if justified, belongs under isolation/remote conditions with people outside the danger zone.

## Source provenance

Primary sources:

- Lazer Safe, *PCSS-A Series Technical Manual*, LS-CS-M-046, v1.25, released 2024-09-12, especially §17.3 start-up/stopping tests.
- Lazer Safe, *PCSS-A Additions Technical Manual*, LS-CS-M-047, v1.18, released 2024-09-12, especially Down Enable option start-up-test tables and §7 valve monitoring.

No numerical stopping limit, hydraulic truth table, PL/SIL/DC value, pressure criterion, or OpenPressBrake-specific hydraulic behavior is transferred from these manuals.

## Next evidence target

Prefer a press-brake OEM/service manual or hydraulic safety-manifold manufacturer procedure that explicitly exposes:

`support/isolate/depressurize -> replace one retaining/safety valve -> challenge that element without companion masking -> physical ram/load-retention witness -> restore full hydraulic circuit -> dynamic stop-performance proof -> safety reset/rearm -> machine-specific production initiation`.

If no public same-machine procedure exists, preserve the gap and rotate to another safety branch rather than inventing a test.
