# 4000-LC-TOOLDB-72 — DB_PROGRAM partial refresh and ignored notification errors
**2026-10-31 | NON-GRADUATED | SOURCE-CONFIRMED static; TEST-CONFIRMED none**

## Scope
LinuxCNC stable v2.9.10 peeled `86cdca76fa2a36274c432caa21952b23c267989a`, development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`. [Official v2.1 DB_PROGRAM protocol](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/tooldatabase/tooldatabase.adoc#L41) specifies userspace child stdin/stdout, startup version, `g` get replies ending FINI, and `p/l/u` notifications. Docs explicitly state that a NAK signals desynchronization but execution continues.

## End-to-end mechanism
- [Stable tooldata_db_getall, lines 194–237](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/tooldata/tooldata_db.cc#L194) and [development equivalent](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/tooldata/tooldata_db.cc#L194) send `g\n`, then **tooldata_reset() before all responses arrive**. They parse each tool directly into the live inventory; a timeout or malformed response returns -1 without rollback. The FINI success path calls `tooldata_save(NULL)` for the random-changer spindle file without checking that return.
- [Stable read_reply, lines 146–179](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/tooldata/tooldata_db.cc#L146) logs any reply containing `NAK` but returns its length. [send_and_verify, lines 181–192](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/tooldata/tooldata_db.cc#L181) accepts any nonnegative reply length, not a specific positive ACK.
- [tooldata_db_notify, lines 303–349](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/tooldata/tooldata_db.cc#L303) builds `p/l/u`, calls `send_and_verify(msg)` **without checking the result**, and returns 0. Development retains this at [lines 302–349](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/tooldata/tooldata_db.cc#L302). Thus both NAK and read timeout may fail to propagate as notifier failure.
- [Development taskclass.cc, lines 312–356 and 547–590](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/task/taskclass.cc#L312) changes local tool slots and sends load/unload/offset notifications separately. Local state, DB child storage, and a command's acknowledgment are distinct oracles.

## Frozen fault matrix — all NOT RUN
| Fault | Source-level prediction | Independent evidence needed |
| --- | --- | --- |
| `g` replies T1, then timeout before FINI | partial live inventory; getall returns -1 | complete before/after inventory and DB transcript |
| `g` replies malformed row | reset then error, no rollback | inventory, parser log |
| `p` returns `NAK no write` | NAK logged; notify returns 0 | local offset versus external DB record |
| `l` gives no reply | timeout not propagated by notify | elapsed time, local/DB snapshots |
| valid `g` through FINI | reload completes; spindle file save result not checked | tool inventory and spindle file bytes |

## Engineering transfer
For a production DB integration, require explicit versioned snapshot/reconciliation and an externally verified acknowledgment of persisted tool identity. This is a recommendation, **not** an upstream implemented guarantee. Never inject these faults on a live toolchanger. SOURCE-CONFIRMED: reset/parse order, NAK and return handling. INFERENCE: desynchronization under injected failures. UNKNOWN: GUI error surface and physical behavior. TEST-CONFIRMED none.
