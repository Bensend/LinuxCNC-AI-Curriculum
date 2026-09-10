# X01 — Recorder perturbation and long-duration retention

Status: **AUTHORITATIVE LAB ACCEPTED / ADVERSARIAL + FRESH HANDOFF PENDING**  
Course level: **2000**  
Pinned LinuxCNC source: `8bf4605ae81042248add031e94c77300406e0413`

## Learning objective

A fresh AI engineer must be able to design LinuxCNC diagnostic recording that distinguishes machine/control behavior from recorder behavior. It must explain where `sampler` runs, where `halsampler` runs, how the shared HAL stream crosses realtime/userspace, how lost samples are detected, which recorder-health indicators are authoritative for which failure, and why a plausible retained trace is not sufficient evidence unless provenance and recorder integrity are also retained.

X01 exists because later X02 synchronized diagnostics and F02 compound-fault analysis need evidence that a recorder did not manufacture or hide the apparent timing relationship.

## Official documentation pass

LinuxCNC documentation describes `sampler` as the realtime producer and `halsampler` as the non-realtime consumer. `depth=` sizes the realtime-to-userspace FIFO. The realtime component exports FIFO depth/full/overrun state, and `halsampler -n COUNT` performs a bounded read. `halsampler -t` prints the stream sample number returned to the userspace reader.

Relevant official pages:

- https://www.linuxcnc.org/docs/master/html/en/man/man9/sampler.9.html
- https://www.linuxcnc.org/docs/master/html/en/man/man1/halsampler.1.html
- https://www.linuxcnc.org/docs/master/html/en/man/man3/hal_stream.3.html

**Important experiment-driven correction:** earlier X01 wording treated a gap in `halsampler -t` output as a necessary consumer-visible symptom of producer-side FIFO loss. The authoritative X01-002 experiment falsified that stronger claim for the pinned revision and tested loss mode. Producer overruns and a deterministic sampled payload gap occurred while retained `-t` tags stayed contiguous. Therefore `-t` is retained-order evidence here, not a sufficient producer-loss oracle by itself.

## Community pass

Two field reports remain useful investigation leads:

1. A 2022 forum report initially blamed unreliable capture timing on `sampler`; the eventual cause was userspace orchestration: asynchronous launch, an indefinite `halsampler`, and terminating the reader before it drained the FIFO. The corrected workflow stopped production, read the known FIFO depth with `-n`, and waited for the consumer to finish.
   - https://forum.linuxcnc.org/24-hal-components/46426-problems-with-sampler-halsampler-solved
2. A 2024 logging discussion recommends `sampler` for continuous HAL capture and `halscope` for trigger-oriented intermittent diagnostics, reinforcing that capture architecture must match the evidence question.
   - https://forum.linuxcnc.org/24-hal-components/51202-live-logging-recording-of-hal-pin-states-possible

Community statements remain `COMMUNITY-REPORTED` unless reconciled with source or experiment.

## Source inventory

| Path / symbol | Purpose | X01 significance | Evidence |
|---|---|---|---|
| `src/hal/components/sampler.c::sample()` | Realtime snapshot producer | Copies configured HAL inputs into one stream record and attempts `hal_stream_write()` | SOURCE-CONFIRMED |
| `src/hal/components/sampler.c::init_sampler()` | Exports sampler pins/function | Establishes `full`, `curr-depth`, `overruns`, `enable`, `sample-num`, sample inputs and realtime function | SOURCE-CONFIRMED |
| `src/hal/components/sampler_usr.c::main()` | Userspace reader | Attaches to stream, waits readable, obtains `this_sample` from `hal_stream_read()`, checks returned sequence and optionally prints tags | SOURCE-CONFIRMED |
| `src/hal/hal_lib.c::hal_stream_write()` / `hal_stream_read()` | Shared stream transport | Underlies FIFO availability and userspace stream sequence | SOURCE-CONFIRMED; deep memory-order proof outside X01 need |
| `docs/src/man/man3/hal_stream.3.adoc` | Stream API contract | Documents stream API/overrun accounting | DOC-CONFIRMED |

