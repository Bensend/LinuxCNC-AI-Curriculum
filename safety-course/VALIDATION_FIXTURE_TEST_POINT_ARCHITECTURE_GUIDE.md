# Validation Fixture / Test-Point Architecture Guide

Date: 2026-09-16
Lane: Independent Safety Curriculum B
Status: DURABLE STUDY

## Purpose

Make correct proof testing easier than improvised jumpers, loose probes, software forces, or undocumented temporary wiring. This guide is architecture-focused. It does **not** assign machine-specific voltage/current ratings, hydraulic pressures, stopping limits, PL/SIL/category, proof-test intervals, or fixture ratings.

## Frozen rule

**A convenient test connection is not automatically a safe test connection, and a fixture that can create a test condition is not proof that the physical safety function responded correctly.**

A validation fixture should reduce human-error and defeat opportunities while preserving the distinction between:

`test request -> deliberate physical/electrical stimulus -> safety path under test -> independent observation -> bounded conclusion -> fixture removal -> production restoration challenge`

LinuxCNC/HAL and ordinary FPGA logic may request tests, collect diagnostics, identify fixtures, reject stale commands, and inhibit normal production control. They are not thereby personnel-safety authority.

## Evidence vocabulary

Use the repository provenance classes explicitly:

- **SOURCE-CONFIRMED** — directly supported by inspectable source/code/design material.
- **DOC-CONFIRMED** — directly supported by authoritative documentation/regulation/manual.
- **TEST-CONFIRMED** — demonstrated by a retained, configuration-bound test artifact.
- **COMMUNITY-REPORTED** — reported by practitioners but not independently established here.
- **INFERENCE** — engineering conclusion from identified evidence; assumptions must be visible.
- **UNKNOWN** — not established; do not silently promote it.

## Authoritative anchors

1. **DOC-CONFIRMED — OSHA 29 CFR 1910.334(c):** electrical test instruments, leads, cables, probes, and connectors are to be visually inspected before use; defective/damaged equipment is removed from service; test equipment/accessories must be rated for the circuits/equipment and environment where used. This supports treating the fixture, leads, connectors, and probes as controlled test equipment rather than incidental wiring.
   - https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.334
2. **DOC-CONFIRMED — OSHA 29 CFR 1910.333(b)(2)(iv):** verification of an electrically deenergized condition requires testing the circuit elements/equipment parts to which the worker will be exposed; it must also address induced/backfeed voltage. This is a strong warning against remote indicators or a fixture connection at the wrong observation boundary being treated as universal proof.
   - https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.333
3. **DOC-CONFIRMED — OSHA interpretation (2012-12-12):** an installed LED indication may be redundant information but does not replace required electrical test equipment; testing remotely from the actual exposed circuit generally does not satisfy the verification requirement. This reinforces the architectural difference between an indicator and an independent measurement point.
   - https://www.osha.gov/laws-regs/standardinterpretations/2012-12-12
4. **DOC-CONFIRMED — OSHA 1910.147(f)(1):** temporary re-energization for testing/positioning is a bounded transition: clear tools/materials, remove employees from the area, remove LOTO as specified, test/position, then deenergize and reapply energy-control measures before servicing continues. A fixture must not turn that bounded transition into a persistent bypass.
   - https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147
5. **DOC-CONFIRMED — Pilz test-pulse definition:** when wired appropriately, specific pulses applied through test-pulse outputs can detect shorts across contacts. This is an example of deliberate diagnostic stimulus with a defined detection target, not a claim that every pulse proves the entire physical safety function.
   - https://www.pilz.com/en-INT/support/lexicon/articles/072903

## Architecture goals

A good validation architecture should make the intended test path:

- obvious,
- keyed or otherwise difficult to mis-mate,
- bounded to the function actually under test,
- difficult to leave connected unnoticed,
- unable to silently become a permanent production bypass,
- observable independently where the claim requires it,
- configuration/calibration identifiable,
- easy to inventory and restore,
- and no more energetic or invasive than the test question requires.

The human-factors objective is practical: **the documented fixture should be easier and faster to use correctly than fabricating an improvised jumper.**

## Test-point placement rule

Place a test point according to the claim being tested, not merely according to where a signal is convenient to reach.

| Claim | Useful test boundary | What it does NOT prove by itself |
|---|---|---|
| Safety input logic recognizes OFF/open | input-side diagnostic point or controlled simulator | real switch actuation, actuator alignment, field wiring upstream, final-element response |
| Field wiring channel continuity/state | field-side point that includes intended cable/connectors | mechanical guard position, independent second channel, output isolation |
| Safety output logic removes command | safety output observation point | contactor/valve physically changed state |
| Contactor/relay changed state | independently derived auxiliary/physical witness appropriate to design | hazardous energy fully absent |
| Electrical circuit is deenergized for exposed work | actual relevant circuit elements/parts using appropriate test equipment | hydraulic, gravity, pneumatic or mechanical energy safe |
| Valve command changed | coil/current/electrical observation as justified | spool position, pressure state, ram motion or personnel safety |
| Motion stopped | independent physical motion observation appropriate to validation plan | stored energy cannot later create motion |

