# 4400-RCD-02 — Voltage-dependent residual-current protection and the broken-neutral failure path
**2026-10-26 | distinct RCD-01 follow-on | original ABB/Schneider + IET scope audit | NON-GRADUATED**

## Question
Two RCDs have the same residual-current waveform class and nominal trip rating. Do they necessarily behave alike when the supply neutral is interrupted, an internal supply disappears, or voltage returns? **No.** RCD waveform class and *trip-power dependency* are separate selection dimensions. This was not the mechanism investigated by RCD-01, PANEL-01, BOND-01 or DCB-01.

## Directly inspected source register
1. **ABB, 2022 original *Residual current devices (RCDs)*, §§5.6–5.7, PDF pp.13–14**: https://library.e.abb.com/public/fc3d92ef8da94d38a3882b0b86afb552/ELAU%20RCD%20Local%20Whitepaper%202022_9AKK108466A8987_RevA.pdf . **DOC-CONFIRMED:** voltage-independent devices can derive trip energy from residual current; voltage-dependent devices use an amplifier powered by mains/auxiliary supply. Some VD devices have an **FE functional-earth** conductor that supports tripping after neutral loss. ABB expressly distinguishes FE from protective earth (PE); no assumption that FE can substitute for protective bonding.
2. **Schneider Electric Australia, FAQ000218860, original manufacturer webpage, published 2021-10-14, updated 2026-03-31**: https://www.se.com/au/en/faqs/FAQ000218860/ . **DOC-CONFIRMED:** VI versus VD mechanisms; describes VD category 1 remaining closed after supply loss (potentially unprotected with neutral break), category 2 opening upon loss of supply and requiring manual reclosure; some category 1 variants use an FE redundancy supply. These are **manufacturer-described categories**, not a diagnosis of any installed device. Manufacturer page also lists specific FE earthing conditions in its Australian context; do not transfer numeric earthing criteria to an unknown U.S. machine.
3. **Institution of Engineering and Technology, *Automatic disconnection of supply for island mode prosumer electrical installations*, July 2026, §Classification of RCDs**, https://electrical.theiet.org/wiring-matters/years/2026/110-july-2026/automatic-disconnection-of-supply-for-island-mode-prosumer-electrical-installations/ . **DOC-CONFIRMED (professional guidance)**: under the cited UK product standards, E1/E2/E3 classifications distinguish behavior on supply loss; E3 may not trip outside rated voltage. **SCOPE LIMIT:** this article is explicitly for UK single-dwelling residential prosumer/island-mode systems. Its E markings and BS 7671 provisions are not claimed to govern a U.S. CNC installation.

## Failure-path analysis — conditional, not machine truth
| Event | VD category-1 example | VD category-2 example | What a qualified review must determine |
|---|---|---|---|
| Neutral opens while line remains hazardous | **DOC-CONFIRMED OEM possibility:** trip-power loss may impair residual-current protection without opening | **DOC-CONFIRMED OEM category description:** opens on supply loss | Exact RCD model, trip-power path, product category, supply topology, selected standard |
| FE conductor disconnected during service | **INFERENCE:** for a design relying on FE redundancy, intended neutral-loss protection may be impaired | **UNKNOWN:** behavior is product-specific | FE purpose and approved wiring; distinguish PE protective bonding from FE |
| Power returns after outage | **DOC-CONFIRMED OEM category description:** some devices remain closed | **DOC-CONFIRMED OEM category description:** category 2 must be reclosed | Whether hazardous machine power/torque or motion could be restored; separate deliberate machine start |
| Front test button passed before outage | **INFERENCE:** a normal-power test does not prove neutral-loss behavior | Same limitation | Exact approved verification and test evidence, without dangerous live fault injection |

**Do not assert** that every VD RCD is unsafe, that a VI RCD is always suitable, or that neutral failure alone implies energized exposed parts on a particular installation. The exact protective scheme and earthing system decide. Equally, no RCD category authorizes machine motion, personnel access or maintenance.

## Architecture / human factors
- **Electrical designer:** document selected RCD/RCM waveform type (RCD-01), trip-power dependency (this module), neutral/FE/PE wiring, supply arrangement, approved fault protection and any power-restoration behavior.
- **Machine safety designer:** independently decide what power loss/return does to drives, gravity-loaded ram, hydraulics, guards and restart. Electrical protective device behavior is not a qualified safe-stop/hold truth table.
- **Maintenance:** use easy-to-follow labeled isolators and a product-specific diagnostic route; never defeat PE, repurpose FE as PE, bridge the RCD, or perform a deliberate live neutral-break demonstration as a student exercise.
- **LinuxCNC/HAL/ordinary FPGA:** diagnostics only; no personnel-safety or electrical-isolation authority.

## Evidence state
**DOC-CONFIRMED:** cited OEM and professional guidance within their exact scope. **INFERENCE:** fault-path and human-factor consequences. **SOURCE-CONFIRMED LinuxCNC:** none new. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none used. **UNKNOWN:** selected OpenPressBrake RCD and earthing topology, neutral-fault behavior, FE/PE routing, physical ram response, PL/SIL and qualified verification. No simulation or physical lab is warranted by these source questions. G0/G1 HOLD.
