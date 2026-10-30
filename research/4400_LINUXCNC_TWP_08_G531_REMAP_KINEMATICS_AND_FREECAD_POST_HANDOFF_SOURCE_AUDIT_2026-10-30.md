# 4000-LC-TWP-08 — LinuxCNC G53.1: FreeCAD's alignment command crosses a machine-specific remap and kinematics boundary
**Session start 2026-10-30T22:35:16Z UTC | SOURCE-CONFIRMED pinned development and FreeCAD source | NON-GRADUATED | no runtime**

## Question / predecessor
The [FreeCAD LinuxCNC post audit](4400_FREECAD_LINUXCNC_POST_06_BLEND_DWELL_TWP_VERSION_BOUNDARY_SOURCE_AUDIT_2026-10-30.md) established that a configured tilted-work-plane (TWP) operation emits `G68.2`, `G53.1`, `G69`; LinuxCNC stable v2.9.10 lacks G68.2 while development has it. The unresolved engineering question was **what actually implements G53.1** in a real development machine configuration, and whether FreeCAD's generic post can be treated as a machine-independent alignment command. It cannot.

## Pinned source / configuration
- LinuxCNC development [`24e84c4506b41634240f7087f0295e361a954886`](https://github.com/LinuxCNC/linuxcnc/tree/24e84c4506b41634240f7087f0295e361a954886).
- [`configs/sim/axis/vismach/5axis/table-rotary_spindle-rotary-nutating/xyzbca-trsrn_twp/xyzbca-trsrn.ini`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/configs/sim/axis/vismach/5axis/table-rotary_spindle-rotary-nutating/xyzbca-trsrn_twp/xyzbca-trsrn.ini), blob `d3032855aee71584de6c04baa89589b0fbb037a4`.
- [`remap_subs/g531remap.ngc`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/configs/sim/axis/vismach/5axis/table-rotary_spindle-rotary-nutating/remap_subs/g531remap.ngc), blob `4b2fd293c611f2a9b3713561f08443f5d6737ce4`.
- [`python/remap.py`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/configs/sim/axis/vismach/5axis/table-rotary_spindle-rotary-nutating/python/remap.py), blob `7431b8ad63533a1b2a57901c0ad9dfee53b1361b`: `g53n_core` ~570–727 and `g682` ~837–956.
- [`docs/src/motion/switchkins.adoc`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/motion/switchkins.adoc), blob `edb93924ae2aa1feeb54e86c8a709973f6a87341`, especially ~23–35, 49–74, 155–199.
- FreeCAD [`TiltedWorkPlane.py`](https://github.com/FreeCAD/FreeCAD/blob/bbc08916a0bab73fdb4b7f3dad7ff706a18924c9/src/Mod/CAM/Path/Post/TiltedWorkPlane.py), pinned `bbc08916a0bab73fdb4b7f3dad7ff706a18924c9`, `DIALECTS` ~103–108 and `euler_zxz` ~80–82.

## Trace: generic post → specific remap → real kinematics
1. **FreeCAD post:** for an enabled tilted plane, `PlaneCommand.G68_2` declares `G68.2 X{x} Y{y} Z{z} I{a1} J{a2} K{a3}`, then `G53.1` aligns, `G69` cancels. Its `euler_zxz` computes intrinsic Z-X'-Z'' Euler angles. The post does **not** supply the machine's rotary-axis geometry, offsets, joint limits, remap scripts or motion wiring.
2. **Real LinuxCNC development example:** the INI explicitly declares `REMAP = G53.1 modalgroup=1 argspec=p ngc=g531remap`, plus `REMAP = M530 modalgroup=10 python=g53n_core`. It also remaps G68.2 to Python `g682`, G69 to an NGC wrapper, and configures `KINEMATICS=xyzbca_trsrn`, six joints and `[TWP] PRIMARY=C, SECONDARY=A`. This is **machine-specific software**, not an interpreter-wide promise that G53.1 is universally available.
3. **NGC wrapper:** `g531remap.ngc` starts with `M66 L0 E0` to stop read-ahead, defaults absent P to zero, executes `G13.1` to select identity kinematics, synchronizes again, calls `M530 P#<P>`, then synchronizes. The missing P word in FreeCAD's bare `G53.1` is **handled by this example wrapper**, not evidence that every remap has the same default.
4. **Python core:** `g53n_core` checks that a TWP is defined but not already active, validates P in {0,1,2}, solves candidate rotary pairs and chooses an optimized reachable pair. It writes calculated rotary/virtual rotation values to the machine kinematics, computes a transformed work offset, and issues `G10 L2 P6/P7/P8/P9` to update G59-family work offsets. It may issue **ordinary G0 rotary positioning**, selects `G59`, executes `G12.1 P2` to activate the TWP kinematics mode, and updates TWP state via `M68 E2 Q2`. This is a substantial machine state transition, not a mere GUI annotation.
5. **G68.2 prerequisite:** the example's Python `g682` rejects a second definition and requires the active work coordinate system to be **G54** before defining TWP. Its default P=0 and Q=313 select intrinsic ZXZ Euler-angle convention, consistent in kind with FreeCAD's `euler_zxz`. This is a **positive source compatibility clue for that convention**, not proof that origins, axis directions, units, geometry, limits or actual motion are correct.
6. **Kinematics documentation:** `G12.1` and `G13.1` synchronize interpreter and motion when changing switchable kinematics. Directly driving the deprecated `motion.switchkins-type` HAL pin can leave the interpreter's look-ahead in a different kinematics mode. The inspected example deliberately uses the synchronized G-code route. This distinction is a LinuxCNC implementation lesson independent of FreeCAD.

## Critical failure paths and boundaries
- **No G53.1 remap or different remap semantics:** the post's syntax alone cannot establish the alignment mechanism. Inventory the exact installed INI `REMAP`, `[PYTHON]`, subroutine path, kinematics module and joint/axis assignment. An example config is not a reusable plug-in for an unrelated mill, robot or press brake.
- **G54 precondition violated:** example `g682` explicitly aborts if defining TWP outside G54. A generic post that assumes arbitrary active WCS is therefore not verified against this example.
- **TWP not defined/already active:** `g53n_core` emits an error and abort path. It does not safely guess a rotary pose.
- **Rotary solution/limits:** the core attempts angle solution/optimization; the actual machine's reachability, collision envelopes, tool length, workholding and limit behavior are **UNKNOWN**. `G0` alignment is an ordinary motion command; source does not prove safe clearance.
- **Work offset mutation:** `G10 L2 P6–P9` writes work-offset state. A program that assumes G59-family offsets are unchanged after a TWP operation is incompatible with this example's state model. Validate reset/cancel and restart semantics before use.
- **Preview vs task:** `g53n_core` exits early for the preview interpreter (`self.task==0`). A preview picture cannot establish task-side remap completion or actual motion.

## Practical source-based compatibility matrix
| Controller/profile | G68.2 | G53.1 alignment | What is established |
|---|---|---|---|
| LinuxCNC stable v2.9.10 pinned in predecessor | Not present in inspected interpreter | No universal machine-specific TWP path established | A configured FreeCAD TWP post is **not** generally compatible |
| Pinned LinuxCNC development interpreter | G68.2 available | Must inspect INI/remap and kinematics | Parsing support alone is insufficient |
| Pinned `xyzbca-trsrn_twp` simulation example | Python G68.2 remap; G54 prerequisite | NGC→M530 Python→rotary G0/G59/G12.1 P2 | Concrete inspectable example; **NOT TEST-CONFIRMED** |
| Actual OpenPressBrake or any mill/robot | UNKNOWN | UNKNOWN | Do not infer installed hardware, geometry, motion or release |

## Bounded learner exercise (unscored; no sealed evaluator)
Given a FreeCAD output sequence `G68.2 X0 Y0 Z0 I0 J30 K0` / `G53.1` / `G69`, identify which INI remaps and Python/NGC functions would run in this *specific* LinuxCNC example. Explain why the G53.1 wrapper inserts `M66 L0 E0` and why replacing `G12.1 P2` with a direct `motion.switchkins-type` write is not equivalent. Identify all coordinate-offset changes and machine-specific prerequisites before accepting any NC.

## Evidence and next
- **SOURCE-CONFIRMED:** FreeCAD ZXZ declaration/align/cancel template; LinuxCNC example's G53.1/G68.2/G69/M530 remaps, P default, G54 check, read-ahead synchronization, kinematics switching, G59-family offset writes and ordinary G0 alignment path.
- **DOC-CONFIRMED:** switchkins synchronization and deprecated HAL-pin warning in pinned LinuxCNC documentation.
- **INFERENCE:** a generic FreeCAD TWP program will be incompatible with a machine lacking equivalent remaps/kinematics; no installed-machine claim.
- **UNKNOWN:** actual FreeCAD generated NC, LinuxCNC runtime error text, rotary clearance, exact physical pose, tool/work offsets, installed machine revisions and physical safety behavior.
- **TEST-CONFIRMED:** none; no build, simulator, workflow, physical test, machine operation or GitHub-hosted/self-hosted compute.

**Next information gain:** inspect a second LinuxCNC five-axis configuration to determine whether G53.1/G68.2 are truly generic or example-local; if a concrete version-specific execution ambiguity survives, freeze an interpreter-only acceptance fixture on verified isolated local `[self-hosted, openpressbrake]`. Do not spend hosted Actions minutes. Existing 1000/2000/F02/3000 closure, G0/G1 HOLD and independent evaluator OPEN remain unchanged.
