# A01 — Runtime Topology Lab Validity and Fallback Design

Primary LinuxCNC development revision: `8bf4605ae81042248add031e94c77300406e0413`

Status: source-grounded experiment design; runtime observations remain pending until a fresh `004-a01-runtime-topology` run reaches its assertions.

## Purpose

A01 needs one bounded runtime observation to test source-derived architectural claims without turning laboratory infrastructure behavior into LinuxCNC architecture evidence. Two earlier `004` attempts reached the workflow ceiling during a full source build before the topology assertions ran. A third hardened attempt, Actions run `33965517203`, was still executing when this guide was written.

This guide defines exactly what counts as valid A01 runtime evidence and the fallback if a full rebuild remains too expensive.

## Evidence boundary

A valid `004` result can test only the runtime process/component topology of the selected upstream simulation at the pinned revision. It cannot establish realtime scheduling quality, latency, physical-machine suitability, functional safety, or behavior of other LinuxCNC revisions.

For this experiment, a green GitHub Actions workflow is not by itself evidence. The result must contain fresh metadata and actual assertion output produced after the current job began.

## Configuration-under-test source trace

The experiment launches upstream `tests/linuxcncrsh/linuxcncrsh-test.ini`.

That INI explicitly selects:

- `[DISPLAY] DISPLAY = linuxcncrsh -n RuntimeTestMachine`
- `[TASK] TASK = milltask`
- `[EMCMOT] EMCMOT = motmod`
- `[HAL] HALFILE = lcncrsh_sim.hal`
- `[KINS] KINEMATICS = trivkins`

The paired `tests/linuxcncrsh/lcncrsh_sim.hal` then loads the configured kinematics and motion modules, plus `ddt` and `hypot`, and wires the tool-change/estop loopback through `iocontrol.0.*` pins. It adds `motion-command-handler` and `motion-controller` to `servo-thread`.

Classification: `SOURCE-CONFIRMED` at `8bf4605...`.

## What the runtime assertions are actually testing

The current `004` job waits until `halcmd list comp` contains `iocontrol.0`, then records `ps`, `halcmd list comp`, and `halcmd list funct` and asserts:

1. `iocontrol.0` exists as a HAL component.
2. `motmod` exists as a HAL component.
3. `trivkins` exists as a HAL component.
4. no executable process named exactly `iocontrol` exists.
5. `milltask` exists as an OS process.
6. `linuxcncsvr` exists as an OS process.

These observations are intentionally paired with source evidence rather than interpreted alone. `src/emc/task/Submakefile` links `taskclass.cc` into `../bin/milltask`; the A01 source trace shows `Task::Task()` calling `hal_init("iocontrol.0")`. Therefore the expected observation—`milltask` process plus `iocontrol.0` HAL component with no standalone `iocontrol` process—tests the source-derived ownership model rather than inferring ownership from a component name.

Classification before a successful run: source claims are `SOURCE-CONFIRMED`; the predicted runtime observations remain `INFERENCE` until the assertions execute.

## Freshness requirements

Reject a run as A01 topology evidence unless all of these are true:

- the workflow source SHA is the intended curriculum commit;
- the job name is `004-a01-runtime-topology`;
- the job output prints the pinned LinuxCNC commit `8bf4605ae81042248add031e94c77300406e0413`;
- the `Key component assertions` section is present, proving execution reached the observation stage;
- `LATEST.*` metadata timestamps belong to the current run;
- no result was inherited from repository checkout.

The runner now deletes checked-out `LATEST.*` before executing a job, specifically because a cancelled earlier run demonstrated that `if: always()` publication could otherwise upload stale prior evidence.

## Why a full LinuxCNC build is not itself part of the A01 claim

A01 needs binaries that faithfully correspond to the pinned upstream source and configuration. It does not require every unrelated LinuxCNC target to be rebuilt for every topology observation.

