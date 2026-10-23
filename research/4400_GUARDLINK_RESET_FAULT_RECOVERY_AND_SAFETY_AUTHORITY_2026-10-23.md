# 4400 — GuardLink reset, fault recovery, topology changes and safety authority

**Status:** source/documentation investigation, NOT a selected-machine design, no physical tests. Session started 2026-10-23T00:34:46Z. Prerequisites: 2520, 2530, 2550, 2560, 2590 and 4400 safety boundary. 1000/2000/3000 remain CLOSED; 2520–25F0 information-separated evaluation gates remain OPEN.

## Question frozen before reading the selected manuals

A builder has six frequently opened guard devices in a series-capable diagnostic chain and wants to expose `Reset`, `Fault Reset`, `Unlock`, and `Lock` controls on a LinuxCNC HMI. What, exactly, do those controls establish? Can a recovered GuardLink chain or a green HMI indication justify rearming hazardous motion? How does a replacement tap affect the evidence?

**Finding:** The manufacturer documents **different commands with different scopes**. Fault recovery, relay reset, guard-lock actuation, diagnostic status, GuardLink operational state, safety-output state, physical hazard cessation, and ordinary cycle start are distinct. The 440R-ENETR interface is explicitly **not safety-rated**; a separate manufacturer-supported 432ES-IG3 architecture uses **CIP Safety** and cannot be conflated with it. These facts preclude assigning personnel-safety authority to an ordinary LinuxCNC HMI or an ENETR status tag.

## Sources, editions and exact applicability

1. Rockwell Automation **GLINK-AT001A-EN-P, July 2023**, *GuardLink Systems Application Technique*, official manufacturer PDF: https://literature.rockwellautomation.com/idc/groups/literature/documents/at/glink-at001_-en-p.pdf . Inspected rendered pp. 5, 7–9 and extracted pp. 3–13. Covers 432ES-IG3, 440R-DG2R2T, 440R-ENETR and selected taps. **DOC-CONFIRMED** for these product families, not selected-machine behavior.
2. Rockwell Automation **440R-UM009E-EN-P, February 2026**, *Guardmaster EtherNet/IP Network Interface User Manual*, official PDF: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/440r-um009_-en-p.pdf . Inspected rendered pp. 39, 62, 65, 75; extracted pp. 6, 39, 63–65, 75. Covers **440R-ENETR Series B**. **DOC-CONFIRMED**.
3. Rockwell Automation **440R-UM015J-EN-P, June 2025**, *Guardmaster DG Safety Relay and GuardLink System User Manual*, official manufacturer PDF: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/440r-um015_-en-p.pdf . Manufacturer-indexed text of Chapter 1 reviewed; full 36+ MB PDF could not be fetched through available reader. **DOC-CONFIRMED with extraction limitation** only where corroborated by source 1; source 2 is controlling for the newer ENETR command descriptions.
4. ISO **ISO/TR 24119:2015** official scope: https://www.iso.org/standard/63160.html . Its potential-free-contact physical-series scope is narrower than every electronic diagnostic chain. **DOC-CONFIRMED for public abstract only**. No uninspected normative clause or numeric diagnostic coverage inferred.

## Architecture A versus B — do not mix their safety communications

| Architecture | Safety-related decision path | Ordinary diagnostic/control path | Evidence / limit |
|---|---|---|---|
| 440R-DG2R2T + GuardLink taps + 440R-ENETR | DG safety relay evaluates GuardLink and other inputs, output monitoring and reset; final elements remain separately required | ENETR communicates relay/tap status and non-safety commands to machine controller over EtherNet/IP | GLINK-AT001A pp. 3–4, 8–9; 440R-UM009E p. 75 explicitly says ENETR **not safety-rated** |
| 432ES-IG3 GuardLink network interface | Manufacturer describes three GuardLink channels connected to safety-rated controller via **CIP Safety** | Additional ordinary status/diagnostic data may coexist | GLINK-AT001A p. 3; exact 432ES-IG3 configuration, CIP Safety controller, safety task and validation remain UNKNOWN |

