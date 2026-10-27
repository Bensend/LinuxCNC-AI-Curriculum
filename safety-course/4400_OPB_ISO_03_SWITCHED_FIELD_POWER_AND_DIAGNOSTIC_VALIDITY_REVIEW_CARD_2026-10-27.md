# 4400-OPB-ISO-03 — switched field supply and diagnostic validity: one-pass reviewer card
**2026-10-27 | PUBLIC SOURCE-TRANSFER / NON-GRADUATED | No new unscored case bank or documentary gate count**

This card distills the [exact STISO621/STISO620/IPS1025H and OpenPressBrake source audit](../research/4400_OPB_L7_L07_ISOLATOR_POWER_LOSS_FAULT_DIAGNOSTIC_POLARITY_SOURCE_AUDIT_2026-10-27.md). Use it only for the proposed **ordinary** digital-output interface; independent Pilz/AKAS, safety valves, physical ram restraint and safe access remain separately qualified.

## Four distinctions the reviewer must keep separate
1. **A logic LOW is not always a healthy measurement.** STISO620 transmits FLT2 from the switched field side to the still-powered FPGA side. If the field transmitter loses power, its receiver can report LOW after a 2–8 microsecond device watchdog. That may mean **diagnostic unavailable**, not “no overload.” The exact FPGA/HMI interpretation is UNKNOWN.
2. **Receiver unpowered is not receiver driving LOW.** STISO621's process receiver has no guaranteed output when its process supply is below UVLO; STISO620's unpowered logic receiver is TRI-STATE. The intended local IPS input pull-down is an ordinary output-bias mechanism, not personnel-safety isolation.
3. **Device shutdown is not zero physical current.** IPS1025H documentation distinguishes VCC disconnection (active output can persist until UVLO) from GND disconnection (output disabled but small OUT current may remain). Neither device behavior proves hydraulic load holding or guard protection.
4. **Diagnostic name is not signal truth.** Older Rev1 isolated-interface prose maps FLT1→OVERLOAD and FLT2→OVERTEMP, while the IPS1025H manufacturer and newer Rev2/manifest say FLT1→OVERTEMP and FLT2→OVERLOAD. Treat as a documented source contradiction; reconcile netlist, firmware, polarity and HMI with final design authority before relying on diagnostics.

## Review sequence, no energized machine work
| Existing gate | Evidence the qualified reviewer should inspect | Unresolved decision |
|---|---|---|
| OPB-D06 — switched L7/L07 | As-built 11K2 poles, process 24 V and process 5 V sources, separate L07 return, no alternate feed/bridge. | Is the intended field domain actually isolated from unswitched logic and alternate sources? UNKNOWN |
| OPB-D01/D03 — normal status | Exact FLT1/FLT2 pins, STISO channel directions, FPGA and UI polarity, valid-power status and stale/invalid behavior. | Is a LOW status healthy, absent power or invalid? UNKNOWN |
| OPB-D08 — physical protection | Independent safety-controller application, safety final elements, Y1/Y2 stop/hold, guards, hydraulic energy and separate reset/restart. | Does the machine reach its defined safe state independently of ordinary FPGA and its diagnostics? UNKNOWN |
| G0 — release documentary readiness | Qualified reviewer role, machine revision, contradictory-source resolution, physical witness plan and restricted evidence links. | HOLD until consistent machine-specific evidence; G0 does not authorize live G1/G2 tests. |

**Do not:** count STISO isolation approvals as a machine safety rating; copy component 2–8 µs watchdog timing into a stopping-distance calculation; infer “zero coil current” from IPS ground-disconnection behavior; assume a fault pin is active-low from its `_L` name; or bridge L07 to L06 to simplify troubleshooting.

**Practical anti-defeat design:** clearly show “switched field supply absent / output diagnostics INVALID” instead of a misleading green healthy icon, keep guard reset independent of normal HMI status, and provide an easy approved service path. All selected-machine evidence remains UNKNOWN; no private drawings or PLC programs belong in this public curriculum. **G0/G1 HOLD; no personnel-exposed hazardous operation.**


**Bidirectional STISO621 caution (same-session original schematic recheck):** ST's March 2025 X-NUCLEO-ISO1A1 schematic page 2 shows the STISO621 simultaneously carries a command **logic→field** and FLT1 diagnostic **field→logic**. On switched-field power loss with logic still powered, its **field command receiver is unpowered/UNKNOWN**, but its **logic FLT1 receiver can settle LOW after the 2–6 µs watchdog**. The STISO620 FLT2 logic receiver can also settle LOW after 2–8 µs. **Both** diagnostic channels therefore need field-power-invalid handling, not only FLT2. Reference: https://www.st.com/resource/en/schematic_pack/x-nucleo-iso1a1-schematic.pdf . No personnel-safety credit or as-built validation.


