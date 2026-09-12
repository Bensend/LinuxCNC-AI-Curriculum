# 3600 press-brake checkpoint — TargetSet provenance / runtime bridge

Date: 2026-09-12

## Global critical path

The sole remaining 2000-series graduation gate is the genuinely information-separated evaluation of `handoffs/F02-fresh-ai-compound-fault-transfer.md`. F02 is technically accepted; the current learner must not self-score that packet or expose learner-side answer material to its evaluator.

## Newly closed 3600 preparation work

- PB-DXF-002 — human confirmation + recipe-step identity/invalidation: TEST-CONFIRMED, frozen Gates A-J 10/10.
- PB-DXF-003 — GaugePlan datum/mechanism provenance + invalidation: TEST-CONFIRMED, frozen Gates A-J 10/10.
- PB-DXF-004 — TargetCalculation/TargetSet provenance + runtime generation semantics: TEST-CONFIRMED, frozen Gates A-J 10/10.

Together with PB-DXF-001 and PB-BG-003, the staged ownership chain is now:

`ImportedPart -> BendFeature -> BendStep -> GaugePlan -> TargetCalculation -> TargetSet generation -> runtime target episode -> bounded planner/controller -> extra-joint posthome-cmd`

Do not add more synthetic state fixtures merely for volume.

## Source/documentation findings

### LinuxCNC `limit3`

Pinned source `8bf4605ae81042248add031e94c77300406e0413` confirms `limit3` is command shaping, not authorization. With `enable=0`, it drives its internal requested input to zero and moves `out` toward zero under constraints; it does not freeze the previous command. `load` bypasses velocity/acceleration limiting for a limited immediate set.

Therefore keep current TargetSet/runtime authority separate from `limit3.enable` and from `limit3.out` plausibility.

### Target-calculation evidence

FreeCAD SheetMetal provides inspectable bend-development math that depends on radius, thickness, K-factor and bend angle. This proves finished/flat geometry is not generally an identity transformation, but it is not a universal backgauge solver.

Official Cybelec CybTouch documentation confirms a useful architectural separation: the operator may enter flange length while the controller calculates X; optional R can also be calculated; backgauge geometry comes from machine parameters; recalculation and corrections are separately managed. The internal flange-to-X formula is not exposed publicly enough to treat as a universal implementation.

A bounded open-source search found no inspectable geometry-to-backgauge target solver meeting the curriculum's evidence standard. Preserve that as SOURCE UNAVAILABLE rather than inventing a formula.

## PB-DXF-004 authoritative result

- workflow `34670122426`
- job `103489793017`
- source commit `3af3549b7ed5a0b852cd4d4067076e2f7cdcd22c`
- artifact `10290852409`
- exact Actions job interval `2026-09-12T03:21:01Z`–`03:21:11Z` = 0.17 min
- retained snapshots: 10
- frozen Gates A-J: 10/10 PASS

Key result: direct, calculated and imported-CAM targets remain distinct method classes; dependency changes revoke authority; identical numeric values do not restore authority; explicit current acceptance creates a new monotonically advancing application generation; mechanism coverage and GaugePlan validity remain prerequisites.

Numeric values in the fixture are deliberately opaque and have no physical correctness claim.

## Compute checkpoint

Exactly backfilled lab compute is now **267.98 min (4.47 h)**; 2026-09-12 exactly backfilled subtotal is **0.72 min** plus explicitly unbackfilled same-day historical usage.

## Exact next dependency-safe 3600 work

If the F02 external transfer still has not arrived, bridge the now-accepted TargetSet generation into the already proven PB-BG-003 runtime episode semantics:

1. a current accepted TargetSet generation may request a new runtime episode;
2. any TargetSet/GaugePlan/calibration/authorization/reference invalidation clears current episode authority;
3. revalidation must create a new TargetSet generation and then a new runtime episode; neither old generation nor old episode may be silently resurrected;
4. `limit3` stays downstream as numeric shaping only;
5. completion remains bound to the current runtime episode and independent feedback/at-position evidence.

Do this as the smallest application/control-ownership integration. Do not add motor physics or a guessed flange-to-X formula.

## Evidence boundary

Current artifacts establish deterministic application provenance, invalidation and ordinary-control ownership only. They do not establish physical target accuracy, finger contact, reachability, collision freedom, tooling suitability, bend accuracy, hydraulic behavior, stopping performance or functional safety.
