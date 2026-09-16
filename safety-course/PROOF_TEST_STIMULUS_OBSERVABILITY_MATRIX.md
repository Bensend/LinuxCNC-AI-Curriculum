# Proof-Test Stimulus and Observability Matrix

Status: DURABLE STUDY ARTIFACT  
Lane: independent safety curriculum Lane B  
Date: 2026-09-16

## Purpose

A proof test is useful only to the extent that it physically challenges the failure mode being claimed and observes enough of the resulting path to justify a bounded conclusion. Merely toggling a PLC/HAL bit, watching an HMI icon, or seeing a diagnostic clear can leave important sensing, wiring, final-element, mechanical, hydraulic, and common-cause failures completely untested.

Frozen rule:

> **`test command issued` is not `physical safety path proven`. A proof test must identify the actual stimulus, the path exercised, the independent observation, and the claim boundary.**

This worksheet complements `DIAGNOSTIC_BLIND_SPOTS_LATENT_FAULT_ACCUMULATION_WORKSHEET.md` and `SENSOR_FEEDBACK_INDEPENDENCE_COMMON_CAUSE_WORKSHEET.md`. It does not assign proof-test intervals, diagnostic-coverage percentages, PL/SIL/category, stopping distances, pressures, forces, speeds, or machine-specific hydraulic behavior.

## Evidence vocabulary

- **SOURCE-CONFIRMED** — directly supported by authoritative source material.
- **DOC-CONFIRMED** — directly supported by project/manufacturer documentation applicable to the specific item/configuration.
- **TEST-CONFIRMED** — directly demonstrated by a controlled test whose stimulus, configuration and observation are retained.
- **COMMUNITY-REPORTED** — reported by community/user material but not independently established.
- **INFERENCE** — engineering reasoning derived from known evidence; not itself a physical test result.
- **UNKNOWN** — not established; do not fill the gap with a plausible number or behavior.

## Source-grounded boundaries

### Safety configuration identity does not replace user testing

**SOURCE-CONFIRMED:** Rockwell documents that a safety-I/O configuration signature identifies module configuration, but the signature can only be considered verified after user testing. Safety input/output/test parameters are part of that configuration. This supports keeping configuration identity and physical proof separate.

Source: Rockwell Automation, ControlLogix/GuardLogix safety-I/O documentation, "Connect to Safety I/O" and related safety-I/O guidance.

### Diagnostics depend on where discrepancy checking occurs

**SOURCE-CONFIRMED:** Rockwell documents that dual-channel discrepancy checking may occur in a safety input module or in a controller safety instruction, and that the choice changes available diagnostic information. A proof plan therefore has to know which layer actually observes the challenged fault rather than assuming that two configured channels imply equivalent fault observability.

Source: Rockwell Automation, GuardLogix Safety Reference Manual, "Input Operation."

### Safeguards require real inspection/testing, not status-only confidence

**SOURCE-CONFIRMED:** OSHA's mechanical power-press rules require periodic inspection of safeguards and testing of specified safety-related mechanisms, with necessary repair before operation. OSHA machine-guarding guidance also calls for guards and other safety devices to be inspected as in place and functional before return to service after maintenance. These are useful general precedents for physically exercising and observing the relevant safety path rather than accepting a software indication alone.

Sources: OSHA 29 CFR 1910.217(e); OSHA Machine Guarding eTool, Additional Safety Considerations.

## Proof-test contract

For each claimed safety function or diagnostic, record:

1. **Claim** — exactly what the test is intended to establish.
2. **Configuration identity** — hardware, wiring, logic/configuration, firmware and relevant mechanical setup to which the result applies.
3. **Precondition** — controlled initial state and hazard boundary.
4. **Physical stimulus** — the real-world action/fault condition applied. If the test only injects a software bit, say so explicitly.
5. **Path exercised** — sensing element, wiring/channel, safety logic, output interface, final element and physical process portions actually traversed.
6. **Independent witness** — observation not merely derived from the same internal value under test.
7. **Expected bounded result** — qualitative result justified before test; machine-specific numeric limits remain UNKNOWN unless independently engineered.
8. **Failure response** — what prevents ordinary rearm/start when the observation disagrees or is missing/stale.
9. **Restoration** — removal of the test condition and confirmation that temporary test/bypass mechanisms are restored.
10. **Evidence retained** — raw observations, test identity, configuration identity, timestamps/order/session identity, operator/tester and exceptions.
11. **Conclusion boundary** — what the result proves and explicitly what it does not prove.

