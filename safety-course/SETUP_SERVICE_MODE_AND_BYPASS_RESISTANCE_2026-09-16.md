# Setup, service mode and safeguard-bypass resistance — professional patterns

Date: 2026-09-16
Status: RESEARCH / ARCHITECTURE FOUNDATION
Scope: generic machinery safety curriculum. This is not a machine-specific PL/SIL determination and does not invent safe speeds, stopping distances, hydraulic states, or diagnostic coverage.

## Learning objective

Teach a fresh AI engineer to distinguish a deliberately engineered setup/service operating mode from an improvised safeguard bypass, and to preserve independent personnel-safety authority when integrating LinuxCNC or an ordinary FPGA controller.

The practical objective is human-factors driven: if legitimate setup, calibration, troubleshooting, tool setting or maintenance routinely requires access, the machine should provide a deliberately engineered way to perform the necessary task under reduced risk. A safeguard that makes normal required work unnecessarily difficult invites defeat; that inconvenience is an engineering problem, not a reason to normalize bypassing the safeguard.

## Evidence ledger

### E1 — operating-mode selection is itself a safety-relevant boundary

Classification: DOC-CONFIRMED.

Pilz states that where a machine has multiple operating modes/control sequences requiring different levels of safety, an operating-mode selector is required. Each selector position may exclusively enable one operating mode; selection alone may not initiate machine operation; and the selected mode overrides other control functions except emergency stop/emergency off. Pilz further explains that safe evaluation is needed to reliably guarantee exclusive selection.

Source: Pilz, `Must an operating mode selector switch be safely evaluated?`, https://www.pilz.com/en-GB/support/faq/standards/articles/167661

### E2 — professional mode-selection products deliberately separate authorization, selection and machine activation

Classification: DOC-CONFIRMED.

Pilz PITmode/PITreader provides functionally safe operating-mode selection plus access permission. PITmode fusion uses a separate Safe Evaluation Unit; PITmode flex uses safety-controller evaluation. The current PIT m4SEU manual describes setup, manual, automatic and service modes, deliberate operator action, detection of multiple simultaneous selection buttons, and a safe `1oon` output rule in which only one operating-mode output is asserted. The selected mode is subsequently activated by the safety-controller program; choosing the mode is not itself a motion command.

Sources:
- https://www.pilz.com/en-US/products/operating-and-monitoring/control-and-signal-devices/pitmode-operating-mode-selector-switch
- https://www.pilz.com/download/open/PIT_m4SEU_Operat_Manual_1004648-EN-08.pdf

### E3 — setup/service access can use an enabling device rather than simply defeating the guard

Classification: DOC-CONFIRMED.

SICK's E100 is a three-stage enabling switch intended for setup/maintenance work in a hazardous area. Motion/functions are enabled only in the middle position; releasing the switch or squeezing through the middle position removes the enabling condition. SICK's Guide for Safe Machinery describes a special operating mode with safeguards disabled only under controlled conditions: the selected mode locks out other modes, selection itself does not cause motion, and dangerous functions require continuous command-device actuation under reduced-risk conditions such as limited speed, path or duration.

Sources:
- https://www.sick.com/cn/en/catalog/products/safety/safety-switches/e100/c/g195532
- https://www.sick.com/media/docs/8/78/678/Special_information_Guide_for_Safe_Machinery_en_IM0014678.PDF

### E4 — losing the enabling condition is a safety demand

Classification: DOC-CONFIRMED.

SICK's Safe Stationary Machine documentation states that safety outputs switch off and the machine remains in the safe state when, among other conditions, the enabling switch is released in Service mode or Service-mode speed is too high. The same safe-state list includes interrupted encoder/controller supply, safety-switch/mode-selector faults and EDM faults.

Source: https://cdn.sick.com/media/docs/9/59/059/Operating_instructions_Safe_Stationary_Machine_en_IM0075059.PDF

### E5 — automatic restart after safeguard restoration is an explicit hazard to prevent

Classification: DOC-CONFIRMED.

Pilz PNOZ s5 documentation warns that automatic start or a bridged manual-start contact can cause automatic startup when a safeguard is reset (for example, when an E-stop is released) and instructs the integrator to use external circuit measures to prevent unexpected restart.

