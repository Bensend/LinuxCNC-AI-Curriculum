# 4400-RESCUE-01 — Press-brake Type-C standards scope and E-stop / entrapment-release conflict
**2026-10-25 | original source reconciliation | DOC-CONFIRMED / INFERENCE / UNKNOWN | NOT a selected-machine rescue procedure.**

## Frozen questions
1. Can the general hydraulic-power-press standard be used as the press-brake-specific acceptance oracle?
2. On a real commercial press brake, does pressing E-stop necessarily leave the normal beam-up command available to free a trapped person?
3. What must be independently established before an OpenPressBrake rescue, maintenance release or restart may be claimed?

## Direct primary-source ledger
| Source / edition / exact locator | Direct observation | Evidence and boundary |
|---|---|---|
| ANSI B11 Standards, [B11 Scopes](https://www.b11standards.org/b11scopes), checked 2026-10-25 | **ANSI B11.3-2022** is explicitly scoped to power press brakes; **B11.2-2013 (R2020)** explicitly excludes powered press brakes from hydraulic/pneumatic power-press coverage. | **DOC-CONFIRMED publisher scope only**; no paid normative clauses inspected. |
| ANSI B11, [current editions](https://www.b11standards.org/current-standards) and [B11.3-2022](https://www.b11standards.org/storeitems/b113-2022) | B11.3 is listed as the current press-brake Type-C edition at time checked. | **DOC-CONFIRMED**, jurisdiction/adoption/installation applicability **UNKNOWN**. |
| ISO, [ISO 16092-1:2017 official abstract](https://www.iso.org/standard/55667.html), scope exclusion item (c), accessed 2026-10-25 | Explicitly excludes machines principally designed for bending/folding by press brakes or folding machines. | **DOC-CONFIRMED publisher**; **do not** transfer ISO 16092-1's press provisions to a press-brake safety release as though Type-C applicable. |
| ISO, [ISO 16092-3:2017 official abstract](https://www.iso.org/standard/63390.html) | Hydraulic-press part explicitly supplements ISO 16092-1; not a substitute for a press-brake-specific standard. | **INFERENCE** from documented part relationship and 16092-1 exclusion; full 16092-3 normative scope not inspected. |
| NEN, [EN 12622:2009 publisher scope](https://www.nen.nl/en/nen-en-12622-2009-en-141376); DIN, [EN 12622:2009+A1:2013 listing](https://www.dinmedia.de/en/standard/din-en-12622/194017398) | European machine-specific standard for hydraulic press brakes, including integral backgauges; edition/jurisdiction must be selected deliberately. | **DOC-CONFIRMED publisher scope**; full normative text not acquired. Do not treat an indexed third-party extract as a purchased authoritative edition. |
| TRUMPF, [TruBend Series 2000 (B35), operator manual B1161en, 2023-05-01](https://www.trumpf.com/filestorage/TRUMPF_US/user_upload/PIM_TruBend_Serie_2000_B35_us_V3.pdf), PDF pp. 21–24 and 33 (printed 1-22–1-25 and 1-33) | Printed 1-22: E-stop stops ram/backgauge, switches off hydraulic unit, and **deactivates PRESS BEAM UP**. Printed 1-23/1-24: beam-up foot control requires hydraulic power; it is unavailable when E-stop has triggered or side/rear protective door opened. Printed 1-33: for trapped body parts, OEM residual-risk table directs use of beam-up foot control. Printed 1-25 lists a freeing-trapped-person safety label. | **DOC-CONFIRMED model/edition-specific**. This is a **conditional-control availability conflict**, not proof that TRUMPF has no rescue path; full approved emergency response and actual machine variant are not established here. |
| Cincinnati, [PROFORM+ EM-560 N-06-14 OEM source already audited](4400_CINCINNATI_PROFORM_RAM_RESTRAINT_LOTO_RESCUE_MANUAL_ERRATA_AUDIT_2026-10-23.md) | That different press-brake manual distinguishes power-available and no-power entrapment release, with warnings and internally inconsistent figure locators. | **DOC-CONFIRMED historical OEM example**, not transferable instructions, dimensions, lifting points or pressure-port truth. |
| OSHA, [29 CFR 1910.147](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147), (d)(2),(5),(6),(e),(f)(1) | Covered maintenance requires orderly shutdown, hazardous stored-energy control, verification, and re-isolation after necessary powered testing/positioning. | **DOC-CONFIRMED regulation**; applicability to a specific site/task **UNKNOWN**. Emergency rescue is **not** made safe merely by citing maintenance LOTO. |

## Source-constrained state matrix: only B35, only what manual establishes
| Situation | OEM evidence for normal PRESS BEAM UP | What is **not** proved |
|---|---|---|
| Normal permitted control state, hydraulic supply available | Printed 1-23 describes UP foot switch commanding hydraulic power and upward motion. | Whether an injured person's entrapment can be relieved without additional harm; no selected safe clearance. |
| E-stop has triggered | Printed 1-22/1-24: UP foot control is **deactivated**. | How rescue is achieved, whether any approved alternate mode exists, and the correct response sequence. |
| Side or rear protective door open | Printed 1-24: UP foot control is **deactivated**. | Whether it is permissible or safe to reclose a guard to enable motion during rescue. |
| Total electrical power unavailable | Hydraulic footswitch UP depends on electrical/hydraulic function; no no-power UP operation established. | Any no-power rescue means or load-restraint procedure for B35. |
| Faulted safety controller, hydraulic valve or trapped pressure | Manual excerpts do not give a complete fault/physical rescue truth table. | No safe motion or holding conclusion. |

**Critical adversarial result:** “E-stop, then press UP” is **not** a universal rescue instruction. On this B35 edition the two ordinary controls are not simultaneously available in the described E-stop state. This does **not** justify clearing E-stop, defeating guards, energizing hydraulics, opening pressure fittings, or moving the ram around a trapped person. Only a qualified, machine-specific, independently reviewed rescue procedure can resolve the competing hazards.

## Engineering distinction and consequence
- **STOP** is stopping further hazardous motion; it may remove the ordinary actuation path needed to release entrapment.
- **HOLD** is maintaining a safe physical load state against gravity, leaks, spool faults and energy loss.
- **RELEASE/RESCUE** is an intentional, controlled action that can itself cause further crushing, sheet sweep, secondary motion or falling load.
- **ISOLATION** for maintenance is not an automatic emergency release mechanism; unloading a cylinder can allow gravity motion.
- **RESET** clears a protective latch under specified conditions; **REARM** establishes a permitted ready state; **START** is a separate deliberate motion request.
- Normal LinuxCNC/HAL/FPGA outputs and diagnostics may coordinate/display these states but must not be the sole personnel-safety authority.

## Six qualitative failure cut sets (INFERENCE, not measured rates)
1. Person trapped + E-stop latches + normal UP disabled + no independent approved rescue capability.
2. Person trapped + guard opened + guard interlock disables UP + improvised guard defeat/rearm.
3. Person trapped + pressure release attempted + gravity load not independently restrained.
4. Power loss + suspended ram + unsupported improvised lifting + second-person exposure.
5. Rescue appears successful + stale normal cycle request + automatic motion after reset.
6. Wrong Type-C standard selected + wrong mode/stop assumption accepted + physical validation omitted.

## Human factors: make correct rescue preparation easiest
Place an **edition- and serial-verified rescue reference** at a safe exterior station, accessible during loss of panel power; identify trained responders, emergency services coordination, physical isolation and approved restraint resources, and a conspicuous **no improvisation** warning. A concise role/communications card should be easier to find than a hidden service menu. Training is tabletop/no-energy until qualified physical test planning and exclusion controls exist. Do not put a generic valve-opening or ram-lifting sequence on a public learner card.

## Evidence gaps / next discriminator
- **UNKNOWN:** actual OpenPressBrake as-built machine type, applicable adopted standard edition, hydraulic circuit, holding method, approved rescue methods with and without power, access/egress, emergency contacts, final elements, control rearm behavior and physical witnesses.
- **TEST-CONFIRMED:** none. **SOURCE-CONFIRMED:** no new LinuxCNC implementation claim; prior ordinary control source studies remain separate. **COMMUNITY-REPORTED:** none relied upon.
- Source research resolves the *general standards-scope and B35 control-availability* questions without simulation. Next information gain requires qualified selected-machine documentation/inspection and independent competency evaluation. Do not freeze a generic lab to infer machine hydraulics.

## Publication discipline
This audit does not authorize personnel-exposed operation or live entrapment drills. No numeric safe speed, stopping distance, pressure, load, PL/SIL or rescue time has been asserted.
## Independent regulator-category corroboration (2026-10-25 continuation)
- OSHA's official [powered press-brake eTool](https://www.osha.gov/etools/machine-guarding/presses/powered-press-brakes) classifies press brakes as a distinct machine family that can have hydraulic, hydra-mechanical or mechanical drives; it specifically identifies workpiece swing and unintended foot-pedal cycling hazards. **DOC-CONFIRMED regulator guidance**, not a Type-C normative acceptance test and not a claim that all brakes share one stop function.
- OSHA's separate [hydraulic-press eTool](https://www.osha.gov/etools/machine-guarding/presses/hydraulic) describes general hydraulic presses. The distinction reinforces that the actuator technology alone does not select the machine-specific standard or safeguarding method.
- WorkSafe Victoria's [power-press safety guidance](https://www.worksafe.vic.gov.au/controlling-risks-power-press-machines) identifies independent physical ram chocks for maintenance as an example, along with guarded pedals and interlocks. **DOC-CONFIRMED jurisdiction-specific guidance**, not selected OpenPressBrake chock strength, proof of holding, or an emergency-release instruction.
- This independent scope cross-check resolves the documentary category question without a simulation. It does **not** resolve installed machine guard geometry, gravity support, qualified rescue path or regulatory adoption.


## 2026-10-27 publisher-edition correction — ISO 6909:2026 now published

The original 2026-10-25 source scope correctly excluded ISO 16092-1/-3 as the press-brake Type-C substitute but was **incomplete about the current international/European press-brake edition**. ISO's [official ISO 6909:2026 record](https://www.iso.org/standard/83403.html) states the first press-brake-specific international edition was published **2026-05-29**; the [EVS EN ISO 6909:2026 adoption](https://www.evs.ee/en/evs-en-iso-6909-2026) is valid **2026-07-01**; European Commission [Decision (EU) 2026/2015](https://eur-lex.europa.eu/legal-content/EN/TXT/PDF/?uri=CELEX%3A32026D2015) lists EN ISO 6909:2026. The published abstract includes hydraulic/servo press brakes, excludes automatic workpiece loading/unloading safety and states it does not apply to machines manufactured before publication. **Do not silently replace historical EN 12622 for legacy-machine evidence or claim a 2026 edition retroactively certifies a retrofit.** See [exact official publisher/edition audit](4400_PRESS_BRAKE_ISO6909_2026_TYPE_C_PUBLICATION_SCOPE_AND_LEGACY_RETROFIT_GATE_2026-10-27.md). Normative clauses, machine date/jurisdiction and qualified applicability remain UNKNOWN; G0/G1 HOLD.
