# 4400-PEDAL-01 — A three-position safety foot pedal can produce a new enable pulse while being unlocked
**2026-10-25 | original OEM source audit | 4400 safety course | NON-GRADUATED | no selected-machine evidence**

## Decision question and why this was worth studying
A press-brake operator presses a guarded, three-position pedal past its pressure point to demand a protective stop. After the hazard clears, the operator releases the pedal and operates its mechanical unlock. **Can the unlock itself create an electrical switching impulse which a naïve control interprets as a fresh cycle request?** Yes, for the documented Schmersal UEDR family; the manufacturer explicitly requires the machine controller to suppress that impulse. This is a distinct failure path from ordinary E-stop reset and from the previously studied two-pedal-AND/two-hand-control non-equivalence. It makes an attractive replacement-pedal "equivalence" claim false unless the exact contact/release/reset behavior is reviewed.

## Primary source A — Schmersal original operating instructions (directly inspected)
**Document:** Schmersal *T.FH 232-..UEDR.. Operating instructions, Safety foot switches*, English original, document code **101211081-EN / I, 05.2021**, 5 PDF pages in publisher file (printed pp.1–5, table on printed p.2). Direct official PDF: https://products.schmersal.com/media/documents/DOC_MAN_MEC_siss-mrl-tfh232_SEN_AIN_V4.pdf . Inspected the printed p.2 state diagram visually and pp.1–5 extracted text.

- **DOC-CONFIRMED, printed p.2 §2.1:** TFH 232-11UEDR (1 NO/1 NC), TFH 232-22UEDR (2 NO/2 NC), T2FH 232 two-pedal mixed variants. A second pedal in a two-pedal enclosure may be **non-safety-related**, without the UEDR overlapping/latching behavior; do not assume both pedals have the same safety function.
- **DOC-CONFIRMED, printed p.2 §2.3 and four-row state diagram:** at rest, no authorized operation; actuated to pressure point, safety release; pressed beyond pressure point, positive-opening NC opens and **mechanically latches**; mechanical unlock via a **blue pushbutton** restores the slider. The diagram labels unlock as **no authorized operation**.
- **CRITICAL DOC-CONFIRMED, printed p.2 diagram footnote:** `The switch-on impulse during the unlocking operation must be suppressed by means of measures at control technology level.` This is an explicit requirement on the **receiving control**, not a claim that the foot switch prevents the impulse by itself. The same page says the whole machine safety chain must be evaluated and validated.
- **DOC-CONFIRMED, printed p.3 §2.5:** NC contact B10D = 100,000, mission time 20 years, with application-specific duty inputs. Neither number is a machine PL, diagnostic coverage, stop time or permission to use one channel.
- **DOC-CONFIRMED, printed p.4 §§4.2–4.3:** contact configurations differ; manufacturer illustrates connection to an SRB-E301MC safety relay and explicitly notes a single-channel jumper option. **An example wiring option is not a recommendation to collapse redundancy** or evidence of a particular selected machine.
- **DOC-CONFIRMED, printed p.4 §5:** inspect cable entry, enclosure, switch operation and accumulated dirt under pedal; replace damaged/defective components. A protected pedal can still become hard to actuate or release through contamination.
- **Limit:** This is a 2021 document for exact UEDR variants; do not extend its mechanical latch, blue unlock or impulse behavior to every foot switch sold by Schmersal.

## Primary source B — steute IK anti-release-impulse variant (direct OEM product specification)
**Exact product:** steute Controltec **GFS IK 2S D 2Ö VD**, article **1441615**. Official product record: https://www.steute-controltec.com/en-us/product/gfs-ik-2s-d-2oe-vd-66518 (inspected 2026-10-25; no separate full instruction PDF directly inspected).

