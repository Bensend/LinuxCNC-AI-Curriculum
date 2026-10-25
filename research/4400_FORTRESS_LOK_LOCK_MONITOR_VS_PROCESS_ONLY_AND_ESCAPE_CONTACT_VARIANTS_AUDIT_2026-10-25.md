# 4400-TK-03 — Fortress LOK guard-lock authority and escape-release contact variants
**Original 17-page Fortress operating instructions directly inspected | 2026-10-25 | exact OEM edition/variant only**

## Source and question
Original Fortress *Operating Instructions: Interlocks with Locking*, manufacturer-hosted PDF (2025 path, document date not asserted), pp. 1–8, 13–14:
https://fortress-safety.com/app/uploads/2025/04/Interlocks-with-Locking-Operating-Instructions.pdf

Question: can an interlock marked "amGardpro LOK" be substituted with another similar LOK configuration while retaining the same personnel-safety meaning? **No general equivalence is established.** The manual differentiates locking power mode, safety contact structure, release hardware and response to escape release.

## Directly confirmed variant distinctions
1. **PTU vs PTL (pp. 3–4)**: Power-To-Unlock is normally locked without solenoid power, with manual release options; Power-To-Lock unlocks when solenoid power is removed. These have different power-failure/access consequences. The manufacturer's examples identify PTL unmonitored variants for *process protection*, not a blanket person-protection claim.
2. **Monitored vs unmonitored locking (p. 4)**: monitored solenoid safety circuits have dual NC locking-state contacts in series with dual NC actuator/key contacts; independent circuits expose both propositions separately. **Unmonitored** solenoid safety circuits respond to actuator/key opening but their NC contacts **do not change when the solenoid unlocks**. A closed guard contact is therefore not proof of lock engagement in this variant.
3. **Escape-release variant-dependent circuit behavior (pp. 3, 7–8)**: SR/ZR/LR escape releases open NC *head* contacts; SE/LE integrated escape releases open NC *solenoid* contacts. Indicator LEDs differ. This means replacing body/module type without revising terminal mapping can defeat the intended observation even when the escape handle mechanically works.
4. **Critical manufacturer warning (p. 5)**: the LOK component is explicitly **not a mains isolator, emergency stop or mechanical stop**. The full-machine energy-removal and ram restraint must remain elsewhere. Auxiliary/manual release tools are to be controlled and not left installed.
5. **Claim limit (p. 6)**: manufacturer's up-to-PLe/Cat4 data is conditional on selected configuration, wiring and appropriate safety function, not proof for a generic retrofit.
6. **Practical mounting (p. 9)**: OEM says the interlock must not take mechanical guard impact; separate mechanical guard stops/supports and accessible maintenance are required. A bent guard that relies on the lock body as its physical stop is an engineering failure path.

## Source-confirmed contact transition (conditional)
| Action / variant | What the original OEM says | Unsupported inference to reject |
|---|---|---|
| Unlock unmonitored-solenoid type while actuator remains in place | NC actuator/key circuit remains closed | "Safety relay sees unlocked state" |
| Escape SR/ZR/LR | NC head contacts open, stop request initiated | "Every LOK escape opens the solenoid contacts" |
| Escape SE/LE | NC solenoid contacts open, stop request initiated | "All red/amber LED meanings are identical" |
| PTL power loss | Guard unlocks on solenoid loss | "Loss of power always keeps person-protective guard locked" |
| Return key and close guard | Conditional normal contacts/locking state can restore | "Physical load holding and new start are proven" |

This is **DOC-CONFIRMED OEM functional behavior**, not an executable wiring prescription, selected machine state, or certified circuit. The actual selected part-number/configuration and full terminal mapping must be independently obtained.

## Adversarial design review
A service technician substitutes an unmonitored process-locking module for a monitored personnel-guard unit because the connector fits. The normal CNC input still reads guard closed when unlocked. A second technician uses escape release and assumes an identical LED/contact pattern across models. Meanwhile the controller retains a cycle command. The risk-reduction route is to require exact part-number and wiring-diagram change control, mechanically adequate guard stop and inside escape, independent safety-state observation, safe final elements and deliberate fresh start. If access is frequent, choose a low-friction guard/handle/diagnostic layout rather than hiding an auxiliary key in the device.

## Status and provenance
**DOC-CONFIRMED** Fortress original manual pages above. **SOURCE-CONFIRMED** no LinuxCNC source. **TEST-CONFIRMED** none. **COMMUNITY-REPORTED** none. **INFERENCE** replacement/maintenance hazard and machine transfer. **UNKNOWN** installed Fortress product, terminal mapping, physical Y1/Y2 stop/hold, access, PL/SIL and validation. No OpenPressBrake Fortress installation asserted; G0/G1 HOLD, G3/G4 NOT AUTHORIZED. This extends TK-01 and earlier GUARD-01 without replacing the existing EUCHNER/Pilz evidence.
