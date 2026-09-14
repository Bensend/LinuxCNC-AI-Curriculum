# 3300-P3 — QtPlasmaC hole/overcut filter and PMX485 field trace

Date: 2026-09-14
Pinned LinuxCNC revision: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`
Status: SOURCE-CONFIRMED filter behavior + DOC-CONFIRMED command semantics + COMMUNITY-REPORTED PMX field chronology

## Scope

This pass closes the highest-value remaining plasma P3 questions around automatic small-hole transformation, torch-disable overcut, velocity restoration, and a real PowerMax RS485 failure/recovery history. It does not claim that the G-code filter is the realtime cutting controller; `plasmac.comp` remains the realtime process authority established in the earlier P1 trace.

## Source path

Primary source: `src/emc/usr_intf/qtplasmac/qtplasmac_gcode.py` at the pinned LinuxCNC revision.

The filter maintains independent state for:

- `holeEnable` — whether full-circle holes are candidates for automatic treatment;
- `arcEnable` — whether non-full-circle small arcs are also candidates;
- `overCut` — whether qualifying holes get torch-off overtravel;
- `holeActive` — whether a velocity-reduced feature is currently active;
- `torchEnable` — filter-side record of whether P3 currently permits torch operation.

`set_hole_type()` maps `#<holes>` values as follows:

| `#<holes>` | hole velocity treatment | small-arc treatment | overcut |
| --- | --- | --- | --- |
| 0 | off | off | off |
| 1 | on | off | off |
| 2 | on | off | on |
| 3 | on | on | off |
| 4 | on | on | on |
| 5 | off | off | off |

The defaults at startup are 32 mm / 1.26 in maximum hole diameter, 60% velocity, and 4 mm / 0.157 in overcut length, adjusted to the configured units.

## Exact transformation mechanism

`do_arc()` determines whether an arc returns to the previous XY endpoint and therefore qualifies as a hole. Diameter comes from I/J geometry plus kerf width. If a qualifying hole is at or below the configured diameter, `get_hole_diameter()` causes the filter to insert:

`M67 E3 Q<holeVelocity>`

before the qualifying feature when velocity reduction is required. `holeActive` remains set until the filter sees a later point where reduced velocity is no longer required, at which point it inserts:

`M67 E3 Q0`

The main file-processing loop also restores E3 to zero before the next ordinary line when a reduced hole episode has ended.

For hole modes 2/4, `do_arc()` invokes `overburn()` after a qualifying full-circle hole. The overburn function computes an additional circular path length from `ocLength / radius`, inserts synchronized torch disable:

`M62 P3`

and extends the circular path by the configured overcut distance. Under active G41/G42 cutter compensation, the filter does not activate the velocity/torch transformation normally; it emits warning/commented inactive commands because synchronized M62-M68 use conflicts with cutter compensation in this workflow.

Representative conceptual transformation for `#<holes>=2`, a qualifying full-circle hole and the default settings:

Input intent:

```gcode
#<holes> = 2
...
G3 I10
M5
```

Filter-added process intent around the circle is equivalent to:

```gcode
M67 E3 Q60          (reduced feature velocity)
G3 I10              (qualifying full-circle hole)
M62 P3              (synchronized torch disable at overcut start)
G3 ... I10 ...      (computed continuation for default/configured overcut distance)
M68 E3 Q0           (velocity restoration at spindle-off cleanup if still active)
M65 P3              (torch permission restoration at spindle-off cleanup if still disabled)
M5
```

The exact computed overcut endpoint depends on radius, direction, current XY and configured overcut length; the filter calculates it rather than relying on CAM to supply the endpoint.

## Cleanup ownership

`spindle_off()` contains explicit filter cleanup. If `holeActive` is still true when normal `M5` is processed, it emits immediate `M68 E3 Q0` and clears the filter flag. If `torchEnable` is false, it emits immediate `M65 P3` and restores the filter-side torch-permission flag.

This is important for diagnosis: seeing `M62 P3` in filtered output is not evidence that the torch is intended to remain inhibited for the next cut. The filter has an explicit end-of-cut reconciliation path.

The source therefore exposes two distinct restoration styles:

