# LinuxCNC AI Curriculum — Master Mission

## Authority

This document is the standing mission contract for AI agents working in `Bensend/LinuxCNC-AI-Curriculum`. Execute it; do not merely summarize or propose a plan.

The objective is source-level mastery of LinuxCNC sufficient to architect, implement, test, debug, and maintain LinuxCNC-based machine-control systems, with eventual application to the separate OpenPressBrake project.

This is an engineering research and reverse-engineering program. Its durable output must be useful to a fresh AI engineer, not just to the conversation that produced it.

## Session Initialization

At the beginning of every work session:

1. Read `README.md`, this file, `CURRICULUM.md`, `SOURCE_POLICY.md`, `MODULE_TEMPLATE.md`, and `PROGRESS.md`.
2. Inspect existing developer guides, call flows, claims, forum findings, experiments, exams, unknowns, and the latest laboratory results.
3. Recover the current LinuxCNC revision(s), unfinished work, spawned prerequisites, and next unblocked module from repository state.
4. Continue existing work rather than restarting it.
5. Treat GitHub as durable memory. Do not rely on conversation memory for facts that belong in the course.
6. Record the lesson/session start timestamp in UTC before substantive work begins.

## Required Module Workflow

For every module, follow this evidence chain:

**Documentation -> community knowledge -> source code -> function/symbol guide -> call-flow guide -> experiment -> verification -> adversarial exam -> corrections -> fresh-AI handoff -> graduation**

A convincing document alone is never graduation evidence.

### 1. Establish Intended Behavior

Study current official LinuxCNC documentation, design documentation, examples, tests, and other authoritative material. Record terminology, architecture, configuration interfaces, documented guarantees, limitations, and version applicability.

### 2. Investigate Community Knowledge

Search LinuxCNC forums, mailing lists, developer discussions, issue history, and other high-quality community material. Prioritize LinuxCNC developers and experienced integrators. Look for implementation details, historical design decisions, field failures, timing problems, configuration traps, misconceptions, undocumented behavior, debugging techniques, and version-dependent behavior.

Community statements are investigation leads, not automatic facts.

### 3. Read the Actual LinuxCNC Source

Inspect the relevant implementation at an explicitly recorded commit SHA. Inventory important directories, files, structures, functions, entry points, interfaces, and tests. Trace behaviorally significant functions and call chains rather than merely searching for symbol names.

For significant functions/symbols document:

- source path and symbol
- purpose
- callers and callees
- inputs and outputs
- state modified
- process/thread and realtime/userspace context
- invocation frequency where applicable
- control flow and important branches
- failure/error behavior
- timing assumptions
- related structures
- HAL-visible consequences
- configuration dependencies
- relevant tests/examples
- evidence classification
- useful symbols for the next source-reading step

Inventory trivial helpers where useful, but spend deep effort on code that affects architecture, state, timing, I/O, error handling, or control flow.

### 4. Reconstruct Complete Execution Paths

Do not stop at isolated functions. Build source-grounded end-to-end call-flow guides answering: what calls this, what happens next, what process/thread executes it, what state crosses each boundary, where HAL is involved, where hardware-facing behavior begins, and what happens on failure.

Important target traces include a LinuxCNC servo period, HAL function execution, command-to-hardware paths, feedback-to-motion paths, HostMot2 read/write cycles, hm2_eth communication, watchdog expiration, encoder faults, and recovery paths.

### 5. Maintain an Evidence Ledger

Use the classifications defined in `SOURCE_POLICY.md`: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, and `UNKNOWN`.

Do not silently reconcile conflicting evidence. Record conflicts, version context, likely explanations when justified, and the source-reading or experiment needed to resolve them.

### 6. Use the Laboratory

Do not rely only on reading. Use the repository's GitHub Actions laboratory for reproducible experiments whenever behavior can reasonably be tested. Read the generated results yourself and preserve useful artifacts.

Experiments may cover LinuxCNC builds, HAL behavior, thread/function ordering, custom components, servo behavior, simulated feedback, following error, encoders, communication failures, watchdogs, invalid configurations, regression cases, and fault injection.

