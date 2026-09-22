# 2520 — Integrity-Method Selection and Target Allocation

Date: 2026-09-22

## Purpose

This lesson sits after hazard/safety-function derivation, fault analysis, and architecture allocation. It prevents a common design error: choosing a safety relay/controller/topology first and then reverse-justifying a PL or SIL claim.

The required order is:

`hazardous event -> safety function/SRS -> risk assessment -> applicable integrity method -> required target -> architecture/reliability/diagnostics/CCF/systematic controls -> achieved integrity evidence -> validation`

A target is a requirement on a safety function. It is not a badge inherited from the highest-rated component in the chain.

## Evidence ledger

### ISO 13849-1 path

**DOC-CONFIRMED:** Pilz's current ISO 13849-1 guidance describes determining required Performance Level (PLr) for an individual safety function from risk assessment criteria including injury severity, frequency/exposure, and possibility of avoidance. It separately identifies Category, MTTFd, diagnostic coverage (DC), and common-cause failure (CCF) as inputs to evaluating a self-developed subsystem. Source: https://www.pilz.com/en-INT/support/law-standards-norms/functional-safety/en-iso-13849-1 (retrieved 2026-09-22).

**DOC-CONFIRMED:** The same guidance identifies safety-function specification content beyond PLr: triggering event, reaction/safe state, operating modes, reaction times, fault reaction/behavior, priority, and interfaces to other safety functions. This is why the SRS must exist before integrity arithmetic.

### IEC 62061 path

**DOC-CONFIRMED:** Siemens describes IEC 62061 as a machinery-sector functional-safety standard for safety-related electrical/electronic/programmable electronic control systems and describes lifecycle treatment from concept through decommissioning. Its machinery SIL treatment uses SIL 1 through SIL 3 and associates the required SIL with a PFH target range. Source: Siemens, *Safety technology with SINUMERIK*, section 3.5, https://support.industry.siemens.com/cs/attachments/109478069/SINUMERIK_Safety_Integrated_en_en-US.pdf (retrieved 2026-09-22).

**DOC-CONFIRMED:** Siemens' IEC 62061 application material separates architectural constraints/SIL claim limit, PFHd, systematic safety integrity, diagnostics/fault reaction, and safety-related application software requirements. Source: https://support.industry.siemens.com/cs/attachments/23996473/23996473_as_fe_i_013_DOKU_v13_e_33.pdf (retrieved 2026-09-22).

**DOC-CONFIRMED:** Siemens' SIRIUS Safety Integrated application manual states that overall safety integrity is not one number inherited from a component: systematic integrity and structural constraints can limit the system through the weakest subsystem, while the dangerous random hardware contribution is accumulated across the safety function. Source: https://cache.industry.siemens.com/dl/files/718/81366718/att_20400/v1/application_manual_sirius_safety_integrated_en-US.pdf (retrieved 2026-09-22).

### Edition/applicability boundary

**UNKNOWN until project-specific selection:** exact normative edition, regional adoption, machine type-C standard, customer/regulatory requirement, and whether one method is required/preferred for the actual machine. This course teaches the selection gate; it does not declare a universal winner.

## Learner-facing selection gate

Before doing any PL/SIL calculation, answer and preserve:

1. What machine and lifecycle phase are in scope?
2. What hazardous event is this safety function reducing?
3. What is the function's trigger, required physical reaction, safe-state proposition, modes, timing requirement, reset/restart behavior, and interfaces?
4. What machine/product-specific standard or legal/regional requirement constrains the method, if any?
5. Which machinery functional-safety method is being used for this function, and why is it applicable to the technologies and architecture in scope?
6. What exact edition/adoption is being used?
7. How was the required integrity target derived from risk assessment/SRS?
8. What evidence is required to show the implemented function achieves that target?

If 1–7 cannot be answered, component arithmetic is premature.

## What the integrity ingredients contribute

### Structural architecture / Category or architectural constraint

Answers questions about fault resistance, redundancy/fault tolerance, and behavior after faults. It does **not** by itself establish achieved PL/SIL.

### Reliability data

Describes dangerous random hardware failure contribution under declared assumptions. Values must come from applicable manufacturer data or a justified calculation with realistic use rate/environment. A catalog value detached from its conditions is not evidence.

### Diagnostic coverage and fault reaction

Addresses which dangerous faults are detected, with what diagnostic path and required reaction. `diagnostic feature exists` is weaker than `the relevant dangerous failure is detected in the application within the required time`.

### Common-cause controls

Address failures capable of defeating nominally redundant paths together. Separation on a schematic does not prove independence from shared power, mechanics, environment, configuration, maintenance, communications, contamination, or a common final element.

### Systematic-fault controls

Address specification, design, software/configuration, integration, modification and lifecycle errors. Hardware redundancy cannot repair a safety requirement that was specified incorrectly.

