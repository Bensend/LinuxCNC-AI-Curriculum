# Multi-zone E-stop span of control and restart authority trace

Date: 2026-09-19

## Question

What can a professional multi-zone implementation actually establish about E-stop span of control, zone containment, reset, and restart authority without transferring machine-specific assumptions to OpenPressBrake?

## Evidence

### DOC-CONFIRMED — Pilz / ISO 13850 interpretation

Pilz states that an E-stop need not remove power from the entire machine. For a machine made from several individual machines, the E-stop command may only be reset directly at the E-stop device that initiated it, by intentional human action. Reset is allowed only after the initiating hazard has been safely removed. If the whole operating range cannot be checked from that device, additional reset/start devices can be required by the risk assessment. Resetting the E-stop must not itself restart machinery; restart requires voluntary actuation of a control device provided for that purpose.

Source: https://www.pilz.com/en-IE/support/faq/standards/articles/180045

### DOC-CONFIRMED — Rockwell real five-zone automotive implementation

Rockwell's Kia Motors Slovakia case study documents an actual body-shop safety redesign in which the line was divided into five zones. Each zone used local Safety Point I/O connected to GuardLogix. The reported behavior is that an interruption stops only the relevant zone, identifies the location, and permits unaffected zones to remain operational.

Source: https://www.rockwellautomation.com/en-se/company/news/case-studies/kia-motor-slovakia-reduces-safety-downtime-by-up-to-70-.html

This is strong evidence that a validated safety architecture may intentionally have a bounded span of control rather than treating every safety demand as a plant-wide power removal. It is not evidence that any arbitrary neighboring zone may remain running; that boundary is application/risk-assessment specific.

### DOC-CONFIRMED — Rockwell zone-tagged safety implementation evidence

Rockwell's CNC accelerator documentation identifies safety input objects by a `ZoneName_DeviceName` convention and states that the safety input status is one of the permissives used in safety output routines. This is useful implementation evidence that zone identity belongs in the safety-function architecture and is not merely an HMI label.

Source: https://literature.rockwellautomation.com/idc/groups/literature/documents/qs/iasimp-qs034_-en-p.pdf

### DOC-CONFIRMED — ordinary MCR logic is not the safety boundary

Rockwell's Logix MCR instruction can disable a program zone, but Rockwell explicitly warns that MCR is not a substitute for a hard-wired master control relay providing E-stop capability. Therefore an ordinary LinuxCNC/HAL/PLC software grouping called a zone cannot by naming alone become the personnel-safety span-of-control mechanism.

Source: https://www.rockwellautomation.com/en-pr/docs/studio-5000-logix-designer/38-02/contents-ditamap/instruction-set/program-control-instructions/master-control-reset--mcr-.html

## Durable freezes

**E-STOP SPAN OF CONTROL != ENTIRE MACHINE BY DEFAULT.**

**ZONE LABEL != VALIDATED SAFETY ZONE.**

**ZONE A SAFETY DEMAND != ZONE B MUST STOP** unless the validated hazard interaction/span-of-control analysis requires it.

**ZONE B CONTINUES RUNNING != ZONE A FAILED TO E-STOP** when the validated architecture deliberately isolates the hazard and permits unaffected zones to remain operational.

**E-STOP DEVICE RELEASED != SAFETY RESET COMPLETE != AREA CLEAR != FINAL ELEMENT PROVED != ORDINARY START.**

**ORDINARY SOFTWARE/HMI ZONE != SAFETY-RATED SPAN-OF-CONTROL IMPLEMENTATION.**

## Commissioning/adversarial implications

A multi-zone safety validation should challenge the mapping, not merely prove that each button changes a bit:

1. demand each E-stop individually;
2. observe which safety outputs/final elements actually transition;
3. verify every hazard required to stop by that device does stop;
4. verify intentionally unaffected zones against the documented span rather than assuming global shutdown;
5. verify device identity/location diagnostics agree with the initiating device;
6. release the initiating device and verify this does not itself restore hazardous motion;
7. where visibility is incomplete, exercise the required additional area-clear/reset mechanism;
8. verify stale/held ordinary START cannot become motion merely because safety authority returns;
9. require a fresh intentional ordinary start where the application calls for it.

A swapped zone input, copied safety tag, incorrect output mapping, or wrong final-element assignment is therefore a commissioning fault worth deliberately checking. HMI indication alone is not the physical witness.

## OpenPressBrake boundary

OpenPressBrake zone boundaries, number/location of E-stops, hydraulic reaction, stop category, final elements, reset locations, area-clear mechanism, stopping performance, and interaction with neighboring equipment remain UNKNOWN until the machine risk assessment/design and physical validation establish them. LinuxCNC and the ordinary FPGA may display zone state and consume permissives/diagnostics, but they must not become the sole personnel-safety authority merely because software can represent zones conveniently.

## Evidence classification

- DOC-CONFIRMED: Pilz reset/restart interpretation and local reset requirement.
- DOC-CONFIRMED: Rockwell five-zone automotive implementation with relevant-zone stopping and unaffected-zone continued operation.
- DOC-CONFIRMED: Rockwell zone-named safety input/permissive implementation evidence.
- DOC-CONFIRMED: Rockwell MCR ordinary logic explicitly not a substitute for E-stop hardware.
- TEST-CONFIRMED: none for OpenPressBrake.
- UNKNOWN: OpenPressBrake machine-specific span of control and physical stop behavior.

## Compute decision

No lab was justified. The unresolved OpenPressBrake questions are physical architecture/risk-assessment/commissioning facts, not questions a software simulation can establish. No GitHub-hosted Actions compute was used.
