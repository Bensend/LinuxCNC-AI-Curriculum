# 4400 ESTOP-MECH-01 — When the red mushroom moves but the electrical block does not

**Status:** NON-GRADUATED, documentary learner module. Prerequisites: 2530 E-stop, 2540 relay/EDM, 2520 physical-safe-state boundary, 4400 CYCLE/LEAK/RESET. No physical release.

## Objective
A fresh engineer can identify the *mechanical actuator-to-contact-block coupling* as a safety-relevant dependency, distinguish it from ordinary NC positive opening, electrical dual-channel diagnostics and the final physical stop, and specify a qualified safe restoration process.

## Mechanism in plain terms
A red latching mushroom is not the electrical contact. The rear contact block is a separate assembly. In a possible failure of a conventional assembly, the mushroom latches but no longer pushes its rear NC contact open. The two electrical channels may both be healthy *as circuits* and still fail the actual demand if they share the detached mechanical holder. This is a conditional failure analysis, not a claim about every E-stop design.

Specific manufacturers offer self-monitoring mounting contacts. Rockwell Safebook 5 p.40 explains a spring contact that closes only when the back assembly is attached. Siemens SIRIUS ACT 3SU1 02/2016 p.149 describes its 3SU1400-1AA10-.HA0 monitoring block and an **initial actuation/function-test** condition. The latter is exact-device behavior, not a universal reset ritual.

## Authority ladder
| Layer | What it can demonstrate | What it cannot demonstrate |
|---|---|---|
| Front mushroom visibly latches | Human actuator changed state | Rear block coupled, NC opened |
| Self-monitoring block / mounting contact | Selected product detects some installation/detachment failures | Every electrical/mechanical failure detected; physical machine stopped |
| Safety relay/controller | Valid qualified input and internal diagnostic state | Hydraulic ram held, pressure removed, every person clear |
| Final elements, mechanical restraints and verified physical state | Relevant stopping/holding functions when qualified and witnessed | Personal maintenance isolation unless separately established |
| LinuxCNC/HAL/HMI | Operator feedback, non-safety stop requests and diagnostics | Personnel-safety authority |

**Stop-demand safety ≠ safe access ≠ maintenance LOTO.** E-stop remains complementary safeguarding, not a substitute for guards or isolation.

## Practical design pattern (conceptual, not a wiring recipe)
1. Identify hazardous motion, exposure and required physical stop/hold separately for each mode.
2. Choose a proven E-stop assembly with documented positive-opening NC contacts and, where justified, a mounting-integrity monitoring variant; use exact compatible holder/head/block combinations.
3. Route safety inputs to an appropriately designed **independent safety-related** system, not ordinary LinuxCNC/FPGA code.
4. Validate the receiver, final elements, stopping and load holding for the selected machine. Never infer a PL/SIL or stopping distance from a component label.
5. Require qualified initial function check, post-service inspection, documented return to normal, and deliberate fresh restart distinct from mushroom release.
6. Put inspection access and replacement parts where maintenance can restore the protective design conveniently. Captive mounting, clear labels and accessible diagnostics reduce incentive to bypass.

## Cross-machine transfer
- **Press brake:** stop demand alone does not demonstrate independent Y1/Y2 stop or gravity restraint.
- **Lathe/mill:** spindle coast and axis movement need separate measured/validated safe-state requirements.
- **Plasma table:** stop of motion does not automatically remove stored electrical or process energy.
- **Robot/cell:** multiple stations and access points require explicit reset visibility/authority.
- **Conveyor:** pull-cord integrity, slack monitoring and contact-block mounting are distinct failure paths.

## Adversarial practice
Use [12 public, unscored cases](4400_ESTOP_MECH_01_TWELVE_UNSCORED_MOUNTING_FAULT_CASES_2026-10-26.md), then the [eight-gate no-energy review](4400_ESTOP_MECH_01_EIGHT_GATE_NO_ENERGY_MOUNTING_REVIEW_2026-10-26.md). The independent evaluator handoff is **PREPARED / NOT RUN** and must use unseen challenges after learner commitment.

## Evidence and unresolved questions
See [manufacturer audit](../research/4400_SIEMENS_ROCKWELL_ESTOP_CONTACT_BLOCK_DETACHMENT_SELF_MONITOR_SOURCE_AUDIT_2026-10-26.md) and [three-state matrix](4400_ESTOP_MECH_01_THREE_CONTACT_FAULT_STATE_AUTHORITY_MATRIX_2026-10-26.md). **DOC-CONFIRMED:** Siemens indexed 2016 original, Rockwell directly inspected Safebook 5 and exact 800F/800H catalog variants. **INFERENCE:** common mounting defect can defeat two NC channels. **UNKNOWN:** actual OpenPressBrake part, circuit, stop/hold, PL/SIL, tests and evaluator. **TEST-CONFIRMED none.**

## Graduation and promotion
Do not graduate the selected-machine safety function from documentary evidence. Promotion queue: exact product assembly and wiring (HIGH, G0 blocker); Siemens manual full visual inspection if selected (MEDIUM); independent functional witness and mechanical load hold (CRITICAL, G0/G1 blocker); unseen transfer score (HIGH, course competency blocker). Counterfactual: if the actual installed block behaves differently, the *general dependency distinction* survives, but machine-specific safety conclusions remain blocked.
