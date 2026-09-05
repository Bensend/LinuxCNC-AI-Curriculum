# A01 — Bounded HAL probe: shell `errexit` and HAL-lock integrity

## Scope

Module A01, LinuxCNC development revision `8bf4605ae81042248add031e94c77300406e0413`.

This note adversarially reviews the prepared `a01-bounded-observation` experiment before it is allowed to run in the next laboratory-compute window. It records two independent hazards: a remaining Bash `errexit` bug in the prepared diagnostic helper and the fact that forcibly killing a process while it is participating in HAL's recursive shared mutex can mutate/strand shared lock accounting.

## Finding 1 — prepared helper still re-enables `errexit` too early

**Classification: TEST-CONFIRMED for Bash control-flow behavior; SOURCE-CONFIRMED for the prepared curriculum script.**

Prepared branch commit `42a78f98863ec6ad6cd07e75a0bfc2c0df2c8666` contains `bounded_halcmd_capture()`. On the normal child-exit path it does:

```bash
set +e
wait "$pid"
local rc=$?
set -e
printf '%s: after rc=%s\n' "$label" "$rc" >&2
return "$rc"
```

Callers try to protect the call with `set +e`, but shell options are global to the current shell. The helper's own `set -e` therefore overrides the caller before `return "$rc"`. If `rc != 0`, the non-zero function return can terminate the script immediately, before the caller records `HAL_RC=$?`.

A minimal Bash reproduction was run during the 2026-09-05T18:12:02Z curriculum session:

```bash
set -e
f() {
    set +e
    false
    rc=$?
    set -e
    echo before-return-$rc
    return "$rc"
}
set +e
f
echo caller-after-f-$?
```

Observed output ended after `before-return-1`; the shell exited with status 1 and never printed `caller-after-f-*`.

This means the earlier correction in `13063ce8...` fixed one `set -e` failure path but did not fully make the helper's error capture robust.

### Required correction before merge

Do not toggle global `errexit` inside the helper. Capture expected failures structurally:

```bash
if wait "$pid"; then
    rc=0
else
    rc=$?
fi
```

Likewise, callers that expect a non-zero probe status should use an `if` condition rather than `set +e`/`set -e` around the helper:

```bash
if bounded_halcmd_capture ...; then
    HAL_RC=0
else
    HAL_RC=$?
fi
```

The top-level final observations may remain ordinary commands so unexpected non-zero status still fails the experiment.

## Finding 2 — hard-killing a HAL-lock participant is diagnostically destructive

**Classification: SOURCE-CONFIRMED for lock implementation; INFERENCE for the exact state after any future killed probe until its stack is observed.**

Pinned source:

- [`src/hal/hal_lib.c::halpr_mutex_acquire()`](https://github.com/LinuxCNC/linuxcnc/blob/8bf4605ae81042248add031e94c77300406e0413/src/hal/hal_lib.c)
- [`src/hal/hal_lib.c::halpr_mutex_release()`](https://github.com/LinuxCNC/linuxcnc/blob/8bf4605ae81042248add031e94c77300406e0413/src/hal/hal_lib.c)
- [`src/hal/hal_lib.c::halpr_mutex_force_release()`](https://github.com/LinuxCNC/linuxcnc/blob/8bf4605ae81042248add031e94c77300406e0413/src/hal/hal_lib.c)
- [`src/rtapi/rtapi_mutex.h`](https://github.com/LinuxCNC/linuxcnc/blob/8bf4605ae81042248add031e94c77300406e0413/src/rtapi/rtapi_mutex.h)
- [`src/hal/hal_lib_extra.c::hal_mutex_force_release()`](https://github.com/LinuxCNC/linuxcnc/blob/8bf4605ae81042248add031e94c77300406e0413/src/hal/hal_lib_extra.c)

`halpr_mutex_acquire()` increments shared `hal_data->lockcnt` **before** a contender potentially waits in `rtapi_mutex_get_rd()`. If the contender is killed while blocked, normal `halpr_mutex_release()` cannot run to decrement that shared count. If a process is killed after acquisition while owning a recursion level, `locktid`, `locklvl`, `lockcnt`, and the reverse-default mutex may likewise remain inconsistent.

LinuxCNC contains an explicit `hal_mutex_force_release()` recovery API, but its own source warning says forced release "may crash the rest of the LCNC application(s)." That is recovery/debugging machinery, not permission to treat a post-kill HAL instance as clean evidence.

### Experiment consequence

The corrected `004` design is valid only if a timed-out `halcmd` is treated as a **terminal diagnostic branch** for that LinuxCNC instance:

1. capture the original live PID and its process state;
2. attempt the bounded GDB backtrace;
3. classify only what the observed stack actually proves;
4. terminate the stalled process with bounded TERM/KILL if needed;
5. immediately abort that topology experiment without issuing further HAL queries or promoting post-kill state as evidence;
6. let LinuxCNC/process cleanup tear down the instance.

The current prepared script already exits the readiness-timeout branch after killing the stalled probe, which is the correct evidence boundary. Future edits must preserve that property.

## Why the backtrace must precede the kill

`halcmd list comp` can block before list traversal, because `halcmd_startup()` calls `hal_init()` and HAL registration can acquire the same shared mutex later used by `hal_list_comp()`. Killing the probe first destroys the only direct evidence about which phase it occupied. Therefore the live-PID backtrace in `42a78f988...` remains the right diagnostic ordering, but it must be combined with the `errexit` correction above.

## Additional uncertainty: GDB attach is an observation, not a guaranteed capability

The script uses privileged, time-bounded `gdb -p` because hosted Ubuntu commonly enables ptrace restrictions. Until the next run actually returns a usable stack, attachment success is `UNKNOWN`. An attach failure must remain a diagnostic failure, not evidence that the process was in startup or list traversal.

## Adversarial checks for the next run

- A non-zero, non-timeout `halcmd` exit must be recorded rather than causing a silent early shell exit.
- A timeout must leave an `after rc=124` marker before the experiment exits.
- No topology conclusion may use HAL output obtained after forcibly killing a stalled lock participant.
- A GDB attach failure must not be translated into a blocking-site claim.
- The exact LinuxCNC revision and corrected curriculum head must be present in fresh result metadata before any observation is promoted.

## Next implementation step

Before merging `a01-bounded-observation` into `main`, replace the helper/caller `set +e`/`set -e` toggles with conditional status capture and preserve the live-PID-backtrace-then-terminal-abort behavior. No additional September 5 lab run is justified merely to test this Bash fix; the shell-control issue was reproduced locally and the paid laboratory budget is already exhausted.
