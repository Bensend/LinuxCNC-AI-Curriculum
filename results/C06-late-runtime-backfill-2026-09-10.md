# C06 late-run exact runtime backfill checkpoint

## Integrity correction

A prior conversational checkpoint incorrectly named workflow `34259441495` and commit `1eb9e157...` for C06-039. Direct GitHub API lookup returns no such workflow/commit in this repository. Do not use those identifiers.

The retained repository reconciliation is authoritative: `results/C06-039-sampler-stream-attach-diagnostic-reconciliation.md` identifies workflow `34310141125`, job `102334943692`, source commit `554dcd79bec5eaeb42a13a454a6e7efb27f5a695`, artifact `10088152204`. Fresh GitHub Actions job metadata independently confirms start `2026-09-09T04:13:51Z`, completion `2026-09-09T04:18:21Z`, exactly 270 s = **4.50 min**.

Two subsequent retained diagnostics were also positively matched and independently verified from Actions metadata:

- C06-041: workflow `34310509116`, job `102336017000`, `2026-09-09T04:19:19Z`–`04:22:18Z`, 179 s = **2.98 min**, workflow failure / non-authoritative diagnostic. The retained reconciliation later showed its naive topology conclusion was invalid because filtered `halcmd show` success did not prove object existence.
- C06-043: workflow `34311305551`, job `102338355587`, `2026-09-09T04:31:35Z`–`04:34:40Z`, 185 s = **3.08 min**, successful corrected readiness preflight. It used actual HAL object-name evidence and confirmed full static P0 topology + exact sampler could attach with retained data.

Exact newly recovered subtotal: **10.57 min** (634 s).

These three rows are safe for later integration into `LAB_COMPUTE_LOG.md`; they are not yet included in that ledger's 146.22-min running total, so do not double-count them.

## C06-040 integrity finding

The results directory contains C06-039 and then C06-041 artifacts, with no C06-040 result artifact. Do not infer that C06-040 executed. A positive workflow/job or other retained execution witness is required before assigning it compute.

## Next checkpoint

Continue positive matching from C06-042/C06-044 onward and C07-047/048/049. Integrate only independently verified job timestamps into `LAB_COMPUTE_LOG.md`. Preserve S02/E20/X01/X02 fresh-handoff separation; this maintenance does not graduate them or unblock F02.
