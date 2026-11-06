# HM2-264 — Joint homing and spindle index are separate motion handshakes (4000, 2026-11-06)

Status: **SOURCE-CONFIRMED v2.9.10, not executed, NON-GRADUATED.** This follows [HM2-263](4000_LINUXCNC_HM2_263_ENCODER_INDEX_LATCH_ACK_2026-11-06.md). No machine, simulator, evaluator, build or CI was run.

## Exact provenance

Inspected upstream LinuxCNC tag `v2.9.10` using GitHub repository reads on 2026-11-06:

- [homing.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/homing.c), blob `13f74f43a1169606e87c7bd8d48f44a2cad6fa74`.
- [control.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/control.c), blob `b6e45d590c7d11030654d8f7d13d118f581b6439`.
- [motion.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/motion.c), blob `febe7f3ff3f2b80e34b00a9e60d3cdb3e9e41841`.
- [HM2-263 encoder.c](4000_LINUXCNC_HM2_263_ENCODER_INDEX_LATCH_ACK_2026-11-06.md) records encoder driver blob `9719d41419da9220761637e002024cdc9d17a8ba`.

## Joint homing: concrete implementation

`homing.c:252-253` exports `joint.N.index-enable` as **HAL_IO**; comments at 133-134 state that motion sets the request and encoder clears it. `base_read_homing_in_pins` at 529-537 reads the encoder's current bit into the homing state, and `base_write_homing_out_pins` at 540-549 publishes the resulting bit. With `HOME_USE_INDEX`, switch-search paths reach `HOME_INDEX_SEARCH_START` (1041-1047 and 1098-1104). The index-only variant enters `HOME_INDEX_ONLY_START` when configured without switch search (809-815). Both set index-enable to 1 (1180-1185,1194-1199).

At `HOME_INDEX_SEARCH_WAIT` (1202-1220), **index-enable becoming zero** is the transition condition: motion disables free trajectory planning and advances to `HOME_SET_INDEX_POSITION`. The latter sets `motor_offset=-home_offset`, derives joint feedback from motor feedback and offset, and aligns command to feedback (1222-1232); `HOME_INDEX_NO_ENCODER_RESET` selects a separate internal-position adjustment (1234-1243). Then the final move is started (1245-1253). Thus *the index location* (`HOME_OFFSET`) and *the final parked home coordinate* (`HOME`) are different concepts.

`control.c:447-460` has an important index-transition exception: while the joint is waiting for index and the index-enable handshake has cleared, it temporarily sets `pos_fb=pos_cmd` rather than using possibly discontinuous motor encoder feedback; homing later reconciles the offset. This is a deliberate control-path exception, not evidence that the physical axis is at the desired home.

## Spindle index is NOT joint homing

`motion.c:707` separately exports `spindle.N.index-enable` as HAL_IO. `control.c:1979-1996` implements an **edge-sensitive two-way spindle handshake** using `old_motion_index` and `old_hal_index`: a new internal motion request asserts the HAL pin; a falling HAL pin after a prior high clears the internal request. That is not the same as `homing.c`'s `HOME_INDEX_SEARCH_WAIT` state transition, and a spindle index should not be connected to a joint homing index simply because both use the name `index-enable`.

The G33/G76 command-to-spindle-index request chain, exact spindle-at-speed gating and lathe-specific Mesa HAL/INI pin mapping **remain unverified in this lesson**. No claim that G33/G76 succeeds solely because index-enable toggles is warranted: encoder position scale, counts/rev, velocity feedback, spindle direction and motion synchronization also matter.

## Reproducible offline exercise

Read the four pinned sources and draw a two-column cycle trace. For a **joint**: (1) home switch/latch search reaches INDEX_SEARCH_START, (2) joint index-enable becomes 1, (3) HostMot2 write arms FPGA latch, (4) later HostMot2 read sees latch completion and clears the shared bit, (5) homing reads zero, stops search and sets offset, (6) final home move. For a **spindle**: (1) internal sync request rises, (2) spindle HAL index-enable rises, (3) encoder latch acknowledges by clearing HAL pin, (4) `old_hal_index` detects falling edge and clears internal request. Mark each edge as SOURCE-CONFIRMED vs timing INFERENCE.

Frozen discrimination cases (not run):

1. Joint bit stays high despite an index-input toggle: homing stays in INDEX_SEARCH_WAIT; check actual FPGA latch armed/readback, not just `input-idx`.
2. Joint bit clears during INDEX_SEARCH_WAIT: home state progresses, but absolute home correctness remains unproved.
3. `HOME_INDEX_NO_ENCODER_RESET` active: inspect internal motor-offset correction rather than assuming encoder zeroing.
4. Spindle HAL index-enable starts low without a preceding high: do not treat this as a newly acknowledged spindle sync request; inspect edge history.
5. Lost HostMot2 read delays index acknowledgment: check Ethernet io_error/read path and servo ordering before blaming the encoder.
6. Cross-wire joint and spindle index-enable: reject configuration; the two independent request owners can interfere.

For each case record servo thread function order, joint home-state, joint/spindle index-enable, Mesa encoder index-enable, rawcounts/position, `io_error`, and actual HAL net names. These are predictions and inspection criteria, **not test results**.

## Limits, next source dependency and safety boundary

The SB1001 7i76E lathe example referenced by LATHE-246/247 was **not fetched or independently revalidated in this session**; no pin names or HOME_USE_INDEX values are invented. Next: retrieve the exact SB1001 HAL/INI at its recorded revision, trace the G33/G76 → motion spindle sync request path and compare it to the distinct joint home path. If that example cannot be retrieved, use a pinned upstream lathe config and state the substitution. Do not dispatch hosted Actions; only justified isolated `[self-hosted, openpressbrake]` compute. Personnel safety remains independent of LinuxCNC homing and spindle sync.
