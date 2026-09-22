# 2530 — E-stop systems from first principles: entry map and release gate

## Learner route

2530 is not a collection of E-stop wiring examples. It is a fault-driven design method for deriving an emergency-stop function from hazards and machine physics while preserving the boundary between ordinary machine control and personnel-safety authority.

Use this order:

1. `2530_ESTOP_FIRST_PRINCIPLES_SOURCE_PREP_2026-09-22.md` — establish what emergency stop is and is not; distinguish complementary protection, stop strategy, reset and restart.
2. `2530_ESTOP_ARCHITECTURE_COMPARISON_AND_FAULT_MAP_2026-09-22.md` — compare professional safety-relay architectures and reverse-map features to actual fault hypotheses.
3. `2530_LINUXCNC_ESTOP_LATCH_BOUNDARY_TRACE_2026-09-22.md` — understand the ordinary-control LinuxCNC latch/reset/watchdog boundary without assigning it personnel-safety authority.
4. `2530_ESTOP_SPAN_RESET_HUMAN_FACTORS_AND_VALIDATION_2026-09-22.md` — derive span of control, actuator accessibility, detachable-station state, reset human factors and E-stop-specific validation.
5. Return to the generic 2520 verification/validation matrix for the complete machine safety-function proof and commissioning/change-control lifecycle.

## Required competency

A learner is ready to leave 2530 only if it can take a novel machine scenario and derive, without copying a manufacturer topology:

`HZ -> physical safe-state PROP -> E-stop span -> stopping concept -> input/device architecture -> credible FLT/CCF -> diagnostics -> safety logic -> final elements -> physical witnesses -> reset/restart propositions -> VAL`

The learner must also state what remains `UNKNOWN` rather than filling missing machine physics with plausible numbers.

## Critical-fail conditions

Do not treat 2530 as transferable if the learner does any of the following:

- treats E-stop as the primary risk-reduction measure rather than complementary protection;
- assumes every E-stop must remove all machine energy;
- chooses Category 0/1 or another stopping behavior without hazard/process evidence;
- infers PL/SIL, diagnostic coverage, stopping time/distance or final-element adequacy from a lookalike topology;
- treats two channels as automatically independent;
- treats EDM or drive/safety status as physical proof of standstill, pressure exhaustion, load holding or personnel clearance;
- lets release/reset itself restart hazardous production;
- treats a retained Cycle Start as fresh post-reset authorization;
- uses ordinary LinuxCNC/HAL/FPGA state as the sole personnel-safety authority;
- defines segmented spans without analyzing coupled/adjacent hazards and human identification of the span;
- allows a visible inactive pendant E-stop to masquerade as an active device.

## Release evidence expected

Before 2530 can be called mature/transferable, preserve all of the following:

- authoritative standards/manufacturer evidence for emergency-stop principles;
- at least three inspectable professional architecture examples with fault-feature reverse mapping;
- a LinuxCNC source-level boundary trace;
- a span/reset/human-factors treatment for linked machines/cells;
- an E-stop-specific validation matrix supplementing, not duplicating, 2520;
- an adversarial novel-machine assessment that withholds the physical data needed to guess a stopping result;
- information-separated competency evidence if the course governance requires blind/fresh evaluation for formal graduation.

## Design review questions

A reviewer should be able to ask these questions in order and receive defensible evidence:

1. What emergency situation is this device intended to help avert?
2. What physical state must the machine reach and maintain?
3. Why is this span correct for the coupled process?
4. Why is the selected stopping concept safer than plausible alternatives for this hazard?
5. Which faults can defeat the input path, logic path, output path or final element?
6. Which faults are detected, by what mechanism, and before what next hazardous opportunity?
7. What dependencies remain shared despite apparent channel redundancy?
8. What does EDM/feedback actually observe physically?
9. What must a person inspect/know before releasing the initiating device?
10. What independent proposition authorizes rearm and what separate proposition authorizes production start?
11. How is retained demand prevented from reviving motion after reset/recovery?
12. What physical measurement or observation proves the stopping proposition on the actual machine?
13. What changes invalidate that proof and trigger revalidation?

## Current release disposition

The learner-readable methodology is now coherent enough for a fresh-AI handoff, but formal competency should not be self-certified. A novel information-separated challenge should test the complete chain. Until that evidence exists, mark 2530 methodology **READY FOR EXTERNAL/FRESH EVALUATION**, not graduated.

The external gate is branch-local. If it cannot execute immediately, continue to the next highest-value safety-course module without exposing a hidden 2530 answer key to the learner side.
