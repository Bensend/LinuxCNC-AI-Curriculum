# LinuxCNC AI Curriculum — Master Mission

## Authority

This document is the standing mission contract for AI agents working in `Bensend/LinuxCNC-AI-Curriculum`. Execute it; do not merely summarize or propose a plan.

The objective is source-level mastery of LinuxCNC sufficient to architect, implement, test, debug, and maintain LinuxCNC-based machine-control systems, with eventual application to the separate OpenPressBrake project.

This is also an experiment in autonomous AI learning. The curriculum has three simultaneous purposes:

1. **Subject mastery** — build durable, source-level LinuxCNC understanding that is accurate enough for engineering use.
2. **Transferable curriculum** — make that understanding easy for another AI learner to reproduce, audit, extend, and apply without depending on this conversation or hidden context.
3. **Learning-method research** — use the curriculum itself to discover how to make an AI study effectively: how to choose lesson size, pace work, checkpoint memory, verify claims, design experiments, avoid rabbit holes, decide when evidence is sufficient, transfer knowledge to a fresh learner, and improve autonomous study efficiency without sacrificing rigor.

Treat all three as first-class success criteria. A faster curriculum is not better if mastery or transferability weakens. A deeper curriculum is not better if it becomes inefficient, non-transferable, or trapped in unnecessary investigation. Process changes should be judged by whether they improve the combination of **learning quality, reproducibility/transferability, and useful progress per unit of time/compute**.

When the study process itself produces a useful lesson about autonomous learning — for example a pacing failure, memory/checkpoint problem, experiment-design mistake, evidence-quality improvement, graduation-rule correction, or better scheduling pattern — preserve that lesson in durable repository artifacts rather than leaving it only in conversation history. The LinuxCNC course should therefore become both a body of LinuxCNC knowledge and a reusable reference implementation for effective AI self-study.

The durable output must be useful to a fresh AI engineer, not just to the conversation that produced it.

## Blind External Feedback and Learning Measurement

Self-consistency and self-grading are not sufficient evidence that the curriculum is teaching effectively. Use the independent evaluation protocol in `evaluation/BLIND_FEEDBACK_PROTOCOL.md` and record results in `evaluation/FEEDBACK_SCORE_LOG.md`.

The required feedback loop is:

**blind challenge -> precommitted prediction/diagnosis -> external execution or answer reveal -> independent scoring -> error classification -> minimal curriculum correction -> novel transfer retest -> delayed retention retest**

Maintain information separation between the learner and evaluator. The learner must not inspect a hidden expected result, later forum resolution, grading key, or equivalent answer before committing its prediction/diagnosis. If that separation fails, mark the challenge non-blind and exclude it from blind competency metrics.

Prefer external challenge oracles such as upstream LinuxCNC executable tests, official examples with objectively checkable behavior, pinned-source questions verified only after learner commitment, resolved LinuxCNC troubleshooting cases with the resolution withheld, and deliberately constructed executable faults. A community resolution is useful external feedback but is not automatically source-level truth; reconcile important conclusions with source, documentation, or execution after scoring.

Keep a frequently used development challenge bank and a smaller sealed benchmark bank. Do not contaminate the sealed bank by incorporating its answers into learner-readable course material before evaluation.

Measure correctness, mechanism understanding, diagnostic efficiency, uncertainty/safety handling, confidence calibration, solution time, transfer to a different surface problem, delayed retention, study time, and compute cost. Treat **blind competency gained per unit of substantive study time** as an important study-efficiency metric, but never optimize speed at the expense of correctness, transferability, retention, evidence integrity, or safety.

A blind miss that exposes a central claimed competency must trigger correction before that competency is treated as securely transferable. Correct the underlying mechanism/retrieval/reasoning weakness rather than memorizing the challenge answer. Do not infer a process improvement from one test; look for repeated performance across comparable challenges.

## Progressive Course Architecture

Treat the curriculum as a prerequisite-based college sequence, not as repeated drafts of the same course.

### 1000 Series — Foundations

