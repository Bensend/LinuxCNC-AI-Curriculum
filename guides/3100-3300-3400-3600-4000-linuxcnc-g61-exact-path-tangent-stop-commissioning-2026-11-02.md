# 3100/3300/3400/3600/4000 — LinuxCNC G61 vs G61.1 tangent-boundary commissioning

**Scope:** ordinary process-path commissioning only. Source audit [TP-166](../research/4400_LINUXCNC_TP_166_G61_G611_TANGENT_CONTINUITY_AND_INI_SOURCE_AUDIT_2026-11-02.md). **NOT RUN**; do not load these examples on a connected machine.

## Operator/programmer contract

`G61` requests exact **path**, not a mandatory stop. In stable 2.9.10, the planner can promote an eligible G61 segment boundary to tangent continuity when `ARC_BLEND_ENABLE=1` and tangent gates pass. `G61.1` requests a stop at each segment boundary. `G64` is blending; `G64 P0` does **not** mean exact path. The canonical interpreter test only verifies emitted modes, not the physical or commanded velocity profile.

## Disconnected A–H walkthrough

1. **A — Freeze configuration:** record LinuxCNC commit, actual INI, `ARC_BLEND_ENABLE`, `ARC_BLEND_OPTIMIZATION_DEPTH`, `ARC_BLEND_KINK_RATIO`, servo period, acceleration/velocity limits, G-code checksum, active path mode. Require verified physical disconnection before any TP run.
2. **B — G61 collinear:** run `g61_collinear.ngc` in the isolated simulator; capture segment identity, junction X10 Y0, commanded velocity at junction, position command, actual position and following error. Prediction: tangent optimization *eligible*; do not predeclare a numerical speed.
3. **C — G61.1 negative control:** same path with `g611_collinear.ngc`. Prediction: STOP condition forbids tangent promotion; compare junction velocity after controlling for acceleration and sample timing.
4. **D — INI differential:** with same G61 path, disable `ARC_BLEND_ENABLE` in a fresh simulator process. Prediction: `tpHandleBlendArc`/tangent setup not invoked. Do not infer safety or claim all G61/G61.1 behavior identical.
5. **E — Sharp-corner discriminator:** change second G1 to X10 Y10. Under G61 the exact vertex must be visited; no G64-style corner-cutting arc should be created. Record if a stop is required by the chosen dynamics.
6. **F — G64 contrast:** `g64_collinear.ngc` uses `G64 P0 Q0`. Distinguish tolerance-less blending from exact path; for a useful geometric comparison, add a corner only after preserving the original control.
7. **G — Cutter-comp preflight:** with a known tool table and disconnected interpreter, attempt a path-mode switch while G41/G42 active. Expected interpreter error; do not use this as a runtime stop test. Ensure `G40` before changing mode in actual posts.
8. **H — Process acceptance:** for mill toolchange approach, router lead-in, plasma pierce/cut transition and press-brake backgauge reposition, separately specify *geometric waypoint*, *zero-speed/settle requirement*, *tool/fixture envelope*, and *independent personnel safety*. A G61 line alone establishes none of the latter three.

## Reproduction and pass/fail

Use an existing upstream simulation configuration with no machine outputs, reviewed for isolation. Set units and feed explicitly; run the three programs **separately** (do not assume one program's modal state persists through M2). Capture NML/TP mode change, commanded velocity/position around the junction and HAL status sampled at servo rate; GUI preview alone is insufficient. **Pass** means source-predicted condition and measured command trace agree within stated sample resolution; **fail** means a reproducible contradictory trace. A zero velocity observed in G61 is not proof G61 always stops: geometry, short moves or acceleration can force zero. Keep raw traces and actual job start/end times.

**Evidence gate:** only self-hosted `[self-hosted, openpressbrake]` when independently isolated; never hosted runners. No test or physical machine has been run. Preserve qualified OpenPressBrake G0/G1 HOLD and independent personnel-safety authority.
