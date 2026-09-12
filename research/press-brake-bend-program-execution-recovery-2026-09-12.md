# Press-brake bend-program execution and recovery — source/community contract

Date: 2026-09-12
Pinned LinuxCNC source: `8bf4605ae81042248add031e94c77300406e0413`
Scope: ordinary machine-control sequencing only; no functional-safety claim.

## Question

After the metadata/GaugePlan/TargetSet/runtime-episode ownership fixtures, what should own an operator-visible bend sequence, and what must happen when execution is interrupted or machine authority is lost?

## Community evidence

Public LinuxCNC press-brake work shows multiple viable surfaces rather than one canonical implementation.

- The 2017 press-brake discussion proposed bend rows that eventually drive LinuxCNC motion; Andy Pugh's tube-bender example used a UI list whose run action invoked a G-code subroutine for each row.
- The 2022 Accurpress retrofit author reported that feeding simple sequences with interrupts into LinuxCNC motion through G-code worked well and retained ordinary G-code capability.
- The 2026 GUI discussion independently converges on a bend-program table and separates Run from editing/calculation.
- The Ursviken retrofit demonstrates that real machines may have several backgauge mechanisms and hydraulic modes, so a bend row cannot safely be treated as one scalar X coordinate.

Classification: `COMMUNITY-REPORTED`. These establish viable architecture patterns, not a universal press-brake standard.

## Documentation cross-check

Current LinuxCNC documentation distinguishes **pause/resume** from **stop/abort**. M0/M1 are temporary pauses and Resume continues at the following line. AXIS documents Stop as ending the run such that a subsequent Run starts from the beginning. AXIS also exposes Run From Selected Line but warns that it first moves to the expected position and warns against use with subroutines. This makes generic run-from-line an unsuitable automatic press-brake recovery primitive: an interrupted physical bend needs domain reconciliation, not merely a source-line restart.

Classification: `DOC-CONFIRMED`.

## Pinned Task source findings

`src/emc/task/emctaskmain.cc` states the Task architecture explicitly: the main loop calls `emcTaskPlan()` and `emcTaskExecute()` cyclically; planning decides what to do based on machine mode/state; AUTO interpreter output is queued as NML commands; execution applies command preconditions and postconditions before advancing the interpreter list.

A plan-execute request queues a Task-plan synchronization command before interpreter execution because the machine may have moved externally. Domain sequencing may request execution, but LinuxCNC Task retains interpreter/motion synchronization responsibility.

`src/emc/task/emctask.cc::emcTaskAbort()` is stronger than a generic pause. It calls `emcMotionAbort()`, clears the pending Task command and `interp_list`, sets interpreter state IDLE and execution state DONE, clears pause/line/call-level/stepping state, queues an interpreter synchronization command, closes the open task plan and resets unflushed segments. The source comment explicitly says that *without* `emcTaskPlanClose()` a new run would resume at the aborted line; the implementation deliberately closes it. Application recovery must not assume an implicit aborted-line resume contract.

OFF, ESTOP_RESET, and ESTOP transitions also invoke Task/motion abort/cleanup/resynchronization paths; volatile-home joints may be unhomed. A later return to ON or healthy transport is not permission to continue a previously accepted bend episode.

Classification: `SOURCE-CONFIRMED` at the pinned revision.

## Ownership contract

Use four distinct identities/state layers:

1. `ProgramRevision` — immutable identity of the accepted bend program/source revision.
2. `BendStepId` — stable semantic identity of one bend step within that revision.
3. `TargetSetGeneration` — calculated machine target generation accepted for that bend step.
4. `ExecutionEpisode` — runtime authority instance created only when the operator/machine starts that step.

A bend-table row is **not** runtime motion authority. Selection/highlight is UI state. A TargetSet is calculated intent. An ExecutionEpisode is the disposable runtime authorization binding.

## Start/advance predicate

