# 4400-PULSE-01 — Two safety inputs do not automatically mean two independently diagnosable channels
**4000 safety engineering module; 2026-10-25; NON-GRADUATED / documentary study.** Prerequisites: 2520 SRS, 2540 safety relay/final element, 2550 integrity/fault exclusions, 2590 protective devices, 4400-EDM-01 and 4400-MIRROR-01. [Original Rockwell/Pilz source audit](../research/4400_ROCKWELL_PILZ_TEST_PULSE_SHARED_SOURCE_CROSS_SHORT_AND_SAFETY_INPUT_VARIANT_AUDIT_2026-10-25.md).

## Objective and design challenge
Given a retrofit drawing with two safety-input terminals, identify whether the receiver can **actually detect** the relevant field-wire faults, explain why two channels fed from one pulsed test source may defeat a cross-short diagnostic, and specify the exact qualified evidence needed before allowing people near the press-brake ram. This is an electrical diagnostic lesson, **not** a shortcut to PL e, a safety-circuit design approval, or hydraulic stop/hold proof.

## Four distinct authorities
```text
Ordinary control/visibility       Independent safety control           Physical hazard restraint
LinuxCNC HMI, HAL, FPGA       ->  sensor/contact -> qualified SI/TO -> qualified safety logic
may log health but cannot          configured fault detection          -> qualified monitored output/EDM
authorize personnel access                                             -> energy-removing final element
                                                                      -> independently verified Y1/Y2
                                                                         stop + gravity hold + guards
```
**A status bit is not a physical witness.** A pulsed electrical test can establish a bounded field-wiring diagnostic, not ram stability or the absence of stored pressure.

## Why test-source identity matters
Rockwell's official **5034-IB8S/XT** Safety Pulse Mode wiring guide says a short between safety inputs fed from the **same** test-output point is not detectable. Its dual-sensor high-integrity examples use **different SI points and different TO points**. This is **DOC-CONFIRMED for that exact receiver/mode**, not a universal rule that all safety inputs must be wired in the same way.

A technician may see two green inputs and assume two independent channels. In the manufacturer-confirmed same-source topology, a cross-bridge can preserve the same test waveform at both terminals. The absence of a reported fault therefore cannot prove absence of the bridge. Exact receiver mode, sensor interface, diagnostic configuration, cabling and fault exclusions determine the coverage.

Pilz's **PNOZmulti** installation manual §5.6 likewise treats short/open testing as an application-specific design task. Its **PNOZ m0p** operating manual §6.1 prohibits using test pulse outputs as actuator supplies and warns against unprotected shared routing with actuator cables. Those are **model-specific** restrictions; copying a terminal arrangement from a different brand/model is not evidence of safety.

## Practical acceptance flow — G0 documentary, NO ENERGY
| Stage | Question | Acceptable witness | What is not evidence |
|---|---|---|---|
| 1. Hazard | Which protective device prevents what exposure, for which modes? | Task/hazard/SRS map | "We installed a safety PLC" |
| 2. Device | Exact E-stop/guard/OSSD/contact type and revision? | Device part number and OEM wiring diagram | Two wires of unspecified origin |
| 3. Receiver | Exact safety SI/TO module, firmware, pulse mode and assigned source per channel? | Qualified terminal map and retained configuration | Two green input LEDs |
| 4. Fault | Which short-to-24V, short-to-0V, cross-short, open, discrepancy and common-cause faults are actually detected? | Exact OEM claims, topology and fault-exclusion rationale | Assuming "dual-channel" implies all faults detected |
| 5. Output | What safety outputs and monitored final elements remove hazard energy? | Output/EDM/contact/valve schematic, exact parts | Ordinary LinuxCNC enable OFF |
| 6. Physics | Does independent Y1/Y2 stop/hold, pressure isolation and gravity restraint work? | Qualified machine-specific G0/G1 and later approved physical evidence | Relay READY or test pulse diagnostic |
| 7. Reset | Does reset restore only permission, requiring a fresh ordinary motion command? | Separate safety reset and restart sequence with occupancy | Restored input automatically starts motion |
| 8. Service | Can wiring be inspected/replaced and guards restored easily without bypass? | Accessible labeled terminals, captured revision, service instructions | Temporary jumpers left in cabinet |

**Decision:** any unresolved safety-critical row is HOLD. Do not attempt energized short injection, disconnect a live guard, defeat interlocks, or run the press brake to learn the fault behavior. Qualified personnel can prepare a de-energized drawing/configuration review first; later test design must use approved safe methods and a physical exclusion plan.

## Specific wrong turns
- **"Both inputs are green; cable is healthy."** No: a shared pulsed source can hide a cross-short in the named Rockwell mode.
- **"I have two contacts, therefore Cat.4/PL e."** No: sensor architecture, wiring, receiver, common cause, diagnostic coverage, final elements and the entire safety function require design-specific assessment.
- **"I can substitute ordinary 24 V for the test source."** Not without OEM-approved mode/wiring and revalidation; the assumed fault detector may disappear.
- **"A test output is a free spare output."** False for the inspected Pilz PNOZ m0p; it is for input tests, not loads.
- **"Use one common test source to simplify wiring."** This may be an undetected-fault topology for a particular module. Simplicity must preserve the **required** diagnostics; use the manufacturer's qualified examples.
- **"Safety input fault cleared; hydraulic ram must be held."** Electrical fault recovery does not establish actual ram holding or pressure isolation.

## Human-factors pattern: make correct wiring the easy wiring
A compact preprinted cabinet terminal chart lists **device ID / contact / SI / TO / mode / expected fault response / exact OEM manual / drawing revision**. Prefer captive/identified harnesses, visible routing and quick access to approved drawings. Keep maintenance jumpers physically controlled and subject to a restoration checklist. A confusing harness that encourages a mechanic to bridge a channel is a design defect, not merely an operator training problem.

## Adversarial examination (not externally scored)
A machine builder connects two normally closed guard channels to SI0/SI1 of a 5034-IB8S, but both are sourced from TO0 in Safety Pulse Mode. A multimeter shows normal 24 V at both and HMI reports OK. The builder claims PL e and authorizes work under the ram. Explain the precise OEM fault-detection limitation, the incorrect inference about PL e, the missing physical stop/hold evidence and the safer no-energy next action. Then repeat the reasoning for a **different manufacturer** without transferring Rockwell-specific TO allocation assumptions.

## Graduation and transfer
To graduate, a fresh learner must diagnose a novel exact-part wiring drawing with independently confirmed OEM scope, preserve physical final-element/ram-hold boundaries and pass an information-separated evaluator. **No fresh evaluation, selected-machine G0 review, G1 physical evidence, or TEST-CONFIRMED result was obtained.** No machine release. The entire selected OpenPressBrake safety circuit and stop/hold proof remain **UNKNOWN**.

## Higher-level uncertainty queue
| Item | Current state | Next evidence | Blocks graduation / machine release? |
|---|---|---|---|
| Exact selected SI/TO, device contacts/OSSD, pulse configuration | UNKNOWN | Restricted as-built drawing + exact manuals | Yes for selected machine |
| Actual field-cable routing and fault exclusions | UNKNOWN | Qualified wiring inspection | Yes |
| Actual physical stop/hold and hydraulic isolation | UNKNOWN | Independent qualified G0/G1 and approved G2 | Yes |
| Independent novel transfer/evaluator | NOT RUN | Sealed unseen case and independent score | Yes for curriculum graduation |
| Numerical diagnostic coverage, PL/SIL, stop time | UNKNOWN | Exact design and physical evidence | Never invent |