**Boundary:** EtherNet/IP is a transport name, not a universal safety classification. The first path's ENETR reset commands do not turn LinuxCNC into a safety controller. The second path must not be described as 'diagnostics-only' merely because it also reports status. Neither architecture establishes machine stopping, gravity-load restraint, occupancy or maintenance isolation without the actual downstream physical evidence.

## Exact input and fault semantics

| Selected tap | Electrical input class | Diagnostic performed by tap | Recoverable discrepancy rule | Recovery per manufacturer |
|---|---|---|---|---|
| GuardLink OSSD tap (e.g. 440S-SF5D family) | Two OSSD outputs from a safety device | **Tap does not perform OSSD signal testing**; connected OSSD device must perform its tests | Inputs disagree for **3 seconds or more** -> recoverable fault | Both inputs LO, then HI |
| GuardLink EMSS tap (e.g. 440S-MF5D family) | Two voltage-free contacts | Tap applies 24 V and pulse-tests contacts | Opening or closing channels outside **10-second simultaneity window** -> recoverable fault | Both contacts cycled open, then closed within 10 seconds |
| Passive tap | Built-in GuardLink device | Passes GuardLink signals | Not interchangeable with OSSD/EMSS | Follow exact supported device instructions |

Evidence: GLINK-AT001A p. 5 (PDF index 4), original rendered table. The **3 s and 10 s are device-family diagnostic windows, NOT permitted human exposure times, machine stopping limits, or acceptable discrepancy targets for another architecture**. The exact selected devices, upstream test pulses, downstream receiver and installed wiring must still be qualified.

## Four different commands (440R-UM009E p. 39)

| ENETR output tag | Manufacturer-defined action | Crucial boundary |
|---|---|---|
| `Reset1` | Sends a relay reset equivalent to pressing a reset-terminal pushbutton; only Optical Link 3; pulse 0.25–3 s | A relay reset request is not evidence of deliberate human actuation, clear safeguarded space, or separate ordinary start. The relay's configured reset mode still matters. |
| `FaultReset` | Power-cycles the relay, only Optical Link 3 | Fault clearing/reinitialization is not safe rearm or physical stop/hold proof. |
| `GuardLinkx.FaultResetCmd` | Power-cycles **one tap and its connected device**; only one tap at a time | An HMI may trigger device reboot, transient loss of diagnostics, and later recovery; it cannot declare the machine safe. |
| `GuardLinkx.UnlockCmd` / `LockCmd` | Requests guard-lock actions at selected taps (or all taps) | Lock command != physical lock engaged; unlock command != hazardous motion stopped; do not repurpose for a safety stop. |

The manual also distinguishes monitored-manual reset (OFF -> ON -> OFF, acceptance on trailing edge) from automatic/manual reset (input ON may be sufficient; hard-wired 24 V can reset immediately when inputs become active), p. 6. **No generic reset design may assume every product requires a fresh trailing edge.** Selected DG configuration and personnel-safety reset/restart allocation must be reviewed.

## State-machine distinction and fault recovery

GLINK-AT001A pp. 8–9 defines `Initialization`, `Safe`, `Operational`, `Fault`. Initialization checks node count, firmware compatibility and terminator; it does **not** go directly to Operational. On a protective demand a tap stops the safety signal, the interface recognizes loss, and the CLU line puts all taps into safe state. To return Operational, all taps must be ready and a dynamic signal must propagate back. **Even when GuardLink is Operational, DG safety outputs can be OFF** depending on other inputs, feedback monitoring and reset. When outputs turn OFF, actual final-element reaction and machine hazard response require separate evidence.