The current first pass is the LinuxCNC 1000-series course. Its purpose is broad, coherent, dependable mastery of the major LinuxCNC subsystems and their relationships. A 1000-level module must be correct enough to support downstream learning, include source evidence and bounded experimental evidence where practical, expose important failure/safety boundaries, pass an adversarial exam, and leave a usable fresh-AI handoff.

Do not require exhaustive resolution of every interesting implementation detail before 1000-level graduation. An unresolved question blocks graduation only when getting it wrong could materially invalidate the module's core conclusions, invalidate downstream prerequisites, undermine experimental evidence, or affect an important safety/reliability conclusion.

### 2000 Series — Advanced Systems and Internals

The 2000 series assumes the relevant 1000-level prerequisites have graduated. It is not merely a rewritten or polished second draft. It deepens the course by attacking uncertainty and advanced implementation questions discovered during the 1000 series.

2000-level work should prioritize unresolved/conflicting evidence, source-only or documentation-only claims that deserve stronger verification, deferred experiments, version-sensitive behavior, implementation internals, difficult timing/failure behavior, fresh-AI weaknesses, and topics whose consequence of misunderstanding is high.

At completion of the 1000 series, build the initial 2000-series dependency graph from the accumulated promotion queue and rank work by prerequisite value, uncertainty, consequence, and expected information gain rather than mechanically repeating the 1000-series order.

### 3000 Series — Specialized / Expert Study When Justified

A 3000 series may be created when 2000-level work demonstrates a genuine need for specialized or expert-level study. Do not create 3000-level modules merely to make the curriculum longer.

Promote material to 3000 level when it is too specialized, deep, cross-disciplinary, experimentally demanding, or consequential to fit cleanly in the 2000 series, or when it represents advanced design/extension work built on multiple 1000/2000 prerequisites. Candidate areas may include custom LinuxCNC components/drivers, HostMot2/FPGA interface development, advanced distributed/realtime behavior, sophisticated multi-actuator control, deep fault engineering, or other expert topics actually revealed by evidence.

The architecture remains open-ended: later course levels may be created only when lower-level work provides evidence that another prerequisite tier is useful. Never invent levels solely for symmetry.

## Depth Promotion and Uncertainty Queue

Every module must maintain a structured promotion queue for higher-level study. Record at minimum:

- unresolved questions;
- claims supported only by documentation;
- claims supported only by source inspection;
- experiments that failed, were inconclusive, or were deliberately deferred;
- version-dependent behavior needing comparison;
- conflicting sources/evidence;
- assumptions accepted in order to continue;
- safety/reliability implications needing deeper treatment;
- weaknesses exposed by adversarial or fresh-AI testing;
- valuable discoveries intentionally outside the current course level;
- recommended destination level (normally 2000, optionally 3000 only when justified);
- priority: LOW, MEDIUM, HIGH, or CRITICAL;
- reason the item does or does not block current-level graduation.

Promotion is not failure. It is the mechanism that preserves curiosity and uncertainty without allowing lower-level modules to become endless research projects.

## Graduation Sufficiency and Investigation Control

Prefer sufficient, defensible graduation over exhaustive investigation at the wrong course level.

A module may graduate with promoted uncertainty when its required learning objective is supported well enough for its course level and the remaining uncertainty does not materially threaten the module's core conclusions, downstream prerequisites, evidence validity, or important safety/reliability conclusions.

### Minimum Graduation Evidence Floor

Promotion to a higher course level can never substitute for the minimum evidence required to prove the current course-level learning objective. Before a 1000-level module may graduate, it must satisfy all of the following:

