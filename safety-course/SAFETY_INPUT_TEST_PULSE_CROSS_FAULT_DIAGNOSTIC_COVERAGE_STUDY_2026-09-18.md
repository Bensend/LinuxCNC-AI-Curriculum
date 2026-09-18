# Safety input test-pulse, cross-fault, and diagnostic-coverage study

Date: 2026-09-18
Lane: independent safety curriculum B

## Why this is independent

The primary lane is currently advancing monitored hydraulic final-element disagreement and physical hazard witness. This study stays on the sensor/input wiring side: what a safety controller can and cannot infer from test pulses, dual-channel discrepancy, and field-wiring diagnostics. It does not edit the hydraulic evidence package or primary checkpoint.

## Architecture freeze

**CONTACTS CLOSED != FIELD WIRING HEALTHY != TEST PULSE OBSERVED CORRECTLY != CHANNELS IN AGREEMENT != SAFETY FUNCTION VALID != FINAL ELEMENT SAFE != PHYSICAL HAZARD ABSENT.**

Likewise:

**DUAL CHANNEL != AUTOMATIC CROSS-FAULT DETECTION.**

**TEST PULSE ENABLED != EVERY SHORT CIRCUIT DETECTABLE.**

**INPUT DIAGNOSTIC CLEAR != PERMISSION FOR LINUXCNC/FPGA TO OWN PERSONNEL-SAFETY AUTHORITY.**

Ordinary LinuxCNC/FPGA I/O may display, log, or request machine behavior, but a personnel-safety claim based on monitored safety inputs belongs to the independent safety architecture and its validated wiring/configuration.

## Evidence and provenance

### SOURCE-CONFIRMED — Rockwell PointMax safety inputs

Rockwell documents Safety Pulse Test as a distinct safety-input mode. A configured test output is associated with the safety input; the controller uses the pulsed source to diagnose field wiring and input circuitry. The documentation states that this can detect shorts to positive supply and between signal lines. It also gives a crucial limitation: two input channels assigned to the **same** test output can be shorted together without that channel-to-channel short being detected.

Source: Rockwell Automation, *Safety Input Modules in CIP Safety Systems*, current PointMax documentation: https://www.rockwellautomation.com/en-us/docs/technical-i-o/current/5034-pointmax/_online/pointmax-i-o-modules-details-ditamap/safety-input-cip-safety-systems.html

This is strong curriculum evidence that diagnostic coverage depends on the actual test-source assignment and field wiring, not merely on the words "dual channel" or "pulse test" in a configuration screen.

### DOC-CONFIRMED — Rockwell Guard I/O

Rockwell's Guard I/O manual distinguishes single-channel, dual-channel equivalent, and dual-channel complementary evaluation. It separately defines Safety Test Pulse mode and states that it is used with a test output to detect shorts between input signal lines and to positive supply.

Source: Rockwell Automation, *Guard I/O DeviceNet Safety Modules User Manual*, 1791DS-UM001L-EN-P, October 2021.

### SOURCE-CONFIRMED — Pilz

Pilz defines a test-pulse output as applying specific pulses to inputs, when wired appropriately, to enable detection of shorts across contacts.

Source: Pilz, *Test pulse output*: https://www.pilz.com/en-US/support/lexicon/articles/072903

The phrase "when wired appropriately" is architecturally important: the diagnostic claim is a property of controller configuration **plus** field topology, not software alone.

### DOC-CONFIRMED — SICK Flexi Soft

SICK explicitly warns that a cross-circuit can impair fault detection and says protected or separate cabling may be required between a controller test-output path and the sensor/safe-input return path for the cited testable sensor arrangement.

Source: SICK, *Flexi Soft Modular Safety Controller — Hardware*, 8012478/1T57/2025-07-30, section 5.4.3.2.

This is useful evidence that testability can itself be defeated by an unfavorable wiring fault/topology; routing and separation remain part of the safety argument.

## Diagnostic layers learners must keep separate

