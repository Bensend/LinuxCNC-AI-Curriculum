# 4400 transfer exercise — same latch, different safety proposition

A service technician replaces a failed EUCHNER CTP-L1 (order 123375) with a CTP-I1 (order 136595) because both are RFID coded, power-to-unlock, include escape release, and advertise FZh 3,000 N. The new `OL` status reports lock present and the controller HMI shows “guard healthy.” The production sequence starts after reset.

The learner must: (1) inspect the two manufacturer product records; (2) identify which variant explicitly lacks **safe guard-lock monitoring**; (3) distinguish safety output FO1A/FO1B, lock diagnostic OL, guard-position PL and lock-monitoring PL; (4) reject a generic connector/pin equivalence; (5) identify the independent owner of safe unlock permission; (6) enumerate residual motion, stored energy and occupancy unknowns; (7) create a `CHG` with `SRS/PHY/AUTH/DEP/ARC/VAL` marked STALE; (8) propose an accessible, low-friction replacement checklist that prevents similar substitutions; (9) state the condition under which process-only locking could be used without falsely crediting it as safety-rated locking; (10) block exposed-person operation until actual safety function and physical witness are revalidated.

This is learner-facing reasoning practice, not a hidden evaluator answer. No machine test, achieved PL/SIL or part substitution is authorized.
