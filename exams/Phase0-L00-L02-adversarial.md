# Phase 0 Adversarial Exam — L00/L01/L02

Status: initial verified exam artifact; stable `v2.9.10` lab result may add corrections.

Development revision: `8bf4605ae81042248add031e94c77300406e0413`
Stable reference: `v2.9.10` / `86cdca76fa2a36274c432caa21952b23c267989a`

Purpose: test whether a fresh AI can reason about the curriculum laboratory, version discipline, LinuxCNC build/test entry points, and evidence boundaries without turning successful simulation into unsupported realtime claims.

## Questions

### Q1 — Misleading premise: “realtime-math passed, therefore realtime works”
Experiment `002` reports that `tests/realtime-math` passed 1/1. An engineer concludes: “The runner has now demonstrated that LinuxCNC meets realtime servo deadlines.” Diagnose every important flaw in that conclusion. State what the experiment *does* establish and what it does *not* establish.

### Q2 — Trace the selected test end-to-end
Starting with the command `runtests -n -p tests/realtime-math`, trace the execution path sufficiently to explain:

1. how `scripts/runtests` discovers the test;
2. why it dispatches this test as a shell script rather than a `.hal` test;
3. what the test script invokes;
4. where the compiled realtime component is installed in a RIP build;
5. how the component is then loaded;
6. how pass/fail returns to the harness.

Name concrete files and commands rather than giving only conceptual descriptions.

### Q3 — Version-sensitive failure diagnosis
A developer writes a helper that parses this exact summary suffix from the development harness:

`..., 0 skipped, 0 shmem errors`

They then run it against stable `v2.9.10` and report the test harness is broken because the suffix is absent. Is that diagnosis valid? Explain the source-level reason and the correct compatibility strategy.

### Q4 — Dirty shared-memory state
Suppose an upstream test exits but leaves a recognized LinuxCNC/HAL System V shared-memory segment behind. Compare what the inspected development harness does with what the inspected stable `v2.9.10` harness does. What evidence would you require before claiming the stable harness protects every test from stale shared-memory state?

### Q5 — Reproducibility attack
A curriculum guide says only “tested LinuxCNC 2.9.10.” Explain why that is weaker than the current L01 pin. List the minimum revision information needed to make a source conclusion or experiment reproducible, and explain why a branch name alone is insufficient.

### Q6 — Build boundary
`make` succeeds in a run-in-place uspace tree but prints a warning about privileges/capabilities. Should L00 mark the build failed? Under what conditions would that warning become relevant to a later realtime or hardware claim?

### Q7 — Harness race handling
Why does `scripts/runtests.in` wait for `result` and `stderr` to be closed before checking them? What class of false result could occur without that wait?

### Q8 — HAL-test retry trap
The harness contains special retry logic for `.hal` tests when the result contains exactly `overrun`. Does that mean all failing HAL tests are retried ten times? Explain the branch precisely.

### Q9 — Bounded modification task
Modify the curriculum lab design so a future experiment can compare one identical upstream test between stable and development without accidentally importing development harness behavior into stable. Describe the key rules the job must follow and identify at least two observations that should be captured for comparison.

### Q10 — Failure-path debugging
A future stable build compiles successfully, but `runtests tests/realtime-math` exits nonzero. Give a source- and artifact-driven debugging sequence that distinguishes at least these possibilities:

- test discovery failure;
- `halcompile` build/install failure;
- `halrun`/component-load failure;
- expected/checkresult mismatch;
- privilege/realtime fallback message that is not itself the test failure.

## Verified Answer Key

### A1
The conclusion is invalid. The GitHub Actions runner used by experiment `002` could not obtain `SCHED_FIFO`; LinuxCNC reported non-realtime POSIX fallback. The experiment is therefore `TEST-CONFIRMED` evidence for the pinned source being buildable in that runner, RIP environment resolution, `halcompile` compiling/linking/installing `rtmath`, HAL/RTAPI component loading through `halrun`, the selected upstream test's success path, and harness result/cleanup behavior observed in that run. It is **not** evidence for realtime scheduling, latency, deadline satisfaction, deterministic servo execution, or hardware-control suitability. The upstream test name “realtime-math” describes the API/component it checks, not proof that the host executed with realtime scheduling.

### A2
At the pinned development revision, generated `scripts/runtests` originates from `scripts/runtests.in`. `run_tests()` searches supplied paths for files named `test.hal`, `test.sh`, or `test`. `tests/realtime-math/test.sh` is found, so `run_test()` selects `run_shell_script()` for the `*.sh` case. That launches `bash -x test.sh`, capturing stdout to `result` and stderr to `stderr`. The upstream script executes `${SUDO} halcompile --install rtmath.comp`, which compiles/links the component and in RIP places its module in the RIP realtime library, then executes `halrun dotest.hal`; that HAL file loads `rtmath`. The shell exit status returns through `run_shell_script()` to `run_tests()`. If execution succeeded, the harness checks `checkresult` when present or compares `expected` to `result`; otherwise it records failure. Experiment `002` preserved a successful path and exit 0.

