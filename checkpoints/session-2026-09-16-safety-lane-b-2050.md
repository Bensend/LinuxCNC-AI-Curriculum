# Independent safety curriculum Lane B checkpoint — 2026-09-16 20:50Z

- Primary-lane state checked immediately before selection: latest durable primary commit was `40db0c4` (`safety: checkpoint modern valve and servo energy-boundary research`). Primary files concern modern press-brake PCSS hydraulic final-element monitoring and servo-machine SS1/STO energy boundaries.
- Lane-B prior checkpoint: `36488e4` (`checkpoint: advance safety lane B to spare readiness evidence`).
- Parallel-work decision: selected the already-checkpointed spare-readiness evidence task because it is independent of the primary lane's OEM energy-boundary tracing and uses a new artifact.
- Compute: NONE. No simulation, synthesis, benchmarking or executable verification was needed; no GitHub-hosted Actions minutes consumed.

## Durable work completed

Created `safety-course/SAFETY_SPARE_READINESS_EVIDENCE_CARD.md` at commit `73eb723`.

The card is intentionally compact enough to back a physical-bin/CMMS record while referring to the deeper lifecycle and substitution worksheets rather than duplicating them.

## Frozen rules added

1. A stocked part is not a ready safety spare until identity, provenance, substitution basis, storage condition, configuration dependencies, affected safety functions and post-installation revalidation are bounded.
2. `APPROVED-SPARE` means approved for controlled installation under documented conditions; it does not mean the machine safety function has already been validated with that physical unit.
3. Same connector, voltage, current, dimensions or mounting pattern is not sufficient evidence of safety equivalence.
4. An unresolved safety-relevant `UNKNOWN` capable of defeating the safety function blocks `APPROVED-SPARE` status.
5. Installation success, project download success or a healthy status bit is not physical validation.
6. Post-installation proof must state the physical stimulus, independent observation, affected reset/restart behavior and bounded conclusion.
7. The card explicitly rejects inventing generic shelf life, stopping distance, pressure threshold, valve truth table, PL/SIL/category, diagnostic coverage or proof-test interval.
8. Physical-bin labels must not call an uninstalled spare `SAFE`, `DROP-IN` or `VALIDATED`; they point to the current evidence record and readiness state instead.

## Main re-read / overlap check

After the artifact commit, current `main` was re-read through the recent commit list. HEAD was `73eb723`, directly following primary checkpoint `40db0c4`; no overlapping primary-lane file changed during this Lane-B work. No reconciliation was required.

## Exact next independent work

Build a **safety spare inventory reconciliation / quarantine audit worksheet** that answers a different lifecycle question from the per-part readiness card:

- reconcile physical bin contents against CMMS/approved-spare records;
- detect wrong revision, mixed lots, unidentified/cannibalized parts, expired or unknown calibration/certificate state, missing firmware/configuration dependencies and opened/damaged packaging;
- force unknown-provenance items to quarantine rather than allowing visual similarity to authorize use;
- record missing approved spares that create maintenance pressure toward unsafe substitution;
- identify obsolete parts whose approved successor basis must be rechecked;
- define periodic audit evidence without inventing a universal audit interval;
- keep procurement/inventory readiness separate from machine safety validation after installation.

Before doing that work, re-read current `main` and the primary lane's newest durable work again. If the primary lane has moved into spare-parts/maintenance inventory work, switch Lane B to another independent safety gap rather than overlapping it.
