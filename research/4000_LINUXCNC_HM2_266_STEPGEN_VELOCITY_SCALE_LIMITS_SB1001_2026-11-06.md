# HM2-266 — Mesa HostMot2 stepgen velocity mode, scaling and timing: SB1001 worked case (4000, 2026-11-06)

**Status:** SOURCE/CONFIG-CONFIRMED for inspected revisions; **NOT EXECUTED / NON-GRADUATED**. No physical motion, build, simulator or GitHub Actions run.

## Provenance and scope
- LinuxCNC **v2.9.10** `src/hal/drivers/mesa-hostmot2/stepgen.c`, Git blob **`8eb43d9a7d8e42573ef653cb82460609d2864ae4`** ([immutable tag view](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/stepgen.c)); inspected lines 40–120, 130–340, 331–355, and selected parameter-export symbols near 1043–1075.
- Public SB1001 example, **kentavv/kvvcreates** commit `d7c083e9a78e70a67d34068ac4fc39745c7944b5`: nested [selected HAL](https://github.com/kentavv/kvvcreates/blob/d7c083e9a78e70a67d34068ac4fc39745c7944b5/linuxcnc/configs/sb1001_lathe/mesa/configs/my_LinuxCNC_machine/my_LinuxCNC_machine.hal), blob `4278606c5d65510291c60230d4176e040397c65a`; [INI](https://github.com/kentavv/kvvcreates/blob/d7c083e9a78e70a67d34068ac4fc39745c7944b5/linuxcnc/configs/sb1001_lathe/mesa/configs/my_LinuxCNC_machine/my_LinuxCNC_machine.ini), blob `bc293509da3681d5f22ef9b5d6e51dbceff2aac7`. Example machine's actual installed LinuxCNC version is **UNKNOWN**. This is a cross-version integration reading, not a claim of measured compatibility.

## What the driver actually does
1. **Read phase** (`hm2_stepgen_process_tram_read`, lines 40–120): obtains FPGA 16.16 accumulator, unwraps delta, adds to host-side `subcounts`, then reports `position-fb = (subcounts/65536.0)/position-scale`. The fractional 16 bits retain substep resolution. It is **generated-step feedback**, not motor shaft encoder feedback. A scale magnitude below `1e-6` is replaced with sign-preserving ±1 and logged.
2. **Control phase** (`hm2_stepgen_instance_prepare_tram_write`, lines 245–328): `control-type == 0` uses the built-in position controller with position-command difference feedforward and position-error correction. **Any nonzero control-type** selects the HAL `velocity-cmd` path. In velocity mode the driver optionally clamps change from `velocity-fb` by `maxaccel * servo_period`, then clamps absolute requested velocity by the lesser of configured nonzero `maxvel` and pulse-timing physical limit. `maxaccel=0` disables the stepgen's acceleration limiter; `maxvel=0` means use the physical maximum, **not stop**. Negative maxvel/maxaccel are made positive with an error log. `velocity-fb` is assigned the **new commanded/clamped velocity**, not independently measured motor speed.
3. **Rate conversion** (lines 320–326): `steps_per_second = new_vel * position_scale`; signed 32-bit step-rate is encoded using `2^32 / stepgen_clock_frequency`. Negative position scale reverses direction for positive machine-coordinate velocity. Register quantization and clock rate limit exact physical output.
4. **Disable path** (`hm2_stepgen_prepare_tram_write`, lines 331–342): when enable is false, step-rate register is zero, `old_position_cmd` is synchronized to current position command, and velocity-fb is zero. It does **not** prove immediate motor stop under a communications fault; actual FPGA watchdog and drive enable wiring remain separate.
5. **Pulse timing** (lines 260–285, 350–390): for `steplen + stepspace > 0`, the source computes `physical_maxvel = (1e9/(steplen_ns+stepspace_ns))/abs(position_scale)`. Step timing parameters are converted to FPGA clock ticks and may be clipped to register bounds. Do not interpret an INI motion `MAX_VELOCITY` as the same parameter as HostMot2 `stepgen.maxvel`.

## Concrete SB1001 wiring: the crucial distinction
The selected HAL loads `hm2_eth` with **five** stepgens, schedules Mesa read before motion and Mesa write after control, and sets stepgen **00 (X)** and **01 (Z)** to `control-type 1`. Joint motor position command is fed to the external servo/PID control path; `x-output`/`z-output` go to the stepgen's **velocity-cmd**, while stepgen generated-step `position-fb` returns to joint motor feedback. Thus the **HostMot2 internal position controller is bypassed** for these axes. To explain following error or tuning, inspect the external PID and its position-command/feedback nets; do not attribute their position loop to stepgen.c.

The selected INI configures a **1,000,000 ns (1 ms)** servo period. X: `STEP_SCALE=-25400` steps/unit, `STEPLEN=2500 ns`, `STEPSPACE=2500 ns`, `STEPGEN_MAXVEL=3.125` units/s, `STEPGEN_MAXACCEL=37.50` units/s². Z: `STEP_SCALE=-20320`, same pulse timing, `STEPGEN_MAXVEL=8.334`, `STEPGEN_MAXACCEL=37.50`. Unit identity depends on the INI trajectory units; do not silently assert mm without checking.

### Offline numeric fixture (arithmetic derived from source, NOT run on FPGA)
- Both axes: minimum step period = 5000 ns, theoretical pulse ceiling **200,000 steps/s**.
- X physical ceiling = 200000/25400 = **7.87401575 units/s**. Configured maxvel **3.125** is lower, so effective driver limit **3.125**; magnitude of requested rate at that limit = **79,375 steps/s**. For +3.125 machine units/s with negative scale, signed step-rate is negative.
- Z physical ceiling = 200000/20320 = **9.84251969 units/s**. Configured maxvel **8.334** is lower; rate magnitude at configured max = **169,346.88 steps/s**.
- At a nominal 1 ms cycle and a previous `velocity-fb=0`, `maxaccel=37.5` bounds the first positive requested output to **0.0375 units/s** (before maxvel). It takes at least `ceil(3.125/0.0375)=84` nominal X servo increments to reach 3.125 if the command stays high and there are no other constraints. This is **not** a measured motor acceleration profile.
- With `maxvel=0`, the cap becomes the computed physical ceiling; with `maxaccel=0`, the optional rate-change clamp is bypassed. Neither zero means "zero motion."

## Reproducible inspection and diagnostic worksheet
```sh
git show v2.9.10:src/hal/drivers/mesa-hostmot2/stepgen.c | sed -n '40,120p;245,342p'
# At the pinned public SB1001 commit, use the *nested* selected HAL/INI:
grep -nE 'stepgen\.(00|01)\.(control-type|position-scale|maxvel|maxaccel|velocity-cmd|position-fb)|addf hm2' my_LinuxCNC_machine.hal
grep -nE 'STEP_SCALE|STEPLEN|STEPSPACE|STEPGEN_MAX|SERVO_PERIOD' my_LinuxCNC_machine.ini
# On a separately authorized nonmoving test configuration only:
halcmd show param '*stepgen*maxvel*'
halcmd show pin '*stepgen*velocity*'
```

**Frozen predictions (not independently executed):** (A) requesting X 10 units/s with maxvel 3.125 clamps driver velocity-fb to 3.125 after its accel ramp; (B) changing maxvel to 0 removes the configured 3.125 cap but not the ~7.874 physical ceiling; (C) with enable false the next prepared TRAM step-rate is zero; (D) positive commanded X velocity produces negative signed step-rate due to negative scale; (E) `position-fb` can advance while a motor is mechanically stalled, because it is based on generated-step accumulator; (F) an invalid near-zero scale is reset during the read phase and should log a warning. Hardware observations, real following error, and packet loss are **UNKNOWN**.

## Boundary and next questions
- `velocity-fb` here is **post-limiter command echo**, not independently measured velocity. Generated-step `position-fb` is also not encoder feedback. This is a diagnostic distinction with consequences for stall detection and following-error interpretation.
- Need source-level follow-up on **external PID wiring and the exact joint motor feedback path** in SB1001, plus source inspection of HostMot2 write timing/stepgen enable behavior during Ethernet `io_error` and FPGA watchdog bite. Avoid repeating the already-closed Ethernet packet counter work.
- Independent personnel safety remains outside LinuxCNC/HAL authority. Do not test moving machinery from this worksheet. No evaluation gate is advanced and no new compute job is justified by this source-only exercise.