`FaultResetCmd` is not a universal 'fix': the 2026 ENETR manual explains that in GuardLink 1.0 the DG knows the tap is OFF but may not know whether the connected device has faulted. Its example sequentially power-cycles taps, with a **3-second example wait** for startup self-test between commands (p. 63). This is **example application logic**, not a universal recovery delay or safety-rated reset. A physical cause of a recurring fault must be diagnosed rather than repeatedly masked by automatic power cycles.

### Firmware-specific nonlocking-device command trap

440R-UM009E p. 62 distinguishes DG firmware **1.01.1 / 1.02.1** (an unlock command to a nonlocking tap may hold the GuardLink signal OFF until a lock command clears it) from **1.02.0 / 1.03.1 / 1.04.8** (a lock/unlock command to a nonlocking device can produce a **brief safe-state transition and then return to Operational**). These version-specific manufacturer observations make an ordinary HMI lock/unlock command **unsuitable as a substitute for a protective stop or lockout**. No machine-specific output timing or actual stopping distance is claimed.

## Replacement and topology — recovery does not close change control

GLINK-AT001A p. 7 states that replacing a tap with the **same type while the link is powered** can automatically recover the GuardLink circuit after reconnection. Changing tap type or number requires DG relearning by power cycling; with ENETR, its power and AOP must be updated; with 432ES, channel/interface power and AOP are handled differently. The same manual requires the specified GuardLink terminator at the last tap (p. 6). **Automatic link recovery does not establish that maintenance work may be done energized, the guard is mechanically correct, the actuator is correctly paired, the downstream final element is safe, or the machine can restart.** Any service must obey its independent energy-isolation and revalidation requirements.

### Worked qualitative fault path (INFERENCE, not a machine test)

1. Rear cell guard opens; tap withdraws GuardLink signal. The DG demands its documented safe-output behavior. Physical motion, pressure and occupancy still require independent machine-level witnesses.
2. Technician replaces a same-type tap; link re-establishes automatically. Operator sees a green diagnostic display. **Do not infer that the safety function is validated after replacement**; preserve `CHG-*`, inspect installation and exercise the actual protective function under an authorized safe commissioning plan.
3. HMI fault-reset routine power-cycles a device and then auto-issues `Reset1`. This conflates fault clearing with safety rearm. Even if the relay accepts reset, deliberate restart, visibility/occupancy, final-element response and physical safe-state evidence remain separate SRS requirements.
4. HMI sends `UnlockCmd` to a nonlocking device on a firmware version with a transient response. A momentary output drop is not a persistent protective stop; hazardous motion may not have stopped at all.
5. A locked guard is reopened only when independent safe access criteria are established. A lock status or GuardLink Operational state alone is not evidence of stopped spindle/held beam/no stored pressure/personnel clear.

## Human factors: do not hide root faults behind 'Reset all'

A one-click 'Reset all safety' HMI button may reduce nuisance downtime but can erase the diagnostic sequence, repeatedly power-cycle devices, and incentivize ignoring intermittent faults. A safer, easier interface shows **which tap, last transition, actual fault code, manual action and required physical verification**, allows ordinary diagnostic readout, and routes physical service to a clear lockout/verification card. If a reset command is permitted, require the selected safety architecture's deliberate reset/restart rules and prevent old ordinary cycle-start requests from silently resuming motion. Keep independent safety authority outside LinuxCNC/HAL/ordinary FPGA. The exact reset interface and access requirements remain machine-specific.

## Cross-machine transfer and limits

- **Press brake:** rear/side access guards do not prove front tooling protection or gravity-loaded beam holding. After any reset, validate actual Y1/Y2/beam/pressure propositions and independent final elements for the selected design.
- **Lathe/mill:** closed/locked guard does not prove spindle standstill or electrical maintenance isolation; check spindle coast and retained cycle commands.
- **Robot cell:** guard-chain Operational does not prove the cell empty. Independent occupancy/restart measures may be required for whole-body access.
- **Saw/feeder:** frequent jam clearing is a foreseeable bypass incentive; good per-device diagnostics and rapid, correctly restorable access are engineering requirements.

