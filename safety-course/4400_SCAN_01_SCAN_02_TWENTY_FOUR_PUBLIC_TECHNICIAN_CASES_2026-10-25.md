# 4400 SCAN-01/02 — 24 public technician transfer cases
**PAPER ONLY / UNSCORED / NOT A BLIND EVALUATION / no energized testing**

For every case, the learner should state: (a) the false safety inference; (b) which exact OEM or machine-specific evidence is required; (c) the independent safety action or hold; (d) the safer, easier-to-maintain design. Do not assume S300 is installed.

## SCAN-01: signal routing and reset authority (12)
1. Scanner internal reset enabled; safety PLC uses EFI protective-field clear instead of OSSD state.
2. Scanner internal reset enabled; controller consumes EFI OSSD status, but a second safety branch uses field-clear status.
3. Operator walks through vertical access field and stands behind it; field status clears.
4. Power returns after an interruption; ordinary CNC retains an old cycle-start bit.
5. Reset button is reachable from inside a guarded cell.
6. Reset button is outside cell but view of rear corner is blocked by fixture.
7. Scanner reports field clear while a contactor's main contacts are welded.
8. Installer shows green EFI diagnostics but no physical OSSD wiring or safety-logic map.
9. A replacement safety controller restores the same project name but different field-status mapping.
10. A warning-only universal I/O output is used as a protective stop input.
11. Technician bridges a manual-reset input to eliminate downtime from nuisance stops.
12. Machine has a properly implemented downstream reset interlock, but normal CNC motion resumes from a stale request after reset.

## SCAN-02: coverage, switching and contour (12)
13. Scanner recessed in a cabinet leaves its model-specific near range accessible.
14. A new guard frame creates a standing pocket outside the scanned plane.
15. A 2D floor scanner is claimed to detect fingers at a press-brake pinch point.
16. Machine switches from small to large protective field only after entering the hazardous zone.
17. EFI field-set change has a configured input delay not included in safety-distance assessment.
18. Field selection uses external OSSDs, but the integrator uses only scanner basic response time.
19. An automatically suggested field is accepted without a stop-time calculation.
20. Vertical scanner mount rotates slightly after maintenance, but no contour reference is configured.
21. Contour reference segment is narrower than the configured scanner resolution.
22. A reflective fixture is placed close to the protective-field boundary.
23. Field map remains unchanged after a taller fixture permits reach-over.
24. A technician proposes disabling the scanner because its guard is awkward to reinstall.

## Public answer principles (not hidden evaluator keys)
The source-confirmed discriminator for cases 1–2 is **EFI field status versus OSSD status**. Cases 3–12 demand distinct occupancy, reset, final-element and fresh-start evidence. Cases 13–24 demand physical geometry and actual timing, not software flags. No numerical OpenPressBrake stopping distances, PL/SIL or pressure thresholds can be inferred. Unresolved machine facts remain **UNKNOWN**. A good answer never credits normal LinuxCNC/FPGA as the sole safety authority, never tests with exposed personnel, and redesigns guard/reset convenience rather than tolerating routine bypass.
