# Late C06/C07 ledger integration checkpoint

The exact historical backfills are now reconciled as one non-overlapping set for safe integration into `LAB_COMPUTE_LOG.md`.

## Rows to integrate

| Lab | Workflow | Job | Start UTC | End UTC | Min | Classification |
|---|---:|---:|---|---|---:|---|
| C06-039 | 34310141125 | 102334943692 | 2026-09-09T04:13:51Z | 2026-09-09T04:18:21Z | 4.50 | diagnostic / non-authoritative |
| C06-041 | 34310509116 | 102336017000 | 2026-09-09T04:19:19Z | 2026-09-09T04:22:18Z | 2.98 | failed diagnostic / non-authoritative |
| C06-042 | 34310857967 | 102337051002 | 2026-09-09T04:24:40Z | 2026-09-09T04:28:09Z | 3.48 | diagnostic PASS |
| C06-043 | 34311305551 | 102338355587 | 2026-09-09T04:31:35Z | 2026-09-09T04:34:40Z | 3.08 | corrected readiness preflight PASS |
| C06-044 | 34311582310 | 102339170004 | 2026-09-09T04:36:27Z | 2026-09-09T04:39:52Z | 3.42 | HARNESS INVALID; count compute only |
| C06-045 construction failure | 34312449313 | 102341723740 | 2026-09-09T04:49:20Z | 2026-09-09T04:49:28Z | 0.13 | workflow failure before useful behavior |
| C06-045 successful preflight | 34312552726 | 102342021620 | 2026-09-09T04:50:51Z | 2026-09-09T04:54:10Z | 3.32 | PREFLIGHT PASS |
| C06-046 | 34312802937 | 102342754452 | 2026-09-09T04:54:49Z | 2026-09-09T04:58:13Z | 3.40 | authoritative PASS |
| C07-047 | 34314733007 | 102348466843 | 2026-09-09T05:24:19Z | 2026-09-09T05:27:49Z | 3.50 | non-authoritative preflight PASS |
| C07-048 | 34318296679 | 102359108023 | 2026-09-09T06:15:57Z | 2026-09-09T06:19:25Z | 3.47 | non-authoritative preflight PASS |
| C07-049 | 34318656849 | 102360226472 | 2026-09-09T06:21:01Z | 2026-09-09T06:24:10Z | 3.15 | authoritative PASS |

Verified addition = **34.44 min**. Existing exact ledger total = **146.22 min**. Therefore the correct post-integration exact total is **180.66 min = 3.011 h**. These are historical 2026-09-09 jobs, so the existing 2026-09-10 exact subtotal remains **24.72 min**.

C06-040 remains deliberately uncounted: no positive execution witness has been established. Do not infer a run from numbering continuity.

## Integrity checks

- No row above is already present in the current `LAB_COMPUTE_LOG.md`; its integrated coverage stops at C06-038 and separately contains later C08/X01/X02 rows.
- The C06-045 construction-failure runtime was independently verified directly from Actions job metadata: job 102341723740 ran 04:49:20Z–04:49:28Z (8 s).
- Evidence classification remains separate from compute accounting: failed and preflight jobs consume compute without becoming authoritative behavioral evidence.
- S02/E20/X01/X02 remain fresh-AI handoff pending; this accounting work does not satisfy those requirements or unblock F02.

## Next checkpoint

Integrate these 11 rows into `LAB_COMPUTE_LOG.md` atomically while preserving every existing historical row; set exact total to 180.66 min (3.01 h), leave 2026-09-10 subtotal at 24.72 min, and remove late-C06/C07 from the immediate backfill queue. Then continue with genuinely information-separated S02/E20/X01/X02 handoffs when available.
