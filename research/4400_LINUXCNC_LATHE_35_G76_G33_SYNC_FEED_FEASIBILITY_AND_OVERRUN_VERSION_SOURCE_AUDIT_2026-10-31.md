# 4400-LC-LATHE-35 — G76/G33 synchronized-feed feasibility and overrun: stable versus development

**Status:** 4000 source-level 3200 lathe transfer, NON-GRADUATED, SOURCE-CONFIRMED static. Inspected 2026-10-31. No LinuxCNC execution or physical threading test.

## Pinned versions

Stable [v2.9.10 interp_convert.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc), blob f01a359652d588d59c9e210fa441a99d2ee19598; [interp_check.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_check.cc), blob ee5164c895dd6610826b8621f64660c90de70233; [tp.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c), blob 5768d6e6880569f72156ed9a761b5eee531c9fcf.

Development immutable commit [24e84c4506b41634240f7087f0295e361a954886](https://github.com/LinuxCNC/linuxcnc/commit/24e84c4506b41634240f7087f0295e361a954886): [interp_check.cc](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/rs274ngc/interp_check.cc), blob b2c8bfc80b8e35f8acca3f2dfa535249a47a1712; [interp_convert.cc](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/rs274ngc/interp_convert.cc), blob 379b21eaba65840ce4160e7ea70df60c12fad9ff; [tp.c](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/tp/tp.c), blob 2b4024c9ab131f708cc22760300231878c9b0fdc; [tp_types.h](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/tp/tp_types.h), blob 610f629fbcb456cd0aeecdf7389a874ef4ffe715; [control.c](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/motion/control.c), blob 7c9a35c237ba05326372294587c33d53aff1a6a9.

**Question:** If programmed spindle RPM × pitch requires faster axis motion than configured limits, is G76/G33 rejected, silently clamped, or diagnosed during motion? The answer materially depends on version.

## Development interpreter preflight

Development `Interp::check_spindle_sync_feed` calculates worst-case selected-spindle RPM from programmed speed. In G96 CSS it considers the smallest cutting radius and available G96 D and spindle INI RPM caps. It computes the non-rotary path length, required feed `abs(pitch) × RPM` in program units/min, projects that feed onto each participating linear axis, and checks `GET_EXTERNAL_AXIS_MAX_VELOCITY(ax)`. A projected rate **strictly greater** than the limit raises a G-code error naming the code, axis, pitch, spindle speed and rates.

The check skips when programmed speed <= 0, pitch = 0, path length = 0, or a relevant external axis limit is unavailable/nonpositive. These are source-confirmed limits of the preflight, not guarantees of feasible motion. `convert_straight` invokes it for G33 and G33.1. G76 checks the plain Z pass and separately the entry/exit taper vector using `taper_pitch = pitch × hypot(taper_dist, thread_height) / taper_dist`, with the tightest cutting radius estimated for CSS.

**Hypothetical discriminator, not executed:** metric Z-only P2 mm/rev, S900 RPM, Z maximum 20 mm/s (1200 mm/min) demands 1800 mm/min (30 mm/s). Development should reject if the configured speed/axis limits are visible to the interpreter. Stable v2.9.10 has no `check_spindle_sync_feed` implementation in inspected `interp_check.cc`, and its G76 conversion lacks this preflight call. Do not claim stable rejects for the same reason.

## Development realtime overrun

Development `tp.c` `tpSyncOverrun` records a spindle number and excess speed in motion status, once per synchronized move. `tp_types.h` defines `TP_SYNC_OVERRUN_WINDOW=0.25` s, `TP_SYNC_OVERRUN_MARGIN=1.02`, `TP_SYNC_OVERRUN_CEILING=0.99`. During synchronization ramp-up, sustained target demand >102% of segment max after >0.25 s can report overrun. During tracking, spindle revolutions are accumulated over a window while the segment runs near its ceiling, and demand >102% of max triggers the report. The design avoids reacting to single encoder-quantized cycles; brief overruns are not guaranteed to be detected.

Development `src/emc/motion/control.c` consumes `syncOverrunSpindle` after `tpRunCycle`, calls `tpAbort`, reports “spindle-synchronized move exceeds axis limits,” clears the status field and sets the motion error flag. This is more than a passive warning. The planner can have lost pitch before detecting it; this does not prove physical thread quality or personnel-safety shutdown.

Stable v2.9.10 inspected `tp.c` has neither `tpSyncOverrun` nor `TP_SYNC_OVERRUN_WINDOW`. Do not transfer development preflight or runtime diagnostics to stable 2.9.10.

## Additional G76 geometry

Stable and development convert `I,J,K` from diameter to radius internally in G7 mode; require J>0, K>J and I≠0. Depths follow `abs(I) + abs(J) × pass^(1/R)` with R clamped to at least 1. The final full-depth pass is executed once plus H spring passes. Development uses a `TINY` margin to avoid an extra near-full-depth pass on x87 extended precision. The [upstream example nc_files/g76.ngc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/nc_files/g76.ngc) documents pitch, offsets, degression and taper, but is not a runtime test.

## Adversarial cases (not executed)

| Scenario | Source-derived expectation | Unresolved |
|---|---|---|
| P2 S900 Z max 1200 mm/min | development interpreter rejects if limits/speed known; stable lacks this guard | actual installed limit and spindle response |
| Programmed speed zero or unavailable | development preflight skips | subsequent physical RPM |
| CSS near X center | development uses worst-case RPM with available caps | installed cap and spindle dynamics |
| G76 E taper | development separately checks X/Z taper demand | real geometry/feedback |
| Sustained demand >102% while near max | development reports overrun; motion abort/error | partial cut already made and latency |
| 100 ms speed surge | 0.25 s window does not guarantee detection | actual dynamics |

**Transfer lesson:** “The G-code parsed” does not establish that a synchronized move can maintain pitch. Check per-axis feed feasibility, actual spindle encoder integrity and runtime synchronization. No build, simulation, machine, evaluator, workflow or Actions compute. Graduated levels and independent safety gates unchanged.
