# 25E0 — Recurring Nuisance-Trip Human-Factors Adversarial Exercise

Date: 2026-09-22
Status: learner-facing adversarial exercise

## Evidence basis

Pilz identifies faster work, convenience, time/performance pressure, poor ergonomics, and simplified operating modes as incentives for safeguard manipulation. Its guidance says the incentive must be identified and reduced, protection concepts should be developed with machine function, and an existing machine with manipulation should undergo situation/cause analysis and safety-concept improvement. Pilz's safety compendium goes further: safeguards that obstruct rather than support the workflow create foreseeable manipulation pressure, and merely making manipulation technically harder is not enough if the reason remains.

Sources, accessed 2026-09-22:
- Pilz, `Protection against manipulation`: https://www.pilz.com/en-INT/support/law-standards-norms/manufacturer-machine-operators/manipulation-protection
- Pilz, `Chapter 4 Safeguards`, Safety Compendium: https://www.pilz.com/download/open/TechBo_Pilz_safety_compendium_1004669-EN-02.pdf

Evidence class: `DOC-CONFIRMED` for the manufacturer guidance; application conclusions below are `INFERENCE` until machine-specific evidence establishes them.

## Scenario

A guarded automated cell stops several times per shift because an interlocked door intermittently falls near the switch's operating boundary during vibration. Operators must walk around the cell, close the door firmly, return to the station, reset, and restart. Production proposes one of four fixes:

A. increase an ordinary LinuxCNC debounce/filter until the trip disappears;
B. tape/spare-actuate the interlock during production and rely on E-stop;
C. replace the switch with a more defeat-resistant coded switch but leave the alignment/vibration/workflow problem unchanged;
D. preserve the safety function while investigating alignment, mounting, door retention, vibration, switch/application tolerance, reset workflow, and whether a different suitable guard/interlock architecture removes the recurring incentive.

## Learner task

For each proposal, classify:

- whether it changes personnel-safety authority;
- whether it addresses the physical cause or merely suppresses evidence;
- which `FIND-*`, `DEP-*`, `PROP-*`, and `SF-*` records become relevant;
- what remains `UNKNOWN`;
- what revalidation is required before production return;
- what human-factor incentive remains.

Then propose the minimum defensible containment and engineering path without inventing switch tolerances, vibration limits, debounce times, PL/SIL targets, or reset timing.

## Expected reasoning boundaries

### A — ordinary LinuxCNC debounce/filter

Reject as a personnel-safety fix unless authoritative safety architecture explicitly places the required filtering in a validated safety-related path. Ordinary LinuxCNC/HAL/FPGA convenience logic must not be promoted to safety authority because nuisance trips are inconvenient.

Freeze: **NUISANCE TRIP != PERMISSION TO MOVE SAFETY AUTHORITY INTO ORDINARY CONTROL.**

### B — defeated interlock plus E-stop

Reject for exposed production. A manually actuated E-stop is not a substitute for the guard proposition and does not restore the physical evidence destroyed by defeating the interlock.

Freeze: **E-STOP AVAILABLE != GUARD SAFETY FUNCTION REPLACED.**

### C — harder-to-defeat switch only

Potentially useful against foreseeable manipulation, but incomplete if vibration/alignment/workflow remains the actual recurrence mechanism. Pilz explicitly warns that technical anti-manipulation measures alone do not remove the incentive.

Freeze: **HARDER TO DEFEAT != ROOT INCENTIVE REMOVED.**

### D — preserve protection and remove recurrence pressure

This is the preferred engineering direction, subject to machine-specific validation. Create/retain `FIND-*` records for recurrence; trace the physical mounting/alignment/vibration dependency; determine whether the selected device and installation are appropriate; improve the physical/workflow design; then re-prove the affected guard proposition under representative conditions before return to ordinary operation.

If the machine cannot maintain a basic safe-to-operate threshold while people are exposed, production remains unavailable. Diagnostic experiments must be isolated/remote with people outside the danger zone when hazardous motion could occur.

## Recurrence escalation questions

1. Is the door/switch actually misaligned, or is that still an inference?
2. Does vibration act through a shared physical structure that could affect another guard or sensor?
3. Is the device installed inside its documented mechanical/environmental application envelope?
4. Does the reset/restart workflow create avoidable travel or repetition that increases defeat incentive?
5. Can the guard be mechanically retained/aligned better without reducing protective function?
6. Would a different suitable interlock architecture tolerate the legitimate machine motion while maintaining the required safety proposition?
7. Did earlier repairs merely restore the switch temporarily without addressing the recurrence mechanism?
8. After correction, what physical/function evidence demonstrates the proposition again?

## Human-factors grading rule

A learner does not receive full credit for saying only `do not bypass`. Full credit requires recognizing recurring nuisance trips as engineering evidence and reducing the legitimate incentive for defeat while preserving the independent safety boundary.

## Frozen distinctions

- **NUISANCE TRIP != FALSE SAFETY FUNCTION.**
- **PRODUCTION PRESSURE != AUTHORITY TO WEAKEN PROTECTION.**
- **HARDER TO DEFEAT != LOW INCENTIVE TO DEFEAT.**
- **DIAGNOSTIC SUPPRESSION != PHYSICAL CAUSE CORRECTED.**
- **RESET WORKFLOW IMPROVED != SAFETY PROPOSITION WEAKENED.**
- **NORMAL CONTROL MAY DISPLAY/DIAGNOSE SAFETY STATE != NORMAL CONTROL MAY ACCEPT PERSONNEL SAFETY.**
