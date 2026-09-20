# Operating-mode cold-start and post-power requalification study

Date: 2026-09-20

## Question

After the operating-mode transition commissioning trace, what professional evidence exists for the harder power-loss/cold-start boundary: selected mode memory, safety permission, reset, Start, and prevention of unintended motion?

## DOC-CONFIRMED — Pilz PIT m4SEU

Pilz PIT m4SEU Operating Manual 1004648-EN-08 explicitly treats **safety-related switching-on of the operating mode after power-on** as a safety requirement. Depending on configuration, a cold start places the device in operating mode 1 or the most recently selected operating mode. The device provides safe 1-of-n mode outputs and detects multiple selection-button operation. The operating mode is then activated through the control program of a safety controller.

Important boundary: retaining or restoring a mode identity after power-up is not evidence that hazardous machine operation is authorized. It establishes a safety-related mode-selection state, not an ordinary fresh production command.

## DOC-CONFIRMED — Pilz guard-locking application

Pilz Application Note 1004124-EN-04 provides a stronger post-power sequence. Its example is configured so that after a cold start (PNOZmulti off/on), warm start (STOP->RUN), or return to a safe condition such as closing/locking the safety gate, an acknowledgement through Reset is required before `Enable Drive`, `STO 1 Drive`, and `STO 2 Drive` can be reset via a separate Start pushbutton.

The note explicitly warns that even where the safety-gate monitoring function itself is configured to reset automatically, a PNOZ cold start or return to safe condition must not directly enable machine startup without additional conditions.

This closes an important authority gap:

**SAFE MODE IDENTITY RESTORED AFTER POWER-ON != SAFETY ACKNOWLEDGEMENT COMPLETE != DRIVE SAFETY OUTPUTS RE-ENABLED != FRESH START PRESENT != PHYSICAL MOTION AUTHORIZED.**

## DOC-CONFIRMED — Rockwell safe-motion restart/cold-start parameters

Rockwell SS1/SS2/SOS/SDI/SLP safety instructions expose Restart Type and Cold Start Type independently. With Manual Cold Start, applying controller power or changing controller mode to Run requires a Reset transition before the instruction can operate. Automatic cold start exists as a configurable behavior, with safety warnings that automatic restart is only appropriate where its use does not create unsafe conditions.

This reinforces that cold-start behavior is a deliberate validated safety-policy choice rather than something to inherit accidentally from ordinary controller state.

## Combined authority chain

Freeze:

`power restored -> safety device/controller initializes -> safety-evaluated mode established -> mode-dependent safeguards/conditions valid -> required cold-start acknowledgement/reset -> safety outputs permitted -> ordinary controller state checked for stale requests -> separate fresh deliberate Start where required -> final element -> physical machine witness`

The following are not equivalent:

**POWER RESTORED != PRE-POWER MODE MEMORY TRUSTWORTHY FOR MOTION != SAFETY-EVALUATED MODE VALID != MODE-SPECIFIC SAFEGUARDS VALID != COLD-START RESET COMPLETE != SAFETY OUTPUTS PERMITTED != ORDINARY START FRESH != PHYSICAL MACHINE SAFE TO MOVE.**

Also freeze:

**MOST-RECENT MODE RESTORED != MOST-RECENT MOTION COMMAND AUTHORIZED.**

**SAFETY CONTROLLER RUNNING != PRODUCTION START AUTHORITY.**

**AUTO-RESET CAPABILITY EXISTS != AUTO-RESTART ACCEPTABLE FOR THIS MACHINE.**

## Commissioning/adversarial pattern

Where the actual machine safety design requires it, a commissioning procedure should challenge:

1. Power loss in every relevant operating mode and machine phase.
2. Power restoration with ordinary START/foot-pedal/HMI/FPGA command state intentionally retained or asserted.
3. The configured cold-start mode-selection result (default mode vs last mode) and whether it is the documented result.
4. Invalid or incomplete mode-selection inputs during initialization.
5. Whether mode-dependent guards, enabling devices, safe-speed functions, hydraulic conditions, and final-element feedback are valid before safety permission can return.
6. Required manual Reset/acknowledgement after cold/warm start.
7. Proof that Reset itself does not initiate hazardous motion.
8. Proof that a separate fresh Start is required where the validated architecture requires it.
9. Final-element and physical-machine observation, not merely HMI/LinuxCNC status.

## LinuxCNC/OpenPressBrake boundary

LinuxCNC, HAL, ordinary FPGA registers, GUI state, and retained application variables may reboot or recover independently from the safety system. Their restored state is not personnel-safety evidence. If an ordinary motion request can survive a reboot, reconnect, process restart, FPGA reconfiguration, or safety-permission outage, the machine architecture must explicitly decide how that request is invalidated/requalified before motion becomes possible.

The exact OpenPressBrake implementation remains UNKNOWN. This study does not choose automatic vs manual cold-start reset, default vs retained operating mode, hydraulic behavior, or a specific stale-command edge-detection scheme.

## Human-factors rule

Cold-start recovery should be clear and intentional. A reset/restart sequence that is so obscure or unreliable that operators routinely power-cycle, hold controls, or bypass interlocks to recover is a design defect. The safer recovery path should also be the easiest legitimate recovery path.

## No compute decision

No compute is justified. The new evidence comes directly from professional safety-device/controller documentation. A software-only lab cannot prove the machine-specific physical safety chain. No GitHub-hosted or self-hosted runner compute was consumed.

## Next evidence target

Seek a complete machine/OEM commissioning example that physically demonstrates this sequence through the final element after power restoration, ideally with a retained ordinary command deliberately challenged. If no such source is available, preserve the remaining physical-machine portion as UNKNOWN and rotate rather than inventing it.
