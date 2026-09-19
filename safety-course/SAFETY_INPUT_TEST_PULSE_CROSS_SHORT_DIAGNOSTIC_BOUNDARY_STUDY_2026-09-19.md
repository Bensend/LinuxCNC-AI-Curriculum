# Safety Input Test-Pulse / Cross-Short Diagnostic Boundary Study

Date: 2026-09-19

## Question

What does a safety-controller test-pulse architecture actually prove about field wiring faults, and what does it *not* prove about the sensor, safety function, final element, or physical hazard?

This is intentionally independent of the current series-guard diagnostic lane and the primary press-brake hydraulic valve/physical-witness lane.

## Evidence vocabulary

- **SOURCE-CONFIRMED** — directly supported by cited manufacturer documentation.
- **DOC-CONFIRMED** — confirmed by repository-retained documentation/artifact.
- **TEST-CONFIRMED** — established by an executed, recorded test.
- **COMMUNITY-REPORTED** — reported by community material but not independently established here.
- **INFERENCE** — engineering conclusion drawn from confirmed evidence and labeled as such.
- **UNKNOWN** — not established by the reviewed evidence.

## SOURCE-CONFIRMED — pulse testing is an active field-wiring diagnostic, not merely a second input bit

Rockwell's Compact 5000 safety-I/O manual documents using a test output with a safety input for short-circuit and cross-channel fault detection. In Safety Pulse Test mode, the test output supplies the input circuit and deliberately produces short OFF pulses while the external contact is closed. The module uses the expected pulse behavior to detect shorts from an input signal to 24 V and shorts between input signal lines.

Rockwell also requires paired safety inputs used for this purpose to be associated with different test-output sources. Its newer PointMax documentation makes the limitation explicit: if two safety inputs are externally wired from the *same* test-output point, a short between those two inputs is not detectable by that pulse arrangement.

Sources:
- Rockwell Automation, Compact 5000 Digital I/O Modules User Manual, 5069-UM004G-EN-P, Chapter 5, "Use Test Output with a Safety Input" and "Test Pulse in a Cycle": https://literature.rockwellautomation.com/idc/groups/literature/documents/um/5069-um004_-en-p.pdf
- Rockwell Automation, 5069 Safety Discrete AOP help, Safety Pulse Test parameters: https://www.rockwellautomation.com/en-us/docs/add-on-profiles/ra-5069-safety-discrete/40/5069-safety-discrete-ditamap/points-view-input/points-view-params-input.html
- Rockwell Automation, PointMax 5034-IB8S/IB8SXT wiring diagrams: https://www.rockwellautomation.com/en-pr/docs/technical/i-o/current/5034-pointmax/_online/5034-um002-ditamap/5034-ib8s-ib8sxt-details/safety-application-suitability-levels-input/5034-ib8s-ib8sxt-wiring-diagrams.html

## SOURCE-CONFIRMED — test-pulse source identity is part of the diagnostic architecture

Rockwell documents a configurable Test Source for a safety input in Safety Pulse Test mode. The test source is therefore not interchangeable metadata: it is part of the physical diagnostic path. The PointMax wiring guidance demonstrates why source assignment matters; two inputs fed by one pulse source can share a fault that the pulse comparison cannot distinguish.

Pilz independently documents the same general mechanism: specific pulses are applied to inputs through test-pulse outputs so that shorts across contacts can be detected. PNOZ m B0 exposes four test-pulse outputs specifically for detection of shorts between inputs and provides a manual commissioning/error-localization function for those pulses.

Sources:
- Pilz, "Test pulse output": https://www.pilz.com/en-US/support/lexicon/articles/072903
- Pilz, PNOZ m B0 Operating Manual 1002660-EN-13, section 5.6 "Detection of shorts across contacts": https://www.pilz.com/download/open/PNOZ_m_B0_Operating_Manual_1002660-EN-13.pdf

## SOURCE-CONFIRMED — a safety input can be valid data while diagnostics remain a separate state

Rockwell's 5069-IB8S device-defined input data exposes the input Data state separately from Fault and Uncertain status. This is useful curriculum evidence that `input=ON` cannot be treated as the whole safety-input truth when diagnostic state says the channel is bad or uncertain.

Source: Rockwell Automation, 5069-IB8S device-defined data types: https://www.rockwellautomation.com/en-il/docs/add-on-profiles/ra-5069-safety-discrete/40/5069-safety-discrete-ditamap/dev-def-data-types/dev-def-data-types-5069-ib8s.html

## INFERENCE — the diagnostic proof is bounded by wiring and configuration

The sources support a practical architecture rule:

**INPUT LOGIC HIGH != FIELD CIRCUIT HEALTHY.**

**TWO INPUTS AGREE != CROSS-SHORT EXCLUDED.**

**TEST PULSE PRESENT != CORRECT TEST SOURCE ASSIGNED != EXPECTED PULSE OBSERVED AT EACH INPUT != FIELD WIRING FAULT-FREE.**

**FIELD WIRING DIAGNOSTIC PASS != SENSOR MECHANICALLY ACTUATED/CORRECT != SAFETY LOGIC VALID != FINAL ELEMENT SAFE != PHYSICAL HAZARD CEASED != RESTART AUTHORITY.**

