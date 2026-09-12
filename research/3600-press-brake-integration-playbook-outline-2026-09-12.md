# 3600 Press Brake — integration playbook outline

Date: 2026-09-12
Status: PRE-ACTIVATION / DEPENDENCY-SAFE INTEGRATION OUTLINE

## Purpose

Organize the accumulated press-brake research into the eventual 3600 machine-class playbook without pretending the specialization has graduated. This file is an integration map: what another AI engineer should eventually be able to build, explain, commission and debug; which evidence is already strong; and which sections still require machine-specific or public implementation evidence.

The 2000-level F02 fresh-AI handoff remains an external prerequisite gate. This outline does not bypass it.

## 1. Machine architecture and ownership

### Teach

- semantic press-cycle coordinator;
- LinuxCNC motion/joint ownership;
- independent Y1/Y2 physical feedback;
- differential synchronization authority;
- hydraulic/process decoder;
- electrical/drive interface;
- external functional-safety boundary.

### Evidence maturity

**STRONG generic architecture.** Pinned LinuxCNC source, public Accurpress evolution, Ursviken field reports, process-state analogues and PB-PREP-002 support the separation.

### Remaining gap

Exact best tandem correction insertion/final saturation topology remains OPEN; PB-PREP-001 is deliberately INCONCLUSIVE.

## 2. Y1/Y2 tandem ram control

### Teach

- common trajectory versus per-side loop ownership;
- independent feedback and scale/reference validation;
- Y1-Y2 differential witness/sign;
- synchronization correction concept;
- per-side output limiting/fault observation;
- why Cartesian/principal Y is not squareness truth.

### Evidence maturity

**MODERATE/STRONG feasibility.** Public Ursviken builder reported physical bending with Y1 PID + Y2 PID + differential sync PID.

### Remaining gap

Final downloadable field configuration/source remains unavailable; exact insertion, saturation, ferror and realtime order cannot be copied as canonical.

## 3. Press-cycle state machine

### Teach

- approach/change point/bend/hold/decompression/return semantics;
- completion witnesses versus command state;
- nonblocking active-state logic;
- continuous fault/interlock reevaluation;
- timeout consequence rather than timer-only diagnostics;
- abort/reconciliation rather than blind state restoration.

### Evidence maturity

**STRONG generic ordinary-control semantics.** PB-PREP-002 plus LinuxCNC process-state analogues and public press components.

### Remaining gap

Machine-specific hydraulic completion witnesses and timings.

## 4. Hydraulic and proportional-valve decoder

### Teach

- semantic process mode is not a valve truth table;
- machine-specific decoder maps modes into legal actuator commands;
- command/feedback/intermediate actuator observability;
- final ordinary authorization and disable paths.

### Evidence maturity

**ARCHITECTURE STRONG; PHYSICAL DETAIL MACHINE-SPECIFIC.** Public projects show several architectures and a field actuator-position-loss lesson.

### Remaining gap

Actual target machine plumbing, polarity, overlap/deadband, pump/unload/decompression topology, feedback and legal valve combinations.

## 5. Pressure, force/tonnage and crowning

### Teach

- pressure command/feedback, derived force, and crowning are separate state;
- pressure-to-force requires a justified machine model;
- crowning nominal calculation, empirical correction and physical actuator state are distinct;
- disabled software calculation does not guarantee a neutral physical crowning actuator;
- ordinary pressure control is not automatically a safety-rated pressure-limit function.

### Evidence maturity

**GOOD controller/domain ownership evidence.** Cybelec public documentation plus Accurpress field evolution.

### Remaining gap

All numeric limits, force models, crowning coefficients and machine-specific physical behavior.

## 6. Backgauge architecture and operator positioning

### Teach

- manual jog;
- typed position;
- homing/reference;
- extra-joint architecture and `posthome-cmd`;
- planner shaping versus authorization;
- command episode identity;
- atomic `at-position` predicate;
- interruption/recovery.

### Evidence maturity

**STRONG LinuxCNC source + bounded tests.** PB-BG-001 through PB-BG-004, pinned motion/homing/control source, Ursviken field topology.

### Remaining gap

Machine-specific travels, speeds, drive faults, physical homing tolerances, stall detection thresholds.

## 7. CAD/DXF and bend-program data model

### Teach

```text
ImportedPart -> BendFeature -> BendStep -> GaugePlan -> TargetCalculation -> TargetSet -> ExecutionEpisode
```

with revision/provenance at every boundary.

- DXF bend lines are geometry, not guaranteed process semantics;
- preserve UNKNOWN metadata;
- human confirmation before sequencing when import evidence is incomplete;
- stable identity across reimport/revision;
- gauge contact/datum ownership;
- calculation method remains pluggable/machine-specific.

### Evidence maturity

**STRONG metadata/ownership contract.** FreeCAD SheetMetal, BenDFM, PB-DXF-001 through 004.

### Remaining gap

No universal public flange-to-X solver found; full automatic collision-free bend sequence remains out of scope for the first implementation.

## 8. Program execution and recovery

### Teach

- LinuxCNC Pause/Resume versus Stop/Abort;
- Task abort destroys current interpreter/pending execution context;
- selected BendStep can persist as operator context but not motion authority;
- abort/restart/reference loss requires reconciliation and a fresh ExecutionEpisode;
- generic Run From Selected Line is not automatic physical-bend recovery.

