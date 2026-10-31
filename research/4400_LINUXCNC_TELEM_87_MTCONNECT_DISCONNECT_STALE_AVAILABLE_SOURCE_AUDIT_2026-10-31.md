# 4000-LC-TELEM-87 — MTConnect disconnect leaves last AVAILABLE and status values in /current (2026-10-31)

**Status:** SOURCE-CONFIRMED conditional transition, TEST-CONFIRMED none, NON-GRADUATED. Complements [TELEM-86](4400_LINUXCNC_TELEM_86_MTCONNECT_ACTUAL_SPINDLE_AND_POLL_FRESHNESS_SOURCE_AUDIT_2026-10-31.md). LinuxCNC pinned development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`. The MTConnect source path was absent at inspected stable v2.9.10. No agent, LinuxCNC runtime or ROS 2 process executed.

## New question
If LinuxCNC was live, the MTConnect agent published `AVAILABLE` and RPM, and then `linuxcnc.stat.poll()` begins throwing, does the `/current` document transition to `UNAVAILABLE`, or can it retain last-good values? This is different from TELEM-86's **semantic** mismatch (ACTUAL vs commanded) and heartbeat freshness; it is an **explicit disconnect transition**.

## Exact source call chain
1. [`lib/python/mtc/lcnc_source.py` lines 89–109](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/lib/python/mtc/lcnc_source.py#L89-L109): successful `stat.poll()` sets `_live=True`; exception sets `_live=False`. `sample_values()` returns `{}` when not available. A live sample includes `vals["avail"]="AVAILABLE"` at [line 113](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/lib/python/mtc/lcnc_source.py#L106-L115).
2. [`lib/python/mtc/agent.py` lines 82–94](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/lib/python/mtc/agent.py#L82-L94): `poll_once()` calls `source.poll()`, obtains the empty source values, optionally adds separate HAL_ITEM values, and calls `buffer.ingest(values, now_iso())`. There is no explicit `avail="UNAVAILABLE"` inserted here when `source.available()` is false.
3. [`lib/python/mtc/streams.py` lines 70–98](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/lib/python/mtc/streams.py#L70-L98): `ObservationBuffer.ingest` **skips** each DataItem whose id is absent from `values`. `_latest` is therefore unchanged for those items. `current()` synthesizes `UNAVAILABLE` **only for items that have never had a value**; an old `AVAILABLE` observation persists after disconnect.
4. [`lib/python/mtc/agent.py` lines 150–152](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/lib/python/mtc/agent.py#L150-L152) and [`streams.py` lines 200–202](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/lib/python/mtc/streams.py#L200-L202): `current_document()` constructs a fresh document/header timestamp using the unchanged latest observations.

**SOURCE-CONFIRMED conditional result:** after a prior successful poll, if the agent remains running and subsequent LinuxCNC polls fail, its `/current` path can continue exposing **old `AVAILABLE` and last-known speed/position observations**, even while new HTTP document timestamps are generated. The old observation timestamps remain attached to their values; a sophisticated consumer can distinguish their age. A naïve consumer using only `AVAILABLE` or the document creation time can misinterpret the state.

## Minimal transition walkthrough (reasoned, NOT RUN)
| Step | LinuxCNC source | `sample_values` | `buffer.ingest` | `/current` `avail` |
|---|---|---|---|---|
| 0 | never polled | `{}` | no values | synthesized UNAVAILABLE |
| 1 | poll succeeds, spindle speed=1000 | `{"avail":"AVAILABLE","spdl_speed":...}` | stores values and sequence | AVAILABLE |
| 2 | poll throws, agent remains running | `{}` (unless independent HAL items) | skips absent `avail` and speed keys | **still AVAILABLE from step 1** |
| 3 | repeated failures | same | no invalidation | **still AVAILABLE** |
| 4 | poll succeeds again | new values | only changed values get new observations | AVAILABLE, possibly unchanged old timestamp if same value |

The exact RPM is not needed to establish the defect; the causal issue is **missing-key skip**. `HalSource.sample_values()` in [`hal_items.py` lines 161–179](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/lib/python/mtc/hal_items.py#L161-L179) can add user HAL data but does not synthesize a LinuxCNC source availability transition.

## Existing tests and what they do not prove
[`configs/sim/axis/mtconnect/test_mtc.py` lines 280–289](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/configs/sim/axis/mtconnect/test_mtc.py#L280-L289) tests an initially offline source returning empty values; that is **not** the live→offline transition with a populated buffer. No existing transition test was verified in this inspection. Do not claim a reproduced upstream regression.

## Integration consequence and review-only correction
For ROS 2/MTConnect external consumers, maintain **both** observation age and explicit connection/heartbeat validity; never use document creationTime alone. A candidate upstream correction is to inject `avail="UNAVAILABLE"` and invalidate selected source-backed DataItems when `LcncSource.available()` becomes false, with a transition regression that checks /current and /sample. That requires a maintainer decision about how to represent stale measurements and avoid spurious asset-change events. No patch is submitted.

**Evidence:** SOURCE-CONFIRMED on pinned development path; INFERENCE external consumer misuse; TEST-CONFIRMED none. No Actions, simulation, machine operation, independent evaluator or physical/safety claim. [Read-only bridge guide](../guides/4000-linuxcnc-ros2-mtconnect-status-provenance-review-2026-10-31.md).
