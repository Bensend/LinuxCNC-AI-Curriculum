# Reset-device location, visibility, and restart-authority study

Date: 2026-09-17
Course: 4000-series safety/design curriculum — independent Lane B

## Purpose

Close a human-machine-interface failure path that remains independent of the current asymmetric power-restoration work: a logically correct reset/restart sequence can still be unsafe if the person acknowledging the protective demand cannot establish that the protected space is clear, can operate reset from inside the hazardous area, or if reset is allowed to collapse into START.

This study is architecture-focused. It does not assign an OpenPressBrake reset-button location, stopping distance, PL/SIL, hydraulic state, or visibility geometry without machine-specific evidence.

## Evidence provenance

- **DOC-CONFIRMED — SICK deTec4 C4P operating instructions, 8026678/1RXH/2025-07-07:** restart interlock prevents automatic restart after a safeguard response. The reset pushbutton is located outside the hazardous area. The machine control must require the machine start button after reset; OSSD return after reset must not itself restart the machine.
- **DOC-CONFIRMED — SICK C4000 Standard/Advanced operating instructions:** where the internal restart interlock is used, the reset button must be outside the hazardous area, not operable from inside it, and the operator must have full visual command of the hazardous area. The documentation warns that applications where a person can stand behind the light curtain require restart-interlock treatment.
- **DOC-CONFIRMED — Pilz PNOZmulti special-applications manual:** for muting reset/override, the danger zone and muting station must be visible from the control position and the zone must be identified as clear before operation. The override is fixed outside the danger zone and uses hold-to-run behavior.
- **DOC-CONFIRMED — Pilz emergency-stop guidance:** resetting the actuated E-stop device must not automatically restart the machine; it prepares the machine for restart. Where the full operating range cannot be checked from the E-stop location, additional restart/start controls can be required by the risk assessment.
- **INFERENCE — curriculum architecture:** a reset device is not merely a Boolean input. Its physical location, ability to view the relevant hazard zone, resistance to operation from inside the zone, and separation from START are part of the complete safety-function interface.
- **UNKNOWN — OpenPressBrake:** actual reset device(s), viewing position, blind spots, rear/side access, guard/light-curtain geometry, mode-specific reset span, reset wiring, reset edge semantics, and whether additional presence sensing or trapped-person protection is required.

## Frozen distinctions

**PROTECTIVE DEVICE CLEAR != HAZARD ZONE VERIFIED CLEAR != RESET ACCEPTED != SAFETY AUTHORITY AVAILABLE != ORDINARY CONTROL REARMED != START COMMAND != MOTION.**

A reset acknowledgement proves only what the validated reset architecture allows it to prove. It is not proof that hydraulic pressure is absent, a ram is mechanically restrained, all guards are closed, a drive is torque-free, or every person has left every hazard zone.

## Architecture questions

For every safety reset/restart function, record:

1. What protective demand is being acknowledged?
2. What exact hazard zone/span does that demand control?
3. Can a person remain inside or behind the protective device after the sensing field becomes clear?
4. From the reset location, can the operator inspect the entire relevant zone without relying solely on an HMI/camera/status bit?
5. Can reset be actuated from inside the hazardous zone, intentionally or by reaching through/around a guard?
6. Does reset require a deliberate transition rather than accepting a permanently asserted or shorted input?
7. Does reset merely restore safety readiness, or can it also energize a final element?
8. Is a separate ordinary START/rearm action required after reset?
9. Can a stale LinuxCNC/HAL/FPGA command survive reset and become effective when safety authority returns?
10. If the zone cannot be fully observed, what independent design measure prevents an unseen person from being exposed at restart?

## Failure-path worksheet

