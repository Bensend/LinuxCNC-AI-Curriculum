# A01 final pre-run audit — 2026-09-05T22:11Z

## Scope

A01 remains in EXPERIMENT at LinuxCNC development revision `8bf4605ae81042248add031e94c77300406e0413`. No September 5 laboratory compute is launched by this checkpoint.

## Reconciliation performed

A fresh branch, `a01-ready-next-budget-20260905T2211Z`, was created from current `main` and the two executable changes from the earlier divergent prepared branch were reapplied deliberately rather than merged blindly:

- `lab-jobs/004-a01-runtime-topology.sh`: three-process readiness (`linuxcncsvr`, `milltask`, `linuxcncrsh`), bounded HAL probes, original-PID state/GDB capture before forced termination, terminal evidence boundary after a forced HAL-probe kill, and bounded launcher cleanup.
- `.github/workflows/lab-runner.yml`: push-range lab selection, fail-closed handling for multiple changed lab scripts, a 70-minute inner experiment timeout inside the 75-minute job ceiling, stale-LATEST deletion, and publication paths that do not depend on a successful experiment exit.

This branch is based on current `main`, so the previous 2-ahead/2-behind divergence is eliminated as a merge prerequisite.

## Control-flow audit

The corrected `004` was re-read under `set -euo pipefail` with the following boundaries checked:

1. Process readiness issues no `halcmd` until all three required userspace processes have been observed.
2. Expected nonzero HAL probe statuses are captured through `if ...; then ... else rc=$?; fi`, avoiding the prior global-errexit loss path.
3. Every externally issued `halcmd` goes through `bounded_halcmd_capture`; a timeout captures the original PID before TERM/KILL.
4. A timeout during HAL readiness exits immediately, so no post-force-kill HAL assertion is accepted as topology evidence.
5. Later component/function probes execute under `set -e`; any nonzero/timeout aborts before `Key component assertions` can be mistaken for successful evidence.
6. The EXIT trap disables itself first, bounds launcher TERM handling, snapshots a still-live launcher, then uses KILL only for publication containment.
7. Workflow selection uses the push event's `before -> GITHUB_SHA` range. A push containing one changed lab script selects that script even when the new head is a merge commit; multiple changed lab scripts fail closed.
8. The experiment has a 70-minute inner wall-clock limit, preserving nominal time inside the 75-minute Actions job ceiling for result publication.

## Additional shell-process verification

Bash documentation confirms `wait PID` returns the saved child status and Bash retains status for terminated asynchronous children. The monitor therefore may poll liveness and then `wait "$pid"` to recover the actual `halcmd` status. This does not change the evidence rule: a monitor timeout is diagnostic failure, not topology evidence.

## Remaining uncertainty

- GDB attach may be prohibited or incomplete on the hosted runner. A failed/empty backtrace does not localize the HAL stall.
- A force-killed HAL participant can invalidate the instance for subsequent HAL evidence; the script exits on that path.
- The exact cause of run `33965517203` remains `UNKNOWN`; the corrected experiment is intended to localize it, not assume it.

## Exact next checkpoint

After the laboratory daily budget resets, compare `a01-ready-next-budget-20260905T2211Z` to current `main`. If only the intended lab/workflow changes remain, advance `main` exactly once from that branch and allow the push-triggered runner to launch exactly one `004`. Record the workflow run ID and source SHA. Do not dispatch a duplicate.

Accept topology evidence only if fresh metadata names `004-a01-runtime-topology`, the source SHA is the newly advanced `main`, all three process-readiness markers occur, no HAL probe was force-killed before assertions, and `Key component assertions` executes. If valid, reconcile the observed process/HAL topology against the A01 source guide, write the fresh-AI handoff, and perform graduation review. If the run fails, diagnose from its last progress marker and captured live-PID evidence before considering another run.
