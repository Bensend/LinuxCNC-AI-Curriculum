# Hazardous-energy isolation, verification, reaccumulation, and test/positioning study — 2026-09-20

## Lane and selection boundary

This is independent Lane-B safety-curriculum work. At selection time the primary lane's newest durable work was `PRESS_BRAKE_HYDRAULIC_POST_SERVICE_ACCEPTANCE_LADDER_AND_NEGATIVE_EVIDENCE_2026-09-20.md`, focused on named hydraulic component replacement, retaining-function proof, stopping-performance proof, and post-service return-to-production evidence. This study deliberately does **not** advance that component-specific hydraulic package. It instead closes a cross-cutting maintenance boundary: how hazardous energy is isolated and verified before intrusive work, how reaccumulation is handled, and how temporary re-energization for test/positioning differs from return to production.

## Question

What must the curriculum require before calling a machine safe for maintenance when ordinary control, safety logic, and physical energy isolation are distinct layers?

## Evidence provenance

### SOURCE-CONFIRMED — OSHA 29 CFR 1910.147

OSHA 29 CFR 1910.147 applies to servicing/maintenance where unexpected energization/startup or release of stored energy can injure personnel. The regulation requires an energy-control program and procedures that identify shutdown, isolation, blocking/securing, lock/tag application/removal, and requirements for testing the machine/equipment to verify the effectiveness of energy-control measures.

Source: OSHA, 29 CFR 1910.147, Control of Hazardous Energy (Lockout/Tagout).
https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147

### SOURCE-CONFIRMED — stored/residual energy and reaccumulation

After lockout/tagout is applied, potentially hazardous stored or residual energy must be relieved, disconnected, restrained, or otherwise rendered safe. If hazardous energy can reaccumulate, verification of isolation must continue until servicing is complete or the reaccumulation possibility no longer exists. Before work begins, the authorized employee must verify isolation and de-energization.

This creates an important curriculum distinction: a one-time `zero` indication is not automatically a durable safe state when accumulators, gravity, capacitors, pressure, springs, thermal sources, or externally supplied energy can reappear.

Source: OSHA 29 CFR 1910.147(d)(5)-(6).
https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147

### SOURCE-CONFIRMED — verification may require more than trying START

OSHA's energy-control guidance states that verification may include a deliberate attempt to operate normal controls, but monitoring instruments may also be necessary and a combination of verification methods may be required to establish that all potentially hazardous energy has been isolated. Hydraulic/pneumatic systems may require bleed valves; stored energy that can reaccumulate requires continued verification.

Source: OSHA Lockout/Tagout eTool, Energy Control Program — control-circuitry prohibition / verification guidance.
https://www.osha.gov/etools/lockout-tagout/hot-topics/energy-control-program/energy-control-circuitry-prohibition

### SOURCE-CONFIRMED — control circuits are not energy-isolating devices

The OSHA framework distinguishes an energy-isolating device from ordinary control circuitry. The maintenance claim therefore cannot be reduced to LinuxCNC disabled, FPGA outputs false, E-stop active, STO requested, or a software state that says `safe`. Those may be useful layers or diagnostics, but they do not replace required physical energy isolation/control for maintenance exposure.

Source: OSHA 29 CFR 1910.147 definitions and application sequence.
https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147

### SOURCE-CONFIRMED — test/positioning is a controlled exception sequence

When lockout/tagout must temporarily be removed and equipment energized for testing or positioning, OSHA defines a controlled sequence: clear tools/materials, remove employees from the machine/equipment area, remove lockout/tagout as specified, energize and perform the test/positioning, then de-energize and reapply energy-control measures before continuing service/maintenance.

This is not equivalent to production release and must not be treated as a shortcut around the maintenance isolation boundary.

Source: OSHA 29 CFR 1910.147(f)(1).
https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147

### SOURCE-CONFIRMED — restoration to service requires area/personnel checks

Before lockout/tagout is removed and energy is restored, OSHA requires inspection for operational integrity/nonessential items and checks that employees are safely positioned or removed; affected employees are notified after device removal and before startup. The regulation also has specific requirements for removal of another person's lock and for group/shift-transfer continuity.

