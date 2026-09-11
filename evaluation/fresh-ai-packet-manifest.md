# Fresh-AI packet identity manifest

Status: **AUTHORITATIVE ROUTING MANIFEST**
Date: 2026-09-11

This manifest exists because an external evaluation was previously returned with module titles that did not match the repository's actual module identities. That evaluation was classified ROUTING INVALID and had no graduation consequence.

Before accepting any future fresh-AI score for these 2000-level prerequisites, require the evaluator to state all of the following before scoring:

1. Repository: `Bensend/LinuxCNC-AI-Curriculum`.
2. Module ID.
3. Exact packet path from this manifest.
4. A short scenario summary consistent with that packet.
5. Confirmation that the evaluator has not been given the prohibited learner answer/answer key and is information-separated from the learner that created/reconciled the module.

A score whose title, scenario, or packet path does not match is **ROUTING INVALID**, not PASS, CONDITIONAL PASS, or FAIL for the named module.

| Module | Authoritative fresh-AI packet | Scenario fingerprint |
|---|---|---|
| S02 | `handoffs/S02-fresh-ai-feedback-integrity-transfer.md` | Dual feedback channels may agree while physical truth differs; separates transport freshness, sensor freshness, common-cause observability, quadrature diagnostic scope, watchdog/output authority and recorder integrity. |
| E20 | `evaluation/E20-fresh-ai-handoff-packet.md` | Mesa Ethernet communication fault recovers; asks whether green transport/driver/watchdog diagnostics justify automatic machine motion reauthorization. |
| X01 | `handoffs/X01-fresh-ai-recorder-integrity-transfer.md` | HAL `sampler` FIFO/producer-overrun and deterministic-payload continuity determine recorder coverage; contiguous userspace `-t` output alone is insufficient. |
| X02 | `handoffs/X02-fresh-ai-multi-surface-diagnostics-transfer.md` | HAL realtime generation, Task/motion heartbeats, Python observer time and GUI timestamps must not be conflated into same-cycle identity or physical-motion proof. |

## Graduation consequence

S02, E20, X01 and X02 remain technically accepted but fresh-AI-handoff pending until valid information-separated results are recorded for the matching packets above. F02 remains blocked until all required handoffs are valid. A failure on a correctly routed packet triggers corrections tied to that packet's actual mechanism; a routing mismatch triggers no module correction.

## Re-evaluation order

The four packets may be evaluated independently. No learner-side self-scoring is allowed. After a valid result is returned, preserve the evaluator response and its identity header before applying any corrections or graduation status change.