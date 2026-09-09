# C06-046 — authoritative phase-first transport/watchdog experiment

Status: **PASS / ACCEPTED TEST-CONFIRMED C06-030 EVIDENCE**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

Workflow: `34312802937`  
Job: `102342754452`  
Artifact: `10089037385`  
Artifact digest: `sha256:331b7f0992de267294dff90990e051e24b6fb79d81cfdd0c707db44d7c63e6d8`

Authoritative job runtime: 2026-09-09T04:54:49Z–04:58:13Z = **3.4 min**.

## Provenance / preflight relationship

C06-045 had already proven the phase-first observation protocol non-authoritatively. C06-046 uses that exact retained expanded harness. The retained `preflight-to-authoritative-label-only.diff` contains exactly two textual changes:

1. the banner changes from non-authoritative preflight to authoritative run;
2. the terminal success label changes from non-authoritative to authoritative.

No phase duration/order, injection threshold, fixture behavior, watchdog register, HAL topology, production HostMot2 source, sampler configuration, or Gate A–H analyzer logic changed between the passing preflight and authoritative run.

## Frozen Gate A–H result

The retained analyzer reports:

- Gate A **PASS** — pinned SHA, retained fixture patch, production-source identity, real watchdog topology.
- Gate B **PASS** — **2,976** single-stream rows, strictly increasing sample numbers, sampler stderr retained and empty.
- Gate C **PASS** — P0 healthy transport, `io_error=false`, `watchdog.has_bit=false`, normal read/write activity advances.
- Gate D **PASS** — P1 contains the single transient failed read, successful reads resume, watchdog remains clear.
- Gate E **PASS** — P2 reaches harness `io_error=true` after the frozen three-consecutive-failure threshold while watchdog command/status/`has_bit` remain clear; normal HostMot2 service evidence freezes.
- Gate F **PASS** — P3 explicit transport-fault removal plus `io_error` clear restores normal service without a watchdog event.
- Gate G **PASS** — P4 healthy transport plus emulated watchdog status bit asserts real `watchdog.has_bit`; P5 holds it asserted until explicit clear.
- Gate H **PASS** — P6 explicit watchdog-status removal and `has_bit` clear permits recovery/normal service.

Authoritative lab exit code: **0**.

## Accepted teaching

The experiment independently verifies the central C06 separation at the pinned revision and in this deterministic hardware-free fixture:

```text
low-level communication failure != HostMot2 watchdog bite
io_error can assert while watchdog.has_bit remains false
watchdog.has_bit can assert with healthy transport and io_error=false
transport recovery != watchdog recovery
fault-state recovery != proof a physical machine is safe to resume
```

The test threshold of three consecutive failed reads remains explicitly a **fixture analogue**, not a claim about every `hm2_eth` installation's `packet-error-limit` configuration.

## Evidence classification

- Transport/watchdog state separation and distinct recovery behavior in the pinned fixture: **TEST-CONFIRMED**.
- Generic HostMot2 ordering/recovery mechanisms previously traced in pinned source: **SOURCE-CONFIRMED**.
- Version-independent claims about all firmware/driver combinations or functional-safety guarantees: **NOT ESTABLISHED** and not taught as such.

## Next graduation work

C06-030 no longer blocks graduation. Next: run the C06 adversarial exam, then a fresh-AI novel-scenario handoff, incorporate any corrections, populate the higher-level uncertainty queue, and apply the counterfactual promotion/graduation sufficiency audit.
