# A01 — GitHub Actions lab-job selection boundary

Session start: `2026-09-05T20:15:42Z`  
Module: A01 process/component architecture / experiment-harness audit

## Scope

This note audits the curriculum runner that will launch the next corrected `004-a01-runtime-topology.sh`. It is experiment-integrity work: a perfectly corrected `004` script is useless if the workflow push handler accidentally selects a different lab job.

## Finding — current push selection is merge-commit unsafe

**SOURCE-CONFIRMED (curriculum harness).** Current `.github/workflows/lab-runner.yml` selects the push-triggered lab with:

```bash
git diff-tree --no-commit-id --name-only -r "${GITHUB_SHA}" -- 'lab-jobs/*.sh'
```

and falls back to `lab-jobs/000-smoke.sh` when that command reports no changed lab script.

**DOC-CONFIRMED.** Git documentation states that merge commits do not show diff output by default unless a merge-diff mode is explicitly requested. The `git diff-tree` documentation likewise documents `-m` as the option that shows differences for merge commits.

**TEST-CONFIRMED (local harness reproduction).** A toy repository was created with a feature branch adding `lab-jobs/004.sh`, an independent main-branch commit, and a `--no-ff` merge. On the resulting merge commit:

```text
single-commit diff-tree:
<no paths>
first-parent explicit range:
lab-jobs/004.sh
first-parent tree pair:
lab-jobs/004.sh
```

Therefore the current selector can silently choose `000-smoke.sh` if the corrected A01 branch is integrated into `main` as a merge commit. That would consume a workflow invocation while producing the wrong experiment and could be misread if only generic `LATEST.*` were inspected.

## Required correction

For a `push` event, determine changed lab jobs over the pushed range (`github.event.before` -> `GITHUB_SHA`) rather than asking a single merge commit for its default diff. A suitable fail-closed pattern is:

```bash
BEFORE="${{ github.event.before }}"
mapfile -t JOB_FILES < <(
    git diff --name-only "$BEFORE" "$GITHUB_SHA" -- 'lab-jobs/*.sh'
)

case "${#JOB_FILES[@]}" in
    0) JOB_FILE="lab-jobs/000-smoke.sh" ;;
    1) JOB_FILE="${JOB_FILES[0]}" ;;
    *)
        printf 'Multiple lab jobs changed in one push; refusing ambiguous auto-selection:\n' >&2
        printf '  %s\n' "${JOB_FILES[@]}" >&2
        exit 4
        ;;
esac
```

The initial all-zero `before` SHA should be handled explicitly if the repository ever needs first-push support; this repository is already established, so that is not on the critical A01 path.

Failing when more than one lab job changed is preferable to `head -n 1`: the next A01 run is intentionally limited to exactly one corrected `004`, and silently choosing an arbitrary first file violates that budget/evidence contract.

## Adversarial checks

1. **Misleading premise:** “The workflow triggers on a change to `lab-jobs/004`, therefore it must execute `004`.”  
   **Correction:** trigger-path filtering and in-job file selection are separate. A merge push can satisfy the workflow path filter while the current `git diff-tree <merge>` selector returns no lab path and falls back to smoke.

2. **Misleading premise:** “Adding `-m` is always the best fix.”  
   **Correction:** `-m` can emit differences against multiple parents and complicate duplicate/ambiguous selection. For a push-triggered runner, the event’s before/after range directly represents what the push introduced to the branch.

3. **Failure interpretation:** a successful `000-smoke` immediately after integrating corrected `004` is not evidence that topology passed or even ran. The run metadata must identify `lab-jobs/004-a01-runtime-topology.sh` and the intended source SHA.

4. **Multiple-job push:** auto-running the lexicographically first changed lab is not acceptable for a paid experiment. Refuse ambiguity and require an explicit workflow dispatch or a narrower integration commit.

## Evidence boundary

- `SOURCE-CONFIRMED`: current curriculum workflow uses single-commit `git diff-tree` plus smoke fallback.
- `DOC-CONFIRMED`: Git merge commits do not show ordinary diff output by default without merge-diff handling.
- `TEST-CONFIRMED`: local no-ff merge reproduction returned no path from the current selector while explicit before/after and first-parent comparisons returned the new lab script.
- `UNKNOWN`: how the next corrected branch will ultimately be integrated (merge commit, squash, rebase, or direct contents update). The runner should not depend on that choice.

## Next checkpoint

Before the next paid A01 run, reconcile this correction with the existing `a01-bounded-observation` fixes and the new launcher/display-readiness correction. The final main-branch integration must ensure that the push handler unambiguously selects `004`; then verify the resulting workflow run by explicit run ID, job file, and source SHA rather than by generic `LATEST.*`.