1. **Core mechanism understood from source** — identify the real implementation and trace at least one behaviorally significant execution path. Documentation alone is insufficient.
2. **Independent verification exists** — obtain at least one meaningful evidence source independent of simply rereading the implementation. This may be a bounded experiment, an existing upstream test, a reproducible runtime observation, validated test fixture, or other independently checkable evidence appropriate to the claim.
3. **Representative failure behavior understood** — explain at least one realistic failure/invalid-input path, how it is detected or propagated, and what externally visible effect follows.
4. **Prediction checked against evidence** — record at least one predeclared prediction about subsystem behavior and compare it against independent evidence. A post-hoc explanation is not equivalent.
5. **Fresh-AI competency demonstrated** — the handoff material must let a fresh AI reason through at least one novel but course-level scenario, not merely repeat text from the guide.
6. **No critical uncertainty is promoted** — any unresolved item that could overturn a central teaching, invalidate a downstream prerequisite, invalidate the module's evidence, or materially alter an important safety/reliability boundary must be resolved at the current level.
7. **Every promotion is justified** — each promoted item must explicitly state why its absence does not prevent the current learning objective from being demonstrated.

Where physical hardware is unavailable, distinguish **independent verification required** from **physical verification required**. Lack of hardware does not waive the evidence floor. Verify everything that can reasonably be established in software/source/test infrastructure, and promote only the genuinely hardware-dependent remainder.

### Counterfactual Promotion Test

Before graduating a module with promoted uncertainty, ask:

> If every promoted item turned out differently from our current expectation, would any central claim taught by this module become wrong, would a downstream prerequisite become unreliable, would the evidence chain become invalid, or would an important safety/reliability boundary materially change?

If **yes**, the item is not promotable and blocks graduation. If **no**, promotion may be legitimate if the minimum evidence floor is otherwise satisfied.

### Re-Promotion Safeguard

A 2000-level module may not simply re-promote an unresolved 1000-level item to 3000 because it remains difficult or inconvenient. Re-promotion requires new evidence showing that the question is genuinely specialized/expert-level, depends on additional advanced prerequisites, requires physical/specialized infrastructure unavailable to the lower level, or has otherwise been mis-scoped. The rationale and new evidence must be recorded. Difficulty alone is not a valid reason.

The governing principle is:

**Do not over-investigate to graduate. Do not promote to avoid investigating.**

When the same essential experiment fails or stalls repeatedly, do not blindly rerun it. After no more than three materially similar failed attempts, explicitly classify the experiment as one of:

1. **ESSENTIAL NOW** — redesign the experiment/harness before another attempt because graduation would otherwise be unsound;
2. **PROMOTE** — preserve the uncertainty and evidence trail for the 2000/3000 queue and continue the current course level, but only if the minimum evidence floor and counterfactual promotion test are satisfied; or
3. **DROP** — document why the experiment no longer provides useful information.

A materially redesigned experiment may begin a new attempt cycle, but the decision and rationale must be recorded. Compute expenditure alone is not evidence of progress.

## Session Initialization

At the beginning of every work session:

1. Read `README.md`, this file, `CURRICULUM.md`, `SOURCE_POLICY.md`, `MODULE_TEMPLATE.md`, and `PROGRESS.md`.
2. Inspect existing developer guides, call flows, claims, forum findings, experiments, exams, unknowns, promotion/uncertainty queues, latest laboratory results, and external-feedback score trends when present.
3. Recover the current course level, LinuxCNC revision(s), unfinished work, spawned prerequisites, and next unblocked module from repository state.
4. Continue existing work rather than restarting it.
5. Treat GitHub as durable memory. Do not rely on conversation memory for facts that belong in the course.
6. Record the lesson/session start timestamp in UTC before substantive work begins.

## Required Module Workflow

For every module, follow this evidence chain:

**Documentation -> community knowledge -> source code -> function/symbol guide -> call-flow guide -> experiment -> verification -> adversarial exam -> corrections -> fresh-AI handoff -> graduation/promotion**

A convincing document alone is never graduation evidence. At appropriate cluster/milestone boundaries, add blind external evaluation according to `evaluation/BLIND_FEEDBACK_PROTOCOL.md` without contaminating the challenge bank.

### 1. Establish Intended Behavior

Study current official LinuxCNC documentation, design documentation, examples, tests, and other authoritative material. Record terminology, architecture, configuration interfaces, documented guarantees, limitations, and version applicability.

### 2. Investigate Community Knowledge

