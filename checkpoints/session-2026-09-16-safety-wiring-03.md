# Safety wiring research session 03 — 2026-09-16

- Session start UTC: `2026-09-16T17:37:30Z`
- Session end UTC: `2026-09-16T17:42:30Z`
- Actual elapsed: `5.00 min`
- Overlap status: `UNKNOWN` — no authoritative concurrent-session marker available in inspected state.
- Compute: NONE. Documentation/source research only; no GitHub-hosted Actions minutes consumed.
- Status: CHECKPOINTED — continue next invocation.

## Durable work completed

- Added `safety-course/PROFESSIONAL_SAFETY_WIRING_REFERENCE_STUDY_02.md`.
- Added a two-map professional analysis method: Map A traces safety demand/logic/final-element feedback; Map B independently traces physical electrical/fluid/gravity energy to hazardous motion. The maps must be overlaid before claiming a machine is in a safe state.
- Added an energy-state worksheet separating normal command inhibition, operational protective stopping, hydraulic/holding safe state, and maintenance isolation.
- Added Pilz fluid-power evidence showing why depressurisation alone is not a generic safe state for vertical loads and why holding/braking functions must be distinguished.

## Key evidence gained

1. `pump off`, `proportional command zero`, `valve coil off`, `pressure dumped`, and `ram prevented from descending` are not interchangeable states.
2. Professional fluid-power guidance explicitly treats gravity movement after depressurisation as a hazard requiring appropriate holding/braking architecture.
3. E-stop/protective stopping and task-specific maintenance isolation must be taught as distinct functions.
4. The exact OEM press-brake E-stop hydraulic truth table remains UNKNOWN pending a complete electrical + hydraulic machine drawing pair.

## Exact next work

1. Continue searching for a complete OEM press-brake electrical + hydraulic schematic pair mapping safety outputs/contactors to named hydraulic final elements.
2. If source availability remains poor, rotate to a complete professional servo machine tool or robotic-cell architecture and apply the same two-map method.
3. Build the cross-machine comparison matrix only from traced final elements, not generic safety-controller examples.
4. No simulation until a concrete unresolved question exists that simulation can actually answer.

## LESSON_LOG append status

Timing is preserved here. Do not replace `LESSON_LOG.md` from a truncated fetch; append only when a safe append-capable path is available.
