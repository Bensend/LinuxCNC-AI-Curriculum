# HM2-265 — SB1001 spindle index signal: PID observer versus motion/HostMot2 handshake (4000, 2026-11-06)

**Status:** CONFIG/SOURCE-CONFIRMED at pinned revisions, **NOT EXECUTED; NON-GRADUATED**. This closes the specific third-participant question from LATHE-246 and HM2-264 without claiming real threading accuracy.

## Provenance
- Public real-machine example [nested SB1001 HAL](https://github.com/kentavv/kvvcreates/blob/d7c083e9a78e70a67d34068ac4fc39745c7944b5/linuxcnc/configs/sb1001_lathe/mesa/configs/my_LinuxCNC_machine/my_LinuxCNC_machine.hal), blob `4278606c5d65510291c60230d4176e040397c65a`; [selected INI](https://github.com/kentavv/kvvcreates/blob/d7c083e9a78e70a67d34068ac4fc39745c7944b5/linuxcnc/configs/sb1001_lathe/mesa/configs/my_LinuxCNC_machine/my_LinuxCNC_machine.ini), blob `bc293509da3681d5f22ef9b5d6e51dbceff2aac7`. Retrieved again from immutable commit in this session. Parent-level similarly named HAL is **not** selected.
- [LinuxCNC v2.9.10 PID implementation](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/components/pid.c), blob `2dc0b776be315b7c5cd71b980c3540dcaf1dd051`, lines 231, 514–518, 586–606, 837–838.
- Prior pinned source chain: [LATHE-244](3200_LINUXCNC_LATHE_244_G33_G76_INDEX_HANDSHAKE_2026-11-05.md), [LATHE-245](3200_LINUXCNC_LATHE_245_TASK_SYNC_POSITION_PHASE_2026-11-05.md), [LATHE-246](3200_LINUXCNC_LATHE_246_SB1001_MESA_ENCODER_INDEX_AUDIT_2026-11-05.md), [LATHE-247](3200_LINUXCNC_LATHE_247_SB1001_FULL_HAL_COUNTER_MODE_2026-11-06.md), [HM2-263](4000_LINUXCNC_HM2_263_ENCODER_INDEX_LATCH_ACK_2026-11-06.md), [HM2-264](4000_LINUXCNC_HM2_264_JOINT_HOME_VS_SPINDLE_INDEX_2026-11-06.md).

## Specific implementation resolution
The selected HAL lines 254, 317 and the spindle-motion connection later in the same file put **three pins** on `spindle-index-enable`: `pid.s.index-enable`, `hm2_7i76e.0.encoder.00.index-enable`, and `spindle.0.index-enable`. They are **not three competing HAL_IO writers**. LinuxCNC PID exports `pid.s.index-enable` as **HAL_IN** (pid.c:837–838). The motion and HostMot2 pins are HAL_IO and implement the request/acknowledgment handshake. PID observes the same signal.

The PID observer has a subtle reason to exist. In pid.c:514–518, a detected **previous-high/current-low** index-enable transition overrides `error-previous-target` for that cycle and uses current command minus feedback, avoiding a false position error from an encoder reference jump. In pid.c:586–590, the same falling-edge condition **skips updating** internally computed command/feedback derivatives for that cycle. The previous index bit is then updated at line 606. The PID observer neither arms the FPGA latch nor clears the index request; it does not independently validate the physical index.

Important nuance: the SB1001's spindle PID is wired to **absolute RPM command and feedback** (HAL lines 255–257), not spindle revolution position. Thus this PID's index observer is structurally present but the encoder zero-offset change does not directly create an RPM position discontinuity in its feedback. The code's special treatment may be largely incidental in this speed-loop configuration; that is an inference, not a measured claim. `pid.s.error-previous-target true` (line 252) makes the error-selection branch relevant in principle. Do not claim that index necessarily resets the PID integral: pid.c shows integral reset on **disable**, not on index fall (lines 565–582).

## Real lathe / interpreter-to-motion boundary
Selected INI: `LATHE=1`, 1 ms nominal servo, `HOME_USE_INDEX=NO` for both X/Z joints, and `ENCODER_SCALE=1.0` for the spindle. Joint homing is therefore **not** configured to use index even though G33/G76 spindle synchronization uses its own index request. The HAL selects `hm2_eth` 7i76E, one encoder, counter-mode 1, and wires encoder position to `spindle.0.revs`, velocity to `spindle.0.speed-in`. Prior pinned interpreter/canonical/Task/motion/TP traces show G33/G76 position-synchronized segments request a spindle index; the HAL provides the required request/ack connection but **not proof of correct pulses/revolution, phase, direction, at-speed or successful threading**. The example's actual LinuxCNC version and spindle sensor topology remain unknown; applying v2.9.10 semantics to it is an integration hypothesis.

Servo order (selected HAL lines 38, 85–101): Mesa read → motion command handler → motion controller → `pid.s.do-pid-calcs` → near comparator → Mesa write. An index completion observed by Mesa read can be seen by motion and PID during that cycle; a new motion index request cannot be sent to the FPGA before the subsequent Mesa write. Exact hardware latency is unmeasured.

## Reproducible minimal source/config exercise (read-only)
```sh
git show v2.9.10:src/hal/components/pid.c | grep -n 'index.enable\|index_enable\|prev_ie'
git show v2.9.10:src/emc/motion/control.c | grep -n 'old_motion_index\|old_hal_index'
# At the pinned SB1001 commit, inspect selected nested HAL/INI:
grep -n 'spindle-index-enable\|pid.s.index-enable\|spindle.0.index-enable\|encoder.00.index-enable\|addf' my_LinuxCNC_machine.hal
grep -n 'HOME_USE_INDEX\|ENCODER_SCALE\|HALFILE\|SERVO_PERIOD' my_LinuxCNC_machine.ini
```

## Frozen, falsifiable diagnostic worksheet — NOT RUN
1. On index request high, PID index-enable should reflect high but **must not** drive the signal; inspect pin direction with `halcmd show pin`.
2. On HostMot2 acknowledgment high→low, PID should select current-command error rather than previous-command error for that cycle when `error-previous-target` is true.
3. On the same falling transition, PID internal derivative dummy outputs should retain their prior values for that cycle; this does not mean every derivative-related pin is frozen.
4. A no-index condition with spindle at-speed true must still hold a new position-synchronized G33 segment at the index gate.
5. `HOME_USE_INDEX=NO` on X/Z does not eliminate the spindle G33/G76 index requirement.
6. Wrong encoder counts/revolution or a gear-dependent pickup can yield incorrect thread pitch despite successful index acknowledgment.

**Evidence boundary:** no tests, simulation, hardware, builds, Actions or laboratory compute. Do not force linked HAL_IO values on a real machine. Preserve independent personnel safety and blind evaluator separation. Next: prioritize a fresh source-grounded 4000-series question (e.g. HostMot2 stepgen velocity/position scale and realtime write ordering) rather than repeat the already pinned G33 chain; runtime tests only with justified isolated `[self-hosted, openpressbrake]` compute.
