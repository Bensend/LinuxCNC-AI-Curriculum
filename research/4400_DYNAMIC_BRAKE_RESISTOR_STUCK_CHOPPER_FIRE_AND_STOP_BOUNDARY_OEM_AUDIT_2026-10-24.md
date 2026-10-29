# 4400 — Dynamic-brake resistor, failed chopper and independent thermal protection
**2026-10-24 | Original OEM research | PAPER / NOT GRADUATED**

## New question
The existing STO/DC-bus course correctly says stored DC voltage remains after torque is disabled. This investigation covers a **different physical hazard**: regenerative stopping converts kinetic energy into heat in a resistor, and a chopper semiconductor failure can keep that resistor energized even when ordinary drive software has faulted. Can ordinary CNC/drive diagnostics alone prevent a fire or prove the machine has stopped? **No such component is assumed installed on OpenPressBrake.**

## Original manufacturer documentation and inspection limits
1. **Rockwell Automation, Armor PowerFlex 350 Light-Duty Dynamic Brake Resistors, 35-IN006D-EN-P, January 2026, 4-page original installation instructions**, p.1: https://literature.rockwellautomation.com/idc/groups/literature/documents/in/35-in006_-en-p.pdf . **Original PDF inspected.** It explicitly identifies failure of a brake IGBT as a resistor fire hazard and shows thermostat protection; its **specific dedicated** Armor PowerFlex 350 kits can cause the drive's internal thermal detection to open its Electronic Motor Disconnect. It also states the catalog 35R-00AP1K/BP1K resistors are **not for Armor PowerFlex 330**. Pp.2–3 warn the cited resistor surfaces can exceed **200 °C**, a product-specific burn warning, not a generic acceptance threshold.
2. **Rockwell, Armor PowerFlex AC Drives User Manual, 35-UM001H-EN-P, July 2025**, p.28, manufacturer's indexed PDF text (full 31 MB original not independently opened in this session): https://literature.rockwellautomation.com/idc/groups/literature/documents/um/35-um001_-en-p.pdf . Indexed passage explains DB dissipates regenerative energy as heat, brake-IGBT failure risk, and product/firmware-specific protections. **DOC-CONFIRMED indexed passage; original-page visual not independently inspected.**
3. **ABB, ACS880-01 Hardware Manual**, resistor braking section p.314, manufacturer's indexed PDF text (full original not opened due source 403): https://library.e.abb.com/public/8426dbfaa37541248a53719f9a42d56d/EN_ACS880-01_HW_U.pdf . Indexed manufacturer wording recommends an independent contactor/thermal-switch circuit even with software thermal model because a conductive-failed chopper may prevent the drive from interrupting mains. **DOC-CONFIRMED indexed excerpt with access limitation; not a verified current revision for any selected machine.**
4. **ABB, ACS880-31 Hardware Manual**, resistor braking p.237, manufacturer's indexed PDF excerpt: https://library.e.abb.com/public/3869f36876be46d78cb4f5114b2707ed/EN_ACS880-31_HW_F.pdf . Describes contactor plus resistor thermal switch and separate ordinary drive digital-input fault indication. **DOC-CONFIRMED indexed excerpt only.**
5. **Rockwell PowerFlex 750 Quick Start, 750-QS001A-EN-P, March 2015**, p.66, manufacturer indexed PDF excerpt: https://literature.rockwellautomation.com/idc/groups/literature/documents/qs/750-qs001_-en-p.pdf . Dynamic braking dissipates energy, may permit faster controlled stop and can be provided by an independent chopper in some frames. **Not evidence of a safety-rated stop.**

## Claims ledger
| ID | Claim | Classification | Scope / limitation |
|---|---|---|---|
| BR-01 | Dynamic braking redirects regenerated electrical energy into **thermal energy** in a resistor. | DOC-CONFIRMED | Rockwell 35-UM001H p.28 indexed; ordinary functional description. |
| BR-02 | Failure of a brake IGBT can create **fire risk** for externally mounted resistors lacking independent overtemperature protection. | DOC-CONFIRMED | Rockwell 35-IN006D p.1 original. |
| BR-03 | Some **specific** Armor PowerFlex 350 + dedicated resistor kits have internal thermal-event detection that opens an Electronic Motor Disconnect; this does not apply automatically to all drives/resistors. | DOC-CONFIRMED | Rockwell 35-IN006D p.1 original; exact catalog and drive model required. |
| BR-04 | Cited Rockwell resistors can exceed 200 °C at the surface; contact and nearby combustible material are hazards. | DOC-CONFIRMED | Rockwell 35-IN006D pp.2–3 original; do not transfer temperature to other resistor families. |
| BR-05 | ABB indexed manuals distinguish a drive's **thermal model** from an **external thermal-switch/contact power-interruption** circuit in chopper-conductive faults. | DOC-CONFIRMED (indexed only) | ABB ACS880-01/31; original full manuals not independently inspected. |
| BR-06 | A normal dynamic brake's existence proves a safety-related stopping time or gravity hold. | **FALSE / UNKNOWN** | OEM sources describe energy dissipation, not selected-machine stop-time, integrity, brake capacity or holding. |
| BR-07 | An ordinary LinuxCNC alarm can substitute for physical resistor overtemperature interruption. | **UNSUPPORTED INFERENCE — reject** | Need selected independent thermal protection/final-element evidence. |

