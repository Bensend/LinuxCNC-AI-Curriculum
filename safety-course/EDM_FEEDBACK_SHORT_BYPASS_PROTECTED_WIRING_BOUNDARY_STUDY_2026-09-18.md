# EDM feedback short/bypass and protected-wiring boundary — 2026-09-18

## Why this independent branch

The primary safety lane's newest durable work is the gravity-axis SBC/SBT mechanical-proof path. Lane B therefore stays on a different failure mechanism: whether external-device-monitoring/feedback wiring can falsely report a healthy final element because the feedback conductor is shorted, bypassed, cross-connected, or otherwise electrically forced to the expected state.

This extends, but does not duplicate, Lane B's earlier output-short/reverse-current work. The question here is not whether a safety output can turn OFF; it is whether the return witness can lie while the final element is physically wrong.

## Evidence ledger

### DOC-CONFIRMED — SICK feedback wiring requires fault containment

SICK UE4457 documentation warns that valve feedback signals must be protected against short circuits to the associated outputs and against shorts between feedback channels, for example by protected wiring or keeping the wiring within the control cabinet.

Source: SICK, *UE4457 IP67 Safety Remote I/Os and Safety Remote Controller for DeviceNet Safety*, operating instructions, Chapter 7.

SICK Flexi Soft Safety Designer documentation repeats the same architectural warning for feedback signals: a short between Feedback 1 and Feedback 2, or between feedback and output signals, can cause an incorrect function in which the dangerous state may not be stopped or may not be stopped in time. It calls for protected cable laying or cabinet-only wiring as example measures.

Source: SICK, *Flexi Soft in Safety Designer*, operating instructions 8014519.

### DOC-CONFIRMED — Pilz feedback monitoring does not make every feedback-loop fault self-detecting

Pilz PNOZ 16S documentation provides a feedback-loop connection using contacts from external contactors, while separately warning that an automatic start or a bridged manual-start contact can produce automatic startup when the safeguard resets unless external circuit measures prevent unexpected restart.

Source: Pilz, *PNOZ 16S Operating Manual*, 1003518-EN.

Pilz PNOZ X2.8P documentation also makes a broader diagnostic lesson explicit: its short-across-contact detection function is not itself failsafe and Pilz specifies an installation test for that function. This is useful evidence against assuming that a named diagnostic feature proves every field-wiring fault is continuously covered.

Source: Pilz, *PNOZ X2.8P Operating Manual*, 1004082-EN-17.

## Frozen engineering model

Do not collapse these claims:

**FINAL ELEMENT COMMANDED OFF != FINAL ELEMENT PHYSICALLY OFF != FEEDBACK CONTACT IN EXPECTED STATE != FEEDBACK CONDUCTOR TRUTHFUL != EDM INPUT HEALTHY != ALL HAZARDOUS ENERGY ABSENT.**

EDM is only as truthful as the physical witness and the wiring path that returns that witness. A correct safety program cannot infer a welded/stuck final element if a wiring fault independently forces the feedback input into the expected state.

A second feedback channel does not automatically solve this. Two channels sharing an unprotected route, connector, supply, common terminal, jumper opportunity, or cross-short mechanism can acquire a common false state.

## Failure-path matrix

| Challenge | False conclusion if review is weak | Required evidence question |
|---|---|---|
| Feedback conductor shorted to its healthy-state potential | `EDM healthy`, therefore contactor/valve is healthy | Can the fault be detected, or is protected/separate routing required? |
| Feedback 1 shorted to Feedback 2 | Two agreeing channels are treated as independent proof | Does the architecture detect the cross-fault, or can one channel electrically drag the other? |
| Feedback shorted to an output conductor | Command and witness can become electrically coupled | Does manufacturer documentation permit the routing/topology, and what fault is claimed detectable? |
| Maintenance jumper left across feedback | Final element can fail while EDM remains satisfied | Is bypass controlled, visible, removed before return-to-service, and challenged in commissioning? |
| Wrong auxiliary contact selected | A contact changes state but does not prove the intended main/final element | Is the contact's mechanical/proof relationship appropriate and documented? |
| Ordinary PLC/FPGA drives or mirrors the EDM node | Software state becomes confused with physical witness | Is personnel-safety feedback owned and evaluated independently of ordinary control? |
| Feedback remains healthy across power-cycle/reset | Stale healthy state is accepted as fresh proof | What transition or discrepancy behavior is required before re-enable? |
| One feedback wire open | Fault may be detected, but only one fault class was challenged | Has false-healthy behavior also been challenged, not merely open-circuit behavior? |

