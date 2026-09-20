# Three-Position Enabling Device — Release, Squeeze, Re-entry, and Motion Authority Study

Date: 2026-09-20
Lane: independent safety curriculum Lane B

## Why this study exists

This study is deliberately narrower than the primary lane's current setup-mode/SLS work. It does not choose OpenPressBrake setup speeds, safety performance levels, stop categories, or mode architecture. It isolates the **human-held enabling-device state machine** and the failure/recovery paths that are easy to collapse into a generic `ENABLE=true` bit.

## Evidence labels

- **SOURCE-CONFIRMED** — directly supported by the cited manufacturer material.
- **DOC-CONFIRMED** — directly supported by repository documentation.
- **TEST-CONFIRMED** — demonstrated by a recorded physical or executable test.
- **COMMUNITY-REPORTED** — reported by community material but not independently proved here.
- **INFERENCE** — engineering conclusion drawn from confirmed evidence; not itself a quoted machine fact.
- **UNKNOWN** — requires machine-specific design, measurement, validation, or authoritative evidence.

## Manufacturer evidence

### SICK Safety Guide for the Americas

**SOURCE-CONFIRMED:** SICK describes three-position enabling devices for setup/maintenance when safeguards must be disabled. Position 1 is not operated/off, position 2 is the middle enabling position, and position 3 is beyond the middle/off. The guide states that the enabling function must **not reactivate while returning from position 3 to position 2**. It also states that machine start must not be initiated solely by actuating the enabling device; hazardous movement is permitted only while the enabling device is actuated. Where multiple people are in the hazard zone, each person must have an enabling device and all selected devices must be operated concurrently before hazardous functions can be initiated. Returning the machine to the normal operating mode must be controlled from outside the hazard zone so the zone can be cleared.

Source: SICK, *Safety Guide for the Americas*, enabling-device section, publicly available manufacturer PDF.

### SICK E100

**SOURCE-CONFIRMED:** SICK describes the E100 as a three-stage off-on-off enabling switch for setup/maintenance. Critical movement can be activated only in the middle position, where the required contacts are closed.

Source: SICK E100 product documentation.

### Pilz PITenable

**SOURCE-CONFIRMED:** Pilz describes PITenable as a three-level off-on-off device for work in a danger zone while the protective effect of movable guards is suspended. Middle position enables the function; sudden release or full depression invokes the protective state and brings the machine to a standstill.

Source: Pilz PITenable manufacturer documentation.

## Architecture freezes

1. **ENABLING DEVICE PRESENT != ENABLING DEVICE IN VALID MIDDLE POSITION != MOTION COMMAND PRESENT != HAZARDOUS MOTION AUTHORIZED.**
2. **POSITION 3 -> POSITION 2 != RE-ENABLE.** Returning from panic/full-squeeze must not silently restore enabling authority merely because the actuator passes through the middle position.
3. **POSITION 1 -> POSITION 2 != MACHINE START BY ITSELF.** The enabling device is permission, not the sole start command.
4. **RELEASED ENABLE != ORDINARY SAFEGUARD RESTORED != SETUP MODE EXITED != PRODUCTION AUTHORITY.**
5. **ONE PERSON'S ENABLE VALID != MULTI-PERSON HAZARD-ZONE AUTHORITY** where the application requires multiple enabling devices.
6. **LINUXCNC/HAL `enable=true` != PERSONNEL-SAFETY AUTHORITY.** LinuxCNC or FPGA logic may consume status for ordinary control/diagnostics, but the personnel-safety function must remain in the validated independent safety architecture.

## Failure-path reasoning

### Release path

A valid middle-position enable is intentionally released to position 1.

Expected architecture behavior: the enabling permission is removed and the safety-related motion function responds according to the validated machine design. Re-gripping to the middle position must not be treated as proof that an old ordinary motion command is fresh.

### Panic/full-squeeze path

The operator squeezes through the middle position into position 3.

