# 4400 — Safety-controller 0 V loss: unintended actuator energization and false-safe input state

**Research status:** Original manufacturer-document source reading, 2026-10-24 UTC. **DOC-CONFIRMED** describes the manufacturer statements below; **INFERENCE** describes proposed machine-level consequences. No selected OpenPressBrake hardware, physical fault, validation, test or performance level is established.

## Why this is a new safety lesson

A dual-channel safety controller can be correctly programmed yet have a hazardous electrical common-cause dependency. **A shared return conductor is not merely an availability issue.** In its own operating instructions, SICK explicitly warns that loss of a common GND can (1) cause a connected relay/actuator to switch unintentionally and (2) allow parallel safety inputs to indicate an unintended high state through reverse current. A green logic status, dual inputs, or an ordinary LinuxCNC `SAFETY_OK` indication cannot rebut either physical mechanism.

This is distinct from the existing 4400 Pilz safe/aux/test-pulse *terminal-role* lesson, the Rockwell contactor coil-suppression/AC long-cable lesson, and the SICK scanner EFI field-bit lesson. Here the failed common reference changes **electrical interpretation of otherwise correctly selected terminals**.

## Original sources and provenance

1. **SICK**, *Flexi Soft Modular Safety Controller — Hardware*, operating instructions **8012478/1WLY/2026-05-05** as printed in the web-extracted source, §§6.1–6.2 (printed pp.51–53), §6.4.5 (p.89), §11.3–11.5 (pp.123–125). Manufacturer PDF: https://www.sick.com/media/docs/0/60/660/operating_instructions_flexi_soft_modular_safety_controller_hardware_en_im0031660.pdf . The public URL is mutable; retrieval tools exposed inconsistent historical footers in some page renders. Therefore **the PDF edition must be verified from actual saved original bytes before machine-specific qualification**. The specific warnings below are present in the manufacturer text extracted from this URL; do not treat the URL alone as an immutable edition checksum.
2. **SICK**, *Safe Linear Positioning*, original instructions **8020941/1FB9/2022-07-19**, §13.2 printed p.80, manufacturer PDF https://www.sick.com/media/docs/0/30/030/operating_instructions_safe_linear_positioning_en_im0081030.pdf . The original page table was visually checked and explicitly distinguishes hardware versions. This is a *separate SICK application* using FX3-XTIO; it is not a specification for every Flexi Soft generation.
3. **OSHA**, 29 CFR 1910.147(b), (d)(5)–(6): https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147 . Maintenance energy isolation is separate from safety-control wiring and diagnostics.

## Manufacturer findings: narrowly stated

| Source location | DOC-CONFIRMED OEM statement | Incorrect transfer to reject |
|---|---|---|
| Flexi Soft §6.1, printed p.52 | SICK directs **star-form GND connections** for actuators connected to Q1–Q4. It warns that if the common GND conductor breaks while at least one output is high and another is low, an actuator such as a relay **could switch unintentionally**. | 'A low safety output always guarantees its coil is physically off.' |
| Flexi Soft §6.1, printed p.53 | If multiple safety inputs are wired in parallel, **reverse current after GND loss may create an unintended high input**; the designer must assess the risk and actual technical data. | 'Two high safety inputs necessarily mean both sensors are healthy.' |
| Flexi Soft §6.1, printed p.52 | SICK calls for compatible common ground among modules, protective devices and supplies; RS-232 GND is internally connected to module A2, so ground-loop avoidance matters. | 'Adding any arbitrary second 0 V/earth link always improves safety.' |
| Flexi Soft §6.2 and module descriptions, printed pp.24–31, 53 | Main-module logic and some module output supplies have **distinct supply paths**. FX3-XTIO Q1–Q4 outputs are supplied at the I/O module's A1/A2; logic/test outputs have other paths. | 'CPU RUN LED means every safety output has the correct supply and return.' |
| Flexi Soft §6.1, printed p.52 | The external supply is specified to bridge brief **20 ms** failures; inductive suppression can extend response time. | '20 ms is a universal allowable safety stop delay or all PLCs tolerate the same dip.' |
| Flexi Soft troubleshooting printed p.124 | Error **0x002D4006** lists supply dips and load switching as possible causes, and calls for checking supply wiring/other heavy loads; **0x003E4006** identifies a FLEXBUS+ restart/EMC class. | 'A restart or error log proves the physical load was safely stopped and held.' |
| Flexi Soft §11.5 printed pp.124–125 | A common GND/encoder-supply path can defeat redundancy of both monitored encoders; common reference and supply must be included in common-cause analysis. | 'Two encoders imply two independent physical measurement channels.' |
| Safe Linear Positioning §13.2 printed p.80 | Under loss of GND, the OEM lists **max 20 mA** reverse input current for XTIO hardware **< V1.10.0** and **max 2 mA** for **≥ V1.10.0**. | '2 mA or 20 mA is an acceptable universal design value, proof of false-high, or an OpenPressBrake measurement.' |

