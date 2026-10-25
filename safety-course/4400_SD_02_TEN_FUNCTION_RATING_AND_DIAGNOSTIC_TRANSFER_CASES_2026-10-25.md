# 4400-SD-02 — Ten function-specific integrity cases (PAPER, UNSCORED)
**2026-10-25 | Based on directly opened Schmersal exact-part 103037334 ratings and 2023 serial diagnostics brochure**

For each scenario state the safety *function* (not merely device), evidence provenance, selected-machine missing witness and whether personnel-exposed operation is allowed.

1. A catalog lists PL e for interlocking but PL d for guard locking. Which rating can support a guard-retention claim, subject to the complete safety-function design?
2. A purchasing replacement has the same connector and a PL e interlocking label but no verified guard-locking function. What must be frozen?
3. A bistable guard lock stays locked during power failure with someone inside. What is missing?
4. The operator receives a fault warning while an ordinary SD status reports outputs healthy. Is physical safe state established?
5. The diagnostic output drops but safety outputs are still ON during a documented noncritical warning. What independent response is required?
6. A programmer uses a LinuxCNC HAL output to command a serial gateway unlock before an independently verified stop. What boundary was crossed?
7. A service technician claims the guard's 2000 N catalog holding force proves the press-brake ram cannot descend. Identify the unrelated mechanical quantities.
8. An AZM40 part number differs in suffix, and a colleague copies the old function rating. What original documents and acceptance checks are needed?
9. A safety controller reports guard locked but occupancy is unknown after an access request. What reset/fresh-start steps remain independent?
10. A new control panel makes it hard to reach the approved escape lever. Which human-factor change invalidates the previous physical acceptance?

The correct learning target is to **separate interlocking, guard locking, safe unlock, escape, independent stop/hold, diagnostics, and rearm**. Cases are not a hidden benchmark and must not be self-scored as independent evaluation. Selected machine G0/G1 HOLD; no physical experiment.
