# 4000 safety checkpoint — gravity-axis brake proof — 2026-09-18T06:41Z

## Session timing

Start UTC: 2026-09-18T06:37:33Z
End UTC: 2026-09-18T06:41:35Z
Elapsed: 4.0 min
Overlap: no known overlap with the immediately preceding Lane-B checkpoint, which committed at 2026-09-18T05:52:07Z. A separate parallel lane may run independently; this session deliberately avoided its 24-V/output reverse-current branch.

## Durable work

Created `safety-course/GRAVITY_AXIS_SAFE_BRAKE_CONTROL_TEST_TRACE_2026-09-18.md` in commit `3767fd67`.

Authoritative manufacturer evidence from Siemens, Pilz and SEW-EURODRIVE establishes a distinct gravity-axis proof chain:

**MOTION COMMAND REMOVED != MOTOR TORQUE REMOVED != BRAKE COMMANDED CLOSED != BRAKE ELECTRICALLY ACTUATED != BRAKE MECHANICALLY ENGAGED != REQUIRED HOLDING CAPACITY PROVED != LOAD PHYSICALLY RETAINED.**

Key evidence:
- Siemens vertical-axis example: dual-channel E-stop -> F-PLC -> controlled stop -> STO + brake closure; external second brake may be driven by safe F-I/O.
- Siemens SBT example: test torque is deliberately applied against the closed brake while movement is monitored; detected movement means holding torque must be treated as insufficient and the axis taken to a safe disposition for repair.
- Pilz: SBC safely controls an external spring-applied brake; SBT addresses the mechanical/wear proof gap; gravity-loaded SOS still needs a mechanically based braking concept.
- SEW: ordinary brake output is not a substitute for safe brake control; wiring and switching-time faults can produce gravity-axis fall.

No OpenPressBrake-specific brake count/type, test torque, interval, permissible movement, PL/SIL/category/DC, stopping time or mechanical/hydraulic topology was inferred.

## Compute

No simulation/build/synthesis/benchmark/test compute was justified or used. No GitHub-hosted Actions minutes consumed. Any future bounded executable question must use `[self-hosted, openpressbrake]` only.

## LESSON_LOG safe-append state

`LESSON_LOG.md` is a large shared append-only file. The connector returned a truncated partial fetch rather than a safe append primitive, so it was not reconstructed/overwritten. Append this row when a safe tail/append mechanism is available:

`| 2026-09-18 | 4000 gravity-axis SBC/SBT mechanical proof trace | 2026-09-18T06:37:33Z | 2026-09-18T06:41:35Z | 4.0 | PROFESSIONAL GRAVITY-AXIS BRAKE PROOF BOUNDARY INTEGRATED | Find complete implementation: brake proof failure -> safety latch/inhibit -> physical load-safe disposition -> reset prerequisites -> brake re-enable -> separate fresh ordinary START; prefer second holding/hydraulic element. | No known overlap with preceding Lane-B checkpoint; avoided Lane-B output reverse-current branch. No lab compute consumed. |`

## Precise next work

Find a complete professional vertical-axis/press implementation exposing:

**brake mechanical proof failure -> safety latch/inhibit -> physical load-safe disposition -> reset prerequisites -> brake re-enable -> separate fresh ordinary START.**

Prefer an implementation that exposes two retaining elements or combines mechanical and hydraulic holding so disagreement/common-cause behavior can be traced. If the public documentation stops before physical load disposition, mark that link UNKNOWN instead of composing unrelated systems.