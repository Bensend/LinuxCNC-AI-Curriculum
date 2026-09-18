# Final-element feedback vs physical-hazard witness trace

Date: 2026-09-18
Active level: 4000 safety course

## Question

After a safety controller commands hazardous power off, what evidence is actually available that the final element changed state, and what additional evidence is needed before claiming the physical hazard has ceased?

This trace closes a recurring ambiguity in E-stop, guard-unlock, fieldbus-recovery, and linked-machine studies: **a commanded safe output and an EDM/auxiliary-contact witness are not the same thing as observing the hazardous physical quantity.**

## Evidence

### Rockwell CENTERLINE / GuardLogix contactor implementation

**DOC-CONFIRMED.** Rockwell Automation publication `MCC-AT007D-EN-P` (August 2023) describes safety contactors as final control devices. A GuardLogix CROUT instruction monitors N/C auxiliary feedback contacts from the contactors. With the contacts wired in series, the safety input ON state means all monitored contactors are open; OFF means at least one remains closed. The same publication treats hardwired STO of a PowerFlex 525 as another final control device and uses redundant, pulse-tested safety outputs/interposing relays for that path.

Source: Rockwell Automation, *CENTERLINE Low Voltage Motor Control Centers Functional Safety*, MCC-AT007D-EN-P, August 2023.

### Rockwell PowerFlex 7000 STO implementation

**DOC-CONFIRMED.** Rockwell publication `SAFETY-AT170A-EN-P` describes GuardLogix de-energizing safety outputs, safety relays SR1/SR2, and the PowerFlex 7000 STO path. N/C contacts from SR1/SR2 return to safety inputs as feedback; reset is permitted only when the feedback monitoring contacts are in the safe state. This is a concrete command -> intermediate final-element feedback -> reset-permission chain.

Source: Rockwell Automation, *Actuator Subsystems -- Stop Cat. 0 or 1 via an Integrated Safety Controller and a PowerFlex 7000 Drive with Hardwired Safe Torque Off Safety Function*, SAFETY-AT170A-EN-P, July 2019.

### Rockwell safe-monitored full-body access

**DOC-CONFIRMED.** Rockwell's functional-safety application catalog describes `SAFETY-AT167A-EN-P` as a system providing safe, monitored, full-body access only when hazardous motion has ceased. The implementation uses a 442G multifunctional access box, 440C-CR30 configurable safety relay, and two 100S safety contactors. A related Guardmaster GLP implementation monitors two proximity sensors to determine hazardous-motion speed and the MAB state, and does not unlock the MAB when a detected fault prevents the required safe-motion condition from being established.

This is materially different from EDM alone: the access decision includes a witness of the hazardous physical variable (motion/speed), not merely an auxiliary contact that reports a switching device's state.

Sources: Rockwell Automation functional-safety document catalog; SAFETY-AT167A-EN-P, June 2019.

### Pilz independent standstill-monitor evidence

**DOC-CONFIRMED.** Pilz documents PNOZ s30 as monitoring speed and standstill and states that safe standstill monitoring can be used to make a danger zone accessible. Pilz also documents safe operating stop as continued monitoring of standstill/position, with departure from the permitted range causing an error reaction.

Source: Pilz, *Safe speed monitoring with PNOZ s30*.

## Evidence-layer model

For curriculum purposes, preserve these layers independently:

1. **Safety command** — safety logic requests the output safe state.
2. **Safety-output state** — safety I/O reports the commanded/de-energized state.
3. **Intermediate/final-element state** — EDM, N/C mirror/auxiliary contacts, STO status, valve-spool feedback, etc. report a device state.
4. **Physical-hazard witness** — safe speed/standstill, pressure, position, retained-load state, voltage/energy measurement, or another hazard-specific quantity is actually monitored where the safety function requires it.
5. **Access/restart authority** — independent safety logic determines whether the required evidence set is valid for the intended action.
6. **Ordinary command** — LinuxCNC/HAL/normal FPGA supplies fresh production intent only after safety authority exists.

