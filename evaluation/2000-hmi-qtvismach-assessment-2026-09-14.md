# 2000-level advanced HMI / QtVismach assessment — 2026-09-14

Status: **PASS (supplemental 2000-level closeout evidence)**

Curriculum scope: advanced HMI behavior and QtVismach/live 3D visualization from the 2000-level roadmap in `CURRICULUM.md`.

This assessment is supplemental evidence for the 2000-level HMI/visualization scope. It does **not** replace the fresh-AI graduation requirement for F02 and does not alter the information-separation rule in `MODULE_TEMPLATE.md`.

## Assessment scenario

The evaluated response designed a read-only LinuxCNC press-brake visualization with independent Y1/Y2 feedback, X-axis backgauge motion, QtVCP integration, QtVismach transforms, diagnostic exaggeration, stale-data handling, HMI performance constraints, failure analysis, and an implementation sketch.

The key requirement was that the visualization remain a read-only consumer of machine state: LinuxCNC control and physical feedback remain authoritative, and graphics must never become part of motion authorization or the safety chain.

## Result

Overall result: **PASS — approximately 93/100**.

| Category | Score | Assessment |
|---|---:|---|
| QtVismach architecture | 95 | Correct separation of control, visualization adapter, model, and QtVCP HMI. |
| HAL integration | 96 | Correct read-only consumer model and distinction between control signals, visualization pins, and display transforms. |
| LinuxCNC HMI integration | 92 | Good operator/diagnostic split, startup-state handling, camera strategy, and render-rate discipline. |
| Y1/Y2 press-brake modeling | 97 | Strong average-plus-differential/tilt reconstruction rather than collapsing the ram to one Y value. |
| Diagnostic design | 97 | Differential-only visual exaggeration preserves truthful numeric values and real average position. |
| Failure handling | 95 | Correct stale/unavailable-data behavior and good diagnosis of startup/change-event and sign/scale failures. |
| Implementation readiness | 88 | Architecture is implementation-ready, but exact current QtVismach/QtVCP API signatures and lifecycle details still require live/version-specific verification. |

## Capabilities demonstrated

The response correctly demonstrated the following 2000-level concepts:

- QtVismach/QtVCP is a **read-only visualization consumer**, not a source of motion or safety authority.
- Independent Y1 and Y2 feedback must remain visible diagnostically even when the physical beam is represented as one rigid body.
- Beam position can be reconstructed from average Y position plus a differential-derived tilt, while separate Y1/Y2 markers preserve the sensing-plane evidence.
- Diagnostic exaggeration should act only on the displayed differential component; actual DRO values remain unscaled.
- An unchanged position value is not evidence of stale data. Freshness requires a validity/heartbeat/generation/data-age witness from an appropriate source.
- Invalid or stale visualization data must be made conspicuous rather than silently freezing the last position or resetting to a plausible value such as zero.
- A renderer does not need servo-thread update rates; state transfer/rendering should be bounded and decoupled from realtime control.
- Display sign/unit/origin corrections belong in the visualization transform and must not mutate authoritative machine feedback merely to make graphics look correct.
- Event-driven GUI startup must read current state explicitly rather than waiting for the next value-change event.
- Collision or geometric visualization may support setup and diagnostics but is not, by itself, a functional-safety function.

## Remaining implementation-specific work

The remaining weakness is appropriately narrower than the 2000-level learning objective:

1. verify exact current QtVismach/QtVCP imports and constructors for `Collection`, STL/OBJ geometry, `HalTranslate`, `HalRotate`, and the OpenGL widget;
2. verify the exact QtVCP/HAL component lifecycle and startup ordering for the deployed LinuxCNC revision;
3. choose the best concrete implementation boundary for derived visualization-only quantities (userspace HAL component, QtVCP HAL pins, or direct visualization-side calculation);
4. verify the selected stale-data/freshness witness in a real configuration rather than inventing one in the renderer;
5. validate real CAD origins, rotation center, units, signs, and mesh complexity on an actual screen/configuration.

These are implementation/version-integration tasks suitable for a later implementation or machine-specific track. They do not overturn the demonstrated 2000-level architectural understanding.

## Promotion / counterfactual check

If the exact QtVismach API names, constructors, or preferred QtVCP lifecycle differ from the pseudocode used in the assessment, the central 2000-level conclusions remain unchanged: visualization is read-only, Y1/Y2 evidence must not be collapsed, stale data must be explicit, graphics are not safety authority, and machine feedback/control remain authoritative.

Therefore the implementation-specific API uncertainty is **safe to promote** and does **not block 2000-level closeout**.

## Graduation consequence

The advanced HMI / QtVismach/live-3D roadmap topic is considered **sufficiently demonstrated at 2000 level**.

The sole known 2000-series graduation blocker remains the genuinely information-separated evaluation of `handoffs/F02-fresh-ai-compound-fault-transfer.md` identified in `evaluation/2000-series-closeout-state-2026-09-11.md` and `PROGRESS.md`.
