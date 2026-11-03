# HAL-THREAD-176 — HAL thread period rounding, priority and addf ordering (2026-11-03)

**Scope:** LinuxCNC core realtime/HAL, applicable to 3100–3600 machine configuration and 4000 controller integration. NON-GRADUATED. No machine or executable verification.

## Provenance and exact source
LinuxCNC upstream **v2.9.10**, `src/hal/hal_lib.c`, Git blob `0ed9b444f96fea3dc88d54016a8d51c20ff8f1a2`:
- `hal_create_thread` lines ~1912–2060: first thread establishes `base_period` from RTAPI clock (or requested period when `exact_base_period`); later periods rounded to nearest multiple by `n=(requested+base/2)/base`, `new->period=base*n`. A new thread whose rounded period is less than the previous (slowest-at-head) is rejected. Priorities descend from `rtapi_prio_highest()` / `rtapi_prio_next_lower`. A requested period below base is rejected before rounding.
- `hal_add_funct_to_thread` lines ~2140–2264: position zero invalid; positive positions count from list start, negative positions from list end; duplicate use of a non-reentrant function rejected; insertion uses `list_add_after`.
- `hal_start_threads` / `hal_stop_threads` lines ~2357–2395 set a shared `threads_running` flag after checking lock state. This is **not** proof of a hardware output-safe state.

Source: https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/hal_lib.c

## Behavior and testable consequences
**SOURCE-CONFIRMED:** Requested thread periods are not necessarily actual periods. Example **NUMERIC INFERENCE**, assuming established base exactly 25,000 ns: requested 1,012,000 ns gives `(1012000+12500)/25000=40` integer divisions, hence **1,000,000 ns actual**. Requested 1,013,000 ns gives 41 ticks and **1,025,000 ns actual**. Boundary is 1,012,500 ns, rounded upward. The first-thread clock selection and platform-specific actual timer may differ; never claim the example is an observed scheduler period.

**SOURCE-CONFIRMED:** Threads must be created in nondecreasing actual period order. A slower thread created first then a faster thread may be rejected. Adding a function at `-1` places it at the end; at `1` at the beginning. HAL signal wiring does **not** by itself define function execution order. A read/compute/write cycle must explicitly order functions in the same thread. Across threads, priority alone does not establish a consistent same-cycle data snapshot.

**SOURCE-CONFIRMED:** A non-reentrant function already in use cannot be attached to a second thread. This matters for attempts to share encoder read, motion command handler, or driver write between servo/base threads.

**UNKNOWN:** RTAPI backend scheduling jitter, exact hardware deadline behavior, all newer development branch differences, actual servo periods in a given INI/HAL, physical output behavior on thread stop. Do not generalize from static library source.

## Reproducible disconnected verification matrix (NOT RUN)
1. On a disconnected LinuxCNC simulator with an available RTAPI backend, create threads in ascending period order with a known base, then `halcmd show thread`; record requested/actual periods and priorities. Confirm platform permits this setup.
2. Probe the rounding boundary at 1,012,499 / 1,012,500 / 1,012,501 ns for 25-us base; compare observed actual periods to the arithmetic, including any RTAPI clock constraints.
3. Reverse creation order; capture error, process exit status and unchanged existing thread list.
4. Add two simple functions with `addf ... 1` and `addf ... -1`; inspect `show thread` before executing; capture a sequence trace to distinguish list order from actual execution.
5. Try attaching one non-reentrant function twice; assert explicit rejection and no partial insertion.
6. Stop threads and verify only HAL scheduling status; **do not** treat stop as safety-rated disable.

**Isolation:** no drive, motion hardware or personnel exposed; only qualified `[self-hosted, openpressbrake]` compute after independent isolation verification. No GitHub-hosted runner. No run was dispatched.

## Transfer and design rule
For Mesa/HostMot2, EtherCAT, servo PID, plasma torch and press-brake feedback chains, document: requested INI period; measured HAL thread period; actual `addf` order; driver read → motion/controller → driver write order; cross-thread age assumptions; observed jitter/overruns. An INI `SERVO_PERIOD` is not sufficient evidence of the effective execution cadence. Keep personnel-safety authority separate from HAL thread operation.

## Predecessor and evidence boundary
This is a narrow scheduler/configuration continuation, not a new claim that existing realtime/HAL lessons are ungraduated. Prior 1000/2000 work and motion/Mesa research remain authoritative for their own tested versions. Existing lab ledger inspected; no new TEST-CONFIRMED evidence or compute minutes.
