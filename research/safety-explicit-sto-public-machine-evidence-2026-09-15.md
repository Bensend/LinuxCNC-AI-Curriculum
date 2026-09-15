# Explicit STO Public Machine Evidence — 2026-09-15

Purpose: ground the future SIM-SAFE-03 lesson in inspectable real-machine evidence rather than a generic invented cabinet.

## Strong public drawing lead — Maho MH400E retrofit

`DOC-CONFIRMED` — A publicly posted 2025-12-29 SolidWorks Electrical drawing for a LinuxCNC-oriented Maho MH400E retrofit contains an explicit safety sheet with separate STO-A/STO-B conductors and labels for spindle, X, Y and Z drive STO channels. The same sheet shows a Phoenix Contact PSR-SCP safety relay family device, E_STOP_A/E_STOP_B, safety reset, safety feedback and an E-stop monitor input. Public PDF surfaced at:

https://www.forum.linuxcnc.org/media/kunena/attachments/42800/MahoMH400ERetrofit_2025-12-29.pdf

Observed labels in the indexed drawing include:
- `SPINDLE_STO_A`, `SPINDLE_STO_B`
- `X_AXIS_STO_A`, `X_AXIS_STO_B`
- `Y_AXIS_STO_A`, `Y_AXIS_STO_B`
- `Z_AXIS_STO_A`, `Z_AXIS_STO_B`
- `SAFETY_FEEDBACK`
- `SAFETY_RESET`
- `E_STOP_A`, `E_STOP_B`
- LinuxCNC-side diagnostic label `safety.estop_active`

The drawing also contains TODO notes to select E-stop/reset/door switches. Therefore it is valuable **architecture/drawing evidence**, but must not be mislabeled as proof that the final physical machine was commissioned or validated exactly as drawn.

## Evidence boundary

`INFERENCE` — The drawing is particularly useful for teaching the separation between:

**physical two-channel E-stop/safety logic -> drive STO channels**

and

**safety-state feedback -> ordinary LinuxCNC diagnostic/status input**.

That is the architecture SIM-SAFE-03 needs to demonstrate, but exact drive behavior, stopping time, STO response time, safe-state category, machine wiring as-built and validation results remain `UNKNOWN` until corresponding drive manuals/as-built/commissioning evidence is inspected.

## Community contrast case

`COMMUNITY-REPORTED` — A February 2025 LinuxCNC EtherCAT forum thread describes StepperOnline/LeadShine EL7 drives without STO where the builder instead feeds servo AC through a contactor in the safety-relay/E-stop loop. E-stop therefore removes drive mains and also drops the drives from EtherCAT, creating a control/recovery consequence. Source:

https://forum.linuxcnc.org/ethercat/55333-e-stop-and-ethercat-drives-going-offline

This is useful as a human teaching contrast: the physical safety action and LinuxCNC/EtherCAT recovery behavior are separate engineering questions. Do not elevate forum opinion about adequacy/compliance to authoritative safety truth.

## LinuxCNC upstream boundary

`DOC-CONFIRMED` — LinuxCNC's public repository README explicitly warns against relying on software alone for safety and states that machinery capable of harming people needs provisions for removing motor power before people enter danger areas. This supports the course boundary but does not specify a machine-specific safety architecture.

## SIM-SAFE-03 use

The human lesson should show two selectable real-world-inspired patterns:

1. drive has explicit STO: independent safety device operates STO A/B while LinuxCNC receives status/diagnostics;
2. drive lacks STO: an external switching/energy-removal strategy may be needed, and doing so can cause ordinary fieldbus/control recovery consequences.

The lesson must not imply that STO guarantees a stopped/held gravity load, removes all electrical energy, or is interchangeable with mains isolation. Those claims depend on the drive and hazard.

## Next evidence

Before freezing the exact SIM-SAFE-03 behavior:
1. identify exact drive models corresponding to the MH400E drawing and fetch their STO manual sections;
2. inspect the drawing revision/build thread for as-built or commissioning confirmation;
3. preserve any gap between drawing intent and physical validation;
4. keep timing/stopping/load-holding values out of the simulator until exact evidence exists.

No compute was required for this research pass.
