# Immutable curriculum timing queue

The repository's legacy `TIMING_APPEND_REQUEST.txt` is occupied by an older 2026-10-12 request. **Do not replace it to log a newer session.**

Each completed curriculum session can create a uniquely named `timing-queue/YYYYMMDDTHHMMSSZ-<topic>.row` containing exactly one Markdown table row matching `LESSON_LOG.md` (eight fields with surrounding pipe delimiters). Queue filenames are immutable and must not be reused or overwritten. Do not place hidden evaluation answers or secrets in timing rows.

The existing `.github/workflows/append-lesson-log.yml` processes the legacy request and all queue files on **`[self-hosted, openpressbrake]` only**, re-reading full `origin/main` on each attempt. It validates request shape, skips already present exact rows, appends to the complete canonical log and retries concurrent pushes. It never clears or overwrites requests. GitHub-hosted runners are prohibited.

**Evidence boundary:** a committed queue row is only a pending request. Verify the self-hosted workflow job and the resulting canonical `LESSON_LOG.md` before claiming the timing row was appended. If the runner is offline, leave the request queued and record the blocker. A malformed row stops the workflow; correct it by a new immutable request and an explicit documented disposition rather than silently rewriting the old one.

Do not alter `LAB_COMPUTE_LOG.md` without new authoritative job start/end metadata.