## Stimulus / observability matrix

| Function / element | Representative latent fault | Inadequate pseudo-test | Required physical stimulus question | Independent witness question | What a passing test may establish | What it must NOT silently claim |
|---|---|---|---|---|---|---|
| Guard/interlock sensor | misaligned actuator, stuck contact, damaged channel | force the input tag OFF/ON | Was the actual guard/actuator moved through the relevant state? | Is the physical guard state independently observable? | tested sensor/channel responded to real actuation in this configuration | all guard geometry is safe; every defeat mode is detected |
| Dual-channel protective input | one channel stuck or shorted/common-cause coupling | toggle both software bits together | Can each physical channel be challenged separately where the device permits? | Are channel-specific observations/diagnostics retained? | challenged discrepancy/fault path was observable | arbitrary diagnostic coverage or independence percentage |
| E-stop actuator/input | broken contact/channel or wiring fault | issue software E-stop command | Was the physical actuator and its real input path operated? | Is resulting safety-path state observed independently of the command bit? | exercised actuator/input path responded as tested | all hazardous energy is removed; stopping distance is acceptable |
| Safety output/contactors | welded/stuck final contact or output path fault | watch controller output turn OFF | Does the test challenge the actual final element? | Is auxiliary/independent physical feedback suitable for the claimed state? | challenged final element changed state as observed | zero electrical/hydraulic/mechanical energy unless separately verified |
| Hydraulic shutoff/dump element | spool/valve fails to achieve intended physical condition | observe solenoid command OFF | What safe test can challenge the real valve/process path? | What independent pressure/motion/position evidence is required? | only the specifically observed physical response | a hydraulic truth table, safe residual pressure, or gravity security without measurement/engineering |
| Motion stop path | drive command removed but axis continues/coasts | watch motion-enable bit clear | Can actual hazardous motion be initiated within a controlled validation boundary and the stop path demanded? | Is physical motion independently measured/observed? | stop demand produced the observed physical response under test conditions | universal stopping time/distance or safe separation distance |
| Presence/protective field device | blocked beam/zone, stale field, wiring fault | force OSSDs/input tags | Can the defined sensing field be physically challenged at representative locations? | Is field interruption and downstream safety response independently evidenced? | tested challenge locations/path were detected | complete coverage of untested geometry or a protective-distance claim |
| Reset/rearm chain | stale reset, held reset, automatic restart | pulse reset tag in logic | Is the real reset device/state transition exercised after a real demand/fault? | Is absence of hazardous restart independently observed? | tested reset/rearm sequence behaved as recorded | physical cause of prior fault is cleared unless separately proven |
| Feedback/EDM | feedback stuck in expected state | manipulate EDM variable | Can the monitored final element be made to produce the contrary physical condition safely? | Does the feedback actually disagree when it should? | feedback path detected the challenged state transition | final element health outside the challenged failure modes |
| Mechanical block/restraint | missing, mis-seated, damaged or incapable of intended restraint | set `block_installed=true` | Is the physical restraint present/engaged and inspected under the applicable procedure? | What direct physical evidence establishes engagement/condition? | observed installation/condition at test time | load capacity or safe support rating without engineering evidence |
| Energy isolation witness | indicator stuck or derived from command | turn disconnect command OFF | Is the actual isolation means operated and energy state verified by the prescribed method? | Is verification independent of the control command? | bounded isolation evidence for tested source/state | absence of every stored/reaccumulating energy source |

## Fault-injection hierarchy

Use the least hazardous stimulus that still reaches the failure mode of interest. A software injection is useful for testing software reaction to a value, but its conclusion must stay at that layer.

Example:

- forcing `guard_open=true` can test **logic reaction to a guard-open value**;
- opening the real guard can additionally test **sensor actuation and physical input path**;
- safely challenging one channel can test **channel discrepancy detection**;
- none of those alone proves **physical hazardous motion stopped within an acceptable distance**.

Do not escalate to hazardous physical fault injection merely to make a test look more realistic. If the failure cannot be challenged safely, record the observability gap and use appropriate inspection, manufacturer test provisions, engineered test fixtures, substitution evidence, or other bounded methods.

## Freshness and invalidation

A prior passing proof test is not automatically transferable after a relevant change. Review/invalidate the result when the claim path changes, including as applicable:

- sensor, actuator or final-element replacement;
- field wiring/connector repair;
- safety I/O replacement or configuration change;
- logic/firmware/configuration change;
- mechanical actuator/guard geometry change;
- hydraulic/pneumatic component or plumbing change;
- calibration or measurement-chain change;
- test method or witness change;
- undocumented configuration identity;
- evidence freshness/order/session ambiguity.

