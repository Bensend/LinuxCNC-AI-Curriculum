# M66-TIMEOUT-001 — run 079 independent audit

Date: 2026-09-11
Workflow: `34593401753`
Job: `103243588697`
Source commit: `cd46cacf7696a714472fa72a1549e6e577365df1`
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Outcome: **STALE-WAIT INTERACTION CONFIRMED**

## Independence / freeze check

The behavioral contract was frozen before result inspection in `experiments/M66-TIMEOUT-001-frozen-contract.md` and in the committed lab script. The authoritative instruction is `M66 P0 L1 Q0.20`; the separate call-flow note's one `L3` experiment-summary transcription was explicitly corrected before the run result was inspected.

Frozen discriminator:

- `delta = experimental_duration - control_duration`
- `delta <= -0.10 s` => `STALE-WAIT INTERACTION CONFIRMED`
- `delta >= +0.10 s` => `HYPOTHESIS FALSIFIED`
- otherwise nondiscriminating/harness invalid.

No threshold, timeout, dwell duration, transition time, source revision, or result rule was changed after observation.

## Provenance and harness gates

Run 079 exited `0` and retained a complete result.

- pinned upstream checkout: `8bf4605ae81042248add031e94c77300406e0413`
- pinned executable/Python-module provenance gate: PASS
- writable fixture input `motion.digital-in-00`: PASS
- fresh control G4 plausibility gate: PASS
- experimental frozen input transition executed: PASS
- experimental program completed without LinuxCNC error-channel failure: PASS
- discriminator gate: PASS

Authoritative Actions job interval: `2026-09-11T11:18:50Z` to `2026-09-11T11:21:57Z` = **3.12 min**. Inner lab output interval was `11:18:53Z` to `11:21:53Z`.

## Observed values

| Witness | Observed |
|---|---:|
| Fresh control `G4 P0.50` duration | `0.505165 s` |
| Frozen experimental input transition | `0.301064 s` after AUTO_RUN |
| Experimental total program duration | `0.311439 s` |
| `experimental - control` | `-0.193726 s` |
| Lab verdict | `STALE-WAIT INTERACTION CONFIRMED` |

The control is close to the requested 0.50 s dwell and is comfortably inside the frozen broad plausibility band.

The experimental program contains a preceding `M66 P0 L1 Q0.20`. It explicitly requires `#5399 == -1` before entering `G4 P0.50`, so reaching the G4 establishes that the M66 timed out as intended. The same digital input is then raised at 0.301064 s after AUTO_RUN. Program completion follows roughly 10 ms later, at 0.311439 s total, instead of extending by the full following 0.50 s dwell.

The observed delta `-0.193726 s` is well beyond the frozen `-0.10 s` confirmation threshold.

## Source/behavior reconciliation

The observed behavior matches the pre-run source hypothesis:

1. M66 `RISE` starts with input LOW, so `WAITING_FOR_DELAY` transforms the internal wait type to `HIGH`.
2. Its Q deadline expires; Task marks `input_timeout=1` and execution DONE, but the inspected timeout branch does not clear `emcAuxInputWaitIndex`.
3. `#5399` is later materialized as `-1`, proving timeout to the interpreter.
4. The following `G4` issues an ordinary `EMC_TRAJ_DELAY`; its issue path establishes a new delay deadline but does not clear the stale auxiliary-input index/type.
5. `G4` uses the same `WAITING_FOR_DELAY` state. When the old input becomes HIGH, the stale HIGH branch clears the auxiliary wait and marks Task execution DONE, terminating the G4 before its own deadline.

This is no longer merely an inferred consequence at the pinned revision: source structure and the controlled run agree.

## Current-master check

A separate 2026-09-11 source inspection of LinuxCNC `master` found the same relevant structure: the timeout path still leaves `emcAuxInputWaitIndex` active, RISE still transforms to HIGH, and the shared `WAITING_FOR_DELAY` input branch still clears execution when that stale condition becomes true. This does **not** substitute for executing master, so the behavioral verdict remains strictly bound to the pinned curriculum revision; however, there is no source-level evidence in current master that this bookkeeping pattern has been removed.

## Architecture consequence for the 4600 press-brake track

This strengthens the earlier ownership rule rather than broadening M66's responsibilities:

- M66 remains useful for non-time-critical supervisory waits where Task-level timing is acceptable.
- timeout must be checked explicitly through `#5399`; timeout is not an automatic abort.
- after a timed event-mode M66 timeout, sequencing code must not assume a following G4 is independent on the tested revision.
- press-cycle timeout handling should preferably be expressed as an explicit process-state transition with unambiguous ownership/witnesses rather than chaining M66 timeout and G4 as though they were independent timers.
- none of this elevates ordinary LinuxCNC Task logic to a functional-safety mechanism.

This does **not** make M66 suitable for Y1/Y2 synchronization, following-error protection, actuator saturation protection, field-I/O freshness, or safety-chain handling.

## Minimal source-correction hypothesis — not applied upstream

The direct defect boundary suggested by the evidence is stale auxiliary-input state surviving timeout. A minimal candidate correction is to clear the auxiliary wait bookkeeping when the wait deadline expires, before a later generic `WAITING_FOR_DELAY` user can inherit it. Abort/reset paths should also be audited for the same state lifetime.

That is a source-maintenance hypothesis, not a committed LinuxCNC patch in this curriculum. Before proposing an upstream patch, a focused regression test should first be reduced into LinuxCNC's own test suite and should cover at least:

- timed RISE timeout -> G4;
- timed FALL timeout -> G4;
- timed HIGH/LOW timeout -> G4;
- successful event wait -> G4 control;
- abort/reset while waiting -> subsequent G4;
- assurance that `#5399=-1` timeout semantics remain unchanged.

Per the curriculum's anti-over-simulation rule, the next curriculum step is **not** to run a large matrix immediately. One minimal upstream-style regression test around the confirmed failure and a source-level fix review are enough before returning to broader press-cycle failure ownership.

## Verdict

**CONFIRMED:** on the pinned LinuxCNC revision, a timed-out event-mode M66 can leave auxiliary wait state that prematurely terminates a subsequent G4 when the old input later satisfies the stale wait condition.

Evidence class: **SOURCE-CONFIRMED + LAB-CONFIRMED (stock loopback Task/interpreter behavior).**

Boundary: this is not physical-machine, fieldbus, hydraulic, realtime synchronization, or functional-safety validation.
