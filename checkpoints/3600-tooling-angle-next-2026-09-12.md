# 3600 Press Brake Checkpoint — Tooling/Material/Springback + Measured-Angle + Calculation Semantics

Date: 2026-09-12

## Critical path

`handoffs/F02-fresh-ai-compound-fault-transfer.md` remains PREPARED / UNSCORED and requires a genuinely information-separated evaluator. It remains the sole known 2000-series graduation gate. Do not self-score or contaminate it.

## Work closed in current preparation

1. `research/press-brake-tooling-material-springback-ownership-2026-09-12.md`
   - separates material, tooling geometry, bend technology, nominal calculation, machine-specific TargetCalculation, empirical correction, TargetSet generation and runtime ExecutionEpisode;
   - explicitly rejects a universal K-factor/springback/Y-depth formula.

2. `research/press-brake-measured-angle-sensor-boundary-2026-09-12.md`
   - models angle as a process measurement with freshness/provenance/phase identity, not a fake commanded joint;
   - separates post-bend measurement/correction from active in-bend sensor correction.

3. `research/press-brake-sensor-bending-public-source-audit-2026-09-12.md`
   - bounded public search found feature documentation and community use cases but no inspectable LinuxCNC sensor-bending implementation with enough timing/authority/saturation/recovery detail;
   - generic realtime sensor-bending topology remains SOURCE UNAVAILABLE / UNKNOWN.

4. `research/press-brake-bend-allowance-public-source-audit-2026-09-12.md`
   - source-traced two downloadable bend/flat-pattern implementations;
   - confirmed a conventional `BA = angle_rad*(R+K*T)` implementation against CAD documentation while finding a 180-degree tangent-setback singularity and an application-specific K-factor guard that must not be generalized;
   - independently found a flat-pattern/DXF generator whose schema and README expose K-factor and bend radius while its actual manufacturing-geometry path ignores both and uses fixed `BD = 1.8*thickness`;
   - adds the rule that calculation provenance must preserve **implementation/version and actual consumed-input lineage**, not merely UI/schema values.

5. `research/press-brake-empirical-bend-table-semantics-2026-09-12.md`
   - documentation-confirmed that real bend tables are not one portable semantic object;
   - Vertex tables may store **half bend deduction** by material/thickness/V-opening/punch-radius/angle and may be populated experimentally;
   - BricsCAD CSV explicitly carries angle and length/datum semantics;
   - SpaceClaim distinguishes compensation tables from radius tables that map thickness/V-die/tool-radius/angle to actual geometry radius;
   - pinned Onshape public API client exposes bend-table `SourceMicroversion` plus structured table rows/columns, demonstrating a useful version-provenance surface even though it does not establish how empirical values were generated;
   - establishes that full/half, angle convention, dimensional datum, units, tooling lookup keys, interpolation state and table revision must survive import or remain UNKNOWN.

## Information-gain stop

Do not add another synthetic ownership fixture, toy PID, generic nominal bend calculator, or equivalent CAD bend-table help page merely to extend 3600 preparation. The generic formula and table-semantics branches are now sufficiently sampled to establish the important semantic/dataflow traps.

## Precise next-work checkpoint

1. **Always re-check F02 first.** If an information-separated evaluator result exists, preserve the full evaluator response before changing status. PASS/no corrections => graduate F02 and close the 2000 series according to the dependency graph.
2. If F02 is still externally blocked, keep 3600 at the information-gain stop unless genuinely new implementation/source resolves a concrete gap.
3. Further calculation-domain research now requires implementation-level information gain, preferably one of:
   - source for measured-coupon fitting/interpolation into an empirical bend table;
   - a real flange/gauging-surface-to-backgauge target solver with explicit dimension datums and tool geometry;
   - a production tool/method calculator whose actual source path consumes punch/die geometry and bend-method inputs.
4. Other high-value source opportunities remain:
   - a downloadable tandem Y1/Y2 implementation exposing correction insertion, saturation, ferror and realtime/addf order;
   - a real measured-angle/sensor-bending implementation exposing acquisition, phase, correction authority and recovery.
5. Preserve PB-PREP-001 as INCONCLUSIVE / no architecture recommendation. Do not retune its frozen discriminator.
6. Do not invent target-machine hydraulic, tooling, material, pressure, safety, springback, acceptance-tolerance or sensor-dynamics values.

No laboratory compute was consumed in these calculation/table passes; source/dataflow/documentation analysis was the appropriate discriminator.
