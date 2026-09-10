# X01-001 exact runtime backfill checkpoint

This maintenance checkpoint records authoritative GitHub Actions job timestamps for the three X01-001 preflight attempts that were still listed as historical compute gaps. These values should be integrated into `LAB_COMPUTE_LOG.md` during the next ledger maintenance pass; they are recorded here now so the lookup need not be repeated.

| Workflow | Job | Start UTC | End UTC | Runtime | Outcome |
|---:|---:|---|---|---:|---|
| `34411511393` | `102666749355` | 2026-09-09T22:18:06Z | 2026-09-09T22:22:01Z | 235 s = 3.92 min | X01-001 attempt 1, workflow failure / harness-invalid lineage |
| `34416110919` | `102681240404` | 2026-09-09T23:15:34Z | 2026-09-09T23:19:09Z | 215 s = 3.58 min | X01-001 attempt 2, workflow failure / harness-invalid lineage |
| `34420657736` | `102695115020` | 2026-09-10T00:17:29Z | 2026-09-10T00:21:08Z | 219 s = 3.65 min | X01-001 attempt 3, workflow failure / three-attempt lineage |

Total newly resolved exact compute: **669 s = 11.15 min**.

Do not change the historical behavioral classification from runtime metadata alone. `PROGRESS.md` already records that X01-001 reached the three-attempt ceiling and the old stream-tag loss oracle was replaced by the materially redesigned X01-002 experiment.
