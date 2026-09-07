# Blind External Feedback Protocol

## Purpose

This protocol measures whether the curriculum produces LinuxCNC competence rather than merely producing convincing notes. It also provides external feedback for the separate experiment in AI-study efficiency.

The governing loop is:

**blind challenge -> precommitted prediction/diagnosis -> external execution or answer reveal -> independent scoring -> error classification -> minimal curriculum correction -> transfer retest -> delayed retention retest**

The learner must not possess the hidden answer, later forum resolution, expected test output, or grading key before committing its response.

## Roles and Information Separation

### Learner
Studies the curriculum and answers blind challenges. It may use only the challenge packet and resources explicitly allowed by that challenge. It must commit its answer before the answer key is revealed.

### Evaluator
Selects challenges, retains hidden answer material, executes objective tests or reveals authoritative/historical outcomes, scores the committed answer, and records evidence. The evaluator must not leak the answer to the learner before commitment.

### Curriculum Controller
Reviews aggregate results and decides whether curriculum or study-process changes are justified. It should respond to repeated failure classes and measured trends rather than rewriting the course around one unusual miss.

These roles may be performed by AI processes, but their information must remain separated for each blind attempt.

## Test Banks

Maintain two conceptually separate banks:

1. **Development bank** — frequent external-feedback challenges used to identify weaknesses and improve the curriculum.
2. **Sealed benchmark bank** — held out from curriculum development and opened only at planned checkpoints to measure generalization. Sealed benchmark answers must not be committed to learner-readable curriculum artifacts before use.

A challenge is contaminated if the learner has already studied its resolution, expected output, grading key, or a near-verbatim equivalent. Mark contaminated challenges and do not count them toward blind competency metrics.

## Preferred LinuxCNC Challenge Sources

Use a mixture of:

- upstream LinuxCNC executable tests with hidden expected/checkresult behavior;
- official documentation examples with objectively checkable results;
- pinned-source behavior questions whose answer can be independently verified after commitment;
- resolved LinuxCNC forum/support cases where the initial symptoms can be separated from the later resolution;
- deliberately constructed faults whose outcome can be executed in the repository laboratory.

Community resolutions are external observations, not automatically source-level truth. Where possible, reconcile a forum resolution with documentation, source, or execution after scoring the learner's diagnosis.

## Challenge Packet

Before learner exposure, create an evaluator-side record containing:

- challenge ID and date;
- course level and target competency;
- source/provenance and version context;
- development or sealed-bank designation;
- initial evidence safe to reveal;
- resources the learner may use;
- hidden answer/resolution or objective execution oracle;
- scoring notes;
- contamination check;
- transfer concept to test later.

The learner receives only the initial evidence and explicitly allowed resources.

## Required Precommitment

Before external feedback is revealed, preserve the learner response with:

1. predicted behavior or primary diagnosis;
2. mechanism believed responsible;
3. expected externally observable result;
4. proposed diagnostic steps or source path;
5. plausible alternatives when warranted;
6. evidence that would falsify the primary hypothesis;
7. confidence from 0 to 100 percent;
8. elapsed solution time;
9. resources actually consulted.

Once committed, the original response is immutable. Corrections must be recorded separately.

## External Feedback

After commitment, obtain feedback from an independent oracle appropriate to the challenge:

- run the upstream or curriculum laboratory test and preserve its actual output/exit status;
- reveal the previously hidden historical resolution;
- reveal the official documented outcome;
- inspect the pinned implementation and/or upstream test only after commitment when source was intentionally withheld.

Workflow success alone is never the oracle when the underlying output can be inspected.

## Scoring — 0 to 10

Score each dimension 0, 1, or 2:

| Dimension | 0 | 1 | 2 |
|---|---|---|---|
| Prediction / diagnosis | materially wrong | partially right | correct |
| Mechanism | wrong/invented | incomplete | correct and causally useful |
| Diagnostic efficiency | misleading/wasteful | workable with excess steps | direct, discriminating path |
| Uncertainty / safety boundary | unsafe or unjustified certainty | partial qualification | appropriate uncertainty and boundaries |
| Confidence calibration | strongly miscalibrated | somewhat miscalibrated | confidence fits evidence/result |

Record total `/10`, but retain all five subscores. Do not award correctness merely for polished prose.

## Error Classification

For every miss or partial miss, classify one or more causes:

- missing knowledge;
- retrieval failure despite available curriculum knowledge;
- incorrect source interpretation;
- bad or hidden assumption;
- alternative hypothesis not considered;
- diagnostic-order inefficiency;
- overconfidence / calibration error;
- version confusion;
- experiment/oracle misunderstanding;
- curriculum gap;
- challenge ambiguity or invalid oracle.

If the challenge or oracle is invalid, mark it `EVALUATION_INVALID`; do not train on or score it as learner failure.

## Correction Rule

Correct the smallest underlying weakness that explains the miss. Do **not** simply paste the challenge answer into the curriculum. The correction should teach the transferable mechanism, diagnostic discriminator, retrieval cue, or reasoning pattern.

One unusual miss is evidence, not an automatic curriculum redesign. Repeated independent misses of the same class are strong evidence for a curriculum or study-method change.

## Transfer Retest

A correction is not validated by repeating the same question. Use a different challenge that exercises the same underlying mechanism with different surface details. The learner should have to recognize and transfer the concept rather than remember the answer.

## Delayed Retention

Where practical, retest the same competency with novel cases at multiple delays, such as:

- after roughly 10 subsequent lessons;
- approximately 24 hours later;
- at a later course-level checkpoint.

Do not require exact timing when scheduling constraints make it artificial; preserve the actual delay and number of intervening lessons.

## Metrics

Maintain aggregate measurements including:

- blind score and five subscores;
- confidence and calibration error;
- solution time;
- lessons/study minutes since prior evaluation;
- lab compute used when applicable;
- first-attempt vs transfer-retest score;
- delayed-retention score;
- repeated error-class frequency;
- contamination/invalid-test rate;
- score trend by competency and course level.

The primary study-efficiency metric is **blind competency gained per unit of substantive study time**, interpreted together with transferability, retention, evidence quality, and compute cost. Never optimize speed alone.

## Study-Method Experimentation

When changing pacing, checkpointing, source depth, experiment frequency, lesson ordering, retrieval aids, or other study-process rules, record the change and compare subsequent blind performance against an appropriate prior window. Avoid claiming causation from tiny samples. Prefer repeated challenges and comparable competency levels.

## Integration with Module Graduation

Normal module adversarial exams and fresh-AI handoffs remain required. Blind external evaluation is an additional independent signal, not a replacement for source evidence or laboratory verification.

A module does not automatically fail because of an unrelated blind challenge. However, a blind miss that demonstrates a central claimed competency is not actually transferable or understood must trigger correction before that competency is treated as securely graduated.

## Initial Cadence

During the 1000 series, aim for a small blind development challenge after a coherent cluster of related modules rather than after every lesson. Use sealed benchmark challenges at larger milestones. Keep evaluation overhead low enough that the curriculum remains primarily a learning program.

## Integrity Rule

**Never allow the learner to inspect the hidden answer merely to make evaluation easier. If information separation cannot be maintained, mark the challenge non-blind and exclude it from blind competency metrics.**
