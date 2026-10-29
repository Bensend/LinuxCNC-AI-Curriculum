# 4400-PEDAL-01 — Foot-switch inadvertent actuation, guard usability and regulation-scope trap

Date: 2026-10-26. Status: **DOCUMENTARY RESEARCH / NON-GRADUATED**. No selected OpenPressBrake pedal identified. No tests or machine actuation.

## Question and novelty boundary

Can a guarded pedal be both hard to actuate accidentally and easy enough to use correctly that operators do not move, remove or defeat the guard? Which actual propositions are established by the switch, its shield, and the safety architecture? **Novelty:** physical anti-trip mechanism, footwear/side access, pedal relocation and inspection usability. Prior 2026-10-23 [dual-pedal AND versus two-hand](../safety-course/4400_DUAL_PEDAL_AND_TWO_HAND_NON_EQUIVALENCE_FIELD_CARD_2026-10-23.md) already establishes that two pedals do not protect hands; do not claim that again as a new finding. Prior 2026-10-25 enabling-device material also remains distinct.

## Direct official-source record

| Evidence | Classification | Exact source and claim | Not established |
|---|---|---|---|
| Linemaster Anti Trip Hercules Gated OX, exact product **511-B4OXG** | **DOC-CONFIRMED** | [OEM product page](https://linemaster.com/product/52/anti-trip-hercules-gated-ox-shield/) under “Features & Benefits”: the latch trip lever must be released before the treadle is depressed; two return springs and a latching mechanism are specified. “Options” distinguishes O from OX shoe-clearance geometry, and the model page lists three rigid-mounting holes. | No published PL/SIL, machine-level anti-repeat or protection from hands reaching dies; dual contacts or DPDT-DB are **not** automatically a validated safety function. |
| Linemaster **SightGuard** accessory | **DOC-CONFIRMED** | [OEM accessory page](https://linemaster.com/products/accessories/sightguard/) under “Top Visibility Windows,” “Relieved Side Walls,” and “Mounting Compatibility”: top viewing windows, **180-degree lateral access**, and compatibility with named product families Aquiline/Treadlite/Dolphin. Manufacturer describes accidental-actuation risk reduction, not an independent protective stop. | The open side access and repositionability mean it cannot be presumed to prevent every side intrusion or all inadvertent operation. No equivalence with the 511-B4OXG gate or certified guard. |
| OSHA general press brake machine guarding | **DOC-CONFIRMED** | [OSHA machine-guarding eTool, press mechanical-friction clutch](https://www.osha.gov/etools/machine-guarding/presses/mechanical-friction-clutch) identifies a guarded foot pedal, general guarding under **29 CFR 1910.212**, and the point-of-operation hazard. | No selected hydraulic press-brake safety circuit or universal safe distance. OSHA web direct-open returned 403 in this session; indexed official content was available. |
| OSHA mechanical power press scope | **DOC-CONFIRMED** | [29 CFR 1910.217(a)(5)](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.217) **expressly excludes press brakes**. Section 1910.217(b)(4) and (b)(7)(x) discuss guarded foot controls for machines within that rule. | **Do not cite these specific mechanical-power-press pedal requirements as directly applicable mandatory press-brake clauses.** This is a transfer lesson, not legal determination for an unidentified machine. |
| OSHA foot-control hazard and behavior | **DOC-CONFIRMED** | [OSHA foot-control eTool](https://www.osha.gov/etools/machine-guarding/presses/foot-control) notes accidental activation with hands in point of operation, slippery pedal area, pedal riding, ergonomic foot-rest considerations and excessive production pace. Its 1910.217 examples apply to the relevant mechanical power presses. | Foot rest, guarded pedal and operator training do not themselves prevent exposure to a hazardous press-brake closing point. |

**Source limitation:** OSHA pages were retrieved via official indexed search but direct page opens returned 403. The Linemaster exact-product and accessory pages were directly opened and read. No standard text beyond the official publicly available regulation/eTool passages was inspected. No product installation or safety-certification claim is inferred.

## Four different engineering layers

1. **Initiation device:** momentary foot contact requests a cycle. A switch closure is only a command; dual switch poles do not prove independent channel monitoring or fault response.
2. **Mechanical unintended-actuation prevention:** shield, latch, clearance for safety shoes, stable mounting, non-slip surface, cleaning and cable routing reduce *likelihood of an unwanted command*. A guard that pinches shoes or obstructs use predictably creates bypass pressure.
3. **Independent safeguarding:** the point-of-operation and rear/workpiece-sweep zones need their own risk-reduction measures, protective functions and validated physical stop/hold. No foot pedal—guarded or unguarded—proves hands are clear.
4. **Restart authority:** a stuck/held pedal, power recovery, mode change, guard restoration or E-stop reset must not create an unintended new stroke. Determine fresh-edge/release-before-reinitiation behavior from the selected SRS and safety controller, not a catalog photo or LinuxCNC GUI.
5. **Physical safe state:** safety-related output, hydraulic energy interruption, Y1/Y2 deceleration, gravity holding and pressure isolation are separate physical propositions. The pedal guard does not perform them.

## Adversarial failure-path table

| Initiator / condition | Misleading apparent evidence | Required discriminator | Design consequence |
|---|---|---|---|
| Sheet offcut drops onto exposed treadle | “Pedal is momentary” | Actual shield and latch entry geometry, object sizes and route | Protect against likely falling/moving objects without impossible operator access. |
| Oversized metatarsal boot cannot fit under cover | “Shield installed = safe” | Fit and neutral-foot position with actual approved footwear; operator observation | Select usable compatible shield or different guarded station, **not removal**. |
| Pedal walks on oily floor | “Non-slip feet fitted” | Physical securement and realistic cleaning/service method | Provide stable position and accessible cleaning; do not leave cable as restraint. |
| Operator parks foot on pedal (“rides” it) | “They are trained” | Actual state and anti-repeat/release logic, shift practice | Separate intentional initiation from standing/foot-rest behavior. |
| Side opening admits rolling stock or adjacent operator | “SightGuard says guard” | Exact guard opening and approach geometry | Do not substitute an open accessory for a fully gated anti-trip design without assessment. |
| Cable crushed/shorted or contact welds | “Two poles present” | Wiring, diagnostics, fault exclusions, common-cause and output behavior | Qualified safety function must not be credited without exact circuit/evidence. |
| Pedal held while reset or mode changes | “Green reset lamp” | Fresh command requirement and actual physical final-element witness | Explicit inhibit and deliberate new start when required by SRS. |
| Operator relocates portable station behind workpiece | “Same pedal, same wiring” | Visibility, position, zones, other persons, new risk assessment | Treat location and human access as configuration/change-controlled facts. |

## Minimal safe, low-friction implementation direction (**INFERENCE**, not a frozen design)

Favor a manufacturer-specified shield/latch matched to footwear and duty, positive stable mounting, simple removable debris-cleaning access that preserves correct guard reinstallation, cable protection and strain relief, a neutral foot-rest, and a visible status that distinguishes *command request* from *machine physically safe*. Prefer a captive guard that can be opened for authorized maintenance and reliably returned to service without improvisation. If these measures still invite bypass, redesign the station rather than teaching operators to tolerate it. Evaluate the safety controller and independent final elements separately; ordinary LinuxCNC/FPGA commands and displays remain non-safety.

## Evidence labels and open machine questions

- **SOURCE-CONFIRMED:** none new; prior LinuxCNC ordinary-control authority boundary applies but is not an OEM foot-pedal claim.
- **DOC-CONFIRMED:** exact Linemaster and official OSHA items above.
- **TEST-CONFIRMED:** none.
- **COMMUNITY-REPORTED:** none relied upon.
- **INFERENCE:** ergonomic/access tradeoffs, failure propagation and proposed engineering architecture.
- **UNKNOWN:** installed pedal model, switch/contact topology, footwear, mounting, cable, operator/guard geometry, pedal restart behavior, safety logic, PL/SIL, independent physical Y1/Y2 stop/hold, and whether a pedal is even installed.

**Release:** G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. Do not operate with people exposed until machine-specific basic safety is independently established. Any experimental operation must isolate people outside the danger zone and document residual risks. No simulation or lab is justified before exact selected-machine evidence.


## 2026-10-29 second-branch source reconciliation: anti-trip != anti-repeat (NON-GRADUATED)
**DOC-CONFIRMED exact official regulatory scope:** OSHA's [mechanical-power-press foot-control eTool](https://www.osha.gov/etools/machine-guarding/presses/foot-control) separately describes (a) preventing **accidental foot-pedal activation** and (b) a **single-stroke/anti-repeat** feature allowing only one press cycle per pedal depression. It cites [29 CFR 1910.217(b)(3)(i)](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.217) for the latter. **Crucial limitation:** the regulation's own **1910.217(a)(5) explicitly excludes press brakes and hydraulic/pneumatic power presses** from *that section*. The eTool is a mechanical-power-press illustration, not a mandatory press-brake design clause or permission to infer any OpenPressBrake behavior. The general press-brake point-of-operation safeguard review remains under [1910.212](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.212) with the applicable selected-site standards and SRS.

**INFERENCE safety design discriminator:** a physical shield or anti-trip latch addresses inadvertent **initial depression**, whereas a deliberate **release-before-new-stroke** interlock addresses a pedal held across cycle completion, E-stop reset, power recovery, guard restoration or mode change. Neither one proves independent ram stop/hold, and no universal single-stroke behavior is imposed here on every press-brake mode. In a selected SRS, distinguish `PEDAL_RELEASED`, `FRESH_INTENT_EDGE`, `SAFETY_PERMITTED`, `CYCLE_IN_PROGRESS`, `CYCLE_COMPLETE` and `REARM_REQUIRED` as **propositions**, not as a LinuxCNC implementation or prescribed hydraulic truth table. A stuck contact, latched pedal, unlock pulse, or mode restoration must not silently become a new intentional start when the hazard requires a fresh command. Observe actual operator work so an anti-repeat design does not encourage defeating a hard-to-use guard. No machine evidence, test, new scored cases or performance claim.
