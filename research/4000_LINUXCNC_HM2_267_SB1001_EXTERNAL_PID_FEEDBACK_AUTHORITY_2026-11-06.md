# HM2-267 — SB1001 X/Z external PID, generated-step feedback and following-error authority (4000, 2026-11-06)

**Evidence:** SOURCE/CONFIG-CONFIRMED on explicitly pinned snapshots; numeric examples are derived, **NOT EXECUTED / NON-GRADUATED**. No machine, build, simulation, Actions or lab compute.

## Provenance
- LinuxCNC v2.9.10 `src/hal/components/pid.c` blob `2dc0b776be315b7c5cd71b980c3540dcaf1dd051`: `do_pid_calcs` around lines 510–669, pin exports around 701–752. [Source](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/components/pid.c).
- LinuxCNC v2.9.10 `src/emc/motion/control.c` blob `b6e45d590c7d11030654d8f7d13d118f581b6439`: servo cycle 250–270, joint feedback and following error 436–489. [Source](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/control.c).
- Public SB1001 `kentavv/kvvcreates` commit `d7c083e9a78e70a67d34068ac4fc39745c7944b5`, nested `linuxcnc/configs/sb1001_lathe/mesa/configs/my_LinuxCNC_machine/`: [HAL](https://github.com/kentavv/kvvcreates/blob/d7c083e9a78e70a67d34068ac4fc39745c7944b5/linuxcnc/configs/sb1001_lathe/mesa/configs/my_LinuxCNC_machine/my_LinuxCNC_machine.hal) blob `4278606c5d65510291c60230d4176e040397c65a`, [INI](https://github.com/kentavv/kvvcreates/blob/d7c083e9a78e70a67d34068ac4fc39745c7944b5/linuxcnc/configs/sb1001_lathe/mesa/configs/my_LinuxCNC_machine/my_LinuxCNC_machine.ini) blob `bc293509da3681d5f22ef9b5d6e51dbceff2aac7`.
- HM2-266 pinned stepgen source `stepgen.c` blob `8eb43d9a7d8e42573ef653cb82460609d2864ae4`. Example installed LinuxCNC revision UNKNOWN: cross-version source/config study, not compatibility test.

## Complete X/Z control graph (HAL lines 143–181 and 193–231)
```text
joint.0.motor-pos-cmd [OUT] -> x-pos-cmd -> pid.x.command [IN]
hm2_7i76e.0.stepgen.00.position-fb [OUT] -> x-pos-fb
     -> pid.x.feedback [IN] AND joint.0.motor-pos-fb [IN]
joint.0.amp-enable-out [OUT] -> x-enable
     -> pid.x.enable [IN] AND stepgen.00.enable [IN]
pid.x.output [OUT] -> x-output -> stepgen.00.velocity-cmd [IN]
joint.0.vel-cmd [OUT] -> x-vel-cmd (net exists; no direct PID command-deriv connection in selected HAL lines)
```
Z repeats identically with joint.1, pid.z, stepgen.01. The selected HAL sets both `control-type=1` (stepgen velocity mode). PID is an **external position-to-velocity controller**; stepgen generates pulses. The two consumers of `x-pos-fb` are not two independent sensors. A stalled stepper can continue reporting generated-step feedback if FPGA continues issuing steps.

## Servo ordering and implications
HAL schedules `hm2_7i76e.0.read` at line 38, `motion-command-handler` line 85, `motion-controller` line 86, `pid.x` and `pid.z.do-pid-calcs` lines 87–88, and `hm2_7i76e.0.write` line 101. Therefore motion consumes the latest available *reported stepgen* feedback, publishes joint command, PID computes velocity from that command and same feedback, and HostMot2 prepares/writes the velocity command later in the servo period. This ordering does not guarantee fresh FPGA data on a failed Ethernet read (HM2-262) or a physical motor response.

The selected INI explicitly declares `[TRAJ] LINEAR_UNITS = inch` (line 92), correcting HM2-266's open unit question: X/Z units here are **inches**, and `STEP_SCALE=-25400/-20320` are steps/inch. The 4 mm and 5 mm screw pitch comments support the scale arithmetic, not independent physical calibration.

## PID behavior and two limits that must not be conflated
- INI X/Z: `P=1000`, `I=D=FF0=FF2=0`, `FF1=1`, `BIAS=DEADBAND=MAX_OUTPUT=0`; HAL `error-previous-target=true` and `maxerror=.0005` for both.
- `pid.c` first computes raw error using **previous command** minus current feedback when `error-previous-target` is enabled and no index-enable falling transition occurred; it publishes this *raw* value to `pid.x.error` before limiting the error used in the P/I/D calculation to ±0.0005 inch. The index transition temporarily uses current command instead and suppresses derivative refresh. The FF1 term uses calculated command derivative. With no explicit command-deriv net in the selected HAL, this derivative is internally calculated.
- `MAX_OUTPUT=0` means PID output clamp disabled (source checks `!=0`), **not** a zero-velocity command. HostMot2 stepgen still enforces its separate maxvel and maxaccel limits. `pid.x.saturated` indicates PID's own output limiter, so it need not assert when stepgen velocity clamps downstream.
- Motion `control.c` computes joint feedback from `joint.N.motor-pos-fb` minus backlash compensation and motor offset (except index-homing special case), then `ferror = pos_cmd - pos_fb`. Threshold is `max(MIN_FERROR, FERROR*abs(joint.vel_cmd)/joint.vel_limit)`, with strict `>` trip comparison. It is an error against *generated-step position*, not a physical encoder/stall check.

## Falsifiable nonmoving arithmetic worksheet
Assume no compensation, no index transition, steady commanded position, generated-step feedback lagging command by 0.001 inch, and zero command derivative. Then raw PID error is 0.001 inch, internal P error clips to 0.0005 inch, P output = **0.5 inch/s**. A 1 ms nominal stepgen acceleration increment from rest is at most **0.0375 inch/s**. Motion's X `MIN_FERROR=0.05` inch and `FERROR=0.5` inch: at zero joint commanded velocity the motion threshold is **0.05 inch**. A 0.001-inch reported-step lag does not trip it; a 0.051-inch reported-step lag does. These are different detectors with different limits.

At 1 inch/s commanded X motion, `vel_limit=2.5` inch/s yields a threshold of `max(0.05, 0.5*1/2.5)=0.2` inch. At precisely 0.2 inch reported error the strict comparison does **not** assert; at 0.201 inch it does. None of these thresholds detect a physical stall if generated steps continue and software feedback tracks command.

**Predictions for a separately authorized, nonmoving/simulation-only diagnostic** (not executed):
1. `halcmd show pin 'pid.x.*'`, `halcmd show pin 'joint.0.*'`, `halcmd show pin 'hm2_7i76e.0.stepgen.00.*'` expose the relevant pins when this configuration is actually loaded.
2. `halcmd show sig x-pos-fb` has exactly one HAL output source (stepgen position-fb) and two input consumers (PID feedback and joint motor feedback), absent modifications in supplemental HAL files.
3. `pid.x.error` may display >0.0005 inch while the proportional calculation is clipped to ±0.0005; inspect `pid.c` for raw-before-clamp ordering.
4. PID `saturated` may remain false while stepgen `velocity-fb` is below PID `output` due to stepgen limiting.
5. A mechanically stalled stepper may produce no LinuxCNC following error **if** generated-step feedback continues tracking command. This is a causal prediction, **not** a hardware test.

## Reproduce source inspection without hardware
```sh
git show v2.9.10:src/hal/components/pid.c | sed -n '510,585p;643,680p'
git show v2.9.10:src/emc/motion/control.c | sed -n '436,490p'
grep -nE 'motor-pos-(cmd|fb)|pid\.(x|z)|stepgen\.0[01]|addf (motion-controller|hm2_7i76e.0.(read|write))' my_LinuxCNC_machine.hal
grep -nE 'LINEAR_UNITS|FERROR|MIN_FERROR|MAX_VELOCITY|STEP_SCALE|MAX_OUTPUT|FF1' my_LinuxCNC_machine.ini
```

## Evidence boundary and next checkpoint
**SOURCE/CONFIG-CONFIRMED:** named pins and read→motion→PID→write ordering, position loop vs pulse generation, raw PID error vs limited P contribution, following-error arithmetic. **INFERENCE:** a stall can be invisible without independent motor position feedback. **UNKNOWN:** supplemental HAL files may modify other signals; actual installed LinuxCNC version, actual drive behavior, pulse loss, PID tuning quality, watchdog response, physical accuracy. Do not use LinuxCNC following-error monitoring as independent personnel-safety authority. No change to graduation, blind-evaluation, physical authorization or safety gates. Next: inspect the selected supplemental HAL for alternative feedback and source-level `pid.c` derivative timing, or rotate to a new machine-specific implementation question if diminishing returns.
