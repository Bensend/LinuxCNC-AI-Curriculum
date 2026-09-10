# C06 late runtime backfill — 042/044/045/046

Exact GitHub Actions job timestamps were positively matched to retained result commits. These values are durable reconciliation evidence for later integration into `LAB_COMPUTE_LOG.md` without estimating from workflow envelopes.

| Lab | Workflow | Job | Start UTC | End UTC | Exact min | Classification |
|---|---:|---:|---|---|---:|---|
| C06-042 persistent-stream topology localizer | 34310857967 | 102337051002 | 2026-09-09T04:24:40Z | 2026-09-09T04:28:09Z | 3.48 | diagnostic PASS |
| C06-044 authoritative real-readiness | 34311582310 | 102339170004 | 2026-09-09T04:36:27Z | 2026-09-09T04:39:52Z | 3.42 | HARNESS INVALID / workflow failure; count compute, no behavioral verdict |
| C06-045 successful phase-publication preflight | 34312552726 | 102342021620 | 2026-09-09T04:50:51Z | 2026-09-09T04:54:10Z | 3.32 | PREFLIGHT PASS |
| C06-046 authoritative phase-first | 34312802937 | 102342754452 | 2026-09-09T04:54:49Z | 2026-09-09T04:58:13Z | 3.40 | PASS; later accepted by C06 closure |

Subtotal: **13.62 min**.

Important integrity notes:

- C06-042 is positively witnessed by retained result commit `fd6ea69aae5a1ab89a5f8b45f3874bdfa5e9c1ce`.
- C06-044 is positively witnessed by retained result commit `60ac98e4b0597e9ee1cbfad384fbd0fdc9e4808a`; its failed workflow still consumed compute but does not become accepted behavioral evidence.
- The successful C06-045 run is positively witnessed by `2312d9201d03d773aa7c1e7dc11eefc125251dbe`. An earlier construction-failure run of the same lab number (`34312449313`) remains to be backfilled separately.
- C06-046 is positively witnessed by `803f0d70fa263d71f914c9142b39116f87087e90`.
- Do not double-count C06-039/041/043, which were reconciled in the prior backfill checkpoint.

## Next checkpoint

1. Obtain exact job metadata for C06-045 construction-failure workflow `34312449313` and count it separately.
2. Reconcile C07-047/048/049 from retained result commits to exact Actions job IDs/timestamps.
3. Integrate this subtotal into the full compute ledger only with preservation of all existing historical rows.
4. Preserve S02/E20/X01/X02 fresh-AI information separation; this maintenance work does not satisfy their pending handoffs.
