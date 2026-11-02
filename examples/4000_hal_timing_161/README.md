# HAL-TIMING-161 disconnected period/type probe

This is a **non-motion HAL fixture**. It loads `threads` and `siggen` only; it does not load motion, a Mesa driver, EtherCAT, or any output hardware. **Do not run on a machine-connected panel PC.** Only execute when an independently verified physically disconnected `[self-hosted, openpressbrake]` environment is available.

In a fresh `halrun` shell (do not paste `halcmd:` prompts):

```text
loadrt threads name1=fast period1=50000 name2=slow period2=1024999
loadrt siggen
addf siggen.0.update slow
start
show thread
show pin slow.time
show pin siggen.0.update.time
```

For **stable v2.9.10** also run `show param slow.tmax` and `show param siggen.0.update.tmax`. For **development pinned commit 67437d8**, instead run `show pin slow.tmax`, `show pin siggen.0.update.tmax`, and `show pin slow.threadbeat` twice. Stop and exit: `stop`, then `exit`.

In a **second fresh halrun shell**, change only `period2=1024999` to `period2=1025000`. With actual 50,000 ns base the source expression predicts **1,000,000 ns** then **1,050,000 ns** nominal slow periods. If actual RTAPI base differs, recalculate; record the actual `show thread` output, not only the requested value. Stable `.time/.tmax` are clock counts; development `.time/.tmax` are seconds.

**NOT RUN.** No command here constitutes a machine safety check, physical jitter measurement, or authorization to start a motor. See [audit](../../research/4400_LINUXCNC_HAL_TIMING_161_THREAD_PERIOD_QUANTIZATION_AND_TELEMETRY_VERSION_SOURCE_AUDIT_2026-11-02.md) and [A–H acceptance card](../../guides/3100-3300-3400-4000-linuxcnc-hal-thread-period-and-runtime-telemetry-commissioning-2026-11-02.md).
