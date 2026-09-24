# Safety input + FPGA interface source audit — 2026-09-24

Status: source audit / curriculum engineering evidence. Not a machine-specific certified design.

Session start: `2026-09-24T07:38:02Z`.

## Question

What electrical semantics can be frozen as reusable contracts for `SI-DRY2`, `SI-OSSD2`, and `FS-IF`, and what must remain device/application-specific before schematic capture?

## Evidence classification

### SOURCE-CONFIRMED — dry-contact/test-pulse input behavior

Rockwell PointMax safety-input documentation distinguishes plain Safety inputs from Safety Pulse Test inputs. A pulse-test input must be associated with a test source; the test output/input combination is used to detect shorts to +24 V and cross-channel faults. The same documentation warns that two channels assigned to the same test source cannot detect a short between those two channels. Rockwell 5069 safety-input documentation likewise requires a test source for Safety Pulse Test mode and states that pulse testing detects shorts to +24 V and channel-to-channel shorts to other inputs.

Pilz PNOZ documentation independently distinguishes dual-channel circuits with and without detection of shorts across contacts. PNOZmulti documentation describes test-pulse outputs as the mechanism used to monitor shorts across inputs.

**Freeze:** `SI-DRY2` may expose a common logical dual-channel contract, but cross-short diagnostic credit is implementation-dependent. A reusable schematic must not claim cross-short detection merely because two contacts are present. Where test pulses provide that diagnostic, each channel's pulse source, timing assumptions, input filtering, wiring topology, and shared-source limitation are part of `DEP-*`/`VAL-*`.

**Freeze:** `DUAL DRY CONTACT != CROSS-SHORT DETECTION`.

### SOURCE-CONFIRMED — OSSD behavior differs from dry contacts

SICK documents safety sensors with two self-monitoring semiconductor OSSD outputs. Its S3000 documentation shows that the device deliberately switches its OSSDs off briefly for internal tests and explicitly requires the receiving controller not to interpret those test pulses as a protective-field trip.

Rockwell's light-curtain guidance likewise states that many light curtains pulse-test OSSD1/OSSD2; if connected directly to safety-controller inputs, the receiver must filter those pulses appropriately. Rockwell safety-I/O documentation separately identifies a `Safety` mode for solid-state safety sensors and a `Safety Pulse Test` mode for contact devices used with controller test outputs.

**Freeze:** `SI-OSSD2` is not `SI-DRY2` with a different connector. Its electrical acceptance depends on the selected OSSD device and receiving input: OFF/ON thresholds, leakage/current behavior, output test-pulse width/period, receiver filtering, fault reaction, cable capacitance/loading, and supply/reference assumptions must be verified from the paired device/controller evidence.

**Freeze:** `OSSD TEST PULSE != PROTECTIVE-DEVICE DEMAND` when the selected manufacturer interface specifies that pulse as a diagnostic behavior and the receiver is qualified/configured to tolerate it.

**Prohibited inference:** never invent a universal OSSD pulse width or filter. SICK's documented values apply to the cited product; other devices may differ.

### SOURCE-CONFIRMED — input electrical thresholds are product-specific

Omron G9SP and NX safety-I/O documentation publishes concrete 24 V input ON/OFF thresholds, currents, test-output currents, residual voltages and leakage currents. Those values demonstrate the kind of interface data required for a real implementation, but they are product specifications rather than universal safety-input constants.

**Freeze:** the reusable family contract shall require an electrical compatibility table for the selected device pair; it shall not freeze universal voltage/current thresholds.

### DOC-CONFIRMED / architecture rule — discrepancy ownership must be singular and visible

Rockwell GuardLogix documentation allows dual-channel discrepancy checking either at the safety-I/O module level or in a dual-channel safety instruction and warns that configuring both can hide discrepancy diagnostics from the instruction.

**Freeze:** every `SI-*` instance shall declare where pair agreement/discrepancy is evaluated, the permitted discrepancy time if applicable, and which layer owns the fault latch/reset. Do not silently duplicate or split discrepancy authority.

## FS-IF hard-inhibit/service boundary

The existing curriculum authority rule remains valid: normal LinuxCNC/HAL/FPGA paths may request operation and consume diagnostics, but shall not acquire personnel-safety authority merely through software convenience.

For a safety-originated hard inhibit entering ordinary FPGA/controller hardware, freeze these implementation requirements before schematic capture:

1. The asserted inhibit has a hardware path to the affected command-enable boundary and dominates normal command generation.
2. No ordinary software register, host packet, HAL pin, normal FPGA state machine, boot default, debug command, or communications recovery can mask an asserted inhibit.
3. Reset/configuration/firmware-update states are analyzed explicitly. If FPGA configuration can temporarily remove the inhibit function, the machine architecture must remain safe through an independent final-element path; the FPGA path cannot be credited as the sole personnel-safety layer.
4. The diagnostic copy sent back to LinuxCNC is observation only. A matching status bit does not prove that the final energy path opened or that the physical safe-state proposition is true.
5. Service jumpers, JTAG/programming headers, manufacturing fixtures and test points capable of bypassing or forcing the inhibit are `DEP-*` safety dependencies. Production accessibility, labeling, restoration verification and commissioning checks are required.
6. A hard-inhibit implementation shall define behavior for loss of safety-side power, loss of normal-controller power, connector open circuit, short to normal supply/reference, FPGA reset/unconfigured state, and power restoration. Any case not established by circuit/device evidence remains `UNKNOWN`.

