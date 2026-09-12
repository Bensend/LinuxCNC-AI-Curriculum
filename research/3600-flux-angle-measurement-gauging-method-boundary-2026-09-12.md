# 3600 — Flux angle-measurement and gauging method boundary

Date: 2026-09-12
Status: dependency-safe 3600 preparation; F02 external gate remains authoritative.

## Why this pass matters

The current information-gain stop permits reopening measured-angle/sensor-bending or explicit-datum gauging only when genuinely new real documentation/source resolves a concrete implementation question. Metamation Flux documentation provides materially richer process semantics than the previously retained generic feature descriptions, although it still does not expose controller source code.

## Evidence classification

All claims below from the Flux reference manual are **DOC-CONFIRMED** for the documented Flux workflow, not LinuxCNC implementation claims and not proof of the underlying Trumpf controller algorithm.

### Angle-measurement methods

Flux documents ACB/ACBLaser/LCB as measuring actual angle during bending and springback, then using that information to adjust beam bottom-dead-center dynamically toward the requested angle.

The manual distinguishes four materially different method semantics:

1. **Identify** — measure actual bend angle; enter decompression; measure springback; compensate by over-bending. The documented sequence deliberately starts with slight underbend and then re-bends to reduce overshoot risk.
2. **Learn Y** — do not use the angle sensor on this bend; copy the beam Y target from a previously measured reference bend. The reference must match angle, radius and tool usage.
3. **Learn SB** — use a previously learned springback value while still using ACB to regulate bending, avoiding a second post-decompression measurement.
4. **Enter SB** — measure target angle but use an operator-entered springback correction; no second post-decompression measurement.

This is stronger evidence than a generic "angle sensor closes the loop" model. Measurement authority, learned correction authority, reference-bend provenance, and phase-dependent acquisition are distinct.

### Automatic method selection and measurement validity

Flux documents automatic method selection: begin with Identify and prefer Learn Y for later bends when angle, radius, tool-set and similar grain orientation permit reuse. It also documents cases where measurement is skipped: angle outside sensor range, non-air-bending processes such as coining/Z-bending/hemming/folding, and pre-bends.

For laser measurement, Flux can choose one/two/three measurement positions based on bend length, evaluate available laser trace length, account for obstruction by die/gauges and holes/formings, compare trace length with machine-defined minimum/ideal thresholds, move measurement positions to improve validity, and add gauge retraction when gauges obstruct measurement.

Therefore a durable sensor-bending program model should preserve at least:

`BendStep -> measurement method -> sensor/system identity -> measurement position(s) -> validity/coverage result -> reference bend/correction provenance -> phase-qualified measurement episode -> resulting correction/beam target`

A scalar measured angle alone is insufficient provenance.

### Gauging surface semantics

Flux documents X/Z/R gauge positioning plus an explicit **Surface** selector. Available surfaces are machine-dependent and may be invalid for particular bends. It distinguishes Stop-type contact from Clamp-type contact; clamp positioning may require simultaneous engagement of two surfaces and can snap between alternative clamp positions while automatically changing R.

Auto-Place can produce multiple feasible gauging positions and cycles through alternatives. The default is associated with the original auto-sequencing/tooling result. Flux also enforces machine constraints such as coupled R positions and can evaluate common Z positions across bends.

Gauge retract is explicitly phase-related: after the part is pinched but before bending, a gauge may retract in +X to avoid collision. Machine defaults further distinguish movement-path strategies, including safe velocity/safe path and final-axis sequencing.

This sharpens the TargetCalculation provenance model:

`part/bend geometry + selected gauge contact surface + stop/clamp mode + machine gauge kinematics/constraints + tooling/setup + feasibility/collision evaluation -> candidate GaugePlan(s) -> selected TargetCalculation/TargetSet`

The chosen X/R/Z numbers are outputs of a contact/constraint/feasibility problem, not sufficient descriptions of the gauging intent by themselves.

## Function/call-flow implication for a future LinuxCNC implementation

The documentation supports a process-level flow, not a LinuxCNC source call chain:

`BendStep selection`
` -> choose/validate gauge contact semantics and candidate gauge plan`
` -> qualify measurement method and sensor geometry`
` -> generate machine targets`
` -> execute pinch/bend/decompression phases`
` -> acquire only phase-qualified measurement(s)`
` -> apply method-specific learned/measured/entered springback authority`
` -> generate/adjust beam target`
` -> preserve result/provenance for later eligible reference bends`

A future LinuxCNC design must not collapse these stages into a generic angle PID or a naked X target without implementation evidence.

## Adversarial boundary check — 7/7 PASS

1. Does ACB documentation prove LinuxCNC has an angle-control loop? **No.**
2. Does Learn Y mean a sensor measurement occurs on that bend? **No; the documented method explicitly reuses a prior beam Y target without ACB use on that bend.**
3. Is springback always measured after decompression? **No; Identify does, while Learn SB/Enter SB avoid that second measurement by different provenance paths.**
4. Can any bend automatically use angle measurement? **No; sensor range, process type and pre-bend status can disqualify it.**
5. Is a backgauge X coordinate enough to define gauging intent? **No; contact surface, stop/clamp semantics, R/Z, machine constraints and feasibility matter.**
6. Does a feasible gauge position prove collision-free motion throughout the transition? **No; the manual separately models movement/retraction strategies and collision state.**
7. Does this documentation reveal realtime acquisition freshness, correction saturation, Y1/Y2 insertion, fault handling or recovery? **No; those remain SOURCE UNAVAILABLE / UNKNOWN.**

## Remaining boundary

This pass materially improves the process/data model but does not satisfy the implementation-source gate. Still UNKNOWN: sensor sampling/acquisition implementation, freshness/generation semantics, controller correction insertion and saturation, Y1/Y2 interaction, exact beam-target update algorithm, fault/recovery behavior, and the actual gauging solver/collision kernel.

No synthetic lab is justified from this documentation alone: a toy implementation would test our invention rather than the documented proprietary mechanism.

## Sources

- Metamation Flux Reference Manual, `Angle Measurement` (copyright 2023): https://metamation.com/wp-content/uploads/Bento/FluxBook/bend/editing/editacb.html
- Metamation Flux Reference Manual, `Editing the Back-gauges`: https://metamation.com/wp-content/uploads/Bento/FluxBook/bend/editing/editgauge.html
- Metamation Flux Reference Manual, `Machine Defaults`: https://metamation.com/wp-content/uploads/Bento/FluxBook/bend/6%20settings/machinedefaults.html