- **DOC-CONFIRMED, Product features:** manufacturer explicitly describes **without switching impulse when releasing foot switch**. It says NO contacts **33–34 and 43–44** are converted by an internal baffle after the pressure point into positive-break NC safety contacts; two further direct-opening NC contacts act as signal contacts after pressure point.
- **DOC-CONFIRMED, Technical data:** positive-break contacts, specified pressure point approximately **245 N**, article-specific B10d 200,000 (10% load), TM up to 20 years. These are component data, **not a press-brake force setting or a machine PL**.
- **INFERENCE:** An internal no-release-impulse mechanism may eliminate one known electrical transition of the Schmersal type, but it does **not** by itself establish machine-level fresh-start gating, no stored motion command, no common-cause wiring fault or independent physical stop/hold. Do not claim that the IK pedal is a drop-in replacement: exact terminals, reset semantics, channel diagnostics and safety chain must be requalified.
- **UNKNOWN:** the 2025 steute mounting/wiring PDF and its full transition diagram were listed on the product page but not directly inspected here. Product-page claims are narrower than an exhaustive timing or fault table.

## Primary source C — actual press-brake retrofit operator manual (direct PDF and visual diagram)
**Document:** PBS Mfg / Fiessler *AKAS Active Optical Protective Device, Operators Manual v2.02*, dated **2018-01-26**, original 38-page PDF, **printed p.24** "3 Position Red Safety Foot Pedal and electrical connection diagram". https://www.pressbrakesafety.com/wp-content/uploads/2019/02/AKAS-Operator-Manual-01-26-18.pdf . Printed p.24 switching diagram inspected visually.

- **DOC-CONFIRMED, printed p.24:** example left pedal has two positions and may select box-bending/opening; example right pedal has three positions and a pressure point for hazardous downward motion. Right pedal uses a working 1NC+1NO pair and a positive-opening NC+NO safety pair. At overtravel the working pair returns to rest while the safety contact changes to stop the hazardous movement. The manual says restart is only possible **after releasing** the foot switch.
- **SOURCE TEXT CONFLICT / DOC-CONFIRMED diagram, UNKNOWN intended sentence:** Printed p.24 text literally says the positive-opening safety contact is activated to "initiate immediately the dangerous movement", which conflicts with its surrounding safety-stop explanation and diagram. **Do not silently repair that sentence or rely on it as an executable stop truth table.** The contact diagram shows the working NO closing at pressure point then opening at full depression, while the safety-side NC opens on full depression; interpreting that as a stop demand is an **INFERENCE** consistent with the manual's protective purpose. Verify the exact current Fiessler OEM instructions and selected safety receiver before using this architecture. No physical stop behavior is TEST-CONFIRMED.
- **DOC-CONFIRMED scope caution:** This is the described **Fiessler FE-FS2-U1/SU1ASDU1-U-RD** retrofit assembly, **not** evidence that all three-position pedals mechanically latch, have the same reset mechanism or are installed on OpenPressBrake.
- **Important correction:** The manual's text says the overtravel safety contact initiates the stop; it is **not** proof that the machine physically stopped/held against gravity. A manufacturer diagram showing redundant information does not establish selected system category, PL, hydraulic final elements, ram overrun or guarding coverage.
- **UNKNOWN:** exact full assembly variant and whether an independent safety controller rejects a release/overtravel transition after the ordinary control has latched a downward command on a given retrofit.

## Comparison: three plausible but incompatible assumptions
| Engineering question | Schmersal T.FH 232-..UEDR | steute GFS IK article 1441615 | Fiessler/PBS illustrated FE-FS2 |
|---|---|---|---|
| Overtravel action | positive-break NC opens, mechanically latched | internal baffle converts specified contacts to positive-break NC | working contacts return, separate positive-opening safety contact changes |
| Return/unlock behavior | **manual blue unlock**, OEM warns of switch-on impulse | **OEM says no release switching impulse** for this exact IK variant; full timing UNKNOWN | restart only after **foot release** in described assembly; latch mechanism not asserted |
| Two-pedal semantics | non-safety second pedal possible | article is single-pedal; dual models separate | left pedal function differs from right |
| Safe restart guaranteed by device alone? | **NO**, receiving controller must suppress impulse | **NO**, whole-machine restart authority remains separate | **NO**, release is a necessary condition in this manual, not full machine proof |
| Selected OpenPressBrake installed? | UNKNOWN | UNKNOWN | UNKNOWN |