**INFERENCE:** a test connector located only on the controller side of a field cable can make an upstream cable break invisible. A second connector on the machine side may improve fault localization, but whether it is justified is design-specific.

## Energy and galvanic boundaries

Do not let the fixture accidentally bridge isolation or introduce an unreviewed energy source.

For every fixture interface document:

- which side supplies energy;
- whether the fixture is passive or active;
- all galvanic/isolation boundaries crossed;
- whether fixture earth/USB/bench-supply grounds can defeat isolation;
- whether an external supply can backfeed the machine;
- whether stored energy exists inside the fixture;
- what happens on fixture power loss, cable removal, connector partial insertion, or wrong sequencing;
- whether connecting the fixture changes the safety function even before a test is commanded.

A USB-connected laptop, oscilloscope, programmer, powered simulator, or grounded bench instrument must not be assumed electrically neutral merely because it is used for diagnostics.

## Passive versus active fixtures

### Passive fixture

Examples include breakouts, keyed loopback/open-circuit plugs, measurement adapters, or connector-access harnesses that do not generate their own command/energy.

Advantages:
- usually easier to understand and audit;
- fewer firmware/configuration states;
- easier removal accounting.

Risks:
- can still short channels, bridge isolation, misroute pins, load signals, or remain installed;
- a passive loopback can become a perfect persistent bypass if production operation is possible with it connected.

### Active fixture

Examples include controlled pulse generators, sensor simulators, isolated signal sources, or fault-insertion boxes.

Additional controls should address:
- fixture firmware/version identity;
- configuration identity;
- calibration where measurement accuracy matters;
- output default state on boot/reset/power loss;
- stale command rejection;
- maximum authority of each output;
- independent indication of what the fixture is physically driving;
- whether a failed fixture can create a more permissive condition than intended.

**INFERENCE:** active fixtures should default toward no test authority rather than reconstructing a prior active output after reboot, unless a separately justified test requirement establishes otherwise.

## Keying, identity, and mis-mating

A validation connector should be selected and wired so plausible mistakes fail obviously rather than creating a believable false-safe condition.

Review:

- mechanical keying/polarization;
- unique connector families or key positions for materially different functions;
- pin sequencing where partial insertion matters;
- physical labels that identify function and machine/location;
- no interchangeable plug that can connect an output to an unintended input or bridge two channels;
- fixture ID distinct from machine configuration ID;
- serialized or otherwise uniquely accountable fixtures where mix-up matters;
- explicit rejection of unknown/unrecognized active-fixture identity where software participates in the workflow.

A digital fixture ID is useful workflow evidence. It does **not** prove that the fixture is wired correctly, calibrated, undamaged, connected to the intended point, or physically removed afterward.

## Fault-insertion reach

For each planned fault injection, write down exactly which real path remains in the test.

Example:

`guard switch -> field cable -> safety input -> safety logic -> safety output -> final element -> hazardous motion`

If a fixture injects the simulated guard signal at the controller input, the real guard switch and upstream field cable are bypassed. The test may be valid for downstream logic, but it must not be recorded as a complete guard-function proof test.

Useful matrix fields:

| Test ID | Fixture connection | Stimulus | Real path bypassed | Real path exercised | Independent witness | Bounded conclusion |
|---|---|---|---|---|---|---|
| VF-01 | TBD | controlled channel open | TBD | TBD | TBD | TBD |

Do not fill `TBD` with invented OpenPressBrake machine facts.

## Independent observation

Avoid using the same fixture output as both the stimulus and the evidence that the stimulus happened.

Examples:

- fixture says `OUTPUT_OFF` = evidence about its command/state, not proof the field voltage/current changed;
- safety controller says `CONTACTOR_OFF` = evidence according to its sensing path, not automatically proof of energy isolation;
- LinuxCNC HMI says `SAFE` = display/ordinary-control evidence, not personnel-safety authority;
- test pulse generated and read back through one shared electronics path may detect specified faults but can retain common-cause blind spots.

Where the validation claim is physical, use an appropriately independent physical/electrical witness and preserve its provenance.

## Production-connection defeat resistance

Ask the adversarial question: **Can production run with the fixture, jumper, breakout, or simulator still connected?**

If yes, treat that as a latent defeat path requiring additional design/workflow control.

Possible generic controls, subject to actual risk/design assessment:

- physical connector arrangement that prevents normal production configuration while test fixture is inserted;
- removable test adapter whose absence is required to restore the normal field connector;
- conspicuous captive cover or production plug;
- fixture-present sensing used as an additional production inhibit (not as sole proof of removal);
- separate controlled storage/accounting;
- post-removal physical challenge of the affected safety function.

Do not rely solely on `fixture_present = false` from the same fixture being removed; loss of fixture communication can look identical.

