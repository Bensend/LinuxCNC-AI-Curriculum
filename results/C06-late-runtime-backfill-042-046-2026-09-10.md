# C06 late runtime backfill — 042/044/045/046

Exact GitHub Actions job timestamps were positively matched to retained result commits.

| Lab | Workflow | Job | Start UTC | End UTC | Exact min | Classification |
|---|---:|---:|---|---|---:|---|
| C06-042 persistent-stream topology localizer | 34310857967 | 102337051002 | 2026-09-09T04:24:40Z | 2026-09-09T04:28:09Z | 3.48 | diagnostic PASS |
| C06-044 authoritative real-readiness | 34311582310 | 102339170004 | 2026-09-09T04:36:27Z | 2026-09-09T04:39:52Z | 3.42 | HARNESS INVALID / workflow failure; count compute, no behavioral verdict |
| C06-045 construction-failure attempt | 34312449313 | 102341723740 | 2026-09-09T04:49:20Z | 2026-09-09T04:49:28Z | 0.13 | HARNESS INVALID; failed before substantive LinuxCNC behavior |
| C06-045 successful phase-publication preflight | 34312552726 | 102342021620 | 2026-09-09T04:50:51Z | 2026-09-09T04:54:10Z | 3.32 | PREFLIGHT PASS |
| C06-046 authoritative phase-first | 34312802937 | 102342754452 | 2026-09-09T04:54:49Z | 2026-09-09T04:58:13Z | 3.40 | PASS; later accepted by C06 closure |

Subtotal: **13.75 min**.

Integrity notes: failed/harness-invalid jobs consume compute but do not become behavioral evidence. C06-042 is witnessed by retained result commit `fd6ea69...`; C06-044 by `60ac98e4...`; successful C06-045 by `2312d920...`; C06-046 by `803f0d70...`. Do not double-count C06-039/041/043 from the prior reconciliation.

## Next checkpoint

Reconcile C07-047/048/049 from retained result commits to exact Actions job IDs/timestamps, then integrate all recovered subtotals into the full ledger without replacing historical rows. Preserve S02/E20/X01/X02 fresh-AI information separation.
