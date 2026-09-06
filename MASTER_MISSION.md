# LinuxCNC AI Curriculum — Master Mission

## Authority

This document is the standing mission contract for AI agents working in `Bensend/LinuxCNC-AI-Curriculum`. Execute it; do not merely summarize or propose a plan.

The objective is source-level mastery of LinuxCNC sufficient to architect, implement, test, debug, and maintain LinuxCNC-based machine-control systems, with eventual application to the separate OpenPressBrake project.

This is an engineering research and reverse-engineering program. Its durable output must be useful to a fresh AI engineer, not just to the conversation that produced it.

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

When the same essential experiment fails or stalls repeatedly, do not blindly rerun it. After no more than three materially similar failed attempts, explicitly classify the experiment as one of:

1. **ESSENTIAL NOW** — redesign the experiment/harness before another attempt because graduation would otherwise be unsound;
2. **PROMOTE** — preserve the uncertainty and evidence trail for the 2000/3000 queue and continue the current course level; or
3. **DROP** — document why the experiment no longer provides useful information.

A materially redesigned experiment may begin a new attempt cycle, but the decision and rationale must be recorded. Compute expenditure alone is not evidence of progress.

## Session Initialization

At the beginning of every work session:

1. Read `README.md`, this file, `CURRICULUM.md`, `SOURCE_POLICY.md`, `MODULE_TEMPLATE.md`, and `PROGRESS.md`.
2. Inspect existing developer guides, call flows, claims, forum findings, experiments, exams, unknowns, promotion/uncertainty queues, and the latest laboratory results.
3. Recover the current course level, LinuxCNC revision(s), unfinished work, spawned prerequisites, and next unblocked module from repository state.
4. Continue existing work rather than restarting it.
5. Treat GitHub as durable memory. Do not rely on conversation memory for facts that belong in the course.
6. Record the lesson/session start timestamp in UTC before substantive work begins.

## Required Module Workflow

For every module, follow this evidence chain:

**Documentation -> community knowledge -> source code -> function/symbol guide -> call-flow guide -> experiment -> verification -> adversarial exam -> corrections -> fresh-AI handoff -> graduation/promotion**

A convincing document alone is never graduation evidence.

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

Commit useful work to GitHub, including developer guides, source maps, function inventories, call-flow guides, claims/evidence ledgers, forum findings, experiments, laboratory scripts/results, exams, corrections, unresolved questions, promotion queues, version comparisons, curriculum changes, and progress checkpoints.

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

Ordinary uncertainty, failed experiments, build failures, conflicting documentation, and incorrect hypotheses are curriculum work. Investigate, document, correct, promote when appropriate, and continue.

## Lesson Timing and Overlap Log

Every curriculum work session must record its timing in `LESSON_LOG.md` so the owner can verify whether hourly sessions are overlapping.

At session start, capture an ISO-8601 UTC start timestamp before substantive work begins.

Immediately before the session ends — after substantive work and repository updates, but before the final response/quit — capture the end timestamp, calculate elapsed wall-clock time, and append one row to `LESSON_LOG.md` containing at minimum session date, module/lesson, start/end UTC, elapsed minutes, status, next checkpoint, and overlap/concurrency notes.

The elapsed value must be based on actual timestamps. Do not omit timing rows for failed or blocked lessons. Commit the timing row before quitting whenever repository write access is available.

## Perpetual Lesson Scheduling

This curriculum is a continuing autonomous engineering course, not a one-session assignment.

At the end of every productive lesson/work session:

1. Commit all useful work and update `PROGRESS.md`.
2. Determine the next appropriate lesson from the dependency graph, including current-level prerequisites and higher-level promotion items.
3. Persist an unambiguous next-work checkpoint.
4. Immediately before quitting, update and commit `LESSON_LOG.md` with actual lesson start/end/duration and overlap status.
5. Ensure another curriculum work session is scheduled automatically.
6. The next session must begin by reading repository state and execute substantive work rather than merely summarize status.

Maintain: **lesson -> persist results -> determine next lesson -> log actual lesson time -> schedule continuation -> next lesson**.

Do not create overlapping curriculum schedules. Prefer one recurring curriculum-work automation whose invocation discovers the next lesson from GitHub state. The scheduler is the heartbeat; GitHub is the course state.

Completion of the 1000 series does not end the perpetual chain. On 1000 graduation, synthesize its promotion queue into a 2000-series curriculum and continue. On 2000 graduation, evaluate whether evidence justifies a 3000 series. Continue into 3000 only when justified. Stop only when the active course sequence has genuinely graduated with no justified next level, the owner explicitly stops/pauses it, or human/safety/account intervention is required.

### Scheduled Continuation Instruction

A recurring curriculum session should execute an instruction equivalent to:

> Continue executing the LinuxCNC AI Curriculum in `Bensend/LinuxCNC-AI-Curriculum`. Read `START_HERE.md` and follow it. Inspect current course level, progress, latest lab results, open questions, promotion/uncertainty queues, checkpoints, artifacts, and `LESSON_LOG.md`. Resume the highest-priority unblocked module according to the dependency graph. Perform substantive research, source analysis, experiments, verification, adversarial testing, corrections, and promotion decisions appropriate to the current course level. Commit durable results and update course state. Immediately before ending, record actual UTC timing and overlap status. Do not merely report status or propose a plan.

## Work-Pacing Rule

A lesson is a bounded engineering unit. Long modules should be decomposed into lessons while remaining part of the same module. Prefer depth and evidence appropriate to the current course level over chapter count, but do not confuse exhaustive investigation with required mastery. Preserve valuable excess depth through promotion.

## First Assignment for a New Course

Validate the curriculum and laboratory infrastructure. Execute initial laboratory/build/version-pinning work and then proceed into the architecture -> realtime -> HAL critical path defined by `CURRICULUM.md`.

Do not merely tell the owner what you intend to do. Use the repository, perform the research, run experiments, inspect results, write durable artifacts, update progress, preserve the next checkpoint, log actual lesson timing immediately before quitting, and continue until owner intervention is genuinely required.
