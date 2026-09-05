# Active Curriculum Session

- Start UTC: `2026-09-05T14:13:04Z`
- End UTC: `2026-09-05T14:16:17Z`
- Module: `A01 Process/component architecture`
- State: `CLOSED`
- Outcome: Actions run `33965517203` was cancelled at 75 minutes, but decoded job logs prove the pinned LinuxCNC build had already launched `linuxcnc`, `linuxcncsvr`, `rtapi_app`, `milltask`, and `linuxcncrsh`. The blocker is now classified as a runtime-observation hang, with the unbounded external `halcmd` readiness probe the constrained working hypothesis.
- Next checkpoint: during the next lab-budget window, timeout-bound and progress-mark every `halcmd` probe, preserve partial run logs independently of shell-step completion, and run exactly one corrected `004`.

This file is a crash/concurrency marker. Closed sessions remain here until the next session overwrites the marker with its own start state.