**Freeze:** `FPGA INHIBIT ASSERTED != PHYSICAL SAFE STATE PROVED`.

The hard inhibit can be one layer in an authority chain. Physical proof remains at the final-element/energy/hazard proposition appropriate to the SRS.

## Dependency / common-cause checklist before schematics

Each `SI-*`/`FS-IF` implementation shall trace at least:

- protective-device supply and safety-controller input supply;
- common 0 V/reference and any shared protection component;
- test-pulse source assignment and any shared pulse source;
- connector pins, cable bundle and field shorts between channels or to +24 V/0 V;
- surge/EMC/filter components shared by both channels;
- controller input threshold/filter resources;
- FPGA/safety-controller connector and shared grounds/supplies;
- FPGA reset/configuration/programming resources;
- service jumpers/debug headers/manufacturing fixtures;
- safety-output/final-element supply or pilot energy where the same supply failure could defeat both sensing and actuation;
- restoration after replacement, service or firmware/configuration change.

Redundant-looking channels sharing an unexamined dependency are not credited as independent.

## Per-family implementation-spec gate

### `SI-DRY2`

May proceed to a concrete implementation spec only after a selected safety-controller/input architecture establishes: input electrical thresholds/current, test-output behavior, cross-short coverage, channel source assignment, discrepancy handling, reset/fault behavior, and field wiring assumptions.

### `SI-OSSD2`

May proceed only after a selected OSSD device plus receiving input establish: compatible PNP/OSSD electrical interface, leakage/current/threshold limits, diagnostic test-pulse behavior and filtering, fault behavior, supply/reference requirements, discrepancy ownership and cable/loading limits.

### `SI-PNP-TP`

Remains intentionally source-dependent. Do not merge generic PNP sensing, controller-generated test pulses and self-testing OSSD semantics into one assumed circuit.

### `FS-IF`

May proceed to a schematic-level hard-inhibit instance only after the exact inhibited resource is named and the independent final-element architecture establishes what safety credit, if any, is assigned to the FPGA-side inhibit. Service/programming bypass analysis is mandatory.

## Sources

- Rockwell Automation, PointMax safety inputs/test outputs: https://www.rockwellautomation.com/en-us/docs/technical/i-o/current/5034-pointmax/_online/pointmax-i-o-modules-details-ditamap/safety-input-cip-safety-systems.html
- Rockwell Automation, 5069 safety input parameters: https://www.rockwellautomation.com/en-us/docs/add-on-profiles/ra-5069-safety-discrete/40/5069-safety-discrete-ditamap/points-view-input/points-view-params-input.html
- Rockwell Automation, Light Curtain safety instruction: https://www.rockwellautomation.com/en-id/docs/studio-5000-logix-designer/37-00/contents-ditamap/instruction-set/safety-instructions/light-curtain--lc-.html
- Rockwell Automation, GuardLogix input operation: https://www.rockwellautomation.com/en-hu/docs/technical/logix5000/_online/1756-rm012/guardlogix-5580-and-compact-guardlogix-5580-safety/safety-i-o/input-operation.html
- Pilz, PNOZ X2.8P operating manual 1004082-EN-17: https://www.pilz.com/download/open/PNOZ_X2_8P_Operat_Manual_1004082-EN-17.pdf
- Pilz, PNOZmulti PNOZ m EF 8DI2DOT operating manual 1004649-EN-06: https://www.pilz.com/download/open/PNOZ_m_EF_8DI2DOT_Oper__Man__1004649-EN-06.pdf
- SICK, S3000 operating instructions 8009942/ZD76/2025-08-19: https://www.sick.com/media/docs/3/63/863/operating_instructions_s3000_safety_laser_scanner_en_im0011863.pdf
- Omron, G9SP safety controller specifications: https://www.ia.omron.com/products/family/2937/specification.html
- Omron, NX-SI/SO safety I/O specifications: https://www.ia.omron.com/products/family/3244/specification.html

## Remaining UNKNOWN / next work

No universal OSSD/test-pulse circuit has been frozen. No PL/SIL target, diagnostic coverage value, discrepancy time, proof-test interval, stopping value, or machine-specific final-element behavior is inferred here.

Next: convert these freezes into explicit per-family implementation-spec templates, then perform an adversarial CCF/service-path review before any schematic is frozen. A real `FS-IF` schematic must wait until the exact safety-originated inhibit target and final-element authority chain are selected.