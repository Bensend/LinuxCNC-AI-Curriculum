# Guard-interlock defeat, motivation, and human-factors authority study

Date: 2026-09-20

## Purpose

Turn the curriculum's practical human-factors rule — make the safer path easier than bypass — into a source-grounded machine-safety design rule rather than treating it as informal advice.

## Authoritative basis

### ISO 14119:2024

ISO's current published description of ISO 14119:2024 states that the standard covers principles for design and selection of interlocking devices associated with guards and gives guidance on measures to minimize the possibility of defeat in a reasonably foreseeable manner. It is explicitly independent of the nature of the energy source and includes trapped-key interlocking systems.

Source:
- https://www.iso.org/standard/75942.html

Evidence: **DOC-CONFIRMED**.

This matters because foreseeable bypass is not merely an operator-training issue. The design/selection of the safeguard is expected to address it.

### Manufacturer implementation guidance

Pilz states that EN ISO 14119 addresses prevention of safeguard/interlock defeat and that all phases of the machine lifecycle must be considered, including automatic, setup, and alternative operating modes.

Source:
- https://www.pilz.com/en-US/support/law-standards-norms/manufacturer-machine-operators/manipulation-protection

Evidence: **DOC-CONFIRMED** manufacturer guidance.

ReeR's machinery-safety guide summarizes practical anti-defeat measures including mounting interlock elements out of reach or shielded/hidden, using coded actuators to prevent substitution, making removal/movement difficult, monitoring status or cyclically testing, and using a second interlock based on a different operating principle with plausibility checking where appropriate.

Source:
- https://int.reersafety.com/academy/industrial-safety-guide/en-iso-14119safety-of-machinery/

Evidence: **DOC-CONFIRMED** manufacturer guidance / standard interpretation.

Pilz's PSENmech product guidance gives a concrete device example: mechanically coded actuators are used for protection against defeat, while opening the guard trips the switch and the evaluation device brings hazardous movement to a standstill.

Source:
- https://www.pilz.com/en-US/products/sensor-technology/safety-switches/psenmech-mechanical-safety-switch

Evidence: **DOC-CONFIRMED** product/application behavior.

## Central curriculum correction

The course should not teach:

> install a safety switch, tell people not to bypass it, and punish bypass.

The better engineering chain is:

`REAL WORK TASK -> SAFEGUARD INTERFERENCE/MOTIVATION -> FORESEEABLE DEFEAT METHOD -> DESIGN CHANGE THAT REMOVES MOTIVATION OR MAKES DEFEAT HARDER -> FAULT/DEFEAT DETECTION -> SAFE RESPONSE -> DIAGNOSTIC THAT HELPS THE USER FIX THE REAL PROBLEM`.

The user's existing human-factors rule is therefore source-aligned: **inconvenience that predictably encourages defeat is an engineering defect to investigate**.

Evidence classification for that exact wording: **INFERENCE**, grounded in ISO 14119's defeat-minimization purpose and manufacturer interpretations emphasizing lifecycle use and anti-manipulation measures.

## Frozen distinctions

`GUARD PRESENT != GUARD INTERLOCKED != INTERLOCK HARD TO DEFEAT != DEFEAT DETECTED`.

`CODED ACTUATOR != IMPOSSIBLE TO BYPASS`.

`INTERLOCK CHANNEL HEALTHY != GUARD PHYSICALLY IN THE INTENDED PROTECTIVE POSITION` unless the validated architecture actually establishes that relationship.

`OPERATOR TRAINED NOT TO BYPASS != BYPASS MOTIVATION REMOVED`.

`BYPASS PROHIBITED != BYPASS PHYSICALLY DIFFICULT`.

`TAMPER-RESISTANT INTERLOCK != SAFE MACHINE BY ITSELF`.

`GUARD CLOSED != HAZARD CEASED != RESTART AUTHORIZED`.

## Practical defeat pathways to design against

ISO/manufacturer guidance supports considering reasonably foreseeable manual defeat and use of readily available objects. For curriculum design reviews, ask at least:

1. Can the switch be actuated while the guard is physically open?
2. Can a spare/loose actuator, magnet, key, shim, wire, or common shop tool simulate the protected state?
3. Can the switch or actuator be unscrewed, repositioned, taped, wedged, or held in the safe state?
4. Can a maintenance person leave a temporary bypass installed because removing it is inconvenient?
5. Does nuisance tripping, poor alignment, slow restart, awkward setup, or inability to perform legitimate diagnostics create a strong incentive to defeat the device?
6. Does the HMI merely say `guard fault`, forcing trial-and-error, when it could identify the actual door/device/channel and help restore the safeguard correctly?
7. Is there a legitimate setup/service task that the normal guard prevents, but no engineered alternate mode exists to perform that task safely?

Items 4-7 are **INFERENCE / human-factors application**, not direct quotations from ISO 14119.

## Safer-path design hierarchy

When a safeguard is being defeated, do not begin with a more threatening warning label. Investigate why.

