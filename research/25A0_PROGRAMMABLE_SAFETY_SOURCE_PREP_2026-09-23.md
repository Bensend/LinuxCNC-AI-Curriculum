# 25A0 — Safety PLCs and programmable safety: source preparation

## Scope

25A0 asks what programmable safety changes — and what it does not. It covers redundant/diverse processing concepts, self-tests/watchdogs, safe I/O, test pulses and short-circuit detection, discrepancy timing, black-channel communication concepts, configuration/software limits, and inspectable/open functional-safety projects.

This is **not** permission to move personnel-safety authority into an ordinary PLC, LinuxCNC, HAL or a normal FPGA controller.

## Initial evidence ledger

### Safe controller internal diagnostics do not validate the field circuit

**DOC-CONFIRMED — Siemens S7-1200 Functional Safety Manual, V4.6 (11/2022):** the fail-safe system provides high internal diagnostic coverage, while diagnostic coverage of external circuits, sensors and actuators depends on the application design and other measures. The same manual states that complete safety-function reaction time includes sensor, PLC and actuator behavior.

Engineering consequence: a safety CPU/module's internal integrity is one subsystem property, not proof that the external sensor wiring, actuator path or physical safe state is correct.

**Freeze:** `SAFETY PLC INTERNAL DIAGNOSTICS != COMPLETE SAFETY FUNCTION VALIDATED`.

### Test pulses are active diagnostic stimuli, not magic wire labels

**DOC-CONFIRMED — Siemens SM 1226 F-DI:** its short-circuit test briefly removes sensor supply; an input that fails to go low can indicate a short to a power source or another fault preventing detection of 0, and the affected channel is passivated. Test duration also affects response time.

**DOC-CONFIRMED — Pilz test-pulse documentation:** appropriately wired test-pulse outputs apply defined pulses to inputs to enable detection of shorts across contacts.

Engineering consequence: test-pulse usefulness depends on topology, wiring, compatible devices and timing. A pulse that the field device filters, sources independently, couples to another channel, or interprets incorrectly can change both diagnostic behavior and response behavior.

**Freeze:** `TEST PULSE PRESENT != EVERY WIRING FAULT DETECTED`.

**Freeze:** `TEST-PULSE DIAGNOSTIC != PHYSICAL SAFE-STATE PROOF`.

### Discrepancy time is both a diagnostic parameter and a response-time parameter

**DOC-CONFIRMED — Siemens S7-1200 F-DI:** configured discrepancy time contributes directly to maximum 1oo2 response time when paired signals disagree. Siemens directs the designer to choose the smallest discrepancy time that accommodates normal sensor/installation/wiring behavior, and documents interaction between discrepancy detection and short-circuit-test/filter timing.

Engineering consequence: simply increasing discrepancy time to eliminate nuisance faults trades away fault-detection/response performance. Simply making it extremely short can create false trips from real mechanical/electrical skew. The value belongs to the safety-function timing and sensor behavior evidence, not arbitrary commissioning convenience.

**Freeze:** `LONGER DISCREPANCY WINDOW != FREE NUISANCE-TRIP FIX`.

### Safe outputs can deliberately pulse and the actuator must tolerate the diagnostic behavior

**DOC-CONFIRMED — Siemens S7-1200 F-DQ:** safe semiconductor outputs use ON/OFF test pulses for switch diagnostics; the manual explicitly requires consideration of whether the actuator can respond to diagnostic pulses, including a single-fault case that can apply energy to the load.

Engineering consequence: safe-output compatibility is an electrical/dynamic interface contract. A small valve, contactor interface, drive input or electronic load cannot be assumed compatible because its nominal voltage matches.

**Freeze:** `SAFE OUTPUT RATING MATCH != ACTUATOR TEST-PULSE COMPATIBILITY PROVED`.

### Configurable safety logic does not erase system/application obligations

**DOC-CONFIRMED — Pilz PNOZmulti installation guidance:** short/open circuits must be prevented from creating hazardous conditions, and the method depends on application hazard, sensor switching frequency and sensor/actuator safety level. Configurable tests can detect many — not all — shorts/open circuits.

Engineering consequence: certified/configurable blocks reduce implementation burden, but the application engineer still owns sensor/final-element selection, wiring assumptions, parameter correctness, response time, reset/restart behavior, fault exclusions where used, and physical validation.

**Freeze:** `CERTIFIED FUNCTION BLOCK != CERTIFIED MACHINE SAFETY FUNCTION`.

## Initial programmable-safety boundary map

| Layer | What it can establish | What it cannot establish alone |
|---|---|---|
| safety CPU internal diagnostics | bounded internal fault detection/response per device evidence | external sensor, wiring, actuator or machine safe state |
| safe input + test pulse | bounded electrical/input fault detection for documented topology | guard position, stopped motion or all external faults |
| 1oo2 discrepancy monitoring | channel agreement within configured timing model | independence, CCF control, correct physical sensor actuation |
| safety application program | specified logical relationship among validated inputs/state/outputs | physical field state or mechanical/hydraulic result |
| safe output diagnostics | bounded output-stage fault detection | final contactor/valve/drive action unless separately witnessed |
| ordinary PLC/LinuxCNC status copy | diagnostics/HMI/process coordination | personnel-safety authority or permission to bypass safety logic |

## Human-factors rule for programmable safety

Good diagnostics should make the **correct repair** faster than bypass. A message such as `Guard circuit fault` is weaker than diagnostics that identify channel, device, discrepancy/test-pulse condition, and the rearm prerequisite without exposing a convenient software bypass. Service modes must be explicit, bounded and auditable; nuisance trips should be corrected at the sensor/wiring/timing/root-cause level rather than normalized by broad bypasses.

## Next evidence questions

1. Trace one manufacturer's safety-controller architecture far enough to separate CPU internal self-test, I/O diagnostics, application program execution, and final output behavior.
2. Build a fault table for dual-channel dry contacts, OSSD sensors and test-pulse/PNP variants; identify which cross-short/open/24 V/0 V faults are detected by which mechanism.
3. Study black-channel safety communication from an authoritative implementation/application guide and separate communication safety mechanisms from underlying Ethernet/network reliability.
4. Inspect at least one open/inspectable functional-safety hardware/software project with published hazard analysis/tests/limitations, as required by the syllabus. Do not treat inspectability as certification.
5. Build an adversarial scenario where a safety PLC program is logically correct but the machine remains unsafe because of a field-interface, timing, common-cause or final-element assumption.

## Compute decision

No executable compute is justified yet. The open questions are source/documentation/architecture questions. If later testing becomes necessary, it must be bounded and run only on `[self-hosted, openpressbrake]`.
