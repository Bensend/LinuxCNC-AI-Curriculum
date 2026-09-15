# 3900 Emerging / Unusual Machines — breadth + additive first pass — 2026-09-15

## Scope

Breadth-first survey after 3100 reached a clean stop. Candidate classes were ranked for novelty relative to already-covered 3100–3800 work, inspectable LinuxCNC evidence, and transfer value.

## Candidate ranking

1. **Additive / extrusion / hybrid** — selected first. LinuxCNC explicitly advertises 3D-printer support, and `cdsteinkuehler/LinuxCNC-RepRap` provides inspectable HAL plus custom realtime components. This exposes a process-authority problem not already covered by subtractive spindle/tooling tracks: extrusion motion plus thermal measurement/heater authority.
2. **Hexapod / Stewart platform** — strong native support (`genhexkins`) and useful singularity/convergence behavior, but overlaps materially with 3500 custom-kinematics work. Preserve for a later targeted pass rather than using it to duplicate genserkins lessons.
3. **Winding / rotary synchronized processes** — community evidence exists, but the bounded search found less inspectable LinuxCNC-specific implementation source than additive.
4. **Dispensing / pick-and-place / measurement** — useful future candidates if an inspectable production configuration appears.

## Real implementation: LinuxCNC-RepRap

Repository: `cdsteinkuehler/LinuxCNC-RepRap` (public, inspectable).

### Motion/process split

`config/MendelMax.hal` uses `trivkins` plus four step generators. XYZ are ordinary Cartesian motion and the fourth stepgen is an A-axis command path. This is a useful architecture warning: an extrusion/feed actuator can be represented as another coordinated motion coordinate, but that representation alone does not provide process readiness, thermal qualification, material-flow proof, or recovery semantics.

### Temperature acquisition

The project adds a realtime I2C path and `ADC2Temp.comp`. `ADC2Temp` converts a 10-bit thermistor ADC value into temperature only when `NewValue` toggles. The component exposes temperature, but no sample-age, stale-data, open/short-sensor, out-of-table, plausibility, or independent sensor-health output was found in the inspected source.

### Heater authority

`config/custom.hal` connects measured extruder temperature to a generic `comp` block with 0.25 hysteresis, compares it against a setpoint, and drives a parallel-port heater output. The inspected HAL therefore implements simple bang-bang temperature control.

No explicit process gate was found tying extrusion/coordinated feed authorization to:

- temperature-in-range and stable;
- measurement freshness;
- thermistor fault/plausibility;
- heater stuck-on/stuck-off detection;
- thermal runaway / failure-to-heat timeout;
- maximum-temperature trip;
- independent hardware thermal cutoff.

This is not a criticism of the historical project; it is an authority-boundary finding. The configuration proves that LinuxCNC/HAL can host extrusion thermal control, but it must not be promoted as a modern production thermal-safety contract.

## Durable 3900 additive rule

**Temperature value != fresh temperature witness != heater authority != extrusion-ready.**

For a production additive/hybrid architecture, keep at least these concepts distinct:

1. motion/extrusion command;
2. measured temperature value;
3. measurement freshness/plausibility;
4. heater command and actual power authority;
5. thermal ready/stable qualification;
6. thermal fault/runaway protection;
7. material-flow/filament availability where applicable;
8. abort/restart eligibility and process-state reconciliation.

A stale but numerically plausible ADC-derived temperature is especially important: because `ADC2Temp` updates only on `NewValue`, loss of new samples can leave the previous temperature visible unless a separate freshness mechanism exists.

## Hexapod boundary preserved

Official LinuxCNC documentation confirms `genhexkins` provides six-DOF XYZABC mapping and exposes forward-kinematics iteration controls including convergence criterion, iteration limit, maximum error, and last/max iteration observations. That is strong native unusual-machine support, but a deeper pass should focus on a genuinely new question such as convergence/failure authority or switchable-kinematics recovery—not repeat 3500 robot IK work.

## Lab decision

No lab. The first-pass authority gaps are directly visible in source/config and do not need a toy thermal simulation. A future lab would be justified only if a stronger real additive implementation exposes an unresolved stale-temperature, queued extrusion, heater-fault, or abort/restart behavior.

## Evidence confidence

- High: inspected LinuxCNC-RepRap HAL/component behavior.
- High: native LinuxCNC documentation for genhexkins capability.
- Medium: breadth ranking, because public unusual-machine implementations are sparse and searchability varies.
