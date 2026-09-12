# 3600 — commercial tooling/gauge workflow boundary (2026-09-12)

## Purpose

This pass tests a narrow question left open by the 3600 information-gain checkpoint: is there defensible public evidence that production press-brake programming treats backgauge/axis targets as part of a tooling- and machine-aware process model rather than as a bare flange-length scalar?

This is **commercial workflow/documentation evidence only**. It is not implementation source and must not be used to infer proprietary formulas, realtime behavior, safety behavior, or a LinuxCNC architecture recommendation.

## Sources

1. LVD, **CADMAN-B | Intelligent programming** (retrieved 2026-09-12):
   https://www.lvdgroup.com/en-us/software/cadman-b
2. Delem, **Profile-T** (retrieved 2026-09-12):
   https://www.delem.com/en/solutions/offline-software/profile-t/profile-t
3. Delem, **DA-58Tx** (retrieved 2026-09-12):
   https://www.delem.com/en/solutions/pressbrake-controls/da-50-series/da-58tx
4. Delem, **DA-69T** (retrieved 2026-09-12):
   https://www.delem.com/en/solutions/pressbrake-controls/da-60-series/da-69t

## Documented observations

### LVD CADMAN-B

LVD states that CADMAN-B:

- automatically unfolds the part and calculates bend allowances;
- determines bend sequence, tooling, tool setup and gauge positions;
- uses the **actual bend interface of the press brake** and an expert bending database for unfolding rather than a generic material/thickness-only model;
- can determine a corrected bend allowance after tooling changes;
- performs start-to-finish 3D simulation with collision detection, gauge positions and tool setups.

This establishes that at least one production workflow treats tool selection, bend allowance, gauge position and collision checking as related process-planning state. It does **not** establish the internal gauge-position formula or prove which exact tooling fields are consumed by that formula.

### Delem Profile-T / DA controls

Delem documents Profile-T as an offline counterpart to its DA-Touch control workflow, with:

- graphical product programming;
- automatic 2D/3D bend-sequence calculation;
- collision detection;
- machine setup preparation;
- tool/product import;
- 3D finger visualization;
- X1-X2 angle programming support.

For DA-58Tx, Delem states that axis positions are automatically computed and the bend sequence can be simulated with the machine and tools at real scale. DA-69T separately exposes sensor-bending/correction interfacing, X1-X2 angle programming, thickness compensation, frame-deflection compensation and TandemLink as controller capabilities/options.

These are useful ownership/interface observations, but they do not disclose the implementation algorithms or realtime ordering behind those capabilities.

## Bounded workflow model

The public documentation supports this *workflow-level* relationship:

`product geometry + machine/tool/process data`

`-> bend/unfold preparation`

`-> bend sequence + tooling/setup selection`

`-> axis/gauge target generation`

`-> machine/tool/finger simulation and collision checking`

`-> production program`

This is **not a source call graph**. No public function names, data structures, solver equations, interpolation rules, collision kernel, or target-generation source path were exposed by the inspected documentation.

## Consequence for the LinuxCNC 3600 contract

A future open press-brake target solver should not collapse the input to `finished_flange_length -> X` unless the selected programming convention explicitly proves that simplification is valid.

The durable target-calculation provenance should be capable of naming, when applicable:

- finished-part geometry and the chosen gauging/reference surface;
- bend line / bend datum convention;
- punch/die/tool-set identity and revision;
- material/thickness/process/bend-technology revision;
- machine/backgauge kinematic convention (including which X/R/Z or split axes are being targeted);
- finger/tool/setup identity when target validity depends on them;
- calculation-engine/version identity;
- resulting target set;
- collision/feasibility result and its engine/version separately from target generation.

The last separation matters: a target can be numerically generated without proving that the part/tool/finger trajectory is collision-free.

## What remains UNKNOWN

The inspected sources do **not** establish:

1. the formula or geometric construction mapping a chosen gauging surface to X/R/Z targets;
2. whether bend allowance, bend deduction, tool geometry or measured correction enters each gauge-axis calculation directly or indirectly;
3. how a selected finger contact point is chosen when several contacts are feasible;
4. the collision solver or sequence optimizer objective/cost function;
5. runtime command-acceptance, freshness, at-position or recovery semantics;
6. sensor-bending correction insertion or saturation behavior;
7. tandem Y1/Y2 realtime synchronization/fault ownership;
8. any functional-safety property.

Therefore the earlier source boundary is preserved: **no implementation-level backgauge solver was found in this pass**.

## Adversarial boundary check

1. **Does LVD's tooling-aware unfolding prove the backgauge formula consumes tooling geometry?** No. The documentation places them in the same production workflow but does not expose that internal dependency.
2. **Does automatic axis-position computation reveal an algorithm?** No. It establishes a capability only.
3. **Does 3D finger visualization prove collision-free execution?** No. It documents a simulation feature, not a formal or physical guarantee.
4. **Does Delem's sensor-bending option reveal an angle-control loop?** No. Interface/capability evidence is not loop topology or source evidence.
5. **Does TandemLink establish a reusable Y1/Y2 LinuxCNC architecture?** No. It is a proprietary product capability with no inspectable synchronization source here.

Result: **5/5 boundary checks passed.**

## Classification

- Tooling/machine-aware production-program workflow: **COMMERCIAL-DOCUMENTATION CONFIRMED**.
- Exact flange/gauging-surface -> backgauge solver: **SOURCE UNAVAILABLE / UNKNOWN**.
- Sensor-bending implementation: **SOURCE UNAVAILABLE / UNKNOWN**.
- Tandem Y1/Y2 implementation: **SOURCE UNAVAILABLE / UNKNOWN**.
- Architecture recommendation from these sources alone: **NOT JUSTIFIED**.

## Next-work checkpoint

1. Re-check F02 first; preserve evaluator identity and information separation if a result appears.
2. If F02 remains blocked, do not turn this workflow evidence into guessed formulas.
3. Resume the backgauge calculation branch only when inspectable source exposes an actual gauging-surface/tooling -> target transformation, or when an independently reproducible implementation can be tested against explicit datums.
4. Preserve the existing information-gain stop for tandem Y1/Y2, active sensor bending, and equivalent generic calculator/table searches until new implementation evidence appears.
