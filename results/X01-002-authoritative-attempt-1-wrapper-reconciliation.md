# X01-002 authoritative attempt 1 — wrapper failure reconciliation

## Identity

- Module: X01 — recorder perturbation and long-duration retention, 2000 level
- Frozen experiment: `experiments/X01-002-sampler-retention-redesign.md`
- LinuxCNC revision under test: `8bf4605ae81042248add031e94c77300406e0413`
- Workflow: `34432706789`
- Job: `102731363601`
- Source commit: `eaea57d58fb6c60e3ea30e1a6cc3e2f22a59101d`
- Retained workflow artifact: `10135052507`
- Job start/end: `2026-09-10T03:16:39Z` / `2026-09-10T03:16:47Z`
- Actual job runtime: 8 s = 0.13 min
- Classification: **HARNESS INVALID — wrapper generation failure before behavioral execution**

## Evidence

The retained `lab-results/LATEST.md` has an empty stdout and a Python `SyntaxError` from the source-rewrite wrapper:

```text
File "<stdin>", line 40
  needle2 = ...
SyntaxError: unexpected character after line continuation character
```

The error occurred while `lab-jobs/031-x01-002-sampler-retention-authoritative.sh` was constructing its generated authoritative script. It occurred before the underlying X01 fixture cloned/built LinuxCNC or entered P0. Therefore no P0–P5 observation exists from this run.

**Frozen Gates A–J: UNSCORED.** Workflow failure is not evidence of LinuxCNC or sampler behavior.

## Root cause

The wrapper used a triple-single-quoted Python string to search for generated scorer text that itself begins an `f'''...'''` string. The nested delimiter was syntactically invalid in the wrapper program, so Python could not execute the rewrite.

This is a generator/wrapper defect, not a defect in the frozen recorder-integrity model.

## Minimal correction

Commit `e2f25c5f873d9683e36430142de5cad3fc9350a8` changes only the wrapper representation of the scorer insertion strings: the outer Python literals are triple-double-quoted so the generated scorer's `f'''...'''` delimiter is ordinary content.

The correction does **not** change:

- pinned LinuxCNC revision;
- 1 ms fixture period;
- source-before-sampler order;
- P1/P2/P4 counts;
- P2 `0..3` cycle tolerance;
- P3 FIFO depth 64;
- P3 250 ms reader starvation;
- P3 bounded 220-record read;
- X01-002 producer-overrun + deterministic-payload-gap loss oracle;
- interpretation of `halsampler -t` as ordering evidence for successfully retained records only;
- P5 predeclared 10,000-record sustained capture; or
- Gates A–J.

The correction push launched workflow `34436256547`. It is the next authoritative attempt for the same frozen X01-002 contract and must be judged from retained evidence, not workflow status alone.

## Documentation / community reconciliation

Current LinuxCNC documentation continues to describe `sampler` as the realtime FIFO producer and `halsampler` as the non-realtime userspace drain. HAL streams are intended for non-blocking realtime transfer. These sources support keeping producer recording and userspace consumption as distinct execution contexts:

- https://linuxcnc.org/docs/html/man/man9/sampler.9.html
- https://linuxcnc.org/docs/html/man/man1/halsampler.1.html
- https://linuxcnc.org/docs/devel/html/man/man3/hal_stream.3.html

A LinuxCNC forum report also demonstrates a userspace-lifecycle failure mode: terminating `halsampler` before FIFO drain produced incomplete captures; disabling the sampler and boundedly draining the known FIFO contents corrected the workflow. This is a community report rather than source truth, but it independently motivates P2's bounded stop/drain discipline:

- https://forum.linuxcnc.org/24-hal-components/46426-problems-with-sampler-halsampler-solved

## Evidence classification

- Wrapper failure and exact job timing: **TEST-CONFIRMED harness evidence**.
- No LinuxCNC behavioral conclusion is permitted from attempt 1.
- Sampler/halsampler execution-context distinction: **DOC-CONFIRMED**, with pinned source work retained elsewhere in X01.
- Early-reader-termination capture issue: **COMMUNITY-REPORTED**, consistent with the frozen bounded-drain test design.

## Checkpoint

Inspect workflow `34436256547`, its exact job metadata, readable result, and retained X01 evidence. If it reaches P0–P5, score the existing frozen Gates A–J without retuning the experiment. If it fails before behavior, classify that failure separately and preserve the attempt count rather than interpreting wrapper failure as sampler behavior.
