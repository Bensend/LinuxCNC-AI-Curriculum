# Operating-mode transition commissioning and stale-command witness study

Date: 2026-09-20

## Scope

Lane-B continuation of the operating-mode selection authority study. This is a generic professional-machine safety study, not an OpenPressBrake machine design and not a claim that LinuxCNC, ordinary HAL logic, an ordinary FPGA, or an HMI is safety-rated.

Question: what does a real commissioning procedure require beyond merely displaying or selecting a mode, especially across Automatic <-> Service transitions, E-stop recovery, and retained ordinary start commands?

## Evidence classifications

### DOC-CONFIRMED — SICK Safe Stationary Machine example

Source: SICK, *Safe Stationary Machine*, document 8020304/2017-07-26.

The example has Automatic and Service modes. Changing operating mode causes a controlled stop. Automatic restart requires door closure, reset, then restart. Service operation requires reset, a held enabling switch, then restart, and runs at reduced speed. Releasing the enabling switch stops the machine. Returning from Service to Automatic again causes a controlled stop and requires door closure, reset, then restart.

The safe state is also entered for detected discrepancy/short-circuit faults on safety switches or the operating-mode selector, EDM faults, encoder plausibility faults, E-stop, released enabling switch in Service, or excessive Service-mode speed.

The commissioning checklist physically exercises both mode transitions. Automatic -> Service must produce SS2, after which the correct ordered sequence Reset -> held enabling switch -> Start produces reduced-speed motion. Service -> Automatic must likewise produce SS2, after which Reset -> Start is required.

A stronger stale-command/restart challenge appears in the Service-mode E-stop test: after E-stop is reset, merely holding the enabling switch and actuating Start has no effect; the machine remains off. Only after Reset, held enabling switch, then Start in the required order does reduced-speed operation resume.

The commissioning checklist also challenges Service overspeed and expects SS2, and checks final drive behavior including STO state in stop-ramp fault cases. Thus the validation path extends beyond a mode bit to a safety response and drive-facing witness.

SICK explicitly requires a thorough check before commissioning, after safety/configuration changes, after mounting/electrical changes, after detected manipulation, machine modification, or component replacement. Effectiveness is to be checked in every selectable operating mode and documented by qualified personnel.

### DOC-CONFIRMED — Pilz operating-mode selection

Pilz requires each selector position to enable only one operating mode and says operation of the selector alone must not initiate machine operation. Pilz PITmode documentation further states that mode selection is to occur outside the danger zone and not while the machine is running. PITmode separates access permission from safe operating-mode evaluation.

### DOC-CONFIRMED — Rockwell Five Position Mode Selector

Rockwell's FPMS instruction represents `No Mode` and `Multiple Modes Selected` as explicit faults. While `Fault Present` is set, an output cannot enter Active. Clearing underlying faults is not itself enough: `Fault Present` clears when faults are clear and the Fault Reset input makes the required OFF->ON transition.

### DOC-CONFIRMED — SICK restart interlock

SICK defines restart interlock as preventing automatic restart, including after the operating mode has changed; a reset command is required before restart.

## Durable authority chain

Freeze the commissioning chain as:

`authorized mode request -> safety-evaluated exclusive mode -> mode-change stop demand -> final stop function -> destination-mode conditions/safeguards -> reset/requalification -> destination-mode compensating controls where applicable -> separate fresh Start -> final element -> physical machine witness`

The following are deliberately not equivalent:

**ACCESS PERMISSION VALID != OPERATING MODE SAFELY SELECTED != EXACTLY ONE MODE VALID != MODE TRANSITION SAFELY COMPLETED != DESTINATION-MODE SAFEGUARDS/COMPENSATING FUNCTIONS VALID != RESET/REQUALIFICATION COMPLETE != ORDINARY START REQUEST FRESH != FINAL ELEMENT ACTED != PHYSICAL MACHINE BEHAVIOR SAFE.**

Also freeze:

**MODE DISPLAY CHANGED != MODE TRANSITION COMPLETE.**

