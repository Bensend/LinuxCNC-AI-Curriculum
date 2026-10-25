# 4400-ACCESS-01 / SPEED-01 — Direct OEM source audit: a safe-rated monitor may unlock on a timer or report overspeed without stopping
**2026-10-25 | Original manufacturer PDF directly opened and relevant pages visually checked | NOT selected-machine proof**

## Question / branch choice
After SD-01/SD-02, can a genuinely safety-oriented drive output still leave access unlocked without a measured standstill witness, or detect overspeed without taking the stopping action? **Yes, in explicit selectable modes of a particular Rockwell product.** This is a distinct configuration/authority failure path, not another generic guard checklist.

## Primary source and exact scope
**DOC-CONFIRMED**: Rockwell Automation, *Kinetix 6200 and Kinetix 6500 Safe Speed Monitoring Safety Reference Manual*, publication **2094-RM001C-EN-P, May 2013**, for catalog **2094-SE02F-M00-S1 / 2094-EN02D-M01-S1**. Original manufacturer PDF: https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/2094-rm001_-en-p.pdf . Directly opened and page images visually inspected: printed **p.60** (PDF p.59), **p.65** (PDF p.64), **p.84** (PDF p.83); additionally read printed pp.58–64 and 84–85 in source text. This is a 2013 edition and **not** a claim about current product firmware, MSR57P variants, or OpenPressBrake installed components. Rockwell 2022 MSR57P search-indexed excerpts show similar behavior but its 11.8 MB PDF was not directly opened; do not promote that into direct-original evidence.

## OEM-supported discriminators
| Claim | Exact source / condition | Evidence / limitation |
|---|---|---|
| Timed door release with **no measured standstill gate** | Ch.6 printed p.60: **Safe Torque Off without Standstill Checking** removes motion power, then DC_Out unlocks after configured **Maximum Stop Time**, **regardless of speed**. | DOC-CONFIRMED and printed diagram visually checked. A safe torque command and expired timer are **not** proof that a spindle, saw blade, roll or load is stopped. |
| Contrast: standstill-checked stop | Ch.6 printed pp.58–61: other stop types use configured **Standstill Speed**; after standstill, **Standstill Position Window** detects movement and can fault. | DOC-CONFIRMED, edition/mode-specific; encoder 1 is the standstill witness, encoder 2 is used for diagnostics (p.61). A sensor may still be mechanically disconnected from the hazardous load. |
| Vertical-axis restriction | Ch.6 printed p.58 warns **not** to use its Safe Stop 1 for vertical axes because Guard Gate output goes off at standstill; p.59 describes Safe Stop 2 with motor power retained for vertical-load applications. | DOC-CONFIRMED **for these Kinetix drive configurations**. Does not prove any hydraulic press brake's holding circuit or make SOS universally suitable for maintenance. |
| Fault/polarity can mean **unlocked** | Ch.6 printed p.65: **Power to Lock** means DC_Out OFF = unlocked; certain faults force DC_Out OFF, and the manual explicitly warns this can create a hazard. It also warns an already-unlocked door can remain unlocked after a fault. | DOC-CONFIRMED and p.65 image inspected. Never assume deenergize-to-safe equals **door locked** without exact mechanism/occupancy/escape analysis. |
| Status-only speed monitor does **not** stop | Ch.7 printed p.84: in **Safe Limited Speed Status Only**, overspeed produces safe output/status for a safety PLC but **no stopping action** within the drive. Door monitoring and enabling-switch monitoring are unavailable in this mode. | DOC-CONFIRMED and p.84 image inspected. Safety-rated information requires an allocated, functioning downstream safety reaction/final element. |
| Device reset is not a fresh production start | Ch.6 printed p.63 warns SS_Reset is not safety-related restart according to EN 60204-1; separate external measures needed where automatic restart hazardous. p.64 describes automatic, manual, manual-monitored reset options. | DOC-CONFIRMED for this product. |
| Speed-monitoring latency | Ch.6 printed p.61 explains very low standstill threshold and low encoder resolution can delay verification. | DOC-CONFIRMED; do **not** invent a selected machine delay or threshold. |
| Safe motion monitoring is not necessarily an integrated fault reaction | Pilz official EN/IEC 61800-5-2 explainer differentiates motion safety functions from **-M** monitoring-only functions whose violations are reported but do not trigger a reaction: https://www.pilz.com/en-US/support/lexicon/articles/200448 | DOC-CONFIRMED official secondary manufacturer explanation; not proof of a particular device. |

