# SICK Safe Stationary Machine — service-mode reset / enable / start authority trace

Date: 2026-09-20
Active curriculum: 4000 safety course

## Question

Can authoritative manufacturer evidence close part of the current integrated setup/service-mode gap by showing that selecting service mode, resetting safety logic, holding an enabling device, and starting the machine are distinct authorities rather than one generic bypass/enable state?

## Evidence

### SICK Safe Stationary Machine

**DOC-CONFIRMED.** SICK's `Safe Stationary Machine` operating instructions expose a Service-mode reset/restart sequence. The documented reset preconditions include the service operating-mode selector active, E-stop healthy, and a brief Reset input. Following reset, machine start additionally requires the enabling-switch input and a separate brief Start input. The act of starting also resets the Service_SS2 state.

This is valuable because it makes the sequencing explicit:

1. service mode selected;
2. emergency-stop chain healthy;
3. reset deliberately actuated;
4. enabling device actuated;
5. separate start/restart deliberately actuated.

The source therefore does not support collapsing service-mode selection, reset, enabling permission and motion start into one `service_enable` bit.

Source: SICK, *Safe Stationary Machine*, operating instructions, section 5.6.1 Service mode / reset and restart sequence: https://www.sick.com/media/docs/9/59/059/operating_instructions_safe_stationary_machine_en_im0075059.pdf

### SICK Safety Guide — enabling-device boundary

**DOC-CONFIRMED.** SICK's machinery safety guide states that an enabling device must not itself initiate machine start; motion is permitted only while it is actuated. For a three-position device, position 1 is Off, position 2 Enable, and position 3 Off/emergency-stop behavior. The enabling function must not reactivate while returning from position 3 through position 2. The guide also says the means of returning machine control to the operating mode must be outside the hazard zone so that it cannot be reached from inside, and that selection of enabling-device use must be subject to supervisory control.

Source: SICK, *Safety Guide for the Americas*, enabling devices section: https://www.sick.com/media/docs/6/06/606/Special_information_Safety_Guide_For_The_Americas_en_IM0032606.PDF

### SICK Safety Multi-Box training implementation

**DOC-CONFIRMED, TRAINING IMPLEMENTATION.** SICK's Safety Multi-Box training equipment gives an inspectable implementation in operating mode 2 `Setup mode`: the machine runs at reduced speed; protective-door/opto-electronic protection may be overridden for the setup function; enabling motion requires the enabling switch in position 2 together with the S2 inching button. Position 3 invokes the emergency-stop function. Reset of that emergency-stop condition requires release of the enabling switch and operation of Reset.

Source: SICK, *Safety Multi-Box training equipment*, setup-mode/enabling-device table: https://www.sick.com/media/docs/8/58/358/operating_instructions_safety_multi_box_training_equipment_democase_en_im0091358.pdf

## Authority ladder

The combined manufacturer evidence supports this reusable sequence:

**MODE SELECTED -> SAFETY PRECONDITIONS HEALTHY -> RESET ACCEPTED -> ENABLING DEVICE VALID -> SEPARATE JOG/START COMMAND -> BOUNDED SETUP MOTION.**

Freeze the following distinctions:

- **SERVICE/SETUP MODE SELECTED != SAFETY RESET ACCEPTED.**
- **SAFETY RESET ACCEPTED != ENABLING DEVICE VALID.**
- **ENABLING DEVICE VALID != MACHINE START.**
- **ENABLING DEVICE + HELD JOG/INCH COMMAND != ORDINARY PRODUCTION AUTHORITY.**
- **POSITION 3 -> POSITION 2 != RE-ENABLE.**
- **SETUP SAFEGUARD OVERRIDE != UNRESTRICTED SPEED/MOTION AUTHORITY.**
- **RESET AFTER ENABLING-DEVICE STOP != PRODUCTION RESTART.**

## OpenPressBrake / LinuxCNC boundary

**INFERENCE.** A LinuxCNC/FPGA implementation may expose normal-control requests such as requested operating mode, jog/inch command, and diagnostic state, but the personnel-safety authority represented by valid mode selection, enabling-device state, safety reset, safe-speed/stop supervision and final-element safety response must remain in the independent safety architecture. Do not implement the chain as a normal HAL expression such as `setup_mode AND enable AND jog` and call that safety.

## What this does not prove

The searched sources still do **not** provide one single OEM/manufacturer acceptance procedure that deliberately performs all of the following as one witnessed test:

- release position 2 to position 1 while a jog command remains held;
- panic/full-squeeze position 2 to position 3 while a jog command remains held;
- return position 3 through position 2 and prove no reactivation;
- physically challenge SLS/SSM during that same setup sequence;
- exit setup mode and restore/requalify the ordinary safeguard;
- deliberately retain a stale jog/start command through mode exit/rearm;
- prove no production motion until a fresh production START.

Those combined acceptance steps remain **UNKNOWN** rather than inferred as manufacturer-tested behavior.

## Information-gain decision

This materially closes the architecture/sequencing part of the integrated setup-mode gap. More generic enabling-switch catalog searching is now low value. A future source should reopen this branch only if it adds the missing *physical acceptance sequence*, particularly held-command release/squeeze tests plus setup exit/safeguard restoration/fresh production restart.

No machine-specific speed, stopping time, safety distance, hydraulic behavior, PL/SIL, or timeout value is inferred from these sources.

## Compute

No simulation/build/test compute was required. No GitHub-hosted runner was used.
