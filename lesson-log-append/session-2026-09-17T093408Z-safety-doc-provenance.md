# LESSON_LOG safe append fragment

Append this row to `LESSON_LOG.md` using the repository safe-append path when full-file atomic append is available:

| 2026-09-17 | 4000 Safety — document provenance and supersession | 2026-09-17T09:34:08Z | 2026-09-17T09:35:42Z | 1.57 | CHECKPOINTED | `checkpoints/session-2026-09-17-safety-doc-provenance.md` | No overlap detected from newest durable repository state; no compute used. |

The connector exposed only a truncated/sliced read of the large lesson log and no verified append primitive, so the log was not overwritten.
