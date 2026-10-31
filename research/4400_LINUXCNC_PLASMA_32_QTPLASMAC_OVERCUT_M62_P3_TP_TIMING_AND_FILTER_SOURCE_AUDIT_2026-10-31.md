# 4000-LC-PLASMA-32 — QtPlasmaC overcut: G-code filter, M62 P3 and actual torch-output timing

**Date:** 2026-10-31. **Track:** LinuxCNC-first 4000 source implementation with 3300 plasma transfer (graduated 3000 stays CLOSED). **Evidence:** SOURCE-CONFIRMED / DOC-CONFIRMED static conditional; TEST-CONFIRMED none. No installed machine claims.

## Why this is new

The general [TP-30](4400_LINUXCNC_TP_30_G64_P_Q_NAIVECAM_CANONICAL_GEOMETRY_AND_IO_BOUNDARY_SOURCE_AUDIT_2026-10-31.md) finding about naive-CAM flush and motion-associated DIOs has a concrete upstream machine application: QtPlasmaC's hole-overcut generator uses `M62 P3` to request torch disable during the extra overcut arc. We trace the real filter, HAL wiring, docs and TP timing rather than assuming a CAM postprocessor's nominal hole endpoint is a physical torch transition.

## Pinned sources (stable v2.9.10)

- [QtPlasmaC G-code filter](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/usr_intf/qtplasmac/qtplasmac_gcode.py#L335-L375) and [`overburn`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/usr_intf/qtplasmac/qtplasmac_gcode.py#L889-L933), blob `4cdae156b94b607bd2514b1573baabc83f396f23`.
- [Filter's `spindle_off` and `program_end` recovery](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/usr_intf/qtplasmac/qtplasmac_gcode.py#L724-L762).
- [Selected QtPlasmaC component HAL](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/lib/hallib/qtplasmac_comp.hal#L10-L50), blob `f3fc216a4932b02a2fe9e8de95cb7c08ced5931e`.
- [Official QtPlasmaC overcut documentation and sample](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/plasma/qtplasmac.adoc#L2102-L2145), blob `9ed0e825ee543cb6a39ac15d18aa149c29a85b23`.
- [Plasmac realtime component](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/components/plasmac.comp#L565-L583), blob `8f22cf1789b8adb49fe0a8d7e7cd5bd33444bf6c`: its `if(torch_off){torch_on = FALSE;}` branch explicitly forces the ordinary torch-on output low when the request is observed. This is a **component execution path**, not measured latency or external arc extinction.
- [Canonical M62 flush](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc#L3137-L3155), [TP DIO staging](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c#L1547-L1558), [blend output selection](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c#L3044-L3057) and [DIO activation](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c#L2491-L2505).

## Full source-to-HAL chain

1. `qtplasmac_gcode.py::overburn` computes an additional arc endpoint using the configured overcut length and hole radius. Without active G41 compensation, it **appends `M62 P3 (disable torch)` followed by a G02/G03 overburn arc**. With `offsetG4x` active, it instead comments out the M62, marks a warning and records the original line as an error; a postprocessed hole is not automatically proof of an enabled overcut disable.
2. The G-code filter tracks a `torchEnable` flag on `M62 P3/M64 P3` versus `M63 P3/M65 P3`. At `M05` or program end, if it believes torch remains disabled, it inserts **immediate `M65 P3`** to restore permission. That is a parser-level state machine, not physical torch-feedback validation.
3. `qtplasmac_comp.hal` wires `motion.digital-out-03 => plasmac.torch-off`. **The physical torch command is `plasmac.torch-on`**, a separate component output; `motion.digital-out-03` is a torch-off request input to the plasma component, not the power-supply contactor output itself. The same HAL maps P1 to ignore-arc-ok and P2 to THC-disable. The `plasmac.comp` realtime body forces `torch_on = FALSE` on a true `torch_off` input, but the physical timing still includes component thread scheduling and external hardware response. This prevents confusing an M62 P3 status bit with actual arc extinguishing.
4. `M62 P3` flushes the canonical naive-CAM buffer, so the prior hole arc and the subsequent overburn arc are separate canonical commands even under positive G64 Q. The TP stages DIO 3 on the next segment. **This does not force a geometric exact stop.** In a parabolic overlap the next segment's staged DIO is applied when TP chooses that segment for status (next velocity >= previous velocity), which can occur before the programmed vertex has been reached. The exact transition depends on active blend mode, velocities, accel, segment geometry and servo scheduling.
5. The official sample uses `G64 P0.005`, `M62 P3`, a 4 mm overcut arc, `M63 P3`, `M5`, then `G0`. The docs explicitly distinguish motion-synchronized M62/M63 from immediate M64/M65 and warn that synchronized outputs need a following motion. A nominal `M63 P3` before M5 does not by itself prove the reenable occurred before the next rapid; the filter's M65 recovery is a separate immediate path.

## Minimal reproducible disconnected test plan (NOT EXECUTED)

Use a **pinned QtPlasmaC simulation** with a synthetic hole, an overcut length of 4 mm, and no physical plasma supply. Preserve both **original CAM G-code** and **filter-produced G-code**; diff the overcut arc and inserted M62/M65 lines. In a servo-sampled trace record `motion.digital-out-03`, `plasmac.torch-off`, `plasmac.torch-on`, TP active segment/motion type, XY commanded position, actual simulated position, velocity, `M3/M5` state and the G64 P/Q setting.

Compare (A) ordinary overcut with M62 P3, (B) G41 compensation active and filter warning, (C) explicit M64 P3 immediate disable, (D) two contradictory same-index M62/M63 P3 before any next move, and (E) no following move before M5/program end. For A, **do not** grade against an invented fixed millisecond or millimeter offset; measure the actual command and HAL transitions relative to the programmed vertex and actual TP blend. For B, distinguish the parser's warning from a runtime error. For C, document the intentional loss of motion synchronization and possible blend interruption. For D, expect only the last staged value at the next motion boundary, not a guaranteed off/on pulse.

## Engineering transfer and limits

Plasma overcut geometry, torch-off scheduling, THC state, and the physical arc-off delay are distinct acceptance quantities. A DXF/nesting/CAM exporter must not treat `M62 P3` as a hardware-accurate end-of-hole event. This source audit does not establish actual QtPlasmaC component latency, plasma power-supply response, or an installed machine defect. Personnel-safety functions remain independent of ordinary LinuxCNC/plasmac controls. **No simulation, workflow, build, test, physical operation or Actions compute was performed.**
