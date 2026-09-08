# C02-024 accepted result — independent feedback loops

Status: **TEST-CONFIRMED / ACCEPTED**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Authoritative retained-evidence run

- Workflow: `34225190610`
- Job: `102057466102`
- Artifact: `10055529544`
- Curriculum source commit: `08c4345a85efc36fdbb313c76e1dc7bc387650f7`
- Job file: `lab-jobs/024-c02-independent-feedback-disturbance-retained.sh`
- Inner exit: **0**
- Runtime window in preserved metadata: `2026-09-08T12:16:54Z` to `2026-09-08T12:20:47Z`
- Frozen Gates A-H: **PASS**

## Prediction

Frozen before implementation: one duplicated/common position command feeding two separate PID + plant + feedback paths does not make the two control states one state. A plant-B-only response change should be able to separate B from A in feedback, error, and control output without any stock PID peer-comparison mechanism appearing.

## Topology and observation boundary

The fixture schedules:

```text
motion-command-handler
motion-controller
PID A
PID B
plant A
plant B
sampler
```

PID A and PID B have separate `hal_pid_t` state and separate `integ` plant instances. Both receive the same Y command. The sampler observes command, both feedbacks, both PID errors, both PID outputs, phase, and both PID-enable bits in one realtime row.

`error-previous-target` is explicitly set false on both PID instances so the experiment is not accidentally using the pinned default previous-target convention.

## Decisive observations

The retained run produced 8,335 realtime rows (`0..8334`) with no acceptance-level evidence-retention gap. Phase populations were:

- phase 1 baseline: 1,013 rows;
- phase 2 B-only plant disturbance: 2,014 rows;
- phase 3 recovery: 1,514 rows;
- phase 4 PID-B disable: 1,014 rows.

Observed metrics:

```text
command-span=5.554
baseline-max-feedback-separation=0.001499
disturbed-max-feedback-separation=0.6499
disturbed-max-error-separation=0.6499
disturbed-max-output-separation=2.599599
disturbed-sustained-separation-samples=2014
phase-4-same-cycle-a-enabled-b-disabled-samples=1011
phase-4-max-abs-pid-b-output-while-same-cycle-disabled=0
phase-4-max-abs-pid-a-output-while-same-cycle-enabled=1
```

All frozen gates passed. The B-only `gain=0.25` disturbance caused sustained independent feedback/error/output divergence while the shared command remained the premise. In the failure phase, 1,011 same-cycle rows simultaneously proved A enabled/B disabled, and PID-B output was exactly zero in those rows.

The small baseline feedback separation is not treated as hidden cross-coupling evidence. With the documented function order, PID calculations consume pre-plant state and the two plant functions then update sequentially before the sampler observes post-plant state. The experiment's independence claim rests on separate instance ownership/topology and the large controlled B-only divergence, not an invalid same-row arithmetic identity.

## Durable raw evidence

The final publication-only correction retained the complete evidence set under `lab-results/c02-024-evidence/` and in artifact `10055529544`:

- `c02-024-realtime.txt` — 8,335 lines, 682,360 bytes, SHA-256 `500b066066fc8df2cc85451a6380a815519bc6159bd9eaa6d53ef20b1d1532cb`;
- `c02-linuxcnc.stdout` — SHA-256 `0e88bdda0f9dfe6382da29b6ba0351d7fa5037cc29b3bf770dfb9b2a3bbe1c27`;
- `c02-linuxcnc.stderr` — SHA-256 `2439983b5a6d7d42a7d8657b08ff053add5c7a5d1e44294aaecdc669c08fba94`;
- `c02-024-halsampler.stderr` — empty, SHA-256 `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`.

This corrects the prior passing run's publication defect without modifying behavior, gates, disturbance, or thresholds.

## Reconciliation with pinned source

Pinned `pid.c` gives each loop its own state and binds each exported realtime function to that specific instance. `calc_pid()` reads only that instance's command/feedback and has no implicit peer feedback read. Pinned `integ.comp` likewise advances only its own plant state. When a PID instance is disabled, pinned source resets its integral state and forces its output to zero.

The accepted runtime observation matches those source-level expectations.

## Invalid/correction history

- Attempt 1, workflow `34219392130`: **HARNESS INVALID for acceptance** because Gate H mixed userspace enable observation with realtime output and the complete raw trace was not durably published. Its B-only divergence evidence remains informative but is not the accepted oracle.
- Correction attempt 2, workflow `34224780695`: behavioral Gates A-H passed, including the same-cycle disable oracle, but the full trace was copied outside the workflow's published path. Classified **behaviorally passing / publication incomplete**, not final accepted evidence.
- Final retained-evidence run `34225190610`: same behavior/gates plus durable full trace publication. **ACCEPTED.**

## C02 conclusion

The experimentally supported 1000-level teaching is:

```text
shared command
!= shared feedback state
!= shared controller error
!= shared control effort
!= cross-coupled synchronization
!= safety-rated disagreement protection
```

C03 must add an explicit synchronization/cross-coupling mechanism. Nothing in C02 establishes that a particular cross-coupled architecture is stable, mechanically appropriate, hydraulically appropriate, or safety-rated.
