# 25E0 — Field-Power Recovery, Brownout Ordering, and Machine-Class Transfer

Date: 2026-09-22
Status: learner-facing 4000 safety-course method

## Learning objective

Handle the narrower but dangerous case where safety logic remains alive while field-device or safety-I/O power disappears and later returns. Separate communication/configuration recovery from reacquisition of physical witnesses, then transfer the same evidence-freshness method across different machine physics.

## Evidence ledger

### DOC-CONFIRMED — field-power loss is a distinct safety-I/O condition

Rockwell Automation, *1756 ControlLogix Digital Safety I/O Modules User Manual* (1756-UM013B-EN-P), documents Field Power Loss Detection. Loss of field-side power faults the module points, turns test outputs off, reports `FieldPowerOff`/fault diagnostics, and changes indicators. When field power is restored and any configured error-latch time has expired, the diagnostic clears; the manual notes recovery can require additional time.

Source: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/1756-um013_-en-p.pdf

Claim class: `DOC-CONFIRMED`.

Important boundary: this proves module-level detection/recovery behavior. It does **not** prove that every machine-level physical proposition represented by those channels remained true during the outage or became fresh merely because the module recovered.

### DOC-CONFIRMED — safety-input alarm recovery requires the input to return to its safe state

Rockwell Armor PowerFlex documentation states that when a safety-input error is detected, safety input data remains off. Recovery requires removal of the error cause and placing the affected safety input(s) into the safe state; only then can the alarm clear according to the latch behavior.

Source: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/35-um001_-en-p.pdf

Claim class: `DOC-CONFIRMED`.

This is useful evidence that restored electronics/power is not necessarily the only recovery condition; field state can have to be reacquired.

### DOC-CONFIRMED — automatic/restart-capable drive behavior is narrower than machine permission

Siemens SINAMICS S120 product documentation describes intelligent startup/restart capability after power interruption while separately providing Safety Integrated functions such as STO, SS1 and SLS. This is evidence that power-recovery behavior can exist in a drive/control domain and must not be mistaken for whole-machine personnel-safety authority.

Source: https://www.siemens.com/fi-fi/products/sinamics/s120-booksize/

Claim class: `DOC-CONFIRMED` for the documented product capabilities; machine-level implications below are `INFERENCE` unless established by the machine design.

## Core distinction

When controller logic stays alive but field power disappears, at least four facts can diverge:

1. controller program/configuration remains present;
2. communications to an I/O module may remain present or later recover;
3. the I/O module's field-side diagnostic may fault and later clear;
4. the **physical thing the channel was intended to witness** may have changed, become unknowable, or require a fresh observation.

Therefore:

**CONTROLLER LOGIC SURVIVED != FIELD WITNESS SURVIVED.**

**FIELD POWER RESTORED != PHYSICAL WITNESS REACQUIRED.**

**I/O DIAGNOSTIC CLEARED != MACHINE-LEVEL SAFETY PROPOSITION FRESH.**

## Required recovery trace

For an affected safety input or output, trace:

`field-power loss -> module/channel fault or invalidity -> safety consequence/inhibition -> power restoration -> module recovery -> field-state reacquisition -> proposition freshness decision -> open-obligation reconciliation -> reset/rearm if eligible -> fresh ordinary demand`

If the device/channel architecture guarantees a particular recovery semantic, cite it. Otherwise use `UNKNOWN`; do not bridge the outage with the pre-outage bit value.

## Multi-domain brownout adversarial case

Assume six domains:

- independent safety-controller logic power;
- safety-I/O/field-device power;
- ordinary FPGA/remote-I/O power;
- LinuxCNC/HMI power;
- drive/actuator control power;
- process/hazardous-energy power.

A brownout drops several domains for different durations. LinuxCNC survives. Safety-controller logic survives. Safety-I/O field power returns first, the drive control supply returns second, ordinary FPGA I/O returns third, while a production-start input remains physically held throughout.

### Bad reconstruction

"The safety PLC never rebooted, all nodes are back online, and the start request is still true, so continue."

### Required reasoning

- safety-controller continuity is useful evidence only for the authority/state that actually remained powered;
- each lost field-power domain invalidates or at least suspends the witnesses dependent on that domain according to its evidence contract;
- communications coming online is not a substitute for reacquiring physical state;
- drive readiness is not a production command;
- a start request held through the event is stale ordinary demand, not fresh post-recovery intent;
- open `FIND-*`, stale `PROP-*`, and pending `VAL-*` obligations remain blocking according to their contracts;
- if recovery ordering can momentarily create contradictory readiness, design the transition so absence of required evidence keeps the system inhibited rather than optimistically reconstructing READY.

