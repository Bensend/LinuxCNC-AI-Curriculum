# 4400-ACC-02 — Blank qualified accumulator zone, gas/fluid and restart witness
**BLANK / NOT RUN / 2026-10-24. Planning record only; no permission to energize, drain, disassemble or expose people.**

## Selected-machine identity and independent approval
- Machine, revision, mode, task and hazard boundary: **UNKNOWN**
- Owner / qualified hydraulic designer / authorized service lead / independent safety reviewer: **UNASSIGNED**
- Current signed as-built hydraulic/electrical diagrams, revision and OEM manuals: **MISSING**
- Accumulator present? Model, vessel serial, fluid/gas construction, certification and selected service instructions: **UNKNOWN**
- Protective motion vs maintenance isolation SRS and physical safe-state acceptance basis: **MISSING**
- Personnel exclusion, remote observation, load support, emergency containment and stop-work authority: **UNDEFINED**
- **Default disposition: HOLD / no personnel-exposed operation.**

## Per-zone record (duplicate for each relevant compartment)
| Field | Fill only from qualified selected evidence |
|---|---|
| Zone ID and connected volume (fluid/gas/cylinder A/B/pilot/return) | UNKNOWN |
| Pressure source and possible reaccumulation paths | UNKNOWN |
| Isolation device, lockability and location | UNKNOWN |
| Discharge path and where its flow can go | UNKNOWN |
| Exact valve part code, M/E, Y/Z, wiring and power loss response | UNKNOWN |
| Relief vs discharge vs holding function | UNKNOWN |
| Gauge/test point ID, calibration, range, valve-state connectivity | UNKNOWN |
| Physical safe-state witness and acceptance basis | NOT DEFINED |
| Independent witness operator, time, raw result and trace | NOT RUN |
| Remaining stored energy / gas charge / gravity load | UNKNOWN |
| Service boundary and qualified vessel-opening authorization | NOT AUTHORIZED |
| Change/stale evidence and maintenance record | OPEN |

## Separate validation records
- `PHY-STOP` independent motion and stopping: **NOT RUN**.
- `PHY-HOLD` independent load restraint/drift: **NOT RUN**.
- `PHY-FLUID` each fluid-side isolated zone: **NOT RUN**.
- `PHY-GAS` qualified vessel-specific gas-side state for proposed work: **NOT RUN**.
- `PHY-REACC` reaccumulation across service interval: **NOT RUN**.
- `PHY-ACCESS` guards/escape/people-clear: **NOT RUN**.
- `PHY-RESTART` independent safety rearm plus deliberate fresh normal start: **NOT RUN**.

## Failure/contradiction handling
If any physical witness contradicts a valve, gauge, HMI or configuration record, record raw observations, stop work, preserve configuration and mark affected `SRS/DEP/ARC/VAL/PT/CHG` evidence **STALE**. A green status bit does not resolve a physical contradiction. **Do not** create a live rupture, intentionally release stored energy with exposed people, or open a pressure vessel as an educational experiment.

## Practical human-factors signoff
Can authorized personnel identify each zone and use qualified test points without removing/bypassing a guard? Can the guard be reinstalled easily? Are independent safety reset and normal start visibly separate? If not, redesign the access and workflow before release.

**All selected-machine fields remain UNKNOWN.** No numeric pressure, flow, PL/SIL, diagnostic coverage, stopping distance or safe exposure threshold is assumed.