Source: https://www.pilz.com/download/open/PNOZ_s5_Operat_Man_21397-EN-11.pdf

### E6 — access management can make restart prevention easier to use than ad-hoc lockout/bypass behavior

Classification: DOC-CONFIRMED.

Pilz documents a `Key-in-pocket` access-management pattern: an authenticated worker places the plant in an appropriate safe state, opens the gate, removes and retains the personal transponder, and enters. The machine is not re-enabled until all signed-in workers have exited and signed out; for large blind areas Pilz describes an additional blind-spot check before restart. Pilz also offers mechanical padlock restart-interlock accessories for guard locking devices.

Sources:
- https://www.pilz.com/en-GB/access-management
- https://www.pilz.com/en-INT/eshop/product/570552

## Architecture lesson: setup mode is not `guard_bypass = true`

A professional setup/service architecture should be reasoned as a state/authority change, not a Boolean bypass of a guard input.

A generic conceptual sequence is:

1. Normal automatic operation is stopped.
2. A deliberate, authorized mode-selection action requests SETUP/SERVICE.
3. Safety logic safely establishes exactly one active operating mode.
4. Safety functions appropriate to that mode are activated. Some normal safeguards may be unavailable only because another independently evaluated protective measure now bounds the hazard.
5. Hazardous movement/function requires deliberate continuous action where the risk assessment requires it (for example, a three-position enabling device plus a separate jog command).
6. Reduced-risk constraints appropriate to the actual machine remain independently enforced.
7. Release/overtravel of the enabling device, mode disagreement, safety-device fault, EDM fault, or violation of the permitted safe-motion envelope creates a safety demand.
8. Returning to AUTOMATIC does not itself start the machine. Restart interlock/final-element proof and a distinct normal START sequence remain necessary.

This is a teaching architecture, not a claim that every machine needs every listed element.

## Authority partition for LinuxCNC/OpenPressBrake

### Independent safety-related system

May own, when required by the machine risk assessment and validated design:
- safety-rated operating-mode evaluation;
- guard/light-curtain state and any permitted special-mode substitution;
- three-position enabling device;
- safe speed/direction/position functions where used;
- safety-valve/contactors/STO final-element authority;
- EDM/final-element feedback;
- restart interlock and personnel-safety reset conditions.

### Ordinary LinuxCNC / FPGA controller

May:
- receive a read-only/diagnostic representation of selected mode and safety-ready state;
- alter ordinary UI and normal-control sequencing for SETUP versus AUTO;
- generate normal jog/position/pressure commands only after the independent safety system permits the relevant operating state;
- default ordinary outputs inactive on stale communications/watchdog/reset;
- show why safety permission is absent.

Must not, merely for convenience:
- synthesize the safety-rated mode selector from an ordinary GUI dropdown;
- turn `guard open` into a software-ignore bit;
- use an ordinary LinuxCNC HAL pin or non-safety FPGA register as the sole enabling-device channel;
- silently restore personnel-safety permission after reboot/network recovery;
- treat a software password as equivalent to independently evaluated operating-mode/access safety where that function is safety-related.

## Human-factors design rules

1. **Provide a legitimate setup path.** If users routinely need to align tooling, jog an axis, observe a mechanism, calibrate sensors or diagnose a machine, design a controlled mode for those tasks instead of forcing them to choose between productivity and the safeguard.
2. **Make mode state obvious.** The operator should not need to infer whether AUTO or SETUP authority is active.
3. **Require deliberate action, not hidden configuration.** A maintenance mode buried in software settings is easier to leave active accidentally than a deliberate mode-selection architecture.
4. **Do not make bypass persistent by default.** Power cycling, LinuxCNC restart, FPGA reconnection or ordinary fault acknowledgment should not silently recreate a special access state.
5. **Avoid easy defeat.** Individually coded/interlocked devices, retained personal keys/transponders and padlockable restart prevention can make the safe workflow easier to preserve than taping a switch or leaving a common key permanently installed.
6. **Keep emergency stop available.** Changing operating mode does not displace E-stop authority.
7. **Separate enable from motion command.** Holding an enabling device should establish permission; a separate deliberate motion command is preferable where the application requires controlled manual movement.
8. **Design for escape behavior.** Three-stage enabling devices intentionally remove permission both when released and when squeezed beyond the enabled middle position.
9. **Support multiple people where needed.** A single reset button is weak protection when several workers can be hidden inside a cell. Personal retained-key/key-in-pocket or equivalent restart-prevention concepts deserve consideration.
10. **Fix inconvenient safeguards.** If a guard has to be removed for routine adjustment because there is no usable setup mode, redesign the workflow/safeguard rather than accepting routine defeat.

