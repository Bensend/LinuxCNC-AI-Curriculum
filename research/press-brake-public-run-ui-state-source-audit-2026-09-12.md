# Press-brake 3600 — public Run UI/state implementation audit

Date: 2026-09-12
Status: COMMUNITY IMPLEMENTATION EVIDENCE + SOURCE-AVAILABILITY BOUNDARY

## Question

The previous checkpoint asked for one bounded inspection of a real public press-brake operator implementation, specifically looking for program-row persistence, pause/abort behavior, row advance, restart/recovery and the command surface. The goal was to replace synthetic ownership fixtures with field evidence.

## Public implementation located

LinuxCNC forum thread `Vertical Press Brake interface and comp`, posted by laserted on 2022-04-26, describes a field-running Accurpress retrofit and publishes a pre-release project attachment. The author reports three operator modes:

1. **jog/manual** — hands-on air bending;
2. **semi-auto-repeat** — operator can capture/set setpoints, adjust them by clicks or typing, then use the pedal to run to that setpoint with dwell/overbend/daylight behavior;
3. **fully automatic** — load and run G-code.

The author explicitly says the intended fully automatic/sequence capability was **never finished** because the operators preferred one-bend/one-side batch work and did not want the planned sequencing/wizard workflow. The public report also says the release uses LinuxCNC MOTION for all three axes after earlier custom state-machine iterations proved rough/jerky.

Evidence classification: COMMUNITY-REPORTED FIELD IMPLEMENTATION. It is stronger than a design proposal because the author states the pre-release version was functional on the actual machine, but it is not a generic reference architecture.

## What this answers

### Semi-automatic command surface

The public field report directly supports an operator workflow where a bend target is captured or typed, adjusted, and then executed repeatedly under pedal control. This is consistent with the curriculum's separation between a durable program/recipe value and a fresh runtime execution episode.

### Full-auto source

The field implementation used ordinary LinuxCNC G-code as the fully automatic command surface. This supports a useful architectural boundary: a press-brake GUI does not need to replace LinuxCNC program execution merely to sequence machine coordinates.

### Why the Run-table abstraction must remain separate

The same author states that a polished bend-sequence/wizard surface was not completed. Therefore the public machine does **not** establish a finished `BendStep -> selected Run row -> automatic next-row` state machine. We must not infer row persistence, row-advance rules or aborted-row replay semantics from the existence of the working machine.

## Source retrieval boundary

The forum post exposes a `pressbrakepre-release_2022-04-26.zip` attachment and a screen capture. In this bounded pass the forum page was inspectable, but the attachment bytes were not retrievable through the available web/container path. Earlier curriculum work already independently inspected public Accurpress HAL/INI/config generations from related forum material and traced real machine ownership/timing, but this pass could not inspect the 2022 GUI project's row/state code directly.

Accordingly:

- **FIELD-CONFIRMED BY AUTHOR:** manual, semi-auto-repeat and G-code auto modes existed; the pre-release ran on a real machine.
- **FIELD-CONFIRMED BY AUTHOR:** semi-auto allowed captured/typed setpoints and pedal execution.
- **FIELD-CONFIRMED BY AUTHOR:** planned sequence/wizard capability was not finished.
- **SOURCE UNAVAILABLE IN THIS PASS:** exact GUI handler code for program-row persistence, row advance, pause/abort transitions and restart/recovery.

This closes the checkpoint's bounded search. Repeating the same attachment search is lower-value unless a new mirror/repository appears.

## Reconciliation with pinned LinuxCNC Task semantics

The preceding source pass established at pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413` that `emcTaskAbort()` is destructive to the current Task/interpreter execution context: it aborts motion, clears pending/interpreter state, queues synchronization, and closes/resets the task plan. Pause/Resume is a different lifecycle.

Therefore even if a future GUI preserves a selected bend-row number across abort, **row persistence is not motion-execution persistence**. A press-brake UI must explicitly reconcile the physical workpiece, selected bend, target generation and operator intent before issuing a fresh execution episode after abort.

## Durable operator model supported by the combined evidence

```text
Program/recipe row
    -> selected bend identity
    -> accepted TargetSet generation
    -> fresh runtime ExecutionEpisode
    -> LinuxCNC command surface (MDI/G-code/posthome target as applicable)
```

Pause may retain the current execution episode only when the underlying LinuxCNC operation is genuinely resumable. Abort invalidates the episode. A persistent row selection may be retained for operator context, but it must enter `RECONCILE_REQUIRED` rather than silently resuming authority.

## Claims boundary

This artifact does not prove the field machine's safeguarding, exact hydraulic sequence, numeric setpoints, stopping behavior, or correctness of its old configuration. It also does not claim that G-code is the only or best press-brake sequencing surface. It establishes only what the public implementation did, what remained unfinished, and what cannot be inferred without source.

## Next implication

The public Run-UI search is complete under the bounded contract. Continue with machine/program calibration and correction ownership rather than adding another synthetic Run-state fixture.
