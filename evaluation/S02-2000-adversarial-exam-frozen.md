# S02 2000-level adversarial exam — FROZEN BEFORE AUTHORITATIVE RESULT REVIEW

Frozen UTC: 2026-09-09
Module: S02 — feedback integrity, diversity and common-cause reasoning
LinuxCNC source baseline: `8bf4605ae81042248add031e94c77300406e0413`
Status: **FROZEN / unanswered**
Score: 20 points total; graduation requires 18/20 **and no critical trap accepted**.

This exam is intentionally frozen before inspection/scoring of the independent authoritative S02 runtime. Do not modify questions, critical traps or point weights to match later evidence.

## Allowed resources when answering

Learner may use:

- S02 research/call-flow artifacts;
- pinned LinuxCNC source and official documentation;
- prior graduated curriculum artifacts;
- retained authoritative S02 artifact after Gates A–J are scored.

Do not use an answer key prepared in advance. The committed learner answer is immutable; corrections, if needed, are separate.

## Questions and scoring

### Q1 — agreement is not truth (3 points)

Two encoder channels report exactly the same position for 500 consecutive servo periods. The relevant hm2_eth board transactions are clean. An integrator concludes: “Both encoders are fresh, independent, and physically correct.”

Explain every inference that is and is not justified. State what additional evidence would be required to establish each missing property: sensor freshness, independence/diversity, and physical truth.

- 1 pt: clean transport is bounded to the checked board transaction rather than promoted to per-sensor physical truth.
- 1 pt: equal values do not establish freshness in a stationary/ambiguous case.
- 1 pt: agreement does not establish independence or common-cause freedom; identifies a genuinely independent discriminator/oracle category rather than merely adding another derived software copy.

### Q2 — version-pinned source path (2 points)

At the pinned revision, trace the narrow evidence path from an hm2_eth read transaction through the transport checks/error surfaces relevant to deciding whether a checked board response is current/acceptable. Then state where that evidence stops: which per-encoder or physical properties are *not* established by that path?

- 1 pt: source path/symbols are version-pinned and causally ordered rather than generic prose.
- 1 pt: stops at board-transaction evidence; no invention of per-encoder freshness, mechanics, independence or physical truth.

### Q3 — stale channel during motion vs stationary ambiguity (3 points)

Case A: modeled physical position is changing, channel A follows it, channel B remains bit-for-bit constant, and transport remains healthy.

Case B: the mechanism is intended to remain stationary, both reported channels remain constant/equal, and transport remains healthy.

For each case, give the strongest defensible diagnosis *from the stated evidence only*. Why are the two conclusions different?

- 2 pts: Case A can support a stale/frozen-channel conclusion only because an independent motion/truth reference creates a discriminator; transport health does not rescue B.
- 1 pt: Case B is `UNKNOWN` sensor freshness from value-only evidence; stationary equality cannot prove freshness.

### Q4 — common-mode adversary (3 points)

A detector may consume only `reported_A`, `reported_B`, and a clean transport-health bit. Construct a common-mode fault in which both reports agree and transport remains healthy while the physical mechanism is wrong. Can any deterministic detector restricted to those three inputs *guarantee* detection of that fault? Explain without hand-waving.

- 1 pt: valid false-agreement construction.
- 1 pt: recognizes observational indistinguishability from a healthy state at the detector inputs; no guaranteed detection.
- 1 pt: states what class of independent evidence can break the ambiguity and keeps test-only ground truth distinct from production signals.

### Q5 — quadrature diagnostic scope (2 points)

An encoder interface reports a quadrature sequence/counting diagnostic clean for an entire run. An engineer wants to treat this as proof that the encoder is mechanically coupled, fresh, correctly scaled, independent of the second channel, and physically truthful.

Which claims are justified, which are not, and why?

- 1 pt: scopes the diagnostic to the fault class it can actually observe (e.g. illegal sequence/counting-path issues as implemented/configured).
- 1 pt: rejects universal validity, coupling, scale, freshness, diversity and physical-truth claims absent separate evidence.

### Q6 — watchdog/feedback misleading premise (2 points)

“HostMot2 watchdog healthy means the encoders are valid; watchdog tripped means their internal feedback state must have stopped updating.” Evaluate both clauses.

- 1 pt: separates watchdog/output-I/O authority from sensor-validity authority.
- 1 pt: recognizes that internal module state may continue independently of physical I/O disconnect behavior; no unsupported equivalence between watchdog state and encoder freshness.

### Q7 — evidence integrity / recorder adversary (2 points)

A runtime trace shows the desired S02 discriminator, but the producer reports sampler overruns and the retained rows skip sample tags around the transition. May the run prove a one-servo-cycle detection bound? What can still be claimed, and what evidence repair is required?

- 1 pt: rejects precise latency/atomic-sequence proof across missing producer samples.
- 1 pt: separates potentially usable qualitative observations from invalid timing proof and requires producer-side recorder-health/contiguous atomic evidence for the latency claim.

### Q8 — bounded HAL design task (3 points)

Sketch a HAL/realtime monitoring design for a dual-feedback axis that:

1. detects pairwise disagreement above a configured threshold;
2. does **not** label equal stationary values “fresh” without an independent freshness witness;
3. keeps transport health as a separate diagnostic dimension;
4. exposes an explicit `unknown/not-proven` state where evidence is insufficient;
5. never claims to be a functional-safety function merely because it runs in realtime.

Name the essential inputs/outputs/state and describe update ordering sufficient to avoid a one-cycle stale comparison. Do not rely on userspace polling for the realtime detection decision.

- 1 pt: correct signal/state partition including explicit unknown/not-proven semantics.
- 1 pt: same-thread/update-order reasoning prevents comparing mismatched-cycle values.
- 1 pt: safety boundary and userspace/realtime authority are stated correctly.

## Critical traps — any accepted trap prevents graduation regardless of numeric score

1. Clean hm2_eth transaction = proof of per-encoder physical freshness.
2. Equal encoder values = proof that both sensors are fresh.
3. Agreement between two channels = proof of independence/diversity.
4. Pairwise agreement = physical truth even under common-mode faults.
5. Clean quadrature diagnostic = universal encoder validity/mechanical coupling proof.
6. HostMot2 watchdog state = encoder-validity oracle.
7. Missing/overrun realtime samples may still support an exact one-cycle detection bound without qualification.
8. A synthetic laboratory `physical_*`/oracle signal may be assumed to exist as a production LinuxCNC truth source.
9. Realtime software monitor = functional-safety function by virtue of realtime execution alone.
10. Userspace sequential polling is accepted as atomic same-servo-cycle evidence for a bounded realtime detector.

## Required answer structure

For every question, the learner must distinguish `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `INFERENCE`, and `UNKNOWN` where materially relevant; version-sensitive statements must name the pinned revision. If an assertion cannot be supported, say `UNKNOWN` rather than inventing behavior.
