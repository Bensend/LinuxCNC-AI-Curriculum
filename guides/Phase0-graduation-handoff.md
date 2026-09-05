# Phase 0 Graduation and Fresh-AI Handoff — L00/L01/L02/L03

Date verified: 2026-09-05

Development baseline: `8bf4605ae81042248add031e94c77300406e0413` (`2.10.0~pre1`, master context)

Stable baseline: `v2.9.10` → `86cdca76fa2a36274c432caa21952b23c267989a`

## Purpose

This artifact is the explicit fresh-AI handoff/graduation gate for the laboratory, versioning, repository/build/test-map, and evidence-method modules. A fresh agent should be able to resume LinuxCNC architecture work without relying on conversation history and without importing unsupported realtime claims from the cloud laboratory.

## Fresh-AI operating contract

Before doing source-level LinuxCNC work:

1. Read `START_HERE.md`, `MASTER_MISSION.md`, `CURRICULUM.md`, `SOURCE_POLICY.md`, `MODULE_TEMPLATE.md`, and `PROGRESS.md`.
2. Pin every LinuxCNC source conclusion to an immutable commit. Record tag/branch context separately.
3. Use development `8bf4605...` for the current development baseline and stable `86cdca76...` when stable comparison matters until L01 is intentionally refreshed.
4. Treat GitHub Actions as a reproducible software lab, not as realtime-machine qualification.
5. Record predictions before experiments and observations afterward.
6. Do not normalize version differences away. Preserve them and classify their evidence.
7. Treat human-readable test-harness output as revision-sensitive unless source establishes a stable interface.

## Reproducible laboratory path

The lab has demonstrated these bounded paths:

### Development build

- `lab-jobs/001-build-linuxcnc.sh`
- run `33943964198`
- configures/builds a uspace RIP tree and resolves LinuxCNC/HAL/test tools
- exit `0`

### Development representative test

- `lab-jobs/002-upstream-realtime-math-test.sh`
- run `33949095338`
- upstream `tests/realtime-math`
- harness summary: `1 tests run, 1 successful, 0 failed + 0 expected, 0 skipped, 0 shmem errors`
- exit `0`
- LinuxCNC could not establish `SCHED_FIFO` and fell back to POSIX non-realtime

### Stable representative test

- `lab-jobs/003-stable-v2.9.10-baseline.sh`
- run `33952061943`
- exact checkout `86cdca76fa2a36274c432caa21952b23c267989a`
- stable checkout's own build scripts, RIP environment, harness, and test definition
- harness summary: `1 tests run, 1 successful, 0 failed + 0 expected, 0 skipped`
- exit `0`
- `Note: Using POSIX non-realtime`

A fresh agent can reproduce the selected test by reading the job scripts and preserved `lab-results` artifacts. If a later runner changes behavior, preserve the new result rather than overwriting the older claim's version/environment scope.

## Source-level harness model a fresh AI must retain

At both pinned revisions, `scripts/runtests.in` discovers `test.hal`, `test.sh`, and executable `test` files. Shell tests are run via Bash; HAL tests are run with `halrun -f` and have a special retry only when output contains the exact overrun marker. The harness waits for captured `result`/`stderr` files to close before validating them to avoid races.

The important version difference is shared-memory hygiene and summary output:

- development has an explicit recognized-key pre/post shared-memory check/removal path and counts `SHMERR` in the summary;
- stable v2.9.10 lacks that inspected explicit path and its summary ends after skipped tests.

Experiment `003` confirms that a stable test can pass normally without the development shmem-summary suffix. Code that assumes that suffix is universal is incorrect.

## Adversarial corrections pass

The Phase-0 adversarial exam was rechecked after experiment `003`.

### Misleading premise survived

A passing upstream test named `realtime-math` still does not demonstrate realtime scheduling. Both stable and development passed the representative test while executing in POSIX non-realtime mode in Actions. This is the primary evidence-boundary trap a fresh AI must reject.

### Version-output premise survived

