# Interposing Contactor / EDM / Backfeed Failure Boundary Study

Date: 2026-09-17
Lane: independent safety curriculum Lane B
Status: durable source/documentation study; no executable verification used

## Question

When a safety controller cannot or should not drive a hazardous-energy final element directly, what is lost or gained by inserting external contactors/relays, and what must be proven before the resulting chain may be credited as a safety function?

This study deliberately does **not** select OpenPressBrake hardware or assign PL/SIL/category/DC values. It defines evidence boundaries and failure questions.

## Frozen architecture distinctions

- `SAFETY OUTPUT OFF != CONTACTOR COIL DE-ENERGIZED != MAIN CONTACTS OPEN != HAZARDOUS ENERGY REMOVED`.
- `EDM FEEDBACK CORRECT != ALL HAZARDOUS ENERGY ABSENT`.
- `TWO CONTACTORS != TWO INDEPENDENT SHUTDOWN PATHS` unless wiring, power, control, feedback, common-cause exposure and final physical effect support that claim.
- `INTERPOSING RELAY PRESENT != SAFETY-RATED INTERFACE`.
- `AUXILIARY CONTACT CHANGED STATE != POWER CONTACT PHYSICALLY PROVEN OPEN` unless the selected device/contact relationship and application justify that inference.
- `OUTPUT COMMAND LOW != OUTPUT NODE ELECTRICALLY LOW`: a short/backfeed from another 24-V source can defeat an intended low state unless the architecture detects or otherwise controls that fault.

## Authoritative manufacturer evidence

### Pilz myPNOZ external-contact feedback

**DOC-CONFIRMED:** Pilz application note 1005677-EN-02 describes external contactors connected to myPNOZ outputs and N/C contacts from those contactors returned to the corresponding feedback loop. Those feedback contacts must be closed before starting; if an N/C feedback contact is open, the machine/plant cannot restart.

**DOC-CONFIRMED:** The same note states that, for a higher safety level in the shown application, two actuators are used. It also states that a short between 24 V DC and a safety output is detected as an error and the load can be switched off through the second shutdown route.

**DOC-CONFIRMED:** Semiconductor safety outputs are periodically tested using an off-test. Pilz separately warns not to route test-pulse wiring with actuator wiring in an unprotected multicore cable.

Source: Pilz, *myPNOZ: Signal forwarding to another myPNOZ*, application note 1005677-EN-02, section 3.2.3/3.2.5, current public PDF observed 2026-09-17.
https://www.pilz.com/download/open/myPNOZ_Signalforwarding_1005677-EN-02.pdf

### SICK Flexi Soft EDM behavior

**DOC-CONFIRMED:** SICK Flexi Soft Safety Designer provides an External Device Monitoring function block specifically to control an external device such as a contactor and check, from its feedback signal, whether it switched as expected.

**DOC-CONFIRMED:** Its two EDM outputs have the same logical value and can connect directly to two output elements. The EDM logic expects feedback to assume the inverted control state within the configured feedback delay; feedback disagreement produces an EDM error and removes the EDM outputs.

**BOUNDARY:** A configured feedback delay is application-specific. This study does not import any delay into OpenPressBrake.

Source: SICK, *Flexi Soft in the Safety Designer configuration software*, 8014519/T157/2025-07-30, section 10.2.7 External device monitoring.
https://www.sick.com/media/docs/3/83/083/operating_instructions_flexi_soft_in_the_safety_designer_configuration_software_en_im0081083.pdf

### Pilz PNOZ 16S feedback-loop blind spot

**DOC-CONFIRMED:** Pilz PNOZ 16S explicitly permits increasing available contacts using contact-expansion modules or external contactors/relays.

**DOC-CONFIRMED:** The same manual explicitly says the device does **not** recognize short circuits or shorts across contacts in the start/feedback loop and instructs the designer to use suitable measures such as fault exclusion through protected or separate installation.

This is important because an EDM loop is not automatically self-diagnosing merely because it is wired back to a safety relay.

Source: Pilz, *PNOZ 16S Operating Manual*, 1003518-EN-12.
https://www.pilz.com/download/open/PNOZ_16S_Operat_Manual_1003518-EN-12.pdf

### Pilz output-contact application boundary

**DOC-CONFIRMED:** Pilz PNOZ 1 wiring instructions distinguish safety contacts from an auxiliary display contact and explicitly prohibit using the auxiliary contact in safety circuits. The manual also requires output-contact protection against welding and suitable protection for capacitive/inductive loads.

Source: Pilz, *PNOZ 1 Operating Manual*, 21114-EN-06.
https://www.pilz.com/download/open/PNOZ_1_Operating_Manual_21114-EN-06.pdf

## Failure-path matrix

