# 3100/3500/4000 — LinuxCNC Home All failure sequencing: gantry simulator and commissioning handoff

**2026-11-01. NON-GRADUATED. All runtime cases NOT RUN.** Read the [HOMING-131 pinned source audit](../research/4400_LINUXCNC_HOMING_131_HOME_ALL_FAILURE_SEQUENCE_CONTINUATION_VERSION_AUDIT_2026-11-01.md) and predecessor [HOMING-90](../research/4400_LINUXCNC_HOMING_90_BOUNDED_MOVE_ABORT_FANOUT_SOURCE_AUDIT_2026-11-01.md). This guide is for **disconnected software-only LinuxCNC**, not a machine setup procedure to execute on powered drives.

## The practical question

A multi-joint machine may home X, paired gantry Y joints, then Z. If X fails its home-switch precondition, does Home All stop, or does the controller start Y anyway? The answer depends on the LinuxCNC revision and on *which state transition failed*. A GUI error is not a reliable substitute for a joint-by-joint servo state trace.

### Real upstream reference, not an invented machine

Pin [`configs/sim/axis/gantry/gantry.ini`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/configs/sim/axis/gantry/gantry.ini) at development commit `06864e23559e70463fc7112d5ce77138bcbc288c`. It defines four joints: X=0 (`HOME_SEQUENCE=0`), Y1=1 and Y2=3 (`HOME_SEQUENCE=-1`), Z=2 (`HOME_SEQUENCE=2`). This is a simulated gantry and not a press-brake, router, or physical acceptance test.

For a disposable copy of the config, add `HOME_IS_SHARED = 1` under `[JOINT_0]`. In the **simulator only**, arrange for `joint.0.home-sw-in` to be high *before* the Home All command, while leaving the other simulated switches in their normal working state. Do not hard-wire or override any real switch. Keep every other homing parameter unchanged initially. Record the exact INI/HAL diff and all source SHAs.

## Source-to-runtime path to instrument

`linuxcnc.command().home(-1)` or the UI's accepted Home All → Task/NML joint-home request → motion `do_home_joint(-1)` → `do_home_all` → servo-cycle `do_homing_sequence` → per-joint `HOME_START` → `HOME_SEQUENCE_WAIT_JOINTS` → next `HOME_SEQUENCE_START_JOINTS` (if members remain included). Compare against `base_1joint_state_machine`'s `HOME_ABORT` branch.