The build graph makes this distinction explicit. `src/emc/task/Submakefile` has concrete targets for `../bin/linuxcncsvr` and `../bin/milltask`; `milltask` depends on the Task/motion-interface objects and the required LinuxCNC/NML/interpreter libraries. The test configuration separately requires the launcher/runtime infrastructure, `motmod`, `trivkins`, `ddt`, `hypot`, `halcmd`, `linuxcncrsh`, and their transitive dependencies.

Therefore, if the third full build still cannot reach assertions within the bounded ceiling, the correct response is not an unverified hand-edited "minimal" target list. The fallback must preserve the upstream build graph and prove that all runtime dependencies are from the same pinned build.

## Fallback strategy after another timeout

Preferred order:

### 1. Reusable pinned run-in-place build artifact

Create a dedicated build-producing workflow/job keyed by:

- LinuxCNC commit `8bf4605...`;
- Ubuntu runner image/toolchain identity;
- configure arguments (`--with-realtime=uspace --disable-gui --disable-manpages --disable-build-documentation`).

The producer performs the supported full build once, records the exact upstream commit/configure line/toolchain metadata, and archives the run-in-place tree needed by later software experiments. A consumer topology job restores that artifact, verifies the embedded/source commit and expected binaries/modules, sources `scripts/rip-environment`, and runs only the topology observation.

Validity advantage: later experiments no longer spend most of their compute budget rebuilding unchanged source, while still using binaries generated by LinuxCNC's own build graph at the pinned revision.

Risk to control: a restored run-in-place tree can contain absolute/generated paths or host-specific state. The producer/consumer must run on a compatible runner image, and the consumer must fail closed if `linuxcnc`, `milltask`, `linuxcncsvr`, `halcmd`, or required RT modules cannot be resolved from the restored tree.

### 2. Build cache/ccache as acceleration, not evidence

Compiler caching may reduce repeated compilation, but cache hits do not change the provenance requirement. The source checkout, configure arguments, and resulting runtime binaries still have to identify the pinned revision. Cache keys must include the LinuxCNC commit and relevant build configuration.

### 3. Narrow upstream targets only after dependency proof

`../bin/milltask` and `../bin/linuxcncsvr` are explicit Make targets, but the linuxcncrsh simulation also needs motion, kinematics, HAL tools/components, launcher support, interpreter/NML libraries, and other transitive targets. A future narrow-build experiment is acceptable only if LinuxCNC's Make dependency graph—not a guessed file list—produces every binary/module required by the exact simulation, and the runtime observation succeeds from a clean checkout.

This is lower priority than a reusable full-build artifact because it creates a new validation burden for A01 without improving the architecture evidence itself.

## Adversarial interpretation checks

- **False:** "The workflow passed, therefore `iocontrol.0` is integrated into milltask." A workflow can pass without valid fresh evidence if the publication logic is flawed; source ownership plus executed runtime assertions are required.
- **False:** "No `iocontrol` process means LinuxCNC has no I/O-control subsystem." The pinned implementation exposes I/O-control behavior through a Task-owned HAL component named `iocontrol.0`.
- **False:** "A HAL component name identifies an OS process." HAL component identity and process identity are different namespaces.
- **False:** "Because `motmod` appears in `halcmd list comp`, GitHub Actions demonstrated realtime scheduling." Component loading/topology is observable in POSIX non-realtime fallback; scheduling quality is outside A01's evidence boundary.
- **False:** "A partial/minimal build is automatically equivalent to the full build." Equivalence must be established through the upstream dependency graph and a clean successful runtime test.

## Exact next checkpoint

Inspect Actions run `33965517203` when it leaves `in_progress`.

- If fresh `004` metadata and the assertion section exist, promote only the observed process/component claims to `TEST-CONFIRMED`, reconcile them into `guides/A01-process-component-architecture.md`, write the fresh-AI handoff, and graduate A01.
- If the run reaches the 75-minute ceiling without assertions, implement the reusable pinned run-in-place build-artifact producer/consumer design above instead of launching a fourth full rebuild.
