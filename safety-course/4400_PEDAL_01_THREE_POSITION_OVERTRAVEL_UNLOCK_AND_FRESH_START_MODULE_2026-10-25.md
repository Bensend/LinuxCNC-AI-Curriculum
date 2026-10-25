# 4400-PEDAL-01 — Three-position foot switches: overtravel stop, unlock pulse and deliberate new start
**2026-10-25 | 4000 safety implementation course | RESEARCH/LEARNER-READY, NON-GRADUATED | physical VAL/PT NOT RUN**

## Learning outcome
A fresh engineer can distinguish the **physical pedal**, its **ordinary motion command**, its **safety-related contacts**, the **independent safety controller/final element**, and the **actual stopped/held ram**; can spot an unlock/release pulse and unsafe retained-command path; and can reject a visually similar but behaviorally different replacement without inventing a machine-specific wiring diagram.

Prerequisites: 2520 hazard/SRS, 2530 E-stop/reset, 2540 safety relay/final elements, 2550/2560 integrity methods, 2580 hydraulic/gravity load, 2590 guards, 4400-GUARD-01 and 4400-RESCUE-01. Previous two-pedal AND versus two-hand safety-function work is complementary, **not** a substitute for this module.

## 1. Identify the real hazard before naming a pedal
Hazard: a person's hand, body or helper enters the die/ram, sheet-sweep, backgauge or other moving mechanism zone during a foot-commanded stroke. A foot pedal is an operator interface; it is **not** a universal safeguard. Define independently:
- **SF-PEDAL-OVERTRAVEL:** a qualified safety-related overtravel demand initiates the selected stop function and prevents further dangerous motion requests in the defined mode.
- **SF-PEDAL-REARM:** releasing or mechanically unlocking the pedal does **not** by itself initiate a dangerous movement; a separate, deliberate, permitted new start is required under qualified conditions.
- **SF-PEDAL-FAULT:** broken/crossed channels, stuck pedal, contamination and unsafe substitutions have a defined detection/response basis in the selected safety architecture.
- **SF-RAM-STOP/HOLD:** independent Y1/Y2 stop and gravity holding; no pedal electrical state proves these physical propositions.
- **SF-MAINTENANCE:** foot pedal or E-stop does not replace isolating electrical, hydraulic, gas, gravity and trapped energy for service.

## 2. What original manufacturers actually say
Read the [source audit](../research/4400_FOOT_PEDAL_LATCH_UNLOCK_PULSE_IK_RELEASE_VARIANT_OEM_AUDIT_2026-10-25.md) before treating any pedal as equivalent.