1. **Device/contact state** — what the E-stop, guard switch, pressure switch, or other device is physically doing.
2. **Field-wire electrical state** — opens, shorts to 24 V/0 V, channel-to-channel shorts, cross-circuits, connector faults.
3. **Test-source identity** — which pulse source is supposed to feed which channel.
4. **Pulse observation** — whether the receiving safety input sees the expected dynamic behavior.
5. **Channel relationship** — equivalent/complementary state and discrepancy timing where applicable.
6. **Safety-function logic** — whether the validated input state permits the safety function.
7. **Safety output/final element** — whether the demanded safe reaction reaches the physical actuator/isolation device.
8. **Physical hazard witness** — whether motion/energy actually reached the required safe condition.

Collapsing any of these layers into a single `SAFE=TRUE` bit hides useful failure paths.

## Failure-path worksheet

| Challenge | Expected architectural question |
|---|---|
| Channel A shorted to +24 V | Does the selected pulse-test topology detect that forced-high condition? |
| Channel A shorted to Channel B | Are the channels on diagnostically independent test sources, or can this cross-short follow the same pulse and remain hidden? |
| Both channels assigned to one test source | Which cross-fault claims are lost by that assignment? |
| Test-output wire shorted directly to input return | Can the controller distinguish bypassed field contacts from a healthy device? |
| One channel open circuit | Is the fault distinguished from a legitimate safety demand, and does restart remain inhibited as required? |
| Channels disagree | What discrepancy diagnostic occurs, and is it latched or automatically recoverable? |
| Fault disappears | Does diagnostic recovery itself re-enable the hazard, or is deliberate reset/rearm still required? |
| Safety controller power cycles with a field short still present | Is the fault rediscovered before safety authority can return? |
| LinuxCNC reports guard closed while safety input is faulted | Which system owns personnel-safety authority? The answer must remain the safety system. |
| Safety input becomes valid while stale START/JOG/CYCLE remains asserted | Safety recovery must not silently convert stale ordinary-control intent into fresh hazardous-motion authority. |
| Pulse timing is filtered by an intermediary device | Has compatibility with test pulses actually been validated? Do not assume. |
| Long/shared cable routing couples channels | Has wiring separation/protection and the resulting fault model been justified? |

## Commissioning/validation questions

A practical validation plan should inject only faults that can be introduced safely and reversibly on a de-energized or otherwise controlled test setup. For each claimed diagnostic, document:

- exact safety input and test-source assignment;
- actual field wiring and cable routing;
- intended device state;
- injected fault class;
- safety-controller diagnostic/state;
- whether safety outputs remain inhibited;
- whether a reset is required after repair;
- whether ordinary LinuxCNC/FPGA indications disagree with safety truth;
- physical final-element/hazard witness where the test is intended to validate the full chain.

Do **not** infer coverage for untested fault classes from one successful short-circuit test.

## Evidence labels for future labs

- **SOURCE-CONFIRMED:** manufacturer/source explicitly states behavior.
- **DOC-CONFIRMED:** behavior is established by an authoritative manual or standard-derived document.
- **TEST-CONFIRMED:** the exact configured hardware/wiring behavior has been deliberately verified.
- **COMMUNITY-REPORTED:** practitioner report only; useful lead, not design proof.
- **INFERENCE:** engineering conclusion derived from evidence but not explicitly stated by the source.
- **UNKNOWN:** machine/configuration-specific fact not yet established.

## OpenPressBrake boundary

The following remain **UNKNOWN** and are not invented here: the eventual safety controller/I/O family; E-stop/guard sensor types; exact dual-channel topology; test-pulse width/period; allowable input filters; cable lengths/routing; required fault exclusions; PL/SIL/category/DC/CCF; reset policy; hydraulic final elements; stopping performance; and physical hazard-witness implementation.

No claim is made that an ordinary FPGA digital input plus software-generated toggling is equivalent to certified/validated safety-input diagnostics.

## Compute decision

No simulation, synthesis, benchmark, or executable test answers the source-tracing question in this pass. No GitHub-hosted or self-hosted compute is justified.

## Precise next-work checkpoint

Find a complete professional wiring/commissioning example that exposes **two physical safety contacts/sensors -> distinct test sources -> safety inputs -> cross-short/short-to-supply/discrepancy diagnosis -> latched or defined fault recovery -> safety output/final element -> physical safe-state witness -> deliberate reset/rearm -> separate fresh ordinary START**. Prefer an example that explicitly demonstrates a fault that becomes *undetectable* when test-source assignment or cable routing is wrong, because that teaches the boundary between redundancy and actual diagnostic coverage.