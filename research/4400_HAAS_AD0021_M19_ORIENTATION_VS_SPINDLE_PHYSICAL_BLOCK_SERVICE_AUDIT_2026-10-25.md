# 4400-BAR-02 — Spindle orientation M19 versus physical service restraint
**2026-10-25 | direct original Haas service documentation | NON-GRADUATED**

## Direct manufacturer evidence
Haas official **Extruded Spindle Liner — Installation — Lathe AD0021**, updated **2022-06-07**, applies to specified machines built July 2005–October 2015: https://www.haascnc.com/service/troubleshooting-and-how-to/how-to/lathe---extruded-spindle-liner---adapter-kit-o1-75---installatio2.html . The original page, Installation section, explicitly instructs blocking the spindle against rotation before installing the liner adapter, permits an appropriate physical block or on its listed C-axis machines the spindle brake (M14), and explicitly says **never use M19 to block the spindle**. It also reminds the maintainer to remove the block before normal operation. **DOC-CONFIRMED for this exact OEM task and variant**, not a universal instruction to use a machine turret/tailstock as a safety restraint.

## Safety lesson
**INFERENCE:** an orientation-complete bit, spindle-at-position command, or LinuxCNC spindle orientation function is not a positive mechanical restraint and does not prove torque cannot move the spindle during maintenance. A selected spindle brake also needs exact manufacturer-approved mechanical holding capability and task-specific energy isolation before being accepted as a protective device. The physical block/fixture must be approved for the task, and removal must be part of controlled return to service. A removable block itself is not equivalent to lockout of electrical, hydraulic or stored energy.

## Adversarial case
Technician needs to loosen a liner adapter. HMI says 'spindle oriented' and servo holds position; someone proposes relying on M19. The source disproves M19 as an acceptable substitute in this Haas service task. Require qualified task-specific restraint, energy isolation and zero-motion verification without exposing a person. No invented holding torque, block design, brake rating or release sequence.

## Evidence boundary
No OpenPressBrake/selected LinuxCNC machine uses this Haas liner, brake or M19 procedure by assumption. **SOURCE-CONFIRMED LinuxCNC physical behavior:** none added. **TEST-CONFIRMED:** none. **UNKNOWN:** selected spindle and service mechanism. G0/G1 HOLD; G3/G4 NOT AUTHORIZED. Do not copy an OEM service action into another machine as a safety recipe.
