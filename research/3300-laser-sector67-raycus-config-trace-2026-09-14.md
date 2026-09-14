# 3300-L1 — Sector67 Raycus fiber laser downloadable configuration trace

Date: 2026-09-14
Source repository: `Sector67/fiber-laser-control`
Pinned public revision: `938b501bfd092505170af8146c1b77a8564754d1` (2024-05-07)
Status: CONFIG-CONFIRMED + PROJECT-DOC-CONFIRMED deployed proof-of-concept behavior

## Why this matters

Earlier L1 evidence had only community prose for a 500 W Raycus fiber retrofit. This repository exposes the actual LinuxCNC/QtPlasmaC configuration, custom HAL, custom G-code filter and project documentation. It therefore upgrades several fiber-laser claims from COMMUNITY-REPORTED to inspectable configuration evidence.

The project reports successful basic cuts in stainless and mild steel. It should still be treated as a machine-specific proof of concept, not as a canonical production fiber architecture.

## Laser-source control contract

The project uses a Raycus C500 in `AD` mode with three physically distinct source-control surfaces documented by the project:

1. **0-10 V analog power request**;
2. **24 V modulation/emission input**;
3. **24 V laser-enable input**.

The source also exposes a +24 V **laser-ready** output. The project documentation explicitly says that powering the source while LinuxCNC is already asserting laser-enable causes the source to enter a fault state. Their current operational workaround is procedural: power the laser source first, then enter LinuxCNC machine-on state.

The available `laser-ready` input had not yet been wired into machine-on qualification because the builders also wanted to test motion with the laser source off.

This is a strong commissioning lesson: **source READY, controller machine-on, laser enable and emission/modulation are different authority/readiness layers.** A production architecture should not collapse them into one `torch-on` Boolean.

## Power command call flow

`config/custom.hal` proves this command path:

`QtPlasmaC material cut_amps -> custom G-code filter -> M03 spindle speed -> spindle.0.speed-out-abs -> hm2_7i92.0.pwmgen.00.value -> 2 kHz PWM -> external PWM-to-0-10V converter -> Raycus analog power input`

The custom filter rewrites each `M03 $0 ...` to:

`M03 $0 S#<_hal[qtplasmac.cut_amps-s]>`

so the QtPlasmaC material table's `cut_amps` field is repurposed as laser-power percentage/provenance.

`custom.hal` then sets PWM scale to 100 and connects `spindle.0.speed-out-abs` to the Mesa PWM value. The generated HAL config sets PWM frequency to 2000 Hz.

`plasmac:torch-on` enables the PWM generator, so process torch state gates analog power generation. The project documentation states that an external PWM-to-0-10 V converter produces the actual analog command.

### Consequence

This configuration does **not** use upstream `laserpower.comp`. It uses QtPlasmaC material semantics + spindle speed + HostMot2 PWM. That further confirms `laserpower.comp` is optional infrastructure, not mandatory architecture.

## Capacitive height-sensor call flow

The project uses a BCL-AMP capacitive sensor whose output is a variable-frequency pulse train. The documentation records reverse-engineered electrical behavior and a Schmitt-trigger cleanup stage before Mesa input.

The LinuxCNC config uses HostMot2 encoder channel 0 in **counter mode**, with the encoder digital filter disabled for the high-frequency input. `laser_cutter.hal` exposes encoder position/count/velocity signals. `custom.hal` scales and clamps encoder velocity, then maps the result into QtPlasmaC's `arc-voltage-in` surface.

The resulting software path is:

`head capacitance -> BCL-AMP variable-frequency output -> Schmitt trigger -> Mesa encoder A input/counter mode -> encoder velocity -> limit/scaling -> QtPlasmaC arc-voltage surface -> adapted height-control logic`

This is an intentional semantic adaptation: the physical quantity is **capacitive standoff**, not plasma arc voltage.

## Probe and Arc OK compatibility glue

`custom.hal` implements two explicit compatibility adaptations:

- synthetic ohmic-probe state from a threshold comparator on the capacitive sensor's encoder velocity-RPM surface;
- an always-true fake Arc OK produced by a `not` component driven by constant false.

These are machine-specific substitutions used to satisfy QtPlasmaC interfaces. They are not evidence that fiber laser has a physical plasma Arc OK or ohmic process.

The project documentation confirms the same behavior and states that the capacitive signal changes sharply when the head touches the material, making the synthetic probe usable for their configuration.

## Gas-assist implementation

The inspected configuration uses a deliberately simple gas policy:

`program running in AUTO -> timedelay -> gas-solenoid`

The on-delay is zero and off-delay is one second. Project documentation calls this control "very naive" and explains that the initial probe time is currently long enough for gas to begin flowing before the cut.

