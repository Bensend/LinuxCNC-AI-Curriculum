# Active Curriculum Session State

Session start UTC: `2026-09-11T11:11:20Z`
Session end UTC: `2026-09-11T11:26:32Z`
Elapsed: `15.2 min`
Status: **CLOSED — 4600 M66 supervisory-wait call flow traced; M66-TIMEOUT-001 run 079 confirmed stale timeout state can prematurely terminate a following G4 on the pinned LinuxCNC revision.**

## Durable state

- Pinned M66 flow is documented in `call-flows/press-brake-M66-Q-supervisory-wait-timeout.md`: interpreter emits `EMC_AUX_INPUT_WAIT`; Task owns userspace wait/deadline polling; timeout becomes `#5399=-1`; timeout is not an automatic program abort.
- `experiments/M66-TIMEOUT-001-frozen-contract.md` preserves the authoritative pre-result contract (`M66 P0 L1 Q0.20`, G4 P0.50, input HIGH at 0.30 s, frozen ±0.10 s discriminator).
- Run 079 / workflow `34593401753` / job `103243588697` passed. Control G4=0.505165 s; experiment completed at 0.311439 s; transition=0.301064 s; delta=-0.193726 s => `STALE-WAIT INTERACTION CONFIRMED`.
- `experiments/M66-TIMEOUT-001-run079-independent-audit.md` reconciles source and behavior and preserves scope limits.
- `research/M66-timeout-following-dwell-in-tree-example-audit-2026-09-11.md` records that pinned and current-master `nc_files/touchoff.ngc` contain the same `M66 P0 L1 Q5` then `G4 P#2` shape without checking `#5399`; this is an example-code applicability finding, not a hardware-incident claim.
- Exact run-079 Actions compute (3.12 min) was integrated into `LAB_COMPUTE_LOG.md`; exact ledger total is 267.26 min (4.45 h).
- The previously missing 10:12:30Z–10:13:02Z lesson timing row was repaired through the race-safe append workflow.
- S02/E20/X01/X02 fresh-AI information-separation requirement remains intact; F02 remains blocked. PB-PREP-001 remains closed INCONCLUSIVE / no architecture recommendation.

## Precise next-work checkpoint

Do **not** launch a broad M66 simulation matrix. First reduce the confirmed defect into an upstream-style minimal regression/source-fix review: verify that clearing stale auxiliary-input bookkeeping on timeout preserves `#5399=-1`, inspect abort/reset lifetime of the same state, and define one focused regression that covers the confirmed timeout->G4 failure. Then return to the 4600 press-cycle failure-ownership matrix, especially explicit state transitions for pressure-not-achieved, pedal/authorization loss, field-I/O freshness loss, and timeout recovery. Preserve the distinction between Task-level supervisory sequencing, realtime Y1/Y2/control faults, transport freshness, and functional safety.

Overlap: **none**. The repaired previous canonical lesson ended `2026-09-11T10:13:02Z`; this session began `2026-09-11T11:11:20Z`, a gap of 58m18s.