The stable experiment produced the older summary format predicted by source. Therefore the answer warning against parsing a development-only `0 shmem errors` suffix as a universal interface is experimentally strengthened.

### Shared-memory claim narrowed

Both wrapper-level post-test `ipcs -m` observations were clean. That observation does not prove the stable harness has the development cleanup mechanism. Source establishes the mechanism difference; the bounded experiment establishes only the observed post-test state.

### No forced source modification

The stable build/test required no patch to LinuxCNC stable source. The job used native stable behavior and passed. This avoids the common reproducibility error of making an old revision mimic a new one before measuring it.

## Representative failure diagnosis a fresh AI should be able to perform

If a future `realtime-math` job fails:

1. Confirm exact commit/tag and generated harness path.
2. Confirm discovery: `test.sh` should be found below `tests/realtime-math`.
3. Read preserved `result` and `stderr` instead of inferring from workflow color alone.
4. Separate `halcompile --install rtmath.comp` compile/link/install failures from later `halrun dotest.hal` load/execution failures.
5. If commands exit zero, inspect `checkresult`/`expected` behavior in the applicable harness revision.
6. Classify realtime capability messages separately: POSIX fallback is an evidence limitation unless it is the actual cause of nonzero test execution.
7. Check pre/post shared-memory state, but distinguish wrapper observations from harness cleanup mechanisms.

## Bounded change competence

A fresh AI may add a new cross-version comparison experiment only if it:

- pins both revisions immutably;
- uses each checkout's own build scripts, `rip-environment`, harness, and test definition;
- records the expected behavior before running;
- captures exact exit status, native summary, per-test result/stderr, version identity, and relevant environment state;
- does not copy development harness behavior into stable merely to make output identical;
- marks scheduling/realtime conclusions as untested unless the runtime actually establishes the needed realtime environment and measurements.

This is sufficient bounded-change competence for Phase 0. Realtime qualification itself belongs to R01/R02/R04 and may require a different environment.

## Open questions intentionally carried forward

- What subset of the full upstream LinuxCNC test suite is appropriate/reliable on the current non-realtime Actions runner?
- What concrete realtime environment should later R01/R02 experiments use to establish scheduling behavior rather than fallback behavior?
- Are there stable-version cleanup mechanisms outside the inspected `scripts/runtests.in` path that matter to particular tests? Do not answer from absence; investigate if later work depends on it.

These do not block A01 process/component architecture because A01 can study runtime boundaries without claiming realtime deadline behavior.

## Graduation decision

### L00 — GRADUATED

The laboratory has a demonstrated build path, a demonstrated upstream test path, preserved result artifacts, failure-diagnosis experience, and an explicit non-realtime boundary.

### L01 — GRADUATED

Stable and development revisions are immutably pinned, stable tag dereference is recorded, both baselines are experimentally buildable/testable in the software lab, and version-sensitive behavior is preserved rather than generalized.

### L02 — GRADUATED

The build-oriented repository map and real upstream harness execution path are source-traced and experimentally verified on both baselines. The guide explicitly stops short of inventing runtime architecture boundaries.

### L03 — GRADUATED

The evidence-classification/conflict workflow has been exercised on a real stable-vs-development difference and on a misleading realtime inference. The correction pass preserves source, test, documentation, community, inference, and unknown boundaries.

## What this graduation does not mean

Phase 0 graduation does not mean the curriculum has established LinuxCNC realtime determinism, hardware suitability, functional safety, complete test-suite compatibility, motion semantics, HAL execution order, or HostMot2 behavior. Those remain later modules.

## Next lesson

Enter **A01 — process/component architecture** at `RESEARCH`.

The first A01 lesson should establish intended architecture from official LinuxCNC documentation and developer/design documents, search developer/community discussions for architecture-boundary traps, then inspect the pinned development source for executable/process entry points and major inter-process interfaces. Produce a runtime architecture map distinct from L02's build-directory map. High-priority boundaries include LinuxCNC launcher/startup, task, motion, interpreter, HAL, UI, and NML, with exact process/thread context and version scope preserved.
