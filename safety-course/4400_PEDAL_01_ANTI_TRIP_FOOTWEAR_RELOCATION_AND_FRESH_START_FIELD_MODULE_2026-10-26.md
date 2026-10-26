# 4400-PEDAL-01 — A guarded foot pedal that people will actually use

Date: 2026-10-26. **Practical public technician module; NON-GRADUATED.** Companion [direct Linemaster/OSHA source audit](../research/4400_PEDAL_01_LINEMASTER_ANTI_TRIP_SIGHTGUARD_OSHA_PRESS_BRAKE_SCOPE_AUDIT_2026-10-26.md). No machine evidence, testing, external score or release.

## Learning objective

Distinguish **reducing inadvertent command initiation** from **protecting the point of operation**, **enforcing deliberate restart**, and **actually stopping/holding the machine**. Propose a guarded foot station that does not encourage foreseeable bypass through awkward footwear fit, bad visibility, difficult cleaning or unreliable mounting. Preserve the exact model and regulation scope.

## Start with the device identity, not the label

- **511-B4OXG Linemaster Anti Trip Hercules Gated OX:** OEM specifies a mechanical latch release before treadle depression, two return springs, cast shield, OX oversize-shoe geometry and floor/equipment mounting holes. It is an exact-model claim, **not** a certified safety-controller specification.
- **Linemaster SightGuard:** OEM describes top visibility and 180-degree lateral access; compatibility is stated for Aquiline, Treadlite and Dolphin families. Its open architecture is **not equivalent** to the gated 511-B4OXG.
- **OSHA scope trap:** 1910.217(a)(5) excludes press brakes; its foot-control subsections may be informative but are **not directly applicable mandatory press-brake rules**. General press-brake guarding must be evaluated under applicable requirements including 1910.212 where applicable, with the actual machine risk assessment.
- **Prior module:** [dual-pedal AND is not two-hand guarding](4400_DUAL_PEDAL_AND_TWO_HAND_NON_EQUIVALENCE_FIELD_CARD_2026-10-23.md). This lesson is about *physical single-station ergonomics and inadvertent initiation*, not rebranding that earlier Boolean-control finding.

## Practical design contract: five separate propositions

| Layer | Question to answer | Evidence accepted | Never use as substitute |
|---|---|---|---|
| Command | Does a deliberate foot movement close the selected contact(s)? | Exact switch model, contact diagram, measured **de-energized** wiring as appropriate | HMI “ready” alone |
| Anti-trip | Can a dropped part, second foot, oversized boot or moving pedal cause a false command? | Exact shield/latch geometry, approved footwear, stable mounting and no-energy fit/inspection | “Guarded” catalog adjective |
| Protective coverage | Are hands and others protected at die and rear/workpiece-sweep hazards? | Machine-specific guard/ESPE/other SRS, geometry, independent protective-function evidence | Foot pedal, two-pedal AND or training |
| Restart | Does a held/stuck pedal or restored supply cause new motion? | Selected reset/anti-repeat/fresh-edge SRS, safety-logic review and qualified validation | LinuxCNC E-stop lamp |
| Physical state | Will Y1/Y2 actually stop and remain supported and hazardous pressure be controlled? | Qualified independent stop, holding, energy isolation and physical witnesses | Switch contacts, FPGA state or pedal guard |

## Twelve PUBLIC PAPER challenges — all **UNSCORED**

For each, identify: (a) which layer is affected; (b) the unsafe shortcut; (c) what exact evidence could distinguish the failure; (d) the least-inconvenient safer redesign; (e) why G0/G1 cannot be released from a paper answer.

