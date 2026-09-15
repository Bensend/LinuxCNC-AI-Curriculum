# 4000 PWM / analog interface first pass — 2026-09-15

Status: ARCHITECTURE PASS; exact analog circuit not yet frozen

## Why this is a separate block

LinuxCNC's FPGA can emit PWM/PDM command information, but a raw logic waveform, an isolated 0-10-V spindle command and a precision +/-10-V analog servo command are three different electrical products. They should not be collapsed into one vague "analog output".

## Proven Mesa reference patterns

### Isolated spindle / VFD command

The Mesa 7I96S implements an isolated potentiometer-replacement analog output. The field side has SPINDLE+, SPINDLE OUT and SPINDLE-. The controlled output can move between the externally supplied SPINDLE- and SPINDLE+ rails. Mesa documents 5-20 V across those rails and notes that a bipolar range is possible when the field rails themselves are bipolar.

The field analog stage is driven by an FPGA PWM output. Mesa specifies an optimum PWM frequency of roughly 10-20 kHz, with 5-50 kHz acceptable; lower frequency increases ripple and higher frequency worsens linearity.

This is a strong production reference for a low-cost isolated VFD/spindle interface where the drive already supplies its analog reference rails.

### Precision +/-10-V analog servo command

The Mesa 7I77 provides six +/-10-V servo-command outputs and explicitly pairs them with drive-enable outputs. More importantly, it contains a local communications watchdog: if more than 50 ms elapses between host communications to the analog section, analog outputs are set to 0 V and drive-enable optocouplers are turned off. Mesa explicitly says this does not replace an E-stop circuit that removes servo power.

That is directly consistent with the curriculum's authority model: command value, command freshness, drive enable and safety authority are separate.

## Working partition

### A. Raw PWM/PDM logic outputs

Purpose: external modules, laser/drive interfaces or future custom daughterboards that need timing-domain modulation rather than an analog voltage.

Requirements:
- FPGA-generated;
- configurable frequency/mode in firmware;
- global watchdog/output-authority consumed locally;
- deterministic inactive state on watchdog/reset;
- exposed only through a protected/level-translated interface appropriate to the selected connector;
- never described as an analog voltage output.

### B. 0-10-V / potentiometer-replacement spindle/VFD output

Preferred base architecture: isolated field-side potentiometer-replacement channel inspired by Mesa 7I76/7I96S rather than a ground-referenced RC filter directly tied to FPGA ground.

Advantages:
- breaks common ground-loop path;
- naturally fits common VFD reference terminals;
- field-side reference can define the output span;
- PWM source can remain under FPGA watchdog authority.

Open work: identify the exact modern isolated analog-switch/opto/DAC topology from inspectable schematics or design a modern equivalent from datasheets; quantify linearity, ripple, startup state and fault behavior.

### C. +/-10-V precision servo command

Treat as a distinct precision analog-servo sub-block. It requires:
- bipolar supply/reference architecture;
- zero-output behavior on watchdog;
- offset/gain calibration;
- output current/load specification;
- deliberate analog grounding and cable shielding;
- paired drive-enable/fault authority;
- prototype noise, drift and fault testing.

Do not derive a claimed precision +/-10-V servo output merely by low-pass filtering the same generic PWM circuit used for spindle speed.

## Working base-board decision

Keep FPGA PWM/PDM resources generic in gateware, but **do not force every analog physical interface onto the base PCB until the exact circuit and machine demand justify it**.

Current preferred packaging:
- at least four watchdog-gated raw PWM/PDM-capable FPGA resources available internally/expansion-side;
- one or two isolated spindle/VFD analog channels are strong candidates for the base board because they are broadly useful;
- multi-axis precision +/-10-V servo output should remain a dedicated analog daughterboard/variant unless machine inventory shows it is a core requirement.

This preserves a universal digital core without loading every controller with precision bipolar analog hardware that many step/dir machines never use.

## Authority/failure contract

For every actuator-facing PWM/analog channel:

`LinuxCNC request -> transport generation/freshness -> FPGA PWM/PDM register -> FPGA watchdog/output authority -> conversion/isolation -> field command`

Watchdog false must force the physical command to its defined inactive state. For a true +/-10-V velocity/torque command this normally means 0 V; for a potentiometer-replacement channel the exact inactive voltage must be defined by the circuit and drive contract, not assumed.

A measured 0-10-V or +/-10-V command proves command voltage only. It does not prove VFD/servo READY, spindle speed, axis motion or process readiness.

## Next evidence needed

1. Inspect an actual 7I76/7I96S or comparable open schematic to identify the isolated potentiometer-replacement circuit rather than inferring implementation from the manual.
2. Inspect an open +/-10-V servo-output schematic (Mesa 7I77 if available or another production-quality reference).
3. Compare PWM-filtered analog versus isolated DAC architectures for resolution, monotonicity, ripple, startup and BOM cost.
4. Freeze channel counts only after the above and machine-inventory review.
5. Preserve the 7I77-style local watchdog-to-zero principle in any analog actuator block.

No simulation is justified at this stage. Datasheet/source schematic analysis and calculations should precede bench testing.
