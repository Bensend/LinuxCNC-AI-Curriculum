# 25E0 — Power-Loss Recovery, Three Authorities, and Physical Proof

## Question

After safety-controller or safety-I/O power is lost and restored, what may be inferred from successful device recovery, what must remain durable outside volatile CNC/HMI state, and what physical safety propositions still require proof?

## Evidence trace

### Siemens SINAMICS Safety Integrated

**DOC-CONFIRMED:** SINAMICS S120 Safety Integrated documentation warns that Safety Integrated functions are only active after system power-up completes and identifies startup as a critical operating state requiring the machine to be kept safe during startup. It separately warns against undesirable automatic motor restart after Emergency Stop. Source: Siemens, *SINAMICS S120 Safety Integrated Function Manual*, 06/2019, 6SL3097-5AR00-0BP2.

**DOC-CONFIRMED:** Siemens documents that a Safety fault can be acknowledged by drive-unit POWER ON, but if the cause has not been eliminated the fault is displayed again immediately after power-up. Source: Siemens, *SINAMICS S120 Safety Integrated Function Manual*, 11/2017, 6SL3097-4AR00-0BP7.

**Engineering consequence:** power cycling can be a documented fault-acknowledgement mechanism in a particular product, but **POWER CYCLE ACKNOWLEDGED != FAULT CAUSE CORRECTED != RETURN-TO-SERVICE ACCEPTED**.

### Rockwell GuardLogix / safety instructions

**DOC-CONFIRMED:** Rockwell safety-instruction documentation distinguishes manual and automatic cold-start behavior. In the cited instruction, manual cold start does not energize Output 1 merely when input status becomes valid after controller power is applied or a fault clears; the device must be tested before Output 1 can energize. Automatic behavior exists as a separately configured option and carries an explicit application warning. Source: Rockwell Automation, *Logix 5000 Controller Safety Application Instruction Set*, publication 1756-RM0950-EN-P, September 2025.

**DOC-CONFIRMED:** GuardLogix 5580 documentation states that controller reset can clear the application and that a Safety Partner reset returns the safety partner to out-of-box state. This is evidence that a safety controller's post-reset identity/configuration state itself matters; a successful reboot must not be treated as proof that the pre-reset accepted safety application still exists. Source: Rockwell Automation, *ControlLogix 5580 and GuardLogix 5580 Controllers User Manual*, 1756-UM543R-EN-P, March 2025.

### Pilz restart interlock / safe status

**DOC-CONFIRMED:** Pilz documents a safe restart interlock (SRL) that prevents reset from allowing the safety module to leave STO, while safe status outputs separately expose module state. Source: Pilz, PMCprotego S safe-motion documentation.

This reinforces the separation between reset/status and authority for hazardous motion.

## Three-authority model

A practical learner model uses three distinct authorities. They may exchange information, but they must not silently substitute for one another.

### Authority A — independent safety controller / safety I/O

Owns the implemented safety-related control function appropriate to the actual design: safety input evaluation, safety logic, safe outputs, safe-motion functions, restart interlocks, device diagnostics, and safety-controller configuration identity.

After power restoration it can establish only what its design actually witnesses. Examples include its own configuration/signature state, channel diagnostics, safe-input state, safe-output state, or monitored drive state.

It does **not** automatically own historical maintenance acceptance or every downstream physical proposition.

### Authority B — durable safety / maintenance evidence ledger

Owns lifecycle facts that must survive volatile control-system restart:

- open `FIND-*` records;
- stale or failed `PROP-*` evidence;
- containment restrictions;
- pending `VAL-*` activities;
- unresolved `UNKNOWN`s;
- accepted-baseline evidence identity;
- change/replacement records and revalidation obligations;
- designated acceptance/closure state.

A reboot cannot manufacture closure of these facts. If this authoritative record is expected but unavailable, treat the relevant state as `UNKNOWN` and retain containment appropriate to the hazard analysis.

### Authority C — ordinary LinuxCNC / FPGA / HMI state

May own normal machine sequencing, motion commands, operator presentation, diagnostics aggregation, and ordinary readiness. It may display safety-controller and ledger status.

It must not create personnel-safety authority merely because it restarted cleanly, HAL is loaded, the FPGA communicates, or the HMI says READY.

## Reconstruction versus re-proof exercise

After a total control-cabinet power interruption, classify each item.

| Fact | Recover from durable/configured state? | Requires new physical proof? | Notes |
|---|---|---|---|
| safety project/signature identity | often reconstruct/check | not by itself | product/design-specific mechanism |
| current safety input/output diagnostics | reacquired after valid startup | not by itself | proves only witnessed scope |
| open `FIND-*` / containment | yes, from durable ledger | no to remember it; yes to close if physical proof required | absence of volatile alarm is irrelevant |
| prior accepted stop-time evidence | record can be recovered | only if a trigger made it stale or acceptance procedure requires it | power loss alone does not universally invalidate physical evidence |
| actual present load-holding capability after relevant maintenance/finding | record may say stale | yes when the declared proposition requires physical proof | do not infer from controller health |
| LinuxCNC machine-on/ready state | volatile/reconstructed | not safety proof | normal control only |
| personnel clear of danger zone | not safely inferred from reboot | architecture/procedure-specific fresh witness required before applicable restart | do not assume |