1. A narrow full shield will not admit the operator's metatarsal boots; someone proposes removing the shield.
2. A sheet offcut slides from the work table and lands beside the foot control; the installer says the treadle spring will always return.
3. A clean pedal is tested on dry concrete, then deployed on an oily floor where it moves during operation.
4. A second operator walks behind a press while the first operates a guarded foot switch; the guarded switch is proposed as proof of rear-zone protection.
5. A new open-sided accessory improves foot entry but allows a trolley wheel to approach laterally. Contrast **SightGuard** with the exact gated anti-trip model; do not assume accessory interchangeability.
6. The operator habitually rests a foot on the treadle between cycles. Explain why retraining alone is not a credible complete control.
7. A technician finds two contact poles in a foot switch and writes “Category 3 / PL d achieved” without wiring or fault evidence.
8. A portable foot station is moved to the opposite side of a large workpiece, changing visibility and cable exposure without changing the PLC program.
9. A foot cable is pinched by a pallet; the ordinary HMI continues to show a stable input. Determine what is and is not proven.
10. A pedal remains pressed during an E-stop and through a safety-controller reset. A LinuxCNC button is then pressed to enable motion.
11. The guard accumulates chips; cleaning requires four loose screws and 15 minutes, so a shift supervisor removes it permanently.
12. An installer quotes **1910.217(b)(4)** as a mandatory hydraulic press-brake design requirement. Reconcile that with **1910.217(a)(5)** and the separate machine-guarding duty.

No answer key is published; these cases are *not* independent/blind scores.

## Twelve documentary gates — all **NOT RUN**

| Gate | Required evidence (or UNKNOWN) | Why it matters |
|---|---|---|
| PED-G01 | Installed switch/guard exact manufacturer and revision | Prevents catalog-family transfer |
| PED-G02 | Contact topology and wiring to ordinary/safety-related inputs | No assumed redundant diagnostics |
| PED-G03 | Shield/latch sequence and fit with actual footwear | Accidental activation and bypass pressure |
| PED-G04 | Stable mounting, floor condition, cable routing and strain relief | Prevent movement and cable damage |
| PED-G05 | Side/falling-object access with representative workplace objects | Guard opening may defeat intent |
| PED-G06 | Foot-rest, fatigue, visibility and operator access | Make safer use easier |
| PED-G07 | Cleaning, reassembly and correct replacement parts | Guard return-to-service integrity |
| PED-G08 | Mode/station selection and relocation change-control | Avoid surprise alternate command station |
| PED-G09 | Anti-repeat/fresh-command after hold, power loss, guard stop and reset | Prevent unexpected restart |
| PED-G10 | Separate point-of-operation/rear/workpiece guarding SRS | Pedal never proves hand clearance |
| PED-G11 | Independent Y1/Y2 stop, gravity holding and energy-isolation proof | Physical safe state, not software request |
| PED-G12 | Independent evaluator, qualified validation, evidence provenance and change closure | No self-graduation or guessed PL/SIL |

All selected-machine fields are **UNKNOWN**; none of these gates can be marked PASS by desk study alone. No hardware contact manipulation, hazardous machine actuation or energized test is authorized by this card.

## Technician's no-energy design sketch

Draw the operator's normal foot path, neutral foot-rest, pedal shield, latch, cable, mounting and nearby moving-object paths. Compare a *full gated design* with a *visible open-sided design* against the **actual** operator footwear, floor and material handling. Mark likely points where people would remove or bypass a nuisance guard. Prefer an OEM-matched guarded switch that can be kept clean and restored without improvised fasteners. If access or visibility is poor, relocate/redesign the whole station under controlled change rather than simply taking the guard off.

Then draw the **separate** control boundary:

`pedal ordinary request -> LinuxCNC/FPGA normal control` (not safety authority)

`guard/ESPE/E-stop -> qualified independent safety-related logic -> independently validated final elements -> physical stop/hold`

`LOTO/physical support -> verified maintenance isolation` (not an E-stop reset).

Do not wire a notional circuit from this exercise; actual safety functions require exact selected design and validation.

## Handoff and release

An unseen evaluator should give a new pedal/footwear/material-handling combination and ask for an evidence-ranked decision before revealing a source-backed rubric. Record learner precommitment and confidence first. **No evaluator has run.** No TEST-CONFIRMED claim, PL/SIL, stopping distance, hydraulic truth table or physical machine proof is available.

**G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** No personnel-exposed hazardous operation. Isolated/remote experimental operation, if separately authorized, must keep everyone outside the danger zone and state residual risks.