**Interpretation of the 20/2 mA distinction:** this is a hardware-version-specific *maximum reverse-current specification*, **not** a measured false-high threshold for any actual wiring. A physical false-high requires the actual circuit, sensor output impedance, topology and receiver input threshold. The source warns of the hazard; it does not prove every GND break will cause it.

## Failure-path / causal analysis (INFERENCE unless OEM says otherwise)

1. A shared actuator return is routed through a removable terminal or common cable. The normal controller continues to display RUN; one safe output remains high while another is commanded low. A return opens. **Manufacturer-identified possibility:** the unintended path can energize an actuator. **UNKNOWN:** which selected final element, if any, would energize, whether its hydraulic/drive response is hazardous, and whether the machine has independent detection.
2. Parallel safety-input commons share a return with other I/O. An open return permits reverse-current coupling and an unintended high indication. **UNKNOWN:** exact input thresholds, diagnostic reaction and whether a dual-channel discrepancy is detected.
3. Both 'redundant' speed encoders share one reference/supply. A common loss can make both invalid at once. **INFERENCE:** relying on the normal LinuxCNC motion feedback to declare a safety stop could hide this common cause; actual safe-speed function and its independent sensor architecture must be established.
4. A 24 V load starts or an output supply dips. SICK troubleshooting associates such conditions with controller restart/diagnostics. **INFERENCE:** after supply restoration, reset ownership and stale ordinary motion commands must be assessed separately; a power-up indication is not a physical holding witness.
5. A technician adds a second ground jumper to suppress nuisance faults. It may create a ground loop or change diagnostic behavior. **UNKNOWN:** suitability until the exact OEM installation, EMC and electrical schematic are reconciled.

## Practical architecture review: make the correct installation easiest

- **Identify actual hardware first:** controller family, FX3 module and hardware version, safety project/CRC, every A1/A2 supply, Q1–Q4 output, coil/actuator and feedback target. Do not assert that SICK hardware is installed on OpenPressBrake.
- **Draw separate paths:** safety PLC logic supply, safety-output supply, actuator 0 V return, sensor 0 V return, functional earth/protective earth, network shield, normal LinuxCNC/FPGA supply, and each physical hazardous-energy path. Mark every *shared* conductor/terminal/fuse.
- **Apply the exact OEM return topology** rather than copying a generic ground-star sketch. Provide durable wire numbers, accessible terminals, strain relief, documented routing and keyed/labelled connectors; eliminate loose or hidden common-return splices that predictably invite shortcuts.
- **Keep normal control separate:** LinuxCNC may read safety status and inhibit ordinary commands, but must not be the only safety demand/diagnostic or the only path that de-energizes a final element.
- **Prevent unsafe recovery:** after any supply loss, ground fault, controller reset or wiring change, invalidate ordinary queued motion; require the actual safety controller's justified reset/rearm sequence and a distinct deliberate new start. The OEM's logic RUN status is not a substitute for the physical stop/hold/occupancy witness.
- **Make inspection non-hazardous:** review drawings, manufacturer instructions, terminal continuity and power topology with qualified electrical isolation and proper instruments. **Do not pull a 0 V wire on an energized press brake** as a curriculum fault-injection test. If a hardware validation is later justified, a qualified team must design an isolated/remote test with people outside the danger zone.

## Transfer across machine classes

- **Press brake:** a false-high input or unexpectedly energized valve/contactor could invalidate an assumed Y1/Y2 stop; gravity hold and hydraulic isolation remain separate.
- **Mill/lathe:** an unintended contactor or drive-enable path could invalidate guard/spindle safety assumptions; coast-down and tool/workpiece hazards still need physical witnesses.
- **Plasma/laser:** a false-ready interlock can coexist with electrical, optical, fire or fume hazards; ordinary torch-enable status is not safety proof.
- **Robot/automated cell:** a shared 0 V/supply/encoder reference can undermine independent protective-zone and safe-motion assumptions; verify actual safe motion and occupancy.
These are **failure hypotheses**, not reports of actual installations.

## Evidence and release disposition

- **DOC-CONFIRMED:** exact statements in the two named SICK original manufacturer documents; OSHA energy isolation rule.
- **SOURCE-CONFIRMED:** no new LinuxCNC source inspected; existing pinned `estop_latch` and NML traces remain ordinary control only.
- **TEST-CONFIRMED:** none; no powered experiments, simulations, workflow compute or physical machine observation.
- **COMMUNITY-REPORTED:** none relied upon.
- **INFERENCE:** shared-return cutover review, proposed low-friction wiring/labeling, restart interlock and cross-machine transfer.
- **UNKNOWN:** selected machine controller and revision, as-built 0 V/PE/FE, exact coil paths, input topology, current/threshold, actual safety function, response time, PL/SIL, hydraulic stop/hold and physical verification.

**Open selected-machine gate:** add an `IN-04k` conditional supply/return/ground/common-cause inventory and physical witness; `VAL/PT NOT RUN`, `G0/G1 HOLD`, `G3/G4 NOT AUTHORIZED`. No personnel-exposed hazardous operation. Maintenance requires separate lockable isolation, stored-energy control and qualified verification; control-circuit de-energization is not LOTO.