Source: OSHA 29 CFR 1910.147(e), (f)(3), and (f)(4).
https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147

## Architecture model

The curriculum shall keep these states distinct:

`ORDINARY CONTROL STOPPED`

`!= SAFETY FUNCTION DEMANDING STOP`

`!= ENERGY-ISOLATING DEVICES PHYSICALLY OPERATED`

`!= LOCKOUT/TAGOUT APPLIED`

`!= STORED/RESIDUAL ENERGY CONTROLLED`

`!= ISOLATION/DE-ENERGIZATION VERIFIED`

`!= REACCUMULATION EXCLUDED OR CONTINUOUSLY CONTROLLED`

`!= INTRUSIVE MAINTENANCE AUTHORIZED`

And on the way back:

`MAINTENANCE COMPLETE`

`!= TOOLS/PERSONNEL CLEAR`

`!= LOCKOUT RELEASE AUTHORIZED`

`!= ENERGY RESTORED`

`!= SAFETY FUNCTIONS REVALIDATED`

`!= SAFETY REARMED`

`!= FRESH ORDINARY PRODUCTION START AUTHORIZED`

## Energy inventory worksheet

A machine-specific procedure should identify, without assuming OpenPressBrake facts:

| Energy/hazard family | Possible isolating/control method | Physical verification question | Reaccumulation question |
|---|---|---|---|
| incoming electrical power | disconnect/breaker or other qualified isolating device | is the relevant circuit actually de-energized by an appropriate verification method? | can another source/backfeed restore energy? |
| DC bus/capacitive energy | discharge/wait/verified measurement as designed | has hazardous stored voltage actually decayed? | can it recharge from another connected source? |
| hydraulic pressure | isolation plus bleed/restraint/blocking as architecture requires | is hazardous pressure/load energy physically controlled? | can accumulator, gravity, thermal expansion, leakage path, or pump source rebuild pressure? |
| pneumatic pressure | isolation/bleed/restraint as architecture requires | is downstream hazardous pressure actually removed or restrained? | can trapped branches or another source repressurize? |
| gravity/elevated member | rated physical block/pin/support/restraint where required | is the load physically supported against hazardous movement? | can settling, leakage, support removal, or another actuator reintroduce motion? |
| springs/flywheels/mechanical stored energy | discharge, restrain, stop, block | has the stored mechanical energy reached a nonhazardous state? | can the mechanism wind/reload/restart? |
| external/auxiliary equipment | separate isolation/control as applicable | are all cross-fed energy paths controlled? | can another machine/system re-energize this machine? |

The entries above are categories/questions, not OpenPressBrake machine facts or acceptance values.

## LinuxCNC / FPGA boundary

LinuxCNC, HAL, the ordinary FPGA/controller, and the HMI may:

- request orderly shutdown before isolation;
- display diagnostic energy-state information;
- inhibit ordinary commands;
- assist commissioning records;
- expose whether a stale ordinary command exists after restoration.

They must not be promoted into the sole personnel-safety authority for intrusive maintenance merely because software reports disabled outputs. A control-system stop can fail independently of the physical isolation state, and a physically isolated machine can still contain stored or gravitational energy.

## Failure-path challenges

### 1. E-stop pressed, main energy still connected

Expected lesson: E-stop is not maintenance isolation. Determine the actual hazardous-energy sources and isolating devices.

### 2. Main electrical disconnect locked, hydraulic accumulator or gravity load remains

Expected lesson: electrical isolation does not prove hydraulic/mechanical stored energy safe. Stored energy must be relieved, restrained, blocked, or otherwise controlled and verified as required by the machine-specific procedure.

### 3. Pressure gauge initially reads safe, then pressure reaccumulates

Expected lesson: initial verification is not sufficient when hazardous reaccumulation is possible. The procedure needs continued verification/control until the hazard can no longer reaccumulate or servicing ends.

### 4. Try-start test fails to move machine, but another energy path exists

Expected lesson: a failed ordinary START attempt is useful evidence but may not prove every energy source isolated. Verification method must match the actual energy inventory.

### 5. Machine is temporarily energized to position an axis for service