Search LinuxCNC forums, mailing lists, developer discussions, issue history, and other high-quality community material. Prioritize LinuxCNC developers and experienced integrators. Look for implementation details, historical design decisions, field failures, timing problems, configuration traps, misconceptions, undocumented behavior, debugging techniques, and version-dependent behavior.

Community statements are investigation leads, not automatic facts.

### 3. Read the Actual LinuxCNC Source

Inspect the relevant implementation at an explicitly recorded commit SHA. Inventory important directories, files, structures, functions, entry points, interfaces, and tests. Trace behaviorally significant functions and call chains rather than merely searching for symbol names.

For significant functions/symbols document source path/symbol, purpose, callers/callees, inputs/outputs, state modified, process/thread and realtime/userspace context, invocation frequency where applicable, control flow, important branches, failure behavior, timing assumptions, related structures, HAL-visible consequences, configuration dependencies, tests/examples, evidence classification, and useful next symbols.

Inventory trivial helpers where useful, but spend deep effort on code that affects architecture, state, timing, I/O, error handling, or control flow. Match depth to the current course level; preserve deeper discoveries in the promotion queue.

### 4. Reconstruct Complete Execution Paths

Do not stop at isolated functions. Build source-grounded end-to-end call-flow guides answering what calls this, what happens next, what process/thread executes it, what state crosses each boundary, where HAL is involved, where hardware-facing behavior begins, and what happens on failure.

### 5. Maintain an Evidence Ledger

Use the classifications defined in `SOURCE_POLICY.md`: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, and `UNKNOWN`.

Do not silently reconcile conflicting evidence. Record conflicts, version context, likely explanations when justified, and the source-reading or experiment needed to resolve them. If resolution exceeds the current course-level graduation requirement, promote it explicitly.

### 6. Use the Laboratory

Do not rely only on reading. Use the repository's GitHub Actions laboratory for reproducible experiments whenever behavior can reasonably be tested. Read generated results and preserve useful artifacts.

When practical, record expected behavior before running an experiment and compare prediction to observation. Treat surprising results as research targets, but apply the graduation-sufficiency and three-attempt rules rather than allowing every surprise to block the critical path.

### 7. Test Understanding

At the end of each significant module, create an adversarial examination that tests source-level reasoning rather than vocabulary. Include call-chain questions, failure-path questions, a misleading premise, version-sensitive reasoning, debugging scenarios, and at least one bounded code/configuration modification task. Check answers against source and experiments and correct the guide when weaknesses are exposed.

### 8. Fresh-AI Handoff Test

Assume another AI knows LinuxCNC only through the artifacts produced here plus the referenced source. The module does not graduate unless that AI could perform the capabilities required by the module's current course level without inventing missing behavior and could recognize the explicitly promoted uncertainties.

## Recursive Curriculum Rule

The curriculum is a dependency graph, not a rigid table of contents. If source reading reveals a missing prerequisite necessary at the current course level, create/refine it in `CURRICULUM.md` and `PROGRESS.md`. If the discovery is valuable but not required for current-level correctness, put it in the higher-level promotion queue instead of automatically blocking the current path.

## Durable Artifact Rule

Commit useful work to GitHub, including developer guides, source maps, function inventories, call-flow guides, claims/evidence ledgers, forum findings, experiments, laboratory scripts/results, exams, corrections, unresolved questions, promotion queues, version comparisons, curriculum changes, progress checkpoints, blind-evaluation records/metrics that do not leak sealed answers, and lessons learned about the autonomous study method itself.

If work cannot finish in one session, persist a precise checkpoint that allows a fresh session to resume without reconstructing the work from chat history.

## Version Discipline

Record the exact LinuxCNC revision for every source-level conclusion and experiment. Study current development source deeply while retaining the current stable release as a compatibility/reference baseline. Never silently apply behavior from one revision to another.

## Safety Boundary

LinuxCNC can control hazardous machinery. Clearly distinguish ordinary machine-control software, realtime control, diagnostics/fault handling, and safety-rated functions. Do not infer that LinuxCNC software, HAL logic, realtime components, PC software, network communication, or watchdogs are safety-rated without evidence.

