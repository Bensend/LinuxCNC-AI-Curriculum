# C08-052 — Authoritative Diagnostic Discrimination Reconciliation

Status: **PASS / ACCEPTED TEST-CONFIRMED C08-050 EVIDENCE**

Frozen plan: `experiments/C08-050-diagnostic-discrimination-trace-plan.md`
Frozen-plan commit: `5f1918372167337405f03373f6950602683cc89b`
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Workflow: `34328731569`
Job: `102392025784`
Artifact: `10094968899`
Artifact digest: `sha256:9c53778cc743e4e393dea15145b0058cd7c35d49809d9fd3cb26187dd825f742`
Trigger commit: `abe48c59357d1cfc3dbcc99c2c1f1d931db6b99d`
Job runtime: 2026-09-09T08:22:16Z through 08:26:07Z = 231 s = **3.9 min**.

## Authority and provenance

The authoritative wrapper declared authority before fresh execution and referenced the already-frozen C08-050 plan. It rebuilt the pinned LinuxCNC tree, reran fresh realtime acquisition/collectors, retained the lab component and exact harness, checked production-tree cleanliness, and scored the unchanged Gates A–J.

## Frozen gate results

- **Gate A PASS** — frozen provenance retained; pinned production LinuxCNC tree unchanged.
- **Gate B PASS** — retained realtime function order places `c08diag.0` before main `sampler.1`.
- **Gate C PASS** — main collector actually attached, retained 285 tagged rows, had empty stderr and clean exit.
- **Gate D PASS** — main producer reported `overruns=0`, `full=FALSE`, `curr_depth=0`; retained main tags were contiguous.
- **Gate E PASS** — P0/P4 quiescence and phase-before-decisive-mutation boundaries were retained in the atomic trace.
- **Gate F PASS** — bounded point observations in both P1 and P3 independently showed the deliberately identical coarse symptom `TRUE`.
- **Gate G PASS** — P1 Cause A and symptom asserted together at the sampler boundary with no sampled Cause-A-only lead.
- **Gate H PASS** — P3 retained a Cause-B-only row at phase-local index 14 strictly before the first Cause-B+symptom row at index 15.
- **Gate I PASS** — separate depth-4 FIFO accumulated **32 producer overruns**, reached full depth, then drained successfully retained tags `[0,1,2]` contiguously.
- **Gate J PASS** — reconciliation preserves point-vs-atomic observation, function-order coherence, producer-retention validity, cross-surface clock limits, and diagnostic-vs-safety boundaries.

Authoritative result: **PASS; frozen gates failed: none.**

## TEST-CONFIRMED conclusions

At the pinned revision and deterministic fixture:

1. The same coarse userspace symptom can arise from distinguishable realtime causal histories. A point observation of `symptom=TRUE` does not identify which tested history occurred.
2. Realtime `sampler` evidence can discriminate those histories only when the relevant producer/sampler function order is retained and understood.
3. Sequential `halcmd` reads are point observations and are not accepted as one atomic servo-cycle record.
4. A successful `halsampler` consumer with contiguous retained record tags is not, by itself, proof that every producer sampling attempt was retained.
5. Producer-side overrun evidence is mandatory before making a no-loss claim. The independent tiny-FIFO test proved **32 rejected writes can coexist with contiguous retained tags `[0,1,2]`** at this revision.
6. HAL realtime trace, Task/NML text/status, process logs and physical observations do not automatically form one atomic global timeline; correlation requires explicit synchronization and preserved provenance.
7. Diagnostic evidence is not a safety-rated function and does not prove physical machine state or authorize restart.

## Documentation/source conflict resolution

Current development `hal_stream(3)` prose was observed to describe sample-number advancement even when a write fails. The pinned implementation returns `-ENOSPC` on full before the successful-enqueue sample-number increment, and C08-051/C08-052 independently reproduced the source behavior. The course therefore records this as a version-bounded documentation/source conflict rather than silently harmonizing the two surfaces.

## Promotion state

C08 now has accepted documentation/community/source/call-flow evidence plus authoritative TEST-CONFIRMED behavior. The module advances to **EXAM / HANDOFF / PROMOTION AUDIT**. Do not rerun C08-050 absent a newly discovered defect. The already-frozen `evaluation/C08-adversarial-exam-draft.md` is the next scored artifact.
