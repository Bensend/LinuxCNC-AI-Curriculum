# A01 checkpoint — concurrent-session harness audit

Session start: `2026-09-05T20:15:42Z`  
Module: A01 process/component architecture  
Working branch: `a01-harness-audit-20260905T2015Z`

## Concurrency state

At this session's start, `main` already contained `SESSION_ACTIVE.md` for another A01 session that began `2026-09-05T20:10:09Z`, plus commits at 20:12Z. This session therefore deliberately did not write its independent harness finding onto `main`; it isolated durable work on this branch. The lesson timing row must be marked `OVERLAP DETECTED`.

## New durable finding

`guides/A01-workflow-job-selection-boundary.md` demonstrates that the current push selector in `.github/workflows/lab-runner.yml` is unsafe when corrected `004` is integrated by a merge commit. The selector uses single-commit `git diff-tree` without merge-diff handling; official Git documentation says merge commits do not expose ordinary diff output by default, and a local no-ff-merge reproduction returned no changed lab path. The workflow would then fall back to `000-smoke`.

## Required correction before next paid run

1. Preserve all existing `a01-bounded-observation` corrections.
2. Preserve the concurrent 20:10Z session's launcher/display readiness correction: do not externally probe HAL until `linuxcncsvr`, `milltask`, and `linuxcncrsh` are observable.
3. Reconcile this branch's workflow-selection correction. For push events, select lab jobs over `github.event.before` -> `GITHUB_SHA`, not `git diff-tree GITHUB_SHA` on a potentially merged commit.
4. Fail closed if more than one lab job changed in the push; do not silently use `head -n 1` for a paid run.
5. Require the resulting workflow metadata to identify `lab-jobs/004-a01-runtime-topology.sh` and the intended reconciled source SHA before accepting any A01 result.
6. Do not launch another LinuxCNC lab on September 5; the daily compute budget remains consumed.

## Integration note

This branch was created from main commit `372d78928591e32f4e979b2ccc158a2909ff097a`. A later session should reconcile/cherry-pick the guide/checkpoint after the overlapping session is closed, rather than force-updating main while concurrency is visible.
