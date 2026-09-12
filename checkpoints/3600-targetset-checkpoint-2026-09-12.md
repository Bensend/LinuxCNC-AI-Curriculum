# 3600 press-brake checkpoint — TargetSet / runtime-episode ownership closed

Date: 2026-09-12

## Global critical path

The sole remaining 2000-series graduation gate is the genuinely information-separated evaluation of `handoffs/F02-fresh-ai-compound-fault-transfer.md`. F02 is technically accepted; the current learner must not self-score that packet or expose learner-side answer material to its evaluator.

## Closed 3600 preparation chain

- PB-DXF-002 — human confirmation + recipe-step identity/invalidation: TEST-CONFIRMED, frozen Gates A-J 10/10.
- PB-DXF-003 — GaugePlan datum/mechanism provenance + invalidation: TEST-CONFIRMED, frozen Gates A-J 10/10.
- PB-DXF-004 — TargetCalculation/TargetSet provenance + generation semantics: TEST-CONFIRMED, frozen Gates A-J 10/10.
- PB-BG-004 — accepted TargetSet generation -> fresh runtime target episode, with fail-closed invalidation: TEST-CONFIRMED, frozen Gates A-J 10/10.

Together with PB-DXF-001 and PB-BG-003, the staged ownership chain is now:

`ImportedPart -> BendFeature -> BendStep -> GaugePlan -> TargetCalculation -> TargetSet generation -> runtime target episode -> bounded planner/controller -> extra-joint posthome-cmd`

Do not add more synthetic ownership/state fixtures merely for volume.

## Source/documentation findings

Pinned LinuxCNC `limit3` is numeric command shaping, not authorization. With `enable=0`, its output returns toward zero under constraints instead of freezing the previous value. `load` can set the limited input immediately while bypassing velocity/acceleration limiting. Current TargetSet/episode authority must therefore remain separate from `limit3.enable` and `limit3.out`.

FreeCAD SheetMetal provides inspectable bend-development math depending on radius, thickness, K-factor and bend angle. Official Cybelec CybTouch documentation confirms flange length and calculated X are separate concepts, with optional calculated R, machine-parameter backgauge geometry, recalculation and correction ownership. The public internal flange-to-X formula remains unavailable.

A bounded open-source search found no inspectable geometry-to-backgauge target solver meeting the evidence standard. Preserve this as SOURCE UNAVAILABLE rather than inventing a universal formula.

## PB-DXF-004 result

- workflow `34670122426`
- job `103489793017`
- artifact `10290852409`
- exact interval `03:21:01Z`–`03:21:11Z` = 0.17 min
- 10 retained snapshots
- frozen Gates A-J: 10/10 PASS

Direct, calculated and imported-CAM target methods remain distinct; dependency changes revoke authority; numeric coincidence does not restore it; explicit current acceptance creates a new monotonically advancing TargetSet generation.

## PB-BG-004 result

- workflow `34670275431`
- job `103490218883`
- source commit `fdb75f88bde3700ccf1306a4d16b9ed7e9843670`
- artifact `10290233358`
- exact interval `03:24:26Z`–`03:24:35Z` = 0.15 min
- 14 retained snapshots
- frozen Gates A-J: 10/10 PASS

A current valid TargetSet generation plus explicit arm creates a fresh runtime episode. TargetSet invalidation, ordinary authorization loss, reference loss and feedback loss revoke current episode authority and completion. The same invalidated generation cannot be silently rearmed; a newer accepted generation plus explicit arm creates a new episode. Numeric equality has no authority role.

## Compute checkpoint

Exactly backfilled lab compute is now **268.13 min (4.47 h)**. The exactly backfilled 2026-09-12 subtotal is **0.87 min (0.01 h)** plus explicitly unbackfilled historical usage.

## Exact next dependency-safe 3600 work

If the F02 external transfer still has not arrived, stop extending the synthetic ownership chain. Resume source/community/domain work from the 3600 dependency map. Highest-value candidates are:

1. operator-facing bend-program execution/recovery workflow: step advance, hold/retry/skip/reconcile semantics and how target generations are regenerated after edits;
2. machine-specific target/calibration/correction ownership using inspectable public configuration/manual evidence;
3. another unresolved press-brake domain area such as homing/calibration, tooling/reachability, or sequence/collision workflow, selected by existing open-question priority.

Prefer inspectable real implementation/source or authoritative documentation. Do not add motor physics, guessed hydraulic detail, or a guessed flange-to-X formula merely to extend simulation depth.

## Evidence boundary

Current artifacts establish deterministic application provenance, invalidation and ordinary-control ownership only. They do not establish physical target accuracy, finger contact, reachability, collision freedom, tooling suitability, bend accuracy, hydraulic behavior, stopping performance or functional safety.