| Injected/credible fault | What a naive design may claim | Required evidence question | Safe curriculum disposition |
|---|---|---|---|
| One contactor power contact welds | `output OFF = power removed` | Does EDM use a suitable mechanically related/mirror feedback contact, and does the second shutdown path independently remove the hazard? | Do not permit restart until the failed final element is resolved. |
| Contactor coil wire shorts to +24 V | `safety controller commanded OFF` | Can the safety output detect external voltage/backfeed? Can an independent shutdown route still remove the hazard? | Treat command state and physical coil state separately. |
| Two contactor coils share one shorted supply/wire bundle | `two contactors = redundancy` | Can one wiring fault energize both? Are routes protected/separated where the safety assessment relies on independence? | Common-cause challenge required. |
| EDM loop shorted closed | `feedback says contactors open` | Can that feedback-loop fault be detected, or is protected/separate routing/fault exclusion required? | Preserve UNKNOWN until wiring and device diagnostics are known. |
| Auxiliary rather than suitable monitoring contact used | `aux changed = mains open` | What relationship between monitoring contact and main poles is guaranteed by the selected device? | Generic auxiliary indication is not physical final-element proof. |
| Interposing relay welds | `safety output itself is healthy` | Is the interposing relay included in the safety chain and monitored/duplicated as required? | Never hide it as mere interface glue. |
| Suppressor fails short | `coil simply de-energizes` | Does failure create fuse/open-circuit behavior or can it defeat another channel/common supply? | Include suppressor and protection in fault analysis. |
| Suppressor/filter changes release time | `OFF timing unchanged` | Is final-element release behavior within the machine validation envelope? | Measure/validate on actual hardware; do not invent time. |
| Safety output off-test reaches a relay/contactor coil | `24 V compatible` | Can pulse cause chatter/dropout, or can coil/input filtering mask diagnostics? | Source/receiver pulse contract required. |
| One power pole opens while another remains welded | `contactor is open` | Does the monitored contact prove the hazardous power path actually interrupted for this device/application? | Physical final-element proof remains distinct from Boolean EDM. |
| LinuxCNC/HAL reports contactor command OFF | `machine safe` | Is status derived from independent safety feedback or merely the ordinary command? | Ordinary control may display diagnostics but cannot create safety truth. |

## OpenPressBrake architecture implications

The following are **INFERENCE / design requirements to verify**, not statements of current hardware:

1. Any relay/contactor inserted between a safety controller and a hazardous-energy final element becomes part of the safety-function evidence chain. It cannot be treated as transparent glue.
2. Where two final elements are credited as independent shutdown paths, commissioning should challenge faults that could energize or falsely report both together: common +24 V shorts, shared return faults, cable damage, common suppressor/protection faults, and feedback-loop shorts.
3. EDM should inhibit safety release/restart when final-element feedback does not match the demanded state. EDM should not be promoted into a claim that hydraulic pressure, gravity load, motor torque, stored energy or personnel clearance is safe.
4. LinuxCNC/HAL/ordinary FPGA may consume EDM/status for HMI and ordinary sequencing. They must not be the sole authority that decides a personnel-safety final element has successfully reached its required state.
5. A commissioning record should identify exactly what feedback contact is observed, what physical element it is mechanically/electrically related to, what faults remain undetected, and what separate physical test establishes the actual hazardous-energy result.

## Provenance labels

- **SOURCE-CONFIRMED:** source identity and manufacturer provenance above.
- **DOC-CONFIRMED:** manufacturer behaviors explicitly described above.
- **TEST-CONFIRMED:** none in this study.
- **COMMUNITY-REPORTED:** none relied upon.
- **INFERENCE:** OpenPressBrake architecture implications above.
- **UNKNOWN:** actual OpenPressBrake safety controller/output topology, contactor/relay choice, monitoring-contact type, cable routing, output pulse behavior, coil suppression, EDM timing, final-element physical response, PL/SIL/category/DC and acceptance limits.

## What this study does not prove

It does not prove motor standstill, STO state, hydraulic isolation, ram restraint, residual pressure removal, safe stopping distance/time, personnel clearance, maintenance isolation, or the suitability of any specific OpenPressBrake relay/contactor. Those require the selected architecture and physical machine evidence.

## Next independent evidence target

Trace a real professional safety chain in which an electronic safety output drives two external contactors/relays and the documentation exposes: output short/backfeed diagnostics, final-element feedback contact type, feedback-loop fault assumptions, restart inhibition, and the physical hazardous-energy path being interrupted. Prefer a manufacturer application with complete wiring rather than another generic EDM description.

If the primary lane reaches that chain first, rotate to a **contactor monitoring-contact physical-proof study** (mirror/positively driven contacts versus ordinary auxiliaries) or a **safety-output backfeed/common-supply fault injection worksheet**, without touching the primary hydraulic/fall-protection files.