**MODE CHANGE != START.**

**E-STOP RELEASED != RESET COMPLETE != START AUTHORIZED.**

**START INPUT PRESENT != FRESH START AUTHORITY.**

**NO/MULTIPLE-MODE FAULT CLEARED AT INPUTS != SAFETY MODE OUTPUT AUTOMATICALLY RE-ACTIVATED.**

## Commissioning/adversarial procedure pattern

A machine-specific validation plan should, where applicable to its risk assessment and safety design, challenge at least these boundaries rather than checking only indicator lamps:

1. Start in each valid mode and prove its mode-specific safeguarding or compensating safety functions through the real final elements and a physical machine witness.
2. While operating in one mode, request another. Prove the transition causes the designed safe stop before destination-mode motion authority exists.
3. Prove the selector/mode request alone cannot initiate motion.
4. In a setup/service mode, challenge the enabling device and any reduced-speed/limited-motion safety function separately.
5. Challenge invalid mode states such as no-mode and multiple-mode where the selected safety architecture exposes them; prove motion authority remains inhibited and requires the documented recovery/reset sequence.
6. Hold or simulate a retained ordinary START request across a mode transition, E-stop, safety reset, and safety-controller/power restoration. Prove it cannot silently become a fresh production-motion request after safety permission returns.
7. Prove the separate fresh deliberate START action required by the machine architecture after the destination mode is valid.
8. Observe the actual drive/hydraulic/other final element and the physical hazard response; HMI mode text or a LinuxCNC/HAL bit is not the physical witness.

The SICK example provides a concrete professional sequence for item 6: after Service-mode E-stop recovery, enabling + Start before Reset does nothing; Reset must occur before the subsequent enabling + Start sequence can run the drive.

## LinuxCNC/OpenPressBrake boundary

LinuxCNC/HAL/HMI may request a normal operating state, display status, sequence production behavior, and record diagnostics, but this study does not establish them as personnel-safety authority. Where mode selection changes required safeguards or permits exposed-person setup motion, the safety-related evaluation and compensating functions belong in the validated safety architecture.

A retained LinuxCNC command, FPGA register, HAL pin, GUI button state, foot-pedal state, or state-machine phase must not be assumed to be a fresh deliberate start merely because the independent safety system has returned permission. The exact mechanism for rejecting stale ordinary commands is machine-specific and remains UNKNOWN for OpenPressBrake.

## Human-factors implication

Safe setup/service operation must be usable enough that operators do not gain a practical incentive to defeat guards or bypass the enabling function. A clearly selected mode, obvious active-mode indication, straightforward reset/restart sequence, and usable sustained-action control reduce pressure to improvise unsafe workarounds. This is an engineering requirement to address, not an excuse to weaken the safety boundary.

## Unknowns preserved

For OpenPressBrake, the following remain UNKNOWN and must not be invented here:

- exact operating modes and mode-dependent hazards;
- selector/access hardware and safe evaluator;
- whether mode change uses SS1, SS2, another stop function, or hydraulic-specific behavior;
- reduced-speed/path/force limits and their measurement;
- guard, laser/AOPD, pedal, enabling-device, and hydraulic interactions by mode;
- exact stale-command rejection implementation;
- cold-start policy;
- PL/SIL/category/DC/CCF targets;
- stopping time/distance;
- final hydraulic truth table;
- fresh production-start sequence.

## No compute decision

No simulation/build/test was justified. The unresolved questions are machine-specific safety architecture and physical validation questions, not questions a generic software simulation would resolve. No GitHub-hosted runner and no self-hosted runner compute were used.

## Next evidence target

Extend this lane only if a professional machine/OEM commissioning procedure exposes one or more of:

- explicit no-mode/multiple-mode field fault injection;
- power-loss/cold-start mode recovery with stale-command challenge;
- mode transition through a hydraulic final element with a physical machine witness;
- proof that a retained ordinary command cannot reassert after safety permission returns.

Otherwise rotate to another open safety branch rather than manufacturing synthetic evidence.
