# HM08 — HostMot2 watchdog cycle and recovery

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Evidence state: **SOURCE-CONFIRMED** unless otherwise marked.

## Normal read-side detection

`hm2_read()` completes the LLIO/TRAM read first. If `io_error` is already asserted it returns without interpreting module data; a temporary `hm2_finish_read() == -EAGAIN` also returns for that invocation. Only after a successful finish and a second `io_error` check does it call `hm2_watchdog_process_tram_read()`.

`hm2_watchdog_process_tram_read()` does nothing when no watchdog exists, communication is already unhealthy, or `llio->needs_reset` is already set. Otherwise status bit 0 means a watchdog bite: it sets the HAL IO pin `watchdog.has_bit = true` and sets `llio->needs_reset = 1`.

The deliberate use of `needs_reset`, rather than rereading the user-clearable `has_bit` pin as the internal latch, prevents a user clear from racing the detection/recovery state machine.

## Normal write/pet path

`hm2_write()` first refuses the entire write cycle while `io_error` is asserted. It then prepares module TRAM buffers. `hm2_watchdog_prepare_tram_write()` writes `0x5a000000` into the watchdog reset/pet TRAM buffer before `hm2_tram_write()` sends the combined TRAM write. Therefore the ordinary HostMot2 `write` function is also the recurring watchdog pet path.

After the TRAM write, `hm2_write()` calls `hm2_watchdog_write(hm2, period)`. This second watchdog function is not the ordinary per-cycle pet; it manages watchdog enable/timeout changes and recovery.

On the first healthy call, `hm2_watchdog_write()` sets the software `enable` flag to 1. If neither timeout nor enable state matches what was last written, it calls `hm2_watchdog_force_write()`. That function converts `timeout_ns` to FPGA counts, writes the timer register, records `written_timeout_ns`/`written_enable`, and writes the status register. If disabled, timer value `0x80000000` is the FPGA handshake value. A requested timeout shorter than 1.5 times the HAL function period produces a warning but is not rejected.

## Bite -> user acknowledgment -> recovery

1. A successful read cycle observes watchdog status bit 0.
2. `hm2_watchdog_process_tram_read()` sets `has_bit = true` and `needs_reset = 1`.
3. Subsequent `hm2_watchdog_write()` calls return while `has_bit` remains true. The user-visible pin therefore gates software recovery.
4. After the user clears `has_bit`, `hm2_watchdog_write()` sees `needs_reset` and/or `needs_soft_reset`, clears the local watchdog status buffer, and calls the generic `hm2_force_write()`.
5. `hm2_force_write()` force-writes watchdog state plus the other HostMot2 module configuration/state writers. If the low-level driver supports `set_force_enqueue`, force enqueue is bracketed around the sequence.
6. If this recovery creates/asserts `io_error`, recovery returns without clearing reset flags. Otherwise `needs_reset` and `needs_soft_reset` are both cleared.

This means `has_bit` is the user acknowledgment gate, while `needs_reset` is the driver's durable internal recovery latch. They are related but are not interchangeable state variables.

## `io_error` boundary

`io_error` is stronger than the watchdog-bite latch in the generic paths traced here. Generic `hm2_read()` and `hm2_write()` return early while it is true, and `hm2_watchdog_write()` itself also returns. Consequently a transport/LLIO-specific mechanism must make communication healthy/clear `io_error` before generic watchdog recovery can progress. Exact transport recovery is driver-specific and belongs with E03/E06/E07, not HM08.

`needs_soft_reset` shares the generic force-write recovery branch with `needs_reset`, but this module does not claim that the two flags have identical causes or transport semantics.

## Unregister path

`hm2_unregister()` attempts to make an existing watchdog bite promptly by setting software enable, setting `timeout_ns` to 1 ns, and calling `hm2_watchdog_force_write()` before cleanup. This is a software/register action. It is not proof that a physical board reached a hazard-safe state.

## Documentation reconciliation

Current HostMot2 documentation agrees with the pinned implementation that the watchdog begins inactive, is serviced by the HostMot2 write function, exports `has_bit` and `timeout_ns`, defaults timeout to 5 ms, and requires clearing `has_bit` to resume after a bite. Documentation further describes board I/O pins becoming high-impedance inputs on a bite. That physical/firmware statement is **DOC-CONFIRMED**, not cloud-lab TEST-CONFIRMED here.

Historical documentation used a distinct `pet_watchdog()` function and even a different default timeout. Do not project those old interfaces onto the pinned development revision.

## Community evidence

Forum reports consistently treat `Watchdog has bit` as a symptom of a sufficiently long communication/realtime interruption, with possible causes including host latency, too-short timeout, network dropouts, NIC/IRQ/power-management behavior, or hardware faults. These are **COMMUNITY-REPORTED diagnostic leads**, not a proof of cause for any particular machine.

## Experiment feasibility assessment

Upstream `hm2_test` is a genuine no-hardware LLIO fixture and its write callback returns success, but it is primarily a compiled-in register-file/registration test pattern. The inspected fixture does not emulate watchdog timer progression, a watchdog bite, physical I/O disconnection, or communication loss. A production-function experiment could potentially be added by extending the fake register pattern with a valid watchdog descriptor and observable write capture, but testing actual bite timing/state would require materially extending the fake hardware model.

For HM08 1000-level scope, do not fake physical watchdog effectiveness. A useful bounded experiment should test production HostMot2/watchdog software state transitions only if it can reuse `hm2_test` with minimal instrumentation: exported objects/default timeout, first-write enable/timer programming, synthetic status-bit detection -> `has_bit`/`needs_reset`, and user-clear -> force-write recovery. If that requires invasive production-source copying rather than fixture extension, promote it to the advanced queue.

## Safety boundary

Neither source inspection nor a fake LLIO proves physical de-energization, bounded physical reaction time, output electrical state on a particular Mesa board/firmware/interface, or functional-safety qualification. Those require firmware/hardware evidence and machine-specific hazard analysis.