Expected lesson: treat this as a controlled test/positioning transition, not as production release. Clear personnel/tools as required, energize only for the necessary task, then de-energize and reapply energy control before maintenance continues.

### 6. Safety PLC/relay/HAL says `safe` after restoration

Expected lesson: diagnostic state is not by itself proof that guards, protective devices, final elements, stored-energy controls, and restart logic have been physically revalidated after service.

### 7. Stale LinuxCNC JOG/START/CYCLE survives the maintenance interval

Expected lesson: restoration of energy and safety readiness must not silently convert retained ordinary command state into motion authority. Require a fresh deliberate production command after the safety/maintenance release sequence.

## Commissioning / teaching verification plan

For a real machine, develop a machine-specific hazardous-energy map before any intrusive lab. Then, using approved procedures and qualified personnel as required:

1. identify every hazardous energy source and every isolating device;
2. perform orderly shutdown without creating a new hazard;
3. physically isolate each required source and apply required lockout/tagout controls;
4. control stored/residual/gravitational energy;
5. verify isolation using methods appropriate to each energy family rather than relying on one HMI bit;
6. deliberately consider alternate/backfeed/cross-machine energy paths;
7. determine whether hazardous energy can reaccumulate and, if so, define continued verification/control;
8. separately exercise the approved test/positioning transition if the maintenance procedure actually requires temporary re-energization;
9. after service, inspect machine/work area and personnel-clear state before energy restoration;
10. revalidate affected safety functions/final elements according to the change scope;
11. challenge stale ordinary commands through restoration/rearm;
12. require a separate fresh ordinary production initiation.

No machine-specific voltage, pressure, time, support capacity, bleed-down interval, or acceptance threshold is supplied by this generic study.

## Evidence-state labels

- **SOURCE-CONFIRMED:** OSHA requirements and OSHA interpretive/eTool guidance cited above.
- **DOC-CONFIRMED:** none added for a specific OpenPressBrake machine in this pass.
- **TEST-CONFIRMED:** none; no executable or physical test was justified or performed.
- **COMMUNITY-REPORTED:** none relied upon.
- **INFERENCE:** LinuxCNC/FPGA/HMI roles are architecture conclusions derived from the control-vs-isolation distinction and existing curriculum safety boundary.
- **UNKNOWN:** OpenPressBrake's actual energy inventory, disconnect topology, electrical verification procedure, hydraulic/pneumatic stored-energy topology, gravity support method, accumulator presence, bleed points, reaccumulation behavior, qualified-person requirements, test/positioning procedure, and return-to-service acceptance values.

## Durable freezes

`E-STOP ACTIVE != ENERGY ISOLATED`

`LINUXCNC DISABLED != ENERGY ISOLATED`

`STO ACTIVE != ALL HAZARDOUS ENERGY CONTROLLED`

`DISCONNECT LOCKED != STORED/RESIDUAL/GRAVITATIONAL ENERGY SAFE`

`ZERO/SAFE INDICATION ONCE != REACCUMULATION IMPOSSIBLE`

`TRY-START FAIL != EVERY ENERGY SOURCE VERIFIED ISOLATED`

`TEMPORARY TEST/POSITIONING ENERGIZATION != PRODUCTION RELEASE`

`LOCKOUT REMOVED != SAFETY REVALIDATED != SAFETY REARMED != FRESH PRODUCTION START`

## Compute

No simulation, synthesis, benchmarking, or executable verification was needed. No GitHub-hosted runner was used and no self-hosted runner time was consumed.

## Precise next-work checkpoint

Find an authoritative machine/OEM maintenance implementation that exposes a complete multi-energy procedure, preferably for a hydraulic press/press brake or comparable gravity-loaded industrial machine:

`energy inventory -> electrical isolation -> hydraulic/pneumatic isolation -> stored/gravity energy restraint -> physical verification method(s) -> reaccumulation handling -> temporary test/positioning transition if needed -> re-isolation -> service completion -> personnel/tools clear -> energy restoration -> affected safety-function/final-element revalidation -> safety rearm -> fresh ordinary production start`.

Prefer documentation that shows how a physical block/support and hydraulic pressure control coexist with electrical isolation, rather than another generic LOTO summary.