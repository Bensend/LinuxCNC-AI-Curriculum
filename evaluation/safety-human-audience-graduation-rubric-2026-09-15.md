# Safety Course Human-Audience Graduation Rubric — 2026-09-15

Purpose: prevent a technically rigorous AI research artifact from being mistaken for a finished human safety lesson.

A safety module must pass both the existing evidence/engineering requirements **and** this human-audience gate.

## 1. Hazard recognition — 0–4

- 0: learner is given terminology but cannot identify what can physically hurt someone.
- 2: hazard is named but energy/hazard boundary is vague.
- 4: learner can point to the hazardous energy/event and identify who/what can enter the hazard zone.

## 2. Physical safe-state understanding — 0–4

- 0: lesson equates a software command/status with safety.
- 2: safe state is stated but not physically explained.
- 4: learner distinguishes request, safety authorization, switching/energy-removal device and actual physical state, including important residual/stored energy.

## 3. Failure reasoning — 0–4

- 0: only normal operation is taught.
- 2: a failure is described after the answer is given.
- 4: learner predicts at least one realistic fault, observes consequences, troubleshoots it and explains which independent element detects/contains it.

## 4. Reset/restart/rearm — 0–4

- 0: restore input automatically means run.
- 2: reset exists but purpose is unclear.
- 4: learner can explain why clearing a fault, acknowledging/resetting, safety reauthorization and restarting hazardous operation are distinct events.

## 5. Practical affordability — 0–4

- 0: lesson implies safety requires buying an expensive branded solution.
- 2: low-cost choices are mentioned without evaluating their failure paths.
- 4: learner can identify the lowest-cost practical way to avoid unacceptable exposure, including isolation/guarding/remote operation/no attended operation when retaining full capability safely would be expensive.

## 6. Human factors / bypass resistance — 0–4

- 0: assumes perfect compliance.
- 2: warns not to bypass safeguards.
- 4: learner identifies why a person would be tempted to bypass the safeguard and improves the design so correct use/reinstallation is easier than defeat where practical.

## 7. Troubleshooting usability — 0–4

- 0: fault state is opaque.
- 2: diagnostics exist but require expert source/manual interpretation.
- 4: learner can locate the missing prerequisite through plain-language/status evidence without being offered a bypass path.

## 8. Transfer — 0–4

- 0: learner memorizes a named relay/product.
- 2: learner can repeat the worked example.
- 4: learner correctly applies the hazard -> safety function -> physical safe state -> feedback -> reset/restart model to a different machine family and preserves UNKNOWN physical facts.

## 9. Standards presentation — 0–4

- 0: human lesson is dominated by standards/compliance prose or uses unexplained PL/SIL/category labels as authority.
- 2: standards are mostly background but still interrupt the mechanism explanation.
- 4: human lesson is understandable without standards fluency; standards/manufacturer evidence remains available in the engineering/evidence layer, and formal-compliance work can deliberately surface it when needed.

## Graduation rule

Working threshold: **>=30/36 with no zero in sections 1–4 or 8**.

Additionally, any of these is an automatic human-audience failure:

- teaching that LinuxCNC/HAL/normal FPGA status proves physical safe state;
- inventing machine-specific stopping, hydraulic, load-holding or diagnostic facts;
- implying `expensive = safe` or `cheap = unsafe` without failure-path reasoning;
- giving a bypass as the normal remedy for an inconvenient safeguard;
- treating E-stop release/reset as automatic hazardous restart without an explicit justified application design;
- leaving the learner unable to state when the inexpensive safe answer is simply to keep people out of the hazard.

## Evaluation format

Prefer a short scenario-based assessment over terminology questions. The learner should draw or annotate the authority/energy path, inject or diagnose a fault, decide whether reset/restart is allowed, and propose a cheaper/easier safeguard without weakening the required physical protection.

This rubric evaluates the **human teaching layer**. It does not replace source provenance, engineering validation, or machine-specific commissioning.
