# Lane B — ESPE physical-field to machine-stop, reset and fresh-start acceptance chain

Date: 2026-09-21
Lane: independent LinuxCNC/OpenPressBrake safety curriculum B

## Why this branch

The primary safety lane is currently advancing exceptional commissioning-state/force persistence and positive-clear production handoff. Lane B's previous checkpoint left an independent ESPE gap: connect a physical protective-field challenge to the safety outputs, actual machine stop, failed-test disposition, correction/retest, reset/rearm and fresh ordinary start. This file stays out of the primary lane's force/simulation/override files and evidence family.

## Evidence labels

- `DOC-CONFIRMED`: stated in cited manufacturer documentation.
- `SOURCE-CONFIRMED`: directly inspectable authoritative source behavior or architecture.
- `TEST-CONFIRMED`: observed by an executed test in this project; none claimed here.
- `COMMUNITY-REPORTED`: community evidence; none used for a safety claim here.
- `INFERENCE`: engineering conclusion transferred from the cited evidence.
- `UNKNOWN`: requires OpenPressBrake-specific design, measurement or validation.

## Source 1 — SICK Safe Presence Detection integrated validation sequence

Source: SICK, *Safe Presence Detection safety system*, operating instructions 8022325/2018-04-12.

URL: https://www.sick.com/media/docs/5/05/205/operating_instructions_safe_presence_detection_safety_system_en_im0078205.pdf

`DOC-CONFIRMED`:

- The manufacturer's validation table deliberately starts the machine and breaches the safety-light-curtain protective field with a test rod.
- The expected result is that the safety controller outputs go OFF and **the machine is stopped**. This is stronger evidence than merely checking an OSSD/status indication.
- In the documented restart-interlock test, releasing/resetting an emergency-stop device and then attempting restart without the required reset leaves the safety outputs OFF and the machine does not start.
- A separate sequence adds the reset action and then restart; only after that sequence is the machine expected to start.

This source therefore exposes distinct observable boundaries between protective-device demand, safety-controller output state, physical machine stopping, reset/rearm and machine restart.

## Source 2 — SICK C4000 Palletizer physical-field challenge and failed-test disposition

Source: SICK, *C4000 Palletizer Standard/Advanced Safety Light Curtain*, operating instructions, commissioning chapter.

URL: https://www.sick.com/media/docs/3/73/873/operating_instructions_c4000_palletizer_standard_advanced_safety_light_curtain_en_im0013873.pdf

`DOC-CONFIRMED`:

- The protective device is checked with the correct test rod along the **complete hazardous area to be protected**, not merely at the light-curtain mounting position.
- If the expected red indication does not occur during the test, the machine must not be operated; work must stop and installation must be checked by specialized personnel.
- The system is to be checked again after machine/protective-device modifications or light-curtain change/repair.

This gives an explicit failed-test production-block boundary and supports the previous Lane-B maintenance study without treating an internally healthy device as proof of the installed protective field.

## Source 3 — Pilz PSEN op2H restart-mode hazard boundary

Source: Pilz, *PSEN op2H-s Series Instruction Manual*, 1001421-EN-03.

URL: https://www.pilz.com/download/open/PSEN_op2H-s_Oper_Man_1001421-EN-03.pdf

`DOC-CONFIRMED`:

- Obstruction opens the OSSD outputs and places the light curtain in its safe/break condition.
- Automatic reset can restore normal operation after the object is removed.
- Pilz explicitly warns that automatic reset can be unsafe for access protection when a person can pass completely beyond the sensitive area; manual reset/restart architecture may then be necessary.

This is useful because `field clear` cannot be promoted into a universal `area clear` or `restart authorized` fact.

## Authority chain to teach

The curriculum should keep these states separate:

1. physical protective field challenged;
2. protective device detects the challenge;
3. OSSD/safety input changes;
4. safety logic commands its safe output state;
5. final elements respond;
6. hazardous machine movement actually stops as required;
7. any applicable quantitative stop-performance criterion is separately accepted;
8. protective field/area is restored and personnel-clear conditions are satisfied;
9. reset/rearm is deliberately accepted where required;
10. a separate fresh ordinary motion/start command is required where the machine architecture calls for one.

`INFERENCE`: an HMI, LinuxCNC HAL signal, FPGA bit or safety-controller diagnostic is evidence about one layer only. It is not permission to skip the downstream physical witness.

## Durable freezes