## Abstract safety/control transition counterexample — not a wiring prescription
Define independent propositions: `SAFE_CHAIN_OK` (qualified independent safety controller's own decision), `NORMAL_PEDAL_REQUEST` (ordinary LinuxCNC input), `FRESH_CYCLE_EDGE` (deliberate post-reset command event), `PHYSICAL_STOP_HOLD` (independent machine witness).

1. A simplistic implementation maps pedal NO high to `cycle_start` and uses a retained command or an automatic-reset safety relay.
2. The operator pushes through to the safety stop; the physical latch opens the safety path.
3. During **manual unlock**, a transient contact transition is possible per Schmersal's explicit warning.
4. If the receiving logic treats that transition as a valid new start (or immediately honors a retained command), a hazardous motion request can reappear **without a new intentional pedal press**.
5. The correct safety requirement is **not** "debounce the pedal for N ms" (no justified N exists). It is a selected, independently reviewed reset/rearm design that prevents an unlock transient and retained ordinary command from authorizing hazardous movement, then requires a new deliberate actuation under verified protective conditions.
6. The final proof is physical: independent stop/hold and restart observation on the selected machine, with nobody exposed; a HAL bit or pedal continuity trace cannot substitute.

This is an **INFERENCE failure-path model** using the manufacturer's warning, not a TEST-CONFIRMED observed accident or an executable safety design.

## Fault/defeat review
- **Mechanical:** jammed slider, missing spring, dirt under shield, damaged return, wedged pedal, inadvertent overtravel, pedal tipped/moved into a sheet path.
- **Electrical:** NC/NO cross-wire, single channel jumper mistaken for redundant architecture, common cable damage, short across safety contact, held input, false "ready" HMI, transient during unlock.
- **Control:** ordinary LinuxCNC MDI/program retained cycle request, safety relay automatic reset without fresh-start interlock, ambiguous UP/RESET/DOWN pedal roles, configuration drift.
- **Human factors:** pedal too awkward to locate, too high an actuation force for legitimate operator, debris accumulating under guard, unsafe habit of keeping a foot resting on the pedal; improve ergonomics and cleaning rather than defeating the cover or latch.
- **Physical:** correct electrical stop demand with continued ram drift or stored hydraulic/gravity energy. Treat STOP, HOLD, ACCESS and maintenance ENERGY as separate witnesses.

## Evidence ledger and limits
| Claim | Classification | Evidence | Limit |
|---|---|---|---|
| UEDR mechanical unlock can create switch-on impulse | **DOC-CONFIRMED** | Schmersal original manual p.2 explicit footnote | No measured pulse width; exact family only |
| IK 1441615 avoids release switching impulse | **DOC-CONFIRMED** | steute exact OEM product features | Full manual/timing not inspected; not all IK models |
| FE-FS2 right pedal working/safety channels differ | **DOC-CONFIRMED** | PBS/Fiessler p.24 diagram | Specific retrofit assembly |
| Any of these installed on OpenPressBrake | **UNKNOWN** | No selected BOM/part/photo | G0 artifact A/C required |
| Safe electrical command implies stopped/held Y1/Y2 | **FALSE as engineering inference** | safety architecture boundary; physical witness outstanding | **TEST-CONFIRMED none** |
| LinuxCNC ordinary HAL can be personnel-safety authority | **NOT ESTABLISHED / NOT ALLOWED** | existing 4400 safety boundary | Do not allocate personnel-safety function to HAL/normal FPGA |

No physical tests, simulation, live machine motion, local or hosted compute, independent scoring or machine PL/SIL calculation were performed. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED.**

## Next discriminating evidence
1. Restricted selected-machine team supplies **exact installed foot-switch part suffix and wiring**, the safety controller and mode/command/rearm path, plus qualified independent physical stop/hold witnesses. Do not publish proprietary drawings.
2. A qualified reviewer evaluates the **unlock transient / retained-command / automatic-reset** paths with a no-energy transition worksheet before any proposed isolated commissioning.
3. Independent evaluator asks a fresh learner to distinguish the three OEM variants without treating a switch catalog as machine safety proof.
4. Do not freeze a lab: OEM sources already resolve the *existence* of the Schmersal unlock-pulse hazard. Remaining question is selected hardware/physical behavior, which a generic LinuxCNC simulation cannot validate.
