# 4400-ATC-02 — LinuxCNC M6 tool-change acknowledgment versus physical retention
**2026-10-25 | SOURCE-CONFIRMED pinned LinuxCNC `062dc7c097693bb68e76192516cd92878dd5ecdf` | TEST NOT RUN | no physical safety claim**

## Question and source-grounded result
Does LinuxCNC's ordinary `iocontrol.0.tool-changed` completion handshake independently verify that a spindle tool is mechanically retained, a changer arm is clear, pneumatic release is disabled, or the cell is safe for personnel? **No, not in the inspected stock Task I/O path.** The Task code tests HAL boolean acknowledgment and updates tool-table/status state; actual safety and physical validation must be supplied by the installed external system.

## Exact pinned source inventory
- `src/emc/task/emctaskmain.cc` lines **2159–2166**: dispatches `EMC_TOOL_PREPARE_TYPE` to `emcToolPrepare(tool)` and `EMC_TOOL_LOAD_TYPE` to `emcToolLoad()`.
- `src/emc/task/taskclass.cc` lines **50–65**: `iocontrol_hal_init()` exports `iocontrol.0.tool-prepare` (HAL OUT), `tool-prepared` (HAL IN), `tool-change` (HAL OUT), `tool-changed` (HAL IN).
- Same file lines **451–505**: `Task::emcToolPrepare()` resolves tool index and sets `tool-prepare=1`; waits on HAL feedback to mark prepared.
- Same file lines **508–536**: `Task::emcToolLoad()` may short-circuit no-op cases, otherwise sets `tool-change=1` and `emcioStatus.status=EXEC`.
- Same file lines **632–676**: `Task::read_tool_inputs()` accepts `tool_prepare && tool_prepared` and `tool_change && tool_changed`; on latter updates `toolInSpindle`, `tool_number`, tool table, clears request, sets `RCS_STATUS::DONE`. It does **not** in this function read drawbar force, arm/pocket capture, release pressure, or personnel presence.
- Same file lines **679–684**: `Task::run()` calls `read_tool_inputs()` periodically and separately reads `emc_enable_in`.
- `docs/src/man/man1/io.1.adoc` lines **37–50** documents request/acknowledgment pins.
- `lib/hallib/core_sim.hal` lines **46–50** deliberately loops `tool-prepare -> tool-prepared` and `tool-change -> tool-changed`, proving a shipped **configuration example** can report completion with no physical toolchanger. This is documentation/config evidence, **not an executed test**.

Pinned browser sources:
- https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/emc/task/emctaskmain.cc
- https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/emc/task/taskclass.cc
- https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/docs/src/man/man1/io.1.adoc
- https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/lib/hallib/core_sim.hal

## Source call flow
`Interpreter / M6` (entry details not fully traced here) -> `EMC_TOOL_PREPARE / EMC_TOOL_LOAD NML` -> `emctaskmain` dispatch -> `Task::emcToolPrepare / emcToolLoad` -> `iocontrol.0.tool-prepare / tool-change` HAL OUT -> **external machine toolchanger integration** -> `iocontrol.0.tool-prepared / tool-changed` HAL IN -> `Task::read_tool_inputs` -> `toolInSpindle / tool_number` and `RCS_STATUS::DONE`.

The explicit boundary is **HAL acknowledgment**. The source does not establish the integrity, timeliness, independence or physical truth of whatever drives the input. A real installation can interpose ordinary PLC checks, but these are **not automatically safety-rated**; personnel-safety authority must be independent and validated.

## Falsifiable code-level scenarios
1. **Stuck-TRUE acknowledgment:** If `tool_changed` remains TRUE when `tool_change` becomes TRUE, the inspected condition can immediately enter the completion branch on a later `run()` cycle, even without physical changer movement. **SOURCE-CONFIRMED logical consequence**, not experimentally executed.
2. **Sim loopback:** The shipped `core_sim.hal` directly connects request to acknowledgment. It intentionally exercises Task handshake without tool retention, making any interpretation of `tool_number` as a force/hold sensor invalid.
3. **Stale external logic:** External normal controller might assert `tool_changed` after a timer or stale sensor; Task treats that as completion. The actual behavior of any particular external implementation is **UNKNOWN**.
4. **Safety function separation:** Even an accurate tool-change acknowledgment does not verify guarded access, Z-axis stop, drawbar force, arm capture, compressed-air isolation or fresh start after fault.

## Adversarial review
**Incorrect:** "LinuxCNC tool number updated, therefore it is safe to open the guard and work under the tool." **Correct:** the updated tool number is ordinary state resulting from HAL acknowledgment. Demand separate OEM retention/capture evidence, independent physical stop/hold, personnel protection and service isolation.

**Incorrect:** "Adding a second HAL acknowledgment bit makes it a Category 3 safety function." **Correct:** safety integrity requires a validated entire safety-related control system, diagnostics, common-cause analysis and physical final elements, not just additional normal pins.

## Evidence classification
- **SOURCE-CONFIRMED:** exact pinned functions, HAL pin directions, Boolean acknowledgment-to-DONE behavior.
- **DOC-CONFIRMED:** pinned manpage descriptions and shipped sim HAL example.
- **TEST-CONFIRMED:** none; no local or hosted runner used.
- **INFERENCE:** stuck-TRUE/stale acknowledgment physical hazard transfer; external integrations may behave differently.
- **UNKNOWN:** actual OpenPressBrake or selected mill/ATC implementation; mechanical force, pneumatic pressure, guard authority, PL/SIL, physical response.

**No lab justified now:** the source itself resolves whether the stock handshake is a physical force witness; physical retention remains machine-specific and cannot be simulated into truth. Do not dispatch hosted Actions. If future question-driven software lab is necessary, only local `[self-hosted, openpressbrake]` runner; current dispatch access was blocked by queued cancellation.
