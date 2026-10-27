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