**SOURCE-CONFIRMED:** manufacturer guidance treats position 3 as an off/protective state. **SOURCE-CONFIRMED:** SICK states that passing back from position 3 through position 2 must not reactivate the enabling function.

This is a distinct acceptance test from simple release. A controller implementation that maps both transitions to a single Boolean can accidentally defeat this property.

### Held ordinary command path

An inch/jog/direction command is held while the enabling device leaves the valid middle state and is then deliberately returned to a valid enabling sequence.

**INFERENCE:** commissioning should challenge whether the architecture can resume hazardous motion from stale ordinary control state. The exact fresh-command requirement is machine/application specific and remains **UNKNOWN** unless established by the chosen architecture and applicable manufacturer/standard evidence.

### Multiple-person path

**SOURCE-CONFIRMED:** SICK states that where multiple people are in the hazard zone while safeguards are disabled, each person must have an enabling device and each selected device must be concurrently operated before hazardous machine functions can be initiated.

Therefore a future OpenPressBrake design must not infer a single-operator rule without a hazard-zone/access decision.

## Question-driven commissioning worksheet

Do not execute this worksheet on OpenPressBrake until the actual safety architecture, operating mode, motion limits, and safe test method are defined.

| Challenge | Required evidence | Current OpenPressBrake status |
|---|---|---|
| Enter setup/maintenance mode | Selected mode is independently established; ordinary production authority is suppressed as designed | UNKNOWN |
| Position 1, no pressure | Enabling permission absent; no hazardous motion from enabling device | UNKNOWN |
| Deliberate 1 -> 2 transition | Enabling permission can become valid, but device transition alone does not start machine | UNKNOWN |
| Release 2 -> 1 during permitted motion | Safety function removes motion authority and physical machine response is witnessed | UNKNOWN |
| Squeeze 2 -> 3 during permitted motion | Safety function removes motion authority and physical machine response is witnessed | UNKNOWN |
| Slowly return 3 -> 2 | No automatic re-enable while passing through middle position | UNKNOWN |
| Return fully to 1, then deliberately establish valid sequence | Recovery follows designed requalification path | UNKNOWN |
| Hold jog/inch command across release/recovery | No unvalidated stale-command restart; required fresh action is proved for actual architecture | UNKNOWN |
| Power loss/restoration with device in 2 | No assumed automatic hazardous-motion authority | UNKNOWN |
| Exit setup mode | Safeguards/mode state requalified before ordinary production authority | UNKNOWN |
| Fresh ordinary production start | Separate production start/restart behavior physically proved | UNKNOWN |
| If multiple people can occupy hazard zone | Each-person enabling/access policy and physical validation established | UNKNOWN |

## OpenPressBrake boundary

No claim is made here that OpenPressBrake requires a handheld enabling device, that a specific guard may be bypassed in setup, or that any particular reduced speed is safe. No stopping time, safe speed, force, hydraulic truth table, PL/SIL/category/DC/CCF, or acceptance threshold is assigned.

A future implementation must preserve the separation:

`mode selection -> safeguard disposition -> enabling-device state machine -> separate motion command -> safety final element -> physical machine response -> setup exit -> safeguard requalification -> ordinary production start`

LinuxCNC and FPGA control may request motion only inside authority granted by the independent safety system; they do not become the personnel-safety authority merely because they can read the enabling-device state.

## Compute decision

No simulation, synthesis, benchmarking, or executable verification was justified for this evidence pass. No GitHub-hosted runner is permitted. A future executable lab, if genuinely needed, must target `[self-hosted, openpressbrake]` only.

## Precise next-work checkpoint

Seek an integrated manufacturer/OEM acceptance procedure that physically challenges **position 2 release**, **position 2 -> 3 panic squeeze**, **3 -> 2 non-reactivation**, and **a held ordinary jog/inch command**, then demonstrates the required deliberate recovery sequence, setup-mode exit, safeguard restoration/requalification, and separate production restart. Prefer a complete machine/robot commissioning sequence over another component catalog. If the primary lane begins that same evidence package, Lane B must switch to another open safety branch before editing overlapping files.