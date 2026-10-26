# 4400 ROPE-PULL-01 — information-separated competency handoff

**Status:** PREPARED / **NOT RUN**. No blind score, no transfer score, no retention score. No hidden answer or sealed case is present in this learner-readable file.

**Learner material:** [source audit](../research/4400_ROPE_PULL_01_ROCKWELL_SCHNEIDER_CABLE_TENSION_RESET_COVERAGE_OEM_AUDIT_2026-10-26.md) and [public field module](../safety-course/4400_ROPE_PULL_01_WHOLE_SPAN_ACCESS_TENSION_WARNING_AND_RESTART_FIELD_MODULE_2026-10-26.md). Twelve public scenarios are **UNSCORED practice**, not a blind test.

## Independent evaluator instructions

1. Choose an **unseen**, appropriately sourced rope-pull, conveyor or long-span emergency-stop case with a different device/variant and different surface conditions than the public practice. Keep its full OEM manual/version, hidden failure cause, expected response and scoring key **outside learner-visible repository material** until precommitment.
2. Reveal only safe initial facts (machine class, physical observations, accessible cable region, relevant normal-control and safety-controller indications) and explicitly allowed sources. Do not reveal hidden outcome or selected diagnostic trap.
3. Require an immutable learner precommitment stating: diagnosis, causal mechanism, physical hazard and energy boundary, discriminating no-energy/qualified verification steps, competing hypotheses, falsifier, uncertainty, confidence 0–100%, solve time, and resources.
4. Only **after** precommitment reveal the independent OEM/test/physical oracle. Score the five dimensions in `evaluation/BLIND_FEEDBACK_PROTOCOL.md` (0–2 each), including whether the learner distinguishes **warning from trip**, **local switch state from whole-span coverage**, and **stop command from physical safe state**.
5. Mark invalid/contaminated if learner saw answer/key or source evidence was insufficient. Preserve immutable first answer, score/error class, correction, a novel transfer challenge and later retention challenge separately. Do not fill `evaluation/FEEDBACK_SCORE_LOG.md` until a real external result exists.
6. **No unsafe validation**: do not energize an unqualified conveyor/press brake or put people in its hazard zone. A source/documentary unseen case is adequate for an initial conceptual evaluation; physical-machine competence remains separately unproven.

## Expected evaluation boundaries (not answers)

- Device variant, cable geometry, tension state and accessible pull path are distinct.
- Normal LinuxCNC/FPGA indicators cannot be credited as personnel-safety authority.
- Exact manufacturer reset behavior does not authorize queued/automatic restart.
- Exact OEM dimensions and response times are **not** universal machine acceptance values.
- An independent physical stop/hold witness is required to claim a machine safe state.
- If OpenPressBrake equipment is not identified, every as-installed claim remains **UNKNOWN**.

**Open:** external 2520–25F0 competency, this new 4400 handoff, and qualified private G0 Stage A machine evidence. **G0/G1 HOLD**.
