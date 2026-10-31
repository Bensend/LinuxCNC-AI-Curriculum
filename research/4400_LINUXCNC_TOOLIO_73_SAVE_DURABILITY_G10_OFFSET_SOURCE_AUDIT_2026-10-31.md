# 4000-LC-TOOLIO-73 — G10 tool offset is updated before non-atomic file save
**2026-10-31 | NON-GRADUATED | SOURCE-CONFIRMED static; TEST-CONFIRMED none**

## Provenance and question
Stable v2.9.10 peeled `86cdca76fa2a36274c432caa21952b23c267989a`, development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`. Does successful G10 tool-offset handling prove the changed offset is durably persisted?

## Source trace
[Stable ioControl.cc:987–1029](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/iotask/ioControl.cc#L987) and [development taskclass.cc:547–590](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/task/taskclass.cc#L547) first change in-memory tooldata with `tooldata_put`, then call `tooldata_save`; both set an IO error only when save returns nonzero. In DB mode they separately notify DB_PROGRAM, whose acknowledgment limitation is in [TOOLDB-72](4400_LINUXCNC_TOOLDB_72_DB_REFRESH_NAK_NOTIFICATION_SOURCE_AUDIT_2026-10-31.md).

[Stable tooldata_save:370–403](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/tooldata/tooldata_common.cc#L370) and [development:374–414](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/tooldata/tooldata_common.cc#L374) use direct `fopen(filename,"w")` truncation, `fprintf` of entries, `fclose`, then return 0. There is **no temporary-file/rename publication, no explicit fsync, and no checking of fprintf/fclose failure** in this path. Open failure returns -1; write/close errors can escape the return. Development adds missing-filename/errno diagnostics; that is not transactional persistence. In DB mode `db_spindle.tbl` is a separate file and getall ignores its save result.

## Disconnected acceptance (NOT RUN)
1. Disposable valid G10 L1 update: compare local offset, file bytes/hash and restart/reload.
2. Save to nonexistent parent directory: predict open failure but already-updated local state.
3. Synthetic write/close error: use only an isolated fault-injection harness, not disk-filling or physical machine I/O. Check actual return and bytes.
4. Compare DB_PROGRAM and conventional-file paths; do not equate notification with durable DB commit.

## Transfer and uncertainty
An engineering adapter could stage and validate a complete snapshot, check writes/flush/close, fsync file, atomic same-filesystem rename, fsync parent directory and verify reload. This is **review-only**, not an upstream patch. SOURCE-CONFIRMED: update-before-save, direct truncation, unchecked write/close. INFERENCE: persistence divergence/crash loss. UNKNOWN: actual disk failures, GUI behavior, physical consequences. TEST-CONFIRMED none. Closed levels and independent safety/evaluation gates unchanged.