The coordinator decides completion from `home_state==HOME_IDLE` (or a member's removal from `joint_in_sequence`), **not** from `homed==1`. The simulator must expose that difference rather than merely report whether a Home All button returned.

## Minimal A/B cases and frozen expected outcomes

| Case | Fault and revision | Precommitted prediction | Required observed discriminator |
|---|---|---|---|
| HS131-A | Stable v2.9.10, X shared switch active at start | X logs error and becomes IDLE without `HOME_ABORT`; Y1/Y2 can begin sequence -1, then Z after Y completes; X stays unhomed | A Y `home-state` transition out of IDLE **after** X error |
| HS131-B | Development 06864e, same X precondition | X enters `HOME_ABORT`; all joints' `joint_in_sequence` and `homed` clear; Y/Z do not start in the same Home All | No Y/Z `HOME_START` after X error, plus global homed-flag clearing |
| HS131-C | Stable, X begins homing then fails due to switch never detected | X's `HOME_ABORT` clears X only; remaining groups may start | X error + later Y `HOME_START` |
| HS131-D | Development, positive `HOME_SEARCH_DIST` and X switch absent | X reaches bounded search endpoint, global abort invalidates all; no later Y start | Endpoint/error, global state clearing, no later Y start |
| HS131-E | Both versions, normal switches | All eligible groups run in order; no error | Control case establishing simulator validity |

Cases A/B are the smallest high-information comparison. C/D require additional deliberate software-only switch simulation and are **not** necessary to answer A/B. Never use a physical axis to provoke a limit or missing-switch failure.

## How to collect evidence

1. Confirm pinned LinuxCNC binary revision, Task mode, simulator-only HAL graph, `[KINS]JOINTS`, `HOME_SEQUENCE` and all `HOME_IS_SHARED` settings. Confirm physical disconnection independently; the `[self-hosted, openpressbrake]` runner label alone is insufficient.
2. Record `joint.0..3.homing`, `joint.0..3.homed`, `joint.0..3.home-state`, `joint.0..3.home-sw-in`, and `motion.homing-inhibit` with servo-period timestamps. If available in an instrumented build, also capture internal `sequence_state`, `current_sequence`, `joint_in_sequence` and `free_tp.enable/active`.
3. Freeze the exact precondition *before* `home(-1)`: machine enabled in the proper free/joint mode, no previous homing active, X shared switch already asserted, all four joints initially unhomed, no unrelated fault. Record command acceptance and Task error separately from realtime state.
4. Observe the X error and **at least two later coordinator periods**; continue long enough to distinguish a Y `HOME_START` from a temporary IDLE or queued command. Record whether the Y group starts, whether Z starts, and whether the controller ever reports all-homed.
5. Retain raw logs, INI/HAL diff, source and binary SHAs, actual job start/end timestamps, process exit code and stdout/stderr. A green workflow check alone is not a LinuxCNC behavioral oracle.

### Important instrumentation limitation

`joint.N.home-state` is a public HAL diagnostic, but `joint_in_sequence` and `sequence_state` are internal `homing.c` state. A public HAL trace can establish Y's subsequent state transition; to distinguish exactly *why* it did not start, use an instrumented disconnected build rather than claiming to observe private fields through ordinary HAL. Sampling only at a low userspace rate may miss short transitions; use servo-synchronous logging or a suitable debug build.

### Interpretation matrix

- **X error + Y begins homing:** supports continuation after an earlier failed sequence; not proof that X was homed.
- **X error + Y does not begin:** inspect the exact revision, command acceptance, `HOME_IS_SHARED`, simulator switch input, joint active status, and private `joint_in_sequence` before inferring global cancellation.
- **`homing_active=0` while one or more `homed=0`:** ordinary completion of the coordinator's activity, not a successful all-homed condition.
- **Unexpected motion command or state:** classify **HARNESS INVALID**, **SOURCE HYPOTHESIS FAILED**, or **VERSION/CONFIG DRIFT** and preserve the original prediction. Do not silently rewrite the expected outcome.

## Machine-class transfer

For a mill/router with a dual-Y gantry, distinguish synchronized final Y move from a whole-program fail-stop policy. For a lathe, a failed spindle or X reference should not be assumed to block another joint solely because Home All was requested. For EtherCAT/CiA402 or absolute-encoder machines, an external homemod and drive-side homing state may change the path: this audit applies to **stock `homing.c`** and not an arbitrary custom homemod. For OpenPressBrake, no stock LinuxCNC homing result authorizes physical Y1/Y2 or personnel-safety decisions; preserve independent safeguarding and existing G0/G1 holds.

## Independent verification and unresolved items

**SOURCE-CONFIRMED:** stable shared-switch failure directly sets IDLE; development routes it to global HOME_ABORT; WAIT checks IDLE rather than homed; the four-joint upstream gantry sequence is real source. **INFERENCE:** later Y/Z starts or does not start under the frozen A/B simulator conditions. **TEST-CONFIRMED:** none. **UNKNOWN:** GUI-specific completion messaging, other homemod behavior, installed-machine fault policies. The earlier HOMING-90 12-case matrix remains valid and unexecuted; this is a narrow additional discriminator, not a compulsory product or new physical machine test.

**Next:** Execute only A/B on a positively qualified disconnected `[self-hosted, openpressbrake]` environment. If access/isolation remains unknown, continue a distinct LinuxCNC internals topic rather than dispatching any hosted or unqualified workflow.
