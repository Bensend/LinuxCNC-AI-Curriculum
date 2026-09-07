# S06-016 — deterministic fault-injection framework fixture

- Status: FROZEN BEFORE IMPLEMENTATION
- Module: S06 — fault injection framework
- LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
- Attempt family: `s06-016-deterministic-rt-source-v1`

## Objective

TEST-CONFIRM a reusable, non-circular fault-injection method using a tiny test-only realtime source/fault scheduler, stock HAL observer components, and stock realtime sampler capture.

## Mechanism under test

The framework boundary itself: deterministic injection -> stock HAL derived observer state -> same-cycle realtime capture -> machine-readable gate classification.

No production LinuxCNC source is modified.

## Fixture

A tiny `halcompile` realtime component emits a monotonically increasing healthy reference value and explicit sequence number, plus a published channel whose behavior is scheduled by realtime cycle count:

- normal except scheduled windows;
- cycles 50–79: frozen published value and published sequence;
- cycle 100 only: +5.0 value jump with sequence still current;
- cycles 130–139: one-cycle-old value and one-cycle-old sequence;
- normal publication resumes after each fault.

Healthy ramp increment: `0.01` per 10 ms cycle.

Stock observer path:

- `sum2 + abs + comp` computes strict value mismatch above `0.05`;
- second `sum2 + abs + comp` computes strict sequence-age mismatch above `0.5` cycles;
- `sampler` executes after source and observers.

Pinned `comp` with zero hysteresis asserts only when `in1 > in0`; exact equality does not assert.

## Frozen acceptance gates

### Gate A — topology/order and capture health

Must verify actual thread function order: test source -> value sum -> value abs -> value comp -> age sum -> age abs -> age comp -> sampler. `sampler.0.overruns` must remain zero and required trace windows must be present.

### Gate B — healthy baseline

Within cycles 10–39: healthy and published values equal, healthy/published sequence equal, value detector false, age detector false.

### Gate C — frozen/stuck publication

Within cycles 50–79, raw trace must independently show healthy sequence advancing while published sequence remains constant. By cycle 56 or later the age detector must be true. Value mismatch must also eventually exceed 0.05 and assert the value detector. Fixture mode alone cannot satisfy this gate.

### Gate D — freeze recovery

Within cycles 80–89: published value/sequence must again equal healthy value/sequence and both detectors must be false.

### Gate E — single-cycle jump

At cycle 100 only: published sequence remains equal to healthy sequence, published value differs from healthy by +5.0, value detector true, age detector false. Cycles 99 and 101 must have both detectors false.

### Gate F — jump recovery

Cycle 101 must already be normal publication and detector-clear.

### Gate G — deterministic one-cycle age/skew

Within cycles 130–139: published value and sequence must correspond to the previous healthy cycle. Absolute value mismatch should be approximately 0.01 (<0.05), so value detector remains false; age difference must be exactly 1 cycle (>0.5), so age detector is true. This demonstrates why freshness/age evidence can detect a condition that a loose numeric threshold does not.

### Gate H — skew recovery

Within cycles 140–149: published == healthy and both detectors false.

### Gate I — circular-oracle adversarial check

Result JSON must explicitly mark the proposition `fixture mode indicates fault, therefore injection and downstream response are proven` as **INVALID**. Accepted injection evidence must come from raw healthy/published value+sequence comparisons; accepted response evidence must come from stock observer outputs.

### Gate J — machine-readable result

The job must emit valid `linuxcnc-ai-fi-v1` JSON with separate injection, response, recovery, capture-health, non-claim, overall, and exit-code fields.

## Harness-invalid criteria

Fixture build/load failure, wrong HAL topology/order, sampler overrun, missing required cycles, intended injection absent in raw trace, or parser/result generation failure => HARNESS_INVALID. No product/stock behavior conclusion may be drawn.

## Behavioral failure criteria

With valid injection and capture, any frozen response/recovery gate mismatch => BEHAVIOR_FAIL.

## Prediction

All gates A–J will pass. The freeze will be visible as both growing value mismatch and growing sequence age; the single-cycle jump will assert only the value detector; deterministic one-cycle skew will assert only the age detector because 0.01 < 0.05.

## Non-claims

No physical sensor, transport, HostMot2, FPGA, machine timing, stopping, diagnostic coverage, PL/SIL/category, or safety-rated function claim is made.
