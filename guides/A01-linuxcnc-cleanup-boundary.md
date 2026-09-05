# A01 — LinuxCNC cleanup is part of the HAL-lock diagnostic boundary

Primary LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Finding

The prepared `004-a01-runtime-topology.sh` experiment previously bounded individual `halcmd` probes but left its EXIT teardown unbounded:

```bash
kill -TERM "$LAUNCHER_PID"
wait "$LAUNCHER_PID"
```

That is not a safe publication boundary when the experiment is specifically diagnosing a possible HAL shared-data lock stall.

At the pinned revision, `scripts/linuxcnc.in` installs:

```bash
trap 'Cleanup ; exit 0' SIGINT SIGTERM
```

Its `Cleanup()` path eventually executes HAL commands including:

- `$HALCMD stop`
- `$HALCMD unload all`
- repeated `$HALCMD list comp`

The same A01 source analysis already established that `halcmd` startup and list operations can block while acquiring HAL shared-data state. Therefore sending TERM to the launcher is not equivalent to a bounded shutdown: the launcher can enter `Cleanup()` and then wait in a HAL operation. An experiment that detects a HAL observation stall could consequently consume the remaining workflow time in its own EXIT trap and lose result publication.

## Evidence classification

- **SOURCE-CONFIRMED**: pinned `scripts/linuxcnc.in` handles SIGINT/SIGTERM by calling `Cleanup()`.
- **SOURCE-CONFIRMED**: that cleanup path invokes `halcmd stop`, `halcmd unload all`, and `halcmd list comp`.
- **SOURCE-CONFIRMED** from earlier A01 work: HAL metadata operations used by `halcmd` can wait on the shared HAL mutex with no internal wall-clock timeout.
- **INFERENCE**: the launcher can therefore fail to exit promptly after TERM when cleanup encounters the same lock pathology under investigation. This is not yet claimed as the cause of run `33965517203`.

## Experiment correction

Branch `a01-bounded-observation`, commit `6e1086c2c1e8fc9afe9dfd01394b00cff241baf8`, now gives launcher teardown an independent bound:

1. TERM the launcher.
2. Poll its liveness for about four seconds.
3. If still alive, capture a process/wchan snapshot.
4. KILL the launcher so the lab script can return and the runner can publish partial evidence.
5. Never interpret teardown output as topology evidence after a forced-kill HAL-lock diagnostic.

The patch remains off `main` so it does not trigger another paid September 5 laboratory run.

## Adversarial implication

A test is not actually wall-clock bounded merely because its central probe is bounded. Every blocking path reachable during error handling and teardown must also be bounded below the outer publication ceiling. In this experiment there are three nested boundaries to audit independently:

1. individual HAL probes;
2. experiment-level teardown;
3. workflow-level experiment timeout and artifact publication.

## Next verification

At the next lab-budget window, reconcile the prepared branch with current `main`, re-audit all expected-nonzero paths under `set -euo pipefail`, and allow exactly one `004` run. If a probe stalls, preserve the original live `halcmd` stack before killing it. If launcher teardown subsequently needs KILL, treat that only as cleanup evidence; do not use post-kill HAL state to validate topology.
