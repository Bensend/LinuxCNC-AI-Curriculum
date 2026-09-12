# PB-PREP-001 Runs 073–077 — Exact Actions Compute Backfill

Date reconciled: 2026-09-12
Purpose: recover exact GitHub Actions runner compute for historical PB-PREP-001 runs 073–077 without changing their evidence classifications.

## Method

For each run, the workflow/job identity was recovered from preserved lab-result commits. The exact runner envelope was then taken from the GitHub Actions job log timestamps, from the first runner log timestamp through the final cleanup timestamp. This is compute accounting only; it does not upgrade invalid/inconclusive evidence.

| Run | Workflow | Job | Start UTC | End UTC | Exact seconds | Compute min | Existing evidence classification |
|---|---:|---:|---|---|---:|---:|---|
| 073 | `34557570498` | `103133395867` | 2026-09-11T03:12:42.7796429Z | 2026-09-11T03:12:48.4685507Z | 5.6889078 | 0.094815 | HARNESS INVALID |
| 074 | `34557615860` | `103133539173` | 2026-09-11T03:13:25.7815990Z | 2026-09-11T03:13:30.4736239Z | 4.6920249 | 0.078200 | HARNESS INVALID |
| 075 | `34557700647` | `103133787770` | 2026-09-11T03:14:45.2012099Z | 2026-09-11T03:14:49.7885856Z | 4.5873757 | 0.076456 | HARNESS INVALID |
| 076 | `34557791643` | `103134059823` | 2026-09-11T03:16:08.8035156Z | 2026-09-11T03:16:14.4557571Z | 5.6522415 | 0.094204 | FLATTENED CONSTRUCTION / STATIC PREFLIGHT PASS; behavioral comparison deliberately not executed |
| 077 | `34557828294` | `103134175120` | 2026-09-11T03:16:45.3328078Z | 2026-09-11T04:26:50.3411040Z | 4205.0082962 | 70.083472 | WORKFLOW TIMEOUT after complete architecture-A trace; no A/B/C verdict |

## Reconciled subtotal

- Runs 073–077 exact runner-envelope subtotal: **70.427147 min**.
- Rounded ledger-display subtotal: **70.43 min**.
- Existing canonical exactly-backfilled total before this artifact: **268.13 min**.
- Arithmetic total if these five rows are integrated into that canonical ledger with no other changes: **338.557147 min**, displayed **338.56 min (5.64 h)**.
- 2026-09-12 daily subtotal is unchanged because all five runs executed on 2026-09-11.

## Evidence/classification preservation

This backfill does not alter PB-PREP-001’s technical conclusion:

- 073–075 remain HARNESS INVALID.
- 076 remains construction/static-preflight evidence only.
- 077 retained a complete architecture-A trace but timed out before producing a valid A/B/C comparative verdict.
- PB-PREP-001 remains **INCONCLUSIVE / NO ARCHITECTURE RECOMMENDATION** under the frozen experiment contract.

## Canonical-ledger integration note

`LAB_COMPUTE_LOG.md` is intentionally not rewritten in this commit. It is a long append-only ledger and a prior destructive replacement was already caught during maintenance. This artifact is the authoritative exact source for a later safe append/integration of these five rows. Until that append occurs, the ledger’s displayed 268.13-minute running total remains the canonical integrated total, while this artifact records an additional **70.427147 minutes** of exact, not-yet-integrated historical compute.
