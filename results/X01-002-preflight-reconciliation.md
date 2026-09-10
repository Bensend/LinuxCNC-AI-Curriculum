# X01-002 redesigned preflight reconciliation

Date: 2026-09-10  
Course level: 2000  
LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Run inspected

- Workflow: `34428664862`
- Job: `102719239856`
- Experiment commit: `09116c106fa0b164022c3b52da2a37bbd1739fe7`
- Retained artifact: `10133717168`
- Job timestamps: `2026-09-10T02:14:36Z` through `2026-09-10T02:19:03Z`
- Actual job runtime: 267 s = **4.45 min**
- Inner laboratory execution recorded `2026-09-10T02:14:42Z` through `2026-09-10T02:18:57Z` and exit code 0.

## Artifact-level preflight audit

Workflow success was not used as the behavioral oracle. The retained artifact was downloaded and the phase evidence was inspected independently.

### P0 — provenance

PASS for preflight validity. The artifact retains the pinned LinuxCNC commit, 1 ms servo period, frozen experiment path, sampler configuration/topology files, source component, HAL files, thread snapshots, and process logs. The run identifies itself as non-authoritative and leaves Gates A–J unscored as required.

### P1 — normally drained baseline

PASS for preflight validity.

- 2,000 retained rows.
- Successful-stream `-t` tags contiguous.
- Deterministic payload cycle counter contiguous.
- Deterministic companion-field relationships passed the harness assertions.
- Producer `sampler.0.overruns = 0`.

### P2 — bounded stop then drain

PASS for preflight validity.

- Remaining FIFO depth at stop: 353.
- Bounded drain returned exactly 353 rows.
- Producer overruns remained 0 and final FIFO depth was 0.
- Source counter at stop observation: 367.
- Last retained payload counter: 364.
- Difference = 3 cycles, exactly at the frozen `0..3` tolerance boundary.

### P3 — forced FIFO saturation / redesigned loss oracle

PASS for preflight validity and, critically, exercises the material redesign rather than the falsified X01-001 oracle.

- Pre-drain `full=TRUE`.
- Producer overruns before drain: 191.
- Producer overruns after the bounded read: 201.
- Source counter advanced 273 -> 456 while recorder loss existed.
- Bounded reader retained 220 rows.
- Consumer `overrun` markers: 0.
- `-t` tag gaps: 0.
- Deterministic payload-cycle gaps: 1.

This is the expected discriminator: successfully retained stream tags can remain contiguous while producer records are omitted. Recorder loss is therefore established by FIFO-full/producer-overrun evidence plus deterministic payload discontinuity, while continued source-counter advance prevents misclassifying recorder loss as proof of a realtime source/control-loop cycle skip.

### P4 — quantitative recorder-load evidence

PASS for preflight validity.

- Narrow capture: `servo-thread.time=566`, `servo-thread.tmax=1650`, producer overruns 0.
- Wide capture: `servo-thread.time=167`, `servo-thread.tmax=1885`, producer overruns 0.

The instantaneous `time` values do not show a monotonic narrow<wide relation, which is allowed by the frozen contract. Retained timing is quantitative cloud-runner evidence only; no deadline, zero-perturbation, physical-hardware, or functional-safety claim follows.

## Decision

**PREFLIGHT VALID.** No harness defect or model retuning is justified. The frozen X01-002 P0–P4 fixture exercised the intended recorder-integrity distinctions. Per the preflight/authoritative policy, the next execution must be a separate authoritative run with the behavioral model unchanged and with a bounded sustained P5 capture selected before launch.

P5 is frozen for the authoritative implementation at **10,000 retained records** using the narrow `ffffb` configuration, concurrent draining, zero producer overruns, contiguous successful-stream tags, contiguous deterministic payload cycles, and retained raw trace/health/provenance. At a 1 ms producer period this is a bounded nominal ~10 s retention interval, while actual cloud scheduling may differ.

## Evidence classification

- X01-002 behavioral model: still not authoritative TEST-CONFIRMED until the independent authoritative run passes.
- Harness validity: independently supported by retained preflight evidence.
- X01-001 `-t`-gap loss oracle: remains falsified for this pinned behavior and must not be restored.

## Exact next checkpoint

Run the separately committed X01-002 authoritative job without changing frozen P0–P4 parameters, loss semantics, stop tolerance, or Gates A–J. Require the predeclared 10,000-record P5 sustained capture. After completion, inspect the retained artifact rather than workflow status alone, score Gates A–J, record exact job runtime, then continue X01 failure analysis/exam/handoff only if the authoritative evidence is accepted.