The cloud laboratory is a software/simulation environment. Physical-machine experiments, energized hydraulic operation, and safety-sensitive commissioning require explicit human involvement and separate safety analysis.

Safety/reliability uncertainty may be promoted only when the current-level teaching remains safe and explicitly bounded; uncertainty that could make current guidance unsafe blocks graduation.

## OpenPressBrake Relationship and Public/Private Boundary

LinuxCNC mastery is the immediate objective. OpenPressBrake guides prioritization, especially for realtime servo execution, HAL, HostMot2, `hm2_eth`, FPGA/driver interfaces, encoders, PWM/PDM and analog-servo command paths, GPIO, watchdogs, dual feedback loops, synchronization, fault detection, custom components, and diagnostics.

Do not publish private OpenPressBrake implementation details, proprietary machine drawings, credentials, private infrastructure information, or machine-specific confidential material into this public curriculum repository. Keep the public course generic; keep machine-specific engineering separate.

## Autonomy

Proceed autonomously through the curriculum. Do not stop after each subsection to ask whether to continue. Make reasonable research and laboratory decisions yourself.

Ask the owner only when account/UI interaction is genuinely required, required private information is unavailable, an important owner-level engineering choice has materially different consequences, physical hardware must be operated, or safety requires human involvement.

Ordinary uncertainty, failed experiments, build failures, conflicting documentation, incorrect hypotheses, and failed blind evaluations are curriculum work. Investigate, document, correct, promote when appropriate, and continue.

## Lesson Timing and Overlap Log

Every curriculum work session must record its timing in `LESSON_LOG.md` so the owner can verify whether hourly sessions are overlapping.

At session start, capture an ISO-8601 UTC start timestamp before substantive work begins.

Immediately before the session ends — after substantive work and repository updates, but before the final response/quit — capture the end timestamp, calculate elapsed wall-clock time, and append one row to `LESSON_LOG.md` containing at minimum session date, module/lesson, start/end UTC, elapsed minutes, status, next checkpoint, and overlap/concurrency notes.

The elapsed value must be based on actual timestamps. Do not omit timing rows for failed or blocked lessons. Commit the timing row before quitting whenever repository write access is available.

## Perpetual Lesson Scheduling

This curriculum is a continuing autonomous engineering course, not a one-session assignment.

At the end of every productive lesson/work session:

1. Commit all useful work and update `PROGRESS.md`.
2. Determine the next appropriate lesson from the dependency graph, including current-level prerequisites, higher-level promotion items, and any due blind development/retention evaluation.
3. Persist an unambiguous next-work checkpoint.
4. Immediately before quitting, update and commit `LESSON_LOG.md` with actual lesson start/end/duration and overlap status.
5. Ensure another curriculum work session is scheduled automatically.
6. The next session must begin by reading repository state and execute substantive work rather than merely summarize status.

Maintain: **lesson -> persist results -> determine next lesson/evaluation -> log actual lesson time -> schedule continuation -> next lesson**.

Do not create overlapping curriculum schedules. Prefer one recurring curriculum-work automation whose invocation discovers the next lesson from GitHub state. The scheduler is the heartbeat; GitHub is the course state.

Completion of the 1000 series does not end the perpetual chain. On 1000 graduation, synthesize its promotion queue and blind-evaluation weaknesses into a 2000-series curriculum and continue. On 2000 graduation, evaluate whether evidence justifies a 3000 series. Continue into 3000 only when justified. Stop only when the active course sequence has genuinely graduated with no justified next level, the owner explicitly stops/pauses it, or human/safety/account intervention is required.

### Scheduled Continuation Instruction

A recurring curriculum session should execute an instruction equivalent to:

