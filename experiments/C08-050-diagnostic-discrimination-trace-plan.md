# C08-050 — Diagnostic Discrimination and Trace-Validity Experiment Plan

Status: **FROZEN BEFORE IMPLEMENTATION / OUTPUT INSPECTION**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Objective

Demonstrate, with reproducible retained evidence, that two different realtime causal histories can present the same coarse userspace symptom, while a correctly ordered realtime `sampler` trace can distinguish them. Independently demonstrate that `halsampler` tag continuity is not a sufficient no-loss oracle when producer-side FIFO writes are rejected.

This experiment tests evidence selection and evidence validity, not machine safety.

## Predeclared predictions

1. Two phases will each present the same coarse userspace observation: `c08diag.symptom = TRUE`.
2. Realtime cause history will differ:
   - **Cause A:** `cause-a` and `symptom` assert in the same producer invocation.
   - **Cause B:** `cause-b` asserts first and `symptom` asserts on a later producer invocation.
3. With function order retained as `c08diag.update` before the main `sampler` function, the realtime trace will expose that distinction.
4. Separate sequential `halcmd` reads are point observations only; they are not accepted as proof of same-cycle ordering.
5. A deliberately tiny sampler FIFO left undrained will become full and accumulate producer overruns.
6. Rejected full-FIFO writes will increase `sampler.0.overruns`, while the sequence numbers of records that were successfully enqueued can still be contiguous when later drained.
7. Therefore consumer tag continuity alone will be rejected as sufficient evidence that no realtime sample attempts were lost.

## Fixture

Use only a lab-scoped deterministic realtime component named `c08diag` plus stock pinned LinuxCNC HAL/sampler infrastructure. Do not modify production LinuxCNC source.

Required `c08diag` HAL objects:

- `c08diag.phase` — `u32` input controlled by the harness and sampled as provenance.
- `c08diag.inject-a` — bool input.
- `c08diag.inject-b` — bool input.
- `c08diag.cause-a` — bool output.
- `c08diag.cause-b` — bool output.
- `c08diag.symptom` — bool output.
- `c08diag.update` — realtime function.

Behavior required of the lab component:

- quiescent inputs clear all three outputs;
- while `inject-a` is active, `cause-a` and `symptom` assert in the same `c08diag.update` invocation and `cause-b` remains clear;
- on the first `c08diag.update` invocation after `inject-b` rises, `cause-b` asserts but `symptom` remains clear;
- on a later invocation while the B episode remains active, `symptom` asserts while `cause-b` remains asserted;
- clearing `inject-b` returns the B path to a re-armable quiescent state.

The main trace sampler must be placed **after** `c08diag.update` in one realtime thread and must capture, at minimum, `phase`, `cause-a`, `cause-b`, and `symptom` in one sampler invocation.

A separate tiny-FIFO sampler channel is used only for the overrun validity subtest so deliberate overflow cannot invalidate the main causal trace.

## Phases

### P0 — baseline

Publish phase 0 before any mutation. Both injection inputs and all cause/symptom outputs must be false.

### P1 — Cause A episode

Publish phase 1 before driving `inject-a=true`. Hold long enough for a bounded coarse userspace `halcmd getp c08diag.symptom` observation after realtime assertion. Then clear `inject-a`.

Expected coarse symptom: TRUE.

Expected main-trace signature: at the first symptom assertion attributable to P1, `cause-a=1`, `cause-b=0`, and no earlier P1 row has `cause-a=1` with `symptom=0`.

### P2 — re-baseline

Publish phase 2 before returning/holding both injection inputs false. Require all cause/symptom outputs false before continuing.

### P3 — Cause B episode

Publish phase 3 before driving `inject-b=true`. Hold long enough for the two-step B behavior and a bounded coarse userspace `halcmd getp c08diag.symptom` observation after symptom assertion. Then clear `inject-b`.

Expected coarse symptom: TRUE — deliberately the same coarse observation as P1.

Expected main-trace signature: at least one P3 row with `cause-b=1`, `cause-a=0`, `symptom=0` must precede the first P3 row with `cause-b=1`, `cause-a=0`, `symptom=1`.

### P4 — final baseline

Publish phase 4 before holding both injection inputs false. Require all cause/symptom outputs false.

## Tiny-FIFO overrun subtest

