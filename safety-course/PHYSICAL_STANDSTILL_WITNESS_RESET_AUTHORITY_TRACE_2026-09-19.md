# Physical standstill witness and reset authority trace

Date: 2026-09-19

## Why this branch

The reset/EDM study closes switching-device feedback and fresh-start semantics, but auxiliary-contact agreement is not a physical hazardous-motion witness. This pass traces a professional safety implementation that directly monitors actual speed/position and verifies abnormal motion while a safe standstill is demanded.

## DOC-CONFIRMED evidence

### Rockwell Safe Brake Control / SS2 application

Rockwell `SAFETY-AT178C-EN-P` shows an SS2/SOS implementation using safety feedback that includes actual speed/position. A standard Motion Axis Stop initiates controlled deceleration, while the safety function monitors deceleration and then transitions into SOS standstill monitoring after the configured standstill/check conditions. The documentation explicitly notes that the standstill threshold can precede true zero speed, so `standstill threshold reached` must not be casually rewritten as `zero physical velocity`.

Source: Rockwell Automation, `Safe Brake Control (SBC) Safety Function Application Technique`, SAFETY-AT178C-EN-P, February 2021, retrieved 2026-09-19: https://literature.rockwellautomation.com/idc/groups/literature/documents/at/safety-at178_-en-p.pdf

### Rockwell ArmorKinetix validation checklist

The current ArmorKinetix safe-monitor validation checklist makes the physical witness explicit. During SS2/SOS validation it trends actual speed/position and the safety limits. While the system is in standstill, the validation deliberately commands motion that violates the standstill deadband and requires a standstill-position fault plus initiation of STO. It separately verifies that a Start command while the system is stopped and sensor subsystems remain safe does not re-energize STO, and it exercises Reset separately.

Source: Rockwell Automation, `ArmorKinetix Safe Monitor Functions Safety Reference Manual`, publication 2198-RM007A-EN-P, June 2023, retrieved 2026-09-19: https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/2198-rm007_-en-p.pdf

### Rockwell zero-speed / safe-speed implementation

Rockwell `SAFETY-AT152` documents a PowerFlex 750 safe-speed-monitor implementation in which wiring faults cause STO/safety-contactor dropout and the system cannot reset until the fault is cleared and the input is cycled. Safety-function feedback can prevent restart when its expected state is not present.

Source: Rockwell Automation, `Zero Speed, Safe Limited Speed, and Safe Direction Safety Function Application Technique`, SAFETY-AT152, retrieved 2026-09-19: https://literature.rockwellautomation.com/idc/groups/literature/documents/at/safety-at152_-en-p.pdf

## Frozen lesson

`EDM/CONTACTOR FEEDBACK SAFE != ACTUAL MOTION SAFE`

`STOP COMMAND ISSUED != DECELERATION MONITORED != STANDSTILL THRESHOLD REACHED != TRUE ZERO SPEED != STANDSTILL MAINTAINED`

`SAFE STANDSTILL VIOLATED -> SAFETY FAULT / STO REACTION`, in the cited Rockwell implementation.

`START COMMAND PRESENT WHILE SAFETY FUNCTION STILL DEMANDS SAFE STATE != MOTION AUTHORITY`.

The physical witness must match the hazard. Speed/position feedback is meaningful for motion, but does not prove a suspended/gravity load is mechanically retained, hydraulic stored energy is safe, a guard area is personnel-clear, or a press-brake ram satisfies machine-specific stop-performance requirements.

## Adversarial review

A dangerous simplification would be to call a drive's configurable `standstill speed` value `zero speed`. Rockwell explicitly distinguishes the programmable standstill threshold from true zero speed. Curriculum language must therefore preserve the exact physical quantity actually monitored.

Likewise, successful STO response to a standstill violation proves the validated motor-drive safety reaction in that architecture; it does not prove that OpenPressBrake's hydraulic ram is retained or pressure-safe.

## OpenPressBrake transfer boundary

Use this as the generic proof pattern:

`SAFETY DEMAND -> CONTROLLED/SAFE REACTION -> PHYSICAL MOTION WITNESS -> LIMIT/STATE MAINTAINED -> FAULT ON VIOLATION -> REPAIR/CORRECTION -> RE-PROOF -> REARM -> APPLICATION-SPECIFIC FRESH START`.

Do not assign OpenPressBrake a speed threshold, stop time, stop distance, STO topology, encoder diagnostic coverage, PL/SIL/category/DC/CCF or hydraulic safe-state meaning from these drive examples.

## Next work

Highest-value continuation remains the primary press-brake hydraulic evidence gap: seek OEM/manifold service evidence that exposes a serviced holding/safety valve's individual retaining-function challenge without companion masking and a physical ram/load witness. If public evidence remains exhausted, continue the physical-witness branch into brake/load retention or another complete professional machine implementation rather than synthesizing an unsupported hydraulic test.
