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


## Software encoder latch documentation conflict (ENCODER-17)

The upstream [`encoder.c` source](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/components/encoder.c#L383-L434) **does** implement `latch-input` edge capture in the fast `encoder.update-counters` software HAL function, and publishes `counts-latched`/`position-latched` in the slower `encoder.capture-position` function. The [man9 page](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/man/man9/encoder.9.adoc#L120-L135) describes it, while [`rtcomps.adoc`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/hal/rtcomps.adoc#L326-L349) incorrectly calls those pins “Not used at this time.” This is **not** proof of a hardware/FPGA-timestamped latch. A repeated edge before the slower capture may replace the earlier buffered count. See [full source audit](../research/4400_LINUXCNC_ENCODER_17_SOFTWARE_LATCH_DOC_CONFLICT_AND_G38_METROLOGY_BOUNDARY_2026-10-31.md). Verify the actual component/driver and thread schedule before comparing these values with G38 `#506x`.


## HostMot2 FPGA encoder probe latch is a third, firmware-gated path (HM2-ENCODER-18)

The [HostMot2 driver](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/drivers/mesa-hostmot2/encoder.c#L50-L90) exposes `hm2_*.encoder.NN.probe-enable` and `probe-invert` **only when** the recognized firmware module descriptor supports probe latching (Encoder 0x83 or Muxed Encoder 0x84). `index-enable` takes priority over probe latching when both are asserted; the FPGA-reported event clears `probe-enable` and publishes a latched encoder count/position. The official [hostmot2(9) manpage](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/man/man9/hostmot2.9.adoc#L303-L415) documents the conditional pins. **This is distinct from** the software `loadrt encoder` latch and from G38's servo `#506x`. G38 does not automatically arm or read the FPGA latch. Check actual firmware capability, pin routing, edge polarity, index priority, scaling and timestamp/latency evidence before designing a probing measurement. [Full source audit](../research/4400_LINUXCNC_HM2_ENCODER_18_FIRMWARE_GATED_PROBE_LATCH_VS_G38_SOURCE_AUDIT_2026-10-31.md).
