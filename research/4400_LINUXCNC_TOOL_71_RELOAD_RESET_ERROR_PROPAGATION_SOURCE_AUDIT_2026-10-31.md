# 4000-LC-TOOL-71 — Nontransactional tool-table reload and version-sensitive error reporting
**2026-10-31 | NON-GRADUATED | SOURCE-CONFIRMED static; TEST-CONFIRMED none**

## Objective and provenance
Determine whether a failed conventional tool-table reload preserves the previous inventory and whether the failure reaches Task/IO status. Compare stable LinuxCNC **v2.9.10**, peeled commit `86cdca76fa2a36274c432caa21952b23c267989a` (tagged 2026-07-02), with development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1` (2026-10-31). This is a userspace/shared-tooldata path, not a realtime servo operation. Official [tool database documentation](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/tooldatabase/tooldatabase.adoc) identifies `[EMCIO]TOOL_TABLE`, `G10 L0`, and Python `linuxcnc.command().load_tool_table()` reload interfaces; it does not promise rollback.

## Source call flow
1. [Stable tooldata_load, lines 273–350](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/tooldata/tooldata_common.cc#L273): check null filename, clear comments, **tooldata_reset() before fopen("r")**, then reset last_index and read rows incrementally. If fopen fails, return -1 **after clearing live entries**, before resetting last_index. Invalid parsed rows print 'Unrecognized line skipped', then `continue`; successful EOF returns 0 despite those skipped rows. No staging/rollback.
2. [Development tooldata_load, lines 281–354](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/tooldata/tooldata_common.cc#L281): same reset-before-open and skip-on-invalid behavior; adds an errno diagnostic and stores comments in the tool record. [tooldata_mmap.cc reset](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/tooldata/tooldata_mmap.cc#L272) clears the shared table under its mutex. Mutex coherence is not transactional inventory preservation.
3. [Stable ioControl.cc, lines 974–986](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/iotask/ioControl.cc#L974) and [ioControl_v2.cc, lines 1129–1141](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/iotask/ioControl_v2.cc#L1129) set IO status RCS_ERROR if `tooldata_load` fails and call `reload_tool_number` only on success. This signals an error but does not restore the old inventory.
4. [Development taskclass.cc, lines 539–545](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/task/taskclass.cc#L539) calls `tooldata_load(file)` **without inspecting its return**, unconditionally calls `reload_tool_number`, and returns 0; [emctaskmain.cc dispatch](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/task/emctaskmain.cc#L2173) consumes that method result. The immediate Task return is not a successful-load oracle; other GUI/error behavior is UNKNOWN.

## Predeclared counterexamples, not observed tests
- Existing T1/T2, then nonexistent path: shared inventory reset before open error. Stable IO error; development method return 0. Exact NML/UI and active spindle-offset consequences **UNKNOWN**.
- Existing T1/T2, then valid T1 plus malformed `T2 P2 Zbad`: invalid line skipped and loader returns success; partial inventory remains.
- Restore valid file and reload: inventory may repopulate, but compare spindle tool/offset separately.

## Reproducible isolation
Use copied sim INI, disposable tool table, no physical HAL/fieldbus. Capture before/after tool table bytes/hash, `linuxcnc.stat` tool inventory where available, tool in spindle, IO/Task status, error logs, and interpreter state. Do not treat `wait_complete()` as a proof of tool inventory. Freeze expectations before executing. All tests NOT RUN.

## Claims and uncertainty
SOURCE-CONFIRMED: reset/open order, malformed-line handling, stable/development consumer divergence. INFERENCE: downstream user-visible inventory loss. UNKNOWN: GUI propagation, motion/tool-offset effects, exact runtime outcomes. TEST-CONFIRMED none. Novelty: full `PROGRESS.md` scan found no prior tooldata/DB_PROGRAM investigation. Closed prerequisite levels, independent personnel-safety authority, and physical G0/G1 HOLD unchanged.
