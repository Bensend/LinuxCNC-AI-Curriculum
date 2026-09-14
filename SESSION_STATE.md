# Active Curriculum Session State

Session start UTC: `2026-09-14T17:35:56Z`
Session end UTC: `2026-09-14T17:50:56Z`
Actual elapsed: **15.0 minutes**
Status: **CLOSED — 3300 plasma P3 breadth closed for rotation; laser L1 source/config coverage materially advanced; waterjet W1 evidence model established and sharpened.**

## Prerequisite state

The 1000 and 2000 series remain **GRADUATED / CLOSED**. F02 remains graduated under its preserved valid information-separated evaluation. This session did not reopen, re-poll or re-score closed 2000 work.

## Active branch

Owner-selected branch remains **3300 — Plasma / Laser / Waterjet**.

Pinned LinuxCNC revision for upstream source claims: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`.

Latest checkpoint: `checkpoints/3300-next-2026-09-14e.md`.

3200 remains intentionally paused and not graduated. 3600 remains at its branch-local information-gain stop.

## Durable work completed

New/updated artifacts:

- `research/3300-plasma-hole-filter-pmx-field-trace-2026-09-14.md`
- `research/3300-laser-native-source-foundation-2026-09-14.md`
- `research/3300-laser-real-implementation-comparison-2026-09-14.md`
- `research/3300-laser-sector67-raycus-config-trace-2026-09-14.md`
- `research/3300-waterjet-w1-implementation-hunt-2026-09-14.md`
- `research/3300-waterjet-vendor-process-boundaries-2026-09-14.md`
- `checkpoints/3300-next-2026-09-14d.md`
- `checkpoints/3300-next-2026-09-14e.md`
- updated `PROGRESS.md`

### Plasma P3 closeout

Pinned `qtplasmac_gcode.py` source establishes automatic hole velocity reduction with M67 E3, computed torch-disabled overcut with M62 P3, and explicit normal M5 cleanup using immediate E3/P3 reconciliation. A real PMX485 field history additionally demonstrated that adapter replacement alone does not exhaust the communications fault tree; software/version/dependency provenance must remain a diagnostic layer.

The plasma breadth branch now has enough source/config/field coverage to preserve an information-gain stop unless strong new evidence appears.

### Laser L1

Pinned LinuxCNC source established native `laserpower.comp`, `raster.comp`, simulator wiring and queued/immediate M62/M63/M67/M68 semantics.

Three materially different real implementation patterns are now preserved: historical CO2, direct Fusion/M67-to-Mesa-PWM diode, and an inspectable Sector67 Raycus C500 fiber retrofit.

At Sector67 revision `938b501bfd092505170af8146c1b77a8564754d1`, downloadable source/config establishes:

- QtPlasmaC material `cut_amps` -> custom M03 rewrite -> spindle speed -> Mesa PWM -> PWM-to-0-10 V -> Raycus power;
- BCL-AMP frequency -> Schmitt trigger -> HostMot2 encoder counter mode -> scaled encoder velocity -> QtPlasmaC arc-voltage surface for adapted capacitive height control;
- synthetic ohmic probe and always-true fake Arc OK as compatibility glue;
- distinct Raycus analog power, modulation, enable and READY surfaces;
- a real startup fault if laser-enable is asserted during source power-up, with READY not yet integrated into machine-on qualification;
- simple program-running gas-solenoid timing explicitly described by the builders as naive;
- material-table field reuse where `CUT_AMPS` is laser power intent while other plasma-oriented field names retain machine-specific meanings.

Sector67 adversarial review after material/config reconciliation: **11/11 passed**.

### Waterjet W1

Public LinuxCNC evidence established separate water/nozzle and abrasive channels, program/manual override arbitration during AUTO, nominal Z versus cut-time correction authority, and the need to verify original industrial drive interfaces before Mesa selection.

Primary vendor documentation sharpened the missing process contract without inventing LinuxCNC semantics: low/high pressure modes and low-pressure pierce exist; vacuum-assisted piercing may establish abrasive before water; abrasive availability/transfer/metering are distinct; clog recovery may require purge/diverter behavior; intensifier and direct-drive pump idle behavior differ.

Therefore no universal water-before-abrasive sequence was promoted. W1 still needs real LinuxCNC pump/pressure-ready and water/abrasive sequencing implementations before a 3-axis process state machine can be frozen.

## Lab decision

No laboratory experiment was launched. Source/config/build-diary evidence continued to provide higher information gain. `LAB_COMPUTE_LOG.md` remains unchanged.

## Exact next checkpoint

Continue from `checkpoints/3300-next-2026-09-14e.md`:

1. prioritize real Flow/KMT/OMAX/H2O-Jet LinuxCNC configurations exposing pump/intensifier READY/fault, pressure/high-pressure valve ownership and water/abrasive timing;
2. require at least one real pressure-ready implementation and one real sequencing implementation before promoting the W1 3-axis process state machine;
3. in parallel, inspect mature fiber configs for source READY/FAULT integration, gas pressure/selection, focus/pierce and abort/recovery;
4. search for a real deployment using upstream `laserpower.power` to compare with the direct PWM architectures;
5. keep queued-output/raster labs frozen until source work leaves a nonduplicate uncertainty.

Overlap: **No overlap.** Previous canonical session ended `2026-09-14T16:48:13Z`; this session began `2026-09-14T17:35:56Z`, **47m43s later**.
