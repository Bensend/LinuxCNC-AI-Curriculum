# MOTION-212 — HostMot2 Ethernet servo ordering and stepgen feedback provenance (2026-11-04)

**Track:** 4000 hardware/LinuxCNC implementation; NON-GRADUATED. **Evidence:** SOURCE-CONFIRMED narrow; no new runtime/physical verification. **Pinned LinuxCNC revision:** `cdf957bd00bbcc4c569f01e7eed5b154422b816c` (development tree, not 2.9.10 release).

## Why this matters
A HAL net named `position-fb` does not establish *what was measured*. The source differentiates an FPGA step-rate accumulator from an independent encoder. In a missed-step, disconnected drive, or slipping mechanics case, an internal stepgen feedback signal can remain plausible even when the axis is not where the controller thinks it is. Likewise, HAL's function order establishes computation order but **not** zero-latency Ethernet transport or synchronized hardware sampling.

## Inspectable source evidence
1. [hm2-servo-eth.hal](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/configs/by_interface/mesa/hm2-servo/hm2-servo-eth.hal) lines 52–61 schedules `hm2_*.read`, `motion-command-handler`, `motion-controller`, three PID calculations, then `hm2_*.write`, in `servo-thread`. Lines 80–88 connect encoder.00.position to pid.0.feedback (the shared net is also connected to joint feedback farther down). This particular upstream example configures **encoder+PWM**, not stepgen servo feedback; see MOTION-196.
2. [stepgen.c](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/src/hal/drivers/mesa-hostmot2/stepgen.c) lines 40–48 reads the FPGA stepgen accumulator register; lines 111–123 accumulates the register delta in `subcounts`, publishes `counts = subcounts >> 16` and `position_fb = (subcounts / 65536.0) / position_scale`. The comment explicitly preserves fractional-count resolution. This is an internal generated-step position representation, **not** an external motor encoder or an axis measurement.
3. Same [stepgen.c](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/src/hal/drivers/mesa-hostmot2/stepgen.c) lines 256 onward prepares commanded step rates for the hardware; lines 342–352 set step rate zero when disabled, and otherwise calculate the command. Thus the read-side accumulator and write-side command are distinct operations. Neither verifies that a physical step occurred.
4. [hm2_eth.c](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/src/hal/drivers/mesa-hostmot2/hm2_eth.c) lines 930–945 explicitly checks queued read packet capacity, logging and resetting the queue on overflow. Lines 1027–1033 derive a configurable read timeout, including percentage-of-period interpretation and minimum 100000 ns. These are concrete transport constraints; a one-millisecond servo period is not proof that a network round trip is always completed in that period.

## One-tick reasoning exercise (review-only)
Given a servo-thread order `hm2.read → motion → pid → hm2.write` and a sample at tick N: the position used by motion/PID is the value published by the **read** function for that tick, and the output written is computed from that published value. It is **not** established that the read corresponds to the instantaneous motor position at the same wall-clock instant as the write. The actual hardware sampling instant, queued Ethernet round-trip, FPGA update timing, and physical plant delay require instrumented evidence.

For a stepgen position-scale of 200 steps/mm and `subcounts = 65536 * 37 + 32768`, the published `position_fb` is `37.5 / 200 = 0.1875 mm` while `counts` is 37. Both are generated-step accumulator values. If a motor physically stalls at 0.15 mm, this signal **cannot independently detect the stall**; an encoder, external sensor or other feedback is required to observe the difference. This arithmetic is an analytical oracle, not a LinuxCNC runtime test.

## Disconnected verification matrix
| Case | Inspection / stimulus | Expected observation | Evidence boundary |
|---|---|---|---|
| A | Read upstream servo HAL addf lines | read precedes motion/PID precedes write | SOURCE |
| B | Trace upstream encoder.00.position | encoder drives PID and joint feedback | SOURCE; physical encoder unverified |
| C | Trace stepgen accumulator processing | subcount-resolution position-fb | SOURCE |
| D | Compare stepgen counts with position-fb at 37.5 counts | 37 vs 0.1875 mm at 200 steps/mm | ANALYTICAL |
| E | Hypothetical lost motor steps | stepgen position-fb can still advance | INFERENCE; no hardware test |
| F | Examine queued-read overflow and timeout | transport has explicit failure/latency handling | SOURCE; timing distribution unknown |
| G | Inspect disabled stepgen prepare | commanded step rate zero; old command updated | SOURCE; mechanical stop not proved |
| H | Replace encoder feedback with stepgen feedback in a proposed config | feedback provenance changes even if pin names look alike | DESIGN REVIEW ONLY; do not deploy |

## Implementation walkthrough / diagnostic boundary
On a disconnected configuration, first locate `[HAL] HALFILE` and `[HOSTMOT2]` in INI, then inspect `loadrt hm2_eth` and `addf` order. Follow the actual producer of each `joint.N.motor-pos-fb` and `pid.N.feedback`; label it `encoder`, `stepgen accumulator`, `simulated`, or `command loopback`. Inspect `stepgen.N.position-scale` independently of encoder scale and actuator-output scaling. Finally, list which conditions are not observable with the chosen feedback. Do not infer physical fault detection from the presence of a PID loop or following-error limits alone.

## Open questions and next dependency
Inspect the **hostmot2.c** common read/write TRAM processing order and its call into stepgen/encoder processing, plus the Ethernet queue completion/error propagation; pin down whether a stale read can be published after a timeout and what the exported `io_error` signal does. Then compare an actual stepgen-based Mesa HAL example against this encoder/PWM example. Runtime verification remains separately gated on approved isolated `[self-hosted, openpressbrake]` compute; do not dispatch hosted Actions. No board, amplifier, physical axis or independent personnel-safety authority has been tested.

## Evidence ledger
SOURCE-CONFIRMED: pinned HAL ordering, stepgen accumulator calculation, disabled command behavior, Ethernet queue/timeout checks. ANALYTICAL: 37.5-step example. UNKNOWN: FPGA/transport latency distribution, real encoder performance, drive fault detection, physical motion, exact timeout-to-HAL propagation. No test/build/compute/workflow/machine execution this session. Preserve blind evaluation and independent personnel-safety gates.
