# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05 — custom operator interface patterns**, **C01 — simulated dual-actuator machine**, and **C02 — independent feedback loops** are **GRADUATED at 1000 level**.

Phase 10 remains active. The highest-priority unblocked module is **C03 — explicit cross-coupling**, state **EXAM**.

C03-025 now has an accepted frozen-gate experiment. Graduation is **not** claimed yet: the already-frozen adversarial exam must be scored, then the required fresh-AI novel-scenario handoff and promotion/counterfactual audit must pass.

## Blind development baseline — BL-DEV-001

The learner response was immutably committed in `evaluation/development/BL-DEV-001-precommit.md` at commit `2117ac7103f929a0d90b59551785500d2b59b874` before oracle inspection.

Result: **VALID, 10/10, 92% confidence**. Detailed evaluation is in `evaluation/development/BL-DEV-001-evaluation.md`; the score ledger is `evaluation/FEEDBACK_SCORE_LOG.md`.

A novel retention/development challenge should sample a different mechanism after roughly 10 subsequent lessons or about 24 hours, preserving the actual delay.

## C01 — simulated dual-actuator machine — GRADUATED 1000

Pinned revision: `8bf4605ae81042248add031e94c77300406e0413`.

Accepted C01-023: workflow `34209185893`, job `102005842122`, artifact `10049218375`, inner exit `0`, Gates A-H PASS. Realtime sampling observed 5 inches of movement on both duplicated Y commands with `max-abs-j1-j3-command-diff=0` and zero sampler overruns.

Retained boundary:

```text
same coordinated command
!= same observation instant
!= independent feedback agreement
!= same physical position
!= synchronized plant
!= safety-rated protection
```

Graduation evidence is in `evaluation/C01-1000-graduation-evaluation.md`.

## C02 — independent feedback loops — GRADUATED 1000

Pinned revision remains `8bf4605ae81042248add031e94c77300406e0413`.

C02 established that two PID instances receiving a common command retain separate command/feedback/error/output state and can diverge under an asymmetric plant disturbance. The accepted retained-evidence result and graduation artifacts are committed under `results/`, `guides/`, `call-flows/`, and `evaluation/`.

Retained boundary:

```text
shared command
!= shared feedback state
!= shared control error
!= synchronized physical plant
!= implicit cross-coupling
!= safety-rated disagreement protection
```

## C03 — explicit cross-coupling — EXAM

Pinned revision: `8bf4605ae81042248add031e94c77300406e0413`.

### Source-grounded topology

Pinned `sum2.comp` computes `out = in0*gain0 + in1*gain1 + offset`; pinned `scale.comp` computes `out = in*gain + offset`. C03 implements the explicit law:

```text
D = feedback_B - feedback_A
C = Kc * D
command_A = base + C
command_B = base - C
```

The coupler runs before the local PIDs/plants; realtime sampler runs after the plants. Exact arithmetic therefore uses the coupler's own sampled D/C signals and realtime residuals rather than naively recomputing from same-row post-plant feedback.

Durable source/observation guide: `guides/C03-phase-publication-and-cross-coupling-boundary.md`.

### C03-025 attempt history

Frozen plan: `experiments/C03-025-explicit-cross-coupling-plan.md`.

- **Attempt 1** — workflow `34226127383`, job `102060582084`, artifact `10055927769`, inner exit `31`: **HARNESS INVALID**. A configuration transition was sampled under a decisive phase label. Reconciled in `results/C03-025-attempt-1-reconciliation.md`.
- **Attempt 2** — workflow `34227719033`, job `102065844076`, artifact `10056559295`, inner exit `31`: **HARNESS INVALID**. Delaying the new phase after a configuration write merely contaminated the old phase during the settle interval. Reconciled in `results/C03-025-attempt-2-reconciliation.md`.
- **Attempt 3** — workflow `34228231147`, job `102067547546`, artifact `10056799485`, source commit `99f7c35ce3cfd23aa96c11f0168c798ff8607c7c`, inner exit `0`: **PASS / TEST-CONFIRMED, Gates A-H**.

Attempt 3 changed only test instrumentation: phase 0 is published and settled before each configuration mutation, then the new configuration is settled before publishing the next decisive phase. Frozen gains, `Kc`, thresholds and decisive durations were unchanged.

Decisive accepted evidence:

```text
sampler-overruns=0
realtime-samples=11199
phase-2-samples=3013
phase-3-samples=3013
phase-4-samples=3012

U (uncoupled disturbed) = 0.703374228 in
X (coupled Kc=0.5)     = 0.377045040 in
R (coupler removed)    = 0.738476396 in
X/U                     = 0.536051827023
R/X                     = 1.95858933988

phase-3 qualified sign rows=3013
direction-correct rows=3013
max realtime arithmetic residuals=0
phase-4 max correction last500=0

gate-B=PASS
gate-C=PASS
gate-D=PASS
gate-E=PASS
gate-F=PASS
gate-G=PASS
gate-H=PASS
C03-025 overall=PASS
```

The explicit coupler reduced sustained simulated disagreement by about **46.4%** under the frozen B-only slowdown, and removing it caused disagreement to rebound to about **1.96x** the coupled value.

Accepted result: `results/C03-025-accepted-result.md`.

Retained boundary:

```text
reduced simulated disagreement
!= proven physical alignment
!= proven stability across gains, delays, saturation, loads or faults
!= validated hydraulic/mechanical press-brake synchronization law
!= safety-rated anti-racking protection
```

### Exact next-work checkpoint

1. Score the already-frozen `evaluation/C03-adversarial-exam-draft.md` without changing its questions or grading requirements.
2. Run the required fresh-AI novel-scenario handoff against a scenario that combines at least correction saturation plus sensor/plant asymmetry and requires preservation of the C02/C03 evidence boundary.
3. Perform the promotion/counterfactual audit. If all three pass, commit `evaluation/C03-1000-graduation-evaluation.md` and graduate C03; otherwise enter CORRECTIONS with the exact failed requirement.
4. Do **not** proceed to a fourth C03-025 experiment unless a new evidence requirement is identified; the frozen behavioral experiment is already accepted, and the plan's three-attempt guardrail has been reached.

## T03 retained boundary

T03-020 passed frozen Gates A-G. Retained rule: **command acknowledgement/order, semantic result, diagnostics, physical truth and safety truth are distinct evidence domains.**

## T04 retained boundary

T04-021 passed frozen Gates A-H. Retained rule: **a rendered GUI value is a presentation claim; identify its source and freshness before treating it as current controller state.**

## T05 retained boundary

```text
GStat construction / retained cache
!= validated/current observation
!= command acceptance
!= physical action
!= safety authority
```

Higher-level T05 promotions remain multi-command-producer correlation/races, error-channel fan-out, remote UI/NML reconnect/timing failures, physical pendant/HALUI behavior, and specialized safety-HMI architecture/certification.

## Laboratory compute / timing notes

`LAB_COMPUTE_LOG.md` contains the authoritative backfill through earlier capstone runs. Invalid runs are retained rather than hidden and should be backfilled for C03 attempts 1-3 at the next compute-accounting pass.

Canonical session timing rows live in `LESSON_LOG.md`. Earlier unclosed-session uncertainty must remain explicit rather than being repaired with invented timestamps.
