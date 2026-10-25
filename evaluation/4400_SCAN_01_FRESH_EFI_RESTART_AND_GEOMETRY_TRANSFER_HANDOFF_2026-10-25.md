# 4400-SCAN-01/02 — independent fresh-AI evaluation handoff
**PREPARED / NOT RUN / NOT SCORED / no hidden answers created**

## Competency
An independent evaluator should supply a **novel** exact-version scenario requiring the learner to distinguish scanner field-clear, OSSD, safety PLC reset, normal CNC fresh command, physical holding and whole-body coverage. The evaluator must separately check physical geometry and monitoring-case timing, not just repeat the S300 manual examples.

## Information separation
Evaluator retains any hidden variant/oracle **outside learner-readable public repository** until learner commits prediction, mechanism, observable result, discriminating checks, alternatives, falsifier, confidence and solution time. Do not use the 24 public scenarios as blind items. The author of this handoff has not executed or scored an evaluation. Follow ../evaluation/BLIND_FEEDBACK_PROTOCOL.md; only independent results may update FEEDBACK_SCORE_LOG.md.

## Evaluation rubric
Use the established five 0–2 dimensions: prediction, mechanism, diagnostic efficiency, uncertainty/safety, confidence calibration. A passing response must never confuse 'sensor reset complete' with 'safe physical Y1/Y2 stop/hold'; must explicitly demand as-built signal routing and geometry; must not propose personnel-exposed fault injection. Record exact oracle provenance, version, contamination check and transfer/retention plan.

## Machine boundary
Selected OpenPressBrake G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No external evaluator, physical stop/hold witness or safety performance rating has been obtained. No GitHub-hosted or local compute was used.
