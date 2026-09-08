# C04 — promotion and counterfactual audit

Decision: **GRADUATED — 1000 level**

## Required evidence

- documentation/community research: present in `guides/C04-asymmetric-actuator-response-research.md` plus current PID documentation reconciliation;
- pinned-source analysis: `guides/C04-pid-saturation-transition-semantics.md` and pinned `pid.c::calc_pid()` trace;
- predeclared experiment: C04-026 preserved exactly, including its valid Gate-G behavioral failure;
- source-driven corrected experiment: C04-027 frozen before implementation and TEST-CONFIRMED with all Gates A-H passing;
- raw realtime evidence: retained and artifact-published for C04-027;
- frozen adversarial exam: **10/10**;
- fresh-AI novel-scenario handoff: **PASS**.

## Counterfactuals the learner must still answer correctly

1. If B PID saturates while A/B feedback agrees, do not infer a tandem-position fault merely from saturation.
2. If A/B disagreement grows but neither PID saturates, do not infer sufficient physical authority; software output bounds may simply not be the active limit.
3. If `pid.saturated=true` immediately after dynamically setting `maxoutput=0`, do not assume current clipping at the pinned revision; inspect transition history and source semantics.
4. If measured disagreement and PID saturation coexist, do not identify mechanical load, current limiting, hydraulic limitation, or sensor failure without independent evidence.
5. If cross-coupling reduces measured disagreement, do not infer safety-rated anti-racking or validated physical stability.

All five are preserved by the accepted artifacts.

## Durable promotion boundary

C04 competence now includes an implementation-specific warning that was **discovered by falsification rather than taught in advance**:

```text
pid.saturated is controller telemetry with revision/transition semantics
!= a timeless, self-authenticating statement of present physical saturation
```

The learner is expected to trace the exact producer path before using such telemetry in higher-level fault logic.

## Forward dependency

C05 — feedback sensor failure modes — is now the highest-priority unblocked module. It should reuse C04's distinction between measured disagreement and plant truth, then deliberately introduce feedback freeze/scale/jump faults with independent observation evidence. C05 must not prematurely define the final safety response; supervisory/safety policy belongs to later modules.
