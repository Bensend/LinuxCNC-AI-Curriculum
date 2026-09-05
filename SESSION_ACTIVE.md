# Active Curriculum Session

- Start UTC: `2026-09-05T19:09:31Z`
- End UTC: `2026-09-05T19:12:35Z`
- Module: `A01 Process/component architecture`
- State: `CLOSED`
- Outcome: source audit found that pinned `linuxcnc.in` TERM handling enters `Cleanup()`, whose later `halcmd stop`, `halcmd unload all`, and `halcmd list comp` calls are not independently wall-clock bounded. The prepared `004` branch now independently bounds launcher teardown so a HAL-lock diagnostic cannot consume the result-publication window in its EXIT trap.
- Next checkpoint: after the September 5 lab budget resets, reconcile `a01-bounded-observation` with current `main`, preserve the bounded-probe, live-stack, lock-integrity, and bounded-cleanup corrections, re-audit all blocking/error paths, then allow exactly one corrected `004` run.

This file is a crash/concurrency marker. Closed sessions remain here until the next session overwrites the marker with its own start state.
