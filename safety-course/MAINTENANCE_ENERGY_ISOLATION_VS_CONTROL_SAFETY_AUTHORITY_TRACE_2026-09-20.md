# Maintenance energy isolation vs control-safety authority trace

Date: 2026-09-20

## Why this branch was selected

The primary press-brake holding/counterbalance-valve post-replacement evidence path is currently source-limited: another bounded search did not locate an authoritative OEM procedure that closes the desired named-valve replacement -> unmasked static retaining challenge -> physical ram/load witness -> quantitative pass/fail -> dynamic stop re-proof -> rearm -> fresh production-start chain. Per `WORK_SELECTION_POLICY.md`, that is a branch-local information-gain stop, not a reason to idle the safety course.

This study rotates to a high-value maintenance boundary that directly affects press brakes, robots, mills, plasma tables, and automated cells: when a safety control/interlock is useful for safeguarding, and when physical hazardous-energy isolation is still required for servicing.

## Authoritative evidence

### OSHA 29 CFR 1910.147

Source: OSHA, *The control of hazardous energy (lockout/tagout)*, 29 CFR 1910.147.
URL: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147

**DOC-CONFIRMED:** An energy-isolating device is a mechanical device that physically prevents transmission or release of energy. OSHA explicitly excludes pushbuttons, selector switches, and other control-circuit devices from that definition.

**DOC-CONFIRMED:** Before covered servicing/maintenance, needed energy-isolating devices are physically operated to isolate the equipment. Potentially hazardous stored/residual energy must then be relieved, disconnected, restrained, or otherwise rendered safe. If stored energy can reaccumulate, isolation verification must continue until the servicing is complete or the reaccumulation possibility is gone.

**DOC-CONFIRMED:** Before work begins, the authorized employee verifies isolation/deenergization. Before release from lockout/tagout, the work area is inspected for operational integrity/nonessential items and employees must be safely positioned or removed.

### OSHA energy-control circuitry guidance

Source: OSHA eTool, *Specific Procedures for Energy Control and Control Circuitry Prohibition*.
URL: https://www.osha.gov/etools/lockout-tagout/hot-topics/energy-control-program/energy-control-circuitry-prohibition

**DOC-CONFIRMED:** Control circuitry does not provide the physical barrier required of an energy-isolating device. Interlocking gates, pushbuttons, and selector switches therefore are not substitutes for physical energy isolation under the covered servicing rule.

**DOC-CONFIRMED:** Verification can include a deliberate start attempt after isolation, because the machine should be incapable of activation, and/or suitable instruments to establish absence of the relevant energy. This is a verification step after isolation, not permission to substitute the normal controls for isolation.

### OSHA slide-lock guidance

Source: OSHA CPL 02-01-043, *Slide-locks — Enforcement Policy, Inspection Procedures and Performance Guidance Criteria*.
URL: https://www.osha.gov/enforcement/directives/cpl-02-01-043

**DOC-CONFIRMED:** OSHA distinguishes control-reliable/interlocked safeguards from hazardous-energy isolation. For covered servicing, control circuits alone do not become energy-isolating devices. Its press-specific guidance also demonstrates a layered physical approach: for qualifying minor press servicing, control measures can be used with physical slide-lock/safety-block measures and other conditions rather than treating an interlock as equivalent to physical restraint.

### OSHA machine-guarding maintenance guidance

Source: OSHA eTool, *Machine Guarding — Additional Safety Considerations*.
URL: https://www.osha.gov/etools/machine-guarding/introduction/safety-considerations

**DOC-CONFIRMED:** OSHA's general maintenance sequence distinguishes stopping the machine, isolating it, locking/tagging, controlling residual energy, and verifying isolation. Return to service separately includes checking that guards/safety devices are in place and functional and that startup will not endanger employees.

## Safety-course authority model

The evidence supports keeping three different concepts separate:

1. **Normal-control stop** — LinuxCNC, HMI, PLC/FPGA or normal machine logic stops commanded operation.
2. **Safety-related control state** — safety relay/PLC, interlock, light curtain, STO, monitored valve logic, etc. prevents or stops hazardous behavior within its validated safety function.
3. **Hazardous-energy isolation / physical restraint** — energy is physically isolated, dissipated, blocked, restrained, or otherwise rendered safe for the service task.

These are complementary engineering layers, not synonyms.

### Durable freezes

**NORMAL STOP COMMAND != SAFETY-RELATED STOP != HAZARDOUS-ENERGY ISOLATION.**

**E-STOP ACTIVE != ELECTRICAL ENERGY ISOLATED != HYDRAULIC PRESSURE DISCHARGED != GRAVITY LOAD PHYSICALLY RESTRAINED.**

