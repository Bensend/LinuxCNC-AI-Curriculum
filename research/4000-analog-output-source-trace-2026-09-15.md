# 4000 analog-output source trace — 2026-09-15

## Scope
Continue the PWM/analog checkpoint without pretending that a public Mesa board-level schematic has been recovered when only manuals, field wiring, and external KiCad representations are inspectable.

## 7I96S potentiometer-replacement path
Mesa's 7I96S manual defines an isolated three-terminal potentiometer replacement: SPINDLE+, SPINDLE OUT, SPINDLE-. The external drive supplies the reference across +/-; the output wiper is commanded between those rails. Supply difference is 5–18 V. The output is FPGA-PWM driven; 10–20 kHz is preferred, 5–50 kHz accepted. Startup forces the output to SPINDLE- (important for bipolar use).

This is materially different from an internally generated precision 0–10 V DAC. It is attractive for VFDs that expose a potentiometer reference because it inherits the drive-side reference and galvanic boundary.

## 7I77 precision servo path
Mesa 7I77 documentation establishes six +/-10 V servo command outputs, paired floating drive-enable outputs, and a communications watchdog behavior that removes command authority. Public LinuxCNC documentation treats these as smart-serial analog outputs with min/max/full-scale configuration. A 2025 university LinuxCNC testbed publishes KiCad wiring representations for both 7I77 and 7I96S and real motor-controller integration, but those KiCad files model the Mesa boards as interface modules rather than exposing Mesa's internal DAC/analog circuitry.

Therefore the exact internal 7I77 DAC/op-amp/watchdog-to-zero circuit is still an evidence gap. Do not invent it.

## Architecture consequence
Freeze the interface classes, not an unsupported Mesa internal topology:

1. Raw FPGA PWM/PDM: watchdog-gated digital resource.
2. Base-board VFD analog: isolated potentiometer-replacement class, normally 0–10 V when the VFD provides 10 V/COM; startup/fault state must be deterministic at minimum command.
3. Precision +/-10 V servo: daughterboard/variant using a dedicated bipolar DAC + output amplifier + independent output-authority/enable gating. Exact component topology remains to be selected from semiconductor reference designs/datasheets rather than reverse-engineered from undocumented Mesa internals.

## Failure-state requirements
- Communications/watchdog loss must force raw PWM inactive and analog command to defined minimum/zero state.
- Recovered communications must not automatically restore stale nonzero analog command.
- Analog command validity is distinct from drive READY/FAULT, spindle-at-speed, encoder feedback, actual motion and STO.
- Loss of the external VFD reference on a potentiometer-replacement channel is a separate diagnosable condition if hardware sensing is added; output-command state alone cannot prove reference presence.
- Precision +/-10 V daughterboard requires startup-zero analysis, DAC power-up state, op-amp saturation/fault analysis and drive-enable ordering before freeze.

## Evidence boundary
This pass found authoritative functional behavior and a real open KiCad integration project, but not a public internal 7I96S/7I77 board schematic suitable for direct component copying. That absence is recorded as a bounded gap, not filled by inference.
