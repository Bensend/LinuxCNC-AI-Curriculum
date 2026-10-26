# MAT-01 — Twelve public paper scenarios (UNSCORED)

**Status:** all 12 are PUBLIC PRACTICE / PAPER ONLY / UNSCORED. These are NOT a blind benchmark, NOT executed on a machine, and do not grant release. For each case identify: (a) actual hazard/occupancy, (b) sensor state and what it can prove, (c) missing physical evidence, (d) independent stop/hold/energy control, (e) required rearm and qualified change-control action, (f) confidence and falsifier. Do not energize machinery to answer.

1. **Disabled zone with paired agreement.** A MatGuard manager has eight floor sections physically shown on a drawing, but both DIP banks select seven inputs; all active indicators are green and one is off. What exactly is proved by absence of Internal Error? What G0 records are stale?
2. **Single-bank mismatch.** A qualified reviewer finds that the two DIP rows disagree on the eighth input. Distinguish the manufacturer's documented Internal Error from the prior case; is either state acceptable for release?
3. **Uncovered baseplate.** An operator can step from the outer edge of a mat onto a rigid machine baseplate and reach the hazard while no longer loading the mat. Which physical guard/geometry must change?
4. **Adult rating misused as child detector.** A MatGuard publication assures adults 35 kg and above. A risk review includes lighter persons. May an aggregate green light prove no such person is inside?
5. **Auto reset plus latched request.** A mat is released after a temporary power dip; ordinary LinuxCNC control retains a previously requested motion. Separate sensor output restoration, independent safety reset and new motion authorization.
6. **Manual reset out of sight.** A remote reset button is easy to reach but has no view behind a machine enclosure. What physical evidence would make the design acceptable, or what supplementary sensing is needed?
7. **Four-wire break.** A Banner SC22 monitored mat conductor is open. Distinguish a documented enabled-input fault lockout from a deliberately disabled input in a different OEM manager.
8. **Wrong device substitution.** A two-wire edge sensor is connected where a four-wire mat is specified. Why does 'the connector fits' not prove compatibility?
9. **Status-to-safety promotion.** An ordinary HMI displays 'Machine Enabled' from a non-safety auxiliary output. Can the HMI state replace physical proof of stopped/held Y1/Y2?
10. **Floor contamination.** Swarf, oil and cleaning liquid accumulate beneath joints. The floor is hard to clean without removing guards, and workers start avoiding the mat. What human-factor redesign prevents predictable defeat?
11. **New cell access door.** A guarded robot cell adds a side access door outside existing mat coverage. Which BND/HAZ/SF/PHY/ARC/VAL/PT records become stale? What new geometry evidence is required?
12. **Mat replacement changes response.** A replacement mat/manager changes response assumptions. A previous safe-distance calculation uses an old sensor time and unverified brake condition. What must be recomputed/validated before exposing personnel?

**Instructor constraints:** No answer key here. For each scenario insist on explicit DOC-CONFIRMED versus INFERENCE versus UNKNOWN. Do not invent PL/SIL, test forces, stopping distance, hydraulic valve state, or installed hardware. **G0/G1 HOLD; external evaluator NOT RUN.**
