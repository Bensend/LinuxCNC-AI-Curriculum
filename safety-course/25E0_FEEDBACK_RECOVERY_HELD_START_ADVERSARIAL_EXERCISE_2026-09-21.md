# 25E0 adversarial exercise — feedback recovery with a held Start demand

Date: 2026-09-21

## Scenario

A machine uses an independent safety relay to remove hazardous actuator power through redundant external contactors. Positively guided NC auxiliary contacts from those contactors form the external-device-monitoring/feedback circuit.

An E-stop demand drops the safety outputs. One contactor does not return as expected, so the feedback circuit remains invalid. The safety relay remains in its safe state.

During troubleshooting, the ordinary machine Start input is left continuously asserted. A technician repairs the contactor/feedback problem. The feedback input now becomes valid.

The HMI simultaneously shows:

- protective input healthy;
- external feedback healthy;
- safety outputs currently off;
- ordinary Start input = TRUE.

## Learner tasks

1. Decide whether the machine may automatically re-energize solely because feedback has returned. Do not answer from intuition; state what implementation evidence is required.
2. Explain why `feedback healthy` is not equivalent to `fresh start intent`.
3. Bound what the contactor feedback proves. Name at least three physical claims it does **not** automatically prove.
4. Specify a safer restart-freshness contract for a machine whose risk assessment/design requires deliberate restart after this fault.
5. Separate the independent safety function from useful ordinary LinuxCNC defense-in-depth behavior.
6. Identify the misleading statement: **“The relay was safely off during the fault, therefore the old Start request cannot matter when the fault clears.”** Explain the mechanism that makes it unsafe as a universal assumption.
7. State what commissioning test would expose a stale held-demand defect without inventing a PL/SIL, stop time, hydraulic pressure threshold or diagnostic-coverage percentage.

## Evidence key for evaluator

Use Siemens SIRIUS 3SK1 Equipment Manual 11/2025 section 8.9.2.4. The documented behavior is that a feedback-circuit error holds the device safe while the error persists, but a Start signal detected during that interval can result in start after the feedback error is eliminated. Siemens provides a specific interconnection to change this behavior so correction of the feedback error does not automatically produce start.

A strong answer must therefore reject the inference that safe-state residence cancels an existing demand. It should require explicit temporal semantics: for example, Start inactive after feedback recovery followed by a deliberate new transition, when that is the intended restart contract.

The answer must also bound EDM authority. A positively guided auxiliary contact can provide evidence about the monitored contactor/contact relationship in the documented circuit; it does not automatically prove hydraulic pressure, ram motion, stored mechanical energy, brake state, zero torque or stopping performance.

LinuxCNC may additionally cancel stale cycle/jog requests and require a new ordinary-control edge after safety release returns. That is defense in depth and human-factors control, not personnel-safety authority.

## Transfer variant

Replace the contactors with a safety-controller feedback input sourced from a drive or valve terminal. Ask the learner to determine what the feedback signal actually means from that device's manual before accepting it as final-element proof. A generic `ready`, `healthy` or `STO active` indication must not be silently promoted into proof of mechanical/hydraulic safe state.
