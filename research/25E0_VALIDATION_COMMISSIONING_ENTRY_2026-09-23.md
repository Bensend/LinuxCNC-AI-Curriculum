# 25E0 — Validation, commissioning, and proof testing: canonical entry

## Mission

Turn the safety requirements into an inspectable release decision. A machine is not validated because the schematic looks correct, the safety relay has a rating, the PLC program compiles, or one E-stop test worked. Validation asks whether the implemented machine actually satisfies the specified safety functions across the relevant lifecycle states and credible faults.

This entry is the canonical 25E0 syllabus branch. Earlier 25E0 intentional-exception/muting/override artifacts remain useful specialist evidence and should be consumed later as adversarial commissioning/change-control cases rather than replacing the core validation syllabus.

## Evidence reopened

**DOC-CONFIRMED — Pilz safety-validation guidance (current page accessed 2026-09-23):** validation follows risk assessment, safety concept/design and implementation; it checks that protective measures were implemented correctly and that safety functions work. Pilz's described validation scope includes safety-function testing, installation/function checks and, at deeper levels, fault simulation and inspection of the SRS/safety-related implementation.

**DOC-CONFIRMED — SICK validation/service guidance:** validation testing is guided by a test plan and compared with design specifications; SICK lists physical testing/fault simulation, stop-time measurement, safeguarding checks and verification that dangerous movements stop as required. Its stop-time service treats measured stopping time as evidence used to verify safeguard distance and notes that lifetime changes such as brake wear can change stopping behavior.

## Verification, validation and commissioning are not synonyms

- **Verification:** did the design/implementation artifact satisfy its specified design requirement? Examples: wiring continuity, configured input type, calculated subsystem architecture, reviewed safety program.
- **Validation:** does the implemented safety function on the actual machine satisfy the safety requirement and achieve the intended risk reduction under the defined conditions?
- **Commissioning:** controlled process of bringing the implemented machine into service, including configuration, checks, tests, corrections, evidence capture and release authority.

Freeze: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION.**

Freeze: **COMPONENT SELF-TEST PASS != MACHINE VALIDATION PASS.**

Freeze: **ONE SUCCESSFUL STOP != VALIDATED STOPPING BEHAVIOR.**

## Test derivation rule

Every validation test must trace to a safety requirement or explicit failure assumption. Use this chain:

`SRS requirement -> observable physical proposition -> precondition/mode -> stimulus or fault -> expected safety response -> measurement/evidence -> acceptance criterion -> result -> anomaly/corrective action -> retest/release status`

A large checklist with no requirement traceability can miss the dominant hazard while appearing thorough.

## Minimum commissioning evidence bundle

For each safety function preserve, as applicable:

1. machine/configuration identity and revision;
2. SRS requirement ID and lifecycle/mode boundary;
3. relevant sensor, logic and final-element identities/configuration;
4. wiring/installation inspection evidence;
5. normal demand test;
6. reset/restart and power-restoration test;
7. justified fault tests/diagnostics, including final-element feedback where applicable;
8. measured physical behavior where the requirement depends on it;
9. test equipment identity/calibration suitability where measurement matters;
10. result against a predeclared acceptance criterion;
11. unresolved deviations and residual risk;
12. authorized release decision;
13. baseline/version record needed to decide when revalidation is required.

## Stopping-time boundary

Where safeguard placement or guard release depends on stopping/cessation time, a catalog response time or software timestamp is not enough. The relevant machine behavior must be measured/validated using an appropriate method and conditions. Wear, load, operating mode and other application variables may affect the result; do not invent a universal margin or interval.

Freeze: **DEVICE RESPONSE TIME != COMPLETE MACHINE STOPPING TIME.**

Freeze: **CALCULATED SAFETY DISTANCE != VALIDATED SAFEGUARD POSITION WITHOUT MACHINE STOPPING EVIDENCE.**

## Proof testing and periodic inspection

25B0 already established that a proof test must actually expose the latent dangerous failure assumed by the reliability/safety argument. 25E0 carries that into maintenance:

- define the latent failure being sought;
- define the stimulus/inspection capable of revealing it;
- define expected indication/physical response;
- record the result and failed-test disposition;
- justify interval from the architecture, manufacturer assumptions, usage/environment and applicable integrity method rather than inventing a calendar period.

Freeze: **ROUTINE MAINTENANCE != PROOF TEST UNLESS IT EXPOSES THE ASSUMED LATENT FAILURE.**

## Change and revalidation trigger model

Do not ask only “did the safety code change?” Revalidation scope must consider changes to sensors, mounting, wiring, safety parameters, logic, firmware, communications, final elements, drive/valve parameters, brakes, mechanics, tooling/load, guard geometry, stopping behavior, reset/restart behavior, operating modes, maintenance procedure and environmental assumptions.

A change may be small in software diff size and large in physical safety consequence.

Freeze: **UNCHANGED SAFETY PROGRAM != UNCHANGED VALIDATED SAFETY FUNCTION.**

## LinuxCNC boundary

LinuxCNC/ordinary FPGA/controller data can support diagnostics, test orchestration and evidence capture. It must not be the sole oracle proving the personnel-safety function that it also commands. Prefer independent physical evidence for the proposition under test. A HAL bit saying `safe` is evidence about a bit, not automatically evidence about stopped motion, isolated energy, discharged pressure or restrained load.

## Safe test escalation

Use the lowest-risk method that can answer the requirement. Static inspection and low-energy representative tests should precede hazardous physical testing. If a required physical test cannot meet a basic safe-to-test threshold with people exposed, isolate/remote the experiment with people outside the danger zone and state residual risk. Do not inject dangerous faults on an attended machine merely because fault injection appears in the syllabus.

## Relationship to existing 25E0 exception-state artifacts

The earlier muting/override/setup exception work is retained as a valuable validation challenge: commissioning must prove not only entry into the exceptional mode but eligibility, alternate protective strategy, bounded persistence, fault/exit behavior, and return-to-production semantics. A normal-controller bypass that yields the same permissive Boolean does not carry equivalent safety evidence.

## Exact next work

1. Build an SRS-to-validation matrix spanning E-stop, guard/interlock, STO/coast, fluid-power safe state and reset/restart.
2. Add adversarial commissioning cases where command/status bits pass while physical validation fails.
3. Reconcile the earlier 25E0 exceptional-mode artifacts into the canonical syllabus rather than duplicating them.
4. Audit stopping-time measurement, periodic proof-test and change/revalidation requirements without inventing machine-specific intervals or thresholds.
5. No executable compute is justified until a concrete unresolved implementation question survives authoritative/static reasoning.
