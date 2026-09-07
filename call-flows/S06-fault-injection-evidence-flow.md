# S06 call flow — deterministic fault injection to accepted evidence

- Course level: 1000
- Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
- Applies to: S06-016 and later HAL-level fixtures that adopt the same contract

## Execution path

### 1. Realtime stimulus/fault scheduler executes

A test-only realtime component executes first in the 10 ms HAL thread. It produces both the healthy reference and the intentionally published/faulted channel, plus explicit sequence/age information.

The scheduler is part of the harness, not the target oracle. Its self-declared mode is metadata only.

### 2. Stock HAL observer functions execute

The published and healthy channels feed stock LinuxCNC arithmetic/comparison components. For S06-016:

- `sum2.0` computes published minus healthy value;
- `abs.0` converts that to absolute value mismatch;
- `comp.0` asserts only when the absolute value mismatch is strictly greater than 0.05;
- `sum2.1` computes published sequence minus healthy sequence;
- `abs.1` converts that to absolute age mismatch;
- `comp.1` asserts only when the age mismatch is strictly greater than 0.5 cycle.

The stock observer path does not read the scheduler's fault-mode declaration.

### 3. `sampler.0` executes after source and observer

Pinned `sampler.c::sample()` reads all configured pins within its realtime function invocation and writes one FIFO record. Therefore, after thread-order verification, each accepted row captures source/reference, injected publication, and downstream observer states from the same configured servo-cycle execution point.

If the FIFO is full, the sample is lost and `overruns` increments. Exact-cycle claims are invalid unless overruns remain zero and all required cycle rows are present.

### 4. `halsampler` drains asynchronously

The non-realtime program copies FIFO records to stdout/file. It does not define when the realtime samples were taken. The sampling point is `sampler.0`, not the userspace drain.

### 5. Post-run classifier separates evidence types

The classifier first asks whether the harness is valid:

- correct thread order;
- intended raw fault actually present;
- no sampler overrun;
- required cycle windows complete;
- parse/schema generation successful.

Only then does it evaluate the stock observer response and recovery.

### 6. Result classification

- intended injection missing or evidence capture unhealthy -> `HARNESS_INVALID`;
- intended injection demonstrated and capture healthy, but downstream prediction fails -> `BEHAVIOR_FAIL`;
- all frozen gates pass -> `PASS`.

## Why this is non-circular

For a one-cycle jump, `mode=2` is insufficient evidence. Injection is proven by the raw relation `published - healthy = +5.0` while sequence remains current. Response is separately proven by `comp.0.out` asserting while the age comparator remains clear.

For one-cycle skew, `mode=3` is likewise insufficient. Injection is proven by raw sequence difference of exactly one and the published value matching the prior healthy sample. Response is separately proven by the age comparator asserting while the value comparator remains clear.

## Failure branch

A custom component build/load failure, wrong function order, missing trace row, overrun, or missing scheduled raw corruption invalidates the harness. It must not be reinterpreted as evidence that stock LinuxCNC failed to detect the condition.

## Recovery branch

Fault removal is tested independently. Publication must again equal the healthy value/sequence and observer outputs must return to the predeclared healthy state. Merely ending the scheduled fault mode is not sufficient recovery evidence.

## Safety boundary

This flow validates a software experiment method at a HAL boundary. It does not validate a physical fault model, common-cause independence, transport failure, hardware diagnostic coverage, or any safety-rated function.
