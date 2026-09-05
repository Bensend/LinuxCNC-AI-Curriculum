# A01 — `halcmd` observation boundary and bounded-probe design

Primary LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

## Why this guide exists

A01 runtime experiment `004` reached a live LinuxCNC runtime but never reached its intended topology assertions. The previous readiness loop was nominally bounded by 80 iterations, yet each iteration executed an unbounded external `halcmd list comp`. Therefore the loop's wall-clock duration was not actually bounded.

## Source findings

### `halcmd` command path

At the pinned revision, `src/hal/utils/halcmd_main.c::main()` parses options, then calls `halcmd_startup(0)` **before** processing the requested command. Only after startup succeeds does it hand the command line to `halcmd_parse_cmd()`. Therefore an externally observed hang in `halcmd list comp` cannot safely be attributed to the `list` implementation alone: attachment/startup may block before command dispatch.

Evidence classification: **SOURCE-CONFIRMED**.

The command table in `src/hal/utils/halcmd.c` dispatches `list` to `do_list_cmd`, and `src/hal/utils/halcmd_commands.h/.cc` declares/implements `do_list_cmd`. LinuxCNC's own `scripts/linuxcnc.in` also invokes `$HALCMD list comp` during shutdown to inspect remaining HAL components. This establishes that `list comp` is a legitimate normal observation command, but it does not establish that it has a bounded completion time under an unhealthy or partially initialized HAL state.

Evidence classification: **SOURCE-CONFIRMED** for dispatch/use; boundedness remains **UNKNOWN**.

## Corrected inference boundary

The previous working hypothesis was "`halcmd list comp` blocked." The source trace requires a more precise statement:

> **INFERENCE:** the experiment was most likely held inside one of its unbounded `halcmd list comp` invocations. The block may be in `halcmd_startup()`/HAL attachment, command dispatch, HAL mutex acquisition, or list traversal. Existing evidence does not isolate which internal stage.

The next experiment must therefore treat the whole `halcmd` process as the observation unit and bound it externally.

## Bounded-probe design

Prepared branch: `a01-bounded-observation`.

The branch changes `lab-jobs/004-a01-runtime-topology.sh` so that:

- `milltask` and `linuxcncsvr` process readiness are observed independently of HAL.
- every `halcmd` process is wrapped by GNU `timeout` (default 3 s, plus a 1 s kill-after window);
- before/after markers identify the exact probe that failed to return;
- a HAL-query timeout preserves process snapshots, LinuxCNC stdout/stderr, and the command's stderr;
- component assertions reuse a captured bounded result instead of issuing multiple uncontrolled queries.

The same branch changes `.github/workflows/lab-runner.yml` so the lab command has an **inner 70-minute timeout** inside the existing 75-minute GitHub job ceiling. This is deliberately different from relying on the job-level timeout: the shell should regain control while five minutes remain to write exit status, `LATEST.*`, upload artifacts, and commit readable results. The artifact path is also deterministic (`run-${GITHUB_RUN_ID}-${GITHUB_RUN_ATTEMPT}`) and no longer depends on a step output that can only be emitted after the long command returns.

These changes are committed on a non-main branch because September 5's laboratory budget is already consumed and the workflow is configured to auto-run changes to `lab-jobs/**` or the runner workflow when pushed to `main`.

## Adversarial checks for the next run

A valid result must distinguish these cases:

1. Controller processes never appear: startup/process problem, not a HAL-query problem.
2. Processes appear and the first bounded `halcmd` times out: HAL attachment/query readiness problem; preserve the exact timeout marker and diagnostics.
3. `halcmd` returns but `iocontrol.0` is absent: runtime reached HAL but expected component topology is not yet present; continue bounded polling until the defined observation window expires.
4. Components appear and assertions execute: only then may runtime topology be promoted to `TEST-CONFIRMED`.
5. The 70-minute inner experiment timeout fires: publication must still occur; exit `124` is diagnostic evidence, not a topology result.

## Next source-reading target if HAL still times out

Trace `halcmd_startup()` and the HAL shared-memory/mutex attachment path at the same pinned revision. Determine where waits are bounded versus unbounded, then map the timeout observation onto that source path. Do not speculate from process presence alone.