The documentation explicitly contemplates a future process-qualified delay, potentially using Arc OK-style logic to wait for gas before laser emission if a more valuable gas is used.

This means the current configuration is evidence that gas is a separate process output, but **not** evidence for a production assist-gas pressure/readiness contract.

## Light-tree / operator-state model

The project intentionally distinguishes visual state:

- green: machine power;
- orange: QtPlasmaC torch enable AND machine-on — laser could be allowed to fire;
- red: program running/paused or torch on.

The builders note that test programs are sometimes run with torch disabled. That operational practice reinforces the distinction between program execution and emission authority.

These indicators are operator diagnostics, not functional-safety devices.

## Realtime execution order visible in HAL

The generated HAL loads motion, PIDs, `plasmac`, HostMot2 and schedules the servo thread broadly as:

`hm2 read -> motion command handler -> motion controller -> axis/spindle PID calculations -> plasmac -> hm2 write`

Custom components for capacitive limiting, logic, delay, synthetic probe and Arc OK are added from the custom HAL. Any future detailed timing claim must preserve the actual final `addf` sequence after all included HAL files are loaded; this artifact does not justify assuming all custom logic executes before `plasmac` without reconstructing the full include/load order.

## Material/recipe authority

This machine reuses QtPlasmaC's material infrastructure rather than creating a new laser recipe schema. The custom filter maps `qtplasmac.cut_amps-s` into M03 spindle speed/power.

The preserved `M190` helper still performs material change by setting QtPlasmaC material-change pins and waiting with a timeout.

Therefore recipe provenance on this machine is:

`QtPlasmaC material selection -> material cut_amps field -> custom_filter M03 rewrite -> spindle/PWM laser-power path`

Other plasma-oriented material fields must not automatically be assumed to have physically correct fiber-laser meanings without machine-specific use evidence.

## Source READY gap and startup fault

The most important unresolved machine issue in the preserved documentation is source-readiness ownership:

- Raycus exposes laser-ready;
- the machine does not currently use it to qualify machine-on;
- asserting laser-enable during source power-up can fault the source;
- startup correctness is achieved procedurally.

This is exactly the kind of distinction the final 3300 playbook should preserve:

`controller enabled != source powered != source ready != emission enabled != power requested`.

It is also a stronger future experiment/design-review target than a toy PWM simulation.

## Safety boundary

The project documentation explicitly warns of immediate eye hazards and reports enclosing the system and using cameras. The downloadable config still cannot establish a functional-safety architecture. Software torch/machine signals, diagnostic lights and an enclosure must not be represented as safety-rated interlocks without separate evidence.

## Adversarial review — 10/10

1. Does `plasmac:torch-on` prove the Raycus is ready? **No.** Ready is a distinct source signal and is not integrated into qualification here.
2. Does the fake always-true Arc OK mean fiber laser has physical Arc OK? **No.** It is interface compatibility glue.
3. Is the BCL-AMP measuring arc voltage? **No.** It measures capacitive standoff through a frequency signal mapped onto an existing software surface.
4. Is `cut_amps` physically current in this machine? **No.** The custom filter repurposes it as laser-power percentage/intention.
5. Does the project use native `laserpower.comp`? **No.** Power goes through spindle speed -> Mesa PWM -> 0-10 V conversion.
6. Does PWM enable alone command emission? **No.** The project documents separate source enable/modulation/analog-power inputs.
7. Is gas readiness verified before every cut? **No.** Current gas control is a simple program-running timed delay and the builders describe it as naive.
8. Does the source-ready omission make the project nonfunctional? **No.** It worked via a procedural startup order, but that leaves an architectural readiness gap.
9. Can the final custom component execution order be inferred solely from `laser_cutter.hal`? **No.** Full include/addf order must be reconstructed before timing claims.
10. Does a successful proof-of-concept config define a universal fiber process architecture? **No.** Preserve machine-specific adaptations and unresolved source/gas/focus/readiness boundaries.

## Promotion consequence

L1 now has an inspectable real fiber configuration in addition to native source, CO2 and diode implementations. This is enough to promote the following breadth-level fiber contracts:

- source readiness and emission authority must be separate from numeric power request;
- capacitive height sensing is a distinct physical measurement even when mapped to plasma-oriented software surfaces;
- material/CAM recipe provenance can be adapted but field semantics must be recorded explicitly;
- assist-gas command/readiness and source-ready/fault handling require process-specific integration;
- adapted QtPlasmaC can be practical, but its plasma names are not evidence of plasma physics in a laser.

Do not yet graduate L1. Highest-value remaining laser evidence is a more mature production fiber implementation with integrated source READY/FAULT, gas pressure/selection, focus/pierce sequencing and abort/recovery, plus an implementation using upstream `laserpower.comp` if one is publicly available.
