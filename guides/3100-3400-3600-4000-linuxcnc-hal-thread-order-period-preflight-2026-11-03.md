# HAL thread scheduling preflight — mill, plasma, press brake and controller integration

Companion to [HAL-THREAD-176](../research/4400_LINUXCNC_HAL_THREAD_176_PERIOD_ROUNDING_PRIORITY_ORDER_SOURCE_AUDIT_2026-11-03.md). **Review-only; NOT RUN.** Pinned upstream LinuxCNC v2.9.10 `src/hal/hal_lib.c` blob `0ed9b444f96fea3dc88d54016a8d51c20ff8f1a2`.

## Inspect before editing
Capture the complete INI `[EMCMOT]` period settings, the HAL `loadrt threads` and `addf` sequence, `halcmd show thread`, `halcmd show funct`, and every connected feedback/output signal. Do not infer timing solely from signal names or an INI period. For real Mesa/EtherCAT setups, separately capture board/driver cycle and encoder feedback freshness; the HAL thread period is only one layer.

## Minimal scheduling worksheet
Given a verified 25,000-ns base, compare requested 1,012,000 ns (40 ticks → 1,000,000 ns) with 1,013,000 ns (41 ticks → 1,025,000 ns). **These are calculations, not observed machine results.** Record RTAPI clock result before accepting the worksheet. Create faster threads first; add functions explicitly in desired order, typically hardware read → motion/controller → hardware write, subject to driver-specific documented requirements.

## Review-only command outline
```sh
# Run ONLY in a disconnected, explicitly isolated LinuxCNC test environment.
halcmd show thread
halcmd show funct
halcmd show pin
```
Compare listed function order with the source HAL/INI, including `addf ... 1` (front) versus `addf ... -1` (end). Capture failures when reversing thread creation or adding a non-reentrant function twice. A thread stop or successful `halcmd` query does not authorize a machine movement or substitute for independent personnel protection.

## Acceptance oracle
A reproducible report includes: LinuxCNC revision, RTAPI backend, base period, each requested/actual period, thread priority, ordered functions, return codes for negative controls, and timing/overrun observations. Do not label as TEST-CONFIRMED until actual execution evidence is retained. Avoid extrapolating from one platform to another.