## Failure-path analysis

| Failure / shortcut | Desired architectural response |
|---|---|
| Ordinary HMI says SETUP but safety mode selector remains AUTO | no special-mode safety authority; ordinary controller must not override safety |
| Guard switch taped/bypassed | design should use defeat-resistant sensing/diagnostics appropriate to risk; do not normalize bypass |
| Enabling device released | safety demand; hazardous special-mode function loses permission |
| Enabling device squeezed in panic | three-stage device passes through to OFF rather than remaining enabled |
| LinuxCNC crashes/reboots | normal commands inactive; independent safety mode/restart state is not manufactured by reboot |
| FPGA/network reconnects | no automatic safety reset or automatic machine start |
| Worker remains inside large cell | restart-prevention/access-management architecture should prevent or independently verify restart rather than trusting a single unseen reset action |
| Common service key left permanently installed | authorization scheme has become ineffective; use controlled/personalized key handling or access management where justified |
| Safety mode-selector channels disagree/fault | safe state/no transition, according to validated safety design |
| Returning SETUP -> AUTO | mode transition alone does not command motion; restart/start sequence remains separate |

## Minimum practical threshold

If a task requires a person to enter or reach into a hazardous zone and the machine has neither effective isolation/blocking nor a validated special operating mode that adequately controls the relevant hazards, the curriculum must not teach `temporarily bypass the guard and be careful` as an operating method. Do not operate with people exposed to that uncontrolled hazard. Experimental operation must instead be isolated/remote with people outside the danger zone until an adequate architecture is established.

## Adversarial review

**Misleading premise:** `The guard has to be open for setup, so the clean solution is for LinuxCNC to ignore the guard whenever the UI is in Setup mode.`

Verdict: reject. An ordinary UI state does not establish the safety-related operating mode or substitute protective measures. A legitimate special mode must deliberately change the applicable safety architecture and retain independent constraints/permission appropriate to the hazard.

**Failure scenario:** LinuxCNC is in SETUP, the enabling pendant is held, and Ethernet to the ordinary FPGA is lost and restored.

Expected reasoning: the ordinary command path should fail inactive on loss. Reconnection may restore diagnostics but must not manufacture safety reset/restart permission or resume motion automatically. Any renewed hazardous motion requires the independently valid special-mode conditions plus a deliberate normal command.

**Human-factors scenario:** technicians repeatedly wedge a guard switch because calibration requires seeing an axis move with the door open.

Expected reasoning: enforcement alone is insufficient. The machine/workflow likely needs a usable engineered setup mode (where risk assessment permits), appropriate reduced-risk safety functions, deliberate hold-to-run/enabling behavior, clear indication and easy return to normal guarding. If those cannot adequately control the hazard, use isolation/blocking instead; do not institutionalize bypass.

## Open questions / next evidence

1. Find a modern CNC press-brake manual or safety-controller application that exposes the exact setup/adjustment mode and how light-curtain/laser protection, enabling/foot controls and hydraulic safety valves change across modes.
2. Find a complete servo machine-tool example combining safe mode selection, guard unlocking, enabling switch, SLS/SDI/SOS/STO and restart logic in one implementation.
3. Trace one multi-person automated-cell access implementation from retained personal access token through safe restart prevention and final-element enable.
4. Do not assign PL/SIL, safe speed, stopping distance, hydraulic pressure or permissible press-brake mode behavior until the relevant machine/component evidence and design calculation exist.

## Compute decision

No simulation/build/test is justified for this module. The unresolved questions are documentary, machine-specific architecture and validation questions. GitHub-hosted compute was not used.
