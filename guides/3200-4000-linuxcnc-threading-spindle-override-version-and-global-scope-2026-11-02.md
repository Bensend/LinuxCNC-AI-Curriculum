# 3200/4000 — LinuxCNC threading override state: source-to-HAL commissioning map

**2026-11-02 | NON-GRADUATED | SOURCE-ONLY, ALL NEW RUNTIME CASES NOT RUN.** Companion to [THREAD-142](../research/4400_LINUXCNC_THREAD_OVERRIDE_142_G33_G331_G76_GLOBAL_LOCK_VERSION_SOURCE_AUDIT_2026-11-02.md). Reuse existing [OVERRIDE-93/94/95 acceptance](4000-linuxcnc-m51-inhibit-coupling-disconnected-acceptance-2026-11-01.md); this guide adds only **thread-specific and version-specific** discriminators.

## Why a lathe integrator should care

A threading pass is position-synchronized to an encoder, not an ordinary F-word feed. In the inspected development revision, G33 deliberately suspends spindle speed override for the pass, G33.1 deliberately retains it, and G76 locks it for the whole cycle. Stable v2.9.10 lacks the inspected development G33 suspension and G76 lock. Those differences are material when upgrading a lathe or writing a CAM post; do not assume one version's override behavior applies to another.

**Crucial cross-layer trap:** a G33 or G76 canonical message can name spindle 1 while Task forwards only the mode to a **global** motion enable mask. G76's new lock snapshots both spindles' scales, not just the selected spindle. This is normal-control state, never independent personnel-safety authority.

## Source walk, from G-code to servo cycle

1. Interpreter `convert_straight`: G33 uses `suspend_speed_override`/restore only in development; G33.1 keeps override; G76 `convert_threading_cycle` locks/restores only in development.
2. Canonical `SPEED_OVERRIDE_(spindle, mode)` flushes pending segments and queues `EMC_TRAJ_SET_SO_ENABLE` with both fields.
3. Task `emctaskmain.cc` forwards **mode only**. `taskintf.cc` issues `EMCMOT_SS_ENABLE`; `command.c` changes global `enables_new`.
4. A newly queued TP segment copies that mask, and `tpUpdateMovementStatus` publishes its `tc->enables` as `enables_queued`. A later restore command need not retroactively change an already queued segment's effective mask.
5. Development servo `process_inputs` latches `min(scale[s],1)` for every spindle on the first **effective** SS_LOCKED transition, and applies it only while SS_ENABLED remains set. TP `tpGetFeedScale` ignores ordinary feed scaling for position-synchronized segments; spindle speed-out still follows its own scaling path.

## Frozen source-derived state table

Assume two spindles, SS_ENABLED initially ON, no other stop/limit, scales `spindle0=0.80`, `spindle1=1.20`, and no external inhibit unless stated. Values describe **requested scale state**, not measured RPM.

| Command / segment | Stable v2.9.10 | Development 06864e | Source-derived scope |
|---|---|---|---|
| G33 $1 | No explicit SS suspend in branch | SS off during segment, restored afterward | Development global SS off affects both spindle multipliers |
| G33.1 $1 | SS unchanged | SS unchanged | Normal selected spindle sync; no special speed-override suspend |
| G76 $1 | No SS lock in inspected cycle | SS_LOCKED rises; latched [0.80, 1.00] | Lock is **global**, both scales snapshotted |
| G76 $1 after M51 P0 | SS remains off unless another command enables | SS_LOCKED may be set while SS_ENABLED stays off | Locked scale not multiplied when SS_ENABLED=0 |
| G33 $1 with spindle-1 saved override OFF | No new suspend/restore | Restore emits OFF, not ON | Global motion SS may remain OFF even if spindle 0 was ON in interpreter |

This table intentionally does not claim a live RPM, a successful thread, or a spindle braking result.

## Practical bounded verification (only on a positively qualified disconnected host)

**Do not energize a machine.** Use a copy of an upstream simulation with **no Mesa, EtherCAT, VFD or actuator outputs**. Pin the source commit, binary, INI/HAL, canonical trace and timestamps. First run the existing upstream `tests/interp/g76` under each version; compare the development `LOCK_SPEED_OVERRIDE(0)` expected line against stable's absence. Existing expected files are an **oracle to execute**, not evidence this session ran them.

Then, in a two-spindle software-only configuration with independently simulated encoder/index and at-speed signals, compare G33 selected spindle 1, G33.1 selected spindle 1 and G76 selected spindle 1. Record per-spindle scale, `spindle.N.speed-out`, `spindle.N.on`, `spindle.N.inhibit`, `motion.feed-inhibit`, Task mode/spindle, motion mask, and planner synchronization state. **Instrument `locked_spindle_scale` if needed; it is internal, not a stock HAL pin.** The upstream multispindle example has a potential index-enable wiring error identified by SPINDLE-22; verify the HAL topology before using it as a test oracle.

A useful discriminating sequence for the development branch: set operator scales to 0.80/1.20, run a G76 cycle selecting spindle 1, vary both operator scales only after the lock is observed, and check whether requested spindle output continues using 0.80/1.00 through the cycle. Repeat with an earlier M51 P0 to check the independent SS_ENABLED condition. A separate G33 $1 test should show whether global override mode affects spindle 0's requested output even though spindle 1 is the selected encoder. Do **not** infer physical motion from these traces.

**Acceptance gates:** (a) interpreter/canonical command order, (b) Task field propagation, (c) motion queued/new flags, (d) TP synchronized-feed handling, (e) commanded spindle speed, (f) actual physical feedback only if independently authorized and separately evaluated. A–E are eligible for isolated software evidence; F is outside this exercise. Log version, all raw data, exit status and **actual job runtime**, not estimated lesson duration. No GitHub-hosted Actions runners. No unqualified local machine control.

## Adversarial checks for a fresh engineer

- Does a canonical `LOCK_SPEED_OVERRIDE(1)` guarantee only spindle 1 is locked? **No:** Task discards the spindle selector and motion locks a global flag.
- Is a G33 feed-inhibit exception proof that `spindle.N.inhibit` is also deferred? **No:** TP feed scaling and spindle command scaling are different paths.
- Does SS_LOCKED alone force a 100% override? **No:** the locked multiplier is applied only if SS_ENABLED remains set; cap is `min(scale,1)`.
- Can a canonical G76 expected log establish the physical speed trajectory? **No:** it proves neither Task/motion execution nor drive feedback.

**Current result:** all new cases **NOT RUN**. No graduation, physical commissioning, safety evaluation or product build.
