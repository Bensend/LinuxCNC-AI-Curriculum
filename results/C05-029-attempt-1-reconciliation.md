# C05-029 attempt 1 — HARNESS INVALID reconciliation

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Frozen plan: `experiments/C05-029-scale-jump-plan.md`

Implementation commit: `90a15ac75fc92d602b474b1e27965fe023183c5c`

Authoritative workflow: `34250135965`

Authoritative job: `102142142268`

## Verdict

**HARNESS INVALID — no behavioral gate was reached.**

The LinuxCNC runtime failed while loading `sampler`:

```text
stream: ERROR: more than 21 items
sampler: rtapi_app_main: Invalid argument (-22)
... insmod for sampler failed, returned -1
HARNESS_INVALID: runtime not ready
```

The C05-029 implementation requested one stream containing 21 float values plus two bit selectors. LinuxCNC stream samples are bounded; current LinuxCNC stream documentation states that one sample can contain up to twenty values. The attempted 23-value stream therefore could not exist, so there is no valid wrong-scale or jump behavior to score.

This is an observation-harness capacity defect, not evidence against any C05 prediction.

## Frozen-plan integrity

No behavioral requirement is changed:

- wrong-scale candidate remains `1.20 * true_B`;
- jump candidate remains `true_B + 0.50 in`;
- `Kc` remains `0.5`;
- both toy plant gains remain `1.0`;
- phase durations and publication rules remain unchanged;
- Gates A–H and every numerical threshold remain unchanged;
- the actual realtime selector edge, not a userspace phase edge, remains decisive for Gate F.

## Harness-only correction

Use **two sampler FIFOs**, both added to the same servo thread. The primary FIFO retains the first twenty float fields. A secondary FIFO retains the remaining PID-B residual plus the two selector bits. Both sampler functions execute once in the same servo thread; their tagged sample numbers must match exactly. The analysis input is produced only by an auditable exact sample-number join of the two retained raw traces.

This approach preserves every field frozen in C05-029 rather than weakening the evidence set to fit one stream.

The corrected harness must additionally require:

1. zero overruns on **both** FIFOs;
2. identical, consecutive sample-number sets for the retained raw traces;
3. durable retention of both original sampler traces plus the joined analysis trace;
4. no behavioral retuning.

Only after those observation-validity checks pass may Gates A–H be evaluated.
