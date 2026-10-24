# 4400-NET-02 — TwinSAFE SC: safety communication of standard sensor data is not a single-channel safety sensor
**Date:** 2026-10-24. **Status:** source-scope audit / NON-GRADUATED. **Relevance:** safety-related position, speed, temperature or pressure sensing, including press-brake Y1/Y2, but **no selected OpenPressBrake hardware asserted**.

## Sources and evidence quality
1. **Beckhoff InfoSys, TwinSAFE SC — configuration**, official live documentation: https://infosys.beckhoff.com/content/1033/ej3124-0090/2299896587.html . **Directly inspected**, DOC-CONFIRMED: TwinSAFE SC uses a *distinct* CRC to distinguish SC from ordinary TwinSAFE connections; the channel is **not enabled by default**; configured safety address and CRC must match on the alias device and CoE objects; separate SC connections require distinct CRC choices. A successful SC telegram therefore depends on exact configuration, but does not itself prove that the physical transducer is correct.
2. **Beckhoff, EL33xx EtherCAT Terminals documentation, version 5.1, original manufacturer PDF, printed p.148**: https://download.beckhoff.com/download/Document/io/ethercat-terminals/el33xxen.pdf . **Manufacturer-indexed excerpt; full PDF NOT directly inspected in this run.** The indexed text states that EL3314-0090 TwinSAFE SC standard thermocouple data are passed to TwinSAFE Logic for multi-channel plausibility checks and voting (examples 1oo2, 2oo3, 3oo5), with at least one TwinSAFE SC source; *typical* achievable PL d/Cat.3 or SIL2 is conditional, not automatic. Treat specific ratings as **manufacturer-indexed DOC-REPORTED, NOT verified installation or independent certification**.
3. **Beckhoff, TwinSAFE Application Guide version 3.5.0**, https://download.beckhoff.com/download/Document/automation/twinsafe/application-guide_twinsafe_en.pdf . **Manufacturer-indexed excerpt only**; full ~12.7 MB PDF rejected by reader. The indexed definition says TwinSAFE SC packages standard-terminal signal into FSoE and requires comparison against a further independent signal in TwinSAFE Logic; it explicitly excludes single-channel-only use and digital inputs for this technology. Do **not** elevate the excerpt into a complete normative proof.
4. **Beckhoff product description, ELX3152-0090**, https://www.beckhoff.com/nn-no/products/i-o/ethercat-terminals/elxxxx-0090-twinsafe-sc/elx3152-0090.html . Official product page confirms a TwinSAFE SC variant of an analog input and describes the use of standard signals for safety tasks; product specifications are not a machine safety function assessment.
5. [NET-01 original safety network source audit](4400_BECKHOFF_FSOE_VS_ORDINARY_ETHERCAT_WATCHDOG_REACTION_TIME_SOURCE_AUDIT_2026-10-24.md) for the separate communication watchdog and physical final-element boundary.

## Engineering discriminator
```text
ordinary transducer A -> special TwinSAFE SC interface -> checked SC transport --+
                                                                          safety logic -> safe output -> final element
independent transducer B -> independent acquisition/diagnostic route ---------+
```
**Critical distinction:** making one standard sensor value survive a transport integrity check does not make the *measurement* intrinsically trustworthy. A sensor stuck at a plausible value, shared reference/power, mechanical coupling fault, common mounting slip, incorrectly mapped Y1/Y2 or duplicated channel can yield a perfectly valid CRC carrying a wrong physical quantity. These are **INFERENCE** fault examples, not claims about installed Beckhoff equipment.

**DOC-CONFIRMED direct config:** SC must be explicitly enabled, addressed and CRC-matched. **Manufacturer-indexed only:** independent comparison/voting is part of the documented architecture; exact performance claims require full original application guide, certified components and machine-level risk assessment. **UNKNOWN:** chosen sensor independence, diagnostics, reaction latency, voting behavior under faults, safe output response and physical load holding.

## Failure-path table
| Fault | Communication can remain valid? | What must be demonstrated |
|---|---|---|
| Thermocouple/encoder stuck at plausible constant | Yes, INFERENCE | Independent diverse measurement and discrepancy response |
| Two sensors share a broken supply/reference | Potentially, INFERENCE | Common-cause assessment, independent power and physical wiring |
| Both channels map to Y1 instead of Y1 and Y2 | Yes, INFERENCE | As-built physical sensor-to-axis mapping witness |
| SC CRC/address mismatched | Expected communication fault per OEM configuration, not experimentally run | Exact SC status/diagnostic and safe output reaction |
| Operator selects one SC source only | Manufacturer-indexed application-guide warning against single-channel-only use | Qualified multi-channel safety architecture and assessment |
| SC value disagrees with ordinary LinuxCNC display | No definitive truth from either UI | Qualified independent physical measurement |
| Two sources agree while gravity ram drifts | Possible common-mode sensor/holding error | Independent final-element and load-holding proof |

## Human-factors and cost choice
For simple machines, use a proven dedicated safety sensor pair and independent safety relay/PLC where it is practical and sufficient; avoid inventing 'safe sensing' from a normal analog LinuxCNC channel. If analog safety processing is justified, procure a documented SC-capable product and design **real sensor independence**, diagnostics, physical mapping, change control and maintenance. Make the diagnostic display show **A, B, disagreement, channel identity and fault**, not only a single reassuring green safety icon. Provide safe, accessible sensor calibration and replacement so a technician is not incentivized to force a constant value or bypass disagreement.

## Information-gain stop
No simulation, bench, physical test or certification claim. Full Beckhoff application guide was not directly inspected; its indexed excerpt is preserved as lower-strength evidence. Reopen for exact certified device/manual revision, independently assessed sensor architecture, qualified source-to-axis wiring witness, safe output and protected physical stop/hold. No invented PL/SIL, pressure threshold or stopping distance.