**GUARD INTERLOCK OPEN != MACHINE PHYSICALLY ISOLATED FOR COVERED SERVICE.**

**STO ACTIVE != ALL MACHINE ENERGY ISOLATED.** STO can be a valuable drive safety function; it does not by itself establish isolation of every electrical, hydraulic, pneumatic, gravity, thermal, or other energy source relevant to a maintenance task.

**SAFETY PLC/RELAY OUTPUT OFF != ENERGY-ISOLATING DEVICE OPEN/LOCKED.**

**RAM/SLIDE BLOCK INSTALLED != ALL OTHER HAZARDOUS ENERGY CONTROLLED.** A physical block can address a gravity/motion hazard while electrical, hydraulic, pneumatic, or stored-energy hazards may remain task-dependent.

**LOCK/TAG APPLIED != STORED ENERGY RENDERED SAFE != ISOLATION VERIFIED.**

**ISOLATION VERIFIED != MACHINE READY FOR PRODUCTION.** Return-to-service also requires restoration/inspection of guards and safety devices, personnel clearance, appropriate revalidation after the work performed, safety rearm/reset where applicable, and fresh ordinary production initiation.

## Press-brake application

**INFERENCE grounded in the authoritative distinction:** A hydraulic press-brake service procedure should be modeled as a task-specific energy map, not as one global `E_STOPPED` Boolean. Potential energy paths can include mains/control electrical energy, pump/motor energy, hydraulic pressure or pressure reaccumulation, ram/gravity potential energy, accumulator energy where fitted, backgauge/auxiliary motion, and energy introduced by test equipment. Which paths require isolation/restraint depends on the actual machine and task.

For OpenPressBrake curriculum purposes, ordinary LinuxCNC/HAL/FPGA state must not be assigned maintenance-isolation authority merely because it can command outputs off. Likewise, the independent safety controller should not be described as an energy-isolating device unless the physical architecture actually includes and validates such an isolating function; the controller may command or monitor final elements without itself constituting the physical isolation.

## Human-factors consequence

A practical machine should make correct maintenance isolation obvious and easy. Useful design directions include clearly identified lockable isolating devices, accessible bleed/discharge points where the actual hydraulic design requires them, convenient rated mechanical restraint/blocking provisions where gravity motion is a hazard, and visible state/diagnostic information that helps a technician verify rather than guess. These are **design principles**, not claims that any particular OpenPressBrake machine already has those features.

A maintenance mode that is more convenient than correct isolation creates predictable pressure to misuse that mode as a service substitute. The curriculum should explicitly teach that inconvenience in legitimate isolation/blocking is an engineering/human-factors issue to improve, not a reason to transfer isolation authority into ordinary software.

## Adversarial failure cases

- Technician presses E-stop, sees motion cease, and enters beneath a gravity axis without controlling stored/gravity energy.
- Technician opens an interlocked gate and assumes the interlock substitutes for isolation during covered service.
- LinuxCNC/FPGA outputs show OFF but a hydraulic accumulator or trapped pressure remains capable of motion.
- Main disconnect is locked but ram potential energy is not restrained for work beneath the ram.
- Mechanical ram block is fitted but electrical/hydraulic hazards relevant to the actual service task remain energized.
- Maintenance ends and lockout is removed, but a bypassed/removed guard is not restored before production restart.
- Isolation was applied but never verified; a mislabeled disconnect or alternate energy feed remains live.

## What remains UNKNOWN

- OpenPressBrake's exact machine-specific hazardous-energy inventory and isolation points.
- Whether the target machine has accumulators or other pressure-storage devices and their verified discharge behavior.
- Exact rated ram-block geometry/capacity and approved blocking points.
- Which diagnostic/commissioning tasks legitimately require controlled energy under a task-specific procedure.
- Any machine-specific alternative-protection procedure; none should be invented from generic guidance.
- Applicable jurisdiction/site-specific requirements beyond the authoritative examples studied here.

## Curriculum consequence / next work

1. Keep the hydraulic post-replacement acceptance path checkpointed as source-limited unless genuinely new OEM/manifold evidence appears.
2. Build the next safety lesson around **controlled-energy diagnostic/commissioning work vs fully isolated maintenance**: identify professional examples where energy must remain present for measurement, and trace what compensating safeguards, operating modes, enabling devices, physical exclusion, or test procedures preserve personnel safety.
3. Preserve the independent boundary: LinuxCNC/normal FPGA may request, display, log, and diagnose; it does not become the personnel-safety authority merely because doing so is convenient.
4. Do not run a lab for this branch: the unresolved questions are machine-/procedure-specific and are better answered by authoritative documentation before any simulation.
