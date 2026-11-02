# HAL-TIMING-161 — Requested thread periods, realtime priority and timing telemetry across LinuxCNC versions

**2026-11-02; 4000 LinuxCNC implementation, 3100/3300/3400 machine-config transfer; NON-GRADUATED.** This is an implementation/diagnostics contract, not a newly discovered crash or a measured jitter failure.

## Question and predecessor check

Can a commissioning tool treat the requested HAL period as the scheduled period, or compare `.time`/`.tmax` thresholds unchanged between LinuxCNC 2.9 and development? Full canonical PROGRESS and LESSON_LOG searches for `hal_create_thread`, `threadbeat`, `exact_base_period`, `servo-thread.time`, `period rounding` and `tmax-increased` found no dedicated predecessor. Earlier MOTION-133/other servo-ratio work addresses motion TP configuration, not this HAL timing telemetry/type contract. General 1000 realtime/HAL lessons are graduated prerequisites, not reopened.

## Immutable primary sources (read on 2026-11-02)

- Stable LinuxCNC **v2.9.10**, known tag commit `86cdca76fa2a36274c432caa21952b23c267989a`: [src/hal/hal_lib.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/hal_lib.c) blob `0ed9b444f96fea3dc88d54016a8d51c20ff8f1a2`, `hal_create_thread` near L1912–2080, `hal_export_funct` near L1888–1907, `thread_task` L2878–2925; [src/emc/motion/motion.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/motion.c) blob `febe7f3ff3f2b80e34b00a9e60d3cdb3e9e41841`, `init_threads` L981–1062; [src/hal/components/threads.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/components/threads.c) blob `bbb7e406949d0decb88556f75dac2213f858824a`.
- Development **master commit `67437d8865e431a9a33f74cee912dbf891d3b4c5`**, not a promise about future master: [src/hal/hal_lib.c](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/src/hal/hal_lib.c) blob `d5d84107e8cfbaf970d91030b66f0753695f150e`, `hal_create_thread` L2105–2284 and `thread_task` near L3300–3364.
- Official stable [Basic HAL](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/hal/basic-hal.adoc) blob `1eab50441d8375bd875d38dd8750f9206d081e50`, function `.time/.tmax` explicitly **CPU cycles**; [core components](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/config/core-components.adoc) blob `c9a56c0ed127e99f208fd1b8b7bd1699259bbd66`, servo period rounded to base multiple.
- Official development [Basic HAL](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/docs/src/hal/basic-hal.adoc) blob `0c800c56c9aea099f82ba093b61125dffc255bb4`, function `.time/.tmax` **real seconds**; [core components](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/docs/src/config/core-components.adoc) blob `6829973a010abfc9cfb604e00eadb20764bc4792`.
- Real upstream [CoreXY simulation INI](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/corexy/corexy_base.inc), blob `b1b258259b2e91ba37137cb20e905567d2a3046b`, sets `BASE_PERIOD=250000`, `SERVO_PERIOD=1000000`; upstream [HAL tutorial](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/hal/tutorial.adoc), blob `611314ac67d8d5798e243b32d4fdf6c56eb0ae16`, creates `threads` and `siggen.0.update`.

## Source execution path

`threads.c::rtapi_app_main` passes requested periods into `hal_create_thread`; normally `motion.c::init_threads` first rounds requested servo/base ratio and creates base (if needed) then servo thread. Both inspected HAL libraries: first created thread consults/starts `rtapi_clock_set_period`; a clock period more than 1% above requested is rejected; base period comes from the RTAPI clock result unless `exact_base_period` is set. For each thread:
```c
n = (period_nsec + hal_data->base_period / 2) / hal_data->base_period;
new->period = hal_data->base_period * n;
```
The new rounded period must not be **less** than the preceding (slowest) thread period; equality is not rejected. Priority is assigned via `rtapi_prio_next_lower(prev_priority)`, so creation order, not simply the requested numeric period, determines relative priority. `rtapi_task_start(...,new->period)` receives the rounded value; `thread_task` passes that same `thread->period` to each HAL function. This is a **SOURCE-CONFIRMED nominal scheduling contract**; OS wakeup accuracy is separate and unmeasured.

### Discriminating arithmetic (INFERENCE from exact integer expression)

Assume RTAPI accepts an **actual** 50,000 ns base tick and no `setexact` override. A second thread requested at **1,024,999 ns** rounds to `floor((1024999+25000)/50000)=20` ticks = **1,000,000 ns**. Requested at **1,025,000 ns**, it rounds to `floor((1025000+25000)/50000)=21` ticks = **1,050,000 ns**. A 1 ns request change crosses a 50,000 ns nominal scheduling boundary. Both revisions use the same integer expression. Actual backend clock acceptance and wakeup jitter are **UNKNOWN** until observed; this example is not a measurement.

### Diagnostics contract differs materially