### A3
The diagnosis is invalid. The inspected development `scripts/runtests.in` contains `SHMERR`, `test_shmem()`, and `test_and_remove_shmem()` handling and includes the shmem-error count in its summary. The inspected `v2.9.10` harness does not contain that newer explicit path and its summary ends after the skipped count. Compatibility code must parse version-appropriate output or, better, rely primarily on process exit status plus structured/preserved artifacts rather than treating one branch's human-readable summary as a universal API.

### A4
On the pinned development revision, the harness checks recognized shared-memory keys before the test suite and checks/removes recognized leftovers after each test, counting `SHMERR` and failing hard when attached processes prevent safe cleanup. In the inspected `v2.9.10` harness, that explicit key table and pre/post `test_shmem`/`test_and_remove_shmem` path is absent. Therefore we may say the newer explicit protection is source-confirmed for the development revision and absent from the inspected stable harness. We may **not** infer from absence alone that no other stable code path can clean state, nor claim stable protects each test from stale state without source evidence or a fault-injection experiment.

### A5
“2.9.10” identifies a release but does not by itself prove which Git object was inspected or executed. L01 records the exact tag and dereferenced commit: `v2.9.10` -> `86cdca76fa2a36274c432caa21952b23c267989a`. Source conclusions and experiments should retain an immutable commit SHA, the tag/branch context when useful, and the exact test/build environment. A mutable branch such as `2.9` or `master` can advance after the experiment, making later source different from what was studied.

### A6
No. A successful uspace RIP software build is valid L00 build evidence even when the build warns that privileges/capabilities are required for hardware/realtime operation. The warning becomes material when a claim depends on realtime scheduling, memory locking, direct hardware access, or capabilities/setuid/setcap behavior. At that point the experiment must verify the actual runtime privileges and scheduling mode instead of borrowing the software-build success as evidence.

### A7
The harness waits because checking a file while the test process or pipeline still has it open creates a race: `checkresult`, `cmp`, or diagnostics could observe incomplete output and report a false mismatch or otherwise unstable result. `wait_for_result_close()` polls both preserved files with `lsof`, with a bounded timeout and warning path.

### A8
No. The retry loop belongs to `run_without_overruns()`, which is selected only for a discovered `*.hal` test. After each `halrun -f` execution it checks whether the `result` contains a line matching `^overrun$`. If no such line exists it returns that run's exit code immediately. Only the specific sampler-overrun marker triggers another attempt, up to ten tries; generic HAL failures do not automatically receive ten retries.

### A9
The stable job must check out the exact immutable stable commit and use *that checkout's* `debian/configure`, `src/configure`/Makefile, `scripts/rip-environment`, `scripts/runtests`, and upstream test files. It must not copy the development `runtests` into stable or normalize stable behavior by backporting development cleanup logic. The development comparison job should likewise use its own pinned checkout. Capture at minimum: resolved commit/tag/VERSION; build exit; harness identity/hash; selected test definition identity/hash; `runtests` exit/status summary; preserved test result/stderr; and relevant pre/post environment observations such as shared memory and realtime fallback messages. The jobs should state the prediction before execution and preserve discrepancies.

### A10
First confirm the exact checkout, generated `runtests` path, test path, and the harness's discovered test count. If zero tests ran, inspect the names and supplied path. If `test.sh` ran, inspect its preserved stderr/result: `halcompile --install rtmath.comp` diagnostics distinguish compile/link/install errors; a later `halrun dotest.hal` failure should be traced to module loading/HAL execution. If both commands exit successfully, inspect whether `checkresult` exists or `expected` comparison failed, and read the harness's stated reason. Separately classify scheduling/capability messages: a `SCHED_FIFO` denial with POSIX fallback is an evidence-boundary warning in this software lab unless it causes the actual command/test to exit nonzero. Do not label it the cause merely because it appears in stderr.

## Exam Self-Check / Corrections Trigger

The answer key was checked against:

- curriculum experiment `002` and its preserved observed behavior;
- development `scripts/runtests.in` at `8bf4605ae81042248add031e94c77300406e0413`;
- stable `scripts/runtests.in` at `86cdca76fa2a36274c432caa21952b23c267989a`;
- stable `tests/realtime-math/README` and `test.sh` at the same stable commit.

Correction still pending: incorporate any contradiction or additional compatibility issue revealed by stable experiment `003` before using this artifact as graduation evidence.
