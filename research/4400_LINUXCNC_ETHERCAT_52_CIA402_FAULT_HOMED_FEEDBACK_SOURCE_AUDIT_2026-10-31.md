# 4000-LC-ETHERCAT-52 — CiA402 drive fault, homed latch and feedback: source-level state oracles

**2026-10-31 | NON-GRADUATED | SOURCE-CONFIRMED conditional state transitions; TEST-CONFIRMED none.** Continues [ETHERCAT-51](4400_LINUXCNC_ETHERCAT_51_CNC3_VS_2026_CSP_CONFIG_HOMING_DC_SOURCE_AUDIT_2026-10-31.md) and distinguishes raw drive state from exported HAL status and joint state.

## Immutable sources

Maintained [`src/cia402.c`](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/src/cia402.c), commit `56515f4aac313551346289d9c227193f50e9602a` (2026-10-29), blob `cc8b1bd34ff4b86888d2f8f998432c3fa36e291e`, `read_all` ~380–450 and `write_all` ~452–522. Original [`dbraun1981/hal-cia402/cia402.comp`](https://github.com/dbraun1981/hal-cia402/blob/e772757686a0fbee476b3d03c060e5cc9ee90e27/cia402.comp), 2021-03-13, blob `9588e5feb08abf6d830c004bac36b812e75abffd`, `read_all/write_all` ~197–307. Maintained [CiA402 documentation](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/documentation/cia402.md) calls support young/incomplete.

## F1 — `stat-fault` and `drv-fault` do not mean the same thing

`read_all` decodes raw statusword bit 3 as `stat-fault`, but `drv-fault = stat_fault && enable` **only when** `auto_fault_reset_delay <= 0` (~443–449). While the timer is positive, `drv-fault` is forcibly zero. `write_all` on an existing fault and an enable rising edge with default `auto-fault-reset=1` requests controlword bit 7 and starts `FAULT_AUTORESET_DELAY_NS=100000000` (~464–477). The original 2021 component has the same masking semantics (~240–269): **not a new 2026 regression**.

At 1 ms, a faulted drive with enable rising may show `stat-fault=1` and `drv-fault=0` for a nominal 100 ms following the reset request; if the drive remains faulted, the fault output can reassert afterward. With `enable=0`, `drv-fault=0` even if the raw fault bit is 1. The generated 2026 HAL routes **only `drv-fault`** to `joint.N.amp-fault-in` (HAL lines 31/48/65). Therefore a low amplifier-fault pin is not proof of a fault-free drive. The reset request does not prove successful recovery; test raw bit3, controlword, timer and eventual fault visibility independently.

## F2 — `stat-homed` is a mode-scoped retained value

`read_all` updates `stat-homed` and `stat-homing` only when `opmode_display==6` (homing mode), with `stat-homed = bit10 && bit12` (~436–441). When the mode changes to CSP (8), the component **does not overwrite** those pins, even if statusword bits change. The 2021 source has the same conditional update (~234–237).

**Falsifiable source prediction:** homing-mode read with bits 10 and 12 high produces `stat-homed=1`; next CSP-mode read with statusword=0 leaves `stat-homed=1`, while raw status bits update. This is a conditional stale-level hazard for any consumer interpreting `custom-homing-finished` as a fresh completion, **not** evidence a physical joint was erroneously homed. In `write_all`, the `home` IO request is cleared only on a *new rising* `stat-homed` while `opmode_homing` is true (~502–507). A previously retained high is not itself a new completion edge. Separate this from the stock Home All `HOME_SEQUENCE` exclusion documented in [HOMING-27](4400_LINUXCNC_HOMING_27_HOME_ALL_JOINT0_NO_REHOME_AND_UNSEQUENCED_JOINT_SOURCE_AUDIT_2026-10-31.md).

## F3 — internal homing motion and joint feedback require a real contract

Maintained `read_all` always derives `pos-fb` from 0x6064 actual position, scaled by `pos-scale` (~385–406); the generated HAL wires it directly to `joint.N.motor-pos-fb`, independently of `joint.N.motor-pos-cmd` → `cia402.N.pos-cmd`. During drive-internal homing, measured position can change without an equivalent LinuxCNC motor command. The **installed** custom homemod must define how that movement, following error and coordinate origin are handled. The generated INI sets `FERROR=MIN_FERROR=1000` for all joints (INI 68–69,85–86,102–103); this demonstration threshold must not be copied as a validated production limit.

The 2021 component directly converted signed 32-bit actual position. The 2026 C port accumulates modular signed deltas into a 64-bit position accumulator and writes target positions modulo 2^32 (source ~388–402, ~495–498), a real wrap-handling improvement. This assumes no >half-range jump between observations; it is **not** an absolute encoder integrity check. The maintained port also changes idle controlword from 0x0004 to 0x0000 and fixes the original unreachable CSV mode (file header and `write_all`). Do not mix an older installed `cia402.comp` with assumptions from the new C port.

## F4 — custom homemod is not bundled by this generated INI

The generator requires external `cia402_homecomp`; one community [example](https://github.com/rodw-au/cia402_homecomp/blob/cc793980e20506d3695a917712b18078de557a9c/cia402_homecomp.comp) at commit `cc793980e20506d3695a917712b18078de557a9c` hardcodes `HOMING_BASE=/home/rod/devt/linuxcnc-dev/src/emc/motion/homing.c` (~47), includes version-sensitive motion internals and defines its own state machine (~195–310). Its [README](https://github.com/rodw-au/cia402_homecomp/blob/cc793980e20506d3695a917712b18078de557a9c/README.md) calls it a first draft. **No evidence establishes that this exact example is the installed binary, builds unchanged for LinuxCNC 2.9.8, or overrides Home All exclusions.** Pin ownership, mode transitions and homing-state semantics require explicit versioned verification.

## Frozen source-derived predictions, NOT RUN

| Case | Stimulus | Expected discriminator |
|---|---|---|
| C1 | fault bit3=1, enable=0 | `stat-fault=1`, `drv-fault=0` |
| C2 | fault=1, enable rising, auto-reset=1 | controlword bit7 request, nominal 100 ms `drv-fault` mask |
| C3 | fault persists after mask with enable=1 | `drv-fault` becomes 1 |
| C4 | homing bit10+12=1 then CSP mode with bits cleared | `stat-homed` stays high until another homing-mode update |
| C5 | home asserted while `stat-homed` already high | no automatic clear without new rising homed edge in homing mode |
| C6 | drive 0x6064 moves while motor command fixed | `pos-fb` moves; joint following-error outcome depends on homemod |
| C7 | 0x6064 crosses signed boundary with small delta | new C port unwrapped position continuous; old .comp discontinuous |

These are **SOURCE-CONFIRMED conditional mechanisms**, not executed tests. Retain raw HAL/status trace and installed binary hashes on a qualified disconnected self-hosted fixture. See [acceptance guide](../guides/4000-linuxcnc-ethercat-cia402-config-bringup-acceptance-2026-10-31.md). No safety-function or hardware performance claim.