## Fault-chain trace: what is and is not proved
1. **Normal LinuxCNC / FPGA** may request stop, display standstill, or select setup mode. None is personnel-safety authority by itself.
2. **Safety motion monitor** may be configured to check speed/position, use a fixed delay without checking, or provide status-only output. These are **different** SRS claims, despite all being marketed within safe-motion product families.
3. **Safety logic** must consume the exact signal and execute the intended response; a diagnostic-only or status-only wire that goes only to the ordinary controller does not implement a safety stop.
4. **Final element / energy path** must physically interrupt the hazardous source or implement an independently validated safe holding/controlled stop. Faulted output does not guarantee a load is motionless; power-to-lock may unlock.
5. **Guard/escape/rearm** must address speed, residual kinetic energy, gravity, people inside, fault recovery and fresh motion command. Guard-unlock authority is a distinct safety function from mere monitor availability.

### Counterexamples / adversarial review
- A high-inertia saw coasts longer than a copied Maximum Stop Time. A Kinetix timed unlock could occur while blade still moves. **INFERENCE** of hazardous exposure; actual time and installation UNKNOWN.
- A mill's safe-rated SLS output reaches an ordinary LinuxCNC HAL pin only; overspeed status changes but no independent final element acts. **INFERENCE** of incomplete safety allocation, not proof of an installed wiring defect.
- A vertical axis reaches encoder standstill then drive torque is removed and external load descends. The OEM's SS1 vertical-axis warning is **DOC-CONFIRMED**; exact press-brake Y1/Y2 hydraulic behavior remains **UNKNOWN**.
- A power-to-lock guard loses DC_Out after an internal fault. The OEM explicitly documents OFF=unlocked; **INFERENCE** that the guard may permit access before the physical hazard is eliminated unless separate safety provisions exist.

## Claim ledger / evidence taxonomy
- **SOURCE-CONFIRMED:** no new LinuxCNC source claim in this investigation; previous pinned LinuxCNC work remains unchanged.
- **DOC-CONFIRMED:** exact 2013 Rockwell manual behavior above; Pilz official distinction between monitored-only and active safe motion.
- **TEST-CONFIRMED:** none. No machine tests, no simulation, no Actions dispatch.
- **COMMUNITY-REPORTED:** none relied upon.
- **INFERENCE:** layered architecture, safer operator workflow, hazard-transfer scenarios, need for independent final-element and occupancy proof.
- **UNKNOWN:** installed OpenPressBrake safety drive, hydraulic circuit, actual load behavior, measured stop time, mechanical braking, encoder mounting/diagnostic coverage, guard lock polarity, SIL/PL, people-exposure authorization.

## No-energy G0 evidence questions
Obtain privately from qualified selected-machine custodian: device/catalog/revision; exact stop mode; timer vs standstill check; encoder-to-load path; final-element truth table; output polarity/fault response; independent Y1/Y2 hold/pressure/energy isolation; inside escape; deliberate reset and fresh motion; mode-change/change-control; measured and validated safe-state timing. Treat these as **UNKNOWN** until documented and qualified; do not copy example thresholds, PL, stop time, or hydraulic valve states.

## Design lesson and human factors
Make the default maintenance access workflow **request access -> independently establish and maintain the required safe physical state -> authorize unlock -> maintain occupancy protection -> deliberately rearm -> fresh motion command**. Provide convenient guarded access and clear diagnostic reasons for a denied unlock; otherwise people will be incentivized to defeat the lock. An inconvenient safeguard is a design defect to fix, **not** a justification for bypass. For gravity-loaded hydraulic axes, a speed indication cannot replace ram support, independent holding and hazardous-energy isolation.

## Information-gain decision
No lab justified: the OEM directly specifies the divergent mode behaviors. A paper/synthetic model would merely encode the manual, not independently verify the physical safety function. Freeze any future lab only for a new unresolved, measurable question with a safe, authorized setup. G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD. **No personnel-exposed operation.**
