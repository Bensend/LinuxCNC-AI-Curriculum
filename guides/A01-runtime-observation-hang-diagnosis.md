# A01 — Runtime Observation Hang Diagnosis

Primary LinuxCNC development revision: `8bf4605ae81042248add031e94c77300406e0413`

Curriculum lab run: GitHub Actions `33965517203`, job `101304830830`, curriculum head `06c7bf7f0602fa577d20a00f92cef82527c61df2`.

Status: failure diagnosis and next-experiment correction. No topology assertion from this run is promoted to `TEST-CONFIRMED`.

## What actually happened

The third `004-a01-runtime-topology` run reached the 75-minute workflow ceiling and was cancelled. Earlier curriculum state described the long-running step as though a full source build might still be the limiting operation. The decoded GitHub job log disproves that working assumption.

At forced runner cleanup GitHub found these live orphan processes from the lab job:

- `linuxcnc`
- `linuxcncsvr`
- `rtapi_app`
- `milltask`
- `linuxcncrsh`

Therefore the pinned LinuxCNC source had compiled far enough to launch the exact upstream `tests/linuxcncrsh/linuxcncrsh-test.ini` runtime. The 75-minute failure was not simply "still compiling LinuxCNC." The lab reached runtime and then failed to complete its observation path.

Classification: `TEST-CONFIRMED` for the laboratory fact that those named processes were live at cancellation; this is runner cleanup evidence, not the intended `004` topology assertion set.

## Why the run still does not satisfy A01

The job never returned from the shell command that wrapped `bash lab-jobs/004-a01-runtime-topology.sh`, so the runner never wrote fresh `LATEST.*` files or the script's `Key component assertions` section. The cancellation-safe publication logic then correctly found no fresh result and uploaded nothing. There is no `lab-results/run-33965517203-1` directory committed to the repository.

Consequently:

- process presence at forced cleanup is useful diagnostic evidence;
- `iocontrol.0`, `motmod`, and `trivkins` were not observed by the curriculum's intended HAL assertions;
- absence of a standalone `iocontrol` process was not tested by the intended assertion;
- A01 remains ungraduated.

## Most likely blocking point in `004`

After launching LinuxCNC in the background, `004` begins its readiness loop with:

```bash
if halcmd list comp >/tmp/a01-components.txt 2>/dev/null && grep -q 'iocontrol.0' /tmp/a01-components.txt; then
```

The loop has a nominal 20-second wall-clock bound only if each `halcmd list comp` invocation itself returns. There is no timeout around that command. A single blocking `halcmd` call therefore defeats the loop bound and can hold the script indefinitely.

This explanation is an `INFERENCE`, not yet a test result, because the current runner redirects the lab script's stdout/stderr into files that are only published after the script exits. The cancelled run did not preserve a line-by-line progress marker showing the exact instruction where execution stopped.

The inference is nevertheless strongly constrained by evidence:

1. forced cleanup proves LinuxCNC runtime processes had launched;
2. code after the readiness loop contains only bounded/simple observation commands except for additional unbounded `halcmd list ...` invocations;
3. upstream `scripts/linuxcnc.in` itself uses `halcmd list comp`, confirming that `list comp` is a legitimate LinuxCNC HAL command at the pinned revision;
4. official `halcmd` documentation describes HAL inspection as an ordinary userspace operation, and LinuxCNC community debugging practice commonly uses `halcmd show/list` while LinuxCNC is running.

## Correction for the next bounded experiment

Do not rebuild or launch a fourth full run on September 5; the course's approximate four-hour daily laboratory budget has already been consumed.

At the next available lab budget, change the observation path before rerunning:

1. Add explicit progress markers immediately before and after LinuxCNC launch and before every external observation command.
2. Wrap every readiness probe in a hard timeout, for example `timeout 2s halcmd list comp`.
3. Wait for `milltask`/`linuxcncsvr` process presence separately before the HAL probe. This distinguishes "controller not started" from "HAL query blocked."
4. Give each final `halcmd list comp` and `halcmd list funct` invocation its own bounded timeout as well.
5. If a HAL command times out, capture `ps`, `pgrep`, `/tmp/linuxcnc.lock`, and the LinuxCNC stdout/stderr before failing closed.
6. Modify the workflow so the run directory path is known independently of the shell step's outputs and partial stdout/stderr can be uploaded on cancellation/failure. The current workflow only emits `run_dir` after the lab script returns, which is why the cancelled run could not publish the already-created partial run directory.

The corrected experiment should still use the pinned commit and exact upstream linuxcncrsh configuration. The reusable-build fallback remains useful for future repeated experiments, but it is no longer the immediate A01 blocker because this run demonstrably reached runtime.

## Adversarial checks

- **False:** "75-minute cancellation proves LinuxCNC takes more than 75 minutes to build." The forced-cleanup process list proves the runtime had launched.
- **False:** "Seeing `milltask` during runner cleanup graduates A01." It only proves process presence at cancellation; the intended HAL/component assertions did not execute to completion.
- **False:** "A loop with 80 × 0.25-second sleeps is necessarily bounded to about 20 seconds." Not when the command inside the loop has no timeout.
- **False:** "No `LATEST.*` result means the hardened runner failed." In this case deletion of inherited `LATEST.*` worked as designed and prevented stale evidence from being republished.

## Exact next checkpoint

At the next laboratory-budget window, patch `004-a01-runtime-topology.sh` so every `halcmd` observation is individually timeout-bounded and progress-marked, and harden `lab-runner.yml` so partial run-directory logs survive a cancelled lab command. Then run one corrected `004` only. If it reaches `Key component assertions`, reconcile the process/HAL observations, write the A01 fresh-AI handoff, and graduate A01. If it instead produces a bounded HAL-query failure, preserve that failure and investigate HAL attachment/readiness rather than repeating the full build unchanged.
