# C05-029 attempt 6 reconciliation — realtime stop succeeded, userspace drain termination remained asymmetric

Status: **HARNESS INVALID**

Frozen experiment: `experiments/C05-029-scale-jump-plan.md`
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Workflow: `34256027036`
Job: `102161932242`
Head commit: `daea4944fff7d979b1e991481e5be7a1ca375dd0`
Job UTC: `2026-09-08T17:15:49Z` to `2026-09-08T17:19:08Z`

## Classification

Attempt 6 is **HARNESS INVALID**, not a behavioral failure of the frozen wrong-scale/jump experiment.

The post-acquisition correction successfully replaced the independent realtime sampler-disable writes with one `halcmd stop`, but the exact raw-trace join still rejected the transport:

```text
HARNESS_INVALID: split sampler sample sets differ onlyA=[] onlyB=[6564, 6565, 6566]
```

No behavioral gate is evaluated from a trace whose two FIFO sample sets are unequal.

## What attempt 6 proved about the remaining defect

The sign of the mismatch reversed relative to attempt 5:

- attempt 5: `onlyA=[6564]`, `onlyB=[]`;
- attempt 6: `onlyA=[]`, `onlyB=[6564,6565,6566]`.

The realtime production boundary is no longer the best explanation. Pinned source shows each `sampler.N` realtime function writes its own FIFO when invoked; both sampler functions are in the same stopped `servo-thread`. After the stop, however, the harness still terminates the two **userspace `halsampler` readers at different times**. It reaps the primary reader first and the secondary reader later. A reader can therefore be terminated while its FIFO still contains records that the other reader has time to drain.

This is consistent with the observed terminal-only mismatch and with the reversal in which trace owns the extra tail.

## Source distinction

Pinned `sampler.c` establishes two separate layers:

```text
realtime sampler function -> HAL stream/FIFO
userspace halsampler       -> FIFO reader -> stdout trace
```

`halcmd stop` stops realtime thread execution; it does not itself prove that each independent userspace reader has drained all already-enqueued FIFO records to its output file before that reader is terminated.

Evidence classification:

- realtime FIFO production model: **SOURCE-CONFIRMED** (`src/hal/components/sampler.c`);
- `halcmd stop -> hal_stop_threads()`: **SOURCE-CONFIRMED** (`src/hal/utils/halcmd_commands.cc`);
- asymmetric terminal drain observed: **TEST-CONFIRMED HARNESS EVIDENCE**;
- exact number of milliseconds needed for an arbitrary reader to drain: not treated as a LinuxCNC behavioral claim.

## Investigation-control decision

Within the materially redesigned concurrent-reader family:

- attempt 4 failed at isolated staging before LinuxCNC;
- attempt 5 exposed a realtime-production stop-boundary race;
- attempt 6 removed that race and exposed the remaining userspace-reader drain boundary.

Attempts 5 and 6 are two materially similar termination-transport failures. One final bounded harness correction is justified before the three-similar-attempt limit: stop realtime production once, then give **both already-running readers the same bounded quiescent drain interval before either is terminated**, while preserving the exact-set join unchanged.

If that final bounded drain still produces unequal sets, classify this redesigned transport family under the three-attempt rule before any further laboratory run. Do not keep extending grace periods.

## Frozen-contract preservation

The next correction changes only post-acquisition reader drain timing. Unchanged:

- Gates A–H and thresholds;
- all PID, plant, `Kc`, scale, jump and phase values;
- two concurrent readers throughout acquisition;
- same realtime function order;
- zero-overrun requirement;
- both complete raw traces retained;
- exact identical-sample-number set equality;
- consecutive-number requirement;
- no intersection, deletion, interpolation, nearest-neighbor matching, or relabeling.
