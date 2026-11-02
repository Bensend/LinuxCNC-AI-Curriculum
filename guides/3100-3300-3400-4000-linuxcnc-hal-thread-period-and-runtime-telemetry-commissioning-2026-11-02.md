# LinuxCNC HAL thread-period and runtime telemetry — disconnected commissioning card

**HAL-TIMING-161; 2026-11-02; 3100/3200/3300/3400/3600 transfer; 4000 implementation.** Source: [pinned audit](../research/4400_LINUXCNC_HAL_TIMING_161_THREAD_PERIOD_QUANTIZATION_AND_TELEMETRY_VERSION_SOURCE_AUDIT_2026-11-02.md). Do not connect to a real controller or use `setexact` as a hardware workaround.

## First establish the installed version

Record `linuxcnc -v`, Git/package build identification, RTAPI backend, `uname -a`, the actual `halcmd show thread` output and any reported clock tick. Do **not** apply development HAL types to a 2.9 installation. Stable: `.time` pin and `.tmax` parameter are s32 clock counts. Development pinned commit 67437d8: both are real-valued pins in seconds, with `threadbeat` available. The requested INI period is not automatically the observed period.

## Isolated, no-output example

On an independently qualified **physically disconnected** `[self-hosted, openpressbrake]` environment with LinuxCNC available, review and run the commands in [fixture README](../examples/4000_hal_timing_161/README.md). It creates only `threads` and `siggen`; no `motmod`, HostMot2, EtherCAT, fieldbus, axis, machine HAL or actuator. Do not execute it on a machine-connected panel PC. Run 1,024,999 ns and 1,025,000 ns variants in **separate fresh HAL sessions** so the first thread's clock and creation order remain comparable.

### Acceptance matrix (all NOT RUN)

| Case | Configuration / observation | Predeclared expected result | What would disprove |
|---|---|---|---|
| A | 50,000 ns first thread, 1,024,999 ns second | Nominal 1,000,000 ns second period if actual base=50,000 ns | Different `show thread` period with actual base verified |
| B | Same but second=1,025,000 ns | Nominal 1,050,000 ns, half-up integer rounding | Different observed period with base verified |
| C | Create slower thread first, then faster | Second rejected by HAL previous-period check | Both accepted under pinned source path |
| D | Create equal-period threads | HAL comparison uses `<`, so equality is not rejected solely for ordering | Explicit equality rejection from that check |
| E | Stable v2.9.10 `show pin fast.time`, `show param fast.tmax` | s32 pin and s32 parameter, raw clock counts | Types/ownership disagree |
| F | Development 67437d8 `show pin fast.time`, `show pin fast.tmax` | real seconds pin and real seconds I/O pin | Types/units disagree |
| G | Development `show pin fast.threadbeat` across running callbacks | sint increases after cyclic passes | Missing pin or no change with running thread |
| H | Compare `.time` with an independent inter-invocation timer | `.time` alone is not an inter-arrival/deadline measurement | Explicit measurement path including wait/wakeup |

**RTAPI caveat:** actual base tick may not equal requested 50,000 ns; report the observed base and re-evaluate A/B rather than manufacturing a failure. Don't infer precise physical timing from a simulated clock.

## Practical interpretation

For a machine commissioning log keep **three separate fields**: requested period (INI or `threads` argument), actual HAL nominal period (`show thread`), and independent measured scheduling latency/deadline behavior. Keep callback execution duration as a fourth field with **version-tagged units**. If a function's `.tmax` exceeds the thread period, that is concerning, but a smaller `.tmax` does not prove deadlines met, nor that external I/O arrived fresh.

For plasma, record torch-voltage timestamp/freshness independently. For Mesa/FPGA, distinguish HAL callback completion from transport/FPGA update and motor feedback. For OpenPressBrake, none of these ordinary-controller signals authorizes G0/G1 machine movement or replaces independent personnel-safety authority.

## Evidence discipline / next

Capture raw `halcmd show thread`, `show pin`, `show param`, version, backend, source/fixture hashes and exact run timestamps before asserting TEST-CONFIRMED. A–H remain NOT RUN. No Actions dispatch in this lesson; do not use GitHub-hosted runners. If no qualified disconnected compute exists, continue distinct LinuxCNC source work rather than adding repetitive unexecuted timing tests.

## Additional controller-interval discriminator (I–J; NOT RUN)

**Important:** the `threads`+siggen fixture above **does not export any `motion.*` pins**. For a separately qualified, disconnected `motmod` simulation, inspect `motion.servo.last-period` only after checking the installed LinuxCNC revision:

- **Stable v2.9.10:** `motion.servo.last-period` is u32 **CPU-clock counts** from `rtapi_get_clocks`; `motion.servo.last-period-ns` is a float pin **only if built with `HAVE_CPU_KHZ`**. Never assume that optional pin exists.
- **Development 67437d8:** `motion.servo.last-period` remains uint but is **nanoseconds** from `rtapi_get_time`; inspected source no longer exports the stable conditional `last-period-ns` pin. The development motion(9) page's additional instruction to divide this ns value by CPU speed is inconsistent with its own unit label and the implementation.

**I:** stable source/type/unit and optional-pin existence. **J:** development source/type/unit, no double conversion. These are **NOT RUN**; don't substitute the no-motion fixture for a motmod experiment. The pin measures time between motion-controller callback entries, not independently verified scheduler wakeup jitter, EtherCAT/Mesa transport timing, or physical position feedback. See [cross-layer source addendum](../research/4400_LINUXCNC_HAL_TIMING_161_THREAD_PERIOD_QUANTIZATION_AND_TELEMETRY_VERSION_SOURCE_AUDIT_2026-11-02.md#same-session-cross-layer-continuation--motion-servo-interval-units-161b).

## Backend-specific base-period verification (K–L; NOT RUN)

For **userspace RTAPI** in the two inspected revisions, `RtapiApp::clock_set_period` stores the first requested base period verbatim. This does **not** mean the OS actually wakes the thread at that precise interval. For **RTAI**, the same RTAPI interface converts to hardware timer counts and returns the converted actual base; the rounded slow-thread period may differ from the 50 µs numerical example. Record backend, first thread requested period, actual returned base and `show thread` before interpreting results. **K** checks userspace stored/query value versus independently observed jitter; **L** checks RTAI count-conversion/returned base and recalculates nominal quantization. Both NOT RUN. No RTOS reconfiguration or hardware connection is permitted here. [Pinned source details](../research/4400_LINUXCNC_HAL_TIMING_161_THREAD_PERIOD_QUANTIZATION_AND_TELEMETRY_VERSION_SOURCE_AUDIT_2026-11-02.md#same-session-rtapi-backend-follow-through--why-the-actual-base-matters-161c).