### A. Remove unnecessary interference

Design guarding around real loading, unloading, cleaning, setup, adjustment, measurement, and maintenance tasks. If a task can be performed without entering the hazard zone, make that path physically convenient.

Examples: accessible external test points; remote indicators; clean access panels outside the safeguarded envelope; tooling/setup features that do not require reaching around a gate.

Evidence: **INFERENCE**, consistent with lifecycle/defeat-minimization guidance.

### B. Provide a legitimate alternate mode when exposure is actually necessary

Where a real task requires access with energy present, use a deliberately bounded setup/service architecture appropriate to the risk: selected mode, task-specific safeguards, enabling/hold-to-run authority, bounded motion, physical preconditions, and explicit return to normal. Do not force technicians to choose between "production mode" and "jumper the interlock."

Evidence: **INFERENCE**, supported by the course's separate SICK/Pilz/Rockwell controlled-energy studies.

### C. Make simple substitution/removal difficult

Use coding, protected mounting, tamper-resistant/secured installation, and suitable device architecture where required by the risk assessment. Avoid exposed easy-to-hold limit switches where a readily available object can trivially simulate guard closure.

Evidence: **DOC-CONFIRMED** manufacturer guidance derived from ISO 14119.

### D. Detect inconsistency rather than trusting one bit

Where the architecture requires it, use redundant/diverse sensing, plausibility checks, cyclic testing, diagnostics, or other validated measures so a permanently asserted `guard closed` state is not blindly trusted.

Evidence: **DOC-CONFIRMED** as a family of measures in manufacturer ISO 14119 guidance. Exact diagnostic coverage and required architecture are machine-specific and remain **UNKNOWN** until designed/validated.

### E. Make correct restoration easy

A guard that takes an hour to realign after every legitimate service action invites a wooden shim or taped actuator. Design mechanical alignment, connectors, diagnostics, fasteners, and access so correct reinstallation is the shortest route back to production.

Evidence: **INFERENCE / human-factors design rule**.

## Press-brake application

For a press brake, defeat pressure can arise at several different boundaries:

- front point-of-operation safeguarding interfering with unusual parts;
- rear gate access needed for backgauge setup or jam clearing;
- side guard access during tooling/setup;
- hydraulic diagnostic work needing live pressure;
- laser/ESPE alignment or muting configuration;
- maintenance after a fault when production is waiting.

These are not one problem and should not share one generic bypass.

A professional design should ask for each task:

`WHY DOES THE PERSON NEED ACCESS? -> WHAT HAZARD REMAINS? -> CAN THE TASK MOVE OUTSIDE THE HAZARD? -> IF NOT, WHAT ALTERNATE SAFETY FUNCTION IS VALID? -> HOW IS NORMAL PRODUCTION AUTHORITY SUPPRESSED? -> HOW IS THE SAFEGUARD RESTORED/REVALIDATED?`

## LinuxCNC / FPGA boundary

Ordinary LinuxCNC/HAL/FPGA may expose diagnostics such as guard identity, channel disagreement, mode request, or reason-for-inhibit. It may make correct recovery easier. It must not become the sole personnel-safety evaluator merely because software can see those states.

Freeze:

`HAL GUARD_CLOSED = TRUE != INDEPENDENTLY VALIDATED GUARD-SAFETY AUTHORITY`.

`HMI BYPASS BUTTON != ACCEPTABLE SUBSTITUTE FOR ENGINEERED SETUP/SERVICE MODE`.

A useful HMI should make bypass **less attractive** by clearly showing why the machine is inhibited and what safe restoration step is required, while the independent safety system retains the actual hazardous-motion permission boundary.

## Adversarial design review

For every OpenPressBrake safeguard later proposed, force the design review to answer:

- How would a hurried operator defeat this with common shop objects?
- How would a technician defeat it to complete a legitimate service task?
- What nuisance behavior would make them want to?
- Can the mechanical design remove that nuisance?
- Can a legitimate alternate mode remove the need for defeat?
- Can defeat/substitution be made harder or detected?
- After the task, what forces or strongly encourages restoration rather than leaving the machine in a bypassed state?
- Does restoration require a separate safety reset/requalification and fresh ordinary start where applicable?

If these questions have no credible answers, the safeguard architecture is incomplete even if the nominal safety schematic looks correct.

## UNKNOWN / not to invent

This study does not choose an OpenPressBrake interlock technology, coding level, PL/SIL/category, diagnostic coverage, guard-locking force, number of channels, defeat-monitoring algorithm, or required mode architecture. Those depend on the actual machine risk assessment and validated safety design.

## Next work

Use this human-factors/anti-defeat lens when reviewing later safety architectures. A high-value next source trace is a complete professional machine implementation where a legitimate setup/maintenance need is solved by an alternate operating mode rather than by bypassing the guard, including physical mode selection, enabling authority, restricted hazardous function, fault behavior, and return to automatic operation.

No executable lab is justified for this standards/design question.
