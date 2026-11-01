# 3100/3500/4000 implementation walkthrough — tilted work plane, CAM and status
**Development-only LinuxCNC G68.2/G68.4/G69; pinned 06864e23559e70463fc7112d5ce77138bcbc288c. NON-GRADUATED / no runtime verification.**

## When this matters
A 3+2 mill CAM post may express holes/paths in a feature coordinate system, but LinuxCNC's **tilted work plane is a coordinate transform, not a command to orient a rotary head or table**. Treat post output, kinematics selection, physical tool-axis alignment, tool-length compensation and feedback as distinct contracts. Native G68.2 is not present in inspected stable v2.9.10; gate the post on the installed controller version.

## Source navigation
- [TWP-111: interpreter→canon→Task and rotary/kinematics boundary](../research/4400_LINUXCNC_TWP_111_G682_FRAME_CHAIN_VS_KINEMATICS_SOURCE_AUDIT_2026-11-01.md).
- [TWP-112: G52 effective origin, status and retain/abort](../research/4400_LINUXCNC_TWP_112_G68_RETAIN_STATUS_G52_PROVENANCE_SOURCE_AUDIT_2026-11-01.md).
- [Development G-code reference](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/docs/src/gcode/g-code.adoc#L2020-L2188), [in-tree G68 interpreter expected output](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/tests/interp/g68-frame/expected), [retention test source](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/tests/workplane-retain/test-ui.py) and [retention expected output](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/tests/workplane-retain/expected).

## Minimal disconnected interpreter/preview fixture
Do not send this to a real machine. It assumes G54, G92, tool and XY offsets are zero; the fixture does not change persistent work offsets. Put in an **isolated sim** and compare emitted absolute canonical XYZ with the arithmetic before any machine configuration work:

```ngc
%
G21 G90 G17 G94 G40 G49 G54
G68.2 P1 X10 Y20 Z30 I90 J0 K0
G0 X0 Y0 Z5
G52 X2 Y3 Z4
G0 X0 Y0 Z5
G52 X0 Y0 Z0
G69
M2
%
```

Expected absolute XYZ with the stated zero-offset precondition: first G0 `(10,15,30)`; second G0 `(12,11,33)`. These are **predeclared source-derived predictions**, not observed results. G52 and G69 themselves do not request motion; changing the frame changes the displayed/program coordinates of a stationary tool. If the simulator has nonzero G54/tool offsets, account for them or stop and reset the fixture assumptions in simulation.

## CAM-post handoff contract
1. **Version and dialect:** require development build with native G68.2; stable 2.9.10 should reject or require a different supported workflow. Do not confuse this with older third-party remap-based TWP examples.
2. **Plane definition:** emit explicit P1 and I/J/K (or explicit P2/P3 points/vectors), units, WCS and modal state. P0 default Q313 is *not* P1 default Q123; post must not silently substitute one for the other.
3. **Orientation:** decide how actual A/B/C joint angles and tool normal will be commanded and verified. G68.2 alone does not choose or move rotaries. G43.4 chooses primary kinematics for the tool-offset operation, not a general proof of collision-free orientation.
4. **Tool length/TCP:** document which kinematics type and tool offset are active; prove that the machine-specific inverse kinematics produces the intended tool tip and orientation. Do not use the rendered plane rectangle as physical proof.
5. **Offsets:** apply the exact `tool + G5x + RotZ·(G92 + O + R·(G52 + program))` chain. Do not treat `g68_offset` after G52 as the original G68.2 entry.
6. **Restarts:** cancel with G69 and clear plane-local G52 before changing fixture datum or defining a replacement plane. Retain=1 survives some M2/abort cases but **not** controller restart or all read-ahead mismatches. Avoid blindly resuming mid-plane after abort.
7. **Validation:** compare canonical endpoints, Task status, HAL relative position and the *actual* independent axis feedback under a qualified isolated simulation; no personnel-safety authorization follows from the G-code preview.

## Bounded verification ladder (not executed here)
- **A — interpreter**: run existing upstream `tests/interp/g68-frame` at exact pinned development revision; capture command, stdout, stderr, exit, source SHA and diff to expected. Contrast stable parser on minimal G68.2 only if qualified isolated build exists.
- **B — read-ahead/abort**: run existing `tests/workplane-retain` with both INI settings; capture Task `g68_active`, G5x and effective origin before/after each phase. Compare *actual* outputs to upstream expected; do not call expected files observed results.
- **C — math/status**: in isolated simulator, check two predeclared fixture XYZ targets, status effective origin `(12,16,33)`, and halui relative XYZ under G52. If any upstream fixture fails, stop and diagnose version/config before inventing new tests.
- **D — kinematics**: only if a real machine configuration with inspectable rotary/TCP mapping is available, verify that programmed plane normal and physical tool normal agree in a disconnected digital twin; keep hardware out of scope.

**Execution:** only qualified isolated `[self-hosted, openpressbrake]` Actions runner if needed. Never hosted runners; no physical machine, no workflow dispatched in this session. Preserve stdout/stderr, job timestamps and authoritative runtime in LAB_COMPUTE_LOG only when a job actually executes.

## Fresh-AI diagnostic exercise
A GUI reports `g68_active=1`, `g68_offset=(12,16,33)`, while the CAM file defines `G68.2 ... X10 Y20 Z30`. Is the status corrupt? **Not necessarily.** First check whether G52 X2 Y3 Z4 was issued in an X90 plane: its rotated local shift is (2,-4,3). Explain why the status is an *effective* frame and why neither this status nor a plane preview proves tool-axis alignment.

## Deferred / promotion
Physical kinematics solution, tool-center-point accuracy, rotary limits and collision geometry remain machine-specific UNKNOWN. Existing upstream tests reduce duplicate test-design work but do not count as a run here. Preserve independent personnel-safety authority. This is 4000 implementation knowledge transferred to the closed 3100/3500 subjects; it does **not** reopen their graduation.
