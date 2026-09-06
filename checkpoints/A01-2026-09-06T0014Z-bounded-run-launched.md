# A01 checkpoint — corrected bounded topology run launched

- Session start UTC: `2026-09-06T00:14:59Z`
- Module: A01 — process/component architecture
- LinuxCNC source revision under test: `8bf4605ae81042248add031e94c77300406e0413`
- Curriculum merge commit under test: `5a8fa43fcb162a0cbc1a8a1a0472e5e6d5458445`
- GitHub Actions run: `34000879408`
- Job: `101399404407`
- Lab script: `lab-jobs/004-a01-runtime-topology.sh`

## Work completed

The September 6 UTC laboratory budget window is open. The prepared bounded-observation branch was compared against current `main` through PR #1. GitHub reported exactly two changed files, and direct diff inspection confirmed they were only:

- `.github/workflows/lab-runner.yml`
- `lab-jobs/004-a01-runtime-topology.sh`

The delta preserved current main-side guides, checkpoints, progress, lesson history, and session state. PR #1 was merged once using merge commit `5a8fa43fcb162a0cbc1a8a1a0472e5e6d5458445`.

The merge triggered exactly one new LinuxCNC Lab Runner execution: run `34000879408`, job `101399404407`. At checkpoint time, checkout and `Select lab job` have completed successfully and `Run lab job and capture complete output` is in progress. No duplicate run was dispatched.

## Acceptance criteria

Do not promote A01 runtime topology to `TEST-CONFIRMED` unless the resulting artifact shows all of the following:

1. Metadata names `lab-jobs/004-a01-runtime-topology.sh` and source commit `5a8fa43fcb162a0cbc1a8a1a0472e5e6d5458445`.
2. Process-readiness markers for `linuxcncsvr`, `milltask`, and `linuxcncrsh`, followed by the all-required-processes marker.
3. No force-killed HAL probe before topology assertions. If a probe is force-killed, all later HAL evidence from that instance is invalid.
4. Execution reaches `Key component assertions`.
5. `iocontrol.0`, `motmod`, and `trivkins` are present in the bounded component listing.
6. Exactly one `milltask` process is observed and no standalone `iocontrol` executable is observed.
7. `halcmd show comp iocontrol.0` yields exactly one userspace component row whose HAL-recorded PID equals the sole live `milltask` PID.

If a bounded `halcmd` stalls, classify the blocking stage only from the captured original-PID stack: `hal_init`/startup, `hal_list_*`, or `UNKNOWN`. A failed or incomplete GDB attach does not justify selecting either stage.

## Exact next work

Inspect run `34000879408` and its committed/artifact output; do not launch another lab while it is active. If it passes all acceptance criteria, reconcile the observations into the A01 evidence ledger, write a fresh-AI handoff, perform graduation review, and unlock R01 only if A01 actually graduates. If it fails, diagnose from the last preserved marker/backtrace and correct only the demonstrated defect before deciding whether another run is justified within the September 6 budget.
