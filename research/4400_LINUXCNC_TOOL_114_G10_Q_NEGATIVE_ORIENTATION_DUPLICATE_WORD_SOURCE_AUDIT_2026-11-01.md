# TOOL-114 — G10 Q negative orientation and duplicate-Q sentinel behavior

**Status:** 4000 interpreter/tool-table source audit; 3200 lathe and CAM-post transfer; NON-GRADUATED. **Versions:** stable v2.9.10 peeled `86cdca76fa2a36274c432caa21952b23c267989a` and development `06864e23559e70463fc7112d5ce77138bcbc288c`. **SOURCE-CONFIRMED** parser/converter branches; **DOC/SOURCE-CONFLICT** accepted negative orientation; **TEST-CONFIRMED none**. Inspected 2026-11-01.

## New question and novelty

The prior curriculum studied G76 validation, cutter compensation, M70 modal restore and M6 tool-changing, but the full historical `PROGRESS.md` search found no `read_q`, `MULTIPLE_Q_WORDS`, G10 L10/L11, or negative tool-orientation audit. This is not a rebranding of those mechanisms. What happens if a lathe CAM post emits `Q-1`, `Q-2`, or a duplicate Q word on a G10 tool-table update?

## Primary sources and trace

- Official [tool-table format](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/docs/src/gcode/tool-compensation.adoc) specifies **Q orientation integer 0–9** for lathe tools.
- Both [stable `interp_read.cc::read_q`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_read.cc) and [development `read_q`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/rs274ngc/interp_read.cc) reject a repeated Q only if `block->q_number > -1.0`, then accept any real Q from `read_real_value`. The source explicitly comments that an older negative-Q check was removed for user-defined codes.
- Both [`interp_convert.cc::convert_setup_tool`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_convert.cc) and [development converter](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/rs274ngc/interp_convert.cc) use `if (block->q_number != -1.0)` to decide whether to update orientation. Inside that branch, `is_near_int` enforces integerness and `CHKS(q > 9)` enforces only the upper bound. **There is no `q < 0` guard in this inspected path.**
- [`interp_check.cc::check_g_codes`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_check.cc) validates G10 L/P, not negative Q. [`SET_TOOL_TABLE_ENTRY`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/task/emccanon.cc) enqueues the orientation field in the tool-set-offset message. The default **stable** [`ioControl.cc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/iotask/ioControl.cc) and `ioControl_v2.cc` accept the orientation field without an additional 0–9 check, call `tooldata_put`, and attempt `tooldata_save`. The **development** [`Task::emcToolSetOffset`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/task/taskclass.cc) performs the same direct put/save. [`tooldata_common.cc::tooldata_format_toolline`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/tooldata/tooldata_common.cc) formats nonzero negative orientation as `Q-2` when saving a normal tool table. The same [tooldata loader](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/tooldata/tooldata_common.cc) parses Q with `sscanf(..., "%d", &orientation)` and no 0–9 validation before `tooldata_put`; a successfully saved `Q-2` can therefore also be reloaded from a file-backed table in the inspected source path. This strengthens the **SOURCE-CONFIRMED conditional propagation/persistence** finding; actual IO execution, file-save success, external tool database behavior and restart observation are still NOT RUN/UNKNOWN.

## Four predeclared parser/converter discriminators

Assume tool P1 exists, no cutter compensation, and otherwise valid G10 L1 context. Each case starts with a fresh interpreter state.

| G-code | Source-derived prediction | Evidence class |
|---|---|---|
| `G10 L1 P1 Q4` | Q4 accepted and stored as orientation 4 in interpreter/tool message | SOURCE-CONFIRMED |
| `G10 L1 P1 Q-1` | `q_flag` set but Q=-1 sentinel causes **no orientation update**; no-effect guard is bypassed because Q is present | SOURCE-CONFIRMED |
| `G10 L1 P1 Q-2` | Integer -2 passes `q>9` check and is placed in interpreter/tool message despite documented 0–9 range | DOC/SOURCE-CONFLICT |
| `G10 L1 P1 Q-2 Q4` | First Q=-2 does not trip `q_number>-1` on the second read; second Q4 replaces it, rather than producing expected duplicate-word error | SOURCE-CONFIRMED conditional |

Control: `G10 L1 P1 Q4 Q5` **does** trigger the multiple-Q error because the first Q4 is >−1. The duplicate-Q check is shared by G-code blocks generally, but downstream behavior must be assessed per command; **do not generalize a specific G10 result to all Q-using G-codes without further tracing**. These are source predictions; none were executed.

## Downstream lathe compensation consumer

Both [stable `interp_queue.cc::latheorigin_x/z`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_queue.cc) and [development equivalents](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/rs274ngc/interp_queue.cc) apply nose-radius origin corrections only for explicit orientation codes 1–8 in G18/XZ. An orientation of -2 matches none of those cases, so these particular X/Z origin shifts are skipped. [`convert_cutter_compensation`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_convert.cc) reads orientation from the tool table; its non-G18 check does not reject -2 when the active plane is G18. This establishes a **conditional SOURCE-CONFIRMED compensation-path difference**, not a proven wrong physical cut; other geometry and machine state must be verified.

## Why it matters

A postprocessor may assume every duplicate Q is rejected and every negative lathe orientation is invalid. The inspected parser violates both assumptions for these inputs. This could make malformed CAM output silently change the selected orientation or propagate an out-of-range value into the default IO tool table and attempted file save. Actual file-save success, external database behavior, complete lathe compensation geometry, GUI display and physical machining effects are **UNKNOWN**, not proven faults. In [cutter compensation conversion](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_convert.cc) orientation is later read from the tool table; do not claim it is harmless merely because the tool-table write was acknowledged.

## Practical boundary

For a G10 tool calibration post, require exactly one Q when present, integer `0 <= Q <= 9`; omit Q entirely when unchanged. Reject `Q-1`, negative Q, and duplicate Q **before** sending G-code. Treat a source-accepted malformed value as an error in the post, not an acceptable controller feature. For L10/L11, also verify the P tool identity and active coordinate-system contract.

## Evidence and test checkpoint

Use an isolated interpreter with a disposable tool table containing P1. Capture parse result, errors, canonical tool-offset messages, persisted table, and tool-orientation readback for the five cases; pin binary to the inspected commit. If a later layer rejects Q-2, record that narrower boundary without retracting the parser finding. No real lathe or live tool table. **All cases NOT RUN.**

**Related:** [TOOL-113](4400_LINUXCNC_TOOL_113_G10_L10_L11_FIXTURE_G92_TLO_VERSION_SOURCE_AUDIT_2026-11-01.md), [practical guide](../guides/3100-3200-4000-linuxcnc-g10-tool-calibration-fixture-q-preflight-2026-11-01.md), [checkpoint](../checkpoints/20261101T114000Z-4000-linuxcnc-g10-tool-table-next.md).