## Frozen rules

**SAFETY OUTPUT OFF != CONTACTOR OPEN != MOTOR/AXIS STATIONARY != HAZARDOUS ENERGY ABSENT != SAFE ACCESS.**

**EDM VALID != PHYSICAL HAZARD PROVED ABSENT.**

**STO ACTIVE != GRAVITY LOAD RETAINED.**

**ZERO-SPEED/STANDSTILL WITNESS != ALL ENERGY SOURCES SAFE.** A motion witness says something about motion; it does not by itself establish hydraulic pressure, accumulator state, suspended-load retention, electrical isolation, pneumatic energy, thermal hazards, or other machine-specific hazards.

**PHYSICAL HAZARD WITNESS VALID != FRESH ORDINARY START.** Safe-entry or standstill evidence does not authorize production motion after reset/rearm.

## Why EDM still matters

The distinction above must not be misread as downgrading EDM. EDM is valuable because it can expose welded/stuck contactors and other failures in the commanded energy-removal chain before restart. The correct lesson is that **EDM proves the monitored switching-state proposition, not every downstream physical proposition.**

For a simple motor hazard, a validated architecture may combine contactor/STO diagnostics with safe standstill monitoring. For a gravity-loaded hydraulic press, additional retaining/load-holding and hydraulic evidence may be required. The exact OpenPressBrake hydraulic truth table remains **UNKNOWN** until machine-specific design evidence exists.

## Adversarial commissioning cases

A professional commissioning/validation plan should challenge at least these propositions where applicable:

- Safety output de-energizes but one contactor remains closed: EDM must prevent restoration of safety authority.
- Contactor auxiliary contact indicates open but hazardous motion continues because of inertia or another energy source: access must not be inferred from EDM alone where safe standstill is required.
- Safe-speed/standstill witness is lost or implausible while contactor feedback remains healthy: do not substitute EDM for the missing physical witness.
- Motion is at standstill but a gravity load is not proven retained: do not infer safe bodily entry beneath the load.
- STO is active but a mechanically driven/coasting hazard has not reached the required safe state: STO status alone is insufficient for access.
- Safety communications recover and all I/O appears healthy after replacement: require the identity/configuration/functional-test chain before restoring authority; do not treat network health as physical validation.
- LinuxCNC START/JOG/ENABLE remains asserted throughout a safety demand: restoration of the safety evidence chain must not reinterpret that stale ordinary command as fresh intent.

## Minimum-safe-to-operate consequence

If the safety function depends on proving that a physical hazard has ceased before personnel can enter, but the design can only observe a controller bit or an intermediate switching contact and cannot establish the required physical condition by the validated architecture, **do not operate with personnel exposed to that hazard**. Experimental operation must remain isolated/remote with people outside the danger zone until the evidence gap is resolved.

## LinuxCNC / ordinary FPGA boundary

LinuxCNC and a normal FPGA may display contactor feedback, standstill state, STO diagnostics, and safety permissives. They may use those diagnostics for sequencing and fault reporting. They must not become the sole personnel-safety authority that decides a hazard is physically safe merely because ordinary-control observations look plausible.

## Open questions / next evidence target

1. Find a professional same-machine implementation exposing `safety output -> contactor/STO/valve feedback -> direct physical hazard witness -> access/rearm -> separate ordinary START` in one trace.
2. Prefer an implementation that injects a disagreement between the final-element witness and physical-hazard witness, because this tests whether the architecture fails safe rather than merely documenting the happy path.
3. Continue seeking a hydraulic/gravity-axis implementation where valve/load-retention feedback and actual load motion/position are both visible. Do not invent pressure thresholds, valve truth tables, stopping distance, PL/SIL, or diagnostic coverage.

## Compute decision

No simulation or build is justified by this question. Authoritative documentation establishes the conceptual distinction. No GitHub-hosted or self-hosted compute was consumed for this study.