## Calibration and configuration binding

When the fixture measures or generates values for which accuracy affects the conclusion, retain:

- fixture identity;
- hardware revision;
- firmware/configuration revision;
- calibration identity/status where applicable;
- machine configuration/signature/revision under test;
- connection location;
- test procedure revision;
- raw observations and transformations.

A valid calibration label cannot prove correct connection. A matching software configuration cannot prove the external fixture wiring. These are separate evidence dimensions.

## Storage and accounting

Fixtures that can defeat or simulate protective devices should not become anonymous shop jumpers.

Recommended architecture/process questions:

- Is each bypass-capable fixture identifiable?
- Is its normal storage location controlled/obvious?
- Can missing inventory be detected before production release?
- Are loose jumper wires prohibited where a dedicated fixture exists?
- Are damaged connectors/leads removed from service rather than repaired informally in the middle of a validation?
- Does the job record who installed and removed the fixture and which function was challenged afterward?

This is not security theater: the aim is to make forgotten temporary test hardware conspicuous.

## Failure-path analysis

### F1 — Wrong connector, electrically plausible result
A simulator fits two similar connectors and drives a valid-looking signal on the wrong circuit.

**Design response:** keying, labeling, unique pinout/connector strategy, connection-location evidence, and an independent response check.

### F2 — Fixture bridges an isolation boundary
Laptop/bench instrument earth or active fixture supply ties isolated machine domains together.

**Design response:** document galvanic boundaries and instrument grounding; use a measurement/stimulus architecture appropriate to the circuit rather than assuming isolation.

### F3 — Test passes while field device is bypassed
Signal injected downstream of the real switch/cable.

**Design response:** record bypassed path and bounded conclusion; perform a separate physical-device challenge where required.

### F4 — Fixture remains installed for production
A loopback or simulator continues to satisfy an input.

**Design response:** make normal production reconnection physically incompatible with leaving the bypass in place where practical; account for the fixture and challenge the restored physical function.

### F5 — Active fixture reboots permissive
Power cycle restores the last simulated safe state.

**Design response:** default to no test authority and require deliberate reauthorization unless a separately engineered requirement says otherwise.

### F6 — Fixture identity mistaken for fixture health
Software recognizes serial/ID and assumes wiring/calibration/condition are valid.

**Design response:** identity, inspection, configuration, calibration, connection and actual observed behavior remain separate evidence.

### F7 — Test point hides backfeed/wrong-circuit hazard
Remote indicator/test point reads deenergized while the actual exposed circuit is energized by another source.

**Design response:** for electrical deenergization, verify at the actual relevant circuit elements/parts with appropriate test equipment per applicable electrical work practice; remote convenience points are not universal substitutes.

### F8 — Fixture-present sensor fails false-negative
Machine believes test fixture is absent.

**Design response:** fixture-present detection may inhibit production but should not be the sole restoration proof; use physical restoration/accounting and post-restoration challenge.

## Commissioning worksheet

For each permanent test interface record:

- Interface/function:
- Physical location:
- Claim(s) it can validly test:
- Claim(s) it cannot test:
- Energy source(s):
- Isolation/galvanic boundary:
- Passive/active:
- Connector/keying strategy:
- Wrong-connector consequence:
- Partial-insertion consequence:
- Fixture default on boot/power loss:
- Fault-insertion reach:
- Independent witness:
- Fixture-present detection, if any:
- Production reconnection method:
- Fixture identity/configuration:
- Calibration requirement/status:
- Storage/accounting method:
- Post-removal challenge:
- Evidence provenance:
- Remaining UNKNOWNs:

## OpenPressBrake application boundary

For OpenPressBrake, this guide may be used to design future service/test interfaces for ordinary controls, safety-interface diagnostics, electrical verification support, guard-device test access, output/final-element observation, and hydraulic/electrical instrumentation **only after the actual machine architecture is known**.

Do not infer from this document:

- a safe hydraulic test pressure;
- a safe ram speed or distance;
- a valve truth table;
- a safe residual pressure;
- a required stopping distance/time;
- a required PL/SIL/category;
- an acceptable electrical test-point rating;
- a fixture isolation rating;
- a proof-test interval.

Those remain **UNKNOWN** until established from applicable requirements, component documentation, engineering calculations, and/or physical measurement/validation.

## Completion criterion

A fixture/test-point design is ready for detailed implementation only when the team can answer, without hand-waving:

1. What exact question does the test answer?
2. What real path is exercised and what is bypassed?
3. What energy can the fixture introduce or bridge?
4. What plausible wrong connection exists and what happens?
5. What independently observes the claimed result?
6. Can production operate with the fixture accidentally left in place?
7. How is fixture/configuration/calibration identity bound to evidence?
8. How is removal/restoration proven and challenged?
9. Which conclusions remain UNKNOWN?

Until then, a convenient test connector is only a convenience feature, not a validated safety-test architecture.