When practical, record the expected behavior before running the experiment. Compare prediction to observation. Treat surprising results as research targets rather than explaining them away.

The Codespaces environment is available for interactive software investigation when a persistent interactive environment is materially useful. Do not require human interaction with Codespaces when the Actions laboratory can perform the work reproducibly.

### 7. Test Understanding

At the end of each significant module, create an adversarial examination that tests source-level reasoning rather than vocabulary. Include call-chain questions, failure-path questions, a misleading premise, version-sensitive reasoning, debugging scenarios, and at least one bounded code/configuration modification task. Check answers against source and experiments and correct the guide when weaknesses are exposed.

### 8. Fresh-AI Handoff Test

Assume another AI knows LinuxCNC only through the artifacts produced here plus the referenced source. The module does not graduate unless that AI could locate the implementation, explain the subsystem, trace important paths, reproduce experiments, diagnose a representative failure, recognize unresolved uncertainty, and make an appropriate bounded change without inventing missing behavior.

## Recursive Curriculum Rule

The curriculum is a dependency graph, not a rigid table of contents. If source reading reveals a missing prerequisite, create or refine the prerequisite/spawned module in `CURRICULUM.md` and `PROGRESS.md`. Do not hand-wave important dependencies merely to finish a module.

Prefer deep completion of one execution path over superficial coverage of several subsystems.

## Durable Artifact Rule

Commit useful work to GitHub, including developer guides, source maps, function inventories, call-flow guides, claims/evidence ledgers, forum findings, experiments, laboratory scripts/results, exams, corrections, unresolved questions, version comparisons, curriculum changes, and progress checkpoints.

If work cannot finish in one session, persist a precise checkpoint that allows a fresh session to resume without reconstructing the work from chat history.

## Version Discipline

Record the exact LinuxCNC revision for every source-level conclusion and experiment. Study the current development source deeply while retaining the current stable release as a compatibility/reference baseline. Never silently apply behavior from one revision to another.

## Safety Boundary

LinuxCNC can control hazardous machinery. Clearly distinguish ordinary machine-control software, realtime control, diagnostics/fault handling, and safety-rated functions. Do not infer that LinuxCNC software, HAL logic, realtime components, PC software, network communication, or watchdogs are safety-rated without evidence.

The cloud laboratory is a software/simulation environment. Physical-machine experiments, energized hydraulic operation, and safety-sensitive commissioning require explicit human involvement and separate safety analysis.

## OpenPressBrake Relationship and Public/Private Boundary

LinuxCNC mastery is the immediate objective. OpenPressBrake guides prioritization, especially for realtime servo execution, HAL, HostMot2, `hm2_eth`, FPGA/driver interfaces, encoders, PWM/PDM and analog-servo command paths, GPIO, watchdogs, dual feedback loops, synchronization, fault detection, custom components, and diagnostics.

Do not publish private OpenPressBrake implementation details, proprietary machine drawings, credentials, private infrastructure information, or machine-specific confidential material into this public curriculum repository. Keep the public course generic; keep machine-specific engineering separate.

## Autonomy

Proceed autonomously through the curriculum. Do not stop after each subsection to ask whether to continue. Make reasonable research and laboratory decisions yourself.

Ask the owner only when account/UI interaction is genuinely required, required private information is unavailable, an important owner-level engineering choice has materially different consequences, physical hardware must be operated, or safety requires human involvement.

Ordinary uncertainty, failed experiments, build failures, conflicting documentation, and incorrect hypotheses are curriculum work. Investigate, document, correct, and continue.

## Lesson Timing and Overlap Log

Every curriculum work session must record its timing in `LESSON_LOG.md` so the owner can verify whether hourly sessions are overlapping.

At session start, capture an ISO-8601 UTC start timestamp before substantive work begins.

Immediately before the session ends — after substantive work and repository updates, but before the final response/quit — capture the end timestamp, calculate elapsed wall-clock time, and append one row to `LESSON_LOG.md` containing at minimum:

