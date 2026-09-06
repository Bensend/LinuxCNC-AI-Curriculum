# HM08 initial research — HostMot2 watchdog mechanism

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Status: **RESEARCH / SOURCE STARTED**

## First pinned source findings

`watchdog.c` parses exactly one effective watchdog instance, registers a TRAM read region for status and a TRAM write region for reset/pet data, allocates a timer register buffer, exports HAL IO pin `<board>.watchdog.has_bit`, and exports RW parameter `<board>.watchdog.timeout_ns` with a 5 ms default.

`hm2_watchdog_prepare_tram_write()` prepares reset/pet value `0x5a000000`. `hm2_watchdog_force_write()` converts requested timeout nanoseconds to FPGA timer counts; when disabled it uses `0x80000000` as the FPGA handshake value. It writes the timer and clears watchdog status through LLIO writes.

`hm2_watchdog_write()` refuses work while LLIO `io_error` is asserted or while HAL `has_bit` remains true. Otherwise it enables the watchdog on first write. If `needs_reset` or `needs_soft_reset` is set, it clears local status, calls the broader `hm2_force_write()` recovery path, checks for renewed I/O error, then clears reset flags on success. A requested timeout below 1.5 times the hm2 write period triggers a warning but is not rejected.

`hm2_watchdog_process_tram_read()` observes the status bit only when communication is healthy and reset is not already pending. A hardware status bit sets HAL `has_bit` and LLIO `needs_reset`. The source comment explicitly uses `needs_reset` rather than the user-clearable HAL pin to avoid a race with the pet/recovery path.

## Important safety boundary

These are software/register mechanisms. They do not establish what physical outputs a particular FPGA image/board/interface reaches after a bite, whether that state is hazard-safe, whether Ethernet loss always produces a bite within a bounded physical time, or whether any resulting system is functionally safety-rated.

## Exact next checkpoint

Trace callers/order of `hm2_watchdog_prepare_tram_write()`, `hm2_watchdog_process_tram_read()`, `hm2_watchdog_write()`, and `hm2_watchdog_force_write()` through generic HostMot2 read/write cycles. Then trace how watchdog reset interacts with `hm2_force_write()`, `needs_reset`, `needs_soft_reset`, and LLIO `io_error`. Add official documentation/community field behavior only as bounded evidence, then design a no-hardware watchdog-state experiment if an upstream fake-LLIO fixture can execute the production watchdog functions.