The exact faults detectable by pulse testing depend on the manufacturer's approved wiring topology, test-source assignment, input mode, and connected device compatibility. A pulse test is not a generic magic proof against every short, open, cross-connection, sensor failure, common-cause fault, or final-element failure.

## Architecture boundary for LinuxCNC/OpenPressBrake

Ordinary LinuxCNC/HAL/FPGA may consume maintenance diagnostics such as `channel fault`, `uncertain`, `input state`, or a localized wiring alarm where the safety system exposes them. Those data are valuable for troubleshooting and HMI guidance.

They do not transfer personnel-safety authority into LinuxCNC. The independent safety path must remain responsible for interpreting its approved input/test-pulse architecture and removing/inhibiting hazardous authority on detected safety-input faults. LinuxCNC must not reconstruct a supposedly equivalent safety decision from ordinary copies of pulse/status bits.

No OpenPressBrake safety-input topology is established here. Whether the future machine uses dry contacts with test pulses, OSSD devices, safe network inputs, dedicated safety relays, or another architecture remains **UNKNOWN** until the actual safety design is frozen.

## Commissioning / verification plan

For each safety input function using pulse-tested contacts:

1. Record the actual safety input channel, point mode, assigned test source, field terminal, cable/conductor, and device contact/channel.
2. Verify the manufacturer's permitted topology and device compatibility before energizing the test.
3. Demand the protective device normally and verify both the safety-side reaction and the actual final-element/physical hazard witness required by that function.
4. Where the manufacturer's commissioning procedure permits it, challenge a short from the input signal to 24 V and verify that the safety evaluator detects the fault and removes/inhibits hazardous authority.
5. Where permitted, challenge a channel-to-channel short and verify detection. Include the source-assignment question explicitly: a test that accidentally uses two inputs from the same pulse source must not be credited as proof of a fault class that the manufacturer says that topology cannot detect.
6. Challenge an open conductor separately; do not assume the cross-short test proves open-circuit behavior.
7. Verify that a diagnostic fault cannot be hidden by a plausible ordinary input state, HMI acknowledgement, LinuxCNC restart, safety-controller power cycle, or stale START/JOG/CYCLE request.
8. Correct the fault and prove the required fault-clear/reset behavior. Clearing a wiring diagnostic is not itself ordinary START authority.
9. After replacement/rewiring, repeat the affected channel mapping and fault-detection proof rather than assuming the replacement preserved test-source identity.

Only inject faults by methods allowed by the device/manufacturer validation procedure and in a controlled commissioning state. Do not create uncontrolled hazardous motion merely to demonstrate a diagnostic.

## Failure paths worth teaching

- Both safety channels read ON because both have been shorted to 24 V.
- Two channels are cross-connected but assigned in a way that cannot distinguish the cross-short.
- Correct device/contact is wired to the wrong test source after maintenance.
- Safety input is accidentally configured as plain Safety rather than Safety Pulse Test where the validated design depended on pulse diagnostics.
- HMI shows a healthy-looking contact state while the safety module reports Fault/Uncertain.
- A replacement safety device is electrically incompatible with the test pulses or requires a different approved connection method.
- A technician clears the wiring fault but production resumes from a stale ordinary motion request without the required reset/restart sequence.

## Evidence status

- Test-pulse use for short-to-24-V and channel-to-channel short detection: **SOURCE-CONFIRMED**.
- Need for distinct test sources to detect some cross-channel shorts: **SOURCE-CONFIRMED**.
- Pilz use of test-pulse outputs for shorts-across-contacts detection and commissioning/error localization: **SOURCE-CONFIRMED**.
- Separate input Data/Fault/Uncertain states on Rockwell safety input: **SOURCE-CONFIRMED**.
- Any specific OpenPressBrake safety-input wiring, pulse width/period, channel pairing, discrepancy time, required PL/SIL/category/DC/CCF, sensor compatibility, final-element response, or physical stopping performance: **UNKNOWN**.
- No **TEST-CONFIRMED** OpenPressBrake result is claimed by this study.
- No **COMMUNITY-REPORTED** claim is needed for the conclusions above.

## Compute decision

No executable verification is justified. The unresolved work is physical safety-I/O architecture and manufacturer evidence. No GitHub-hosted or self-hosted runner compute was used.

## Precise next-work checkpoint

Find a professional commissioning/validation artifact that traces one pulse-tested dual-channel protective device through:

`device channels -> distinct test sources -> normal demand -> short-to-24-V challenge -> channel-to-channel cross-short challenge -> safety input Fault/Uncertain state -> safety evaluator output inhibition -> actual final element -> physical hazardous-state witness -> fault correction -> required safety reset/rearm -> fresh ordinary START`.

Prefer an artifact that explicitly demonstrates a misassigned/shared test-source failure or documents why that wiring defeats a specific diagnostic. If no complete artifact is public, keep the physical final-element portion **UNKNOWN** and rotate to another independent safety evidence gap rather than synthesizing a machine-specific result.