Detailed end-to-end flow: `call-flows/X01-sampler-recording-and-loss-boundary.md`.

## Function / failure guide

### `sampler.c::sample(void *arg, long period)`

Execution context: realtime HAL function, invoked only when the configuration adds `sampler.N` to a realtime thread.

1. If `enable` is false, no record is emitted; current depth/full are refreshed.
2. Configured sample pins are copied into a local record.
3. `hal_stream_write()` is attempted once.
4. If the write fails, the source explicitly says the FIFO is full/data is lost; `sampler.N.overruns` increments, `full=1`, and current depth is reported at max.
5. A successful write clears `full` and refreshes current depth.

This failure branch is recorder evidence. It does not itself stop the thread or prove a machine/control cycle was skipped.

### `sampler_usr.c::main()`

Execution context: ordinary userspace.

Flow:

`hal_init -> hal_stream_attach -> hal_stream_wait_readable -> hal_stream_read(data,&this_sample) -> local sequence check -> formatted output`.

The code maintains `last_sample`. If returned `this_sample` is not the expected successor, it prints `overrun`; with `-t` it prints `this_sample-1` before payload values.

### Version-sensitive `sampler.N.sample-num` trap

At the pinned revision, `init_sampler()` exports `sampler.N.sample-num`, but inspected `sample()` does not read or increment that pin. `halsampler -t` obtains `this_sample` from `hal_stream_read()`, not from that exported pin. X01 therefore does not teach `sampler.N.sample-num` as the retained-record sequence without separate version-specific proof.

## Authoritative X01-002 experiment

Frozen contract: `experiments/X01-002-sampler-retention-redesign.md`  
Workflow: `34436256547`  
Job: `102741829103`  
Artifact: `10136342576`  
Evidence review: `results/X01-002-authoritative-evidence-review.md`

The retained artifact was independently inspected rather than accepting workflow status alone.

### P1 baseline

- 2,000 retained rows;
- tags `0..1999`, contiguous;
- deterministic payload counter unit-contiguous;
- producer overruns `0`.

### P2 stop/drain

- stopped source counter `373`;
- remaining FIFO depth `354`;
- exactly 354 rows drained;
- terminal retained payload `370`, within frozen `0..3` boundary tolerance;
- post-drain FIFO depth `0`, overruns `0`.

### P3 forced FIFO loss

Before drain: depth `64`, `full=TRUE`, producer overruns `192`, source counter `282`.

After bounded read: producer overruns `206`, source counter `473`, 220 retained rows, zero consumer `overrun` markers, zero `-t` tag gaps, and **one deterministic payload gap**. Independent parsing located the gap at payload **79 -> 286**.

This is the central X01 result:

> clean retained `-t` tags do not prove that the realtime recorder producer lost no records.

The safe conclusion is recorder loss because producer overrun evidence and sampled payload discontinuity agree while the deterministic source continued to advance. It is **not** evidence that the control loop skipped cycles.

### P4 recorder timing observation

Both narrow and wide configurations retained 2,000 rows with zero overruns.

- narrow `servo-thread.time=251`, `tmax=2855`;
- wide `servo-thread.time=400`, `tmax=3196`.

These are environment-specific quantitative observations, not a production deadline guarantee or a causal proof of a fixed width penalty.

### P5 sustained publication

The count was frozen before authoritative execution at 10,000 retained narrow-config records.

- exactly 10,000 rows;
- tags `0..9999` contiguous;
- deterministic payload unit-contiguous throughout;
- producer overruns `0`, `full=FALSE`.

This proves bounded sustained retention in the tested fixture only.

## Claims ledger