| Failure path | False-safe assumption | Required design/validation question |
|---|---|---|
| Reset button inside hazard zone | `operator pressed reset -> zone clear` | Can reset be physically operated while a person remains exposed? |
| Reset outside zone but blind corner exists | `outside location -> adequate observation` | Can every relevant access/pinch/crush area actually be inspected from that position? |
| Light curtain clears behind entrant | `field clear -> nobody inside` | Is stand-behind/encroachment possible, and if so what restart interlock/presence measure addresses it? |
| HMI reset from remote panel | `status screen says clear -> physical zone clear` | What physical observation or validated presence-detection architecture supports remote acknowledgement? |
| Reset and START share one action | `reset is harmless acknowledgement` | Can the same act cause hazardous motion or energization? If so, redesign the sequence. |
| Reset input stuck/shorted | `reset asserted -> deliberate human action` | Does the selected safety logic require a valid edge/release sequence and diagnose inappropriate static state where required? |
| Reset button held during power restoration | `power-up healthy -> reset intentional` | Does cold-start behavior accept a pre-existing reset state? Validate the actual device/configuration. |
| Multiple zones share one reset | `one clear zone -> all zones clear` | Is the reset span intentionally matched to all hazards it releases? |
| Local reset after E-stop release | `E-stop released -> machine safe to restart` | Has the initiating condition been resolved and are all relevant protective functions ready? |
| Camera-only visibility | `camera image -> direct zone-clear proof` | What happens on frozen image, latency, obstruction, camera power/network loss, or wrong view? Treat ordinary video as assistance unless a validated safety function says otherwise. |
| Maintenance person behind guard | `guard closed/field clear -> maintenance complete` | What personnel-accounting/LOTO/permit boundary prevents restart while servicing remains active? |
| LinuxCNC command remains TRUE | `safety reset -> operator wants old motion` | Require ordinary-command freshness/rearm; safety reset is not process START. |

## Practical OpenPressBrake application rule

The independent safety system owns personnel-safety reset acceptance. LinuxCNC/HAL/FPGA may display `RESET REQUIRED`, request a normal-control rearm, invalidate stale commands, and provide diagnostics, but ordinary software must not become the sole authority that decides a protected space is clear.

A practical commissioning walkdown should physically challenge each reset point with the machine incapable of hazardous motion: stand at the intended reset location, inspect the complete associated zone, attempt legitimate reach paths from inside/behind the safeguard, identify blind spots and alternate entrances, and document exactly what the reset releases. Any later guard, table, tooling, cabinet, camera, fixture, material-flow, or access change that obstructs the view or changes the hazard span invalidates that observation and triggers revalidation.

## Validation prompts

- Trigger each protective device separately and prove the intended reset span.
- Confirm clearing the protective device alone does not create motion.
- Confirm reset alone does not create motion.
- Confirm a separate deliberate START/rearm is required where the architecture intends it.
- Hold or simulate a stuck reset input during a controlled nonhazardous validation and establish actual safety-device behavior from manufacturer documentation/test evidence.
- Challenge power restoration with reset already asserted; do not assume edge semantics.
- Challenge a maintained ordinary motion/run command through reset and prove stale-command policy.
- Perform a physical line-of-sight walkdown for every reset position after tooling/guarding/access changes.
- Treat inability to see or otherwise safely account for the relevant protected space as a design problem, not an operator-training workaround.

## What this does not claim

This artifact does not claim that every machine must use one physical hardwired reset button, that cameras can never be part of a validated architecture, that every E-stop requires a second reset button, or that one manufacturer's restart behavior applies universally. It records manufacturer-supported patterns and turns them into questions that the actual machine design must close.

## Precise next-work checkpoint

Find a professional machine/cell implementation that exposes reset-button placement and zone visibility together with safety logic and final-element restart behavior. Trace `protective demand -> stop -> person may/may not remain in zone -> reset location/visibility -> safety reset -> ordinary START -> final-element re-enable`. Prefer a complete OEM drawing/manual package. If the primary lane reaches that evidence package first, rotate to trapped-person/presence-sensing restart prevention or multi-zone reset-span validation rather than duplicating it.
