# Lesson-log append race repair — 2026-09-10

## Problem

The missing 2026-09-10 15:11:23Z lesson row was not absent because the row failed validation. Append workflow run `34513380226` successfully validated the request and created a local commit, but its push was rejected as non-fast-forward because `main` advanced concurrently.

## Evidence

- Failing workflow: `34513380226`, attempt 2, job `102992923281`.
- Validation/append step: PASS.
- Commit step created local commit `e8e565b` containing one LESSON_LOG insertion.
- Push failed with `! [rejected] main -> main (non-fast-forward)`.
- Therefore the defect was a repository-write race in the append harness, not a malformed timing row.

## Correction

`.github/workflows/append-lesson-log.yml` now:

1. serializes append jobs with an `append-lesson-log` concurrency group;
2. captures the requested row from the triggering commit before synchronization;
3. fetches and resets onto the latest `origin/main` before each append attempt;
4. checks idempotently whether the exact row is already present;
5. retries a rejected push up to five times, rebuilding the append on the newest `main` each time.

This preserves the triggering row even if a newer timing request has subsequently replaced `TIMING_APPEND_REQUEST.txt` on `main`.

## Verification

The repaired workflow was exercised immediately by re-requesting the missing 15:11 row. Workflow `34518966286` completed successfully, and `LESSON_LOG.md` now contains the exact 2026-09-10T15:11:23Z–15:13:30Z row.

## Study-method lesson

Durable evidence appenders that run concurrently with autonomous curriculum commits must be designed as idempotent merge/retry operations. A one-shot `git push` after checkout is not sufficient evidence-retention infrastructure when the repository is being updated by overlapping actors.

## Next checkpoint

Preserve S02/E20/X01/X02 as technically accepted but fresh-AI-handoff pending. F02 remains blocked by information separation. Until a genuinely fresh evaluator is available, continue dependency-safe evidence/integrity maintenance; `LAB_COMPUTE_LOG.md` currently reports exactly backfilled compute of 180.65 min (3.01 h), with C06-040 intentionally uncounted absent a positive execution witness.
