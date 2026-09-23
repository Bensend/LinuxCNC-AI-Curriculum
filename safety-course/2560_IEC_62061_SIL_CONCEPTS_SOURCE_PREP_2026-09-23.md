# 2560 — IEC 62061 / SIL concepts for machine builders — source preparation

## Purpose

Teach SIL reasoning as another disciplined machinery-safety integrity method, not as a more impressive label than PL and not as permission to replace hazard/SRS/validation work with probability arithmetic.

The inherited chain remains:

`hazard -> safety-related control function / SRS -> required integrity -> subsystem architecture + random-hardware evidence + diagnostics + systematic controls -> achieved integrity evidence -> validation`

## Current-edition orientation

**DOC-CONFIRMED:** Pilz's current IEC 62061 guidance identifies IEC 62061:2021 as the current revised machinery functional-safety standard and notes that the 2021 edition is no longer limited to electrical/electronic/programmable-electronic technology; its scope can include other technologies such as hydraulic and pneumatic systems. Pilz's revision summary also notes new/expanded treatment of failure rates, diagnostic coverage, reliability calculation, software, validation independence, EMC, proof testing and security.

Sources:
- https://www.pilz.com/en-US/support/law-standards-norms/functional-safety/en-iec-62061
- https://www.pilz.com/en-US/support/law-standards-norms/functional-safety

## SIL is not a component adjective

For a machine safety-related control function, the required integrity follows the risk-reduction requirement/SRS. A subsystem's capability and data contribute to the complete function; they do not automatically transfer their SIL label to every machine function using that subsystem.

**Freeze:** SIL TARGET != COMPONENT SIL LABEL.

## PFHd — probability dimension, not complete safety

**DOC-CONFIRMED:** current Pilz IEC 62061 guidance gives the machinery high-demand/continuous-mode PFHd bands:

- SIL 1: `>= 1e-6` and `< 1e-5` dangerous failures/hour
- SIL 2: `>= 1e-7` and `< 1e-6`
- SIL 3: `>= 1e-8` and `< 1e-7`

PFHd is therefore a quantitative random-hardware-failure dimension. It does not prove that the safety function was specified correctly, that systematic faults are controlled, that the architecture is suitable, or that the physical machine reaches its safe state.

**Freeze:** PFHd IN RANGE != COMPLETE SAFETY FUNCTION VALIDATED.

## Architecture still matters

**DOC-CONFIRMED:** Pilz describes subsystem SIL capability as constrained by architecture and safe failure fraction/diagnostic level, with hardware fault tolerance (HFT) as a distinct structural property. Thus a very small numerical failure-rate estimate cannot be used to ignore an architectural claim limit.

Learner questions:

1. How many dangerous faults can the subsystem tolerate before the safety function is lost?
2. What failures are detected and how?
3. What shared/common dependencies defeat the claimed tolerance?
4. What architecture-based claim limit applies before probability arithmetic is used?

**Freeze:** SMALL PFHd NUMBER != PERMISSION TO IGNORE ARCHITECTURAL CONSTRAINTS.

## Random hardware versus systematic integrity

**DOC-CONFIRMED:** current IEC 62061 guidance separates dangerous random hardware failure probability from systematic safety integrity requirements for avoiding and controlling systematic faults. Schneider Electric's safety documentation gives a practical lifecycle example: systematic errors in specification, hardware, software, use and maintenance require fault-avoidance measures over the lifecycle.

This distinction is essential for AI-assisted machine design. A spreadsheet can sum PFHd values while the design still fails because the requirement is wrong, software/configuration is wrong, a parameter is uncontrolled, a maintenance replacement changes behavior, or a shared dependency was omitted.

**Freeze:** RANDOM-HARDWARE CALCULATION != SYSTEMATIC-CORRECTNESS EVIDENCE.

## Subsystem composition

A complete SRCF may include sensing/input, logic and final-element/output subsystems. The complete-function integrity must respect both the quantitative contribution of the subsystems and applicable architectural/systematic constraints.

A useful current manufacturer example is Schneider Electric's Lexium documentation, which publishes both IEC 62061 SIL-related data and ISO 13849 PL/Category data for the same safety function. The manufacturer explicitly warns that values for multiple elements must be combined using the applicable standard methods rather than treated as direct conversions. This is useful evidence that PL and SIL are parallel engineering methods with overlapping physical evidence, not interchangeable labels.

Source:
- https://product-help.schneider-electric.com/Machine%20Expert/V2.1/de/MLS-HWG/MLS-HWG/SafetyStandards-A2896F3B.html

## PL versus SIL — first comparison frame

Do not teach a universal lookup table as the method.

ISO 13849 emphasizes Category/designated architecture, MTTFd, DCavg and CCF in determining PL for subsystems and comparing achieved PL with PLr.

IEC 62061 emphasizes the required SIL for the SRCF, dangerous random hardware probability (PFHd), architectural constraints/HFT/diagnostic or SFF evidence, subsystem composition, and systematic integrity/lifecycle requirements.

Both methods still depend on:

- a correctly defined safety function/SRS;
- defensible component/application data;
- architecture and diagnostic reasoning;
- control of common/dependent failures;
- systematic correctness;
- validation of the real machine function.

Therefore the same physical architecture may be reasoned about under either framework when its evidence is suitable, but a PL result is not converted casually into SIL and vice versa.

## Practical human-factors boundary

The method must not encourage a small-shop builder to spend effort optimizing a decimal PFHd while an obvious unguarded hazard, single unmonitored dangerous final element, defeated interlock, uncontrolled gravity load, or unknown stopping behavior remains. Qualitative fault analysis should first expose obvious architecture/physical weaknesses; quantitative integrity work becomes useful when it answers a real residual design question.

**Freeze:** MORE PRECISE MATH != MORE RISK REDUCTION WHEN THE PHYSICAL WEAK LINK IS STILL OBVIOUS.

## Evidence classification

- IEC 62061:2021 scope/revision orientation: `DOC-CONFIRMED` through current Pilz standards guidance.
- PFHd SIL bands, HFT/SFF architecture relationship, random versus systematic integrity distinction: `DOC-CONFIRMED` through current Pilz IEC 62061 guidance.
- Manufacturer parallel SIL/PL safety data: `DOC-CONFIRMED` through Schneider Electric product safety documentation.
- Any machine-specific required SIL, PFHd, HFT, SFF, diagnostic effectiveness, proof-test interval or achieved SIL: `UNKNOWN` until the actual SRS/design/application evidence is supplied.

## Next evidence-gain task

Build one symbolic or explicitly sourced machine safety function and reason about it twice: first using the 2550 PL-style evidence dimensions and then using IEC 62061 SIL-style dimensions. The purpose is to identify shared physical evidence, method-specific evidence, and places where a direct PL<->SIL conversion would be invalid. Do not claim formal certification and do not invent machine-specific numerical inputs.

No compute is justified for this source/method question. If later calculation is needed to resolve a concrete question, use only `[self-hosted, openpressbrake]`.
