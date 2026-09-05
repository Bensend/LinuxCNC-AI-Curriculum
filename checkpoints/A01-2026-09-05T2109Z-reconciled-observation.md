# A01 checkpoint — reconciled bounded-observation branch

Session start: `2026-09-05T21:09:47Z`  
Module: A01 process/component architecture  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Repository reconciliation performed

The previously isolated harness-audit branch `a01-harness-audit-20260905T2015Z` was a clean three-commit fast-forward from `main`; it has now been fast-forwarded into `main`. This preserves the merge-commit job-selection finding, its overlap timing row, and the harness-audit checkpoint without touching a lab-triggering path.

The latest actual A01 lab run remains Actions run `33965517203` at curriculum head `06c7bf7f0602fa577d20a00f92cef82527c61df2`. It was cancelled at the 75-minute ceiling and produced no valid fresh `004` topology assertions. No later A01 lab run exists as of this checkpoint, so no topology claim is promoted to `TEST-CONFIRMED`.

## Source verification added

Pinned LinuxCNC `src/emc/usr_intf/Submakefile` builds `../bin/linuxcncrsh` directly from the `EMCRSHSRCS` set including `src/emc/usr_intf/emcrsh.cc`. `emcrsh.cc` contains the program `main()` and identifies itself as source for `linuxcncrsh`. Therefore using the executable/process identity `linuxcncrsh` as the display-phase marker for the exact upstream `tests/linuxcncrsh` configuration is source-grounded rather than assuming a shell/Python wrapper name.

Evidence: `SOURCE-CONFIRMED` at `8bf4605ae81042248add031e94c77300406e0413`.

## Reconciled executable branch

Created `a01-reconciled-observation-20260905` from current `main` and staged the next corrected experiment there so September 5's consumed lab budget is not exceeded.

Current prepared commits:

- `acc881900951ee630d112b57fac776f53d8738fd` — reconciles the bounded HAL-probe/live-PID-GDB/lock-integrity/bounded-launcher-cleanup changes into `004` and adds a strict pre-HAL readiness gate requiring all of `linuxcncsvr`, `milltask`, and `linuxcncrsh`, with per-process progress markers. If the display phase is not reached, the experiment captures process/stdout/stderr evidence and exits without issuing an external HAL query.
- `44a721e774f7ab5a4a18d4e676912b400c32d8a3` — reconciles the 70-minute inner experiment timeout and replaces merge-unsafe single-commit `git diff-tree` job selection with push-range selection (`github.event.before` -> `GITHUB_SHA`). Multiple changed lab jobs fail closed instead of using `head -n 1`. The zero-before case uses an explicit root diff.

This branch is exactly two commits ahead of current `main` at this checkpoint and changes only `.github/workflows/lab-runner.yml` and `lab-jobs/004-a01-runtime-topology.sh`.

## Adversarial harness verification

A fresh synthetic Git repository reproduced the exact push-range selector behavior after the patch:

```text
before_after_count=1
before_after_files=lab-jobs/004-a01-runtime-topology.sh
ambiguous_count=2
ambiguous_files=lab-jobs/004-a01-runtime-topology.sh lab-jobs/005.sh
```

Thus a merge/push range introducing only corrected `004` selects exactly that job, while a range changing two jobs is detectably ambiguous and must be refused. This is `TEST-CONFIRMED` for the selector logic itself; it is not LinuxCNC runtime evidence.

## Timing-log integrity anomaly recovered

`main` contains a durable start marker for an A01 session beginning `2026-09-05T20:10:09Z`, but that session did not append its required end/timing row before a separate 20:15Z harness-audit session detected overlap. The later 20:15Z session did log its own `OVERLAP DETECTED` row and is now in `main`. Do not invent an end timestamp for the incomplete 20:10Z session; retain it as a timing-log integrity anomaly.

## Exact next checkpoint

1. Do not merge `a01-reconciled-observation-20260905` to `main` on September 5; the daily laboratory compute budget is already consumed.
2. At the next lab-budget window, first compare the prepared branch with then-current `main` and ensure it is still a clean fast-forward or reconcile any intervening non-lab research without dropping either prepared commit.
3. Re-audit the final two changed files for shell/YAML control-flow hazards under `set -euo pipefail`, especially return-code capture, GDB failure handling, forced-kill terminal behavior, launcher EXIT cleanup, and push-range job selection.
4. Advance `main` to the reconciled branch exactly once. That push should auto-trigger one `004`; do not dispatch a duplicate.
5. Verify the resulting workflow by explicit run ID, source SHA, and metadata naming `lab-jobs/004-a01-runtime-topology.sh` plus the three process-readiness markers.
6. If `linuxcncrsh` never becomes visible, treat the run as launcher-startup evidence and diagnose preserved launcher/process output; do not claim an external HAL stall because none should have been issued.
7. If a HAL probe stalls, classify only from the original live PID stack as startup/`hal_init`, `hal_list_*`, or `UNKNOWN`. A failed attach does not establish a stage. After a force-killed HAL participant, make no further HAL assertions against that instance.
8. If topology assertions complete without invalidation, reconcile process and HAL observations, write the A01 fresh-AI handoff, perform graduation review, and only then unlock R01.