A matching software/configuration signature is useful configuration evidence but does not prove unchanged field wiring, mechanics, hydraulics, guarding or physical performance.

## Stale-data adversarial checks

Before accepting a test, ask:

- Could the witness be a cached value from before the stimulus?
- Could two displays be derived from the same frozen network tag?
- Did the sensor actually transition, or did only the HMI representation change?
- Was the event order preserved across reboot/reconnect?
- Did a temporary force/bypass survive the test?
- Did the test accidentally prove only the simulator or diagnostic harness?
- Was the independent witness powered/referenced through the same failed common cause?

If any answer is unresolved, narrow the conclusion or mark it **UNKNOWN**.

## Practical OpenPressBrake separation of authority

LinuxCNC/HAL and the ordinary FPGA/control layer may:

- request ordinary motion and stop actions;
- display safety-system state supplied to them;
- log commands, feedback and timestamps;
- inhibit ordinary production commands;
- discard stale commands after reset/reconnect;
- help sequence a non-safety validation procedure.

They must not be treated as personnel-safety authority merely because a proof-test screen or script runs there. Independent safety functions retain their own authority. A convenient HMI test wizard is an operator aid, not a substitute for the actual safety path, physical stimulus, independent witness, restoration checks or validation evidence.

## Question-driven validation template

Use one row per question. Do not run a lab merely because compute is available.

| ID | Safety claim | Failure mode questioned | Physical stimulus | Path actually exercised | Independent witness | Configuration ID | Evidence class | Result | Bounded conclusion / UNKNOWN |
|---|---|---|---|---|---|---|---|---|---|
| PT-___ | | | | | | | | | |

## Adversarial review cases

1. **Green HMI after E-stop:** the screen says stopped after the physical E-stop is pressed, but no independent final-element or motion observation exists. Accept only the HMI/input-path claim; physical stop performance remains UNKNOWN.
2. **Forced guard bit:** forcing a guard tag successfully removes motion permission. This tests logic response, not the guard sensor, wiring or actuator alignment.
3. **Two screens agree:** LinuxCNC and a maintenance dashboard both show contactor OFF but consume the same network bit. Treat them as one witness.
4. **EDM never challenged:** EDM reads healthy for months because the contactor has never been deliberately taken through the state that would expose a stuck feedback path. The absence of a diagnostic fault is not proof.
5. **Valve command OFF:** a solenoid output drops but no physical hydraulic witness is present. Do not infer safe pressure, spool state or ram security.
6. **Old passing test after repair:** a sensor cable was replaced after the recorded test. Re-evaluate the evidence binding to the changed path.
7. **Matching safety signature after field change:** software identity matches, but a guard bracket was moved. The signature does not validate the new mechanical geometry.
8. **Temporary force forgotten:** the proof test passes only because an engineering force remains active. Restoration and force/bypass clearance are mandatory evidence items.
9. **Stale feedback after reconnect:** an HMI reuses the last known safe value while communication is lost. Missing freshness is a failed observability condition, not a safe state proof.
10. **Unsafe desire for realism:** a proposed test would deliberately defeat a load-holding element with people exposed. Do not perform it; redesign the test boundary or retain the claim as UNKNOWN.

## Completion gate for a proof-test record

A record is not complete until all applicable items are answered:

- [ ] Exact claim stated.
- [ ] Relevant configuration identity retained.
- [ ] Physical stimulus or explicit software-only limitation recorded.
- [ ] Path actually exercised identified.
- [ ] Independent witness identified and freshness established.
- [ ] Common-cause dependence considered.
- [ ] Expected bounded result defined without invented machine numbers.
- [ ] Unexpected/missing evidence blocks ordinary rearm/start as appropriate to the safety architecture.
- [ ] Temporary forces, bypasses and test fixtures restored/removed.
- [ ] Raw evidence retained with provenance.
- [ ] Conclusion explicitly excludes untested layers.

## Next independent work

Build a **proof-test restoration / test-tool defeat-resistance worksheet** focused on temporary forces, jumpers, test plugs, simulated inputs, maintenance passwords, diagnostic overrides and validation fixtures: how they are authorized, visibly indicated, bounded, logged, removed, independently checked and prevented from surviving reboot/mode change/return to production. Keep it distinct from the primary lane's fault-reset causal-clearance work and from general maintenance bypass lifecycle material already present in the course.
