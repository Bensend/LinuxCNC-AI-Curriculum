# Adversarial exercise — conflicting overrun instructions and unguarded workpiece motion

**Scope:** Fiessler AKAS-5M doc 1581, 2024-02-15, printed pp.4–5,14; OSHA powered-press-brake eTool. **No numerical design answer or machine validation.**

## Scenario

A retrofitted press brake has an AKAS-5M receiver. The builder's commissioning spreadsheet uses a single overrun limit of 13 mm copied from the manufacturer's p.5. A technician finds an 11 mm fast-speed-reduction trigger on p.14. Both believe the device's test-rod response proves safe operation. A large sheet rises during bending and can sweep a helper's hands into the machine frame. The normal LinuxCNC interface displays `LASER OK`.

## Required learner deliverables

1. Quote **page locations**, not an inferred universal limit. Classify the two numerical statements and the different/ambiguous ten-measurement wording as a DOC-CONFIRMED **unreconciled source discrepancy** and preserve possible context differences as UNKNOWN.
2. Refuse to sign off any stop/overrun acceptance criterion until exact selected variant, adjustment position, safety-related controller, manufacturer clarification where needed, actual stop evidence and application geometry are available. Do not resolve the discrepancy by choosing either number from this exercise.
3. Create separate `HAZ/PHY/SRS/AUTH/DEP/ARC/VAL` records for (a) die-line finger reach, (b) moving-workpiece sweep and part-to-frame pinch, (c) ejection/fragment hazard, and (d) foot-control/restart exposure. State why a device test addresses only a subset.
4. Design a **non-executed** independent validation matrix: mode/guard state, expected safety demand, selected final-element evidence, physical stop/hold, workpiece/helper exclusion, and residual energy. Keep personnel outside hazard zones during any future qualified experimental testing.
5. Propose an ergonomic alternative to repeated nuisance trips or guard bypass: improve supported tool alignment and access, provide explicit mode/coverage diagnostics, workpiece support/handling aids and a repeatable restoration process.
6. Record `CHG` and mark old validation evidence STALE after tool, receiver, controller, geometry or workpiece-handling changes.

**Assessment boundary:** A response that states '13 mm is safe', '11 mm is safe', 'laser OK means safe', 'slow mode removes crush risk', or 'OSSD ON authorizes start' fails the evidence/authority boundary. External 2520–25F0 evaluation keys remain sealed; this is an ordinary learner exercise.
