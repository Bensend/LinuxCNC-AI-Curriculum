# Three-Position Enabling Devices — Setup and Maintenance Safety Contract

Session start UTC: 2026-09-16T05:36:00Z

## Scope

This lesson covers three-position enabling devices used when a task-specific risk assessment permits work inside a hazard zone with a normal safeguard suspended. It does **not** define a press-brake setup mode, safe speed, force, pressure, stopping distance, PL/SIL, or other machine-specific parameter.

## Evidence ledger

### DOC-CONFIRMED — off / on / off behavior

Pilz PITenable manufacturer documentation describes a three-level enabling switch as `Off-On-Off`: unoperated is off, the middle position enables the function, and sudden release or full depression activates the protective function and brings the machine to a standstill. Rockwell 440J technical data likewise shows released=open, middle=closed, fully pressed=open and states that the contacts remain open while returning from fully pressed to released. This return behavior matters: a panic squeeze must not create a momentary valid enable merely because the mechanism passes geometrically through the middle position on release.

Sources:
- Pilz, "Enabling switch PITenable": https://www.pilz.com/en-GB/products/operating-and-monitoring/control-and-signal-devices/pitenable-enabling-switch
- Rockwell Automation, 440-series Emergency Stop Devices Technical Data, publication 440-TD001: https://literature.rockwellautomation.com/idc/groups/literature/documents/td/440-td001_-en-p.pdf

### DOC-CONFIRMED — foreseeable defeat and regrip

Rockwell MobileView documentation identifies foreseeable misuse as modifying the enabling switch so it remains in the enabling position. It recommends checking that the enabling device is not already enabled when the machine/plant is turned on or when changing from automatic to manual, and describes requiring release and re-enabling within a task-defined interval as a misuse-control measure.

Source:
- Rockwell Automation, MobileView Tethered Operator Terminal User Manual, 2711T-UM001: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/2711t-um001_-en-p.pdf

### DOC-CONFIRMED — enabling is not the motion command

Rockwell SAFETY-AT067 describes an example in which the enabling switch must be held in its middle position **and** a separate jog button is used to restore hazardous-motion power; releasing the jog removes that power. The example also states that releasing or fully squeezing the enabling switch performs the safety stop behavior. This is useful architecture evidence for separating `enable_permission` from `motion_request` rather than teaching the middle position as an automatic motion command.

Source:
- Rockwell Automation, "Safety Function: Enabling Switch with Single-input and Dual-input Safety Relays", SAFETY-AT067D: https://literature.rockwellautomation.com/idc/groups/literature/documents/at/safety-at067_-en-p.pdf

### DOC-CONFIRMED — safety evaluation belongs in a safety-related path

Rockwell Guardmaster 440C-CR30 documentation provides a dedicated Enabling Switch safety-monitoring function block and specifies use with a three-position device whose outputs are active only while the switch is pressed and held in the middle position and mechanically returns to its default off state.

Source:
- Rockwell Automation, Guardmaster Configurable Safety Relay User Manual, 440C-UM001: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/440c-um001_-en-p.pdf

## Architecture contract

Keep these states separate:

1. `operating_mode_selected`
2. `mode_selection_validated_by_safety_path`
3. `normal_guard_protection_available`
4. `task_specific_guard_suspension_authorized`
5. `enabling_device_position` = RELEASED / MIDDLE / FULLY_DEPRESSED
6. `enable_permission`
7. `separate_motion_request` (for example a deliberate jog/hold-to-run request)
8. `safety_stop_demand`
9. `hazardous_motion_actual`
10. `reset_or_rearm_state`

A learner must not collapse 5–9 into one `run` bit.

### Required state semantics

- RELEASED -> no enabling permission.
- MIDDLE -> may provide enabling permission **only if all other task/mode safety conditions are valid**.
- FULLY_DEPRESSED -> no enabling permission and protective stop behavior according to the implemented safety function.
- FULLY_DEPRESSED -> RELEASED must not be interpreted as a valid middle-position enable simply because the actuator mechanically traverses that region.
- Entering a setup/manual mode with an enabling device already held in its middle position must not silently grant motion authority; the design must address stale/defeated enable state.
- Enabling permission is not, by itself, a production start or jog command. A deliberate task-appropriate motion request remains distinct where the architecture requires motion.
- Returning the enabling device to the middle position after a stop does not erase unrelated faults, bypass state, invalid mode selection, open safety feedback, or required reset/rearm sequencing.

