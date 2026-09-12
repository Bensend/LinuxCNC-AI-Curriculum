# 3600 press-brake checkpoint — DXF confirmation through GaugePlan / target-calculation boundary

Date: 2026-09-12

## Global critical path

The 2000 series remains technically complete except for the genuinely information-separated F02 fresh-AI evaluation at `handoffs/F02-fresh-ai-compound-fault-transfer.md`. S02/E20/X01/X02 transfers already passed. The current learner must not self-score F02 or expose its learner-side answer/audit material to the evaluator.

A correctly routed F02 PASS with no material correction should graduate F02 and close the 2000 series.

## 3600 work closed in this branch

- PB-BG-001 — manual/jog ownership and authorization revocation: test-confirmed.
- PB-BG-002 — extra-joint typed-position ownership: test-confirmed.
- PB-BG-003 — current target episode / atomic completion semantics: test-confirmed.
- PB-DXF-001 — metadata/provenance/reimport semantics: test-confirmed, Gates A-J 10/10.
- PB-DXF-002 — operator bend-feature confirmation and recipe-step identity/invalidation: test-confirmed, Gates A-J 10/10.
- PB-DXF-003 — GaugePlan datum/mechanism provenance and invalidation: test-confirmed, Gates A-J 10/10.

Do not add more synthetic state fixtures merely for volume. These application ownership questions are sufficiently discriminated for the current preparation stage.

## Source finding that changes implementation expectations

Pinned LinuxCNC `limit3.comp` is a bounded command-shaping primitive, not an authorization latch. When `enable` is false it substitutes an input of zero, so `out` returns toward zero subject to its position/velocity/acceleration constraints. It does not freeze the prior output. `load` can jump output to the limited input while bypassing velocity/acceleration constraints.

Therefore separate:

1. recipe / GaugePlan validity;
2. target-generation / rearm authority;
3. numeric command shaping (`limit3` or equivalent);
4. homed extra-joint `posthome-cmd` authority;
5. feedback/completion episode evidence.

Do not infer renewed current-plan authority from a plausible `limit3.out` after reference or authorization recovery.

## Current data/control chain

`ImportedPart -> BendFeature -> BendStep -> GaugePlan -> target calculation -> TargetSet generation -> runtime episode -> bounded planner/controller -> extra-joint posthome-cmd`

The first four stages now have explicit provenance/invalidation contracts. Numeric target calculation is intentionally not yet frozen.

## Target-calculation evidence status

Open-source FreeCAD SheetMetal source confirms actual bend-development math depends on inside radius, thickness, K-factor and angle; bend allowance/leg/flange relations are not simple identity mappings.

A bounded commercial-controller documentation search confirmed that mature controllers integrate tooling, material/thickness, backgauge programming and correction systems, but did **not** yield a trustworthy universal public formula mapping a selected part datum directly to X/R/Z. That formula is therefore SOURCE UNAVAILABLE in the bounded pass, not something to invent.

The target-calculation layer must preserve drawing/dimension semantics, selected gauging datum, material/bend-model provenance, tooling/forming reference where relevant, machine calibration/offset revision and participating mechanisms.

## Exact next dependency-safe 3600 work

If F02 remains externally blocked, perform one bounded search for an inspectable open-source/offline press-brake project that actually computes backgauge targets from explicit geometry. Trace:

- input dimension convention;
- selected contact/gauging datum;
- bend allowance/deduction or shop-table use;
- tooling/forming-plane offsets;
- orientation/flip and prior-bend effects;
- X/R/Z allocation;
- calibration/correction provenance.

If no implementation is inspectable after the bounded pass, record SOURCE UNAVAILABLE and freeze only a **generic target-calculation interface/provenance contract**. Do not generate numeric machine targets from guessed formulas.

## Laboratory checkpoint

PB-DXF-003 authoritative workflow `34669836019`, job `103488990203`, artifact `10289893020`, source commit `5b2fb70022b542c431e3e677a7ebd4690e0f8e98` retained eight snapshots and passed unchanged frozen Gates A-J 10/10. Exact job interval was 9 seconds (0.15 min).

PB-DXF-001/002/003 exact compute rows are being integrated through the repository's race-safe compute append workflow rather than by replacing the ledger.

## Claims boundary

The branch establishes application/data ownership and selected source semantics only. It does not establish actual bend geometry accuracy, universal backgauge targets, tooling compatibility, collision freedom, machine reachability, physical positioning accuracy, hydraulic behavior, stopping performance or functional safety.