### Monotonic-inhibition rule

`INFERENCE` from the evidence and independent-authority model: during asynchronous recovery, adding a recovered domain may add **evidence**, but must not erase an unresolved blocker merely because more devices are online. Progress toward motion permission occurs only through explicit evidence-bearing transitions. Unknown required evidence remains inhibiting.

This is not a universal circuit topology; it is a state/evidence rule to be implemented and validated for the machine.

## Cross-machine transfer

The recovery method transfers; the physical propositions do not.

### Press brake / gravity axis

Possible propositions include guard/protective-device state, independent safety authority, final-element state, hazardous vertical motion stopped, and load-holding/stored hydraulic or gravitational energy conditions. The exact hydraulic safe state, valve truth table, pressure criterion, stopping distance and brake/load-holding proof remain `UNKNOWN` until machine-specific evidence establishes them.

A recovered safety-input channel can prove only its defined input proposition. It does not by itself prove a ram is mechanically/hydraulically safe.

### Spindle machine / mill / lathe

Possible propositions include access safeguard state, torque-producing-energy inhibition, actual spindle standstill where access depends on it, and ordinary spindle/cycle demand freshness. STO or drive-ready state must not be silently substituted for actual standstill if the safety function depends on standstill.

### Plasma / router

Possible propositions include perimeter/access safeguard state, hazardous axis motion inhibition, spindle/router/tool energy state, torch/process enable state, and fresh cycle demand. A plasma process adds machine-specific electrical/process hazards; a router adds spindle/tool hazards. Neither inherits press-brake hydraulic propositions.

### Transfer lesson

The reusable questions are:

1. Which authority was lost?
2. Which witnesses lost their evidence source?
3. Which safety propositions depend on those witnesses?
4. What evidence makes each proposition fresh again?
5. Which reset/rearm is required?
6. Which ordinary demands must be discarded and freshly asserted?

The answers remain machine-specific.

## Human-factors rule

Recovery indications should say what is actually missing: e.g. `FIELD SAFETY POWER LOST`, `WAITING FOR GUARD STATE`, `SAFETY RESET REQUIRED`, or `READY — NEW CYCLE START REQUIRED`. A generic red light followed by unexplained automatic recovery trains operators to hold controls, repeatedly reset, or bypass troublesome devices. Make correct recovery easier to understand than defeat.

## Failure-path review

- Controller alive + field input power dead: do not preserve the old input as truth.
- Field power restored + diagnostic clears: reacquire any physical witness required by the proposition.
- Drive/control supply recovers early: keep production permission separate from drive readiness.
- LinuxCNC survives with held Cycle Start: demand remains stale through safety recovery.
- Field device recovers into an unexpected state: remain inhibited and disposition the discrepancy.
- Evidence source cannot distinguish pre-/post-outage state: mark required proposition `UNKNOWN` until an appropriate fresh witness/test resolves it.

## New freezes

- **CONTROLLER LOGIC SURVIVED != FIELD WITNESS SURVIVED.**
- **COMMUNICATION RESTORED != PHYSICAL WITNESS REACQUIRED.**
- **FIELD POWER RESTORED != MACHINE-LEVEL SAFETY PROPOSITION FRESH.**
- **I/O DIAGNOSTIC CLEARED != RETURN-TO-SERVICE ACCEPTANCE.**
- **MORE DOMAINS ONLINE != FEWER SAFETY BLOCKERS unless required evidence was actually gained.**
- **RECOVERY ORDER != AUTHORITY ORDER.**
- **TRANSFERABLE SAFETY METHOD != TRANSFERABLE MACHINE PHYSICS.**

## Reusable learner artifact

Use `POWER_RECOVERY_TRANSITION_WORKSHEET.md` for whole-machine, partial-domain, field-power, and brownout recovery analysis.

## Compute decision

No executable compute is justified for these generic propositions. Manufacturer documentation resolves the field-power behavior needed for this lesson. A future lab is justified only for a concrete hardware/configuration question whose recovery semantics remain unresolved after source tracing; such compute must use `[self-hosted, openpressbrake]` and never a GitHub-hosted runner.
