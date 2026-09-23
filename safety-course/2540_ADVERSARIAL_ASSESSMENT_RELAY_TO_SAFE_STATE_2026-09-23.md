# 2540 — Adversarial assessment: relay to physical safe state

## Purpose

Test whether the learner can reason from a safety-function requirement through relay/module behavior and final elements without transferring evidence across unsupported boundaries. This is a learner-facing assessment, not a hidden grading key.

For every scenario use this chain explicitly:

`command -> diagnostic witness -> final-element state -> hazardous-energy state -> physical safe-state proposition`

For each answer classify important claims as `DOC-CONFIRMED`, `SOURCE-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, or `UNKNOWN`. Do not invent PL/SIL, PFHd, stopping time, pressure, diagnostic coverage, B10d applicability, or machine physics.

## Scenario 1 — welded motor contactor

A dual-channel safety relay de-energizes two contactors. K1 has a welded NO main pole. Its ordinary auxiliary NC is wired into EDM and reports the expected reset state.

1. What proposition does the EDM signal appear to support?
2. Why is an ordinary auxiliary contact insufficient evidence that K1's main pole opened?
3. What documented contact relationship would strengthen that proposition?
4. If K2 independently interrupts the motor supply, what additional dependency/common-cause questions remain before calling the safety function adequate?
5. What machine-level evidence is still required if the SRS requires standstill rather than merely removal of motor supply?

Critical trap: `EDM healthy -> all hazardous motion stopped`.

## Scenario 2 — correct current, wrong switching duty

A safety relay output is catalog-rated 6 A resistive. A technician connects a 1.2 A DC solenoid directly because 1.2 A is below 6 A.

Explain why this arithmetic is not sufficient. Identify the missing evidence concerning DC interruption, inductive load behavior, utilization category/application rating, inrush, suppression, switching frequency, contact protection, release dynamics, and output failure assumptions.

Critical trap: `load current < contact current rating -> suitable final element`.

## Scenario 3 — suppression drift

A validated contactor coil originally used suppression arrangement A. Maintenance substitutes arrangement B because it reduces electrical noise more effectively. The contactor still drops when tested casually.

Identify which prior evidence becomes stale. Explain why a suppression change can affect release dynamics and therefore any safety timing assumption. Define the minimum change-impact questions before prior validation can be reused.

Critical trap: `same contactor + lower transient voltage -> safety-neutral change`.

## Scenario 4 — STO on a gravity axis

A drive reports STO active on a vertical axis carrying a suspended load.

Separate these propositions:

- torque-producing switching inhibited;
- drive-generated torque absent;
- shaft/axis stationary;
- brake engaged;
- load mechanically restrained;
- electrical isolation achieved.

State which may be supported by documented STO behavior and which require separate architecture or physical proof.

Critical trap: `certified STO active -> suspended load safe`.

## Scenario 5 — trapped pneumatic energy

Two monitored exhaust valves report their expected exhaust positions. A downstream branch is isolated by a check valve and retains pressure.

Explain why valve-position feedback can pass while the machine safe-state proposition fails. Identify what must be measured or otherwise proved if the SRS requires the branch to be below a defined safe pressure before access.

Critical trap: `redundant monitored valves -> every downstream volume depressurized`.

## Scenario 6 — common final element

Two independent safety-controller outputs both ultimately command one ordinary contactor that is the only physical interruption path.

1. Is the logic redundant?
2. Is the physical energy-removal path redundant?
3. Which single failure can defeat both logical channels' intended result?
4. Why can neither two inputs nor two logic outputs manufacture a second physical interruption path?

Critical trap: counting channels at one layer and transferring that count downstream.

## Scenario 7 — replacement drift

A failed contactor is replaced with a device having the same coil voltage, package size, nominal current, and auxiliary contact count. The replacement manual does not establish mirror-contact behavior and gives different utilization data.

Explain why this is not a validated safety-equivalent replacement. Identify which design verification, EDM proposition, reliability/use-profile assumptions, switching suitability, and functional/fault validation must be revisited.

Critical trap: `form/fit/current match -> safety-function equivalence`.

## Scenario 8 — component rating transfer

A commercial safety relay is documented for use up to PL e / SIL 3 in specified architectures. The machine uses that relay, one unmonitored contactor, and an unknown guard switch.

Explain why the complete machine function cannot inherit the module's rating. List the missing subsystem, architecture, reliability, diagnostic, CCF/systematic, application, and validation evidence.

Critical trap: `highest-rated component -> complete-function rating`.

## Scenario 9 — force-guided does not mean failure-proof

A force-guided relay reaches end of life. Explain what force guidance contributes diagnostically and what it does not guarantee. Distinguish a detectable covered contact relationship from immunity to wear, coil failure, wiring faults, common cause, or machine-level energy hazards.

## Scenario 10 — reset, witness, and restart

After a detected contactor fault, maintenance replaces the device. EDM now appears healthy and the safety relay accepts reset. Cycle Start remained asserted throughout the repair.

Describe the required separation among:

1. fault cleared;
2. diagnostic witness healthy;
3. safety function reset/rearmed;
4. machine start authorized;
5. physical safe-state/restart conditions validated.

A reset must not silently become a production start.

## Scenario 11 — proposition audit

For each statement below mark `SUPPORTED`, `UNSUPPORTED`, or `CONDITIONAL`, and name the missing evidence:

- Both safety outputs are off, therefore the shaft is stopped.
- A mirror contact is open, therefore every main pole is open.
- STO is active, therefore electrical maintenance is safe.
- The valve spool reached exhaust position, therefore the cylinder cannot move.
- PFHd is published for the safety relay, therefore machine PFHd is known.
- Two contactors exist, therefore common-cause failure is controlled.
- The replacement relay has a larger current rating, therefore revalidation is unnecessary.

## Scenario 12 — design task

Starting only from the requirement `hazardous rotation shall be prevented while access is permitted`, produce a bounded evidence plan for a guarded spindle machine. Do not choose a PL/SIL or stopping distance without the missing risk and physical inputs.

Your plan must identify:

- the physical safe-state proposition;
- sensor/input proposition;
- safety logic proposition;
- final-element proposition;
- diagnostic witnesses and their exact limits;
- residual/stored-energy questions;
- restart/rearm behavior;
- common-cause/dependency questions;
- physical validation needed;
- maintenance/replacement changes that invalidate evidence.

## Pass characteristics

A strong response consistently keeps electrical command, diagnostic witness, final-element state, hazardous-energy state, and physical safe state separate; refuses unsupported numerical/rating claims; recognizes common final elements and common cause; bounds EDM/mirror contacts/STO/valve feedback to what they actually witness; and treats maintenance changes as evidence-impact events.

A response is not competent if it grants personnel-safety authority to ordinary LinuxCNC/FPGA logic, equates component certification with complete-function integrity, or claims a physical safe state solely from an electrical status bit.
