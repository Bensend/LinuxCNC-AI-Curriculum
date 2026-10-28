# 4400-M1XX-EXIT-01 — Script finished is not actuator finished
**Technician card | 2026-10-28 | NON-GRADUATED source reading | no machine test**

Read [pinned LinuxCNC M1xx process/Task audit](../research/4400_M1XX_EXIT_01_LINUXCNC_2910_USER_MCODE_ZERO_EXIT_BACKGROUND_CHILD_AND_SAFETY_BOUNDARY_2026-10-28.md) after [ATC-01](4400_ATC_01_TOOL_RETENTION_DRAWBAR_PNEUMATIC_RELEASE_AND_SERVICE_MODULE_2026-10-25.md) and [M67/M68 queued output](4400_ANALOG_QUEUE_01_M68_OFF_CAN_BE_REASSERTED_BY_PENDING_M67_FIELD_CARD_2026-10-28.md).

**The trap:** A custom M100–M199 script may command an actuator, return exit code 0 and let G-code continue. Task observes the **external program's direct child PID and exit code**, not physical clamp engagement, valve position, pressure or energy isolation. The official collet example unconditionally exits 0 after a HAL command; its separate `&` example intentionally allows background work. No physical failure was executed here.

| Operator sees | Correct interpretation | Required independent evidence |
|---|---|---|
| M-code DONE | Script exited zero | Actual process feedback, if required |
| Script started an operation | Normal command requested | Actuator state and appropriate fault response |
| G-code paused | Task waiting for child | **Not** safe standstill, load hold or guard permission |
| Program abort | Task may signal direct child | Independent physical stop/hold and energy isolation |
| HMI “ready” | Normal-control status | Qualified safety-permitted and physical verification |

**Easy-to-follow design:** Keep script failure handling explicit; do not force `exit 0` after a failed normal command. Prefer bounded, visible process steps and an independent status sensor for process completion. Keep guard replacement and safe setup easier than bypass. Do not require a technician to reach into the hazard to acknowledge a reset.

**Boundary:** LinuxCNC scripts, HAL and ordinary FPGA are not safety-rated merely because they wait, return an error or command OFF. Independent safety-related control and physical final elements must provide protection. If essential stop/hold/guard/restart proof is missing, **no personnel-exposed operation**; experimental operation, if later authorized, must be isolated/remote with people outside the hazard zone.

**Status:** SOURCE/DOC-CONFIRMED process semantics, **TEST-CONFIRMED none**, selected OpenPressBrake M1xx implementation **UNKNOWN**; **G0/G1 HOLD**, external evaluator **OPEN**.

**Wrong-script trap:** The tagged Task startup searches `PROGRAM_PREFIX` before `USER_M_PATH` and registers the **first executable M1xx name**. Confirm the actual resolved script path, revision and exit handling; a duplicate file in another directory is not necessarily the one running. This is process reliability/change control, **not** a safety interlock.

**Specific check:** LinuxCNC's own HAL documentation prohibits `setp` on a pin already connected to a signal. Its M1xx collet example still ends with unconditional `exit 0`; a linked-pin command error can therefore be hidden behind a successful script exit. Check pin linkage, script exit propagation and independent actuator feedback—without trying the fault on a live machine.
