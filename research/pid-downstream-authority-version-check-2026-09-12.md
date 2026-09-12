# PID downstream-authority version check

Date: 2026-09-12
Status: **VERSION COMPATIBILITY CHECK**

## Question

Is the newly documented PID-authority boundary merely an artifact of the curriculum's pinned LinuxCNC revision, or is the relevant implementation still present on current upstream master?

## Revisions compared

Pinned curriculum source:

`8bf4605ae81042248add031e94c77300406e0413`

Current upstream `master` as retrieved on 2026-09-12.

File:

`src/hal/components/pid.c`

## Result

The GitHub blob SHA returned for `pid.c` is the same in both reads:

`b35b11a81733d5d5852134b1c3e35cded7295134`

Therefore the relevant `calc_pid()` implementation is byte-identical between the pinned curriculum revision and current upstream master at the time of this check.

The following conclusions are consequently version-confirmed across those two points:

- disabling stock `pid` resets `error_i` and forces output to zero;
- anti-windup uses `limit_state` from the PID block's own `maxoutput` clipping;
- `pid.N.saturated`, `saturated-s`, and `saturated-count` report that same internal limit state;
- no downstream brake, drive-enable, hydraulic-authority or later-limiter state enters this calculation unless external HAL explicitly changes the PID inputs/enable.

## Scope

This does not claim every historical LinuxCNC release has identical behavior. It records only that the source used by the curriculum and upstream master on 2026-09-12 are identical for this file.

## Curriculum consequence

The actuator-authority lesson does not need to be labeled a pinned-revision-only oddity. It is still current upstream behavior as of this audit. Machine-specific brake/drive/hydraulic sequencing remains separate and must not be inferred from stock PID semantics.
