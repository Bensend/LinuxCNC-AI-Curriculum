# Protective-field physical-boundary and machine-reaction commissioning study

Date: 2026-09-20
Course: 4000 safety / professional machine implementation

## Question

Can the current accessible-cell validation lane be strengthened from generic restart-interlock guidance into a manufacturer-directed physical commissioning test that challenges the configured protective field at multiple real locations and observes the actual machine response?

## Evidence

### SICK S200 commissioning

**DOC-CONFIRMED** — SICK S200 operating instructions, Commissioning chapter 8, require initial commissioning/check and release by qualified personnel and documentation of the result. Before machine release, the instructions require checking whether access to the hazardous area/hazard point is completely monitored. They then prescribe a recurring functional test in which an object is introduced at the protective-field boundary and the tester verifies that the OSSDs switch OFF; the test is to be performed along all protective-field boundaries.

Source: SICK, *S200 safety laser scanner operating instructions*, chapter 8, section 8.1 / test notes. Public manufacturer manual.

### Rockwell SafeZone whole-system protective test

**DOC-CONFIRMED** — Rockwell Automation's SafeZone Singlezone/Multizone manual prescribes deliberately interrupting the protective field while the machine is running. The scanner indication must change from green to red and the dangerous movement must stop. The test is repeated at different points in the hazardous area and on all scanners. A non-conformance requires immediate machine/system shutdown and examination by qualified safety personnel. For stationary applications, the manual also requires checking that floor-marked hazardous areas correspond to stored protective-field shapes and that gaps are covered by additional protective measures.

Source: Rockwell Automation Publication 442L-UM003C-EN-P, SafeZone Singlezone and Multizone Safety Laser Scanner User Manual, current indexed publication (February 2025).

### SICK microScan3 principal-function test

**DOC-CONFIRMED** — Current SICK microScan3 EtherNet/IP instructions require periodic documented thorough checks and recommend triggering the protective function and observing the safety output through the *reaction of the machine*. If a thorough check reveals an error, the machine is to be shut down immediately and mounting/electrical installation checked by qualified safety personnel.

Source: SICK microScan3 EtherNet/IP operating instructions, 8020200/1SK3/2025-07-04, project-planning/test-notes section.

### Restart remains separate

**DOC-CONFIRMED** — Rockwell SafeZone 3 instructions state that reset returns the protective device to monitoring/restart-ready state but must not itself introduce movement; machine start is permitted only after a separate start command. Reset is permitted only when safety functions/protective devices are functional. The same manual requires an object-free field for reset to restore the safety output.

Source: Rockwell Automation Publication 442L-UM008B-EN-P, August 2022.

## Evidence ladder gained

The manufacturer procedures establish a much stronger commissioning ladder than a configuration review alone:

`configured field -> physical field boundary -> deliberate intrusion at multiple locations -> scanner detects intrusion -> safety output changes -> actual dangerous machine movement stops -> repeat across area/devices -> disposition any nonconformance -> reset/restart separation`.

Freeze:

**CONFIGURED PROTECTIVE FIELD != PHYSICAL PROTECTIVE FIELD VERIFIED.**

**ONE INTRUSION POINT PASSED != ENTIRE REQUIRED BOUNDARY/AREA VERIFIED.**

**SCANNER INDICATES FIELD INTERRUPTION != DANGEROUS MACHINE MOVEMENT PHYSICALLY STOPPED.**

**FLOOR MARKING MATCHES FIELD != UNMONITORED GAPS ABSENT UNLESS GAPS/ADDITIONAL MEASURES ARE ALSO CHECKED.**

**PROTECTIVE FIELD CLEAR != RESET VALID != FRESH MACHINE START.**

## What this closes

The previous accessible-cell study had a derived adversarial commissioning script but lacked a manufacturer procedure that deliberately challenged multiple physical points while observing final machine behavior. Rockwell now supplies that physical challenge and machine-reaction witness. SICK independently supplies boundary-wide checking and machine-reaction observation.

This means the curriculum should no longer teach scanner commissioning as merely downloading a field and observing an OSSD/status bit. The physical geometry and downstream machine reaction must be challenged.

## What remains UNKNOWN / INFERENCE

The located procedures do **not** explicitly combine all of the following into one manufacturer acceptance script:

- a person deliberately standing in a scanner blind/stand-behind region after crossing the access field;
- an attempted reset while that retained person remains outside scanner coverage;
- a stale ordinary motion command already asserted before reset;
- explicit observation that this stale command cannot restart hazardous motion;
- a separate fresh production-start action after personnel-clear/requalification.

Therefore the complete retained-person + stale-command adversarial script remains **INFERENCE**, even though its component requirements are increasingly manufacturer-supported.

No OpenPressBrake field geometry, safety distance, scanner model, reset location, stopping time, PL/SIL/category, hydraulic safe state, or final-element topology is inferred here.

## Practical commissioning contract

For a future machine-specific validation plan, authoritative evidence now supports requiring at least:

1. compare configured protection geometry to the actual machine/hazard layout;
2. identify gaps, near-field blind areas and routes by which a person can leave the sensing field toward the hazard;
3. deliberately challenge the protective field at multiple physical locations/boundaries;
4. observe both protective-device state and the actual dangerous machine response;
5. repeat across every relevant scanner/protective zone;
6. treat any mismatch as a commissioning failure, not a warning to work around;
7. preserve reset as non-motion-producing and require separate ordinary start authority.

The exact test object, points, acceptance distances and stopping criteria remain device/application-specific and must come from the selected equipment, risk assessment and machine design.

## Human-factors consequence

A field that is difficult to test is easier to misconfigure unnoticed. Machine design should make the required protective boundaries visible, reachable for safe commissioning tests, and difficult to defeat accidentally. If an operator can step through the field and occupy an unmonitored hazardous location, the architecture must address that retained-person condition rather than relying on training to remember it.

## Compute

No simulation/build/test compute was justified. No GitHub-hosted runner or self-hosted runner was used.

## Next evidence target

One bounded search should now target an OEM/manufacturer **retained-person / stand-behind acceptance test** that explicitly challenges restart while a person/test body remains in an interior blind area. If no such procedure is found, mark that narrow source path information-gain limited and rotate to another safety branch rather than repeating scanner manuals.