**Power-return trap — conditional, not a machine observation:** With FPGA logic still powered, a HIGH ordinary command may persist while 11K2 removes L7/L07. When the field domain is restored, STISO621 resumes transmitting the **existing** command after its startup conditions; the isolator does not require a new command edge. A qualified reviewer must establish that the **independent** safety system enforces appropriate fresh-start/rearm and that normal controller outputs are managed on field-power loss/return. A software clear bit or HMI green icon alone is not independent restart protection. No actual held-command behavior, hydraulic response or reset program is established. [Source-derived timeline](../research/4400_OPB_L7_L07_ISOLATOR_POWER_LOSS_FAULT_DIAGNOSTIC_POLARITY_SOURCE_AUDIT_2026-10-27.md).


**Input-side companion (TI ISO1212, Feb 2025, Table 7-2):** an **open field IN/SENSE** reports **LOW** while the FPGA-side receiver remains powered; that LOW cannot distinguish a legitimate inactive Pilz status from a broken wire or absent source. TI's TIDA-01509 achieves broken-wire discrimination with **additional circuitry**, not an inherent extra “wire broken” bit from a basic ISO1212 input. The published OpenPressBrake DI manifest makes `INPUT_VALID` optional; no installed wire-break/rail-valid mechanism is established. Inspect qualified as-built evidence before labeling a collection of all-LOW status bits “safe.” [Source audit addendum](../research/4400_OPB_L7_L07_ISOLATOR_POWER_LOSS_FAULT_DIAGNOSTIC_POLARITY_SOURCE_AUDIT_2026-10-27.md). The independent safety PLC and physical hold/guard evidence remain separate.


**11K2 two-pole single-contact fault check (paper only):** The published Rev1 board map calls 11K2 a two-pole L7/L07 switch. An L7-positive-only weld/cross-feed with L07 open invokes a **different** IPS1025H manufacturer ground-disconnection case than an L07-return-only weld with L7 open (VCC-disconnection case). Neither proves zero coil current, physical load holding, or redundant safety function. Ask for existing as-built 11K2 part/contact/feedback, wiring and independent hydraulic final-element evidence. No contact-weld fault injection or live bridging; [source-specific matrix](../research/4400_OPB_L7_L07_ISOLATOR_POWER_LOSS_FAULT_DIAGNOSTIC_POLARITY_SOURCE_AUDIT_2026-10-27.md).


**Do not copy TI's wire-break demo into L07.** Direct TIDA-01509 Rev A guide (May 2025) shows its added opto-emulator **temporarily opens the ISO121x field-ground path** to elicit a diagnostic pulse. That technique is a reference-board mechanism, **not** proof it is compatible with a retained shared Pilz/11K2 return or other safety wiring. A technician must not interrupt/bridge L07 to “test” status validity; ask for the as-built qualified design and preserve independent safety ownership. [OEM source and transfer-limit audit](../research/4400_OPB_L7_L07_ISOLATOR_POWER_LOSS_FAULT_DIAGNOSTIC_POLARITY_SOURCE_AUDIT_2026-10-27.md).


## Human-factors normal-diagnostics display contract — three-valued, **not** a safety PLC design
| Process supply / source validity | FLT1/FLT2 or Pilz status bits | Honest ordinary HMI meaning | Personnel-safety decision |
|---|---|---|---|
| **VALID by independently reviewed normal diagnostic evidence** | Driver fault not asserted | “No *reported ordinary driver fault*” — never “safe ram” | Independent Pilz/AKAS and physical stop/hold/guard still required. |
| **INVALID / UNKNOWN** (L7/L07 absent, broken wire possible, validity mechanism unresolved, startup transient) | LOW or stale/unknown | “FIELD POWER/STATUS UNAVAILABLE — NOT VERIFIED”; suppress green healthy and auto-resume suggestions. | **HOLD**; no ordinary HMI permission to expose people. |
| **VALID** | Qualified driver fault asserted | Specific fault class only after FLT1/FLT2 mapping and polarity reconciliation; maintenance workflow with isolation. | Independent safety remains authoritative. |
| **RESTORING** after 11K2 returns | Held ordinary command, settling inputs | “REARM REQUIRED”; normal output management and fresh operator intent reviewed separately. | Independent safety reset must not by itself initiate hazardous motion. |

This is a **proposed ergonomic information-state model (INFERENCE)** for the ordinary UI, not a verified FPGA implementation, a safety-function truth table, or authorization to modify the safety PLC. The qualified machine team must define actual validity and fault behavior from final wiring, physical proof and risk assessment. Keep maintenance and guard-restoration workflow easy and visibly distinct from mere program Pause/Resume.


**Board-design handoff, not safety approval:** IPS1025H FLT current-source clamp spec (up to 8 V under a stated test) and STISO621 input absolute maximum (7 V) pose a **bounded worst-case interface-voltage question**, even though ST's own X-NUCLEO-ISO1A1 reference connects FLT1 to STISO621. Do not infer a real overvoltage from two standalone limits; request full final-netlist/current-path/input-protection qualification from the separate board-design lane. This does not change Pilz/AKAS safety authority or justify an energized fault injection. [Exact source audit](../research/4400_OPB_L7_L07_ISOLATOR_POWER_LOSS_FAULT_DIAGNOSTIC_POLARITY_SOURCE_AUDIT_2026-10-27.md).
