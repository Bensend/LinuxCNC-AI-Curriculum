# MOTION-196 — Pinned upstream Mesa encoder-servo implementation, 2026-11-03

**Course:** 4000 LinuxCNC implementation, NON-GRADUATED. **Status:** SOURCE-CONFIRMED configuration; TEST-CONFIRMED none. **Revision:** LinuxCNC `cdf957bd00bbcc4c569f01e7eed5b154422b816c` (development tree; do not silently call this the 2.9.10 release). This closes the *example availability* gap of MOTION-194/195, not the physical-validation gap.

## Exact provenance and complete pair

- [7i96s.ini](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/configs/by_interface/mesa/hm2-servo/7i96s.ini), blob `9aae201609fee6ba81a370ff04f58440c929bdbc`.
- [hm2-servo-eth.hal](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/configs/by_interface/mesa/hm2-servo/hm2-servo-eth.hal), blob `480c630e49c76cc5d3b8812b0df9426c8d5ec98d`.
- [5i20.ini](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/configs/by_interface/mesa/hm2-servo/5i20.ini), blob `dd293a3b7d971b83f2e33f65d8486ebcd46fd806`, and [hm2-servo.hal](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/configs/by_interface/mesa/hm2-servo/hm2-servo.hal), blob `548e010854e1aca178f27877eb3e2f7799464132`: PCI comparison.
- These are **upstream example configurations**, not proof of a working physical 7i96S servo machine. Board firmware/pinout suitability, actual encoder and amplifier wiring and output polarity must be verified before use. Do not copy this to a powered machine.

## X-axis source trace (Y and Z repeat with channels 01 and 02)

```text
[JOINT_0] INPUT_SCALE=81920  FERROR=0.010  MIN_FERROR=0.002
          P=100 I=0 D=0 FF0=0 FF1=1 FF2=0
          OUTPUT_SCALE=-1 MAX_OUTPUT=1
[HOSTMOT2] DRIVER=hm2_eth BOARD_IP=192.168.1.121 BOARD=7i96s
           CONFIG="num_encoders=3 num_pwmgens=3 num_stepgens=0"
[HAL] HALFILE=hm2-servo-eth.hal
[EMCMOT] SERVO_PERIOD=1000000
hm2_7i96s.0.encoder.00.position -> motor.00.pos-fb
                                  -> pid.0.feedback
                                  -> joint.0.motor-pos-fb
joint.0.motor-pos-cmd -> pid.0.command
pid.0.output -> hm2_7i96s.0.pwmgen.00.value
joint.0.amp-enable-out -> pid.0.enable, pwmgen.00.enable
```

**SOURCE-CONFIRMED:** HAL directly connects encoder position (not stepgen position-fb) to both PID and joint feedback. The driver is configured for zero step generators, three encoders, three PWM generators. Encoder scale and output scale are **different dimensions**; the X encoder scale is 81920 counts per machine unit, and the PWM scale is -1.0, not a substitute for encoder scaling. Y uses INPUT_SCALE=-81920 and OUTPUT_SCALE=+1; Z uses +81920/-1. The INI declares inch linear units. These values are illustrative, not machine calibration.

**SOURCE-CONFIRMED scheduling:** `hm2_*.read` → `motion-command-handler` → `motion-controller` → `pid.0/1/2.do-pid-calcs` → `hm2_*.write`, all in `servo-thread`. Thus encoder sampling is consumed before the current motion/PID calculations and new PWM output is published after them. Actual FPGA sampling/transport latency and physical following-error dynamics are UNKNOWN.

**SOURCE-CONFIRMED enable/homing:** `joint.0.amp-enable-out` drives PID and PWM enables, but the sample has no separately verified physical drive-ready/fault return. X/Z home without encoder index; Y links `joint.1.index-enable` bidirectionally to encoder.01.index-enable. All three home-switch inputs share GPIO 025 in_not, explicitly a demonstration convenience, not a recommended independent homing arrangement. `iocontrol.0.user-enable-out` loops directly to `emc-enable-in` and tool-change acknowledgments loop back: neither constitutes independent personnel safety.

**SOURCE-CONFIRMED limits:** X/Y/Z `FERROR=0.010` and `MIN_FERROR=0.002` are configured; `pid.N.maxoutput` comes from `MAX_OUTPUT=1`. These are different constraints: following error belongs to motion feedback monitoring, PID maxoutput to control output. The exact motion runtime trip formula is separately established in the prior BL-DEV-002 source/transfer evidence; do not infer the runtime trip outcome from this config alone.

## Diagnostic comparison / minimal review exercise

| Case | Signal producer for joint motor-pos-fb | What it demonstrates |
|---|---|---|
| AXIS `core_sim.hal` | commanded position signal | direct synthetic loopback; no plant evidence |
| `basic_sim.tcl` | PID/mux synthetic feedback | enable-dependent hold, no physical encoder |
| MR1 7i96S tandem | HostMot2 stepgen position-fb | generated step position, not measured axis |
| This upstream 7i96S hm2-servo example | HostMot2 encoder position | intended independent encoder input topology; not yet measured hardware response |

Disconnected reviewer should: (1) locate INI HALFILE and HOSTMOT2 config; (2) trace `encoder.00.position` to both feedback consumers; (3) trace `motor-pos-cmd` to PWM via PID; (4) check `addf` order; (5) distinguish encoder and output scale signs; (6) identify which GPIO and loopbacks are illustrative; (7) compare FERROR with PID output saturation. **Expected:** all seven are text-inspectable; no runtime pass/fail asserted.

## Remaining implementation questions / next branch

1. Confirm actual 7i96S firmware and PWM/encoder module availability and electrical suitability for the specific bitfile, not merely the INI requested module counts.
2. Verify amplifier-enable/fault return, encoder polarity and scale, PWM polarity and output limits against real machine wiring before any physical test.
3. A disconnected LinuxCNC runtime could inspect `halcmd show pin` and servo traces only after runner isolation is independently approved. MOTION-144 remains blocked; no hosted Actions fallback.
4. **Information-gain stop:** a complete encoder-servo *example* is now found. Do not spend another hourly session finding nearly identical examples. Rotate to source-grounded 3300 plasma DXF → CAM/postprocessor → LinuxCNC interpreter/QtPlasmaC path, or another unblocked implementation topic.

## Evidence ledger

| Claim | Class | Boundary |
|---|---|---|
| Encoder → PID and joint feedback | SOURCE-CONFIRMED | pinned HAL, not physical encoder accuracy |
| PID → PWM, enable and servo ordering | SOURCE-CONFIRMED | pinned HAL, no measured latency |
| Numeric scale, PID and following-error parameters | SOURCE-CONFIRMED | pinned INI, not tuning endorsement |
| Encoder module counts imply physically available FPGA resources | UNKNOWN | firmware/bitfile/hardware check required |
| Real amplifier/encoder behavior or safety authority | UNKNOWN | no hardware, tests, or independent personnel-safety evidence |

No builds, laboratory compute, workflows, or machine operations were performed. Graduated modules and blind/evaluator separation unchanged.
