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


**2026-10-29 EOFF-01 integration:** After learner route item 1, review [direct OEM/OSHA emergency switching-off versus E-stop and LOTO source audit](../research/4400_EOFF_01_EATON_PILZ_OSHA_EMERGENCY_SWITCHING_OFF_VS_ESTOP_VS_LOTO_SOURCE_AUDIT_2026-10-29.md). The existing 2530 competency must reject E-off/STO as safe-to-service proof and reject uncontrolled power removal without physical gravity-hold analysis. Independent evaluator NOT RUN; no new competency.


**2026-10-30 SIM-LOOP-01 practical transfer supplement:** After route item 3, use the [official LinuxCNC E-stop loopback migration source audit](../research/4400_ESTOP_SIM_LOOP_01_OFFICIAL_STEPPER_EXAMPLE_EXTERNAL_ESTOP_FEEDBACK_COPY_RISK_SOURCE_AUDIT_2026-10-30.md) and [public unscored field card](4400_ESTOP_SIM_LOOP_01_SIMULATION_TO_MACHINE_HANDOFF_FIELD_CARD_2026-10-30.md). Pinned v2.9.10 stepper setup documentation includes `net estop-loop iocontrol.0.user-enable-out iocontrol.0.emc-enable-in` and explicitly says the example assumes **no external E-stop button**. `core_sim.hal` uses the same loopback as a simulation fixture. **SOURCE/DOC-CONFIRMED:** an internal software output is echoed into a normal external-feedback input, not a physical contact or independent safety witness. **INFERENCE:** copying this example unchanged to a machine can hide an external-trip status even when a separate physical safety chain still stops it. Do not claim a real machine has the loopback or that the physical E-stop is defeated without as-built evidence. No new scored competency; independent evaluator OPEN; G0/G1 HOLD.


**2026-10-30 USB pendant exact-source transfer (UNSCORED):** The [XHC-WHB04B-6 stable/development audit](../research/4400_USB_PENDANT_01_LINUXCNC_WHB04B6_RESET_STOP_LINK_FRESHNESS_AND_BLOCKING_SOURCE_AUDIT_2026-10-30.md) demonstrates why a button labeled RESET or STOP on an ordinary wireless USB handwheel cannot be credited as a personnel E-stop: RESET issues normal machine on/off, STOP issues program stop, and `is-connected` tracks the USB receiver/session rather than a proven safety-rated radio link. The man page's `whb.halui.estop.*` RESET reference conflicts with registered source pins. An independent physical E-stop and final-element proof remain required. No new scored 2530 challenge; evaluator OPEN, G0/G1 HOLD.
