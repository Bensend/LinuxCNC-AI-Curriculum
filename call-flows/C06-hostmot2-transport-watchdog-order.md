# C06 — HostMot2 Transport / Watchdog Servo-Cycle Call Flow

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Evidence class: SOURCE-CONFIRMED unless otherwise stated.

## Generic read/request ordering

`hostmot2.c:hm2_read_request()` stores the servo period in `llio->period`, refuses to touch the low-level driver while `io_error` is true, queues all registered TRAM reads via `hm2_tram_read()`, queues raw/TP-PWM reads, then calls `hm2_queue_read()` and marks `llio->read_requested=true` with a request timestamp.

`tram.c:hm2_tram_read()` walks every registered TRAM read region and calls `llio->queue_read()`. `hm2_queue_read()` calls optional `llio->send_queued_reads()`.

`hostmot2.c:hm2_read()` consumes a previously requested read or invokes `hm2_read_request()` itself, clears `read_requested`, returns immediately if `io_error` is set, and then calls `hm2_finish_read()`. `tram.c:hm2_finish_read()` delegates to optional `llio->receive_queued_reads()`; `-EAGAIN` is treated by `hm2_read()` as a temporary read failure and no module TRAM processing occurs that cycle.

Only after a successful finish and a second `io_error` check does `hm2_read()` process the received TRAM image. The watchdog status is processed first: `hm2_watchdog_process_tram_read()`, followed by GPIO, encoders, stepgen and other module readers.

Therefore the watchdog status bit is not independently observable by generic HostMot2 when the transport read fails: the status is part of the same received TRAM image and its processor is skipped when `io_error` or a temporary receive failure prevents normal read completion.

## Generic write ordering

`hostmot2.c:hm2_write()` first returns if `io_error` is true. Otherwise it initializes DDR if required, then prepares write-side TRAM in module order beginning with `hm2_watchdog_prepare_tram_write()`. The watchdog prepare function writes the reset/pet pattern `0x5a000000` into the watchdog TRAM reset register.

The generic writer then calls `hm2_tram_write()`, which queues each registered write region through `llio->queue_write()`. After TRAM queuing it performs module-specific direct writes, including `hm2_watchdog_write()`, and finally calls `hm2_finish_write()`, which delegates to optional `llio->send_queued_writes()`.

This ordering means the normal TRAM write path carries the watchdog reset/pet value every serviced write cycle. `hm2_watchdog_write()` is primarily responsible for timeout/configuration/recovery state, not the ordinary per-cycle TRAM pet itself.

## Watchdog bite and recovery state

`hm2_watchdog_process_tram_read()` returns if no watchdog exists, if `io_error` is true, or if `llio->needs_reset` is already nonzero. If the watchdog status register bit 0 is set, it sets HAL `watchdog.has_bit=true` and `llio->needs_reset=1`.

`hm2_watchdog_write()` returns while `io_error` is true or while the user-visible `watchdog.has_bit` remains true. Once the user clears `has_bit`, a pending `needs_reset` or `needs_soft_reset` causes the function to clear the local watchdog status image and call `hm2_force_write()` to rewrite FPGA configuration. Recovery aborts if `io_error` reappears. Only after successful recovery are `needs_reset` and `needs_soft_reset` cleared.

The low-level contract in `hostmot2-lowlevel.h` is explicit: low-level drivers set `io_error` on detected I/O failure; HostMot2 stops calling the llio while it remains true; users may clear the HAL parameter to allow HostMot2 to resume and reset/re-drive the hardware. `needs_reset` may originate from an llio error or watchdog bite; `needs_soft_reset` is similar but suppresses the user message.

## Deterministic software-only test seam

Pinned `src/hal/drivers/mesa-hostmot2/hm2_test.c` is an existing hardware-free low-level I/O driver. Its comments state that it behaves like a HostMot2 llio and supplies compiled-in register data specifically to test HostMot2 without special hardware. Its `read()` copies from an in-memory register pattern and its `write()` returns success.

For C06, this is preferable to disturbing a real host Ethernet interface. A lab-local, explicitly recorded instrumentation patch can extend `hm2_test` with deterministic HAL-controlled failure injection while leaving generic `hostmot2.c`, `tram.c`, and `watchdog.c` unchanged. The patch must be classified as test-harness code, not LinuxCNC production behavior.

## Retained safety boundary

A packet/read failure, `io_error`, or FPGA watchdog bite is diagnostic/control-system evidence only. It does not prove an attached drive, valve, motor, hydraulic system, or machine has entered a safe state, and clearing software-visible fault state does not prove restart is safe.
