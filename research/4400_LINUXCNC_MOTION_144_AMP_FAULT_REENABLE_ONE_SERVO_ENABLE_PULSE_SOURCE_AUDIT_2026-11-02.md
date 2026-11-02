# MOTION-144 — Joint amplifier fault: same-cycle trip versus one-cycle re-enable pulse

**2026-11-02 | 4000 LinuxCNC motion internals; 3100/3200/3400/3500 machine transfer | NON-GRADUATED | source-only.**

## Why this is a distinct LinuxCNC core question

A same-session follow-through after [ECAT-ENC-143](4400_LINUXCNC_ECAT_ENCODER_143_EL5101_RECONNECT_WRAP_FREQUENCY_SOURCE_AUDIT_2026-11-02.md) asks how LinuxCNC motion handles a drive's *ordinary* `joint.N.amp-fault-in` versus `joint.N.amp-enable-out` during a fault and subsequent enable command. Full historical PROGRESS term checks found no `amp-fault-in`, `amp-enable-out`, or `joint fault` source audit; existing following-error, homing, and safety studies are different mechanisms. This is not a safety-course evaluation, not a real servo drive, and not a physical stop-time assertion.

## Pinned source and exact call chain

LinuxCNC [stable v2.9.10](https://github.com/LinuxCNC/linuxcnc/tree/v2.9.10) and development commit [`06864e23559e70463fc7112d5ce77138bcbc288c`](https://github.com/LinuxCNC/linuxcnc/commit/06864e23559e70463fc7112d5ce77138bcbc288c) were inspected directly.

- [Stable `control.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/control.c), blob `b6e45d590c7d11030654d8f7d13d118f581b6439`: `emcmotController` lines **247–270** runs `process_inputs` → `check_for_faults` → `set_operating_mode` → `output_to_hal`. `process_inputs` reads `amp_fault` into joint fault flag lines **504–509**; `check_for_faults` lines **802–847** tests fault only for **active AND enabled** joints, sets joint error and `emcmotInternal->enabling=0`; `set_operating_mode` lines **867–924** clears/enables joint flags; `output_to_hal` line **2023** copies `GET_JOINT_ENABLE_FLAG` to `joint.N.amp-enable-out`.
- [Stable `command.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c), blob `0b79061d39be915bbea548b2c33bb794d31ab302`, lines **1304–1319**: `EMCMOT_ENABLE` checks the global `motion.enable` HAL input, **not** the joint amp-fault flags, before setting `emcmotInternal->enabling=1`.
- [Stable `motion.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/motion.c), blob `febe7f3ff3f2b80e34b00a9e60d3cdb3e9e41841`, lines **762–763**: joint amp-enable is HAL_OUT and amp-fault is HAL_IN.
- [Development `control.c`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/motion/control.c), blob `7c9a35c237ba05326372294587c33d53aff1a6a9`, lines **253–280**, **579–584**, **876–999**, **2140**: same functional call order and active/enabled gate; HAL accessors changed to `hal_get_bool`/`hal_set_bool`.
- [Development `command.c`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/motion/command.c), blob `fd9760e59ac0e9801cbee90a379acd98d47ca6ea`, lines **1453–1468**: same enable precondition. [Development `motion.c`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/motion/motion.c), blob `4a096507d64b19a3035cce7a66cab635d19d5ea7`, lines **768–769**: same pin directions.

## Source-derived state table

Assume one **active** joint, `joint.0.amp-fault-in=TRUE`, global `motion.enable` input TRUE, no other motion mode transition, and a normal controller invocation. `motion.enable` here means the HAL input gate, distinct from the internal `GET_MOTION_ENABLE_FLAG` state.

| Starting internal state | Requested action | Fault evaluation | End of callback `joint.0.amp-enable-out` | Interpretation |
| --- | --- | --- | --- | --- |
| Motion/joint already enabled | Amp fault asserts | `process_inputs` sets fault; `check_for_faults` sees active+enabled and sets enabling=0 | **FALSE** | Source can deassert the normal HAL enable in the **same controller callback** |
| Motion/joint disabled, amp fault remains TRUE | `EMCMOT_ENABLE` accepted (global enable input TRUE) | `check_for_faults` **skips** fault because joint enable flag is still FALSE; `set_operating_mode` enables joint | **TRUE** | **Conditional one-callback enable pulse** despite persistent fault |
| Next callback, amp fault still TRUE | No new command | Now active+enabled; fault check sets enabling=0 and `set_operating_mode` disables | **FALSE** | Re-enable pulse ends after next controller pass |
| Motion disabled, amp fault TRUE | Enable attempted while global `motion.enable` input FALSE | `EMCMOT_ENABLE` rejected in command handler | **FALSE** | Global input is a distinct precondition |
| Joint inactive, amp fault TRUE | Motion enabled for other joints | Fault check skips inactive joint | **FALSE** for inactive joint's flag | An inactive joint is not automatically a motion trip source |

**Important:** The pulse conclusion is a conditional **source-derived control-state prediction**, not an observed electrical pulse or an assertion that a real amplifier will energize. The HAL thread's function order, downstream drive enable wiring, EtherCAT/HostMot2 output timing, drive internal fault logic and hardware interlocks determine actual physical consequences. `amp-enable-out` is a software request, not amplifier power feedback. A real drive may ignore an enable request while faulted.

## Why this matters for actual configs

A normal servo HAL typically schedules `motion-controller` and then output transport writes. If that order is present, the transient TRUE value can be visible to a downstream HAL consumer on the enable callback; a different HAL order may delay or skip transmission. Do **not** claim exact physical pulse duration from a single source-level pass. A motion-level `amp-fault-in` is diagnostic and participates in the software enable state machine, not a substitute for independent personnel-safety authority.

For machine integration, distinguish: (1) drive fault feedback, (2) LinuxCNC `joint.N.amp-enable-out` command, (3) actual amplifier ready/energized status, (4) feedback position validity, and (5) independent protective-stop authority. After a fault, operator re-enable should be gated by a positively verified drive-ready condition outside the source's ordinary active+enabled check, and rehome/reacquire position if needed. Do not introduce an unreviewed HAL interlock or safety claim into a live machine based on this audit.

## Minimal disconnected verification plan (NOT RUN)

Use a source-pinned LinuxCNC simulator with a **fake drive and no physical outputs**, and record at servo-thread resolution: `joint.0.amp-fault-in`, `joint.0.amp-enable-out`, `motion.enable` HAL input, `motion.motion-enabled` output, internal joint enable/fault/error flags if instrumented, command timestamps and `motion-controller`/transport `addf` order.

1. Enable with amp fault FALSE; verify stable TRUE output.
2. Assert amp fault while enabled; verify output deasserts after the first fault-processing controller pass.
3. Keep fault TRUE, request re-enable while global `motion.enable` input remains TRUE; discriminate **one callback TRUE** versus immediate rejection, and record the next callback.
4. Repeat with global `motion.enable` input FALSE; expect command rejection.
5. Repeat on an inactive joint; confirm no unrelated joint's enable is changed by that inactive fault alone.
6. Compare v2.9.10 and pinned development; capture any differing GUI/Task enable preconditions, and avoid inferring Task behavior solely from the motion command handler.

A fake HAL source that writes `amp-fault-in` is **not** a personnel-safety test. No qualified isolated compute was dispatched; all six remain **NOT RUN**. A proposed source correction must be designed around the intended semantics of faulted/disabled joints, recovery, and independent drive readiness—not simply a cosmetic GUI status change.

## Evidence and next

**SOURCE-CONFIRMED:** fault sampling, active+enabled fault gate, command precondition, mode transition and HAL publication order in both pinned versions. **INFERENCE:** conditional one-controller-pass TRUE output during re-enable with persistent fault. **UNKNOWN:** Task/GUI command acceptance beyond motion handler, realtime scheduling jitter, transport transmission, drive state, physical pulse, machine reaction and safety performance. **TEST-CONFIRMED none.** No build, HAL execution, physical machine, evaluator or Actions; 0/0 hosted/self-hosted minutes.

See [combined checkpoint](../checkpoints/20261102T0236Z-4000-linuxcnc-ethercat-encoder-next.md) for next work. Preserve graduated levels, independent safety/OpenPressBrake G0/G1 HOLD and hourly schedule.