- synchronized restoration while progressing through ordinary filtered geometry: `M67 E3 Q0` / explicit synchronized P3 commands where present;
- immediate cleanup at end-of-cut/program-state reconciliation: `M68 E3 Q0`, `M65 P3`.

These are G-code/filter semantics, not a substitute for proving the downstream realtime process state.

## Documentation reconciliation

Current QtPlasmaC documentation agrees with the source contract:

- M67 E3 sets velocity as a percentage of material cut feed;
- M62/M63 P3 synchronously disable/enable torch permission;
- automatic hole modes 1-4 implement the combinations above;
- overcut is incompatible with active cutter compensation;
- automatic hole processing is optional and can substitute for CAM-post support when the post does not emit the feature commands itself.

The documentation also recommends M52 adaptive-feed enable for the velocity-reduction workflow.

## PMX485 field chronology

A LinuxCNC forum report from 29 Nov 2023 described intermittent PMX485 errors on QtPlasmaC 1.0.40 after the owner had already changed the USB-RS485 converter. On 30 Nov 2023, QtPlasmaC developer `phillc54` explained that the original PMX485 implementation had been built partly from incomplete/ambiguous legacy Hypertherm documentation and that a rewrite was underway for Powermax SYNC plus legacy efficiency. Another experienced user pointed out that 1.0.40 dated from June 2021 and recommended updating. The machine owner reported on 4 Dec 2023 that after updating, the problem no longer occurred.

Classification: COMMUNITY-REPORTED. This does not prove the root cause was software, but it is strong commissioning evidence that adapter replacement alone is an incomplete diagnostic response and that QtPlasmaC/PMX component version provenance belongs in the fault tree.

A separate 2021 report showed a missing/incorrect Python serial package as another userspace prerequisite failure surface. `pmx485-test`/port-open success, QtPlasmaC component startup, serial transport health and actual plasma-source response therefore remain separate checkpoints.

## Production-diagnostics consequence

Use this layer order when diagnosing a plasma feature problem:

`CAM geometry/feature intent -> optional CAM-emitted process codes -> qtplasmac_gcode filter detection/transformation -> interpreter synchronized/immediate I/O scheduling -> plasmac realtime process qualification -> Motion/eoffsets -> hardware/process feedback`

For PMX parameter/control failures use a separate userspace chain:

`QtPlasmaC version + Python serial availability -> serial device/permissions -> adapter/cable -> pmx485 protocol validation/status -> Powermax remote parameter state`

Do not treat PMX485 status as Arc OK, Torch On or a functional-safety witness.

## Adversarial boundary review — 8/8

1. Does the filter itself perform THC? **No.** It emits/normalizes G-code/process intent; realtime THC remains elsewhere.
2. Does `#<holes>=2` mean CAM must provide an overcut endpoint? **No.** The filter computes one for qualifying full-circle holes.
3. Does P3 torch-disable mean power source communication is disconnected? **No.** It is a synchronized LinuxCNC process-control surface, separate from PMX485 serial communication.
4. Is M67 velocity reduction itself THC disable? **No.** THC may become ineligible because of velocity qualification, but E3 is adaptive feed intent.
5. Is cutter compensation compatible with automatic overcut? **No in this workflow.** The filter warns/inactivates the relevant transformation.
6. Can the filter leave P3 disabled forever after a normal hole episode? **Normal M5 cleanup explicitly restores torch permission if needed.** Abnormal abort/restart remains a downstream state-reconciliation question, not proven by this source path.
7. Does replacing a USB-RS485 adapter exhaust the PMX485 fault tree? **No.** Version, dependencies, protocol handling and plasma-source response remain separate layers.
8. Does the 2023 upgrade success prove a specific software defect caused the intermittent failure? **No.** Preserve it as community chronology, not source-confirmed root cause.

## Promotion / stop decision

The exact automatic-hole transformation and normal M5 cleanup are sufficiently source-established for the breadth-first P3 pass. Do not spend another lesson re-reading this path unless an abort/restart case or a specific version regression requires it.

Remaining high-value plasma work is now narrower: a downloadable combined ohmic+float real configuration, stronger CAM-post provenance for which layer emits feature codes, and later production-stage tandem evidence. Plasma is approaching diminishing returns relative to the underdeveloped laser branch, so the next session work should rotate into 3300-L1 after preserving any immediately available strong P2 evidence.
