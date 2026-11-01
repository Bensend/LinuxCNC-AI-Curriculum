# 3100 / 3200 / 4000 practical guide — LinuxCNC G10 tool calibration and CAM-post preflight

**Audience:** mill/lathe integrators, probing and tool-setting implementers, CAM post authors. **Status:** source-grounded implementation walkthrough, **not** a graduated module, executed test, physical calibration recipe, or safety authorization. LinuxCNC stable v2.9.10 `86cdca76fa2a36274c432caa21952b23c267989a` versus development `06864e23559e70463fc7112d5ce77138bcbc288c`. Read [TOOL-113](../research/4400_LINUXCNC_TOOL_113_G10_L10_L11_FIXTURE_G92_TLO_VERSION_SOURCE_AUDIT_2026-11-01.md) and [TOOL-114](../research/4400_LINUXCNC_TOOL_114_G10_Q_NEGATIVE_ORIENTATION_DUPLICATE_WORD_SOURCE_AUDIT_2026-11-01.md) before changing a machine.

## 1. Three distinct tool-table operations

| Command | Reference for specified axis values | What is changed |
|---|---|---|
| `G10 L1 Pn Z...` | Explicit stored offset in current program units | Stored tool-table entry; not a tool setter |
| `G10 L10 Pn Z...` | Current position in active G5x + G52/G92 context | Computes stored offset so a later G43 makes the current coordinate equal requested Z |
| `G10 L11 Pn Z...` | Fixed G59.3 fixture as if G52/G92 were inactive | Computes stored offset against the designated tool-setting datum |

`G10 L10` and `L11` do not magically measure tool length; they use whatever physical position and offsets the controller currently believes. Confirm the probe or setter position separately. `G59.3` must be established and validated before using L11. The command may update the loaded tool's stored `#5403`, but the **applied** offset `#5083` changes on G43 reload. Inspect [upstream documentation](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/docs/src/gcode/g-code.adoc) and [interpreter implementation](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/rs274ngc/interp_convert.cc).

## 2. Source-to-runtime boundary diagram

`G10 L10/L11` → `check_g_codes` (G10 L/P) → `convert_modal_0` → `convert_setup_tool` (G59.3/current fixture, G52/G92, current TLO, optional XY rotation) → `SET_TOOL_TABLE_ENTRY` → Task `EMC_TOOL_SET_OFFSET` → IO tool table / synchronization. Later `G43` → `convert_tool_length_offset` → `USE_TOOL_LENGTH_OFFSET` → motion transform.

**Do not collapse stored tool geometry, applied motion offset, actual encoder position, and verified physical tool tip into one signal.** A successful interpreter return does not establish a physical touch-off.

## 3. Minimal disconnected G-code probes (NOT RUN)

Requires a disposable sim tool table with valid P1, a known G59.3 datum, and a deliberate frozen coordinate/offset state. **Never run these on a production controller or with a live tool table.** Use one fresh fixture per case and inspect outputs; do not run L10 then L11 in sequence and compare as though the starting state were identical.

```ngc
(illustrative L10 fixture; set up initial offsets in disconnected sim)
G21 G90 G40
T1 M6
G43 H1
G10 L10 P1 Z1
(verify stored #5403 and tool-table P1; compare applied #5083)
G43 H1
(verify applied #5083 changed only after explicit reload)
M2
```

```ngc
(illustrative alternative L11 fixture, from a freshly reset state)
G21 G90 G40
T1 M6
G43 H1
G10 L11 P1 Z1
G43 H1
M2
```

**Important:** The T1/M6/G43 example is valid only for a simulator with a functioning tool-change setup; use an upstream isolated interpreter fixture if the sim has no M6. This guide intentionally does not invent a complete machine configuration.

Predeclared numeric oracle for a *synthetic interpreter state*, not the two G-code snippets alone: current Z7, active G52/G92 Z3, active G54 origin Z20, active TLO Z5, G59.3 origin Z30, requested Z1 → L10 stored Z11; L11 stored Z4. [Arithmetic and full state assumptions](../research/4400_LINUXCNC_TOOL_113_G10_L10_L11_FIXTURE_G92_TLO_VERSION_SOURCE_AUDIT_2026-11-01.md).

