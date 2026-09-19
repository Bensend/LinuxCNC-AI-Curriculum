# Series Guard Diagnostic Architecture Comparison

UTC study: 2026-09-19

## Question

When multiple movable guards share a safety path, what can the architecture actually prove about an individual guard fault, and what must remain separate from ordinary PLC/HMI diagnostics?

## Evidence classes

### SOURCE-CONFIRMED — conventional series contacts can mask faults
Pilz's safety compendium gives a concrete three-gate series example. A short circuit at one gate is initially undetected. Opening that gate exposes an inconsistency and faults the evaluator, but subsequently opening another gate can restore a plausible aggregate condition; the fault condition can reset and the machine can again become ready to start even though the original defect remains. Pilz names this failure of detectability `fault masking` and ties it to restricted diagnostic coverage.

Source: Pilz, Safety Compendium, Chapter 4 Safeguards, series-connected safety gates.

### SOURCE-CONFIRMED — internally diagnosed OSSD switches change the fault-detection architecture
Pilz separately states that the conventional masking issue applies to mechanical and magnetic switches, while switches with internal diagnostics and OSSD outputs, commonly RFID devices, are not affected by that particular masking mechanism.

SICK STR1 provides a concrete architecture. STR1 has monitored semiconductor OSSD outputs and detects faults no later than the next request; on detected fault it switches the safety circuit off. STR1 supports several series architectures:

- Flexi Loop: each node evaluates a safety switch and sends information to the SICK safety evaluator; diagnostics are available per node.
- T-connector series: connected devices act like one device and individual diagnostics are not provided by that series connection.
- Control-cabinet series: safety OSSDs are series evaluated while auxiliary outputs can be individually wired to an ordinary PLC for diagnostics.

SICK's Flexi Loop material describes continuous diagnostics of individual doors/E-stops/sensors and individual-node fault indication.

Sources: SICK STR1 Operating Instructions 8018754/1RU3/2025-04-04; SICK Safe Series Connection / Flexi Loop documentation.

### SOURCE-CONFIRMED — diagnostic information is not automatically safety authority
Pilz Safety Device Diagnostics explicitly labels its diagnostic response data as not safety-relevant and directs the designer to the individual safety device for safety-relevant data. SDD can provide extensive device diagnostics and can work with series-connected sensors, but the diagnostic bus/status presentation must not silently become the personnel-safety decision path.

Rockwell GuardLink similarly exposes device-level diagnostic/health information for troubleshooting. This improves fault localization; it does not by itself prove that the hazardous final element stopped or that personnel are clear.

Sources: Pilz Safety Device Diagnostics; Rockwell GuardLink technology/product documentation.

## Durable engineering freeze

**AGGREGATE SERIES INPUT SAFE != EACH GUARD CHANNEL HEALTHY != INDIVIDUAL FAULT LOCALIZED != HAZARD PHYSICALLY STOPPED != PERSONNEL CLEAR != RESTART AUTHORITY.**

**INDIVIDUAL DIAGNOSTIC MESSAGE PRESENT != SAFETY-RATED INDIVIDUAL DECISION PATH.**

**OSSD INTERNAL DIAGNOSTICS / SAFE NODE EVALUATION CAN REMOVE A SPECIFIC CONVENTIONAL CONTACT-MASKING FAILURE MODE; THEY DO NOT REMOVE THE NEED TO VALIDATE THE COMPLETE SAFETY FUNCTION THROUGH ITS FINAL ELEMENT AND physical hazardous-state witness.**

## Commissioning / adversarial validation pattern

For a multi-guard system, validation should be architecture-specific rather than using one generic `open every door` test:

1. Identify whether each guard reaches the evaluator as conventional volt-free contacts, internally diagnosed OSSD, individually wired safe input, safe series node, or ordinary diagnostic-only data.
2. Demand each guard independently and prove the intended safety output/final element response plus the physical hazardous-state witness.
3. Introduce only faults explicitly permitted by the manufacturer's validation procedure. For conventional series contacts, challenge the documented masking sequence: create the permitted single fault, operate the affected guard, then operate a second guard and verify whether the evaluator retains or loses the fault as the documented architecture predicts.
4. For individually diagnosed architectures, verify that the correct physical guard/node is identified and that a fault cannot be cleared merely by operating another guard. Device identity/localization is part of commissioning evidence, not a substitute for the safety reaction.
5. Prove reset/restart behavior after correction. Closing guards or clearing a diagnostic display must not resurrect a stale ordinary START request.
6. Verify that PLC/HMI diagnostic data cannot independently authorize hazardous motion when the safety path is not valid.

## Human factors

Individual diagnostics have safety-adjacent practical value even when the diagnostic presentation is not itself safety-rated: they make the failed device easy to find, reducing pressure to jumper/bypass an unknown guard in order to restore production. A design that makes fault localization needlessly difficult encourages defeat of safeguards and should be treated as an engineering defect where a practical diagnosable architecture is available.

## Open evidence gap

The desired single professional commissioning artifact that shows the entire chain remains open:

`guard A/B/C -> individual/series safety channels -> injected single fault -> second-guard operation -> retained/masked diagnostic result -> evaluator safe output -> actual final element -> physical hazardous-state witness -> correction -> re-proof -> safety reset -> fresh ordinary START`.

Public manufacturer evidence establishes the architecture and fault-masking distinction strongly, but the sources reviewed here do not expose that whole physical final-element chain in one inspectable commissioning example. Do not invent one.

No OpenPressBrake guard topology, PL/SIL/category/DC/CCF, final-element response, reset location, hydraulic response, or stopping performance is assigned by this study.

No executable lab is justified: the unresolved issue is source/implementation evidence, not a software behavior question. No runner compute was used.
