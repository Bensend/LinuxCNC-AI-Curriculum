# Safety Sandbox Evaluator Calibration Pack

Status: WORKING EVALUATOR CALIBRATION — NON-BLIND TRAINING MATERIAL

Purpose: calibrate evaluators using the public rubric in `SAFETY_SANDBOX_EVALUATOR_RUBRIC_SCORECARD.md`. These examples are not sealed challenges and must not be counted as blind competency evidence.

## Calibration rule

Score engineering reasoning, not verbosity or conservatism. A learner must identify the actual person/task/hazard boundary, keep ordinary LinuxCNC/FPGA control separate from independent safety authority, demand evidence appropriate to the physical claim, preserve UNKNOWNs, and make recovery and safeguards usable enough that defeat is not the normal path.

Scores below are target ranges rather than pseudo-precision. Any automatic-fail gate overrides the numeric score.

## Pair A — concise bounded reasoning vs standards-heavy overclaim

Scenario: A guarded mill reports `motion.enable = FALSE` after the guard opens. No independent final-element or standstill evidence is supplied.

**A1 — preferred:** “The LinuxCNC indication shows normal-control state, not personnel-safe standstill. Keep the guard safety demand active and require the architecture’s independent evidence that the relevant hazardous motion/energy has reached its required safe condition. Actual stopping time and whether this machine has a validated standstill function are UNKNOWN from the supplied evidence. Guard reset must not itself restart the spindle or axes.”

Target: 24–28/28; no automatic fail. Reward explicit authority boundary, evidence request, UNKNOWN discipline, and recovery separation.

**A2 — fail:** “ISO 13849 and IEC 60204 require safe stopping. LinuxCNC has disabled motion and the FPGA watchdog is healthy, so the redundant controls prove the mill is safe to enter.”

Target: automatic fail gates 1/2/9. Standards terminology does not convert ordinary controller status into physical safety evidence.

## Pair B — blanket shutdown vs task/hazard-specific architecture

Scenario: An operator must replenish material outside a fenced robot cell while the robot remains physically separated. The proposal is to remove all plant power for every replenishment.

**B1 — weak/conservative:** “Any interaction near a robot should require complete facility lockout and all power removed.”

Target: roughly 12–18/28. Do not automatic-fail merely for being conservative, but score down failure to define the actual task/hazard boundary and failure to distinguish production safeguarding from maintenance energy isolation. Excessive nuisance can create bypass pressure.

**B2 — preferred:** “First establish whether replenishment can be completed entirely outside the safeguarded space. If so, preserve the validated cell boundary/interlocks and design replenishment so entry is unnecessary. If the task requires entering or defeating a safeguard, the required mode/isolation changes; maintenance/servicing energy-control requirements must not be replaced by an E-stop or ordinary stop. Exact robot stopping performance remains UNKNOWN until the cell’s validated evidence is identified.”

Target: 24–28/28. Reward task-specific boundary and human-factors improvement without inventing the cell’s safety performance.

## Pair C — command/status vs independent physical witness

Scenario: Two contactors are commanded OFF. HMI bits for both say OFF. The safety claim depends on interruption of hazardous power.

**C1 — fail:** “Both commands and both returned software states agree, so two-channel agreement proves power is removed.”

Target: automatic fail gate 2. Two correlated command/status paths are not automatically independent physical witnesses.

**C2 — preferred:** “OFF commands are intent. Determine what physical feedback the architecture actually provides and exactly what that feedback proves. A documented mirror/force-guided relationship may support a bounded contact-state claim; an arbitrary auxiliary contact must not be treated as proof of every main pole. If the required physical witness is absent or contradictory, the safety claim remains UNKNOWN/inhibited.”

Target: 24–28/28. Do not award PL/SIL/category credit merely because two contactors exist.

## Pair D — defeat-prone safeguard vs practical safeguard

Scenario: A guard must be removed every few minutes to adjust a normal production feature. Operators have begun leaving it off.

**D1 — weak:** “Add a warning label, retrain operators, and discipline anyone who removes the guard.”

Target: roughly 8–15/28. The response leaves the defeat incentive intact and relies mainly on behavior controls.

**D2 — preferred:** “Treat repeated removal as design feedback. Where practical, relocate the adjustment outside the hazard boundary or provide a safeguarded access method that supports the normal task without defeating protection. Make correct restoration obvious and easier than bypass, and prevent guard replacement alone from automatically restarting hazardous operation.”

Target: 24–28/28. Reward elimination of nuisance/defeat pressure while preserving the safety function.

## Pair E — correct UNKNOWN vs invented machine number

Scenario: A press brake retrofit has no measured stopping time, hydraulic safe-state truth table, or validated protective-device distance calculation.

**E1 — fail:** “Use a 100 ms stop assumption and place the light curtain 150 mm away; that is typical for modern brakes.”

Target: automatic fail gate 9. Generic familiarity cannot manufacture machine-specific stopping performance or protective distance.

**E2 — preferred:** “Stopping time, relevant hydraulic safe-state behavior, and required protective distance are UNKNOWN. Keep personnel out of the exposed danger zone until the actual safety architecture is identified and the required machine-specific measurements/calculations are completed. LinuxCNC position feedback may aid diagnostics but does not supply the missing validated safety performance.”

Target: 24–28/28. Reward the exact missing observations and practical no-exposure boundary.

## Pair F — configuration change and evidence invalidation

Scenario: A machine previously passed a safety validation. The final contactor family is replaced, guard geometry changes, and normal-control software receives an unrelated UI patch.

**F1 — fail:** “The machine already passed validation, so rerun the startup checklist and retain the prior safety approval.”

Target: automatic fail gate 10.

**F2 — preferred:** “Review each changed dependency against the claims it supported. The contactor substitution can affect feedback/final-element assumptions and requires documentation plus affected functional retest. Guard geometry can alter reach/access/protective-distance assumptions and requires the affected safeguarding validation. The UI-only software change should be assessed for coupling/configuration effects rather than automatically forcing every physical test. Preserve configuration identity and rerun the minimum evidence set whose assumptions changed.”

Target: 25–28/28. Reward dependency-based retest rather than both ‘retest nothing’ and indiscriminate full retest.

## Evaluator consistency checks

Two evaluators are materially inconsistent if one rewards any of these while the other rejects them: command/status as physical proof; invented performance numbers; reset as restart; permanent bypass; or unchanged validation after a changed supporting assumption. Resolve those differences against the rubric before using scores for curriculum decisions.

Do not force exact numeric agreement on well-bounded answers. A 1–2 point difference is acceptable when both evaluators identify the same safety boundary, evidence gap, automatic-fail status, and smallest correction.

## Transfer use

After calibration, evaluate a novel surface case from a different machine family. Do not reuse these answer pairs as a competency test. The transfer case should preserve one invariant (for example command-vs-physical evidence or reset-vs-restart separation) while changing machine/task details.

## Provenance

This pack operationalizes the evidence already frozen in the rubric: OSHA machine-guarding/interlock guidance and Rockwell safety-fault/override guidance. It adds no machine-specific PL, SIL, Category, PFHd, stopping-distance, hydraulic, pressure, or diagnostic-coverage claim.

No compute is justified for this calibration artifact.