## Practical architecture rules

1. **EDM wiring is part of the safety evidence path, not ordinary indication wiring.** Treat its routing, terminals, connectors, bypass points and cross-fault exposure as part of the safety-function design.
2. **Protected wiring is a real design control.** When the selected device relies on protected/separate wiring for a fault class, enclosure/routing assumptions become part of the validation record rather than drafting neatness.
3. **Agreement is not independence.** Two feedback bits that agree after a common electrical fault are not two independent witnesses.
4. **A feedback contact proves only its documented mechanical relationship.** It does not prove unrelated poles, stored energy, hydraulic state, gravity retention, or absence of alternate energy feeds.
5. **Reset must not erase unresolved disagreement.** A reset/rearm operation cannot legitimately convert missing physical proof into permission merely because the ordinary controller is ready.
6. **LinuxCNC/HAL/ordinary FPGA may display EDM state but must not synthesize the sole personnel-safety witness.** The independent safety architecture owns the safety decision.

## Question-driven commissioning / fault-injection card

Use only manufacturer-permitted methods and keep people outside the hazard while deliberately creating faults.

- With the final element forced/not able to return to the expected safe physical state, verify that genuine feedback disagreement prevents the documented restart/re-enable path.
- Challenge an open feedback conductor and record the exact diagnostic/reaction.
- Challenge the credible false-healthy fault classes identified by the wiring design: short to supply/reference, feedback-to-feedback cross-short, or feedback-to-output coupling. Do not perform a fault injection that the selected equipment documentation prohibits.
- Verify that protected-routing assumptions actually exist from the witness contact/device to the safety input; inspect terminal blocks and field connectors where accidental bridges are plausible.
- If maintenance bypass/jumpers are allowed, validate the bypass-control and return-to-service process, including an unmistakable out-of-service state and proof that the bypass is removed before hazardous operation.
- Power-cycle the safety and ordinary-control domains in plausible orders and verify that stale ordinary diagnostics cannot satisfy fresh physical feedback requirements.
- Verify that HMI/LinuxCNC indications distinguish `commanded safe`, `feedback returned`, `feedback fault/disagreement`, and any independently proven physical state instead of presenting one generic SAFE bit.

Exact timing windows, test voltages, fault impedances, proof-test intervals and acceptance limits are device/application-specific and must come from selected equipment documentation and the machine validation plan.

## OpenPressBrake UNKNOWN boundary

No claim is made here about OpenPressBrake's selected safety controller, contactors, valves, feedback contact type, protected wiring, cabinet routing, EDM topology, discrepancy timing, reset semantics, PL/SIL/category/DC, hydraulic state, stopping performance, or physical final-element response. Those remain **UNKNOWN** until actual hardware and machine evidence exists.

## Provenance status

- SICK and Pilz documented device behavior/wiring requirements above: **DOC-CONFIRMED**.
- Separation of physical witness from feedback-conductor integrity: **INFERENCE grounded in those manufacturer requirements**.
- OpenPressBrake implementation/performance: **UNKNOWN**.
- No new **TEST-CONFIRMED**, **SOURCE-CONFIRMED**, or **COMMUNITY-REPORTED** machine claim was created.

## Compute decision

No simulation, synthesis, benchmark, or executable test is justified for this documentation/wiring-boundary question. No GitHub-hosted runner is to be used. If a future bounded executable verification is genuinely needed, it must target `[self-hosted, openpressbrake]` only.

## Precise next independent work

Find a complete professional final-element example exposing:

**safety output -> contactor/valve -> physical feedback witness -> protected feedback wiring -> safety input/EDM -> false-healthy wiring fault -> restart inhibition/recovery.**

Prefer documentation that explicitly shows which feedback short/cross-faults are diagnosed versus prevented by routing. If the primary lane moves into this same package first, rotate Lane B to maintenance-bypass/keyed-override lifecycle and return-to-service validation, staying outside gravity-axis brake proof work.