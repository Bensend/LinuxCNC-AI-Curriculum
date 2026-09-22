# 2520 — Transfer Exercise: Guarded Spindle / Robot-Tending Cell

Date: 2026-09-22
Status: learner transfer exercise; machine-specific physical values intentionally unresolved

## Purpose

Stress-test the full 2520 hazard-to-release method on a machine class materially different from the gravity/fluid-power and press-brake examples. This is a design exercise, not evidence that any real machine satisfies a PL/SIL target or stopping-distance requirement.

## Scenario

A guarded automated cell contains:

- an electrically driven rotating spindle/tool;
- a robot or transfer mechanism that loads/unloads the work area;
- pneumatic workholding/tooling;
- a full-body access gate with interlocking;
- an emergency-stop function;
- setup/manual operation requiring restricted access;
- ordinary LinuxCNC/FPGA control for production sequencing and diagnostics;
- an independent safety-related control path for personnel protection.

Known only at the conceptual level: the spindle can retain kinetic energy after torque is removed; pneumatics may retain stored energy; the robot/transfer mechanism may have hazardous motion; access can place a person inside the safeguarded space.

The actual stopping time, run-down time, guard-locking need, safe distance, pneumatic exhaust behavior, workholding behavior, drive safety capability, robot safety capability, diagnostic coverage, required PL/SIL, proof interval and final-element architecture are **UNKNOWN** until established by applicable design evidence and measurement.

## Learner task

Produce a compact machine safety design package using this chain:

`boundary -> HZ -> PROP -> SF/SRS -> FLT -> ARCH/DEP/CCF -> integrity gate -> VAL/EVID -> commissioning/release -> change/revalidation`

### 1. Boundaries and hazardous events

At minimum distinguish production, access, setup/manual intervention, fault recovery, maintenance and power-recovery lifecycle states.

Do not write “machine dangerous” as the hazard. State hazardous events such as access while spindle kinetic energy remains, unexpected robot/transfer motion with personnel exposed, or release/motion caused by stored pneumatic energy.

### 2. Physical propositions

For each safety function state the physical proposition actually needed. Examples of proposition form—not answers—include:

- hazardous spindle motion/energy is below the defined acceptance condition before access that depends on standstill;
- hazardous robot/transfer motion is prevented while a person may occupy the protected space;
- hazardous pneumatic motion/release is prevented or controlled to the defined safe condition;
- a restart cannot occur merely because the gate is closed or safety reset/reintegration completes.

If the acceptance condition is not supplied, mark it `UNKNOWN`; do not replace it with “STO active”, “drive ready”, “zero command”, “LinuxCNC idle”, or “network healthy”.

### 3. Safety-function composition

Analyze simultaneous gate-open, E-stop, setup/enabling, process-fault and recovery demands. Identify shared final elements and shared dependencies. Do not assume separate initiators imply independent energy-removal paths.

### 4. Fault and diagnostic analysis

Include at least:

- one input/wiring fault;
- one final-element fault;
- one latent fault;
- one common-cause/shared-dependency fault;
- one mechanical/physical fault not diagnosable by ordinary electronic channel agreement;
- one stale/unavailable evidence case after power or communication interruption.

For each diagnostic, state what fault hypothesis it detects and what physical proposition remains unproved.

### 5. Architecture/integrity gate

Trace shared power, network infrastructure, mechanical mounting, configuration, final elements and physical witnesses. Select the applicable integrity method/edition only from the actual project context. Derive the required target from risk/SRS evidence; if those facts are absent, the target remains `UNKNOWN`.

A high-rated drive, robot controller, safety PLC or relay does not automatically establish the achieved integrity of the complete machine safety function.

### 6. Verification/validation and physical proof

Derive tests from the SRS and fault analysis. Separate:

- design verification;
- functional validation;
- diagnostic/fault validation;
- physical-process proof;
- recovery/restart validation;
- maintenance/change revalidation.

Identify which cases require actual measurement or machine-specific evidence. Do not fabricate a stopping time, safe distance, residual pressure, run-down threshold or acceptance result.

### 7. Commissioning and change

Define the release baseline and configuration identity. Include temporary commissioning measures and their removal. Then analyze a change where the spindle drive is replaced by a newer model that advertises equivalent or better safety capability. Determine what must be impact-analyzed and revalidated; “better-rated component” is not itself a release argument.

## Adversarial prompts

1. The guard is closed, both interlock channels agree, the safety network is healthy and the spindle drive reports STO. Does that prove the spindle is physically stopped? Explain the evidence needed.
2. Safety communications recover after a field-power interruption while Cycle Start remained held. What authority, if any, does that held demand have?
3. Two independent guard channels share one moved actuator/bracket. What does channel agreement prove?
4. The pneumatic valve output is de-energized and feedback says the valve changed state. What does that prove about trapped pressure or mechanical workholding?
5. A maintenance technician replaces a guard switch with the same part number but adjusts its actuator position. Which prior evidence can remain valid and which proposition must be physically re-proved?
6. LinuxCNC observes every safety status and inhibits its own motion commands. Why is that useful but still not sufficient to make LinuxCNC the personnel-safety authority?

## Acceptance for the exercise

A strong answer exposes missing physical facts, maintains the independent safety boundary, traces shared dependencies and final elements, separates status from physical proof, separates reset/rearm from fresh production demand, and derives validation/change scope from the SRS and affected propositions.

A weak answer invents numbers, assigns PL/SIL from topology or component labels, treats STO/output bits as physical standstill proof, treats two channels as automatically independent, or lets LinuxCNC/normal FPGA logic become the sole personnel-protection authority.

## Evidence status

This exercise is `INFERENCE`/curriculum design until executed by an information-separated learner. It intentionally contains no hidden answer key and therefore does not contaminate a future blind evaluation if the future challenge uses a different scenario.
