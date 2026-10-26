# 4400-HAL-THREAD-01 — HAL `stop` suspends periodic functions; it does not prove a physical safe stop

**Date:** 2026-10-26. **Status:** pinned SOURCE-CONFIRMED for normal HAL behavior; hardware consequences UNKNOWN; PAPER ONLY, NON-GRADUATED. Distinct from [HAL-MUTATION-01](4400_LINUXCNC_HAL_UNLINK_STALE_TRUE_AND_SETS_WRITER_BOUNDARY_SOURCE_TRACE_2026-10-26.md): this case **leaves nets connected** but stops cyclic functions.

## Predeclared source question
When the HAL utility receives `stop`, does it command safety outputs FALSE, or does it prevent future realtime callbacks? What happens if a callback is already running? Does this behavior establish an external hardware watchdog's response?

## Exact source and execution path
- Stable LinuxCNC tag **v2.9.10**: [halcmd_commands.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/utils/halcmd_commands.cc) `do_stop_cmd` ~301–307 calls `hal_stop_threads`. [hal_lib.c blob `0ed9b44`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/hal_lib.c), `hal_stop_threads` ~2378–2396 checks initialization and `HAL_LOCK_RUN`, then sets `hal_data->threads_running=0`; `thread_task` ~2875–2933 executes function list **only if** `threads_running>0`, then continues waiting each period.
- Development pinned commit **`062dc7c097693bb68e76192516cd92878dd5ecdf`**: [halcmd_commands.cc](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/hal/utils/halcmd_commands.cc) `do_stop_cmd` ~259–265; [hal_lib.c blob `d5d8410`](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/hal/hal_lib.c), `hal_stop_threads` ~2766–2790 and `thread_task` ~3272–3370. The development implementation additionally calls `threads_wait_idle()` in the ULAPI path, returning timeout if it cannot establish idle, and uses `thread->busy` around each pass.
- [Official 2.9 halcmd(1) manual](https://linuxcnc.org/docs/2.9/html/man/man1/halcmd.1.html): `stop` stops realtime threads calling their functions; `start` starts execution of their function lists. **DOC-CONFIRMED**.

## Key result
Neither inspected `hal_stop_threads` implementation calls an independent safety relay, drops all HAL output pins to FALSE, verifies drive STO, closes a hydraulic safety valve, proves Y1/Y2 holding, or verifies spindle/arc energy isolation. The source sets a **software scheduling flag**; the next `thread_task` pass skips its function list. **SOURCE-CONFIRMED absence of those actions in this call path**, not a universal claim about all separately configured watchdogs.

### In-flight callback distinction
In v2.9.10, setting the flag does not synchronously cancel a callback already executing within the `if` block; the loop is allowed to complete. In the pinned development ULAPI path, the additional idle wait is intended to wait for the current pass to finish, but may time out. **Do not invent a physical stop latency from either code path**. The `stop` return value and the machine's actual hazardous-energy state are different propositions.

### Why stale command values matter
If a realtime function normally refreshes an output, ceasing its callbacks does **not** itself zero its last stored HAL output. The pin value, userspace processes, downstream drive/hardware behavior, and any independently configured watchdog must be analyzed separately. **INFERENCE** a stale output could be dangerous in a design that treats it as a personnel-safety permission; this audit does not establish how a selected hardware device reacts to missing updates.

## Four failure-path distinctions
1. **Normal HAL `stop`**: no more scheduled function calls; not a safety stop.
2. **External watchdog expiry**: may force a defined hardware response **only if** the exact device, wiring, timing, and independent safety allocation establish it; none verified here.
3. **Physical load holding**: a stopped control loop is not evidence that a gravity-loaded ram is restrained or that pressure is isolated.
4. **Restart after `start`**: normal callbacks may resume; safe reset, operator fresh start and physical readiness are separate machine-specific requirements.

## Evidence ledger
| Claim | Class | Limit |
|---|---|---|
| `do_stop_cmd -> hal_stop_threads -> threads_running=0` | SOURCE-CONFIRMED | Both pinned revisions |
| Realtime function list gated on `threads_running>0` | SOURCE-CONFIRMED | Both `thread_task` paths |
| Development ULAPI idle-wait addition | SOURCE-CONFIRMED | Pinned development only; not assumed in stable |
| All physical outputs deenergize on `halcmd stop` | UNKNOWN / NOT ESTABLISHED | Requires device-specific output and watchdog evidence |
| `halcmd stop` is a personnel-rated protective stop | FALSE as design allocation / INFERENCE | No independent safety-related function evidenced |
| Actual OpenPressBrake controller/FPGA watchdog and final-element behavior | UNKNOWN | Requires private as-built and qualified physical validation |
| Measured stop time, PL/SIL, pressure, physical Y1/Y2 hold | UNKNOWN / NOT TEST-CONFIRMED | No test, no ratings invented |

## Practical design response
Keep personnel protection independent of HAL callback scheduling. Define what a lost controller heartbeat means for **ordinary control**, then separately prove the independent safety circuit and its final elements achieve the machine-specific physical safe state. Make failure recovery usable: display `control loop stopped` separately from `safety reset required`, require deliberate restart, and avoid a service procedure that invites disabling interlocks to resume a frozen controller.

## Lab decision
Source and official docs settle the scheduling question without compute. A hardware-watchdog bench test becomes justified only after a concrete selected device/configuration, frozen question and safe isolated fixture exist; it cannot be inferred from `hal_stop_threads`. No Actions dispatch or machine tests. **G0/G1 HOLD; independent evaluator NOT RUN; no personnel-exposed operation.**
