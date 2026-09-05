# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

| Module | Status | Primary evidence | Experiment | Exam | Notes |
|---|---|---|---|---|---|
| L00 Codespaces laboratory | EXAM | GitHub Actions smoke/build/test results + official build docs + captured logs | `000-smoke` passed; `001-build-linuxcnc` passed; `002-upstream-realtime-math-test` passed in run `33949095338` | `exams/Phase0-L00-L02-adversarial.md` created with verified answer key | Lab runner preserves stdout/stderr/exit code, builds pinned LinuxCNC, and executes bounded upstream tests; current Actions runner falls back to POSIX non-realtime |
| L01 Version pinning | EXPERIMENT | `guides/L01-version-baseline.md`; official current-release docs; annotated `v2.9.10` tag dereference | development `8bf4605ae81042248add031e94c77300406e0413` built; stable `003` run `33952061943` in progress | covered by Phase-0 exam | Stable reference is `v2.9.10` commit `86cdca76fa2a36274c432caa21952b23c267989a`; tag object dereference and exact-version discipline documented |
| L02 Repository/build/test map | EXAM | `guides/L02-build-test-map.md`; `guides/L02-representative-test.md`; `src/Makefile`; stable/development `scripts/runtests.in` | `002` ran upstream `tests/realtime-math`: 1/1 successful, exit 0, zero shmem errors on development | `exams/Phase0-L00-L02-adversarial.md` | Representative harness path verified; development has explicit shmem hygiene absent from inspected 2.9.10 harness; realtime scheduling not tested by Actions fallback |
| L03 Evidence/claims workflow | EXAM | `SOURCE_POLICY.md`; `guides/L03-evidence-claims-workflow.md`; worked stable-vs-development conflict | Phase-0 experiments exercise prediction/observation and evidence narrowing | Phase-0 exam includes evidence-boundary attacks | Formal claim record, conflict protocol, version comparison rule, and fresh-AI evidence checklist committed |
| A01 Process/component architecture | PLANNED | — | — | — | Critical path; blocked until Phase 0 corrections/handoff |
| R01 Realtime model | PLANNED | — | — | — | Critical path |
| H01 HAL architecture | PLANNED | — | — | — | Critical path |
| H04 HAL execution ordering | PLANNED | — | — | — | Critical path |
| M03 One servo-period trace | PLANNED | — | — | — | Critical path |
| HM01 HostMot2 architecture | PLANNED | — | — | — | Critical path |
| E01 hm2_eth architecture | PLANNED | — | — | — | Critical path |
| HM08 HostMot2 watchdog | PLANNED | — | — | — | Critical path |
| IO01 Encoder path | PLANNED | — | — | — | Critical path |
| IO04 PWM/PDM path | PLANNED | — | — | — | Critical path |

## Current checkpoint

This session launched `lab-jobs/003-stable-v2.9.10-baseline.sh` at curriculum commit `42f5a295c8364d529102dd18793707a6f0cf9f57`; GitHub Actions run `33952061943` is still executing the lab job at the current checkpoint. The job checks out exact stable commit `86cdca76fa2a36274c432caa21952b23c267989a`, verifies the `v2.9.10` tag, builds that checkout as a uspace RIP tree on the same runner class used for development, and runs the stable checkout's own `tests/realtime-math` through the stable checkout's own `scripts/runtests`. Development harness behavior is deliberately not transplanted into stable.

Version evidence was strengthened in `guides/L01-version-baseline.md`: GitHub's annotated tag `v2.9.10` points through tag object `4e7abeab3e764a42ef9def932333a1d4004e547b` to commit `86cdca76fa2a36274c432caa21952b23c267989a`. Official LinuxCNC material identifies 2.9.10 as the current release; the release announcement also records that 2.9.9 was withdrawn after a bug-fix compatibility regression, reinforcing the need for exact version discipline.

The first Phase-0 adversarial exam is committed as `exams/Phase0-L00-L02-adversarial.md`. It attacks the misleading premise that a passing test named `realtime-math` proves realtime scheduling, requires an end-to-end harness trace, tests stable-vs-development output differences and shared-memory hygiene, and includes bounded lab-modification and failure-diagnosis tasks. Its answer key is checked against the pinned source and experiment `002`; it explicitly requires correction if `003` reveals contradictory evidence.

L03 is now represented by `guides/L03-evidence-claims-workflow.md`, which formalizes falsifiable claim records, evidence classes, conflict handling, prediction-before-test, experimental boundaries, negative-source-evidence limits, version comparison rules, and a fresh-AI handoff checklist. The worked example preserves the version-sensitive `scripts/runtests.in` shared-memory behavior rather than smoothing it into a universal claim.

### Preserved development experiment evidence

Actions run `33949095338`, triggered by curriculum commit `c2eb8e5a01a9360586281ac8352e8a5e94de3226`, completed successfully against LinuxCNC development revision `8bf4605ae81042248add031e94c77300406e0413`:

- `Runtest: 1 tests run, 1 successful, 0 failed + 0 expected, 0 skipped, 0 shmem errors`.
- `runtests exit status: 0`.
- `halcompile` compiled `rtmath.c`, linked `rtmath.so`, and copied it into the RIP `rtlib` directory.
- `halrun` loaded the component through the upstream test.
- pre-test and post-test `ipcs -m` snapshots listed no System V shared-memory segments.
- the Actions environment lacks realtime scheduling capabilities; LinuxCNC reported failed `SCHED_FIFO` setup and fell back to POSIX non-realtime execution. This is software-lab evidence and must not be reused as R01/R02 realtime evidence.

## Next lesson / exact resume point

1. Inspect Actions run `33952061943` and the committed `lab-results/LATEST*` files once the stable `003` job completes.
2. If `003` fails, diagnose the exact stable build/test incompatibility from preserved stdout/stderr and patch only the curriculum wrapper when justified; do not alter stable LinuxCNC merely to force a pass.
3. If `003` passes, update `guides/L01-version-baseline.md` and `guides/L02-build-test-map.md` with stable observed behavior, including the stable harness summary and any scheduling fallback differences.
4. Run the Phase-0 adversarial exam as a correction/handoff pass: identify any answer that overclaims evidence, patch guides/claims, and record explicit graduation evidence for L00-L03.
5. Only after Phase 0 survives that corrections/handoff pass should A01 process/component architecture enter `RESEARCH`.

The complete module graph is maintained in `CURRICULUM.md`. Add rows here as modules enter active work rather than using this file as a duplicate syllabus.
