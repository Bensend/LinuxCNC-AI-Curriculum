# 4400 — Mode-dependent safeguard validation matrix (planning only)

**Status:** DRAFT VALIDATION PLAN / ALL TESTS **NOT RUN**. The table is a machine-specific SRS/VAL authoring aid, not a permission or procedure to energize a press brake. Companion manufacturer example: Fiessler AKAS-5M, operating instructions doc 1581, 2024-02-15, pp. 4–5, 9–11, 24–26, 42–43, https://www.fiessler.de/default-wAssets/docs/download/AKAS/bdh-akas-5-original-engl-doc1581-v1.0.pdf. Qualified personnel must derive the actual safe test method and acceptance limits for the selected machine.

| VAL candidate | Adversarial precondition/question | Safety-related behavior that must be independently established | Physical/independent witness | Unknown/stop gate |
|---|---|---|---|---|
| VAL-MUT-01 | Ordinary NC requests box mode but safety authorization missing | No unqualified protective-field suppression | Safety-related mode state and selected guard coverage | Selected controller logic UNKNOWN |
| VAL-MUT-02 | Field interrupted during a mode in which the relevant elements are active | Selected protective function withdraws hazardous closing authority | Final-element change plus independent ram stop/hold | Stop time, overrun and hold UNKNOWN |
| VAL-MUT-03 | Field deliberately muted for approved forming mode | Alternative safety function remains valid through whole exposed task | Qualified actual speed/position, tooling reach, residual pinch risk, safety output/final element | Mode-specific exposure acceptance UNKNOWN |
| VAL-MUT-04 | Normal controller requests slow but independent witness reports contradictory actual speed | Independent safety-related authority wins over ordinary request | Independent speed witness and final energy path/ram motion | Actual sensors and safe-state logic UNKNOWN |
| VAL-MUT-05 | Tool height, punch or die changes | Previous guard alignment/muting evidence becomes STALE | New geometry and independently verified protection/overrun | Tool identity/geometry UNKNOWN |
| VAL-MUT-06 | Setup mode ends; ordinary start request remains asserted | Special muting is cancelled and deliberate rearm is distinct from normal start | Safety mode state, actual final-element and motion witness | Restart logic UNKNOWN |
| VAL-MUT-07 | Power interrupted/restored during setup or box mode | No unqualified fast restart or inherited stale permission | Independent safety state, actual motion and mode restoration | Product-specific power-up semantics UNKNOWN |
| VAL-MUT-08 | Hydraulic valve reports expected state but ram/pressure contradicts it | Physical contradiction blocks safety acceptance | Independent ram motion/load restraint and relevant pressure zones | Circuit truth table, pressure locations UNKNOWN |
| VAL-MUT-09 | Operator needs to form a part that regularly causes nuisance trips | Correct protected method remains practical without defeat | Observed task/workholding/guard setup, not HMI statistics alone | Real operator workflow UNKNOWN |
| VAL-MUT-10 | Servicing requires access to hazardous energy | Production stop/muting not treated as isolation | Lockable isolating means, stored-energy disposition, restraint and verification | Maintenance energy map UNKNOWN |

## Traceability and acceptance discipline

Link each selected `VAL` to `BND/ENE/HAZ/SF/PHY/SRS/AUTH/DEP/HF/ARC/PT/CHG/UNK/RR`. Record the selected safety device's exact catalog, manual revision, controller firmware, actual hydraulic/electrical drawing, tooling and measured stop/holding evidence. If an upstream assumption changes, retain historical evidence but mark dependents STALE. No synthetic numeric speed, pressure, distance, diagnostic coverage, PL/SIL or interval is supplied here.

## Execution prohibition pending machine evidence

Do **not** run these cases on an attended hazardous machine from this worksheet. A qualified machine-safety plan must first define isolation/remote-test conditions, who controls the danger zone, expected failure energy, positive load restraint, stop criteria and residual risks. If a basic safe-to-operate threshold cannot be independently demonstrated, do not expose people to the hazard.