## Failure-path and authority analysis
```
mechanical load / motor -> inverter DC bus -> brake chopper semiconductor -> resistor -> heat
                                                  |                          |
                                     possible short/conductive fault     thermal switch
ordinary CNC/drive fault report -------------------------------------> diagnostics only
qualified thermal protective circuit -> appropriately selected physical energy-interruption element
independent personnel safety stop/hold -> separate machine final elements / restraints
```
The schematic is a **functional decomposition**, not an approved wiring design. A resistor thermostat's trip alone does not establish that the selected contactor opens or that all bus sources (including shared bus/PM generation) are isolated. The **new common-bus audit** matters here: an upstream AC contactor may not remove energy from a resistor fed by other DC sources. Conversely, opening a bus source abruptly may compromise a controlled deceleration; the required stop/hold architecture must be established independently.

**INFERENCE:** A system relying solely on the chopper to satisfy a personnel-safety stop may lose braking on an open resistor, failed thermal circuit, bus overvoltage or drive fault. It may overheat on a shorted chopper. Do not assert either fault always causes a particular stopping distance; selected drive fault responses are UNKNOWN.

## Adversarial design review
- **Resistor overtemperature:** identify whether a thermostat exists, its physical interruption path, its failure behavior and whether shared DC feeds remain.
- **Open resistor:** drive may be unable to dissipate expected regenerative energy; do not assume commanded deceleration remains achievable.
- **Chopper conductive fault:** software thermal model may not independently remove energy; protect against overheating/fire per exact OEM.
- **Mechanical coast:** losing braking capacity can extend stop; actual safe distance/guard-lock timing requires physical evidence.
- **Gravity axis:** dissipating electrical energy is not mechanical load holding.
- **Reset:** cooling/replacing a resistor is not automatic permission to resume motion; fault diagnosis, deliberate rearm and fresh start remain.
- **Maintenance:** resistor may be both electrically energized and thermally hot after motion ends; qualify access/isolation/cooling.

## Practical human factors
Use a guarded non-combustible location with adequate OEM-required ventilation, labelled hot-surface warning and inspectable wiring. Make thermal-switch replacement and fault diagnosis easy without defeating guarding. Avoid inaccessible resistor enclosures that tempt operators to bypass a persistent overtemperature fault. This is an **INFERENCE** design recommendation; actual thermal ratings, enclosure spacing, fuse selection, wiring, stop time and PL/SIL remain product/machine specific.

## Transfer and release
Applicable only when an actual brake resistor/chopper exists: press brake servo axes, spindle drive, mill Z, lathe spindle, gantry/feeder, robot cell. Do not confuse **electrical regenerative braking**, **mechanical holding brake**, **drive STO**, **safety-rated controlled stop**, **electrical service isolation** or **fire protection**. All are different propositions. No selected OpenPressBrake device or physical evidence established. `TEST-CONFIRMED: none`; paper/source only; independent evaluator and physical release gates OPEN. No exposed hazardous operation authorized; no live fire/thermal/fault injection lab justified.


## 2026-10-29 exact-OEM source-depth and novelty correction
[ABB 2011 direct two-page circuit, ACS800 R7/R8 frame exception and Schneider accessory suffix addendum](4400_BRAKE_RESISTOR_2026_10_29_ABB_2011_ACS800_FRAME_EXCEPTION_AND_SCHNEIDER_SUFFIX_SOURCE_DELTA.md). This **does not introduce a new causal mechanism**: the original 2026-10-24 BR-01 already established failed-conductive chopper -> resistor overheat and separate thermal interruption. Increment: directly inspected complete ABB 2011 circuit and exact 2009 ACS800 internal-chopper input-bridge exception (external chopper requires contactor), plus exact Schneider ATV312 resistor part numbers with/without built-in thermal contacts. **DOC-CONFIRMED exact OEM**, no machine/physical proof. The session corrected a first-pass duplicate claim before closing; avoid index-title-only novelty searches.
