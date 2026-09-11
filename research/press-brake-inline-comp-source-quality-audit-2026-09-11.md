# Press-brake inline COMP source-quality audit — 2018 concept versus 2022 field report

Date: 2026-09-11

Status: **DEPENDENCY-SAFE 4600 PREPARATION; community/source-skeleton evidence only**

## Purpose

The 4600 preparation checkpoint asks for real public press-brake HAL/COMP/config evidence, not just prose. This audit evaluates an inline LinuxCNC `comp` skeleton published in the 2018 forum thread **Hydraulic press brake control**, then contrasts its evidence level with a later 2022 field retrofit report. The goal is source-quality discipline and control-ownership analysis, not a machine design prescription.

Sources:

- 2018 discussion and inline component: https://forum.linuxcnc.org/30-cnc-machines/35266-hydraulic-press-brake-control
- 2022 field report: https://forum.linuxcnc.org/show-your-stuff/45716-vertical-press-brake-interface-and-comp

## What the 2018 source actually contains

The thread includes machine-readable LinuxCNC component syntax rather than prose alone. The proposed singleton `pressbrake` component declares:

- ordinary bit inputs named `Emergency_brake`, `Light_curtain`, `Safety_door_sensor`, and `Enable`;
- independent left/right glass-scale position feedback;
- independent left/right stepper encoder feedback;
- backstop feedback and oil-pressure input;
- left/right stepper home inputs;
- maximum/press-speed and hold-time parameters;
- independent left/right stepper position commands;
- hydraulic-pump and machine-light outputs;
- left/right glass-scale correction outputs.

The discussion explicitly asks whether the closed-loop stepper logic should be implemented **inside the component or outside it in HAL**, and proposes left/right cylinder synchronization while the ram descends.

This is useful architectural evidence because it exposes the intended interface boundary and the unresolved ownership question directly in code-like form.

## Why it is not implementation evidence

The published component is only a beginning/skeleton:

- its state enum contains only `INIT` and `SELECT`;
- `INIT` transitions to `SELECT` when enabled;
- `SELECT` immediately returns to `INIT`;
- none of the declared feedback, speed, pressure, homing, synchronization, pump, or command pins are used to implement the claimed press behavior;
- no matching HAL wiring, INI configuration, thread ordering, machine parameters, build/run record, retained trace, or adversarial test is supplied in the visible source;
- no evidence establishes the semantics or independence of the signals labelled as emergency stop, light curtain, or safety-door inputs.

Therefore the correct classification is **COMMUNITY SOURCE-SKELETON**, not verified implementation, laboratory evidence, or functional-safety evidence.

A pin name is not a safety claim. An ordinary realtime component accepting `Emergency_brake` or `Light_curtain` as an input does not establish required safety integrity, independence, diagnostic coverage, safe-state behavior, or external safety-system architecture.

## Contrast with the 2022 field report

A separate 2022 Accurpress retrofit report provides stronger field evidence. Its author reports a real machine with:

- ram under full PID;
- two backgauge motion axes;
- Vickers proportional ram valve and Mesa analog command hardware;
- glass-scale/servo feedback;
- manual, semi-auto, and partially developed fully automatic modes.

Most importantly for architecture, the author reports having tried a large custom “do it all” ram/process component, found the response rough/jerky, and later put all three motion axes under LinuxCNC MOTION instead of reimplementing trajectory/motion behavior.

This is **COMMUNITY-REPORTED FIELD EXPERIENCE**, not source-level proof. It is nevertheless stronger behavioral evidence than the 2018 skeleton because the author reports an operating physical retrofit and describes an architecture change driven by observed behavior.

Do not infer that the 2018 and 2022 projects are the same implementation or that one directly evolved into the other. They are separate examples that illuminate the same ownership question.

## Evidence-quality lesson

“Machine-readable” is necessary but not sufficient for promoting a public project to implementation evidence.

For the 4600 specialization, a downloadable press-brake configuration should not be treated as code-level corroboration until the following are inspectable:

1. actual HAL/COMP/INI or equivalent runtime files;
2. explicit signal ownership and thread/function ordering;
3. where common ram trajectory, Y1/Y2 feedback, differential synchronization, final actuator allocation, and hydraulic-mode sequencing live;
4. how disable/fault conditions withdraw ordinary actuator authority;
5. provenance tying those files to the claimed machine or test fixture;
6. behavioral evidence or retained traces sufficient to distinguish declarations from executed behavior.

Safety-related names in ordinary software are to remain outside functional-safety claims unless independent safety evidence exists.

## Architectural reconciliation

The 2018 skeleton makes the central ambiguity explicit: should cylinder synchronization live inside one press component or outside it in HAL/motion control? The 2022 field report provides a cautionary answer for one machine: collapsing process state and ram motion into a large custom component gave inferior motion behavior, while LinuxCNC MOTION was retained for the axes.

This supports the existing layered-contract research direction without proving a universal topology:

```text
press-cycle/process intent
        |
LinuxCNC motion/joint trajectory ownership
        |
Y1/Y2 independent truth + synchronization/final allocation
        |
machine-specific hydraulic/electrical decoding
        |
physical plant

functional safety: separate evidence/authority boundary
```

PB-PREP-001 remains responsible for testing the narrower software question of where differential correction should be inserted relative to stock PID/final allocation. This community artifact must not be used to decide PB-PREP-001 Gates A–J.

## Adversarial checks

- **Trap:** “The component has an `Emergency_brake` pin, therefore it implements emergency stopping.”  
  **Reject.** The shown state machine does not use that pin, and an ordinary pin declaration does not establish a safety function.

- **Trap:** “The component declares two glass scales, therefore independent Y1/Y2 fault handling exists.”  
  **Reject.** Declarations establish intended observability only; no shown behavior consumes those values.

- **Trap:** “A public COMP snippet satisfies the checkpoint for a downloadable verified configuration.”  
  **Reject.** It is better than prose but lacks complete runtime wiring and executed evidence.

- **Trap:** “The 2022 field report proves custom components are always wrong for press brakes.”  
  **Reject.** It reports one architecture history and supports a design question, not a universal prohibition.

## Result

This search advances the public-evidence checkpoint one level: there is now a concrete inline LinuxCNC COMP source skeleton to inspect, but **no newly verified complete downloadable press-brake runtime configuration**. The search therefore remains open, with a stricter acceptance test than merely finding code-like text.

## Next checkpoint

1. Preserve PB-PREP-001 candidate 078 as the only active behavioral execution; do not duplicate it.
2. When 078 completes, independently audit its retained architecture-B raw trace and provenance under the frozen contract.
3. Continue searching forum attachments/repositories for a complete HAL/COMP/INI set. Promote it to implementation evidence only after ownership, ordering, provenance, and executed behavior are inspectable.
4. Keep machine-specific valve truth tables, pressure/current values, and functional-safety claims out of generic conclusions.
