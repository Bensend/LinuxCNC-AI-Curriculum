# Safety change-impact / boundary-escape session — 2026-09-17

- Session start UTC: `2026-09-17T10:35:00Z`
- Session end UTC: `2026-09-17T10:37:32Z`
- Actual elapsed: `2.53 min`
- Overlap status: `NO EVIDENCE OF OVERLAP` — prior authoritative checkpoint ended 2026-09-17T03:47:00Z.
- Compute: `NONE`; source/documentation and repository engineering only. No GitHub-hosted Actions minutes consumed; self-hosted compute was not justified.
- Status: CHECKPOINTED — safety course remains active.

## Governance/current-state reconciliation

- Read `START_HERE.md` first, then current `LEVEL_ORDER.md`, `WORK_SELECTION_POLICY.md`, `PROGRESS.md`, latest active checkpoint, current safety-course inventory, and relevant proportional-driver contract.
- Repository state confirms 1000/2000/3000 are closed and 4000 safety is primary.
- `PROGRESS.md` still points to `session-2026-09-17-safety-mode-edm-ccf.md`; this checkpoint is newer durable continuation evidence and supersedes that pointer for next-work selection.

## Durable work completed

1. Added `safety-course/CHANGE_BOUNDARY_ESCAPE_AND_REVALIDATION_SCOPE_WORKSHEET_2026-09-17.md`.
   - Prevents declaring a change non-safety merely because it occurs in ordinary LinuxCNC/HAL/FPGA/HMI or standard PLC code.
   - Adds DATA/TIME/POWER/MODE/RESET/FEEDBACK/PHYSICAL/DIAGNOSTIC/HUMAN-FACTORS/BASELINE scope-escape gates.
   - Adds R0–R4 revalidation-scope labels without pretending they are PL/SIL ratings.
   - Anchors the method to current Rockwell GuardLogix impact-analysis guidance and Siemens Safety Integrated acceptance-test guidance.
2. Added `safety-course/OPENPRESSBRAKE_PROPORTIONAL_COMMAND_CHANGE_IMPACT_APPLICATION_2026-09-17.md`.
   - Applies the method to HAL scaling/mapping, transport/register mapping, watchdog/freshness, ADC/current-feedback mapping, and output default/polarity changes.
   - Preserves independent safety authority while requiring stale-command/rearm and physical correspondence checks where ordinary changes can affect post-safety recovery behavior.
   - Leaves hydraulic safety truth tables, stopping/pressure values, PL/SIL/DC and final machine safety architecture UNKNOWN.
3. Short-session continuation check found another useful unblocked safety branch, so work continued rather than ending after the first application.
4. Added `safety-course/OPENPRESSBRAKE_SHARED_POWER_COMMON_CAUSE_REVIEW_2026-09-17.md`.
   - Converts shared 24-V/0-V/connectors/protection/feedback paths into common-cause schematic-review rules.
   - Uses SICK manufacturer evidence that CCF prevention includes signal-path separation, protection, and control of voltage-failure/fluctuation consequences, with a concrete dual-encoder example showing that a protected common supply can coexist with separate supply lines when the architecture supports it.
   - Explicitly rejects the simplistic rule that sharing one PSU automatically proves or disproves independence.

## Exact next work

Build an **OpenPressBrake safety power/common map template** for the board-design automation to fill from the actual schematic. It should inventory safety-controller power, safety-device branches, safety final-element coil power, ordinary FPGA/controller power, proportional field power, returns/bonds, protection, connector/harness common points, and EDM/feedback returns. Every shared node should be classified `SAFE CONSEQUENCE ESTABLISHED`, `FAULT DETECTED / RESTART INHIBITED`, `EXCLUDED BY CONSTRUCTION + EVIDENCE`, `NOT SAFETY-RELEVANT`, or `UNKNOWN — REVIEW REQUIRED`.

Then apply that template to actual schematic evidence when available; do not invent missing board wiring or machine hydraulic facts.

## LESSON_LOG safe-append status

`LESSON_LOG.md` was fetched only as a bounded head range and the available GitHub connector exposes whole-file replacement, not an atomic append action. Overwriting the large log from an incomplete fetch would violate repository governance. Required timing is preserved here for later safe append:

`| 2026-09-17 | Safety course — change-boundary escape + proportional-path application + shared-power CCF | 2026-09-17T10:35:00Z | 2026-09-17T10:37:32Z | 2.53 | BOUNDARY-ESCAPE / CCF RULES ADDED | Build OpenPressBrake safety power/common map template | No overlap; no compute. |`
