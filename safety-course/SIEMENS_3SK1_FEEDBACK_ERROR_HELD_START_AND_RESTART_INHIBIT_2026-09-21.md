# Siemens 3SK1 feedback-error, held-start and restart-inhibit study

Date: 2026-09-21

## Question

When a safety relay is waiting for monitored external final-element feedback to return, what happens if a Start signal is already present, and what does the feedback witness actually prove?

This follows the 25E0 Schmersal reset/feedback/controller-release study and deliberately targets explicit disagreement/failure behavior rather than another generic feedback-loop example.

## Authoritative implementation

**DOC-CONFIRMED.** Siemens, *SIRIUS 3SK1 safety relays — Equipment Manual*, 11/2025, A5E02526190021A/RS-AF/006, section 8.9.2.4, explicitly documents a feedback-circuit error case. If the 3SK1 detects a feedback-circuit error, it remains in the safe state while the error persists. Critically, if a Start signal is detected during that interval, the device starts after the feedback-circuit error is eliminated. Siemens then provides a specific start-button interconnection to change that behavior under the heading **No automatic start of a feedback circuit error correction**.

Authoritative source: Siemens Industry Online Support, `manual_safety_relay_3SK1_en-US.pdf`, current indexed 11/2025 edition, section 8.9.2.4.

A separate Siemens SIRIUS safety-system manual describes the physical purpose of actuator monitoring: external contactors used to switch hazardous-motion load circuits are monitored through feedback signal contacts; if those feedback contacts are not closed, the safety relay cannot switch in. With positively driven contacts, a welded load contact prevents the expected feedback condition and therefore prevents switch-in.

Authoritative source: Siemens safety-system manual, actuator-circuit monitoring section.

## The important state-machine lesson

The 3SK1 example proves that **feedback disagreement and command freshness are separate properties**.

A safe output can correctly remain off while external feedback is wrong, yet an already-present Start signal can remain semantically effective and cause output energization when the feedback fault later disappears. The designer therefore cannot infer fresh intent merely from the fact that the relay spent time in a safe state.

Freeze:

- **FEEDBACK ERROR -> SAFE STATE does not imply START REQUEST CANCELLED.**
- **FEEDBACK RESTORED does not imply FRESH START.**
- **START SIGNAL PRESENT does not imply START TRANSITION OCCURRED AFTER FEEDBACK BECAME VALID.**
- **RESTART INHIBIT is a state-machine property, not a synonym for safe outputs currently being off.**

The Siemens alternate wiring is especially valuable pedagogically because it shows that the undesirable/undesired restart behavior is not solved by adding another generic `feedback_ok` Boolean. It is solved by defining the relationship between feedback recovery and the temporal semantics of Start.

## What the feedback witness proves

**DOC-CONFIRMED:** in Siemens' actuator-monitoring architecture, the feedback circuit can monitor auxiliary/signalling contacts of external contactors and prevent safety-relay switch-in when the required feedback condition is absent. Positively driven contact construction can make a welded load-contact fault observable through the associated feedback contact.

But that witness remains bounded.

A contactor feedback contact can support a claim about the monitored contactor/contact state according to the contactor's documented positively-driven contact relationship and wiring. It does not by itself prove:

- zero motor torque;
- absence of stored mechanical energy;
- hydraulic pressure below a machine-specific threshold;
- hydraulic valve-spool position;
- ram stopped or restrained;
- brake engagement;
- contactor main-pole isolation beyond what the monitored architecture and component evidence justify; or
- correct physical stopping performance.

Those broader claims remain **UNKNOWN/design-specific** until the relevant physical chain is traced and, where required, physically validated.

Freeze:

**EDM / FEEDBACK VALID != COMPLETE PHYSICAL SAFE-STATE PROOF.**

## Failure-path analysis

### F1 — contactor fails to return

Protective demand removes the safety outputs. A monitored contactor does not return to the expected state, so feedback remains invalid. The 3SK1 remains safe while the feedback error persists. This is useful diagnostic coverage of the monitored actuator circuit, not generic proof that every hazardous-energy path is safe.

### F2 — Start held during feedback fault

The operator or ordinary controller leaves Start asserted while feedback is invalid. In the documented default behavior, eliminating the feedback error can cause the relay to start without a newly generated Start event. Therefore a course design that requires fresh operator intent after repair/recovery must implement the documented restart-inhibit/start-interconnection behavior or an equivalently justified architecture; it cannot assume freshness.

### F3 — feedback becomes electrically valid for the wrong reason

A bypassed, miswired or incorrectly selected auxiliary contact may satisfy the feedback input while the physical claim the designer intended to prove is false. Electrical validity of the input does not enlarge its diagnostic authority. Commissioning must prove the signal-to-physical-state mapping and defeat resistance appropriate to the design.

### F4 — electrical final element is healthy, different energy domain remains hazardous

A motor contactor can correctly report its monitored state while a hydraulic accumulator, gravity load, brake, pneumatic store or another independent energy path remains hazardous. Return-to-service requires the evidence appropriate to those paths rather than treating EDM as a universal `machine_safe` bit.

## Human-factors consequence

This source exposes a subtle but realistic maintenance trap. A technician can clear the thing visibly blocking reset — for example, restore a contactor or repair its feedback wiring — and the machine can become eligible to energize while Start is still asserted. The safer design makes the required behavior obvious and difficult to defeat:

- show `FEEDBACK FAULT` separately from `RESET/START REQUIRED`;
- when fresh intent is required, force Start to return inactive and require a new deliberate transition after feedback is valid;
- do not tell maintainers to hold or repeatedly press Start while repairing feedback faults;
- preserve independent safety authority; ordinary LinuxCNC diagnostics may explain the inhibit but must not counterfeit the safety feedback.

## OpenPressBrake / LinuxCNC teaching boundary

For a LinuxCNC machine, ordinary control may implement additional demand-freshness rules such as cancelling jog/cycle requests when safety permission disappears and requiring a new edge after permission returns. That is useful defense in depth and human-factors engineering.

It does **not** replace the independent safety subsystem's restart/rearm semantics or monitored final-element feedback.

A useful conceptual split is:

`protective inputs + safety logic + bounded final-element feedback + required reset/restart transition -> safety release eligibility`

separate from:

`production configuration + mode + fresh ordinary operator demand -> LinuxCNC motion request`.

Neither side should silently regenerate the other's authority.

## Evidence ledger

- 3SK1 remains safe while feedback error persists: **DOC-CONFIRMED**.
- Start present during feedback error can cause start after the error is eliminated: **DOC-CONFIRMED**.
- Siemens provides an alternate start-button interconnection specifically to prevent automatic start on feedback-error correction: **DOC-CONFIRMED**.
- External contactor feedback can inhibit switch-in and positively driven contacts can expose a welded load-contact condition in the documented architecture: **DOC-CONFIRMED**.
- Exact physical hazard state proved by a particular feedback contact beyond its documented contact relationship: **UNKNOWN/design-specific**.
- Requiring a fresh ordinary LinuxCNC demand after safety-permission restoration as defense in depth: **INFERENCE/design recommendation**, not a claim that LinuxCNC is safety-rated.

## Curriculum result

The previous question is now materially answered with explicit vendor behavior, including a counterintuitive failure/recovery path. The course should carry a new review question into every restart/rearm design:

> If a reset/start/jog/cycle demand is already true while final-element feedback is invalid, exactly what happens when feedback becomes valid again?

If the answer is not explicitly defined and verified, restart freshness is unresolved.

No executable compute was justified; this was a documentation/state-machine question answered by authoritative manufacturer evidence.