| Property | v2.9.10 | Development commit 67437d8 |
|---|---|---|
| HAL function `<function>.time` | **s32 HAL pin**, difference of `rtapi_get_clocks()` values | **real HAL pin**, difference of `rtapi_get_time()` nanoseconds × 1e-9 |
| Function `<function>.tmax` | **s32 RW HAL parameter**, clock-count maximum | **real HAL_IO pin**, seconds maximum |
| Function `<function>.tmax-increased` | bit RO **parameter** | bool HAL_OUT **pin** |
| `<thread>.time` | s32 HAL_OUT pin, clock-count execution time | real HAL_OUT pin, seconds execution time |
| `<thread>.tmax` | s32 RW **parameter**, clock-count maximum | real HAL_IO **pin**, seconds maximum |
| `<thread>.threadbeat` | **not exported** in inspected stable source | sint HAL_OUT pin incremented after a running cyclic pass |

Stable `thread_task` L2893–2921 samples `rtapi_get_clocks`, computes per-function and total execution duration, and then calls `rtapi_wait`. Development L3300–3364 samples `rtapi_get_time`, converts nanoseconds to seconds and increments `threadbeat` after the functions. Neither `thread.time` value measures the interval **between** callbacks or guarantees a deadline was met: the wait and wakeup are outside the execution-time subtraction. A raw numeric comparison between stable clock counts and development seconds is invalid. Converting stable counts to seconds requires a verified clock-frequency calibration, not a hardcoded 1 GHz assumption.

The development `threadbeat` is a pass counter, **not** a physical output acknowledgment, watchdog, proof of an uninterrupted deadline history, or independent safety input. Its use in upstream [halrmt set wait documentation](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/docs/src/man/man1/halrmt.1.adoc) and [tests/tap.0/taptest.py](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/tests/tap.0/taptest.py) illustrates cycle synchronization; that test code was inspected via code search, **not run**.

## Machine-specific consequences

- **3100 mill / 3400 router:** distinguish `SERVO_PERIOD` INI request, rounded HAL period and measured scheduling lateness before changing PID/stepgen tuning.
- **3200 lathe:** don't diagnose threading phase from `servo-thread.time` alone; that is execution duration, not spindle-index or encoder-sample phase.
- **3300 plasma:** a torch-height-control function running in the servo thread shares its scheduling budget; the timing pin measures callback execution, not THC sensor freshness or arc-voltage transport latency.
- **3600 press brake:** a LinuxCNC threadbeat or small `.time` is not independent confirmation of ram, backgauge, or personnel-safety authority.

## Claim ledger and falsifiers

| Claim | Class | What would falsify / verify |
|---|---|---|
| HAL rounds to nearest integer base multiple with half-up tie | SOURCE-CONFIRMED both | Show `halcmd show thread` period on qualified disconnected runtime; compare actual RTAPI base |
| Stable time/tmax are clock-count s32 pin/parameter | SOURCE + DOC-CONFIRMED stable | Inspect `show pin` and `show param` types; record CPU clock basis |
| Development time/tmax are real seconds pins; threadbeat exists | SOURCE + DOC-CONFIRMED development | Inspect types and increment with no-motion HAL fixture |
| Small `.time` proves deadlines met | **REJECTED** by measurement boundaries | Separate actual inter-invocation timing and deadline measurement required |
| A 1 ns request change can move nominal schedule 50 µs | arithmetic INFERENCE conditional on base=50 µs | A/B no-motion thread fixture, not yet run |
| No physical machine impact | UNKNOWN | No hardware execution or output connection allowed |

## Reproducible exercises / evidence state

See [no-motion fixture and readout](../examples/4000_hal_timing_161/README.md) and [commissioning guide](../guides/3100-3300-3400-4000-linuxcnc-hal-thread-period-and-runtime-telemetry-commissioning-2026-11-02.md). A–H cases are **NOT RUN**; no LinuxCNC build, runtime, qualified runner, machine or independent evaluation. Do not use GitHub-hosted Actions; only independently qualified, physically disconnected `[self-hosted, openpressbrake]` if a test is justified.

## Adversarial transfer and promotion

1. If a 1 ms thread and a 1.025 ms requested thread show the same `.time` number on two LinuxCNC versions, can one compare latency? **No**: types/units differ; neither number is jitter.
2. If a 50 µs base and 1.024999 ms requested thread produce 1 ms actual, is that an error? **No**: expected quantization conditional on actual base.
3. If `threadbeat` increases, did the drive receive a valid step? **No**: HAL callback completion only.
4. If a second thread is requested at 0.9 ms after a 1 ms thread, is its creation permitted? **No**, rounded new period below previous period is rejected; creation order matters.

**Promotion:** compare exact backend `rtapi_clock_set_period` behavior (RTAI vs uspace PREEMPT_RT), actual wakeup jitter and deadline misses on isolated compute; consequences can change timing budget but do not invalidate the source-derived API/type contract. No graduation claimed; earlier graduated levels remain closed.

## Same-session cross-layer continuation — motion servo interval units (161B)

The same visible HAL pin name **`motion.servo.last-period`** has a second, more subtle version-dependent **unit change without a type change**:

- **v2.9.10:** [`control.c::emcmotController`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/control.c) blob `b6e45d590c7d11030654d8f7d13d118f581b6439`, near L223–233, computes `this_run = rtapi_get_clocks() - last`. [`motion.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/motion.c) L589–593 exports `motion.servo.last-period` as u32 **CPU-clock counts** and **conditionally** exports float `motion.servo.last-period-ns` under `HAVE_CPU_KHZ`, calculated `this_run * 1e6 / cpu_khz`. The latter may be **absent**, so scripts must test pin existence. Stable [core-components docs](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/config/core-components.adoc) describe clock counts.
- **Development 67437d8:** [`control.c::emcmotController`](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/src/emc/motion/control.c) blob `7c9a35c237ba05326372294587c33d53aff1a6a9`, near L229–236, computes `rtapi_get_time()` delta in **nanoseconds**, stored in the same **uint** `motion.servo.last-period`; [`motion.c`](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/src/emc/motion/motion.c) blob `4a096507d64b19a3035cce7a66cab635d19d5ea7` L652–655 exports this pin, not the stable conditional `last-period-ns`. Development [core-components docs](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/docs/src/config/core-components.adoc) correctly state nanoseconds. **Documentation inconsistency:** development [motion(9)](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/docs/src/man/man9/motion.9.adoc) says *both* “Time (in ns)” and that dividing by CPU speed yields seconds; the latter instruction is incompatible with a nanosecond-valued pin. Preserve the conflict rather than following the stale conversion advice.

**Practical impact:** A monitoring script using `motion.servo.last-period` and a fixed numerical threshold can silently change meaning when moving from stable to development, even though HAL still reports `uint`. The interval is between **controller function invocations**, not an independent measurement of the servo thread's OS wakeup instant, external FPGA update, or motor motion. The first sample may include initialization effects. Treat a timing alarm as a controller diagnostic, not a personnel-safety function.

**Additional acceptance (I–J; NOT RUN):** I: on stable with motmod and no hardware, confirm `motion.servo.last-period` is clock counts and probe whether conditional `last-period-ns` exists; do not assume it does. J: on pinned development, confirm `motion.servo.last-period` is nanoseconds despite unchanged uint type, `last-period-ns` is not exported by inspected source, and no CPU-frequency division is used. Both require a qualified disconnected environment; the `threads`+siggen fixture **does not load motmod** and therefore cannot test I/J. These cases must use a separate minimal motion simulation, not be claimed covered by the existing fixture.

## Same-session RTAPI backend follow-through — why the actual base matters (161C)

The conditional base-tick caveat above is **source-resolved for two specific backends**, without claiming their actual wakeup precision:

- **v2.9.10 userspace RTAPI** [`src/rtapi/uspace_rtapi_app.cc::RtapiApp::clock_set_period`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/rtapi/uspace_rtapi_app.cc) blob `8e600cc4b7912bf683ce3e17e78d21bb63ae3261` L1218–1227: first positive request stores `period=nsecs` and returns it; query 0 returns the stored value; a second positive call is rejected. Development [same symbol](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/src/rtapi/uspace_rtapi_app.cc) blob `8bfbedec1d2f4a191291be15ba9b6ec5bfb35395` L185–194 retains this contract. Thus in these paths a requested 50,000 ns first tick is **stored as** 50,000 ns, not proven to be achieved by the OS at each wakeup.
- **v2.9.10 RTAI RTAPI** [`src/rtapi/rtai_rtapi.c::rtapi_clock_set_period`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/rtapi/rtai_rtapi.c) blob `4a241948c323361b2077365a1915b824949638b5` L491–523: checks 2,000 ns–1,000,000,000 ns, converts requested nanoseconds to hardware timer counts, adjusts downward when the conversion would exceed the request, starts the timer and returns `count2nano(got_counts)` as the actual base. Development [same RTAI symbol](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/src/rtapi/rtai_rtapi.c) blob `b019fda81f04c947e3ed2418c142d0fecf7f6ec3` L500–531 retains this behavior. Hence the *actual returned* base tick may differ from 50,000 ns and must be used in the quantization formula.

Development official [`rtapi_clock_set_period(3)`](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/docs/src/man/man3/rtapi_clock_set_period.3.adoc) blob `f9ea777698ac7f2ffea759baf86bf65fa8355309` correctly cautions that returned actual clock period may differ from requested due to hardware/RTOS limits. The two backend traces do **not** establish an exact scheduler wakeup guarantee. The LinuxCNC HAL rounding example therefore remains a nominal API prediction; on a particular machine the correct acceptance oracle must first establish backend and actual returned base period.

**Additional cases K–L (NOT RUN):** K: with userspace RTAPI, confirm the stored/query base is the requested positive value while independently measuring jitter; do not call stored equality a timing guarantee. L: with RTAI, compare requested period, timer count conversion and returned base; recompute the second-thread quantization from the returned value. A physical machine must remain disconnected, and no kernel/RTOS configuration changes are authorized by this guide.
