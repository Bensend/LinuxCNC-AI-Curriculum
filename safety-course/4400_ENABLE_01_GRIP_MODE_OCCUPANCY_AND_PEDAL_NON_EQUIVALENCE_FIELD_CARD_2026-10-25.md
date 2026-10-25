# 4400-ENABLE-01 — Grip enabling, mode authority and multiple entrants
**2026-10-25 | 12 PAPER transfer cases | NON-GRADUATED | independent evaluation NOT RUN**

Use [direct original Rockwell 440J audit](../research/4400_ROCKWELL_440J_THREE_POSITION_ENABLING_VS_PEDAL_AND_MULTI_PERSON_SOURCE_AUDIT_2026-10-25.md) with [PEDAL-01](4400_PEDAL_01_THREE_POSITION_OVERTRAVEL_UNLOCK_AND_FRESH_START_MODULE_2026-10-25.md). No answers are supplied; evaluator must keep a genuinely new challenge hidden until learner precommitment.

## What the learner must prove
The **440J mid-position is a permissive**, not an independent motion-start command. Fully squeezed and fully released are stop-demand states; the OEM specifies that contacts remain open through fully squeezed -> released. Reduced-performance mode, mode retention, protective-device scope, actual safe speed, independent stop/hold, occupancy and deliberate restart are distinct obligations. The same "three-position" description on a foot pedal does **not** imply identical return behavior.

## 12 unscored technician decisions
1. A maintenance engineer holds a 440J in the middle, and a normal LinuxCNC jog request is already true from before guard entry. What independent condition and fresh-action evidence is missing?
2. During robot teaching, an operator panics and squeezes the grip to its third position. What does the 2026 Rockwell manual establish about the contact state on the way back to release, and what remains unproven physically?
3. An HMI reports "reduced speed" while the actual axis encoder is disconnected. Is this a safety-rated speed witness? What selected architecture would have to be evaluated?
4. The safety design allows the HMI to switch to automatic high-speed mode while the operator holds a grip inside the cell. Identify the failed requirement.
5. Two people enter through different guards. One holds an enabling grip and the other has no device. What OEM multi-person condition is violated or unproven?
6. A supplier offers a three-position foot pedal as a cheaper replacement for a hand enabling grip. What exact functional and human-factor differences prevent simple substitution?
7. A grip model includes an optional NO jog button. Does squeezing the grip alone initiate motion? How must jog/reset be related to the mid-position?
8. The safety engineer disables three separate safeguards whenever the enabling switch is held, because it is "safety rated." What is the architectural problem?
9. The operator is inside a guarded mill enclosure; a spindle coasts after the grip is released. Which physical stop/standstill evidence is missing?
10. A hydraulic press brake setup has a gravity-loaded ram. The grip safety contacts open correctly at full squeeze, but the ram drifts. What is the proper release decision?
11. A maintainer clamps a grip at mid-position to free a hand for adjustment. What safer task/fixture/interface redesign could remove the incentive without defeating the function?
12. An independent evaluator provides a different grip-switch OEM contact diagram. Which evidence labels and variant-specific questions prevent importing Rockwell 440J behavior as universal truth?

## Blank selected-machine record
| Field | Required selected evidence | Status |
|---|---|---|
| Machine, task, modes, persons exposed | Qualified hazard/occupancy map | UNKNOWN |
| Grip exact part/variant, return state diagram | Original OEM/manual and selected wiring | UNKNOWN |
| Independent safety input channels and safety controller | As-built/firmware/logic revision | UNKNOWN |
| Separate jog/start and reset; retained-command handling | Qualified safety and normal-control interaction | UNKNOWN |
| Selected reduced-performance limit and independent witness | Qualified sensor/monitor, actual safe speed/force proof | UNKNOWN |
| Guard(s) suspended, those remaining active, entry/egress | Task/mode protective coverage | UNKNOWN |
| Multiple persons and each enabling authority | Selected occupancy and reset method | UNKNOWN |
| Final elements, actual stop/hold and residual energy | Independent physical measurement plan | UNKNOWN |
| Operator ergonomics and predictable defeat incentives | Unpowered task observation | UNKNOWN |
| Independent review / release gate | Signed G0 and later isolated physical VAL/PT | **HOLD / NOT RUN** |

**No-energy desk gate:** only identify/document actual equipment and conflicts; do not bypass interlocks, use a grip to override guards, move a hazardous machine, or test with people inside. G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED. Any isolated/remote experimental plan requires qualified exclusion, secondary restraint, abort plan and explicit residual risk. No selected machine PL/SIL, speed, distance or pressure is inferred.

**Evidence:** Rockwell February 2026 OEM **DOC-CONFIRMED** in exact product/application scope; cross-machine comparisons and safe workflow design **INFERENCE**; selected physical function **UNKNOWN**; **TEST-CONFIRMED none**. No self-scoring or blind-evaluation leakage.