| Claim | Classification | Confidence | Boundary |
|---|---|---:|---|
| `sampler` records in realtime; `halsampler` drains in userspace | SOURCE + DOC | high | pinned source verified |
| FIFO-full stream write loses a recorder record and increments producer overrun evidence | SOURCE + TEST | high | does not prove control-cycle skip |
| one successful sampler record is one invocation-level snapshot of configured input pins | SOURCE | high | function order still matters |
| `halsampler -t` uses the sequence returned by `hal_stream_read()` | SOURCE | high | not exported `sample-num` pin at pinned rev |
| contiguous `-t` tags alone prove no producer record loss | **FALSE; TEST-FALSIFIED** | high | X01-002 P3 produced loss with contiguous tags |
| deterministic payload discontinuity + producer overrun reveals missing recorder coverage | TEST-CONFIRMED | high | fixture-specific witness must itself be trustworthy |
| stopping production then boundedly draining preserves terminal evidence better than killing the reader | SOURCE + COMMUNITY + TEST | high | X01 P2 tested bounded drain |
| recorder width/rate may perturb timing | SOURCE/INFERENCE + OBSERVATION | medium-high | production impact remains environment-specific |
| 10,000 clean rows prove indefinite/power-safe logging | **FALSE premise** | high | only bounded software retention was tested |

## Failure modes

- **FIFO saturation:** producer stream write fails; record is lost and producer health shows it.
- **Clean-tag false reassurance:** `-t` output may remain contiguous despite producer-side loss in the tested mode.
- **Userspace drain termination:** retained file can be truncated with FIFO data still pending.
- **Consumer/output backpressure:** slow draining can drive FIFO toward producer loss.
- **Observation-order error:** independent userspace reads can tear a relationship that one same-invocation sampler row would preserve better.
- **Recorder perturbation:** recording consumes execution resources; zero sample loss does not prove zero timing perturbation.
- **Evidence publication loss:** a technically correct run is unusable if raw trace, topology, health and provenance are not retained.

## Prediction check

The original X01-001 prediction expected forced FIFO loss to create a `-t` discontinuity. That prediction was falsified. Under the curriculum's three-attempt rule the experiment was classified **ESSENTIAL NOW / MATERIAL REDESIGN**, not retuned into a pass.

X01-002 froze a replacement prediction before execution: forced producer loss must create producer-overrun evidence plus a discontinuity in a deterministic sampled cycle witness; `-t` tags are characterized but are not required to gap. The authoritative run matched this redesigned prediction.

## Current graduation boundary

The source/documentation/community passes and frozen authoritative laboratory Gates A–J are technically accepted. Remaining curriculum requirements before X01 can be labeled graduated are:

- freeze and pass an adversarial X01 exam;
- incorporate any resulting corrections;
- prepare and obtain a genuinely information-separated fresh-AI handoff with a novel course-level scenario;
- run the counterfactual promotion/sufficiency decision.

The current learner must not self-certify the fresh-AI handoff.

## Higher-level boundary / uncertainty queue

| Item | Why not required for X01-2000 | Destination |
|---|---|---|
| deep HAL stream ring-buffer memory-order proof | current source + bounded runtime evidence is sufficient for recorder-integrity contract | later only if concurrency evidence contradicts assumptions |
| filesystem durability/power-loss retention | different persistence problem from sampler transport integrity | specialized future module if needed |
| physical sensor simultaneity | software sampler cannot prove electrical simultaneity | machine/hardware validation |
| safety-rated logging | requires safety lifecycle/certification beyond diagnostic recorder | external safety engineering |
| production-machine deadline effect of recorder width | depends on actual hardware/load/realtime environment | machine-specific validation |

None of these can overturn the central X01 teaching that recorder producer health, sampled witness continuity, reader lifecycle, provenance and thread order must be separated before inferring machine/control behavior from diagnostic traces.

## Exact checkpoint

Freeze an X01 adversarial exam against this corrected model before answering it. Include a misleading clean-`-t` premise, a version-sensitive `sample-num` question, a producer-full failure-path trace, and a small recorder configuration/code task. After exam/corrections, prepare but do not self-certify the fresh-AI handoff. X02 may only consume the accepted recorder contract according to the dependency graph's acceptance rule.
