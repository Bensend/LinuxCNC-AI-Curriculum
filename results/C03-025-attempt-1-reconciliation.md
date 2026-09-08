# C03-025 attempt 1 reconciliation

## Classification

**HARNESS INVALID — Gate C transition-row observation defect.** This is not a behavioral failure of the frozen cross-coupling law.

Authoritative run: workflow `34226127383`, job `102060582084`, artifact `10055927769`, source commit `8d189e53b38e31be91ea02b5375bcffb98c97e05`, inner exit `31`.

## What was valid

- pinned LinuxCNC provenance passed;
- the intended two-PID/two-plant/cross-coupling topology and servo function order were printed;
- sampler overruns were `0`;
- `11053` realtime rows were captured with `3015` phase-2, `3016` phase-3, and `3012` phase-4 rows;
- userspace phase announcements showed the intended steady configurations: phase 2 `Kc=0`, A gain `1`, B gain `0.25`; phase 3 `Kc=0.5`, A gain `1`, B gain `0.25`; phase 4 `Kc=0`, A gain `1`, B gain `0.25`.

The analyzer correctly refused to continue because at least one realtime row tagged as phase 2 did not simultaneously contain the required Gate-C configuration.

## Root cause

The phase sequencing used separate userspace `halcmd sets` processes back-to-back. For phase 2 it wrote plant-B gain and immediately wrote the phase signal; phases 3 and 4 similarly wrote `Kc` and immediately wrote the phase signal. Those writes are not an atomic realtime transaction. The 1 ms servo thread can sample between them, so a new phase marker can coexist for a transition row with the preceding configuration value. Gate C requires every evaluated phase-2/3/4 row to prove the frozen configuration in the same realtime record, so rejecting that run is correct.

This is an observation/phase-publication defect. It does not justify widening Gate C, deleting transition rows after seeing the result, or changing `Kc`, PID gains, plant gains, phase durations, or any behavioral threshold.

## Frozen correction for attempt 2

Preserve C03-025 Gates A–H unchanged. Change only phase publication ordering:

1. write the next configuration value (`plant-B gain` or `Kc`);
2. wait `20 ms` (20 nominal servo periods, comfortably beyond one cycle);
3. only then publish the new phase marker;
4. retain the original `>=1 s / >=3 s` dwell after the phase marker.

This deliberately excludes configuration-transition cycles from the decisive phase labels rather than filtering them after collection. Same-row plant gains and `Kc` remain the Gate-C oracle.

The correction must be durably visible in the runnable harness before execution, and attempt 2 must again preserve raw realtime evidence regardless of outcome.

## Documentation reconciliation

LinuxCNC documents `halcmd` as a command-line/userspace tool for manipulating HAL, while realtime HAL functions execute in scheduled threads. The curriculum therefore must not infer an atomic same-servo-cycle configuration transaction from sequential `halcmd` invocations. This experiment's phase signal is test instrumentation; publishing it only after a settle interval is the correct way to make the phase label describe already-established realtime configuration.
