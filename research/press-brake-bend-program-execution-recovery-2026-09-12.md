# Press-brake bend-program execution and recovery — source/community contract

Date: 2026-09-12
Pinned LinuxCNC source: `8bf4605ae81042248add031e94c77300406e0413`
Scope: ordinary machine-control sequencing only; no functional-safety claim.

## Question

After the metadata/GaugePlan/TargetSet/runtime-episode ownership fixtures, what should own an operator-visible bend sequence, and what must happen when execution is interrupted or machine authority is lost?

## Community evidence

Public LinuxCNC press-brake work shows multiple viable surfaces rather than one canonical implementation.

- The 2017 press-brake discussion proposed bend rows that eventually drive LinuxCNC motion; Andy Pugh's tube-bender example used a UI list whose run action invoked a G-code subroutine for each row. This is useful evidence that a domain-specific table can remain the operator/program representation while LinuxCNC receives ordinary motion commands.
- The 2022 Accurpress retrofit author reported that feeding simple sequences with interrupts into LinuxCNC motion through G-code worked well and retained the ability to run ordinary G-code.
- The 2026 GUI discussion independently converges on a bend-program table and separates the Run surface from the editor/calculation surface.
- The Ursviken retrofit demonstrates that real machines may have several backgauge mechanisms and hydraulic modes, so a bend row cannot safely be treated as one scalar X coordinate.

Classification: `COMMUNITY-REPORTED`. These examples establish viable architecture patterns, not a universal press-brake standard.

## Pinned Task source findings

`src/emc/task/emctaskmain.cc` states the Task architecture explicitly: the main loop calls `emcTaskPlan()` and `emcTaskExecute()` cyclically; planning decides what to do based on machine mode/state; AUTO interpreter output is queued as NML commands; execution applies command preconditions and postconditions before advancing the interpreter list.

A plan-execute request queues a Task-plan synchronization command before interpreter execution because the machine may have moved externally. This is a strong source boundary for a press-brake program runner: domain sequencing may request execution, but LinuxCNC Task retains responsibility for interpreter/motion synchronization.

`src/emc/task/emctask.cc` shows that OFF, ESTOP_RESET, and ESTOP transitions call Task/motion abort paths, perform abort cleanup, and resynchronize the Task plan; volatile-home joints may be unhomed. Therefore an application must not interpret a later return to ON/green transport as permission to continue a previously accepted bend episode.

Classification: `SOURCE-CONFIRMED` at the pinned revision.

## Ownership contract

Use four distinct identities/state layers:

1. `ProgramRevision` — immutable identity of the accepted bend program/source revision.
2. `BendStepId` — stable semantic identity of one bend step within that revision.
3. `TargetSetGeneration` — calculated machine target generation accepted for that bend step.
4. `ExecutionEpisode` — runtime authority instance created only when the operator/machine starts that step.

A bend-table row is **not** itself runtime motion authority. Selection/highlight is UI state. A TargetSet is calculated intent. An ExecutionEpisode is the disposable runtime authorization binding.

## Start/advance predicate

A new bend execution episode may be created only from the currently accepted `ProgramRevision + BendStepId + TargetSetGeneration`, after required reference/reconciliation/interlock predicates are current. The runtime layer must reject stale generations even when their numeric targets equal the new ones.

Completion of a step requires positive completion witnesses for every mechanism required by that step; it must not be inferred from elapsed time or from the table index having advanced. For backgauges this includes the current target/episode completion contract developed in PB-BG-003/004. Hydraulic/ram completion remains a separate mode/state witness.

Only after the current episode completes may the sequence controller advance the semantic bend-step pointer.

## Interruption and recovery

Classify interruption rather than using one generic pause bit:

- **operator hold/pause with authority retained:** may preserve the semantic step pointer, but resume must use LinuxCNC's supported pause/resume semantics for already-issued motion; it must not synthesize a second target episode accidentally.
- **Task/motion abort, ESTOP, OFF, reference loss, drive/feedback invalidity, or application reconciliation-required fault:** invalidate the current `ExecutionEpisode` immediately. Any queued/domain-side assumption that the bend completed becomes invalid.
- **program revision, tooling/calculation revision, or TargetSet generation change:** invalidate the episode and require explicit reacceptance/reconciliation even if numeric coordinates happen to match.

After an abort-class interruption, recovery is **reconcile then rearm**, not automatic resume. Reconciliation must determine the physical/current machine state, current bend step, accepted program revision, current TargetSet generation, reference state, and whether material/tool state makes repeating or skipping the bend a human/domain decision. The software must not silently infer that an interrupted physical bend is safe to repeat.

## Function/call-flow summary

Domain program row -> accepted `BendStepId` -> accepted `TargetSetGeneration` -> create fresh `ExecutionEpisode` -> issue supported LinuxCNC command surface -> Task `emcTaskPlan()` mode/state arbitration -> interpreter/command queue -> `emcTaskExecute()` preconditions/issue/postconditions -> motion/IO -> independent mechanism completion witnesses -> episode complete -> sequence advances.

Abort-class path: state/fault transition -> Task/motion abort + cleanup/resynchronization -> application invalidates `ExecutionEpisode` -> sequence pointer remains semantically identifiable but **not authorized** -> physical/domain reconciliation -> explicit rearm -> fresh episode.

## Adversarial cases

1. Abort during bend step 4, then transport becomes green: step 4 does not become resumable merely because transport recovered.
2. Operator reloads an edited program whose step 4 has the same X/R values: old episode remains stale because `ProgramRevision` changed.
3. Target calculation is regenerated with identical numbers: old episode remains stale because `TargetSetGeneration` changed.
4. UI advances the highlighted row before all required mechanism completion witnesses arrive: this is a UI/sequence bug; row index is not completion evidence.
5. Physical bend was partially formed when abort occurred: software cannot safely decide repeat-vs-skip from LinuxCNC motion state alone; require domain/human reconciliation.

## Evidence boundary and next work

This contract is sufficient to stop adding synthetic ownership layers merely for completeness. The next useful evidence should be a real operator-program execution surface or a small integration fixture that exercises LinuxCNC Task abort/resynchronization semantics, only if it resolves a LinuxCNC-specific ambiguity.

Do not claim that LinuxCNC Task abort is a safety-rated function. Do not infer material bend state from backgauge/ram software state alone.