- **TEST ROD DETECTED != MACHINE PHYSICALLY STOPPED**
- **OSSD OFF != FINAL ELEMENT PHYSICALLY IN SAFE STATE**
- **MACHINE STOPPED ONCE != QUANTITATIVE STOPPING PERFORMANCE ACCEPTED**
- **PROTECTIVE FIELD CLEAR != HAZARDOUS AREA PERSONNEL-CLEAR**
- **PROTECTIVE FIELD RESTORED != RESET/REARM ACCEPTED != ORDINARY START AUTHORIZED**
- **FAILED PHYSICAL FIELD TEST != CONDITION THAT MAY BE ACKNOWLEDGED BACK INTO PRODUCTION**
- **DEVICE SELF-DIAGNOSTICS HEALTHY != INSTALLED PROTECTIVE GEOMETRY PHYSICALLY PROVED**

## Question-driven commissioning worksheet

The future OpenPressBrake implementation should answer these with architecture-specific evidence rather than copied numbers:

| Question | Required witness | Current OpenPressBrake status |
|---|---|---|
| Does the intended test object challenge every required part of the physical protected boundary? | physical field challenge at defined locations | `UNKNOWN` |
| Does the ESPE report the challenge? | device/OSSD state | `UNKNOWN` |
| Does safety logic receive and act on it? | safety-I/O/controller evidence | `UNKNOWN` |
| Do final elements actually transition? | contactor/STO/valve/brake or other architecture-specific physical feedback | `UNKNOWN` |
| Does hazardous machine motion stop as required? | direct physical machine witness | `UNKNOWN` |
| If stop performance determines safeguard placement, does the tested machine configuration meet the applicable acceptance criterion? | measured result plus machine configuration and acceptance basis | `UNKNOWN` |
| Does a failed protective-field test block production until corrected and completely retested? | commissioning/maintenance procedure and observed validation | `UNKNOWN` |
| Can clearing the field alone restart motion when whole-body access is possible? | negative restart test | `UNKNOWN` |
| After reset/rearm, can a stale START/JOG/CYCLE command create motion? | negative stale-command test | `UNKNOWN` |
| Is a separate fresh ordinary command required after the safety sequence? | observed start-authority test | `UNKNOWN` |

## Failure-path exercise

A useful eventual machine test, once the real architecture is defined and safe to commission, is:

1. Establish an approved test state and safe test boundary.
2. Start only the motion needed for the test.
3. Challenge the ESPE at each required physical location with the specified test object.
4. Record protective-device and safety-logic response.
5. Observe the actual final element(s), not just software status.
6. Observe the physical hazardous motion response.
7. Deliberately create or use a safe simulated installation defect only where the OEM/device validation procedure permits it; verify that a failed field test blocks production rather than becoming an acknowledge-and-run condition.
8. Correct the defect and repeat the complete affected test, rather than merely clearing a diagnostic.
9. Challenge stand-behind/personnel-clear behavior where whole-body access exists.
10. Perform required reset/rearm.
11. Hold an ordinary START/JOG/CYCLE request across the reset boundary and prove it cannot become stale motion authority.
12. Issue a separate fresh ordinary command and verify only the intended motion occurs.

Steps involving real machine energy are a future commissioning plan, not `TEST-CONFIRMED` evidence from this curriculum run.

## OpenPressBrake boundary

`INFERENCE`: LinuxCNC and the normal FPGA/control path may display ESPE state, inhibit ordinary commands, log faults, and coordinate production behavior, but personnel-safety authority must remain in the qualified safety architecture. Ordinary software must not be allowed to reinterpret `field clear`, reset a failed physical validation, or synthesize personnel-clear authority.

`UNKNOWN` and deliberately not invented here:

- ESPE type/resolution/geometry;
- required test object;
- safety distance;
- response/stopping time or distance;
- final-element topology;
- hydraulic response or safe-state truth table;
- PL/SIL/category/DC/CCF;
- reset architecture;
- whole-body-access/personnel-clear method;
- test interval or quantitative acceptance limit.

## Compute

No executable verification was justified. This was a source/documentation and architecture-tracing task, so no GitHub Actions compute was used.

## Precise next Lane-B work

Find authoritative OEM/manufacturer evidence that closes the remaining downstream final-element witness with a deliberate **ESPE challenge -> safety output -> physical contactor/STO/hydraulic final element -> actual hazardous-motion stop -> failed-test production lockout -> correction/full affected retest -> reset/rearm -> fresh start** sequence. Prefer a press, press brake, robot cell or other high-energy machine with an explicit acceptance checklist. If no source adds a physical final-element witness beyond the SICK integrated machine-stop sequence, mark this ESPE branch information-gain limited and rotate to another independent safety branch rather than accumulating generic light-curtain material.