Use a separate sampler channel with depth 4 (usable queue capacity expected to be 3 records). Add its realtime sampling function to a running thread while no userspace consumer is attached.

Before draining:

- retain `sampler.0.overruns`, `sampler.0.full`, and `sampler.0.curr-depth`;
- require `overruns > 0` and evidence that the producer reached full capacity.

Then stop/disable further production for this channel, attach `halsampler -c 0 -t`, drain the retained records, and retain collector exit status/stderr/output. The analyzer may observe contiguous tags among successfully enqueued records; such continuity must **not** override the producer-side overrun proof.

## Frozen Gates A–J

### Gate A — provenance / source integrity

PASS only if the exact LinuxCNC commit is retained, relevant production source hashes are retained, the lab component/harness/config are retained, and no production LinuxCNC source is modified.

### Gate B — topology and function-order provenance

PASS only if retained HAL thread/function evidence proves the relevant order is `c08diag.update` before the main sampler function. The trace is not authoritative if this order is absent or ambiguous.

### Gate C — collector validity

PASS only if the main `halsampler` collector actually attaches, produces non-empty tagged output, exits cleanly, and has retained stderr/exit status. Mere HAL-object presence is insufficient.

### Gate D — main-trace no-loss evidence

PASS only if the main sampler's producer-side `overruns` remains zero for the authoritative causal trace and collector tags are monotonic/contiguous for the retained interval. Consumer continuity alone is insufficient; producer overrun state is mandatory.

### Gate E — baseline integrity

PASS only if P0 and P4 contain quiescent rows with `cause-a=0`, `cause-b=0`, `symptom=0` and the harness publishes phase before decisive injection mutations.

### Gate F — same coarse userspace symptom

PASS only if bounded userspace point observations in both P1 and P3 each record `c08diag.symptom=TRUE`. These reads prove only that the same coarse symptom was observable in both phases; they are not treated as atomic causal evidence.

### Gate G — Cause A realtime discrimination

PASS only if P1 main-trace evidence shows symptom assertion associated with `cause-a=1`, `cause-b=0`, with no earlier P1 sampled row showing `cause-a=1`, `symptom=0`.

### Gate H — Cause B realtime discrimination

PASS only if P3 main-trace evidence contains a sampled `cause-b=1`, `cause-a=0`, `symptom=0` row that strictly precedes the first sampled `cause-b=1`, `cause-a=0`, `symptom=1` row.

### Gate I — tiny-FIFO overrun semantics

PASS only if the separate depth-4 producer records `overruns>0` while undrained and the retained drain demonstrates that consumer record tags alone are not used to claim no loss. Contiguous successfully enqueued tags are allowed and, if observed, strengthen the intended discriminator.

### Gate J — evidence/safety interpretation

PASS only if reconciliation states explicitly:

- sequential `halcmd` reads are not an atomic servo-cycle trace;
- one sampler invocation is coherent only to that sampler/function-order boundary;
- producer overrun evidence is required before claiming attempted samples were not dropped;
- HAL trace, Task/NML text/status, process logs, and physical observations do not share a universal atomic clock unless separately synchronized;
- diagnostic evidence is not a safety-rated function and does not prove physical machine state.

## Invalid-run rules

Do not score Gates F–I as LinuxCNC behavioral failures if any of Gates A–D fails first. Classify such a run as **HARNESS INVALID** and repair only the evidence harness defect without weakening these frozen gates.

If three materially similar attempts fail, apply the repository ESSENTIAL NOW / PROMOTE / DROP rule before another similar attempt.

## Non-authoritative preflight requirement

Before one authoritative C08-050 execution is allowed, run a non-authoritative preflight that proves:

1. `c08diag` builds/loads and required HAL objects exist;
2. exact thread order is retained and shows producer before main sampler;
3. an actual main collector attaches and obtains at least one valid tagged record;
4. phase publication occurs before injection mutation;
5. P1 and P3 produce the intended distinguishing trace shapes in a smoke-scale run;
6. tiny-FIFO overrun evidence can be retained and drained without being confused with the main trace.

The preflight may validate implementation mechanics but **must not score Gates A–J**.

## Authority boundary

Only a later run explicitly declared authoritative **before execution**, using this unchanged plan and unchanged gates, may become C08 TEST-CONFIRMED behavioral evidence.
