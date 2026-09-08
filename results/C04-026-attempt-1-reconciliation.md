# C04-026 attempt 1 reconciliation

Status: **HARNESS INVALID — no behavioral conclusion**

Authoritative run: workflow `34231940180`, job `102079994732`, artifact `10058317466`, source commit `5068dea32243f209e4873cc1117a1b2d5ed51dc2`.

## What the run established

The LinuxCNC fixture started successfully at pinned revision `8bf4605ae81042248add031e94c77300406e0413`, preserved the C03 cross-coupler topology, and completed the four frozen phases with 10,111 realtime samples and zero reported sampler overruns. Configuration prints show Kc=0.5, plant-A gain=1, plant-B gain 1 -> 0.35 -> 0.35 -> 1, and PID-B maxoutput 0 -> 0 -> 1 -> 0. The analyzer reported S1=0, S2=0.377086302, S3=0.687180144, S4=0.0103899042 and exact sampled coupling arithmetic residuals. These numbers are useful diagnostic evidence only; this attempt is not accepted.

## Why the attempt is HARNESS INVALID

Two independent audit defects violate the frozen observation requirements.

1. **Gate-F analyzer field-index defect.** The parsed tuple is documented as `n,base,fa,fb,D,C,cmdA,cmdB,outA,outB,kc,phase,resC,resA,resB,gainA,gainB,satA,satB,satCountB,maxOutB`. Therefore PID-B output is tuple index 9, not index 8. Attempt 1 tested `abs(r[8]-1.0)`, which is PID-A output, while simultaneously testing PID-B saturation at `r[18]`. The printed `phase-3-longest-b-saturated-at-limit=0` is therefore not a valid Gate-F measurement.

2. **Required raw realtime evidence was not retained in the workflow artifact.** Artifact `10058317466` contains logs/metadata but not `c04-026-realtime.txt` or the promised `lab-results/` trace. The inherited script performs the C04 analyzer before its later evidence-copy block; because the analyzer exited nonzero under `set -e`, the raw-evidence copy was skipped. Frozen Gate B explicitly classifies missing raw evidence as HARNESS INVALID.

Because either defect alone invalidates the decisive observation, Gates F/G must not be interpreted from attempt 1 and the frozen `maxoutput=1.0` prediction has **not yet received a valid behavioral test**.

## Source reconciliation discovered during audit

Pinned `pid.c` applies `maxoutput` only when nonzero. If the pre-limit output is greater than +maxoutput it clamps to +maxoutput and sets `limit_state=+1`; if less than -maxoutput it clamps and sets -1; otherwise it clears `limit_state`. The exported `saturated`, `saturated-s`, and `saturated-count` telemetry is then driven from `limit_state`. This means source truth is stricter than a casual reading of `output == +/-maxoutput`: an exactly-at-limit value that did not require clipping need not establish `limit_state` by equality alone. The frozen experiment correctly requires same-cycle saturation telemetry in addition to output-at-limit evidence.

Current stable LinuxCNC documentation describes `maxoutput` as the absolute output limit and says the error integrator holds while output is limited; it also describes `saturated`, `saturated-s`, and `saturated-count` as saturation telemetry. Documentation is supporting evidence; pinned source remains authoritative for this experiment.

## Correction discipline for attempt 2

Do **not** change Gates A-H, `maxoutput=1.0`, plant gains, PID gains, Kc, phase durations, or thresholds.

Change only the observation harness:

- fix Gate-F PID-B output indexing from `r[8]` to `r[9]`;
- copy/preserve `c04-026-realtime.txt` and logs into durable evidence **before** running any analyzer that can exit nonzero;
- preserve the same realtime fields and phase-publication discipline;
- inspect raw phase-3 rows directly for `satB`, `satCountB`, `outB`, and `maxOutB` before accepting the analyzer summary;
- if valid attempt 2 proves the frozen 1.0 bound does not create >=500 consecutive saturated rows, classify that as a behavioral FAIL rather than retuning the bound.

## Safety boundary retained

`PID software saturation != physical actuator stall != drive current limit != hydraulic pressure/flow limit != sensor-fault diagnosis != safety-rated fault decision.`
