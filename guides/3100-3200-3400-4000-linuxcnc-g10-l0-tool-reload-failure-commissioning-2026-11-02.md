# LinuxCNC G10 L0 tool-table reload failure — disconnected commissioning (3100/3200/3400/4000)

**Purpose:** distinguish interpreter acceptance, IO/Task acknowledgment, and actual tooldata contents. **Research only, NOT RUN.** Source [TOOL-RELOAD-172](../research/4400_LINUXCNC_TOOL_RELOAD_172_G10L0_FAILED_OPEN_TASK_STATUS_ATOMICITY_SOURCE_AUDIT_2026-11-02.md). Versions: v2.9.10 and development `67437d8865e431a9a33f74cee912dbf891d3b4c5`. Do not run on any machine with connected drives/spindle. No safety qualification follows.

## Use the upstream configuration rather than inventing a machine
Start from `configs/sim/axis/db_demo/` (nonrandom demo) for valid DB reload, and a **copy** of a stock no-hardware simulation INI with `[EMCIO] TOOL_TABLE=<temporary copy>` for file-failure cases. Never rename an installed machine's real tool table or use a shared production database. Verify that only simulated joint/axis feedback is connected and no Mesa, EtherCAT, USB, serial, or other physical outputs can energize. Capture `git rev-parse HEAD`, selected INI, tool file hash, `[EMCIO]` fields, process logs and the initial tool-table snapshot.

## Frozen case matrix
A. **Valid baseline:** no tool in spindle (`T0 M6` only on a suitable simulated toolchanger); save table and `#5400`–`#5413`, issue `G10 L0`; expect refreshed table with no error. Check that it actually changed only if the fixture file/database was intentionally changed.

B. **Loaded-tool guard:** load a simulated tool `T1 M6`; issue `G10 L0`; expect interpreter rejection before `RELOAD_TOOLDATA`. Record `#5400`, tool table and error. Unload through the configured simulated toolchanger, not `M61 Q0`.

C. **Missing-file negative:** in a disposable file-mode simulation with spindle empty, rename the **copy** of TOOL_TABLE after a successful baseline. Issue `G10 L0`; capture interpreter result, Task/IO `RCS_STATUS`, tool-table entries (at least two distinct tool numbers, geometry and pocket), `#5400`–`#5413`, and error text. **Source predictions:** both revisions reset before failed open; stable IO sets RCS_ERROR, development Task discards failure. Actual outcome NOT RUN. Restore original file before exit; if table is empty, do not attempt tool selection or compensated motion.

D. **Malformed-file negative:** copy a valid table; insert one deliberately malformed line between two known valid tool entries; run G10 L0 in a fresh disposable sim and record which entries survive. **Source prediction:** malformed line skipped and overall `tooldata_load` may return 0; do not claim a parse failure without log/return witness.

E. **DB_PROGRAM case:** use the upstream `db_nonran.ini` and `base.ngc` for valid database rules. If failure injection is justified, isolate a copy of the DB backend and intentionally make one `g` request fail; record protocol messages, `db_mode` transition, Task status and table. DB path differs from file-open path. Never run this on a production database.

F. **G43 persistence:** with a known simulated tool offset, record `#5403` (table value) separately from applied tool offset (e.g., `#5083` where applicable). Change a **copy** of table data, reload only with no tool loaded, then explicitly reselect/reapply G43 in the sim; do not infer that G10 L0 itself reapplies the tool length.

## Minimal G-code (no motion)
See [fixture](../examples/4000_tool_reload_172/g10_l0_no_motion.ngc). It deliberately does not perform T/M6, G0/G1, spindle or probing. Run only after separately confirming the tool-empty precondition in the selected simulator. For missing-file case, the file rename is a **manual fixture setup** before running the program, not part of G-code.

## Oracle and evidence gate
Predeclare exact expected tool numbers/geometry and error classes for each revision. PASS requires actual post-command table entries, not merely return 0, G-code preview, or a GUI toast. For C, record both the failure **status** and the **table preservation** outcome: these are separate assertions. If one fails, do not mark the other passed. No runtime results exist at authoring. Only dispatch compute on independently verified physically disconnected `[self-hosted, openpressbrake]`; **never** GitHub-hosted runners. Preserve independent personnel safety and existing evaluator gates.

## Implementation change review
The [review-only patch](../examples/4000_tool_reload_172/development_failed_open_and_status_review_only.patch) is a two-part minimal candidate: check return in development Task; open file before clearing tooldata. It is **not** sufficient for malformed-line atomicity or database recovery. Before applying upstream, run A–F against unchanged and patched builds, check `tooldata_load` callers, and verify status behavior through Task/IO and GUI. No code is applied to LinuxCNC by this guide.
