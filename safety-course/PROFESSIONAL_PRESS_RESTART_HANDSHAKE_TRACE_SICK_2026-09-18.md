# Professional press reset/restart/EDM handshake trace — SICK UE4457

Session start: 2026-09-18T04:37:00Z

## Purpose
Close a specific evidence gap left by the hydraulic/fall-protection work: show a professional press implementation in which independent safety logic does not silently become ordinary motion authority after reset.

## Source
SICK UE4457 IP67 Operating Instructions, logic-programming press example (8011214/TF85/2010-04-06), p.143. Evidence class: **DOC-CONFIRMED**.

## Documented sequence
The example gives an explicit ordered handshake:

1. Safety controller powers up and completes its internal test.
2. Communication with the ordinary press controller (standard PLC) is established.
3. Safety inputs (examples named by SICK: C4000/S3000 OSSDs, E-stops, safety-door interlock) must be active.
4. Reset-required indication is asserted.
5. A reset pushbutton is operated according to the safety function-block requirements.
6. The safety controller sends a `Restart required` state to the standard press controller.
7. The standard press controller returns a `Restart` input to the safety controller.
8. Only after the restart sequence is satisfied does the safety function produce `Safety Enable`.
9. The standard PLC may then command Ram Down / Ram Up, while the safety conditions remain valid and EDM feedback remains correct.
10. The example explicitly interlocks Ram Up and Ram Down outputs.
11. Power cycling or loss of a safety input returns the sequence to its earlier safety checks rather than preserving motion authority.

## Evidence boundary
This is unusually valuable because it separates four authorities that are often collapsed in retrofit reasoning:

**protective devices healthy -> manual safety reset -> safety/ordinary-controller restart handshake -> Safety Enable -> ordinary Ram Up/Down command**

Frozen rule:

**RESET ACCEPTED != RESTART HANDSHAKE COMPLETE != SAFETY ENABLE != RAM COMMAND != VERIFIED RAM MOTION.**

The standard PLC participates in the restart handshake, but the independent safety logic retains the safety-enable decision. Conversely, the safety controller does not select Ram Up/Down as a consequence of reset.

## EDM boundary
SICK requires External Device Monitoring feedback to remain consistent with the EDM function-block requirements while motion control is permitted. Evidence class: **DOC-CONFIRMED**.

EDM is therefore a final-switching-device consistency witness. It must not be promoted into proof of:

- hydraulic pressure absence;
- seated hydraulic holding-valve position unless that exact device is what is monitored;
- ram standstill;
- gravity-load retention;
- personnel absence;
- accumulator discharge;
- maintenance isolation.

Those stronger claims require their own physical witnesses.

## Reconciliation with the HAWE hydraulic trace
The prior HAWE ePRAX work established a different layer: safety-related hydraulic actuators QM2-QM5, BG2-BG5 valve-position witnesses, pressure evidence, dual Y-axis disagreement, gravity-driven FAST DOWN, and retained-energy/maintenance boundaries.

The SICK press example now supplies a professional controller-level restart pattern that can be composed with that physical evidence without pretending the two products are one certified design:

`protective demand / mode` -> `independent safety logic` -> `reset` -> `restart handshake` -> `Safety Enable` -> `ordinary motion command` -> `hydraulic safety final elements` -> `valve/pressure/load witnesses`

The composition above is **INFERENCE / curriculum architecture**, not a manufacturer-certified SICK+HAWE combination.

## OpenPressBrake application boundary
For OpenPressBrake, the exact safety controller, hydraulic topology, final switching devices, EDM targets, reset/restart wiring, and safe re-enable sequence remain **UNKNOWN** until selected/designed and validated.

Required architecture property, however, is now well supported: LinuxCNC/HAL/ordinary FPGA may request or consume restart/permissive state, but safety reset must not directly create a fresh Ram Down/Up command. A stale ordinary command must not become newly authorized hazardous motion merely because safety authority returned.

## Commissioning challenges derived from the trace
These are verification requirements, not claims about existing OpenPressBrake hardware:

- Hold ordinary Ram Down true before safety reset; demonstrate that reset alone cannot cause motion.
- Interrupt a safety input during permitted motion; require safety removal and a complete documented restart sequence before ordinary control can regain authority.
- Force an EDM disagreement; verify Safety Enable cannot be accepted/restored while the discrepancy exists.
- Power-cycle the safety controller while ordinary controller state survives; verify no retained ordinary command bypasses reset/restart semantics.
- Power-cycle the ordinary controller while safety logic survives; verify communications/restart state cannot be mistaken for a fresh START.
- Challenge contradictory Up/Down requests; verify the implemented architecture has an explicit safe resolution.
- Separately verify hydraulic valve-position, pressure, load-motion, and retained-energy witnesses; do not use successful EDM as their surrogate.

## Minimum-operate gate
If a reset or safety-enable transition can replay a stale hazardous-motion request without a validated fresh-start/restart contract, the affected operating mode is **DO-NOT-OPERATE with people exposed** until corrected. Experimental testing must be isolated/remote with people outside the danger zone and residual stored/gravity energy controlled.

## Next evidence target
Find a complete press/vertical-axis implementation that joins this controller-level handshake to explicit monitored hydraulic final elements (valve position and/or pressure/load witnesses) in the same documented machine, or preserve the integration boundary as UNKNOWN. Also seek a professional dual-axis discrepancy/latch example if it exposes Y1/Y2 disagreement through reset and physical re-enable.

No simulation or build is justified by this source trace; no compute was consumed.