- session date
- lesson/module identifier and short title
- start timestamp UTC
- end timestamp UTC
- elapsed minutes
- status (`complete`, `checkpoint`, `blocked`, or `failed`)
- next lesson/checkpoint
- notes about any detected overlap or concurrency

The elapsed value must be based on actual start/end timestamps, not an estimate of how long the lesson felt.

If the previous lesson's end timestamp is later than the current lesson's start timestamp, explicitly mark `OVERLAP DETECTED` in the notes. If concurrency is otherwise visible from GitHub runs, repository state, or conflicting active checkpoints, record that as well.

Do not omit the timing row when a lesson fails or is blocked; those sessions are important for diagnosing scheduler behavior.

The timing row is part of the required durable session checkpoint and must be committed before quitting the lesson whenever repository write access is available.

## Perpetual Lesson Scheduling

This curriculum is a continuing autonomous engineering course, not a one-session assignment.

At the end of every productive lesson/work session:

1. Commit all useful work and update `PROGRESS.md`.
2. Determine the next appropriate lesson from the dependency graph, including any newly discovered prerequisite.
3. Persist an unambiguous next-work checkpoint in the repository.
4. Immediately before quitting, update and commit `LESSON_LOG.md` with actual lesson start/end/duration and overlap status.
5. Ensure another curriculum work session is scheduled automatically.
6. The next session must begin by reading repository state and then execute substantive work rather than merely summarize status or propose a plan.

Maintain the cycle:

**lesson -> persist results -> determine next lesson -> log actual lesson time -> schedule continuation -> next lesson**

Do not create overlapping curriculum schedules. Prefer one recurring curriculum-work automation whose every invocation discovers the next lesson from GitHub state. The scheduler is the heartbeat; GitHub is the course state.

If a lesson cannot finish in one session, schedule continuation of that same lesson. If an experiment/result is pending, persist that state and schedule an appropriate follow-up instead of guessing.

Only stop or pause the perpetual chain when:

- the complete curriculum has genuinely graduated;
- the owner explicitly says to stop or pause;
- continuation requires physical-machine interaction;
- continuation requires a safety-sensitive decision;
- an unrecoverable permission/account problem requires owner intervention; or
- an important owner-level engineering decision cannot responsibly be made autonomously.

If the execution environment cannot itself create or verify the recurring automation, explicitly ask the owner for the minimum required action rather than pretending scheduling succeeded.

### Scheduled Continuation Instruction

A recurring curriculum session should execute an instruction equivalent to:

> Continue executing the LinuxCNC AI Curriculum in `Bensend/LinuxCNC-AI-Curriculum`. Read `START_HERE.md` and follow it. Inspect current progress, latest lab results, open questions, checkpoints, existing artifacts, and `LESSON_LOG.md`. Record the session start timestamp in UTC. Resume the highest-priority unblocked module or unfinished lesson according to the dependency graph. Perform substantive documentation research, community research, source analysis, function/call-flow documentation, laboratory experiments, verification, adversarial testing, and corrections appropriate to the lesson. Commit durable results and update course state. Preserve a precise next-work checkpoint. Immediately before ending the session, record the UTC end timestamp, calculate actual elapsed minutes, append and commit the timing row to `LESSON_LOG.md`, and flag any overlap with the previous lesson. Do not merely report status or propose a plan.

## Work-Pacing Rule

A lesson is a bounded engineering unit that can be researched, source-traced, experimentally investigated, documented, and checked thoroughly. Long modules should be decomposed into lessons while remaining part of the same module. Prefer depth and evidence over chapter count.

## First Assignment for a New Course

Validate the curriculum and laboratory infrastructure. Execute the initial laboratory/build/version-pinning work and then proceed into the architecture -> realtime -> HAL critical path defined by `CURRICULUM.md`.

Do not merely tell the owner what you intend to do. Use the repository, perform the research, run experiments, inspect results, write durable artifacts, update progress, preserve the next checkpoint, log actual lesson timing immediately before quitting, and continue until owner intervention is genuinely required.
