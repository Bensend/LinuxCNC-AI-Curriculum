# 4400-CYCLE-LIFE-01 — Contact duty is not a perpetual PL: technician review card
**2026-10-28 | open-book documentary check | NOT a live test or machine release**

Read [exact-OEM Pilz PZE X4P/Rockwell audit](../research/4400_CYCLE_LIFE_01_PILZ_PZE_X4P_CONTACT_DUTY_AND_ROCKWELL_OPERATOR_B10D_SOURCE_DEPTH_2026-10-28.md), then the existing [CYCLE-01 module](4400_CYCLE_01_ON_STATE_DIAGNOSTIC_GAPS_AND_SAFE_PROOF_WORKFLOW_MODULE_2026-10-26.md) and [2550 use-profile examples](2550_EXAMPLE_ARCHITECTURES_AND_ASSUMPTION_TRAPS_2026-09-23.md). This is an **exact manufacturer addendum**, not a new blind test or repeated diagnostic-cycle module.

## The shop-floor decision
An electrical retrofit uses a familiar contact expansion block. The safety drawing and part number look unchanged, but production now opens and closes its contacts every stroke. The maintenance note says “PL e; 20-year mission time,” and a spare contact formerly switching a large load is moved into a low-current feedback circuit.

**Do not accept the substitution from those labels.** For the documented Pilz PZE X4P, output service-life curves depend on switched current, category and switching frequency; the manual warns against reusing high-current contacts for low-current duty. Its published PL/PFH/TM describes the component **within specified conditions**, not an unlimited lifetime or the complete machine.

## One-page qualified review (no energized testing)
| Question | Evidence to locate | If missing |
|---|---|---|
| Is this the actual part? | Selected SKU, revision, base safety relay, wiring and manual edition | UNKNOWN — no component rating transfer |
| How often does each contact actually change state? | Operation count for **this output**, including all functions, versus original use profile | HOLD duty assumption |
| What does it switch? | Actual voltage, current/inrush, AC/DC utilization category, suppression, number of simultaneously loaded contacts | HOLD service-life applicability |
| Has the contact changed duty? | Replacement history and previous high-current use | HOLD reuse suitability |
| Is opening periodically verified? | Exact OEM method, qualified approved schedule and dated results | HOLD proof of diagnostic currency |
| What does the output physically remove? | Independent safety logic, EDM, selected contactor/valve/drive and actual machine stop/hold | HOLD physical safety proposition |
| How is production resumed? | Verified area clear, independent safety rearm and **separate fresh** normal start | HOLD restart |

**Important distinction:** The Pilz PZE X4P manual gives an example of 2,000,000 contact cycles for its specified 0.2 A AC15 inductive case, and conditional monthly/yearly opening checks for its specified integrity context. Neither is a universal service interval. A Rockwell 800G assembled-station page lists different B10d figures for selector, pushbutton and contact blocks; that specific station is **not suitable for E-stop**. Do not use it as a retrofit recommendation.

**Human factors:** Make the duty register and approved maintenance schedule short and easy to find; use a convenient approved proof window with energy hazards controlled. A difficult proof procedure invites skipped checks, while a nuisance trip invites unsafe bypass. Improve the design rather than hiding the warning.

**Boundary:** Ordinary LinuxCNC/HAL/FPGA can count normal cycles and flag maintenance due, but that counter is not safety-rated proof of contact opening or independent Y1/Y2 gravity holding. Do not authorize hazardous personnel exposure from a green HMI or an unverified maintenance spreadsheet.

**Status:** DOC-CONFIRMED manufacturer facts; INFERENCE suggested duty register; selected OpenPressBrake evidence UNKNOWN, TEST-CONFIRMED none, external 2520–25F0 evaluator OPEN. **G0/G1 HOLD; no personnel-exposed operation.**