## 4. Version and Q-word compatibility gates

- Stable v2.9.10 has no native G68.2. Development explicitly **rejects L10/L11 while G68.2 is active**. Cancel the plane with G69 and verify its status before tool calibration; do not silently assume rotary alignment or fixture status.
- Lathe Q orientation is documented as integer 0–9. Both inspected parser versions can accept negative Q values, and a first Q<=−1 can bypass the duplicate-Q detector. The inspected G18 lathe `latheorigin_x/z` source only adjusts for orientations 1–8, so Q-2 would skip those origin-shift branches if it reaches cutter compensation; physical geometry is not tested. **Postprocessor contract: exactly one Q if present; integer 0..9; otherwise omit.**
- For automated tool setters, do not rely solely on a G-code wait, successful G10, or a GUI coordinate display as a physical contact or tool clamp witness. Personnel safety and qualified machine permissives remain independent.

## 5. Prefer the existing upstream tests

At pinned development revision `06864e23559e70463fc7112d5ce77138bcbc288c`, run the existing [L1/L10 test](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/tests/interp/g10/g10-l1-l10/test.ngc) and [L11/G92 test](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/tests/interp/g10/g10-l11/test.ngc) in their original `tests/interp/g10/` directories with their original `test.tbl`, `test.sh` and `expected`. Do not treat an expected file as an observed test run. L11's upstream expected result repeats Z=-3/-4 after G92; L10's expected results include -0.707107/-0.707107 under 45-degree rotation and show why G43 reload matters. The test input blobs are identical between stable and development, but full expected logs differ in surrounding tool-change commands, so use the **matching revision's expected file**; both preserve the L11 -3/-4 results. These upstream cases use G20 inches, unlike our separate synthetic mm arithmetic. The additional Q-negative cases are **not** covered by those two fixtures.

## 6. Focused verification ladder

1. **Read-only provenance:** record `linuxcnc --version`, interpreter commit, current units, active G5x/G52/G92, G59.3 fixture, G43/G49 state, tool P and table backup; read the official `g-code.adoc`, `interp_convert.cc`, `interp_find.cc`.
2. **Disconnected arithmetic:** with identical frozen initial states, compare L10/L11 stored offset and applied `#5083` before/after G43. Capture actual outputs, stderr, exit status, timestamp and authoritative job runtime.
3. **G68 branch:** on development, check G68.2 active L11 rejection and G69 then L11 acceptance; on stable, establish native G68.2 unavailability without conflating a remap.
4. **Q validation:** use a disposable P1 entry and the five [TOOL-114 cases](../research/4400_LINUXCNC_TOOL_114_G10_Q_NEGATIVE_ORIENTATION_DUPLICATE_WORD_SOURCE_AUDIT_2026-11-01.md). Distinguish parser acceptance from default IO `tooldata_put/tooldata_save` source path, actual file-save success, and optional external tool-database behavior.
5. **Independent acceptance:** if physical tool setting is later authorized by the machine owner, verify with independent measured geometry and machine-specific release gates; this curriculum does not authorize it.

All cases **NOT RUN**. Qualified execution only on isolated `[self-hosted, openpressbrake]` compute; never a GitHub-hosted Actions runner. If qualified compute is unavailable, rotate to a distinct LinuxCNC source topic.

## 7. Fresh-AI transfer check (unscored)

A lathe post emits `G10 L11 P7 Z0 Q-2 Q3` while G52 is active and the operator believes tool 7 is being measured against G54. Explain which fixture L11 uses, why the post should reject the Q sequence even if LinuxCNC accepts it, which two parameters distinguish stored versus applied TLO, and what must be independently verified before a tool is used. Do not reveal a sealed evaluator answer or score this exercise as blind evidence.

**Checkpoint:** [next work](../checkpoints/20261101T114000Z-4000-linuxcnc-g10-tool-table-next.md).