**Schmersal T.FH 232-..UEDR (original OEM manual, p.2):** mid-press permits the safety release, push-through opens/latches a positive-break NC contact, and a blue pushbutton mechanically unlocks. The manufacturer expressly warns that **unlocking can produce a switch-on impulse which the control system must suppress**. This is the key counterexample to "unlock is always harmless." [Official manual](https://products.schmersal.com/media/documents/DOC_MAN_MEC_siss-mrl-tfh232_SEN_AIN_V4.pdf).

**steute GFS IK 2S D 2Ö VD, article 1441615:** OEM describes an internal baffle that changes contact roles after the pressure point and a variant **without a switching impulse on release**. It is **not** proof that a selected safety chain is wired or validated correctly. [Exact product](https://www.steute-controltec.com/en-us/product/gfs-ik-2s-d-2oe-vd-66518).

**Fiessler/PBS FE-FS2 retrofit assembly, 2018 original manual p.24:** right pedal is three-position; working and safety contact pairs have different transitions. The described restart requires release, while the left pedal is a distinct two-position function. This does **not** prove mechanical latching or an independent fresh-start safeguard on another machine. [Original manual](https://www.pressbrakesafety.com/wp-content/uploads/2019/02/AKAS-Operator-Manual-01-26-18.pdf).

**Do not transfer** terminal numbers, contact polarity, reset style, B10d, PL, operating force, response time or latch state across these variants.

## 3. Four authority layers
| Layer | Legitimate role | Cannot prove |
|---|---|---|
| Physical foot switch | Operator input and, for selected devices, safety-contact actuation | machine stopped, load held, safe restart |
| Normal LinuxCNC/HAL/FPGA | Mode, feed command, visualization, diagnostics, sequence management | personnel-safety function or physical final-element proof |
| Independent safety-related control | Evaluate selected dual channels, discrepancies, fault/reset/rearm conditions; command safety final elements | load physically stopped/held solely because output is off |
| Final elements and independent witness | Qualified valves/brakes/drive/contactors plus independent motion/holding/energy measurements | all other hazards covered unless separately established |

Normal UI may report a fault, but it cannot silently override safety inhibition. A safety controller may signal normal control to discard stale motion commands; the physical safety path must not depend on LinuxCNC correctly doing so.

## 4. Abstract transition model — for analysis, NOT executable logic
| State | Pedal observation | Permitted conceptual action | Hazardous request |
|---|---|---|---|
| P0 neutral | fully released; safety channels qualified | monitor readiness; do not infer a start | **not from neutral alone** |
| P1 working range | new deliberate press, all other qualified preconditions true | normal motion request *may* be evaluated | only through selected independent safety authority |
| P2 overtravel | pressure point exceeded; protective contact changes | demand safety stop, inhibit motion | **no** |
| P3 return from overtravel | pedal released but latched/stop not rearmed | retain inhibition | **no** |
| P4 mechanical unlock/reset | latch clears; transient may occur in UEDR | discard/suppress unlock impulse; check reset preconditions | **no** |
| P5 rearmed neutral | qualified protective conditions and deliberate reset accepted; ordinary request cleared | wait for **fresh intentional start edge** | **no until fresh edge** |
| P6 new cycle request | separate intentional post-rearm action | evaluate command and physical safeguarding | only if selected safety function permits |

This is a **requirements sketch**, not a safety PLC program or universal OEM transition truth table. The selected machine may have other modes, dual-role UP/RESET pedals, alternative safety devices or independent rescue paths. No numerical time/debounce setting is justified here.

### Invariants for adversarial review
1. `UNLOCK_EVENT` alone never implies `NEW_START`.
2. `SAFETY_RESET` alone never implies `HAZARDOUS_MOTION`.
3. A held, welded, stale or repeated ordinary foot/HAL command cannot bypass the independent safety decision.
4. A detected safety input fault does not prove the ram has stopped; physical final-element and Y1/Y2 holding witnesses remain distinct.
5. A mode change, pedal replacement, safety relay reset-parameter change or wiring repair makes affected proof **STALE** until reviewed/revalidated.
6. Maintenance access requires actual energy isolation/restraint, not merely a neutral pedal.
7. An operator can use the guard and pedal conveniently; a workaround caused by bad ergonomics is a design defect.

## 5. Failure paths to challenge
**F1 — Unlock transient:** UEDR mechanical unlock produces an electrical impulse; receiver mistakes it for a new press. Consequence: potential unexpected cycle request. Mitigation concept: independently reviewed fresh-start and unlock-event rejection; do not invent a fixed debounce duration.

**F2 — Retained ordinary command:** a custom LinuxCNC/HAL/FPGA interface or downstream controller retains a motion request across safety reset and could drive movement when final elements re-enable. This is an **INFERENCE scenario**, not a claim about every LinuxCNC UI. The [pinned HALUI source trace](../research/4400_LINUXCNC_PINNED_HALUI_PROGRAM_RUN_EDGE_VS_SAFETY_REARM_SOURCE_TRACE_2026-10-25.md) shows that ordinary `halui.program.run` dispatches on a **0 -> 1 rising edge**, not repeatedly for a continuously held high in the same process. A new unlock pulse can nevertheless generate an ordinary run request; Task acceptance and physical motion remain unproven. Requirement: an old or transient request cannot initiate a new stroke after reset; verify independent safety inhibit and fresh command.

**F3 — Pedal swap:** replacement has same number of terminals and enclosure but different latch/impulse/contact transition. Require exact variant qualification, terminal-state table, control logic and physical proof; reject visual similarity.

**F4 — Two pedals conflated:** left pedal is normal mode/UP and right pedal has overtravel safety function; tying both into one Boolean AND is not two-hand control and may obscure which safety demand stopped which actuator.

**F5 — Dirt, damaged cover or stuck mechanism:** protective shield improves accidental-actuation resistance but can trap debris or be removed for convenience. Provide accessible cleaning/inspection and replacement, not wedge or bypass.

**F6 — Electrical safety response but hydraulic drift:** safety contact and safety relay change correctly, but gravity, leakage or accumulator pressure moves the ram. STOP/HOLD and ENERGY remain UNKNOWN until physical independent verification.

## 6. Minimum safe-to-operate threshold
A selected press brake cannot be released for **people-exposed hazardous operation** when the pedal stop/rearm behavior, independent safety authority, ram stop/hold, guarding, rescue and stored-energy boundaries have not been qualified. If engineering experiments are justified, only a separately approved **isolated/remote** plan with personnel outside danger zones, secondary restraint, abort/containment and explicit residual risk may proceed. This module authorizes **no** energized or human-entrapment tests.

## 7. Human factors — safer should be easier
An anti-accidental-actuation shield, reachable pedal position, stable non-slip mounting, protected cable routing, easy debris removal and legible neutral/working/overtravel indications should make correct use natural. A reset location should discourage blind rearm but not force unsafe reaches. Review seated/standing use, PPE/footwear, sheet-handling stance, left/right foot tasks and service access. An operator's temptation to prop open the cover or wedge a switch is evidence to improve the design **without removing the protection**.

## 8. Learning verification and promotion
Complete the [technician cases and blank witness](4400_PEDAL_01_TECHNICIAN_TRANSITIONS_AND_BLANK_WITNESS_2026-10-25.md) without consulting hidden evaluator material. External independent evaluator challenge remains PREPARED/NOT RUN. Documentary claim strength **DOC-CONFIRMED** for exact OEMs; state model **INFERENCE**; selected physical behavior **UNKNOWN**; **TEST-CONFIRMED none**. Do not graduate on the strength of a written module alone.

**Promotion/open items:** exact selected OpenPressBrake footswitch/safety-controller input channels, actual reset/retained-command response, Y1/Y2 independent stop/hold, selected pedal release waveform if relevant, and independent evaluation. These **block selected-machine safety release**, not further unrelated 4400 research.

**Next:** restricted G0 packet A/C/F and qualified no-energy transition review; otherwise rotate to a different unresolved 4400 safety hazard. No generic compute lab is justified by already explicit OEM warning.
