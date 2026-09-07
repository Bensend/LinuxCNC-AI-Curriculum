# S03 — hm2_eth Communication Loss to Host Stale State

Status: **SOURCE-CONFIRMED call flow**
Course level: 1000
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Scope

This trace connects the pinned `hm2_eth` transport policy to the generic HostMot2 realtime read/write boundary. It deliberately stops before claiming FPGA output state, drive response, STO, stopping time, or functional safety.

## 1. Normal queued read

In `src/hal/drivers/mesa-hostmot2/hm2_eth.c`, `hm2_eth_send_queued_reads()` appends two protocol checks to the queued HostMot2 reads before transmission:

1. a readback of the low 16 bits of the last write count (`rxudpcount`);
2. a scratch-register write/read using the incremented `read_cnt`, returned into `confirm_rw_cnt`.

This means the receive side can distinguish a merely received UDP datagram from the response associated with the current queued transaction.

## 2. Receive timeout / malformed-size path

`hm2_eth_receive_queued_reads()` derives `read_timeout` from `packet-read-timeout`: <=0 becomes 80% of the LLIO thread period, values below 100 are interpreted as a percentage of the period, and the result is clamped to at least 100 us.

It then calls `eth_socket_recv()` for exactly `queue_buff_size` bytes. If the returned byte count differs from that expected size, it:

- resets queued-read bookkeeping;
- calls `record_soft_error()`;
- returns `-EAGAIN` while the error level remains below the permanent-error limit;
- returns 0 once `record_soft_error()` reaches the limit.

Thus a temporary transport/read failure is not identical to permanent `io_error`.

## 3. Wrong transaction response

After a correctly sized packet is copied into queued destinations, the driver checks `confirm_rw_cnt.read_cnt` against the current `read_cnt`. While still before `read_deadline`, a mismatched response causes another receive attempt rather than immediate publication.

After queued-read bookkeeping is reset, the driver also checks the returned write counter when `has_written_cnt` is true. A mismatch between `write_cnt` and `confirm_rw_cnt.write_cnt` calls `record_soft_error()`.

A successful matching cycle instead calls `decrement_soft_error()`.

## 4. Error accumulator and permanent boundary

`record_soft_error()` is the central escalation function:

- marks `llio.needs_soft_reset = 1`;
- sets HAL `packet-error = TRUE`;
- increments cumulative `packet-error-total`;
- adds at least 1 (or configured `packet-error-increment`) to `comm_error_counter`;
- clamps the counter to `packet-error-limit`;
- publishes `packet-error-level`;
- when the level reaches the limit, sets LLIO `io_error = TRUE` and `packet-error-exceeded = TRUE`.

`decrement_soft_error()` subtracts at least 1 (or configured `packet-error-decrement`) on a successful cycle, clamps at zero, publishes the lower level, and clears the per-cycle `packet-error` and `packet-error-exceeded` indications.

This is an error-level policy, not simply a consecutive-packet-loss counter.

## 5. Manual clear / retry boundary

At the beginning of `hm2_eth_receive_queued_reads()`, if `comm_error_counter` equals the configured limit but the user has cleared LLIO `io_error`, the driver resets `comm_error_counter` to zero. This permits communication attempts to resume.

Important: clearing `io_error` is permission to retry. It is not evidence that the FPGA, remote I/O, drive, encoder state, or machine state is synchronized. Fresh successful transactions must be observed before treating subsequent feedback as fresh.

## 6. Join to generic HostMot2 read publication

In pinned `src/hal/drivers/mesa-hostmot2/hostmot2.c`:

`hm2_read_request()`

- stores the period;
- returns immediately if LLIO `io_error` is already TRUE;
- queues TRAM/raw/TP-PWM reads only while the error remains clear;
- sets `read_requested` only after queue setup.

`hm2_read()`

- requests a read when necessary;
- clears `read_requested`;
- returns immediately on persistent `io_error`;
- returns without module publication when `hm2_finish_read()` returns `-EAGAIN`;
- rechecks `io_error` after finishing the transport read;
- only then calls module processors including GPIO, encoder, resolver, stepgen, Smart Serial, absolute encoders, and other TRAM consumers.

Therefore both a transient `-EAGAIN` cycle and a permanent `io_error` state can leave previously published module HAL values visible. The distinction is duration/policy, not freshness: **unchanged HAL feedback is not proof of a fresh unchanged measurement.**

Representative values subject to this stale-publication boundary include GPIO input state, encoder count/position/velocity, stepgen feedback state, Smart Serial remote process data, resolver feedback, and other values updated by the skipped per-module TRAM processors. Exact pin names depend on configured modules.

## 7. Join to HostMot2 write suppression

`hm2_write()` checks `io_error` before DDR initialization, cyclic write preparation, `hm2_tram_write()`, change-detected configuration writes, raw writes, and `hm2_finish_write()`. Persistent `io_error` therefore suppresses the normal HostMot2 host command-delivery path.

This creates a second diagnostic trap: a HAL command can change on the host while the normal HostMot2 write function is returning early. The changed host pin must not be described as a command proven to have reached the FPGA or downstream actuator.

## 8. Failure-domain separation

| Evidence | Valid conclusion | Invalid leap |
|---|---|---|
| `packet-error=TRUE` | latest cycle detected a transport/read/write problem | permanent communication loss |
| elevated `packet-error-level` | recent errors accumulated under hm2_eth policy | FPGA watchdog has bitten |
| `io-error=TRUE` | hm2_eth reached persistent LLIO error boundary | outputs are physically safe |
| frozen encoder/GPIO HAL value | no newer publication is visible | shaft/input is physically unchanged |
| changed host command during `io-error` | software-side command changed | board received it |
| manual clear of `io-error` | host may attempt communication again | machine state is synchronized/safe |

## Experiment decision

A useful 1000-level independent test should avoid pretending to emulate Ethernet hardware. The highest-information bounded experiment is a mutable fake-LLIO production-path test that:

1. publishes a known module value through normal HostMot2 processing;
2. changes the fixture's backing register value but asserts LLIO `io_error` before the next HostMot2 read;
3. verifies the prior HAL value remains published rather than adopting the changed backing value;
4. changes an output command while `io_error` is asserted and verifies the LLIO write-capture count does not advance;
5. clears `io_error`, performs a fresh successful cycle, and verifies publication/write capture resumes.

This can TEST-CONFIRM the generic HostMot2 stale-publication/write-suppression boundary. It cannot test UDP timeout behavior, packet-error accumulation, FPGA watchdog timing, electrical output state, drive response, or safety.

If extending the existing fake-LLIO fixture requires building a complete valid module descriptor merely to observe one GPIO/encoder value, prefer the smallest already-valid HostMot2 fixture and instrument its existing TRAM region rather than constructing a fake Ethernet target.

## Prediction before experiment

**Prediction:** once a known fresh HostMot2 value has been published, asserting LLIO `io_error` before the next `hm2_read()` will leave that previous HAL value unchanged even if the fake backing register changes; normal `hm2_write()` will likewise perform no captured LLIO write until `io_error` is cleared. After clear and a successful cycle, fresh publication/write activity should resume.

A failure of either stale-publication or write-suppression prediction blocks S03 graduation until explained, because both are central teachings of this module.