### Validation

Checks that the implemented safety function actually satisfies its SRS and integrity assumptions. Calculation is evidence for part of the claim; validation is not replaced by arithmetic.

## Symbolic worked example — no invented machine numbers

Safety function `SF-GUARD-STOP` protects access to a hazardous moving process.

- `HZ-01`: person accesses hazard zone while hazardous motion/energy can harm them.
- `PROP-01`: hazardous motion/energy reaches the defined safe state before exposure permitted by the SRS.
- Trigger: guard opening/access request.
- Required integrity target: `TARGET-01 = [derive from documented risk assessment using selected method]`.
- Input subsystem: `SUB-I`, with architecture/reliability/diagnostic/CCF evidence placeholders.
- Logic subsystem: `SUB-L`, with certified/application evidence placeholders.
- Final-element subsystem: `SUB-O`, with architecture/reliability/diagnostic/CCF evidence placeholders.
- Process witness: `EVID-PHYS`, proving only the physical proposition actually established by the design.

ISO 13849-style evidence placeholders:

`PL_achieved = f(Category, MTTFd, DCavg, CCF controls, systematic measures, subsystem combination, validation)`

Compare the achieved result with `PLr = TARGET-01` only after every input is justified for the application.

IEC 62061-style evidence placeholders:

`SIL_achieved` is constrained by subsystem architectural/systematic capability and by the accumulated dangerous random hardware contribution for the complete safety function, plus validation of the implemented SRCF.

No numeric PFHd, MTTFd, DC, CCF score, demand rate, or target is assigned here because the example has no real machine data.

## Counterexample — the high-rated controller trap

Suppose `SUB-L` is a certified safety controller capable of a high integrity level and two independent guard inputs are correctly diagnosed. Both safety outputs, however, drive one unmonitored mechanical/hydraulic final element whose physical safe-state proposition has never been established under the relevant failure modes.

Incorrect conclusion: `the controller is SIL 3 / PL e capable, therefore the machine safety function is SIL 3 / PL e`.

Correct disposition: **NOT PROVED**. The controller's capability does not establish the complete safety function. A shared final element may impose an architectural/integrity limit, and a status bit or electrical feedback cannot be silently promoted into proof of the downstream physical process proposition.

Likewise, two redundant safety controllers cannot create two physical energy-removal paths when both ultimately depend on the same unproved final element.

## Human-factors gate

Integrity arithmetic does not excuse a safeguard that operators predictably defeat because normal use, setup, cleaning, jam clearing, or recovery is impractical. Treat foreseeable bypass pressure as a design input. Prefer architectures where correct guard/interlock use and restoration are simpler than bypass.

If the design cannot establish a basic safe-to-operate state with people exposed, the machine is not ready for exposed operation. Experimental operation must be isolated/remote with people outside the danger zone and residual risk explicitly controlled.

## Independent safety boundary

LinuxCNC, ordinary HAL/FPGA logic, HMI status, and non-safety networks may request, display, or diagnose ordinary machine state. They do not acquire personnel-safety authority because an integrity calculation exists elsewhere. Safety authority remains with the independently engineered safety-related control and its physical final elements/proof chain.

## Required learner output

For each safety function, produce:

`SF-ID | hazardous event | safe-state PROP | selected method+edition | target derivation evidence | subsystem architecture | reliability evidence | diagnostic evidence | CCF controls | systematic controls | physical final element/witness | achieved-integrity evidence | validation cases | UNKNOWN/FIND items`

Any blank that is required to support the integrity claim blocks that claim; it does not invite a guessed value.

## Freezes

- **PLr / required SIL COMES FROM THE SAFETY FUNCTION'S RISK/SRS CONTEXT, NOT FROM TOPOLOGY.**
- **CATEGORY / ARCHITECTURE != ACHIEVED PL OR SIL.**
- **CERTIFIED COMPONENT CAPABILITY != COMPLETE SAFETY-FUNCTION INTEGRITY.**
- **HIGH-RATED LOGIC CANNOT RESCUE AN UNPROVED SHARED FINAL ELEMENT.**
- **NUMERICAL TOOL OUTPUT != VALIDATION.**
- **DIAGNOSTIC COVERAGE CLAIM != PHYSICAL SAFE-STATE PROOF.**
- **STANDARD METHOD SELECTED != EDITION/APPLICABILITY ESTABLISHED.**
- **ORDINARY LINUXCNC/FPGA CONTROL != PERSONNEL-SAFETY AUTHORITY.**

## Next methodology step

Run a formal adversarial 2520 assessment spanning hazard derivation -> safety-function/SRS -> composition -> fault/diagnostic analysis -> architecture/CCF -> integrity-method gate. The assessment must penalize invented targets/numbers and component-rating substitution, and must include at least one shared-final-element and one systematic/specification-fault trap.
