# MOTION-221 — Maintained LinuxCNC-EtherCAT: WKC telemetry versus Sync Unit freshness (4000, NON-GRADUATED)

Date 2026-11-04. Prerequisite [MOTION-220](4400_LINUXCNC_MOTION_220_LCEC_HAL_AL_PIN_SEMANTICS_2026-11-04.md). No runtime, hardware, build or CI. This investigation **supersedes the assumption that archived lcec's lack of a WKC pin describes current maintained lcec**.

## Provenance and version boundary

The non-archived [linuxcnc-ethercat/linuxcnc-ethercat](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat) README explicitly identifies this as the development home forked from sittner in 2023. Inspected [src/lcec_main.c](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/master/src/lcec_main.c), **content blob SHA `85fc4a195c1e7c83d27835285e50a9c744e7eecf`**, function and line anchors below. This is an immutable *blob* identity for the inspected content, not a verified branch commit; retrieve that blob before repeating claims against a newer checkout. [README.md](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/master/README.md) blob `764667388ec014f071007c62b60928f60b9769d4`. Archived comparison: sittner commit `225d5a3589a7cf8ccb8ee9edc894c1ddad4a7b13`, MOTION-219/220.

## Implementation trace — SOURCE-CONFIRMED for inspected blob

1. `master_pins` around lines 77–82 exports `%s.wkc` (u32), `%s.wkc-min` (u32), `%s.wkc-change-count` (u32), `%s.wkc-state` (s32), and `%s.wkc-reset` (bit, HAL_IO). This **differs from archived MOTION-220's pin inventory**. `sync_unit_pins` around lines 117–124 exports corresponding per-unit WKC pins and `%s.%s.syncunit.%s.fresh`; exported only when master has more than one Sync Unit per source comment. Actual prefixes depend on configured master/unit names.
2. `lcec_read_master` around lines 1656–1704 calls `ecrt_master_receive`; for each Sync Unit sets `process=queued`, calls `ecrt_domain_process` **only for queued units**, and calls `ecrt_domain_state` for each domain. Unsheduled units retain their *last reported* state; aggregate master `wkc` sums unit counters, while aggregate `wkc-state` is COMPLETE only if all are COMPLETE, ZERO if all ZERO, otherwise INCOMPLETE.
3. Around lines 1719–1747, master `wkc-min` and change count start tracking **after first COMPLETE exchange**, and `wkc-reset` self-clears/re-arms. These are historical statistics, not packet timestamps or a per-cycle Boolean success pin.
4. Around lines 1788–1800, unthreaded slave `proc_read` callbacks execute whenever their Sync Unit was processed, **without an explicit `EC_WC_COMPLETE` gate** in that call condition. The unit `fresh` bit is assigned `sync_unit->process`, i.e. **a domain was scheduled/processed in this tick**, not proof its working counter was complete. Do not equate `fresh=1` with valid new PDO payload.
5. `lcec_read_all` invokes each master and updates aggregate AL state; the README's minimal HAL sequence uses `lcec.read-all` before `lcec.write-all`. Slave AL-state polling remains a different cadence from domain processing.

## Practical diagnostic matrix (disconnected review oracle)

| Situation | Unit process/fresh | Domain WKC state | Interpretation |
|---|---|---|---|
| Scheduled, complete exchange | 1 | COMPLETE | Successful domain-level WC reported; not proof of independent motor position |
| Scheduled, incomplete exchange | 1 | INCOMPLETE | Callback may run on PDO image despite incomplete exchange; treat values as potentially stale |
| Not scheduled (e.g. slow unit on alternate 1 ms tick) | 0 | last state retained | A COMPLETE WKC displayed now may describe an earlier exchange; not an error by itself |
| Two units, one COMPLETE and one INCOMPLETE | unit-specific | master INCOMPLETE | Master aggregate cannot identify which unit failed; inspect per-unit pins |
| After reset before first COMPLETE | variable | ZERO/INCOMPLETE | wkc-min/change-count not yet a meaningful steady-state loss history |

These are deductions from inspected assignments, **not executed outcomes**. The IgH internal buffer-retention and device callback implementation are still UNKNOWN; incomplete WKC does not by itself prove which bytes remain stale.

## Minimal reproducible source exercise

1. Retrieve the immutable `lcec_main.c` blob and inspect `master_pins`, `sync_unit_pins`, `lcec_read_master`, `lcec_update_sync_unit_wkc`.
2. On a *disconnected simulation/review* only, trace a 1 ms master with a 2 ms slow unit across ticks 0, 1, 2. Predict `fresh` = 1,0,1 while slow unit WKC state can remain COMPLETE on tick 1. Check the `process=queued` and `ecrt_domain_state` paths.
3. In an actual independently authorized lab, record `wkc`, `wkc-state`, per-unit `fresh`, `wkc-change-count`, and actual joint feedback at servo cadence; separately record domain queue schedule. **No lab was performed here.**
4. Avoid connecting `fresh` or `all-op` alone as an actuator permissive; personnel-safety authority remains independent.

## Adversarial review questions (not a blind exam)

- Does `fresh=1` prove that all expected PDO bytes were received? **No**; it is set from `process`.
- Does `wkc-state=COMPLETE` on an unscheduled slow-domain tick prove a new exchange happened? **No**; state is retained.
- Can master `wkc-state=INCOMPLETE` identify a specific faulty slave? **No**; inspect unit/device data.
- Is an incomplete WKC sufficient to conclude a particular encoder value stayed unchanged? **No**; IgH data and device callback require inspection.
- Are archived MOTION-220 pin inventories correct for the maintained branch? **No**; maintained branch adds WKC telemetry.

## Evidence ledger and next dependency

| Claim | Classification | Evidence | Remaining |
|---|---|---|---|
| Maintained fork and recommended package source | SOURCE/DOC-CONFIRMED at inspected README blob | README | Installed versions differ |
| WKC pin names and reset semantics | SOURCE-CONFIRMED | `lcec_main.c` lines 77–82, 1719–1747 | Verify deployment revision |
| Scheduled domain vs WC validity distinction | SOURCE-CONFIRMED | lines 1656–1704, 1788–1800 | Test with IgH |
| Exact IgH WC enum values and buffer semantics | UNKNOWN | Not inspected | Read maintained `ethercat` `ecrt.h` and domain receive path |
| Device callback stale-data effects | UNKNOWN | Not inspected | Trace one generic/servo `proc_read` |
| Physical response / tested reliability | NOT TESTED | None | Isolated self-hosted test only if justified |

**Next:** Pin maintained IgH EtherCAT master source and inspect `ec_domain_state_t`, `EC_WC_*`, domain process and data-buffer lifetime; then one device `proc_read`. Rotate to trajectory planner if source path stalls. Preserve graduated levels, blind evaluator separation, and independent safety gates.
