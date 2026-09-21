# 25E0 adversarial exercise — composition is not conjunction

## Scenario

A vertical axis uses a professional safe-drive platform offering STO/SS1, safe motion monitoring, SBC and SBT. The most recent SBT passed. The encoder currently reports standstill. The brake output is commanded applied. An ordinary LinuxCNC `cycle-start` input has remained physically asserted since before a guard-opening event.

A technician proposes one production-ready bit:

`axis_safe = zero_speed && brake_commanded && last_sbt_passed`

and wants LinuxCNC to resume automatically when the guard is closed and the independent safety system becomes permissive again.

## Learner task

Classify each observation by what it physically proves, identify the unjustified conjunction, and define the minimum additional questions that must be answered before restart behavior can be validated.

## Required reasoning targets

A correct analysis must recognize all of the following:

1. `zero_speed` is motion evidence at the observation time; it does not prove retaining torque/capability.
2. `brake_commanded` is command/state evidence; it does not prove mechanical brake torque.
3. `last_sbt_passed` is active proof-test evidence from a prior test condition/time; it is not continuous proof and its acceptable age/context is application-specific.
4. The fact that one certified platform supplies SBC, SBT and motion monitoring does not prove that the product automatically ANDs them in the proposed way for this machine transition.
5. Restored guard/safety permission is not a fresh ordinary start request.
6. A `cycle-start` held across the safety interruption must have explicitly designed demand-freshness semantics; it must not be allowed to become a hidden automatic restart merely because permission returns.
7. For a gravity axis, the sequence between controlled torque, brake application/proof, STO and release/restart must come from the validated machine architecture. `fault => remove torque immediately` is not a universal safe rule.
8. If the machine-specific retaining capability, stopping/holding acceptance criteria, or reset/restart semantics are unknown, personnel must not be exposed while experimentally determining them; testing must be isolated/remote with residual risk controlled.

## Design-review deliverable

Produce a typed transition table with separate columns for:

- ordinary demand freshness;
- safety mode/permission;
- motion witness;
- brake command/state;
- brake proof status and proof age/context;
- gravity/stored-energy state requiring separate validation;
- reset/rearm state;
- allowed ordinary command.

Any cell that lacks authoritative machine-specific evidence must be marked `UNKNOWN`, not inferred from a neighboring witness.

## Pass criterion

Pass only if the learner refuses both shortcuts:

- collapsing heterogeneous evidence into `axis_safe`; and
- treating return of safety permission while Start remains held as a fresh production command.
