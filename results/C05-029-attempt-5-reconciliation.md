# C05-029 attempt 5 reconciliation — concurrent samplers, terminal one-cycle mismatch

Status: **HARNESS INVALID**

Frozen experiment: `experiments/C05-029-scale-jump-plan.md`
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Workflow: `34252609192`
Head commit: `c411b8e2622521c5124ec217159a88cea7a084be`
Artifact: `10066749535`
Inner exit: `1`
Lab UTC: `2026-09-08T16:41:42Z` to `2026-09-08T16:46:28Z`

## Classification

Attempt 5 is **HARNESS INVALID**, not a behavioral failure of the frozen wrong-scale/jump prediction.

The staged redesign successfully reached the pinned LinuxCNC build, generated the intended two-FIFO sampler topology, started both userspace `halsampler` readers concurrently, and ran the experiment. The exact-join validator then rejected the evidence because the raw FIFO sample-number sets differed by exactly one terminal sample:

```text
HARNESS_INVALID: split sampler sample sets differ onlyA=[6564] onlyB=[]
```

That is an observation-transport defect. No C05-029 behavioral gate may be weakened, and no fault parameter may be retuned in response.

## Why the one-row mismatch is a harness defect

The current split transport disables the two realtime sampler instances using two sequential userspace commands:

```text
halcmd setp sampler.0.enable false
halcmd setp sampler.1.enable false
```

Those writes are not an atomic servo-thread boundary. The servo thread can execute between the two commands, allowing one sampler function to record one additional cycle while the other is already disabled. The observed `onlyA=[6564]` terminal-only difference is exactly the shape expected from such a stop-boundary race.

This does **not** justify deleting the unmatched row, intersecting the sample sets, using nearest-neighbor matching, or weakening the exact same-cycle requirement. Doing so after observing the mismatch would violate the frozen transport/evidence contract.

## Source-grounded correction mechanism

At the pinned revision, `halcmd stop` routes through `do_stop_cmd()` to `hal_stop_threads()`. The HAL API/documentation defines `hal_stop_threads()` as stopping the realtime threads previously started by `hal_start_threads()`.

For C05-029 this gives a cleaner observation boundary: after the final phase, stop the servo thread itself once, then inspect both sampler counters and reap both concurrent userspace readers. Because both `sampler.0` and `sampler.1` are functions in the same `servo-thread`, the thread stop removes the independent per-sampler userspace-disable race while preserving the frozen in-thread function order and all sampled behavior up to the final completed cycle.

Evidence classification: **SOURCE-CONFIRMED** for `halcmd stop -> hal_stop_threads()` at the pinned revision; experiment still required to verify the corrected transport.

## Frozen-contract preservation

The correction may change only the post-acquisition observation stop mechanism:

```text
sequential sampler.0/sampler.1 disable
    ->
single halcmd stop of realtime threads
```

Unchanged:

- Gates A–H;
- `Kc=0.5`;
- plant gains `1.0`;
- PID gains/configuration;
- normal/scale/jump transforms;
- selector sequence;
- phase durations;
- minimum row counts;
- zero-overrun requirement;
- exact identical-sample-number join;
- no row deletion/interpolation/relabeling;
- raw-trace retention and cleanup requirements.

## Attempt accounting

The C05-029 history must remain explicit:

1. attempt 1 — HARNESS INVALID: sampler item-count limit;
2. attempt 2 — HARNESS INVALID: wrapper quoting before LinuxCNC;
3. attempt 3 — HARNESS INVALID: deferred FIFO-1 reader produced empty trace;
4. redesigned attempt 4 — HARNESS INVALID before LinuxCNC: isolated staging root omitted inherited `028` source;
5. redesigned attempt 5 — HARNESS INVALID after LinuxCNC execution: one terminal sample mismatch caused by independently stopping the two sampler instances.

The earlier three-attempt decision remains **ESSENTIAL NOW**. Attempts 4–5 belong to the materially redesigned concurrent-reader experiment family; attempt 5 materially narrows the remaining defect to the stop boundary.

## Next experiment

Create one harness-only correction that uses a single realtime-thread stop after acquisition, keeps both userspace readers concurrent, preserves both complete raw traces, and requires the existing exact-set/equal-sample join unchanged.

If that run is harness-valid and a frozen behavioral gate fails, preserve the falsification. Do not retune.