## Evidence ledger (selected)

| ID | Claim | Class | Source / page | What remains UNKNOWN |
|---|---|---|---|---|
| GL-01 | 440R-ENETR is not safety-rated | DOC-CONFIRMED | 440R-UM009E p. 75 | Selected machine safety path |
| GL-02 | 432ES-IG3 supports CIP Safety to safety-rated controller | DOC-CONFIRMED | GLINK-AT001A p. 3 | Exact CIP Safety configuration |
| GL-03 | OSSD tap does not test OSSD pulses | DOC-CONFIRMED | GLINK-AT001A p. 5 | Selected device testing/compatibility |
| GL-04 | OSSD disagreement >=3 s recoverable fault | DOC-CONFIRMED | GLINK-AT001A p. 5 | Machine reaction, physical safe state |
| GL-05 | EMSS uses pulse tests and 10 s simultaneity | DOC-CONFIRMED | GLINK-AT001A p. 5 | Selected contact/wiring/receiver |
| GL-06 | `Reset1` differs from `FaultReset` and `FaultResetCmd` | DOC-CONFIRMED | 440R-UM009E p. 39 | Configured reset authorization |
| GL-07 | Operational chain can coexist with outputs OFF | DOC-CONFIRMED | GLINK-AT001A p. 8 | Physical final-element response |
| GL-08 | Same-type tap replacement can auto-recover chain | DOC-CONFIRMED | GLINK-AT001A p. 7 | Safe service/revalidation |
| GL-09 | Nonlocking-device lock/unlock behavior varies by DG firmware | DOC-CONFIRMED | 440R-UM009E p. 62 | Installed firmware/physical stop |
| GL-10 | HMI green or fault reset cannot prove physical safe state | INFERENCE from authority separation | GL-01, GL-06, GL-07, cumulative SRS/PHY contract | Machine witness, validation |
| GL-11 | Machine achieved PL/SIL, DC, PFHd and stop time | UNKNOWN | Not derived | Selected system/measurements |
| GL-12 | GuardLink device/link physically tested in this session | UNKNOWN/NOT TESTED | No lab | All selected runtime behavior |

## Source conflicts and non-inferences

- The 2023 application technique includes both 432ES-IG3 and 440R-DG/ENETR. A phrase about 'safety and non-safety communications' describes **different solutions**, not a safety-rated ENETR channel. The explicit 2026 ENETR Appendix B controls this conclusion.
- The 2025 DG manual is large and not fully fetched here; its indexed Chapter 1 claims are corroborated with the directly inspected 2023 application technique. Do not claim complete inspection of the 2025 manual.
- The 2026 ENETR manual discusses GuardLink 1.0 examples and multiple DG firmware versions. Do not silently generalize an example to all firmware, all device variants, or all wiring topologies.
- Manufacturer 'hot replacement' is not a maintenance energy-control procedure. No authorization for energized service is inferred.
- No selected-machine hydraulic truth table, pressure thresholds, stopping distances, PFHd, diagnostic coverage, safe-speed limit or achieved PL/SIL was calculated or invented.

## Lab decision and exact next evidence

**NO LAB FROZEN.** The immediate uncertainty was documentary: which path is safety-related, how the three resets differ, and whether firmware can change nonlocking-command behavior. Manufacturer documentation resolves those questions. Physical commissioning requires a selected device, exact firmware/config, installed wiring and independent stop/hold/occupancy witnesses. A future bench experiment is justified only for a concrete unresolved selected-interface behavior not answerable from documentation; target `[self-hosted, openpressbrake]` only. Never use hosted runners.

Next: integrate `GL-01`–`GL-12` into `DEP/HF/AUTH/ARC/VAL/PT/CHG/UNK` records; obtain exact selected chain identity; check 2026 ENETR p. 62 firmware against installed revision and review how retained ordinary start is inhibited after recovery. Preserve external/fresh 2520–25F0 evaluation separation.
