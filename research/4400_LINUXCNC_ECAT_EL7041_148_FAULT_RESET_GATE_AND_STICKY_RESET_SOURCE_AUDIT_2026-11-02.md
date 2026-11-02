# ECAT-EL7041-148 — EL7041 synthetic fault mask and sticky/reset-cancel behavior

**2026-11-02 | 4000 LinuxCNC implementation, 3100/3400 stepper commissioning | NON-GRADUATED | SOURCE-ONLY.**

## Why this is distinct

Read mandatory curriculum governance and [current checkpoint](../checkpoints/20261102T0440Z-4000-linuxcnc-el7041-next.md); full PROGRESS, lab and lesson predecessor scans found no `fault_reset_retry`, `srv-fault` or EL7041 reset trace. [MOTION-144](4400_LINUXCNC_MOTION_144_AMP_FAULT_REENABLE_ONE_SERVO_ENABLE_PULSE_SOURCE_AUDIT_2026-11-02.md) addresses **core LinuxCNC** joint amplifier-fault enable gating, not this **out-of-tree EtherCAT driver**'s generated status and reset outputs. [ECAT-12](4400_LINUXCNC_ETHERCAT_12_SYNC_UNIT_FRESHNESS_LATE_OUTPUTS_SOURCE_AUDIT_2026-10-30.md) addresses bus image freshness, not the driver's reset state machine. No hardware or test execution is inferred.

## Pinned source

Maintained [linuxcnc-ethercat commit 56515f4](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/commit/56515f4aac313551346289d9c227193f50e9602a), published **2026-10-29T03:20:29Z**; [`src/devices/lcec_el7041.c`](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/src/devices/lcec_el7041.c), blob `75d5428695085be053837c27220b81a6740ec835`, lines **223–264** (`srv-fault`, `srv-fault-reset`, `srv-error`, `srv-reset` pins), **592–598** (state initialization), **603–612** (operational early return), **642–655** (raw drive error → internal fault), **683–702** (retry counter and synthetic HAL fault), **724–741** (enable rising-edge reset arm), **804–830** (manual/auto reset and PDO publication). The driver defines `fault` as a **separate HAL_OUT** from raw `dcm_error`; it is not an independent drive diagnostic.

## Three different signals, not one truth

- `srv-error` is copied from the EtherCAT `0x6010:04` drive error status on operational reads. `internal_fault = srv-error` (line 654).
- `srv-fault` is **synthetic**: while `fault_reset_retry > 0`, the read callback writes FALSE to `srv-fault` **even when `srv-error` remains TRUE**. Once retry count reaches zero, the *next* read publishes the raw internal fault.
- `srv-reset` is an **output command** to EtherCAT `0x7010:02`. `srv-fault-reset` is a HAL input/request that the driver itself clears; neither proves that a physical drive accepted reset.

## Frozen source-derived cycle oracle

Assume a **successful operational read before each write**, no communication loss, a persistent `0x6010:04=1`, initially disabled `srv-enable=0`, `last_dcm_enable=0`, `fault_reset_retry=0`, `fault_reset_cycle=0`, `fault_reset_state=0`, and no manual fault-reset request. On the rising enable write, lines 733–741 set retry=1, state=1, cycle=0 and assert `srv-reset`. Subsequent operational read/write pairs yield:

| Step | retry after read | state after read | cycle after read | HAL srv-error | HAL srv-fault | srv-reset after following write |
|---|---:|---:|---:|---:|---:|---:|
| enable-rising write (prior read already showed fault) | 1 (set by write) | 1 | 0 | 1 | 1 (prior sample) | 1 |
| read/write #1 | 1 | 1 | 1 | 1 | **0** | 1 |
| read/write #2 | 1 | 0 | 0 | 1 | **0** | 1 (not cleared) |
| read/write #3 | 1 | 0 | 1 | 1 | **0** | 1 (not cleared) |
| read/write #4 | 0 | 1 | 0 | 1 | **0** | 0 (enable branch clears) |
| read/write #5 | 0 | 1 | 0 | 1 | **1** | 0 |

**Key detail:** the reset-state bit toggles FALSE at read #2, but the write function does **not** clear `dcm_reset` in the `retry>0 && state==0` branch. Therefore the commanded reset remains asserted across that nominal off phase. The four-read fault mask is **callback-count**, not a fixed wall-time guarantee; real timing, PDO freshness and drive acceptance remain UNKNOWN. If the drive error clears earlier, the read function sets retry=0 and the sequence differs.

## Manual reset has a separate asymmetry

With `retry=0`, a TRUE `srv-fault-reset` sets `dcm_reset=1` first (lines 804–807). The immediately following `else` clears `dcm_reset=0` **if `srv-enable=1`**, and always clears the input request. Thus an isolated manual reset request while enabled produces **no asserted reset PDO** in that callback. Conversely, while disabled the `else` does **not** clear `dcm_reset`; a single request can leave the reset PDO TRUE on later writes after the HAL request has self-cleared, until some other path clears it (e.g. enable TRUE with retry=0). This is a source-level command-state property, not evidence of drive response.

## Implementation consequences and frozen tests

A hypothetical HAL link `lcec.0.X.srv-fault → joint.N.amp-fault-in` would carry a synthetic, transiently masked fault. Do **not** claim such a link is present on a specific machine or that LinuxCNC physically enables a faulty motor; [MOTION-144](4400_LINUXCNC_MOTION_144_AMP_FAULT_REENABLE_ONE_SERVO_ENABLE_PULSE_SOURCE_AUDIT_2026-11-02.md) is a distinct core-motion concern. For a fake-PDO test, freeze cases (1) persistent raw error + rising enable (table above), (2) error clears during retry, (3) manual reset while enabled and retry=0, (4) manual reset while disabled and retry=0, then re-enable, (5) non-operational read (outputs stale). Capture `srv-error`, `srv-fault`, `srv-reset`, `srv-fault-reset`, retry/state/cycle and raw PDO each callback. Any correction must choose explicit reset pulse semantics and keep raw diagnostic vs retry-in-progress separate; no unreviewed patch.

**SOURCE-CONFIRMED:** read/write branches, synthetic fault suppression, sticky reset command, manual-reset clear ordering. **INFERENCE:** table under stated callback ordering, possible HAL integration effects. **TEST-CONFIRMED none. UNKNOWN:** actual drive, firmware, reset acceptance, machine wiring and physical motion. No build/HAL/EtherCAT/machine/evaluator/Actions; hosted/self-hosted 0/0 min. Independent safety remains authoritative.

[Practical guide](../guides/3100-3400-4000-linuxcnc-ethercat-el7041-sdo-and-encoder-status-commissioning-2026-11-02.md) · [Checkpoint](../checkpoints/20261102T0440Z-4000-linuxcnc-el7041-next.md).
