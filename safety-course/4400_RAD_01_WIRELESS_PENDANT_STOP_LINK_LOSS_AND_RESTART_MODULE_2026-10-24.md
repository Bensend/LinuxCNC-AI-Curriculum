# 4400-RAD-01 — Wireless pendant STOP, radio-link loss, ownership and restart
**Status:** RESEARCH / NON-GRADUATED. **Prerequisites:** 2520 safety-function derivation, 2530 E-stop, 2560 fault/diagnostics, 2570 independent validation, 2580 selected-machine intake, 4400-RST-01 fresh restart and 4400-HYD-01 load holding.

## Objective
Given an industrial radio pendant, determine which components are ordinary command/diagnostics, which exact radio STOP subsystem may be credited as safety-related, what physical stop/hold is required downstream, and how lost link, battery failure, power restoration, pairing changes and abandoned controls are handled without surprise restart. Explain why a PLd STOP claim on a transmitter/receiver does **not** confer PLd on LinuxCNC, a hydraulic valve or the entire machine.

## Required reading and source status
1. [Original Tele Radio R15/T19 OEM source audit](../research/4400_TELE_RADIO_R15_T19_WIRELESS_STOP_CONFIGURATION_AND_RESTART_OEM_AUDIT_2026-10-24.md): DOC-CONFIRMED product/edition.
2. [Scanreco G5 CAN/MOSFET cross-OEM comparison](../research/4400_SCANRECO_G5_CAN_STOP_OUTPUT_VS_ORDINARY_CAN_CROSSCHECK_2026-10-24.md): manufacturer web DOC-CONFIRMED; full OEM manual/physical truth UNKNOWN.
3. [4400-RST-01](4400_RST_01_POWER_RETURN_RESET_EDM_AND_FRESH_START_MODULE_2026-10-24.md): separate radio link eligibility, safety rearm and deliberate new machine start.
4. [4400-HYD-01](4400_HYD_01_FASTDOWN_DRIVE_LOSS_VALVE_FEEDBACK_AND_PHYSICAL_HOLD_MODULE_2026-10-24.md): press-brake gravity-load STOP cannot be equated with valve power removal.

## Mechanism
**Radio normal controls -> normal LinuxCNC commands** (no personnel-safety credit).
**Certified transmitter STOP -> qualified receiver STOP logic/relays -> selected independent safety controller/final elements -> actual physical hazard stop/hold** (safety claim limited to proven chain).
**Physical isolator + stored-energy verification -> maintenance** (separate from E-stop).
**Link/pairing diagnostics -> HMI** (helpful but not a safety signal).

### The exact OEM trap
Tele Radio R15 v09 printed pp.13–15 declares a PLd Cat3 STOP **only for its specified T19-02/R15 product combination and qualifying configuration**. Continuous radio, all relays off on link loss, <=500 ms link timeout, login/logout on, unique ID and Require start on are explicit OEM requirements. The same original manual says *discontinuous mode 5 cancels the PLd STOP function*. This is a mode/configuration gate, not a universal 500 ms machine stop limit. R15 'Require start' ON prevents radio stop-relay reactivation after receiver power restoration until a start command; **radio STOP relay eligibility is not machine-cycle start authorization**.

## Failure-path matrix
| Trigger | What is NOT proven | Required evidence |
|---|---|---|
| Radio link lost / interference / dead battery | Normal CAN timeout or software jog-stop does not prove independent physical stop | Exact safety output deassertion and physical selected stop/hold |
| Receiver brownout and return | PLd status LED and radio START do not prove safe empty zone or new machine start | Receiver settings, independent reset/start, actual final-element and occupancy witness |
| Transmitter power OFF, still logged in | Absence of active motion does not prove ownership transfer | Registration/logout/replace and control-identity procedure |
| Operator selects discontinuous mode | Working buttons do not prove certified STOP remains active | Locked mode/firmware readback and revalidation |
| Wrong registered transmitter tries takeover | UI 'connected' is not operator identity | Exact ID binding, key custody, machine inhibit and rearm |
| Remote operator cannot see work zone | Stop button proximity does not guarantee hazard visibility | Physical guarding, exclusion, local enable and line-of-sight rules |
| Radio stop removes holding energy | Motor or valve deenergized does not prove suspended load held | Independent gravity/retention/energy safe state |
| Receiver stop relays open | Physical final elements may stick, shared power can defeat stop | EDM where justified, independent final-element witness and fault analysis |

