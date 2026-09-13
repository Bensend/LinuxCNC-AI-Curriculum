# 3600 — Quantitative angle-measurement interface source trace — 2026-09-13

## Scope

F02 was re-checked first and remains externally blocked/unscored. This trace follows the current 3600 information-gain gate: only new inspectable quantitative angle-measurement implementation/interface evidence is useful.

## Pinned public source

Repository: `machinepilot/FANUC_dev`
Pinned revision: `23392889558240370cc0755ce5be4c72b181387f`
Primary artifact: `LDJ/Kvara/PLC/Ioleng.inc`

Classification: **SOURCE-CONFIRMED interface definitions in a public repository**. The repository does not independently authenticate the original vendor/deployment provenance, so do not promote these definitions to verified vendor behavior without corroboration.

## Source-visible interface

`Ioleng.inc` exposes a materially richer angle-control contract than a generic boolean bend sensor:

- `%C2.7`: bend uses SER/LC angle sensor.
- `%C4.0`: start of floating from SER angle sensor.
- `%C4.1`: end of angle writing from SER sensor.
- `%C4.2`: end of bend from SER angle sensor.
- `%C4.3`: SER angle-sensor error.
- `%C2.6`: BDC recalculated after floating.
- `%C2.8`: bending-calculation error after floating.
- `%C2.9/%C2.10/%C2.11`: LC target calculation OK/error/bend completed.
- `%C2.14`: realtime angle in tolerance or wrong, bend completed.
- `%C7` and `%C12`: realtime angle values during descent (right/general channels).
- `%C11` and `%C13`: realtime angle values during floating (right/general channels).
- `%C8`: dynamic BDC correction Y1 for angle measurement.
- `%C9`: dynamic BDC correction Y2 for angle measurement.

The same file separately defines program Y1/Y2 target quotas (`DP_PMI` / `DP_PMIY2`). Therefore the dynamic angle corrections are not merely aliases for the nominal programmed targets at the interface-definition level.

## Reconstructed ownership/call-flow contract

The interface supports this bounded architecture model:

`bend-step sensor enable -> phase-qualified angle episode (descent/floating) -> quantitative angle observations -> target/recalculation status -> separate Y1/Y2 dynamic BDC corrections -> corrected beam target authority -> tolerance/completion`

This is an interface/data-flow reconstruction, **not** a claim that the producer/calculation implementation has been found.

The source also demonstrates why a single scalar `measured_angle` is inadequate provenance: descent and floating values are separate channels, calculation completion/error is separate from sensor-cycle state, and Y1/Y2 correction outputs are distinct.

## Source search for producers/consumers

A bounded repository code search for the correction channels and angle-sensor enable/status terms returned the interface/reference definitions and duplicated raw documentation, but no inspectable producer/consumer algorithm implementing the correction calculation. Thus this pass advances the architecture boundary but does not expose the calculation kernel.

## Adversarial boundary test — 7/7

1. **Do C8/C9 prove a Y1/Y2 correction formula?** No; only distinct correction interfaces are source-visible.
2. **Do descent/floating registers prove sample freshness?** No timestamp, sequence/generation or age contract was found.
3. **Does C2.14 prove a safety-rated angle stop?** No; it is an ordinary software interface definition absent safety evidence.
4. **Does target-calc OK prove physical beam authority?** No; calculation state is upstream of actuator/drive/hydraulic authority.
5. **Can C8/C9 be assumed to be added directly to DP_PMI/DP_PMIY2?** No; exact insertion point and saturation remain unknown.
6. **Does this establish LinuxCNC semantics?** No; it is comparative press-brake interface evidence, not LinuxCNC source.
7. **Does the public repository prove authentic deployed ESA/FANUC behavior?** No; provenance is not independently authenticated in this trace.

## Durable correction to the 3600 model

Replace the earlier broad statement `quantitative sensor-bending implementation source unavailable` with the narrower statement:

> Quantitative sensor-bending **interface architecture is source-visible** in a public artifact: phase-qualified angle channels, sensor/calculation states and separate Y1/Y2 dynamic BDC correction channels exist. The acquisition producer, freshness contract, correction formula, insertion/saturation, actuator interaction and recovery implementation remain **SOURCE UNAVAILABLE / UNKNOWN**.

## Lab decision

No synthetic experiment was run. A toy angle loop could reproduce an invented architecture but cannot verify the missing producer/calculation implementation. The highest-information next action is source tracing, not simulation.

## Next checkpoint

1. Re-check F02 first.
2. Search the pinned artifact/repository specifically for producers/consumers of `%C7/%C11/%C12/%C13`, `%C8/%C9`, `%C2.7`, `%C2.14`, and the SER/LC calculation states.
3. Prefer source exposing freshness/generation, correction formula, insertion point, limiting/saturation, Y1/Y2 interaction, sensor-error recovery, or tandem coordination.
4. If only duplicated interface declarations remain discoverable, preserve the information-gain stop; do not invent a synthetic controller to fill the gap.
5. PB-PREP-001 remains INCONCLUSIVE / NO ARCHITECTURE RECOMMENDATION.
