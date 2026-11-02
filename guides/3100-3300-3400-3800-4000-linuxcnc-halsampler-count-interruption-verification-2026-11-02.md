# HAL-SAMPLER-157 — finite capture exit-code contract (disconnected)
**Source-reviewed 2026-11-02; NO TEST EXECUTION.** Read [HAL-SAMPLER-157 audit](../research/4400_LINUXCNC_HAL_SAMPLER_157_EARLY_SIGNAL_SUCCESS_EXIT_SOURCE_DOC_CONFLICT_2026-11-02.md). Stable v2.9.10 `86cdca76fa2a36274c432caa21952b23c267989a`; development `67437d8865e431a9a33f74cee912dbf891d3b4c5`.

Use only a positively qualified, physically disconnected LinuxCNC software environment, no machine outputs or energized axes. Start a HAL-only sampler with a 1-ms thread, e.g. in a HAL script:
```hal
loadrt threads name1=slow period1=1000000
loadrt sampler depth=512 cfg=s
setp sampler.0.pin.0 123
addf sampler.0 slow
start
```
This produces one signed value per callback. Use `halrun <file.hal>` as in upstream `tests/loadrt.2/test.sh`; keep HAL alive while invoking the separate `halsampler` userspace process. For an independent runner, collect the child's exact status and output file length, rather than only `halrun` or `timeout` wrapper exit status.

## Frozen acceptance matrix
| Case | Source-derived prediction | Evidence needed |
|---|---|---|
| A. `halsampler -n 20` completes naturally | 20 rows, exit 0 | exact row count and child exit code |
| B. `halsampler -n 1000000` receives SIGTERM after startup, well before count | `stop=1`, loop breaks, exit **0** in inspected original despite truncated rows | signal delivery witness, fewer than 1,000,000 rows, actual child status |
| C. Same with SIGINT | same source branch as B | actual child status, row count |
| D. Same with proposed patch | exit **nonzero** when stopped before count | patch identity, build log, child status |
| E. Finite natural completion with proposed patch | remains exit 0 | exact row count |
| F. Indefinite `halsampler` stopped by SIGTERM | original exit 0; patch nonzero, consistent with development man page | child status |
| G. Broken stdout pipe / SIGPIPE | stop handler is registered; output/stdio buffering may affect timing | actual child status, row count, stdout error; **do not assume** deterministic signal timing |
| I. Compare `sampler.0.sample-num` with `halsampler -t` tags | docs promise automatic HAL pin increment; source exports/initializes but does not update pin; stream tags use `fifo->this_sample` | HAL pin snapshots and tagged output, compare counters separately |
| H. Missing output file | unchecked `open/dup2` in both revisions; behavior requires execution | syscall trace and child status, no confident predicted exit code |

For B/C, wait until the userspace component has initialized and at least one row is recorded; signal during `ignore_sig` is explicitly excluded. If using GNU `timeout`, `--preserve-status` is necessary to avoid confusing wrapper timeout code 124 with the child process status. Better still launch the process and `kill -TERM <child-pid>` after confirming startup, then `wait` for its status. Avoid using `head` to provoke SIGPIPE as the primary oracle because buffering and pipe closure complicate interpretation.

## Source reading / patch review
Inspect `sampler_usr.c::quit`, `main`'s `samples` decrement, `hal_stream_wait_readable`, `if(stop) break`, and unconditional `exitval=0`. Compare the exact man-page promise about early termination. [Candidate one-line patch](../examples/4000_hal_sampler_157/halsampler_early_stop_exit_status_v2910.patch) is for v2.9.10 only; it has not been compiled, run, or submitted upstream. A passing test must include both status **and count**; no machine safety or physical-stop claims follow.

## Diagnostic integration guidance
For mill/lathe/plasma/router/feeder HAL trace capture, record LinuxCNC revision, HAL thread period, actual sample count, sampler overruns, process status, any `overrun` markers and file byte count. A successful userspace process is not proof of complete realtime telemetry, especially if the capture was interrupted or the FIFO overflowed. Do not use sampler data to substitute for independent personnel-safety channels.

**Counter provenance:** development `sampler(9)` says `sampler.N.sample-num` automatically increments, but stable/development `sampler.c::sample` does not write it. The `-t` number is `hal_stream_write`'s internal `fifo->this_sample` conveyed through `hal_stream_read`. Do not equate the HAL_IO pin and the FIFO tag without a runtime witness; do not infer that setting the HAL pin resets FIFO numbering.
