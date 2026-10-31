# LinuxCNC tool inventory and persistence — disconnected acceptance guide
**2026-10-31 | ALL NOT RUN | review-only; no physical machine I/O**

Read [TOOL-71](../research/4400_LINUXCNC_TOOL_71_RELOAD_RESET_ERROR_PROPAGATION_SOURCE_AUDIT_2026-10-31.md), [TOOLDB-72](../research/4400_LINUXCNC_TOOLDB_72_DB_REFRESH_NAK_NOTIFICATION_SOURCE_AUDIT_2026-10-31.md), [TOOLIO-73](../research/4400_LINUXCNC_TOOLIO_73_SAVE_DURABILITY_G10_OFFSET_SOURCE_AUDIT_2026-10-31.md). Compare LinuxCNC v2.9.10 peeled `86cdca76fa2a36274c432caa21952b23c267989a` and development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1` in separate **disconnected, disposable sim** environments.

## Minimal nonrandom tool-table fixture
```text
T1 P1 Z10 D6 ; one
T2 P2 Z20 D8 ; two
```
For each case freeze expected outcome and capture: source revision, INI path, exact tool-table bytes/hash, before/after inventory and offsets, spindle tool number, Task/IO status, interpreter state, stderr/stdout, and elapsed time. For DB_PROGRAM, snapshot the external DB separately. A successful command return is not a state oracle.

| Case | Injection | Source prediction | Independent oracle |
| --- | --- | --- | --- |
| TL1 | Valid reload | T1/T2 present | inventory |
| TL2 | Missing file, stable | table reset; IO error | inventory and IO status |
| TL3 | Missing file, development | table reset; Task method ignores loader -1 | inventory and status |
| TL4 | T1 valid, T2 Zbad | T2 skipped, loader success | parser log and inventory |
| TL5 | Restore valid table | inventory recovers; spindle state to check | inventory and tool-in-spindle |
| DB1 | `g` T1 then timeout | partial table, getall -1 | DB transcript + local snapshot |
| DB2 | `g` malformed reply | reset, no rollback | transcript and inventory |
| DB3 | `p` returns NAK | log only; notifier 0 | local vs external DB offset |
| DB4 | `l` times out | notifier discards negative return | timing + DB/local state |
| IO1 | Valid G10 L1 | local/file normally update | memory/file/restart |
| IO2 | Save open failure | local already changed; error returned | memory and IO status |
| IO3 | Inject write/close error | may report success | fault-injection trace/file bytes |

**No case is TEST-CONFIRMED.** Before execution verify the precise command syntax against the pinned executable and positively isolate a `[self-hosted, openpressbrake]` runner from all machine outputs. Do not use GitHub-hosted Actions or manipulate production storage. Record harness validity before any behavioral PASS/FAIL.

Fresh-AI exercise: explain why stable IO ERROR and development Task return 0 can both accompany a cleared inventory, and why DB child NAK is not a persisted-tool acknowledgment. Preserve closed levels, independent evaluator and personnel-safety gates, OpenPressBrake physical G0/G1 HOLD.