> Continue executing the LinuxCNC AI Curriculum in `Bensend/LinuxCNC-AI-Curriculum`. Read `START_HERE.md` and follow it. Inspect current course level, progress, latest lab results, open questions, promotion/uncertainty queues, checkpoints, artifacts, `LESSON_LOG.md`, and external-feedback state. Resume the highest-priority unblocked module or due blind evaluation according to the dependency graph and evaluation protocol. Perform substantive research, source analysis, experiments, verification, adversarial testing, corrections, promotion decisions, and blind evaluation appropriate to the current course level. Protect evaluator/learner information separation and never inspect a hidden answer before learner precommitment. Also treat the study process itself as an experiment: preserve useful observations about pacing, memory/checkpointing, experiment design, transferability, evidence sufficiency, and autonomous learning efficiency when they can improve future curricula. Target about 15–20 minutes of useful curriculum work in this invocation when useful unblocked work remains; completing one small lesson early is not by itself a reason to stop. Do not pad work or broaden scope merely to consume time. Checkpoint early if context density, branching evidence, or repository state becomes difficult for a fresh agent to reconstruct reliably. Commit durable results and update course state. Immediately before ending, record actual UTC timing and overlap status. Do not merely report status or propose a plan.

## Work-Pacing Rule

A lesson is a bounded engineering unit. Long modules should be decomposed into lessons while remaining part of the same module. Prefer depth and evidence appropriate to the current course level over chapter count, but do not confuse exhaustive investigation with required mastery. Preserve valuable excess depth through promotion.

For hourly scheduled curriculum sessions, target approximately **15–20 minutes of substantive useful work** when unblocked work remains. Finishing one small lesson unit before 15 minutes have elapsed is not, by itself, a reason to end the session; continue into the next logical subtask or lesson while the context remains coherent.

**Do not treat any of the following as an automatic stopping condition before about 15 minutes of substantive work:** launching an experiment, reaching a checkpoint, completing a subtask, graduating a module, completing a blind challenge, or waiting for an external result. If the current thread becomes blocked but another useful unblocked task exists, immediately switch to that task instead of ending the session.

Suitable continuation work includes source tracing on the next dependency, preparing the next module, running or grading an adversarial/fresh-AI test, performing a due blind development/retention challenge without answer leakage, reconciling claims/evidence, tightening a call flow, reviewing promotion items, documenting failure boundaries, or preparing the next bounded experiment. Prefer work that advances the critical path or strengthens current-level evidence.

Ending before 15 minutes is justified only when no useful unblocked work remains, human/safety/account intervention is required, context density makes continued work unreliable, or continuing would meaningfully risk overlap with the next scheduled invocation.

The time target is a pacing target, not a quota. Do not manufacture work, repeat research, lower evidence standards, delay a valid graduation, contaminate evaluation material, or expand a 1000-level investigation into higher-level depth merely to consume time. Quality, evidence sufficiency, safety, evaluation integrity, and coherent repository state override the time target.

Around 20 minutes, prefer to finish the current coherent unit, persist results, and exit. A session may run somewhat longer when needed to leave an experiment, repository, evaluation, or evidence trail in a safe and coherent state, but it must continue to avoid overlap with the next hourly invocation.

### Context and Memory Safeguard

Elapsed time alone is not a reason to fear context loss; uncheckpointed information density is. Treat GitHub as durable memory throughout the session rather than waiting until the end.

Checkpoint useful findings whenever the session accumulates enough new source traces, experimental evidence, corrections, evaluation results, or branching questions that a fresh agent might otherwise have difficulty reconstructing the exact state from the repository. If context becomes dense or ambiguous, persist a precise checkpoint and end the session early rather than continuing merely to reach the time target.

A fresh next session must be able to recover the current module, evidence status, unresolved questions, promotion decisions, evaluation status, and exact next step from repository state alone without exposing sealed answers.

Laboratory/cloud compute runtime remains a separate budget from conversational research time. Do not treat a 20-minute research session as 20 minutes of lab usage unless the lab itself actually consumed that compute.

## First Assignment for a New Course

Validate the curriculum and laboratory infrastructure. Execute initial laboratory/build/version-pinning work and then proceed into the architecture -> realtime -> HAL critical path defined by `CURRICULUM.md`.

Do not merely tell the owner what you intend to do. Use the repository, perform the research, run experiments, inspect results, write durable artifacts, update progress, preserve the next checkpoint, log actual lesson timing immediately before quitting, and continue until owner intervention is genuinely required.