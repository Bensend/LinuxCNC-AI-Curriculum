# PB-DOMAIN — Tooling / Material / Measured-Angle Adversarial Review

Date frozen: 2026-09-12
Scope: dependency-safe 3600 preparation; not a formal 3600 graduation exam.

Allowed evidence:

- `research/press-brake-tooling-material-springback-ownership-2026-09-12.md`
- `research/press-brake-measured-angle-sensor-boundary-2026-09-12.md`
- `research/press-brake-bend-technology-table-provenance-2026-09-12.md`
- pinned FreeCAD SheetMetal source `db3f87556cf8930257b69096cabe00e660caa416`
- public LinuxCNC/HostMot2 source/docs already cited by those artifacts
- public controller documentation cited by those artifacts

Do not use machine-specific private information.

## Questions

1. A BendStep requests 90°. The operator changes from Die A to Die B but keeps the same punch, material and finished geometry. The existing TargetSet was calculated before the die change and its numeric X/Y targets still look plausible. May the runtime reuse that TargetSet unchanged? Explain the exact ownership boundary.

2. A material spreadsheet contains the same numeric K-factor rows as yesterday but the header was changed from `K-factor (ANSI)` to `K-factor (DIN)`. An engineer argues that because the numbers are unchanged no recalculation is necessary. Is that claim valid? Point to the implementation mechanism that decides this.

3. A measured angle channel reports `90.0` for five consecutive GUI updates after a bend. Ethernet/HostMot2 transport diagnostics are green and the displayed value agrees with the requested BendStep angle. What is the strongest justified conclusion? What additional evidence is required before calling the physical result current and correct?

4. A GUI developer wants to expose a measurement-only linear scale on the press as LinuxCNC axis W because the DRO widget already knows how to display axes. The scale is never commanded. Is this representation automatically sound? Give a better default representation and state what would justify promoting the channel into commanded motion semantics.

5. The first part of a job bends 2° open. The operator enters a +2° correction and the second part is correct. Should software automatically add +2° to the global material Overbend Factor? Explain the competing hypotheses that make this unsafe.

6. A developer proposes `angle_error -> PID -> add directly to both Y valve commands` for active sensor bending. The toy simulation converges. Is that enough to adopt the topology? List the minimum unresolved authority/timing questions that must be answered from a real implementation or sensor/machine contract.

7. The current bend-technology table revision changes while a part program is paused. The numeric result for the current bend happens to remain identical after recomputation. Can the existing ExecutionEpisode remain authoritative? Explain using generation/provenance rather than numeric equality.

8. A HostMot2 encoder provides both `position` and `position-interpolated`. The angle sensor has coarse resolution, so a developer suggests using `position-interpolated` for the active angle-control loop because it looks smoother. What does the documented interface say, and what engineering conclusion follows?

## Scoring

2 points each, 16 total. A full-credit answer must preserve uncertainty and ordinary-control/safety boundaries rather than merely select yes/no.
