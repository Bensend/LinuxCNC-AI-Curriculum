# Three-Position Enabling Device, Panic Release, and Setup-Motion Authority Study

Date: 2026-09-20
Lane: independent safety curriculum Lane B
Status: durable source/documentation study

## Why this lane

The primary safety lane is currently advancing hydraulic press-brake two-hand total stop-response and physical final-element tracing. This study deliberately uses a different device family and evidence package: three-position enabling devices used for adjustment, troubleshooting, calibration, and other justified work requiring presence in a danger zone while a normal safeguard is suspended.

## Evidence labels

- **SOURCE-CONFIRMED** — stated by an authoritative manufacturer/source cited below.
- **DOC-CONFIRMED** — confirmed by repository documentation.
- **TEST-CONFIRMED** — established by an executed test. None claimed here.
- **COMMUNITY-REPORTED** — community evidence only. None relied on here.
- **INFERENCE** — engineering conclusion derived from source-confirmed facts; not a machine-specific fact.
- **UNKNOWN** — requires application design, measurement, or machine evidence.

## Source trace

### Pilz PITenable

**SOURCE-CONFIRMED:** Pilz describes PITenable as a manually operated three-level enabling switch for work inside a plant or machine danger zone when the protective effect of a safeguard must be suspended. Its three positions are Off-On-Off: the middle position enables the function, while release or full depression returns to the protective/off state. Pilz explicitly ties the fully depressed position to protection when an operator overreacts in shock/panic.

Source: https://www.pilz.com/en-GB/products/operating-and-monitoring/control-and-signal-devices/pitenable-enabling-switch

### Rockwell GripSwitch application

**SOURCE-CONFIRMED:** Rockwell's GripSwitch application note describes a three-position trigger whose safety contacts close only in the center position; further squeezing or releasing opens them. Critically, release from the fully squeezed position does not re-close the safety contacts. Rockwell lists visual observation, minor adjustment, troubleshooting, calibration, tool changes, and lubrication as example tasks and says risk assessment determines any required reduced-performance mode.

Source: https://literature.rockwellautomation.com/idc/groups/literature/documents/at/safety-at016_-en-p.pdf

## Architecture freeze

**INFERENCE:** The enabling device is permission inside a separately constrained setup/maintenance safety architecture; it is not an ordinary run command and not proof that the machine is safe merely because the center position is held.

Freeze these distinctions:

- **SETUP MODE SELECTED != NORMAL SAFEGUARD SUSPENSION AUTHORIZED**
- **ENABLING DEVICE PRESENT != ENABLING DEVICE SAFETY CHANNELS HEALTHY**
- **CENTER POSITION DETECTED != PERMITTED MOTION REQUESTED**
- **CENTER POSITION + JOG REQUEST != SAFE SPEED/DIRECTION/AXIS CONDITIONS PROVED**
- **RELEASE != FULL SQUEEZE != CENTER POSITION** even though both outer positions must remove enabling authority
- **FULL SQUEEZE THEN RELAX != AUTOMATIC RE-ENABLE**
- **ENABLING AUTHORITY != PRODUCTION AUTHORITY**
- **LINUXCNC JOG/START COMMAND != PERSONNEL-SAFETY AUTHORITY**

A practical authority chain is therefore:

`deliberate setup/service mode -> required safeguard-suspension conditions -> independent safety evaluator -> valid enabling-device center state -> separately deliberate permitted motion request -> constrained motion authority -> monitored safety conditions -> final element -> physical machine behavior`

Any production transition must separately restore the required safeguards and safety conditions and require fresh ordinary production initiation.

## Failure-path analysis

1. **Release while motion is occurring.** Expected architecture: enabling permission is removed; the applicable safety response occurs independently of LinuxCNC deciding to stop.
2. **Panic/full squeeze while motion is occurring.** Expected architecture: full depression removes permission just as release does.
3. **Full squeeze followed by relaxation toward center.** Rockwell evidence is especially useful: the contacts do not simply re-close on release from the fully squeezed state. A panic action must not turn into a fresh enabling command merely because grip force relaxes.
4. **Device held in center before mode entry or power restoration.** Treat automatic acquisition of motion authority as unsafe until the application's reset/restart and mode-transition design explicitly proves otherwise.
5. **Stale LinuxCNC jog/start/cycle command.** Safety restoration must not reinterpret retained ordinary-control state as a fresh hazardous-motion request.
6. **One enabling channel fault or wiring fault.** Required diagnostic behavior is application/evaluator-specific and remains UNKNOWN until traced to the selected safety architecture.
7. **Center position valid but speed/direction/axis is wrong.** Enabling-device validity does not prove SLS, safe direction, axis selection, or coupled-axis hazard control.
8. **Normal guard/light curtain remains suspended after setup exit.** Removing the enabling device or leaving setup mode is not by itself proof that normal safeguarding has been restored and validated.
9. **Device defeated/clamped/taped.** The architecture and commissioning procedure must challenge foreseeable defeat rather than treating ergonomic presence as proof of a live operator.
10. **Safety evaluator says enabled but final element or machine fails to respond correctly.** Logic-state evidence remains separate from physical final-element/motion proof.

## Commissioning / validation questions

A machine-specific validation plan should answer, without inventing values:

- Which modes permit the enabling device to matter?
- Which normal safeguards may be suspended in each such mode, and which remain active?
- Does position 1 remove enabling authority?
- Does position 2 establish enabling permission but still require a separate deliberate jog/motion command?
- Does position 3 remove enabling authority?
- After position 3, can relaxation toward position 2 create authority without the required release/requalification sequence?
- What happens if the device is already held at power-up, safety reset, or mode transition?
- What happens if a LinuxCNC/HMI jog/start command is already asserted when enabling permission returns?
- Which speed, direction, axis, travel, force, or other constraints are independently safety-monitored for the task?
- Does an enabling-device channel fault inhibit the relevant hazardous motion and require the documented recovery?
- Does release/full squeeze produce the required response at the actual final element and physical machine?
- Can the normal safeguard be proven restored before production rearm?
- Is a fresh ordinary production initiation required after leaving setup/service mode?

## OpenPressBrake boundary

**UNKNOWN:** OpenPressBrake's eventual need for a three-position enabling device, allowed setup tasks, mode selector architecture, permitted axes/directions, safe speeds, response times, stopping performance, hydraulic behavior, final elements, safety category/PL/SIL, and exact reset/requalification sequence.

Do not copy example speeds, timing, stopping distances, or performance claims from a vendor application into OpenPressBrake.

**INFERENCE:** LinuxCNC/HAL/FPGA may request setup motion and display diagnostics, but personnel-safety authority for guard suspension, enabling-device validity, constrained-motion conditions, and the safety response belongs in the independent safety architecture.

## Precise next evidence target

Find a complete professional machine implementation showing:

`mode selector -> safeguard suspension decision -> three-position enabling device dual-channel evaluation -> separate hold-to-run/jog request -> safety-monitored motion constraint -> deliberate release and panic/full-squeeze challenges -> actual final-element response -> physical motion witness -> required requalification -> safeguard restoration -> safety rearm -> fresh ordinary production start`

Prefer a commissioning or OEM service procedure that explicitly tests the full-squeeze-to-relax behavior, held-at-power-up/mode-entry behavior, or stale motion command.