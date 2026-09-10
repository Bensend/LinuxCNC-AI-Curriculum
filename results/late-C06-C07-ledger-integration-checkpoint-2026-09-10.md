# Late C06/C07 ledger integration checkpoint

The exact historical backfills are now reconciled as one non-overlapping set for safe integration into `LAB_COMPUTE_LOG.md`.

## Rows integrated

| Lab | Workflow | Job | Start UTC | End UTC | Seconds | Display min | Classification |
|---|---:|---:|---|---|---:|---:|---|
| C06-039 | 34310141125 | 102334943692 | 2026-09-09T04:13:51Z | 2026-09-09T04:18:21Z | 270 | 4.50 | diagnostic / non-authoritative |
| C06-041 | 34310509116 | 102336017000 | 2026-09-09T04:19:19Z | 2026-09-09T04:22:18Z | 179 | 2.98 | failed diagnostic / non-authoritative |
| C06-042 | 34310857967 | 102337051002 | 2026-09-09T04:24:40Z | 2026-09-09T04:28:09Z | 209 | 3.48 | diagnostic PASS |
| C06-043 | 34311305551 | 102338355587 | 2026-09-09T04:31:35Z | 2026-09-09T04:34:40Z | 185 | 3.08 | corrected readiness preflight PASS |
| C06-044 | 34311582310 | 102339170004 | 2026-09-09T04:36:27Z | 2026-09-09T04:39:52Z | 205 | 3.42 | HARNESS INVALID; count compute only |
| C06-045 construction failure | 34312449313 | 102341723740 | 2026-09-09T04:49:20Z | 2026-09-09T04:49:28Z | 8 | 0.13 | workflow failure before useful behavior |
| C06-045 successful preflight | 34312552726 | 102342021620 | 2026-09-09T04:50:51Z | 2026-09-09T04:54:10Z | 199 | 3.32 | PREFLIGHT PASS |
| C06-046 | 34312802937 | 102342754452 | 2026-09-09T04:54:49Z | 2026-09-09T04:58:13Z | 204 | 3.40 | authoritative PASS |
| C07-047 | 34314733007 | 102348466843 | 2026-09-09T05:24:19Z | 2026-09-09T05:27:49Z | 210 | 3.50 | non-authoritative preflight PASS |
| C07-048 | 34318296679 | 102359108023 | 2026-09-09T06:15:57Z | 2026-09-09T06:19:25Z | 208 | 3.47 | non-authoritative preflight PASS |
| C07-049 | 34318656849 | 102360226472 | 2026-09-09T06:21:01Z | 2026-09-09T06:24:10Z | 189 | 3.15 | authoritative PASS |

Exact interval sum = **2,066 s = 34.433333... min**, therefore **34.43 min** when displayed to two decimals. The earlier checkpoint incorrectly stated 34.44 min; deterministic recomputation during integration caught and corrected that one-hundredth-minute rounding/accounting error.

Existing exact ledger total before this block = **146.22 min**. The correctly rounded post-integration total from the ledger rows is therefore **180.65 min (3.01 h)**. These are historical 2026-09-09 jobs, so the existing 2026-09-10 exact subtotal remains **24.72 min**.

C06-040 remains deliberately uncounted: no positive execution witness has been established. Do not infer a run from numbering continuity.

## Integrity checks

- The 11 rows are now integrated into `LAB_COMPUTE_LOG.md` by an idempotent workflow keyed on workflow-run ID.
- The helper recomputes displayed totals from all ledger rows using decimal arithmetic, preventing silent overwrite/drop of historical rows.
- Evidence classification remains separate from compute accounting: failed and preflight jobs consume compute without becoming authoritative behavioral evidence.
- S02/E20/X01/X02 remain fresh-AI handoff pending; this accounting work does not satisfy those requirements or unblock F02.

## Next checkpoint

Repair the missing 15:11 lesson timing row and stale `SESSION_ACTIVE.md` marker. Preserve S02/E20/X01/X02 as technically accepted / handoff pending. If genuinely information-separated evaluation is still unavailable, continue evidence-integrity or other dependency-safe work without self-certifying transfer.