### Adversarial state

Before power loss:

- safety controller has a valid accepted project;
- `FIND-022` remains open for degraded physical stopping behavior;
- `PROP-STOP-007` is stale;
- containment prohibits exposed production pending `VAL-STOP-021`.

After power restoration:

- safety controller boots with the expected signature and no internal diagnostic fault;
- safety inputs are healthy;
- safe outputs are initially inhibited and a reset is available;
- LinuxCNC/HAL/FPGA communication returns;
- HMI normal diagnostics are green.

Correct conclusion: none of those events closes `FIND-022` or refreshes `PROP-STOP-007`. The ledger's containment remains. A reset can be a step in the safety-control sequence only after the actual prerequisites for that design are satisfied; it is not a substitute for `VAL-STOP-021`.

## Extending the physical-proof boundary beyond contactors

### Drive example

**DOC-CONFIRMED:** Siemens explicitly distinguishes Safety Integrated startup/diagnostic state from machine safety during startup and warns that automatic restart must be controlled. A drive can therefore report a valid safety state without proving unrelated mechanical/process propositions such as an independently required stopping-distance baseline, brake holding capability, or personnel-clear condition.

**INFERENCE:** A drive STO/status indication is valuable evidence for the proposition it is designed and validated to witness. It is not universal evidence that rotation has stopped, stored energy is absent, a gravity load is held, or safeguard separation remains valid.

### Brake / load-holding example

**DOC-CONFIRMED:** Pilz safe-motion documentation exposes safe status and restart-interlock functions as distinct functions. This supports teaching that module status and restart permission are not identical propositions.

**INFERENCE:** Where a machine's risk reduction depends on a mechanical brake or load-holding element, controller/drive status can coexist with a separate proposition such as `PROP-HOLD-*`. The witness and acceptance criterion must come from the actual machine architecture and manufacturer/design evidence. Do not invent holding torque, pressure, test load, interval, or acceptable drift.

### Valve / hydraulic example

**INFERENCE / UNKNOWN UNTIL MACHINE-SPECIFIC EVIDENCE:** A safety output commanding a valve safe, or feedback proving a spool/solenoid/contact state, does not automatically prove pressure decay, trapped-energy removal, load holding, or absence of hazardous gravity motion. Those are separate physical/process propositions when the architecture depends on them. Their witnesses and limits remain `UNKNOWN` until established for the machine.

## Recovery sequence method

Use the following evidence-oriented sequence rather than a generic `power on -> reset -> run` assumption:

1. **Contain startup hazard.** Treat safety-system startup as a distinct state; ordinary motion demand remains absent.
2. **Establish safety-controller identity and diagnostic validity** to the extent the actual product/design supports.
3. **Recover durable lifecycle obligations** (`FIND-*`, stale `PROP-*`, containment, pending `VAL-*`).
4. **Reacquire current field witnesses** required by the safety architecture.
5. **Identify stale/failed/unknown physical propositions.** Power restoration does not refresh them merely by occurring.
6. **Perform proposition-specific re-proof** only where required by an actual invalidation trigger, finding, maintenance change, commissioning procedure, or defined proof obligation.
7. **Obtain designated acceptance/closure** for the relevant obligations.
8. **Perform reset/rearm** as its own safety-control step where the design requires it.
9. **Require a fresh ordinary production demand.** Do not resurrect the pre-power-loss motion/start command by convenience.

## Human-factors rule

Recovery should make the safe path simpler than bypass. Present the operator/technician with one explicit reason production remains inhibited: e.g. `OPEN SAFETY OBLIGATION: PROP-STOP-007 requires VAL-STOP-021`. Do not force personnel to infer the cause from a collection of green device LEDs while a hidden maintenance record remains open.

If recovery requires obscure service steps that predictably encourage bypass, redesign the recovery workflow. Diagnostic convenience is not a reason to transfer safety authority into LinuxCNC or the ordinary FPGA.

## Learner freezes

- **POWER RESTORED != SAFETY FUNCTIONS FULLY ACTIVE DURING STARTUP.**
- **POWER CYCLE ACKNOWLEDGED != FAULT CAUSE CORRECTED.**
- **SAFETY CONTROLLER HEALTHY != DURABLE SAFETY OBLIGATIONS CLEARED.**
- **EXPECTED SAFETY SIGNATURE != PHYSICAL PROCESS PROPOSITION FRESH.**
- **RESET AVAILABLE != RESET AUTHORIZED.**
- **SAFE OUTPUT/DRIVE STATUS != EVERY DOWNSTREAM PHYSICAL PROPOSITION PROVED.**
- **LINUXCNC READY != PERSONNEL-SAFETY RETURN-TO-SERVICE ACCEPTANCE.**
- **PRE-POWER-LOSS ORDINARY DEMAND != FRESH POST-RECOVERY DEMAND.**

## Evidence limits

Manufacturer statements above are `DOC-CONFIRMED`. The three-authority model, ledger architecture, and generic recovery sequence are `INFERENCE` intended as a conservative curriculum method. They are not a claim that a particular persistence technology, safety category, PL/SIL, proof interval, reset architecture, hydraulic truth table, or acceptance procedure is universally required.

No executable compute is justified for this lesson. The unresolved questions are authority/evidence boundaries established more directly by professional documentation and machine-specific engineering than by simulation.
