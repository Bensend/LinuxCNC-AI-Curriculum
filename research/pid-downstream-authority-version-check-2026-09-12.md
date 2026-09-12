# PID / joint-authority version check

Date: 2026-09-12
Status: **VERSION COMPATIBILITY CHECK**

## Question

Are the newly documented PID-authority and homed-extra-joint fault-witness boundaries merely artifacts of the curriculum's pinned LinuxCNC revision, or are the relevant implementations still present on current upstream master?

## Revisions compared

Pinned curriculum source:

`8bf4605ae81042248add031e94c77300406e0413`

Current upstream `master` as retrieved on 2026-09-12.

Files:

- `src/hal/components/pid.c`
- `src/emc/motion/control.c`

## Result — PID implementation

The GitHub blob SHA returned for `pid.c` is the same in both reads:

`b35b11a81733d5d5852134b1c3e35cded7295134`

Therefore the relevant `calc_pid()` implementation is byte-identical between the pinned curriculum revision and current upstream master at the time of this check.

The following conclusions are consequently version-confirmed across those two points:

- disabling stock `pid` resets `error_i` and forces output to zero;
- anti-windup uses `limit_state` from the PID block's own `maxoutput` clipping;
- `pid.N.saturated`, `saturated-s`, and `saturated-count` report that same internal limit state;
- no downstream brake, drive-enable, hydraulic-authority or later-limiter state enters this calculation unless external HAL explicitly changes the PID inputs/enable.

## Result — joint authority / extra-joint fault witnesses

The GitHub blob SHA returned for `src/emc/motion/control.c` is also the same in both reads:

`2ddf587b484919057821c65f1d4a9392a6d69f06`

Therefore the relevant motion-control implementation is likewise byte-identical between the pinned revision and current master at this check. In particular:

- a homed extra joint still has `joint->ferror` explicitly forced to zero as `not relevant for homed extrajoints`;
- hard-limit and `amp_fault` inputs are still read separately;
- enabled-joint amplifier fault still sets the joint error and drives `emcmotInternal->enabling = 0`;
- the disable transition still clears active joint enable flags and motion enable;
- the joint enable flag is still published to `joint.N.amp-enable-out`.

## Scope

This does not claim every historical LinuxCNC release has identical behavior. It records only that the source used by the curriculum and upstream master on 2026-09-12 are identical for these two files.

## Curriculum consequence

The actuator-authority and homed-extra-joint witness lessons do not need to be labeled pinned-revision-only oddities. They are still current upstream behavior as of this audit. Machine-specific brake/drive/hydraulic sequencing, post-home tracking supervision and safety behavior remain separate and must not be inferred from stock PID/MOTMOD semantics.
