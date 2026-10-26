# 4400 MAT-01 — Pressure-sensitive floors: protective trip, occupancy, channel integrity, and rearm

**Status:** practical 4000-series safety deepening; **NOT GRADUATED**, no independent evaluation or selected-machine proof. **Prerequisites:** 2520 safety-function derivation, 2530 E-stop/restart, 2540 safety relays, 2590 guards/presence sensing, 25F0 machine capstone. **Scope:** pressure mats on guarded mills, robots/cells, plasma tables, and possible press-brake applications; not a recommendation that a mat alone protects a press-brake point of operation.

## The engineering question
A technician says: "The Mat Manager has no error and Machine Enabled is green, so the floor is protected and we can restart." Show precisely why each inference is incomplete.

## Five separate layers
1. **Physical coverage** — can a person reach or occupy the hazard without standing on an effective mat (machine base, workpiece, trench, cable tray, side door, furniture, mat seam, under/over reach)?
2. **Detection assurance** — what person/force/geometry does the exact product assure? Rockwell's examined MatGuard specifies adults 35 kg or more; do not assume all people or all mat types.
3. **Configured input topology** — which zones are intentionally enabled? Rockwell's 440F-UM001C paired DIP banks can both agree while an input is disabled; mismatch detection does not validate the as-built floor map.
4. **Safety-related output/physical stopping** — mat actuation must reach the independent safety function and final elements; the actual dangerous motion/energy must stop in time. A normal PLC/HAL auxiliary tag is not safety authority.
5. **Recovery/restart** — a clear mat, manual reset, restored safety outputs, and a new machine start are different propositions. Auto-reset requires downstream independent restart prevention.

## Manufacturer-grounded teaching
- **DOC-CONFIRMED Rockwell Dec 2024:** dual DIP input selection, disabled-channel indicator OFF, pair mismatch Internal Error; manufacturer-specific, not universal.
- **DOC-CONFIRMED Rockwell Jan/Dec 2024:** 35 kg adult detection scope, full coverage and anti-bypass geometry, manual vs automatic reset, separate machine-start interlock, non-safety auxiliary status.
- **DOC-CONFIRMED Banner 2015:** SC22 four-wire monitoring and fault lockout; explicitly forbids using mat actuation to initiate hazardous motion.
- **INFERENCE:** an undetected path may remain even when all active mat channels are healthy; a valid configured disabled zone is a change-control hazard; a person can be physically inside while sensor output is clear.
- **UNKNOWN:** actual OpenPressBrake mat/guard topology, selected stopping time, Y1/Y2 hold, hydraulics, reset, PL/SIL and external evaluator.
- **TEST-CONFIRMED:** none. No GitHub Actions, simulation or hazardous demonstration is warranted to establish these documentary distinctions.

## Human-factor design rules
Make the approved route easy: flush/sloped trim, grip/cleanability, visible and reachable reset outside the hazard, protected cables, quick replacement with keyed zone labels, guarded machine-base footholds, non-obstructing floor geometry. If a legitimate operator task repeatedly requires crossing an awkward mat or reaching from a bypass route, **redesign the task/geometry** rather than demanding vigilance or tolerating defeat. Require a zone map and two-person qualified review for channel/mode changes; display disabled channels as **coverage unavailable**, not "green/healthy".

## Cross-machine transfer
- **Robot/cell:** mat may provide inside-the-fence occupancy; must cover all accessible floor, and reset must not imply empty cell. An enabling pendant is not equivalent.
- **Mill/lathe:** coolant, chips, swarf, tramp oil and operator platforms challenge sensor integrity and physical coverage; door guards/spindle run-down remain independent.
- **Plasma:** sparks, sheet stock, fume-extraction ducts and cable trays complicate mat wear and bypass geometry; process hazards persist after electrical stop.
- **Press brake:** standing mat at rear may complement guarded access, but point-of-operation laser/guards, ram gravity hold, hydraulic pressure and Y1/Y2 safe stop need their own proof. No selected OpenPressBrake mat assumed.

## Verification route (NOT RUN)
Read the [twelve no-energy gates](4400_MAT_01_TWELVE_GATE_NO_ENERGY_DESK_REVIEW_2026-10-26.md), work [twelve unscored paper cases](4400_MAT_01_TWELVE_UNSCORED_PAPER_SCENARIOS_2026-10-26.md), and hand an unseen case to an information-separated evaluator. Do not score yourself. The [five-layer matrix](4400_MAT_01_FIVE_LAYER_PRESENCE_AND_REARM_AUTHORITY_MATRIX_2026-10-26.md) provides SRS/PHY/VAL links.

## Sources
- Rockwell 440F-UM001C-EN-P, December 2024: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/440f-um001_-en-p.pdf
- Rockwell 440F-UM003A-EN-P, January 2024: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/440f-um003_-en-p.pdf
- Banner SC22 133487 Rev D, October 2015: https://info.bannerengineering.com/cs/groups/public/documents/literature/133487.pdf
- Full ISO 13856-1 and machine-specific standards applicability remain a qualified design review, not established by excerpts.

## Promotion / uncertainty queue
| Item | Evidence | Why unresolved | Priority | Graduation effect |
|---|---|---|---|---|
| Actual selected floor/guard geometry, occupancy and all alternate access routes | UNKNOWN | qualified as-built G0 required | CRITICAL | blocks machine release |
| Machine-specific stop/hold, hydraulic isolation and measured distance | UNKNOWN | physical G1 evidence required | CRITICAL | blocks machine release |
| Selected controller/mat model, channel configuration and mode | UNKNOWN | OEM plate, wiring and config | HIGH | blocks applicability |
| Independent unseen competency score | NOT RUN | information separation | HIGH | blocks course graduation |
| Manufacturer 2015/2024 numeric examples transferred to 2026 machine | not justified | edition/application review | HIGH | must NOT transfer |

**Counterfactual test:** even if every manufacturer feature differed on the selected machine, the lesson's invariant—physical coverage, detection, configured inputs, physical stopping and fresh restart need separate evidence—remains true. No machine-specific approval is claimed.
