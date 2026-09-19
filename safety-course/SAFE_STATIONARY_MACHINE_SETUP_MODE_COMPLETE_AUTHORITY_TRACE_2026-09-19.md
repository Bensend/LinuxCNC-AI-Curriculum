# Safe Stationary Machine — setup-mode complete authority trace

Date: 2026-09-19

## Question

Can a professional implementation close more of the Lane-B chain than isolated mode-selector and enabling-switch documentation: deliberate setup selection -> normal safeguard suspension -> substitute reduced-risk safety function -> enabling device -> separate motion command -> monitored physical motion -> stop on enabling loss/overtravel -> controlled return toward normal safeguarding?

## Evidence

### SICK Safe Stationary Machine example application

**DOC-CONFIRMED.** SICK's `Safe Stationary Machine` operating instructions describe an integrated application in which hazardous-area access is normally permitted only after the Flexi Soft safety controller detects machine standstill, while a safety locking device keeps the door locked during motion.

For setup/maintenance, the same application explicitly allows personnel presence in the hazardous area only under a substitute reduced-risk architecture: machine speed is lowered; a three-position enabling switch is required; enabling is active only in position 2; positions 1 and 3 cause the safety controller to command the drive to stop; and the actual command that starts machine movement must come from an **additional control switch**. Following a valid start sequence, Drive Monitor FX3-MOC0 monitors actual machine speed and the safety controller switches the drive off if measured speed exceeds the permissible configured speed.

This is materially stronger than treating the enabling switch as the motion command or treating ordinary commanded speed as proof of reduced-risk motion.

Source: SICK, `Safe Stationary Machine`, operating instructions 8020304/2017-07-26, section 4.1.3, publicly indexed PDF.

### SICK Guide for Safe Machinery

**DOC-CONFIRMED.** SICK's current/public safety guide independently states that setup/maintenance work with safeguards disabled requires other risk-reducing measures such as reduced force/speed; an enabling device alone must not initiate machine start; movement is permitted only while the enabling device remains actuated; three-position behavior is Off/Enable/Off; return from position 3 to position 2 must not reactivate enabling authority; and the means of returning the machine to the normal operating mode must be outside the hazard zone so the hazard zone can be checked clear.

The guide also states that if multiple people are in the hazard zone while protective devices are disabled, each person must have an enabling device and all selected devices must be concurrently operated before hazardous functions can be initiated.

Source: SICK, `Guide for Safe Machinery`, enabling-devices section, publicly indexed PDF.

### Independent device evidence

**DOC-CONFIRMED.** SICK E100 and Pilz PITenable product documentation independently describe three-position Off-On-Off enabling behavior intended for setup/maintenance when normal protective devices are suspended. Pilz states that release or full depression invokes the protective function and brings the machine to standstill.

## Authority decomposition

The evidence supports the following non-equivalences:

`SETUP MODE SELECTED != SAFEGUARD SUSPENSION AUTHORIZED`

`SAFEGUARD SUSPENDED != SUBSTITUTE SAFETY FUNCTION VALID`

`ENABLING DEVICE POSITION 2 != MOTION START COMMAND`

`MOTION COMMAND PRESENT != ACTUAL SPEED WITHIN SAFE SETUP LIMIT`

`COMMANDED LOW SPEED != SAFELY MONITORED LOW SPEED`

`ENABLING DEVICE RELEASED/FULLY PRESSED != ORDINARY CONTROL MAY KEEP MOTION GOING`

`SETUP WORK COMPLETE != HAZARD ZONE CLEAR != NORMAL SAFEGUARD RESTORED != PRODUCTION START AUTHORITY`

The SICK implementation is especially useful because the reduced-risk claim has a **physical motion witness**: Drive Monitor FX3-MOC0 monitors speed rather than trusting only the normal motion command.

## Failure-path trace

1. Normal condition: access is interlocked against machine motion; standstill is detected before access can be allowed.
2. Setup/maintenance requires an explicit substitute safety architecture rather than merely ignoring the guard.
3. Enabling position 2 supplies only enabling authority.
4. A separate control action requests motion.
5. Actual speed is safety-monitored.
6. Overspeed causes the safety controller to switch off the drive.
7. Enabling release or overtravel removes enabling authority and commands a stop.
8. A position-3 -> position-2 transition must not silently recreate enabling authority.
9. Return toward normal operation requires restoration of the normal safeguarding regime and hazard-zone-clear reasoning; it is not established merely by releasing the enabling device.

## Human-factors consequences

The architecture makes the safer path operationally usable: the person who must observe setup motion can remain near the process while reduced speed is independently monitored and the handheld device fails toward stop both on release and panic squeeze. The additional motion control prevents an ergonomically convenient but unsafe interpretation in which simply gripping the enabling device starts motion.

For multi-person entry, one shared enabling device is not an acceptable proxy for everyone being protected; the SICK guide explicitly calls for an enabling device per person when multiple people are inside with protective devices disabled.

## Boundary to LinuxCNC / ordinary FPGA

**INFERENCE, deliberately conservative.** A LinuxCNC command, HAL pin, GUI jog button, or ordinary FPGA signal may provide the *separate motion request* in an architecture of this shape, but it must not become the sole authority for the safety-side mode selection, enabling-device validity, safely monitored speed, guard suspension, or protective stop. The professional example places those safety functions in a dedicated safety controller/safe motion monitor.

No claim is made that SICK's particular architecture, speed threshold, PL/SIL, stop category, timing, or hardware must be copied into OpenPressBrake.

## What remains UNKNOWN

- A complete press-brake-specific implementation of this exact setup-mode chain.
- OpenPressBrake-specific safe setup speed/force, stopping performance, hydraulic final-element behavior, PL/SIL/category/DC/CCF, or mode policy.
- The complete SICK example's production-mode reset/start sequence after setup exit is not established by the excerpt used here.
- Whether a press brake may safely use reduced-speed setup with a particular safeguard suspended depends on its validated machine-specific risk reduction and cannot be inferred from this stationary-machine example.

## Durable freeze

**MODE SELECTED != SAFEGUARD SUSPENSION AUTHORIZED != SUBSTITUTE SAFETY FUNCTIONS VALID != ENABLING DEVICE VALID != SEPARATE MOTION REQUEST PRESENT != ACTUAL MOTION WITHIN SAFETY LIMIT != PHYSICAL STOP ON LOSS OF AUTHORITY != NORMAL SAFEGUARD RESTORED != PERSONNEL CLEAR != PRODUCTION AUTHORITY.**

Also freeze:

**COMMANDED REDUCED SPEED != SAFELY MONITORED REDUCED SPEED.**

**ENABLING DEVICE MID-POSITION != MACHINE START.**

**ONE PERSON'S ENABLING AUTHORITY != ALL PERSONNEL PROTECTED WHEN MULTIPLE PEOPLE ARE INSIDE.**

## Next evidence target

Prefer a machine-tool, robot-cell, or press/press-brake commissioning/validation document exposing the return half of the chain: setup-mode exit -> substitute-function removal -> normal guard/interlock restoration and proof -> personnel-clear condition -> safety reset/rearm where required -> separate fresh ordinary START. A press-brake example with actual hydraulic final-element behavior is highest value.

No executable lab is justified by this documentary question. No GitHub-hosted or self-hosted compute was used.
