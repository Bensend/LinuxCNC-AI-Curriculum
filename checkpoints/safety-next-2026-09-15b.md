# Safety Curriculum Next Work — 2026-09-15b

## Current state

3000 remains GRADUATED/CLOSED. Safety remains the primary 4000 curriculum priority.

This pass added:
- `guides/safety-welded-contactor-exercise-2026-09-15.md`: first 20-point scored safety exercise, with critical-fail conditions separating commanded state, physical safe state, EDM feedback, reset/rearm, LinuxCNC diagnostics and quantitative safety claims;
- `research/safety-current-manual-revision-freeze-2026-09-15.md`: current official Pilz document-index freeze for PNOZ s4 21396-23 (2026-06-22) and PNOZ X3 20547-17 (2026-04-29), with numeric/model-specific claims deliberately left OPEN until exact current tables are extracted.

The exercise freezes the practical rule that a welded downstream contact is not proved safe by an OFF command. External-device feedback must detect the mismatch and the safety system must inhibit rearm; LinuxCNC may diagnose the condition but must not override it. If the welded element is the only physical interruption path, the required safe state may not be achieved and operation with people exposed to the hazard is unacceptable.

## Exact next work

1. Obtain/extract the actual current PNOZ s4 21396-23 and PNOZ X3 20547-17 numeric tables; freeze model-specific response/recovery, contact ratings/fusing, channel/cross-short diagnostics and PL/SIL restrictions only from those exact revisions.
2. Find a public LinuxCNC machine with explicit drive STO wiring, preferably with commissioning chronology. Do not count a generic E-stop input or inferred cabinet connection as STO evidence.
3. Extend the scored exercise across machine physics: vertical/gravity axis, spindle, hydraulic ram, plasma/laser process source, robot/cell access. Define physical safe state first for each.
4. Build an SRS-first low-cost reference architecture only after the failure model is explicit. Do not assign Category/PL/SIL to a generic/open circuit without calculation and validation evidence.
5. Keep reset easy but deliberate. Diagnostics should expose the missing prerequisite without providing a bypass path.

## Lab decision

No lab justified. Remaining uncertainty is documentary/application evidence, not a simulation question.
