# 4000-LC-TWP-111 — G68.2 frame composition is not five-axis tool orientation
**2026-11-01 | Status SOURCE / NON-GRADUATED | LinuxCNC development 06864e23559e70463fc7112d5ce77138bcbc288c; stable v2.9.10 peeled 86cdca76fa2a36274c432caa21952b23c267989a.**

## Question and novelty
Does a LinuxCNC G68.2 tilted work plane rotate machine joints, align the tool to the surface, or merely transform programmed XYZ before Task/motion? This is a 3100 mill/3500 kinematics/4000 CAM-post interface question, distinct from NURBS-109/110's curve geometry and LATHE-107's spindle phase. Repository progress and code search for G68.2/workplane found no earlier exact treatment. Do not infer runtime success from source.

## Pinned upstream chain
1. [Official development G68.2 specification](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/docs/src/gcode/g-code.adoc#L2020-L2080) documents G68.2 P0/P1/P2/P3, G68.4 composition, G69 cancel, and the transform order. [Stable v2.9.10 G-code reference](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/gcode/g-code.adoc) has no G68.2 entry; stable `interp_workplane.cc` path is absent (GitHub 404 at that commit). **VERSION-GATED**: do not emit this G-code from a stable 2.9 CAM post.
2. [`interp_workplane.cc`, `work_plane_build` lines 361–562](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/rs274ngc/interp_workplane.cc#L361-L562) parses P1 fixed-axis Q123 by default, P0 moving-axis Q313 by default, P2 point sequence, P3 vectors, and G68.4 composition. [`work_plane_set` lines 205–230](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/rs274ngc/interp_workplane.cc#L205-L230) captures current world position, changes interpreter frame, recomputes program position, and sends `SET_G68_FRAME`. Defining the plane does not itself enqueue a traverse.
3. [`g68_apply` / `program_to_world_xyz` lines 121–183](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/rs274ngc/interp_workplane.cc#L121-L183) implement `p_world = tool + G5x + RotZ(XY)·(G92 + O + R·(L + p_program))` for XYZ. `L` is plane-local G52; A/B/C and U/V/W do **not** pass through the plane. The reverse uses transpose of R (orthonormal matrix). [`emccanon.cc` lines 199–284](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/task/emccanon.cc#L199-L284) independently applies the same frame to canonical XYZ, not to rotary coordinates.
4. [`SET_G68_FRAME` lines 554–574](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/task/emccanon.cc#L554-L574) flushes prior segments, updates canonical shadow and queues `EMC_TRAJ_SET_G68`; [Task dispatcher lines 1580–1588, 1995–2006](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/task/emctaskmain.cc#L1995-L2006) updates task status after earlier motion. It is an **executed-command/status witness**, not a motor-orientation witness.
5. [`convert_tool_length_offset` G43.4 path lines 6684–6709](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/rs274ngc/interp_convert.cc#L6684-L6709) separately switches to a primary kinematics type before applying tool length offset. [Kinematics conventions: tool X](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/docs/src/motion/kinematics-conventions.adoc#L190-L228) distinguishes physical rotary joints from virtual tool-axis rotation. **G68.2 does not automatically request rotary alignment or prove that the installed kinematics can achieve the tool normal.** A machine-specific orientation strategy, limits, collision model and TCP behavior remain separate.

## Reproducible arithmetic (not an executed LinuxCNC test)
Assume metric, identity G54/G92/tool offsets, XY rotation zero, P1 default Q123. `G68.2 P1 X10 Y20 Z30 I90 J0 K0` rotates around fixed X: `R(x,y,z)=(x,-z,y)`. At programmed `(0,0,5)`, the expected absolute XYZ is `(10,15,30)`. After `G52 X2 Y3 Z4` inside the plane, the *effective* plane origin is `O + R·L = (12,16,33)`; programmed `(0,0,5)` maps to `(12,11,33)`. These are source-derived predictions, not measured motion. With nonzero G5x, G92, XY rotation, or tool offset, apply the entire chain in the stated order.

## Source-defined boundaries and failure paths
- P2/P3 incomplete/out-of-order Q, collinear points, zero vectors, invalid axis order, active cutter compensation, or G68.4 without an existing plane are rejected by `work_plane_build` / `convert_work_plane` ([source](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/rs274ngc/interp_workplane.cc#L334-L562)).
- A plane changes the interpretation of **programmed** XYZ, not the machine's physical tool orientation. A geometrically correct preview does not establish rotary clearance, TCP selection, or probe/fixture safety.
- The in-tree [`tests/interp/g68-frame/expected`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/tests/interp/g68-frame/expected) is an upstream *expected-output fixture*; its presence is not evidence it was executed in this session.

## Claims and verification
| Claim | Evidence | Classification | Runtime proof |
|---|---|---|---|
| Stable 2.9 lacks native G68.2 | pinned stable docs + absent source path | SOURCE/DOC version contrast | NOT RUN |
| Development transforms XYZ through plane before other offsets | interpreter + canonical source | SOURCE-CONFIRMED | NOT RUN |
| G68.2 alone does not align rotaries | transform code + separate G43.4 kinematics path | SOURCE-CONFIRMED boundary | NOT RUN |
| Numeric XYZ examples | explicit matrix arithmetic | INFERENCE from source | NOT RUN |
| Installed 5-axis tool actually reaches tilted normal | needs kinematics/config/physical witness | UNKNOWN | NOT RUN |

## Adversarial handoff
A post emits G68.2 P1 I90 followed by G1 Z-5 on a 3-axis XYZ machine. Can the programmer infer a tilted drilled hole? **No**: the transform may map Z motion into Y in program/world space, but tool axis remains physically vertical unless the machine has separate orientation control. Check kinematics and tool normal, not only transformed endpoints. No physical movement is authorized by this source study.

## Dependency and next
Prerequisites: interpreter→Task→motion and 3100/3500 kinematics. Follow [TWP-112](4400_LINUXCNC_TWP_112_G68_RETAIN_STATUS_G52_PROVENANCE_SOURCE_AUDIT_2026-11-01.md) and [practical guide](../guides/3100-4000-linuxcnc-g682-tilted-work-plane-cam-and-status-2026-11-01.md). Next evidence: disconnected development `saicanon`/sim versus stable parser and status; inspect actual kinematics before any machine use. No claim of a newly discovered upstream defect.