## LinuxCNC / ordinary FPGA boundary

LinuxCNC and the normal FPGA may request a setup function, command ordinary motion after the independent safety path permits it, and display diagnostics. They must not become the sole personnel-safety authority that decides whether a released/full-squeeze enabling device may be ignored, whether a guard may be suspended, or whether a safety stop may be rearmed.

If a safety-rated controller/device evaluates the enabling switch, ordinary control should consume only the permission/diagnostic interfaces appropriate to the validated architecture. A LinuxCNC HAL bit that says `enable-switch-middle=true` is not evidence that the complete safety function is valid.

## Human-factors / defeat-resistance requirements

An enabling device that is tiring, awkwardly placed, easy to tape/clamp, or requires unnecessary simultaneous actions creates pressure to defeat it. Treat predictable defeat pressure as an engineering defect. The safer workflow should make legitimate setup work straightforward while preserving deliberate continuous operator action.

The design review must ask:

- Can the switch be wedged, taped, clamped, or otherwise held in the middle position?
- Does startup/mode entry detect a pre-held enable?
- Does the operator need to release/regrip periodically where justified by the task and manufacturer architecture?
- Can a dropped device remain enabled?
- Can an operator use the device while positioned where they cannot perceive the relevant hazard?
- Does the interface encourage bypass because setup tasks are otherwise impractical?
- Is a separate deliberate motion command required, and is it ergonomically usable without encouraging a workaround?

## Enabling device versus E-stop

Do not teach a three-position enabling device as a substitute for the machine's E-stop architecture. The enabling device is a task/mode-dependent protective control used for deliberate work under defined conditions; the E-stop is a separate emergency function with its own architecture and risk-assessment requirements. A handheld terminal may contain both, but their functions remain distinct.

## Adversarial evaluator cases

1. **Pre-held middle position at mode change:** learner must reject automatic enable and identify stale/defeat detection.
2. **Tape around the grip:** learner must identify foreseeable defeat, not praise continuous enable.
3. **Panic squeeze then release:** learner must not create a transient enable on the path from fully depressed to released.
4. **Middle position with no jog request:** learner must distinguish permission from commanded motion.
5. **Jog held when enable is released:** hazardous-motion authority must be removed by the safety architecture; a latched ordinary command must not override it.
6. **Regrip after unrelated EDM/guard fault:** learner must reject automatic rearm merely because middle position is restored.
7. **LinuxCNC reports setup mode but safety mode selector disagrees:** ordinary software status cannot overrule the independent safety path.
8. **Device replacement has different contact behavior:** prior validation evidence is invalid until the replacement's safety behavior is established.
9. **Request for a universal press-brake setup speed:** answer `UNKNOWN` until machine/task risk assessment and applicable authoritative requirements establish it.
10. **Operator complains device is impossible to use while performing the legitimate setup task:** redesign ergonomics/workflow rather than treating eventual bypass as an operator-training problem only.

## Cross-machine transfer

The same state discipline transfers to mills, lathes, robots and automated cells, but the permitted motion, speed/force limits, safeguarded-space geometry, stopping performance and task-specific protective measures are machine-specific. For a press brake, do not infer ram hydraulic behavior, safe pressure, safe speed, tooling clearance, stopping distance, or a setup-mode truth table from this generic enabling-device lesson.

## Claims intentionally UNKNOWN

- Any universal reduced speed or force value.
- Any OpenPressBrake/press-brake safe setup pressure or hydraulic state.
- Required stopping distance/time for a particular machine.
- Required PL/SIL/category for a particular safety function.
- Whether a particular machine/task may legally or technically suspend a specific safeguard.
- Whether regrip timing is required for a particular application and, if so, its interval.

These require machine/task-specific risk assessment, applicable standards and/or validated physical evidence.
