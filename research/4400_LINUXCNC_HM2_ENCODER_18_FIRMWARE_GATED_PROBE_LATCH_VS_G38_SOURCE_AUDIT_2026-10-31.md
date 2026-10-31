# 4000-LC-HM2-ENCODER-18 — HostMot2 firmware-gated probe latch is not LinuxCNC G38

**2026-10-31 | LinuxCNC-first 4000 HostMot2/FPGA integration | NON-GRADUATED | static source and official manpage only.** Follows [software encoder ENCODER-17](4400_LINUXCNC_ENCODER_17_SOFTWARE_LATCH_DOC_CONFLICT_AND_G38_METROLOGY_BOUNDARY_2026-10-31.md) and [Task/servo G38 PROBE-16](4400_LINUXCNC_PROBE_16_TASK_VERDICT_BARRIER_PREVIEW_AND_POSITION_SOURCE_VERSION_AUDIT_2026-10-31.md).

## Question
Can a Mesa/HostMot2 encoder latch its count on a probe event in the FPGA, and what firmware, HAL and command preconditions distinguish that from the ordinary G38 `motion.probe-input` servo result and software `encoder.c` latch?

## Exact revisions and authority
- LinuxCNC development commit [`24e84c4506b41634240f7087f0295e361a954886`](https://github.com/LinuxCNC/linuxcnc/tree/24e84c4506b41634240f7087f0295e361a954886): [`src/hal/drivers/mesa-hostmot2/encoder.c`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/drivers/mesa-hostmot2/encoder.c), blob `4ed8ad05e22405c8221d31d624d56e637dfefe19`; [`hostmot2.h`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/drivers/mesa-hostmot2/hostmot2.h#L263-L296), blob `89850f312b97daccb0eaa0e64ff5d2f3f1324cc7`.
- Stable **v2.9.10** [`encoder.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/encoder.c), blob `9719d41419da9220761637e002024cdc9d17a8ba`, independently contains `firmware_supports_probe`, `probe-enable`/`probe-invert`, and the `HM2_ENCODER_LATCH_ON_PROBE` path. Do not extrapolate to every firmware image or board.
- Official [`hostmot2(9)` encoder section](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/man/man9/hostmot2.9.adoc#L303-L415), blob `da9f56a494f345fc1920878ace5729d80377e7dd`: `probe-enable` and `probe-invert` exist **only if firmware supports them**; `position-latched` and `count-latched` describe the encoder latch result. This is **DOC-CONFIRMED** and agrees with inspected source.

## Source-confirmed state path
1. **Firmware capability is explicit, not implied by card model:** `hm2_encoder_parse_md` around lines 325–354 sets `firmware_supports_probe=1` only for recognized **Encoder descriptor version 0x83** or **Muxed Encoder version 0x84**. Otherwise it remains zero, so `probe-enable` and `probe-invert` HAL pins are not created (lines 587–603). Presence of a Mesa board or ordinary encoder is not proof of this feature.
2. **Arm/priority:** `hm2_encoder_update_control_register` lines 50–90 sets `HM2_ENCODER_LATCH_ON_INDEX` when `index-enable` is true, but sets `HM2_ENCODER_LATCH_ON_PROBE` only when **`!index_enable && probe-enable`**. Index takes priority if both requests are asserted. `HM2_ENCODER_INDEX_JUSTONCE` is set for either arm. `probe-invert` selects probe edge polarity; manpage says **TRUE rising**, **FALSE falling**. These are firmware/driver controls, not a G38 instruction.
3. **Event/result:** `hm2_encoder_instance_update_rawcounts_and_handle_index` lines 810–852 checks whether the FPGA's latched control bit cleared. For probe mode it extracts a 16-bit latched count from the latch/control register, extends it relative to prior accumulated rawcounts, updates `rawlatch`, and **clears the HAL `probe-enable` pin**. Index mode may additionally update the zero offset, subject to `no_clear_on_index`; probe mode does not zero the encoder in this branch. `hm2_encoder_instance_update_position` around lines 915–925 publishes `count-latched` and `position-latched` after zero-offset/scale conversion.
4. **Distinct clocks:** HostMot2 [manpage lines 383–404](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/man/man9/hostmot2.9.adoc#L383-L404) describes an encoder timestamp clock for velocity estimation and a separate DPLL `timer-number` controlling when **periodic counts are sampled** relative to host reads. Neither statement establishes that G38 `#506x` reads a timestamped FPGA probe latch. The probe latch here captures **FPGA encoder count on its probe event**; exact event-to-input electrical path, synchronizer/filter, register read delay and metrological error require firmware/board-specific evidence.
5. **No automatic G38 coupling:** `src/emc/motion/control.c::process_probe_inputs` uses `motion.probe-input` and `carte_pos_fb`, while HostMot2 `probe-enable` arms an encoder hardware latch. Merely enabling G38 does **not** arm `hm2_*.encoder.NN.probe-enable` in these inspected paths, and the HostMot2 latch does **not** automatically replace `#5061–#5069`. An application wishing to correlate both needs an explicit, validated signal/arming and data-capture design.

## Three-way comparison

| Path | Event source | Captured value | Output | Important caveat |
|---|---|---|---|---|
| G38 Task/motion | HAL `motion.probe-input` sampled in servo | `carte_pos_fb` at verdict | `#5061–#5069`, `#5070` | No fresh edge required for no-error G38.3/G38.5 (PROBE-15); version-sensitive Task completion |
| Software `loadrt encoder` | HAL `latch-input` edge sampled by `encoder.update-counters` | Software `raw_counts` at sampled edge | `encoder.*.position-latched` | Faster thread can still miss events; multiple edges before capture can overwrite |
| HostMot2 encoder | Firmware probe/index latch, **if descriptor supports it** | FPGA latched encoder count | `hm2_*.encoder.NN.count-latched` / `position-latched` | Explicit arm, polarity and index priority; not automatically tied to G38 or a selected machine |

## Review questions before use
- Which exact HostMot2 firmware module descriptor and FPGA pin assignment is installed? Does `probe-enable` actually exist in `halcmd show pin`?
- Is the desired probe edge rising or falling at the FPGA, and is the same physical signal separately routed to `motion.probe-input`? Do not infer routing from similar pin names.
- Is `index-enable` active concurrently, masking the probe latch? Was `probe-enable` armed **before** the edge and did it auto-clear afterward?
- Are `count-latched`, `position-latched`, `#506x`, `#5070`, and encoder scale/zero offsets recorded with their distinct update times?
- Is the board/firmware electrical/filter/latency performance documented or measured? No numerical accuracy, event jitter or guaranteed sample rate is established here.

**Evidence:** SOURCE-CONFIRMED firmware gate, HAL export, arm priority, event detection and count publication in stable/development; DOC-CONFIRMED official pin semantics; **UNKNOWN** installed firmware, wiring, electrical event timing, metrology uncertainty, exact OpenPressBrake machine; TEST-CONFIRMED none. No workflow, simulation, build, synthesis, physical test or machine motion; zero hosted/self-hosted compute. Independent safety remains outside normal LinuxCNC/FPGA. Existing G0/G1 HOLD unchanged.

**Next:** select a **real, inspectable** Mesa machine HAL+INI with a supported encoder probe input, or inspect exact firmware HDL only if a consequential timing question remains. Otherwise rotate to a new LinuxCNC-first source topic; do not manufacture a lab to restate the documented control bits.
