# C02-024 correction attempt 2 reconciliation

## Classification

**Behavioral gates PASS, evidence publication INCOMPLETE; not accepted as the final authoritative C02-024 artifact.**

This classification is deliberately stricter than treating workflow success as sufficient evidence. Frozen Gates A-H and numerical thresholds remain unchanged.

## Run

- Workflow: `34224780695`
- Job: `102056118960`
- Source commit: `bca881e1788b6f704a2567e6185940e36c2317a3`
- Inner exit: `0`
- Finished UTC: `2026-09-08T12:15:58Z`
- Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`

## Behavioral evidence

The correction successfully moved enable A/B into each realtime sampler record. It recorded:

- sample numbers `0..7791`;
- phase 1: 1,014 samples;
- phase 2: 2,014 samples;
- phase 3: 1,513 samples;
- phase 4: 1,014 samples;
- shared-command span: `5.554` in;
- B-only disturbance maximum feedback separation: `0.65`;
- maximum error separation: `0.65`;
- maximum PID-output separation: `2.6`;
- 2,014 consecutive disturbed samples above the frozen disagreement threshold;
- 1,011 phase-4 rows proving in the **same realtime record** that A was enabled and B disabled;
- maximum absolute PID-B output in those same-cycle disabled rows: exactly `0`;
- maximum absolute PID-A output while same-cycle enabled: `1`;
- Gates B-H: PASS; overall C02-024: PASS.

The result reconciles with pinned source: stock PID instances own separate state, the B-only plant disturbance does not create a hidden peer comparator, and the disabled branch forces that instance's output to zero.

## Why a further publication-only rerun is justified

The corrected shell cleanup copied the complete sampler trace and process logs to `$GITHUB_WORKSPACE`, but the workflow artifact includes `lab-results/**`, not arbitrary repository-root evidence files. Therefore only the summarized output and a trace tail were durably published; the complete realtime file was not in the artifact/repository result.

Because the experiment plan requires raw trace retention, this is an **evidence publication defect**, not a reason to weaken the evidence requirement after seeing a pass.

A wrapper has been committed that leaves the behavior harness, gates, thresholds, disturbance and same-cycle oracle unchanged and copies the complete evidence set into `lab-results/c02-024-evidence/` before workflow publication. The next run must pass the same frozen gates and preserve that directory before C02-024 is accepted.

## Safety boundary

`PID B disabled and output == 0` is software-loop evidence only. It is not proof of actuator power isolation, hydraulic isolation, mechanical safety, or a safety-rated anti-racking function.
