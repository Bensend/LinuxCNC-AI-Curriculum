# 4000-LC-HOMING-26 — Index-enable IO ownership across motion and HostMot2 encoder

**Session continuation:** 2026-10-31T05:40:07Z. **Status:** SOURCE-CONFIRMED static stable/development control-flow comparison; NON-GRADUATED; no HAL scheduling runtime or physical index measurement. Related [HOMING-24](4400_LINUXCNC_HOMING_24_ABSOLUTE_ENCODER_REHOME_OFFSET_REGRESSION_SOURCE_TEST_AUDIT_2026-10-31.md), [HOMING-25](4400_LINUXCNC_HOMING_25_BOUNDED_SEARCH_RETURN_GANTRY_ABORT_SOURCE_TEST_AUDIT_2026-10-31.md) and prior [SPINDLE-22](4400_LINUXCNC_SPINDLE_22_MULTISPINDLE_ATSPEED_INDEX_HANDSHAKE_SOURCE_AUDIT_2026-10-31.md).

## Precise question

When `HOME_USE_INDEX=YES`, which side owns `joint.N.index-enable`, which side clears it, and does LinuxCNC treat the pin as a persistent output or an IO handshake? Does HAL `addf` order affect when the state machine sees an index event?

## Pinned source inventory

- Development LinuxCNC [24e84c4506b41634240f7087f0295e361a954886 `src/emc/motion/control.c`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/motion/control.c), blob `7c9a35c237ba05326372294587c33d53aff1a6a9`, `emcmotController` ~212–287: `read_homing_in_pins` → `process_inputs` → `do_homing` → `output_to_hal` → `write_homing_out_pins`.
- Development [`homing.c`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/motion/homing.c), blob `adec003afe19a0ea0eae3c565c9d4bb708a0a5e6`: `base_make_joint_home_pins` ~324–338, `base_read_homing_in_pins` ~614–623, `base_write_homing_out_pins` ~625–657, `HOME_INDEX_ONLY_START` ~1274–1313, `HOME_INDEX_SEARCH_WAIT` ~1329–1347, `HOME_SET_INDEX_POSITION` ~1349–1375.
- Stable [v2.9.10 `homing.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/homing.c), blob `13f74f43a1169606e87c7bd8d48f44a2cad6fa74`, `base_read_homing_in_pins` ~529–538, `base_write_homing_out_pins` ~540–551.
- Development [`src/hal/drivers/mesa-hostmot2/encoder.c`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/drivers/mesa-hostmot2/encoder.c), blob `4ed8ad05e22405c8221d31d624d56e637dfefe19`, `hm2_encoder_update_control_register` ~50–83, HAL pin declaration ~573–583, `hm2_encoder_instance_update_rawcounts_and_handle_index` ~783–834.
- [Official homing configuration](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/config/ini-homing.adoc) describes `HOME_USE_INDEX`, `HOME_INDEX_NO_ENCODER_RESET` and joint/encoder index-enable wiring. Source must be used for exact scheduling and state.

## End-to-end servo and FPGA handshake

1. The motion controller calls `read_homing_in_pins` at the beginning of its servo cycle, reading the current `joint.N.index-enable` HAL **IO** value into `H[N].index_enable`.
2. In index-only or switch-then-index homing, the state machine sets `H[N].index_enable=1` and starts or continues the latch-speed move. The state `HOME_INDEX_SEARCH_WAIT` remains active while that flag is nonzero.
3. Near the end of the motion controller call, `write_homing_out_pins` publishes the arm request to the shared HAL IO signal. In development, it writes **only on internal rising/falling edges** (tracked by `index_enable_prev`); this deliberately avoids clamping an encoder-cleared IO signal every servo cycle.
4. HostMot2 encoder TRAM write preparation reads `encoder.N.index-enable`; when true, it requests FPGA `HM2_ENCODER_LATCH_ON_INDEX`. HostMot2's read processing observes the index-latch flag clearing, optionally resets the encoder zero offset (unless `no-clear-on-index`), and **writes HAL `encoder.N.index-enable=0`**.
5. On the next motion read that observes the cleared HAL IO signal, `HOME_INDEX_SEARCH_WAIT` stops the free planner and advances to `HOME_SET_INDEX_POSITION`. This stage updates `motor_offset`, `pos_fb`, `pos_cmd` and `free_tp.curr_pos` based on whether the encoder actually reset on index.

**SOURCE-CONFIRMED:** motion's state machine uses the **encoder driver's clearing of the shared IO bit** as its event acknowledgement. It does not independently receive the FPGA's timestamp or test an extra phase-Z edge.

## Stable/development IO-write difference

In stable v2.9.10, `base_write_homing_out_pins` assigns `*addr->index_enable = H[jno].index_enable` **on every servo call**. Development's implementation writes only when `H.index_enable` changes relative to `index_enable_prev`, explicitly commenting that the encoder also owns and clears the IO bit. Under normal single-thread HAL ordering, the motion read can observe a prior encoder clear and then publish zero; that does not establish a stable failure. **INFERENCE:** edge-only publication is less likely to overwrite an independently cleared IO bit between the motion read and write; whether such an interleaving occurs on a particular configuration is UNKNOWN.

HAL `addf` order matters: with `hm2.read` before motion, the new encoder event can be consumed by motion in that iteration; with motion before `hm2.read`, motion may see the prior IO value until the next iteration. The actual latency depends on FPGA latching, driver read/write split, realtime schedule and transport. **No measured cycle count is asserted** for a real Mesa machine.

## Encoder-reset consistency

HostMot2's `no-clear-on-index` pin controls whether its zero-offset counter is reset when an index latch arrives. LinuxCNC's `HOME_INDEX_NO_ENCODER_RESET` flag changes the joint coordinate correction in `HOME_SET_INDEX_POSITION`. These must describe the same behavior: if the encoder does not reset but LinuxCNC assumes it did (or vice versa), the machine coordinate origin can be wrong even when `index-enable` successfully clears. The bit clearing is a **handshake**, not a calibration certificate.

The HostMot2 control register gives index latching precedence over optional probe latching while index-enable is active. This matters for integrations that try to use the same encoder for both functions; it does not mean a G38 probe automatically participates in homing.

## Practical falsifiers and pending checks

- On a verified isolated simulation or Mesa test environment, record a full `addf` list and `joint.N.index-enable`/encoder IO state before arming, after arming, on index and after clearing. Separate `hm2.read`, motion, and `hm2.write` timing; avoid treating userspace HAL polling as an atomic servo trace.
- Verify `HOME_INDEX_NO_ENCODER_RESET` and `hm2.encoder.N.no-clear-on-index` agree with the chosen feedback implementation; test both counter-reset and no-reset paths in a software fixture before any machine motion.
- A source revision where motion no longer reads the shared IO bit as its event acknowledgement, or a trace where the bit clears but the controller remains in `HOME_INDEX_SEARCH_WAIT` indefinitely with no other faults, would require re-investigation.

**Evidence:** read/write order, edge-only development output, stable every-cycle output, HostMot2 index-clear and coordinate update SOURCE-CONFIRMED; exact physical timing, packet freshness, missed index, actual reset alignment UNKNOWN; TEST-CONFIRMED none. Independent personnel-safety authority remains separate. No workflow, build, physical operation, hosted/self-hosted Actions compute or evaluator.