### Evidence maturity

**STRONG LinuxCNC source; MODERATE field UI evidence.** Real Accurpress retrofit had manual, semi-auto-repeat and G-code-auto modes.

### Remaining gap

The public field project's intended bend-sequence/wizard UI was not finished; exact row-state implementation source was unavailable in the bounded pass.

## 9. First-piece correction and quality feedback

### Teach

- trial bend -> measure -> explicit correction -> repeat same bend -> accept/advance;
- requested geometry, nominal target, empirical correction and machine calibration are distinct;
- bend-specific is the default correction scope;
- promotion to program/class scope requires stronger repeated evidence;
- correction changes create a new TargetSet generation;
- systematic coordinate residual routes to calibration review rather than product-offset propagation.

### Evidence maturity

**STRONG workflow/documentation evidence.** Cybelec and Delem families independently expose correction workflows and reusable correction concepts.

### Remaining gap

Machine/process-specific acceptance limits, springback models, tooling/material qualification ranges.

## 10. Machine calibration and commissioning

### Teach

- reference/HOME_OFFSET versus HOME;
- scale plausibility;
- direction/backlash/hysteresis tests;
- independent physical reference;
- Y1/Y2 differential validation;
- product residual versus machine-coordinate residual;
- recorder/provenance requirements;
- recovery revalidation.

### Evidence maturity

**GOOD generic checklist.** LinuxCNC homing/encoder/backlash/ferror docs/source and correction-diagnosis matrix.

### Remaining gap

Actual machine acceptance tolerances and energized commissioning procedures.

## 11. HMI and diagnostics

### Teach

Separate display of:

- LinuxCNC controller state;
- press-program/BendStep state;
- TargetSet provenance and validity;
- runtime ExecutionEpisode/authorization;
- Y1/Y2/X/R/Z physical feedback;
- correction/calibration revisions;
- stale/fault/reconciliation reasons;
- external safety-chain observation without mislabelling ordinary software as `SAFE`.

### Evidence maturity

**GOOD QtVCP/documentation architecture + field UI concepts.**

### Remaining gap

Executable production press-brake HMI source suitable for direct stale-state/adversarial testing and ergonomic validation.

## 12. Functional-safety boundary

### Teach

- LinuxCNC ordinary control, diagnostics, watchdogs and HMI are not automatically safety-rated;
- safeguarding, pedal safety, monitored valves, stopping performance, safety PLC/relay architecture and required PL/SIL are machine/risk-specific;
- LinuxCNC may observe safety state without owning the safety function.

### Evidence maturity

**STRONG boundary statement; implementation machine-specific.**

### Remaining gap

Actual target-machine risk assessment and safety-system engineering, intentionally outside this public generic curriculum.

## 13. Failure and recovery playbook

Minimum scenarios eventual 3600 guide should cover:

- one-side feedback stale/frozen;
- Y1/Y2 disagreement;
- scale/reference error;
- communication/watchdog loss;
- recorder overrun / invalid diagnostic capture;
- backgauge command episode invalidation;
- abort during a bend/program;
- correction/calibration revision mismatch;
- pressure/process witness invalid;
- crowning state unknown after restart/disable;
- external ordinary-control interlock loss;
- incomplete workpiece state after interrupted bend.

Each should state detection, evidence boundary, ordinary-control response, reconciliation and what remains UNKNOWN.

## 14. Staged implementation path

A defensible first implementation can be intentionally limited:

### Stage 1

- manual ram/auxiliary modes appropriate to the actual machine;
- typed/jog backgauge positioning;
- reliable reference/fault state;
- clear diagnostics.

### Stage 2

- semi-auto repeat of one accepted BendStep;
- first-piece correction workflow;
- explicit target/correction provenance.

### Stage 3

- ordered human-confirmed bend program;
- automatic movement to next accepted targets with reconciliation rules;
- retained program state and diagnostics.

### Stage 4

- imported CAD/DXF geometry assists BendFeature creation and gauging;
- human-confirmed sequencing remains acceptable.

### Later only when justified

- automatic sequence optimization/collision planning;
- learned correction reuse;
- deeper visualization/simulation;
- machine-specific advanced automation.

This staged route reflects the user's stated initial goal of manual typed/jog backgauge capability before full DXF automation and avoids forcing immature automation into the critical path.

## 15. Evidence and graduation plan once 3600 activates

The actual 3600 specialization should still follow the full module workflow:

1. consolidate official documentation;
2. consolidate multiple public implementations;
3. pinned source inventory/call flows;
4. integrate the existing bounded experiments as prerequisites rather than blindly repeating them;
5. identify only the remaining behaviorally significant experiment gaps;
6. adversarial exam;
7. corrections;
8. novel fresh-AI handoff;
9. graduation sufficiency / higher-level promotion review.

Do not call the specialization graduated from preparation artifacts alone.

## Current activation blocker

`handoffs/F02-fresh-ai-compound-fault-transfer.md` remains PREPARED / UNSCORED and must be evaluated by a genuinely information-separated evaluator. Until then, the artifacts above remain dependency-safe 3600 preparation rather than formal specialization graduation.

## Next checkpoint

Re-check F02 at the start of the next session. If still externally blocked, only continue 3600 when a genuinely new public implementation/source or an uncovered machine-domain question offers information gain. Otherwise preserve this integration outline and stop expanding generic abstractions.
