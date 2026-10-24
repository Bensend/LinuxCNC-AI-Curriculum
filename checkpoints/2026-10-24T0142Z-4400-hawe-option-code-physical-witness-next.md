# 4400 safety continuation — 2026-10-24T01:37Z Bosch / HAWE B 6340 + D 6340 variants

**Supersedes** `checkpoints/2026-10-24T0141Z-4400-hawe-gravity-valve-accumulator-next.md`. Session start **2026-10-24T01:37:48Z UTC**, recorded before substantive work. 1000–3000/F02 CLOSED, 2520–25F0 external evaluation OPEN; safety 4400 priority.

## Evidence and artifacts

- [Bosch IH04/IH04E OEM comparison](../research/4400_BOSCH_IH04_VALVE_FEEDBACK_LEAKAGE_REPLACEMENT_SCOPE_AUDIT_2026-10-24.md) and [paper card](../safety-course/4400_HYDRAULIC_VALVE_FEEDBACK_LEAKAGE_SCOPE_TECHNICIAN_CARD_2026-10-24.md): normal valve actual-value not safety authority; OFF can retain pressure; leakage invisible to valve switches; same-type valve replacement reaction-time recheck; different OEM 1/5 mm/s figures **not transferable**. §11AW.
- [HAWE ePRAX real press-brake OEM audit](../research/4400_HAWE_EPRAX_2026_GRAVITY_VALVE_ACCUMULATOR_SAFETY_SOURCE_TRACE_2026-10-24.md) and [paper card](../safety-course/4400_HAWE_EPRAX_GRAVITY_VALVE_STORED_ENERGY_TECHNICIAN_CARD_2026-10-24.md): B 6340 04-2026 gravity-assisted FAST DOWN, ordinary drive throttle versus safety valve withdrawal, linear-scale safety speed witness, optional accumulator Slow Up; **D 6340 07-2026** source now proves **`S` monitored-valve versus no-monitoring option** and **`X` no Slow Up versus `A/B` accumulator variants**. OEM revisions must be reconciled. §11AX.
- **No selected OpenPressBrake hardware** confirmed; no inferred hydraulic truth table, PL/SIL, safe speed, stopping time/distance, pressure, drift limit or numerical acceptance. `IN-01..10/OPT/PHY UNKNOWN`, `VAL/PT NOT RUN`, G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. 2520–25F0 external blind gates OPEN; original exact archive **6/85 pending**. No physical tests or simulation.
- Self-hosted-only run 39919548510/job 120301190483 last checked **QUEUED** on `[self-hosted,openpressbrake]`; no authoritative job runtime, `LAB_COMPUTE_LOG.md` unchanged, hosted/self-hosted compute 0.

## Next highest-value work

1. Selected-machine **both Y1/Y2** as-built hydraulic and safety I/O diagrams, photographed full part/order codes and revisions, monitored-valve and accumulator option identification, pressure-zone/physical beam-hold witnesses, independent safety-controller and linear-scale coupling, mechanical ram restraint, guard/occupancy and deliberate local restart. Record `BND/ENE/PHY/AUTH/DEP/ARC/VAL/PT` with exact provenance; no personnel-exposed operation until minimum independent protections are demonstrated. Experimental movement only isolated/remote, all people outside danger zone, residual risk explicit.
2. If unavailable, rotate to an **independent** OEM-specific fault/maintenance boundary not covered here, rather than repeating stop-time algebra or 3000 material. Full ISO 6909:2026 normative text still unavailable; public scope only. Six original archive files require exact bytes.
3. No lab justified now; if a genuine unresolved question arises, `[self-hosted,openpressbrake]` only, no GitHub-hosted minutes. Keep hourly automation enabled.
4. Immediately before ending append UTC end, elapsed and overlap to **complete** `LESSON_LOG.md` using a fresh SHA guard, verify and commit. Previous canonical end 2026-10-24T00:39:16.001Z.
