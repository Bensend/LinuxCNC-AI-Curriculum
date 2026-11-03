# HM2-178 — HostMot2 watchdog, Ethernet packet errors and servo-thread ordering (source trace)

Status: **NON-GRADUATED; SOURCE-CONFIRMED stable v2.9.10 only; TEST-CONFIRMED none.** Follow-up to [MESA-177](4400_LINUXCNC_MESA_177_7I96S_UPSTREAM_HAL_INI_ORDER_AUDIT_2026-11-03.md). No machine authorization.

## Scope and provenance

Upstream [LinuxCNC v2.9.10](https://github.com/LinuxCNC/linuxcnc/tree/v2.9.10), inspected via repository contents API on 2026-11-03:

- `src/hal/drivers/mesa-hostmot2/hostmot2.c`, blob `75619ae3f6925087a6693c5421bbf629f4459d94`, functions `hm2_read_request` (77–92), `hm2_read` (94–122), `hm2_write` (125–165).
- `src/hal/drivers/mesa-hostmot2/watchdog.c`, blob `73b1a34d2410295f8903118bf0cfd9e00d7166e6`, `hm2_watchdog_process_tram_read` (33–55), `hm2_watchdog_write` (252–302).
- `src/hal/drivers/mesa-hostmot2/hm2_eth.c`, blob `1c338be89cb9620a0b6f23c8c21c5e137afaabdc`, `record_soft_error` (871–886), `decrement_soft_error` (888–897), `hm2_eth_receive_queued_reads` (899 onward).
- Previous MESA-177 7i96S bundled example is **not authenticated PNCconf output**. Its source schedule is `hm2.read → motion-command-handler → motion-controller → hm2.write → estop-latch`.

## Reproducible call-path walkthrough

1. At `hm2_read`, a missing queued read first calls `hm2_read_request`. Either path returns early on `llio.io_error`. A temporary `hm2_finish_read == -EAGAIN` returns before updating decoded watchdog, encoder, stepgen or GPIO HAL feedback. **Source-confirmed**: HAL feedback can remain at its prior published value on these branches. The precise Ethernet circumstances that yield EAGAIN and any resulting freshness interval remain **UNKNOWN**.
2. Successful read completion calls `hm2_watchdog_process_tram_read` before GPIO, encoder and stepgen decoding. A watchdog status bit sets `watchdog.has_bit` and `llio.needs_reset` unless reset is already pending. These are software observations of FPGA state, not a timestamped physical stop.
3. `hm2_write` checks `io_error`, prepares watchdog reset and module output TRAM buffers, performs `hm2_tram_write`, then calls `hm2_watchdog_write` for timeout/enable changes and recovery. **Important distinction:** a successful host `hm2.write` call does not by itself prove a particular output transition reached a physical drive.
4. `hm2_watchdog_write` returns if `io_error` or `watchdog.has_bit` remains asserted. On reset-needed paths after the operator clears the has-bit condition, it calls `hm2_force_write` and clears `needs_reset/needs_soft_reset` only if no IO error was detected. This is a *recovery path*, not evidence that machine-specific actuator interlocks have been requalified.
5. `hm2_eth.c::record_soft_error` increments `packet-error-total`, increases a bounded error level, sets `needs_soft_reset`, and latches `llio.io_error` when the configurable limit is reached. `decrement_soft_error` reduces the level and clears transient packet-error indicators; it does not itself clear the latched `llio.io_error`. The receive path contains a special case that resets its internal counter when the limit had been reached and the externally writable IO-error flag was cleared. Therefore **packet-error, packet-error-level, packet-error-exceeded, io_error and watchdog.has_bit are distinct diagnostics**, not interchangeable evidence of a successful output or a safe reset.

## Timing implications and limits

- With the MESA-177 order, `estop-latch` executes after `hm2.write`. A change computed only by that latch cannot affect the already completed write call in that same HAL pass; whether another independent output path reacts sooner is machine/configuration dependent (**INFERENCE**).
- `watchdog.c` initializes a nominal 5 ms timeout (line 172) and warns if configured timeout is below 1.5 × the `hm2_write` period (292–299). This warning is not a deterministic stop-time guarantee. Network transport, hardware FPGA behavior, drive enable wiring and task-level stop behavior must be separately verified.
- A persistent `io_error` skips both HostMot2 reads and writes, so apparent stable feedback may be stale. A dashboard must distinguish **last sample**, **sample age**, **communications state**, and **independent physical feedback**.
- No claim of personnel safety or hardware E-stop authority follows from these software watchdog branches.

## Disconnected verification matrix (NOT RUN)

| Case | Stimulus in isolated fake LLIO/HostMot2 harness | Oracle |
|---|---|---|
| A | Successful read and write | Decode order; TRAM write precedes timeout-change handling |
| B | Set `io_error` before read | No decoder update; prior HAL feedback retained |
| C | `hm2_finish_read` returns `-EAGAIN` | No watchdog/encoder/stepgen decode this pass |
| D | FPGA watchdog status bit set | `has_bit` and `needs_reset` become asserted |
| E | `has_bit` remains set | No recovery `force_write` |
| F | Clear has-bit with reset pending, no IO error | Force-write attempted, reset flags cleared only on success |
| G | Ethernet soft errors reach packet limit | IO error latches; next HostMot2 read/write return early |
| H | Soft-error decrement below limit | Transient diagnostic clears; does not assert successful hardware write |
| I | Estop latch changes output after hm2.write | Next-cycle path distinguished from independent hardware stop |

**Do not** run these against connected actuators. The harness must log cycle number and monotonic timestamps for read-request, read-finish, decoder, motion, write and latch; freeze both positive and negative controls before execution. No test results, compiler outputs, waveform measurements or runner isolation attestations exist in this lesson.

## Prediction and adversarial transfer

Prediction before execution: when `io_error` is asserted, HostMot2 read/write callbacks return without updating hardware or published position; a UI that sees an unchanged position value alone cannot tell that feedback stopped. Falsifier: an independent timestamped encoder update or an alternate callback demonstrably refreshing that same HAL pin during the error interval.

Questions for a fresh engineer: (1) Does `packet-error=0` imply `io_error=0`? (2) Does clearing `watchdog.has_bit` prove the drive is safe to re-enable? (3) What is the effect of scheduling an estop-latch *after* hardware write? (4) Can a read failure masquerade as zero velocity? (5) Which branch would need source inspection to determine if EAGAIN is benign or sustained? (6) How would you detect a stalled feedback stream without mistaking stepgen commanded-position feedback for a physical encoder?

## Next evidence

Inspect stable/development differences and Ethernet `hm2_finish_read` handling; obtain a **verifiably PNCconf-generated** 7i96S HAL/INI (do not relabel an upstream bundled sample); add a disconnected timestamped fake-LLIO oracle only after qualified self-hosted runner isolation. MOTION-144 remains the first executable queue item under the current checkpoint. Preserve graduated modules, blind evaluator separation and independent safety gates.