A new bend execution episode may be created only from the currently accepted `ProgramRevision + BendStepId + TargetSetGeneration`, after required reference/reconciliation/interlock predicates are current. Reject stale generations even when numeric targets equal the new ones.

Completion requires positive witnesses for every mechanism required by the step; it must not be inferred from elapsed time or row-index advance. Backgauges use the current target/episode completion contract from PB-BG-003/004. Hydraulic/ram completion remains a separate mode/state witness.

Only after the current episode completes may the sequence controller advance the semantic bend-step pointer.

## Interruption and recovery

- **operator hold/pause with authority retained:** may preserve the semantic step pointer; Resume uses supported LinuxCNC pause/resume semantics and must not synthesize a duplicate episode.
- **Task/motion abort, ESTOP, OFF, reference loss, drive/feedback invalidity, or reconciliation-required fault:** invalidate the current `ExecutionEpisode` immediately.
- **program revision, tooling/calculation revision, or TargetSet generation change:** invalidate the episode and require explicit reacceptance/reconciliation even if coordinates match.

After an abort-class interruption, recovery is **reconcile then rearm**, not automatic resume. Reconciliation determines current physical/machine state, semantic bend step, accepted program revision, TargetSet generation, reference state, and whether material/tool state makes repeating or skipping the bend a human/domain decision. Software must not infer that an interrupted physical bend is safe to repeat.

Because `emcTaskAbort()` closes/resets the plan, a domain controller that chooses to retry the same semantic bend after reconciliation must issue a **fresh** execution request/episode. Generic Run From Selected Line is not a substitute for this domain decision.

## Function/call-flow summary

Domain program row -> accepted `BendStepId` -> accepted `TargetSetGeneration` -> fresh `ExecutionEpisode` -> supported LinuxCNC command surface -> Task `emcTaskPlan()` mode/state arbitration -> interpreter/command queue -> `emcTaskExecute()` preconditions/issue/postconditions -> motion/IO -> independent mechanism completion witnesses -> episode complete -> sequence advances.

Abort path: state/fault transition -> `emcTaskAbort()` -> `emcMotionAbort()` -> pending command + interpreter list cleared -> interpreter IDLE / exec DONE -> Task plan sync queued -> task plan close/reset -> application invalidates episode -> semantic bend pointer remains identifiable but **not authorized** -> physical/domain reconciliation -> explicit rearm -> fresh episode/request.

## Adversarial cases

1. Abort during bend step 4, then transport becomes green: step 4 is not resumable merely because transport recovered.
2. Edited program has the same step-4 X/R values: old episode is stale because `ProgramRevision` changed.
3. Target calculation regenerates identical numbers: old episode is stale because `TargetSetGeneration` changed.
4. UI advances the highlighted row before all mechanism completion witnesses arrive: row index is not completion evidence.
5. Physical bend was partially formed when abort occurred: LinuxCNC motion state alone cannot decide repeat-vs-skip; require domain/human reconciliation.
6. UI offers “resume step 4” after Task abort: if retry is allowed, create a fresh episode and explicit command; do not rely on hidden continuation.
7. UI attempts automatic Run From Selected Line after abort: reject as a general recovery policy because interpreter positioning/reconstruction is not evidence that material state or press-step prerequisites are reconciled.

## Evidence boundary and next work

The LinuxCNC-specific ambiguity is resolved: Task abort is not ordinary pause and does not provide implicit aborted-line continuation. A synthetic experiment that merely re-demonstrates this branch has low information gain.

Next useful work: define a real operator-program state model (`READY`, `RUNNING`, `PAUSED`, `ABORTED_NEEDS_RECONCILIATION`, `REARM_READY`, `COMPLETE`) and persistence rules, then compare it against an inspectable public press-brake implementation if one exists. Add a lab fixture only for a concrete Task/UI integration ambiguity.

Do not claim Task abort is safety-rated. Do not infer material bend state from backgauge/ram software state alone.
