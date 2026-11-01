# LinuxCNC motion-cycle timing: practical HAL/INI preflight
**3100/3200/3400/3500/4000 implementation guide.** SOURCE-BASED, **NOT RUN**. Read [RT-133](../research/4400_LINUXCNC_RT_133_TRAJ_SERVO_CYCLE_ASSIGNMENT_CUBIC_REAL_CONFIG_SOURCE_AUDIT_2026-11-01.md) and [RT-134](../research/4400_LINUXCNC_RT_134_INI_HAL_PERIOD_PASS_THROUGH_ROUNDING_AND_DIAGNOSTIC_SOURCE_AUDIT_2026-11-01.md).

## Why this matters
An INI period is a **request**, HAL `loadrt` is the actual parameter boundary, HAL quantizes the nominal thread period, and `motion-controller` receives that nominal period. There is no separate exported trajectory-planner HAL function in the pinned source. Motion invokes TP when its cubic interpolator needs a new point. Do not confuse this with observed scheduling jitter or physical axis feedback.

## Three minimal, inspectable examples
**A — 1:1 baseline.** BASE=50,000 ns, SERVO=1,000,000 ns, no `traj_period_nsec` argument. Motion defaults traj to 1 ms; first callback predicts TP=1 ms, internal servo=1 ms, cubic rate=1, segment=1 ms, increment=1 ms.

**B — shipped 10:1 machine config.** [1240rutex.ini](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/configs/by_machine/smithy/1240rutex.ini#L81-L83) plus [HAL](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/configs/by_machine/smithy/1240rutex.hal#L1-L20) explicitly passes 10 ms trajectory with 1 ms servo. Source-derived first callback: `servo_mult=10`, `setTraj(1ms)` changes cubic rate to 1; `setServo(10ms)` computes rate 0, cubic rejects it, then accepts segment 10 ms. **Predicted:** TP=1 ms, reported servo=10 ms, config interpolationRate=0, cubic stored rate=1, segment=10 ms, increment=10 ms, HAL nominal callback=1 ms. This is **not** a verified 10x physical speed error.

**C — same INI, different HAL.** [622gecko.ini](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/configs/by_machine/smithy/622gecko.ini#L81-L83) also specifies 10 ms trajectory, but [HAL](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/configs/by_machine/smithy/622gecko.hal#L1-L3) passes `traj_period_nsec=[EMCMOT]SERVO_PERIOD`; effective request is 1 ms. [Pentapod core_sim.hal](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/lib/hallib/core_sim.hal#L7) omits trajectory period entirely. **Never infer the loaded motion parameters from INI alone.**

**D — rounded base/servo.** BASE=400 µs, SERVO=1 ms, TRAJ omitted: source rounds servo to 1.2 ms but defaults traj to 1 ms. First callback `servo_mult=0`; `setServoCycleTime(0)` returns -1 without propagating an error; initial servo config remains 1.2 ms. Do **not** claim a physical velocity fault from this example.

## Commissioning workflow — disconnected software only
1. Freeze controller revision, exact INI, all included HAL files and resolved `loadrt` substitutions.
2. Map `addf` order: e.g. software stepgen capture → motion-command-handler → motion-controller → stepgen.update-freq in the pinned 1240rutex HAL. For Mesa/HostMot2 or EtherCAT, map hardware read before control and hardware write after; do not invent a base thread for FPGA step generation.
3. Predeclare expected nominal servo period, TP cycle, cubic rate, segment and increment. Distinguish `thread->period` from measured `motion.servo.last-period`.
4. **Only with positively qualified physical isolation and `[self-hosted, openpressbrake]` compute:** compare 1:1 and 10:1 configurations using a small software-only coordinated move. Instrument `emcmotConfig`, `coord_tp.cycleTime`, cubic fields and commanded position/velocity before and after first callback; capture actual logs, exit, version and authoritative job duration. A runner label is not physical isolation.
5. Treat any proposed upstream setter swap or clamping change as **untested** until default, nondefault and rounded-period cases all pass. Prefer effective 1:1 timing for new integration until an isolated comparison supports a nondefault ratio. No product build is mandated.

## Fresh-engineer adversarial exercises (not blind-scored)
Explain why `TRAJ_PERIOD=10ms` can be ignored by pentapod; distinguish 1240rutex from 622gecko; trace why `cubicSetInterpolationRate(0)` does not overwrite stored rate; explain why nominal thread period and last-period jitter are different; and identify why a motion command trace cannot establish physical axis position or independent personnel safety. Use pinned source to answer, not this guide's prose alone.

**Evidence:** SOURCE/DOC-CONFIRMED call paths, COMMUNITY-REPORTED upstream issue #3268, source-derived arithmetic INFERENCE; no local TEST-CONFIRMED runtime. Graduated levels and independent safety/OpenPressBrake G0/G1 HOLD unchanged. [Next checkpoint](../checkpoints/20261101T203600Z-4000-linuxcnc-motion-cycle-period-next.md).
