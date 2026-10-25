# Independent evaluation handoff — 4400-PEDAL-01
**2026-10-25 | PREPARED, NOT EXECUTED | information-separated | no hidden answers in learner materials**

## Competency to test
Fresh learner should distinguish exact three-position pedal variant behavior, mechanically latched overtravel, contact transition during manual unlock, the receiving controller's fresh-start responsibility, and independent physical stop/hold. The challenge must not be a verbatim repetition of the published Schmersal example.

## Evaluator-only preparation (not an answer key)
1. Independently choose a new **documented** safety foot-switch variant or a genuinely different fault/transition diagram from original OEM source; record exact document edition/part number and date in a **private evaluator record**. Do not place hidden solution or expected diagram in this public repository.
2. Check that learner has not already seen the resolution, exact state diagram or a near-verbatim scenario. If contaminated, mark **NON-BLIND** and choose a fresh challenge.
3. Supply learner only a bounded problem statement, machine hazard and allowed evidence. Require **precommitment**: predicted transition, mechanism, expected observable contact/command, two discriminating checks, falsifier, confidence 0–100, time and sources used.
4. After immutable precommitment, reveal the OEM original diagram and independently grade the five 0–2 dimensions in `evaluation/BLIND_FEEDBACK_PROTOCOL.md`: prediction, mechanism, diagnostic efficiency, safety/uncertainty, confidence calibration.
5. Record the actual score in `evaluation/FEEDBACK_SCORE_LOG.md`, classify misses, perform minimal correction and schedule a novel transfer and later retention check. Never count a paper worksheet as TEST-CONFIRMED machine stop.
6. Evaluate safety boundary explicitly: learner must refuse to infer machine-level PL/SIL, physical Y1/Y2 HOLD, rescue, or personnel-exposed release from a component contact table.

## Transfer traps worth sampling without revealing answers
- A pedal with automatic release versus one with mechanical latching.
- A two-pedal enclosure where only one pedal carries a safety function.
- A release/repair event that changes a safety contact but not an intentional new command.
- A working NO transition which is not a physical motion witness.
- A qualified electrical safety stop with unresolved hydraulic/gravity drift.
- A change to the safety relay reset parameter after the pedal is replaced.

## Status and boundaries
**Prepared:** evaluation packet design only. **Not run:** no external learner precommitment, oracle reveal, score, transfer or retention. No live machine test. Original OEM provenance in [research audit](../research/4400_FOOT_PEDAL_LATCH_UNLOCK_PULSE_IK_RELEASE_VARIANT_OEM_AUDIT_2026-10-25.md); learner-facing [module](../safety-course/4400_PEDAL_01_THREE_POSITION_OVERTRAVEL_UNLOCK_AND_FRESH_START_MODULE_2026-10-25.md) and [paper card](../safety-course/4400_PEDAL_01_TECHNICIAN_TRANSITIONS_AND_BLANK_WITNESS_2026-10-25.md). Keep external scorer independent; do not self-grade. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED.