## Practical design pattern
Default to **fixed hardwired accessible local E-stop(s)**, guarded zone and a clearly labeled local operator station. Use a wireless pendant only when the risk assessment justifies it. Where radio STOP is a safety function, buy a matched certified transmitter+receiver, lock safety settings, use the manufacturer's specified safety terminals into an independent safety controller/final-element chain, and keep ordinary radio controls on the LinuxCNC side. Provide easy secure parking/charging and obvious transmitter ID; make it simpler to return the pendant and keep guards in place than to bypass them. On uncertainty, link loss, wrong owner or configuration mismatch: inhibit motion and require qualified resolution. Do **not** automatically dump pressure on a gravity-loaded ram based on a generic wireless STOP recipe.

## Learner work
Complete [16 paper scenarios](4400_RADIO_PENDANT_LINK_LOSS_OWNERSHIP_AND_REARM_TECHNICIAN_CARD_2026-10-24.md). Explain the physical safe state and exact evidence needed, not only relay/LED states. Use [blank qualified selected-machine witness](4400_RADIO_PENDANT_SELECTED_MACHINE_BLANK_WITNESS_2026-10-24.md) only if radio equipment actually exists. Prepare [independent fresh-AI handoff](../evaluation/4400_RAD_01_FRESH_RADIO_STOP_TRANSFER_HANDOFF_2026-10-24.md); it has no answer key and is NOT SCORED.

## Completion gates
- **G0/G1:** selected model/firmware/receiver settings/outputs and whole machine SRS evidence; currently HOLD/UNKNOWN.
- **G2:** physically isolated/remote, qualified independent STOP terminal + actual stop/hold validation; NOT RUN.
- **G3/G4:** personnel-exposed hazardous commissioning and operation NOT AUTHORIZED.
- **G5:** independent information-separated transfer evaluation OPEN.
No invented stop time, distance, integrity rating or valve truth table. Do not claim that any radio system is installed on OpenPressBrake.


## Same-session RAD-02 standards-scope and mobile-HMI extension
Read [official IEC 62745 publisher-scope / FME 2024 industry guideline audit](../research/4400_IEC62745_FME_MOBILE_DEVICE_CABLELESS_SAFETY_AUTHORITY_SCOPE_2026-10-24.md) and complete [10 additional PAPER cases](4400_MOBILE_HMI_VS_CERTIFIED_RADIO_STOP_TECHNICIAN_CARD_2026-10-24.md). IEC 62745:2017 publisher abstract confirms the subject of cableless portable operator stations; the complete licensed normative standard was **not** read. FME's March 2023-status guidance addresses general-purpose phones/tablets, not certified radio pendant integration; its 0.5 s guideline is **not** a universal machine stop-time requirement. The engineering transfer is: **onscreen STOP != certified emergency stop**, **Wi-Fi link != safety authorization**, **link restored != safe fresh motion**, and **radio STOP relay open != gravity load held**. Keep accessible fixed hardwired safety controls and independent physical safeguards; remote HMI read-only by default. This is not a new OpenPressBrake hardware assertion.


## Same-session RAD-03 exact original manual edition-transfer audit
Read [R15 v09/v11 direct original OEM comparison](../research/4400_TELE_RADIO_R15_V09_V11_VERSION_SCOPE_AND_POWER_CYCLE_AUDIT_2026-10-24.md) and [8 PAPER version-change scenarios](4400_RADIO_MANUAL_VERSION_AND_PAIRING_CHANGE_TECHNICIAN_CARD_2026-10-24.md). v09's functional-safety chapter names T19-02, while v11 also names T29-12; both require receiver SW0014-14v24+ and reserve older firmware for a different manual. Both cancel PLd STOP in discontinuous mode 5; v11 additionally explicitly instructs a receiver power cycle after changing PLd to non-PLd configuration. This is documentary edition-specific evidence, not a certified equivalence of transmitter models, permission for energized service or physical test.


## 2026-10-30 ordinary USB handwheel contrast (exact LinuxCNC source, not a certified radio)
[Stable v2.9.10/development XHC-WHB04B-6 source audit](../research/4400_USB_PENDANT_01_LINUXCNC_WHB04B6_RESET_STOP_LINK_FRESHNESS_AND_BLOCKING_SOURCE_AUDIT_2026-10-30.md) is a **different architecture** from Tele Radio R15: a LinuxCNC userspace USB/HAL component maps RESET to ordinary machine on/off and STOP to normal Task abort (including motion/IO/spindle abort calls); `whb.pendant.is-connected` follows receiver initialization, not proven remote safety-link freshness. The official man page's E-stop pin cross-reference is stale against the inspected registered pins. Do not transfer R15's product-specific PLd/timeout claims to the XHC HID receiver or treat the cheap pendant as a safety-radio substitute. Keep the independent fixed stop, guard and physical final-element boundary. No selected installation or physical test; UNSCORED transfer only.
