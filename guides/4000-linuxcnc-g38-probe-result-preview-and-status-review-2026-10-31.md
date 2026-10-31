# 4000 practical review — LinuxCNC G38 result, Task completion and preview

**Source-pinned guide; not a machine-ready probing macro.** Read [PROBE-15](../research/4400_LINUXCNC_PROBE_15_G383_G385_ALREADY_TARGET_STATE_RESULT_SOURCE_AUDIT_2026-10-31.md) and [PROBE-16](../research/4400_LINUXCNC_PROBE_16_TASK_VERDICT_BARRIER_PREVIEW_AND_POSITION_SOURCE_VERSION_AUDIT_2026-10-31.md) first. LinuxCNC stable **v2.9.10** differs from inspected October 2026 development source.

## Before a probing recipe is trusted

1. Inspect the actual `motion.probe-input` HAL net and **input polarity** at rest, during contact, and after release. Check any dbounce/filter and HAL function order. A GUI indicator is not an independent contact witness.
2. Check that the **initial** input state is opposite the target for the selected G38 variant. G38.3 and G38.5 do **not** reject an already-in-target state in the inspected source; `#5070=1` alone is not proof of a new edge.
3. After a no-error probe, **branch on `#5070` before consuming `#5061–#5069`** for offsets, tool length, surface location, or automatic follow-up moves. A failed probe still records an end-of-travel feedback position.
4. Keep an independent probe-result log: command/revision, start input, end input, target, `#5070`, `#506x`, machine/feedback position, active work/tool offsets, and the source of each observation. Do not infer a numeric metrology uncertainty without measured latency and calibration.
5. Treat the Task/servo result barrier as **version-sensitive**. v2.9.10 can classify motion DONE when queue=0 and in-position while `probing` is still true; development added `!probing`, controller-heartbeat, and failed-status-read guards in October 2026. Upstream [#3650](https://github.com/LinuxCNC/linuxcnc/issues/3650) is a field report, not a guaranteed reproducer on your machine.
6. Treat Axis preview as a **different interpreter context**. Its probe-success stub returns 0; the official G-code overview confirms preview `#5070` always fails. Compare preview and actual Task paths rather than altering production logic to satisfy the preview.

## Source-only scenario checks (not runnable machine commands)

| Situation | Expected source-level interpretation | Required handling |
|---|---|---|
| Input already TRUE; G38.3 begins | Success may be reported on the level alone | Reject recipe start unless a real new edge/geometry is independently established |
| Input stays FALSE through G38.3 end | No-error failure, `#5070=0`; feedback position still stored | Do not set offsets from `#506x` |
| G38.2 ends without contact | Motion error and Task abort path | Inspect error/status; do not expect normal next-line branch |
| Preview `if [#5070]` differs from Task | Preview uses a fixed zero stub | Review both branches; do not treat preview as a live probe result |
| Encoder latch pin connected to same probe signal | Separate encoder-latch path exists | Inspect `encoder.*.latch-position` and capture timing separately; `#506x` is not automatically that latch |

## Configuration contrast

The pinned upstream [servo simulation HAL](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/lib/hallib/servo_sim.hal#L270-L285) routes `sphereprobe.probe-out` to both `motion.probe-input` and encoder latch inputs. That **does not** mean LinuxCNC's G38 result reads the encoder's latched position. The pinned [GladeVCP Mesa example](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/gui/gladevcp-panels.adoc#L58-L65) includes a `dbounce.probe` stage, whose timing depends on the actual thread and input waveform. Neither example certifies a physical machine.

**Evidence limit:** static source/documentation and upstream maintainer changes, no new runtime or physical validation. Normal LinuxCNC motion/probing is not a personnel-safety system. Existing independent safety gates remain HOLD.
