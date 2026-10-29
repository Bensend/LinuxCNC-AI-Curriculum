# 25E0 — Information-separated commissioning / validation competency handoff

**2026-10-29 | evaluator-only selection protocol, learner-readable but without a fixed challenge, hidden oracle or answer.** Status: **READY FOR EXTERNAL/FRESH EVALUATION; NOT RUN; NOT GRADUATED.** This is the current 25E0 dispatch contract. The [2026-09-23 public example](25E0_EXTERNAL_EVALUATOR_HANDOFF_2026-09-23.md) remains historical open-book practice, **not a presumptively blind test**.

## What the independent evaluator must test

Can a fresh learner derive a *machine-specific commissioning and revalidation plan* from a safety requirements specification (SRS), rather than accept controller diagnostics or an unchanged safety program as physical proof? The learner must distinguish **normal control**, **diagnostics**, **independent safety-related control**, **physical final elements / stored energy**, **personnel access**, and **maintenance isolation**.

## Scenario construction — evaluator holds the decisive facts

Select a genuinely novel machine, task and lifecycle change, materially different from the published generic guard + STO + pneumatic actuator + reset example and from any examples known to the learner. A cross-machine candidate is acceptable, but **do not publish the selected scenario, expected outcome or hidden fault in this repository before precommitment**.

Provide enough observable/documented information to construct a test plan, while retaining at least one necessary physical datum as UNKNOWN. Include:

1. At least **two hazardous energy or motion mechanisms** with different final-element or restraint requirements; include one stored-energy or coast/gravity hazard.
2. A personnel-access safeguard, with the question of whether a person can reach the hazard before it ends.
3. A normal LinuxCNC/HAL/FPGA or conventional controller command/status path that can mislead without becoming personnel-safety authority.
4. A purportedly healthy safety-device/PLC/drive status whose **exact diagnostic scope** is narrower than the required physical safe-state proposition.
5. A single fault plus a common dependency or latent fault that a generic 'press E-stop' checklist would miss.
6. A deliberate reset/rearm and distinct ordinary cycle-start sequence, including power loss/restoration or a held command.
7. A post-commissioning **change** that may invalidate a subset of previously accepted evidence (e.g. mechanical inertia, guard geometry, final-element model, wiring, safety firmware/configuration, or hydraulic plumbing). Do not preannounce which tests are stale.
8. A human task that could make a safeguard inconvenient, and a practical lower-defeat alternative.

**Do not provide or fabricate** a machine-specific stopping time/distance, pressure threshold, PL/SIL, diagnostic coverage, proof-test interval, or physical truth table unless it is an explicit evidenced scenario input. Give the learner enough provenance to say which values are measured, documented, inferred or unknown.

## Required learner commitment (before any oracle reveal)

Obtain a timestamped immutable response containing:

- machine/task/hazard boundary and physical safe-state propositions, with the exposed person identified;
- SRS-to-validation trace: each safety function, stimulus, expected safety-related action, **independent physical witness**, acceptance criterion/source, safe test setup and residual uncertainty;
- electrical, fluid, mechanical and process stored-energy isolation versus production protective-stop distinctions;
- at least **three justified adversarial/fault cases**, including the safe method for each; unsafe live fault injection must be rejected or replaced by disconnected simulation/documentary review;
- failure of a final element, loss of a common dependency, and an unexpected reset/restart sequence;
- evidence of actual stop/hold, guarded access/inside escape if applicable, deliberate rearm and new ordinary start;
- the baseline configuration and evidence identity frozen at release (machine ID, as-built wiring, selected component variants, safety project/firmware, test method, instrument calibration and witness);
- which accepted claims must be revalidated after the supplied change, and which may remain valid with a reasoned dependency argument;
- a periodic inspection/proof-test *failure mechanism* and its evidential limit, without inventing an interval;
- evidence-class labels (SOURCE-CONFIRMED, DOC-CONFIRMED, TEST-CONFIRMED, COMMUNITY-REPORTED, INFERENCE, UNKNOWN), alternatives, falsifiers, confidence 0–100%, elapsed solution time and resources used;
- an explicit **HOLD / restricted isolated trial / eligible for attended operation** recommendation based only on established evidence, not wishful completion.

The learner may specify what a qualified technician must measure; **do not request hazardous machine operation** merely to score a paper exercise.

## Evaluator's independent scoring and safety gate

Before learner exposure, record scenario identity/version, source provenance, expected physical propositions, hidden discriminators, novelty/contamination assessment, permitted resources, rubric, and independent evaluator identity **outside learner-readable material**. Do not expose hidden keys, later forum resolution, or preferred architecture before commitment.

After commitment, score the five dimensions in [BLIND_FEEDBACK_PROTOCOL](BLIND_FEEDBACK_PROTOCOL.md) **/10**; separately, if used, score the [safety-specific seven dimensions and automatic-fail gates](../safety-course/SAFETY_SANDBOX_EVALUATOR_RUBRIC_SCORECARD.md) **/28**. Do **not** convert /28 to /10 or average them. Mark any invalid oracle or prior exposure **NON-BLIND / EVALUATION_INVALID** and exclude from blind competency metrics.

A polished plan fails the safety gate if it treats LinuxCNC/HMI, PLC diagnostics, STO, EDM, a green interlock, an E-stop request, a gauge at the wrong pressure zone, or unchanged software as independent proof of a physically safe machine; if it merges reset and motion start; invents machine-specific physical limits; permits exposed operation without minimum safeguards; or authorizes uncontrolled live fault injection. A score never authorizes physical machine operation.

After independent scoring, retain the original commitment and oracle provenance, classify misses, correct only the transferable mechanism, and schedule a **different-surface transfer** and later **retention** challenge. Only the independent evaluator may advance the 25E0 competency gate under the existing course governance.

## Local compute and installed OpenPressBrake boundary

This handoff requires **no simulation, build, test suite, GitHub-hosted runner, or machine actuation**. If a future objective oracle genuinely requires execution, freeze its question and exact fixture first. Only a verified self-hosted `[self-hosted, openpressbrake]` path with **independently established physical isolation from hazardous I/O** may be considered. Runner labels, hashes, workflow success and software interlocks are not proof of isolation. Otherwise use documentary evaluation and record the blocker.

For the actual OpenPressBrake machine, Stage A A–G qualified installed Pilz/AKAS, K1/K2/EDM, Y1/Y2 stop/hold, guard, isolation and restart evidence is still missing. **G0/G1 HOLD; no personnel-exposed hazardous operation.** Do not turn an evaluator scenario into a claim about the selected machine.
