# 3600 Press Brake Checkpoint — Tooling/Material/Springback + Measured-Angle Boundary

Date: 2026-09-12

## Critical path

`handoffs/F02-fresh-ai-compound-fault-transfer.md` remains PREPARED / UNSCORED and requires a genuinely information-separated evaluator. It remains the sole known 2000-series graduation gate. Do not self-score or contaminate it.

## Work closed in this pass

1. `research/press-brake-tooling-material-springback-ownership-2026-09-12.md`
   - separates material, tooling geometry, bend technology, nominal calculation, machine-specific TargetCalculation, empirical correction, TargetSet generation and runtime ExecutionEpisode;
   - source-confirmed FreeCAD bend-allowance/K-factor calculation boundary;
   - documentation-confirmed commercial separation of overbend, tool/die selection, bend compensation and production correction;
   - explicitly rejects a universal K-factor/springback/Y-depth formula.

2. `research/press-brake-measured-angle-sensor-boundary-2026-09-12.md`
   - models angle as a process measurement with freshness/provenance/phase identity, not a fake commanded joint;
   - separates post-bend measurement/correction from active in-bend sensor correction;
   - inherits the 2000-series freshness/generation/recorder validity boundaries.

3. `research/press-brake-sensor-bending-public-source-audit-2026-09-12.md`
   - bounded public search found feature documentation and community use cases but no inspectable LinuxCNC sensor-bending implementation with enough timing/authority/saturation/recovery detail;
   - generic realtime sensor-bending topology is therefore SOURCE UNAVAILABLE / UNKNOWN.

## Information-gain stop

Do not add another synthetic ownership or toy PID fixture merely to extend the 3600 preparation. The unresolved sensor-bending question requires real source/documentation, not generic simulation.

## Precise next-work checkpoint

1. **Always re-check F02 first.** If an information-separated evaluator result exists, preserve the full evaluator response before changing status. PASS/no corrections => graduate F02 and close the 2000 series according to the dependency graph.
2. If F02 is still externally blocked, keep the 3600 preparation at the current information-gain stop unless genuinely new public implementation/source appears.
3. A worthwhile next 3600 pass must resolve a concrete remaining playbook gap rather than restate ownership. Highest-value candidates are:
   - a newly available downloadable tandem Y1/Y2 implementation exposing correction insertion/saturation/ferror/addf order; or
   - a real measured-angle/sensor-bending implementation exposing acquisition, phase, correction authority and recovery; or
   - concrete public tooling/process-calculation source that adds information beyond the now-established provenance contract.
4. Preserve PB-PREP-001 as INCONCLUSIVE / no architecture recommendation. Do not retune its frozen discriminator.
5. Do not invent target-machine hydraulic, tooling, material, pressure, safety, springback, acceptance-tolerance or sensor-dynamics values.

No laboratory compute was consumed in this pass; source/documentation/community evidence was the appropriate discriminator.
