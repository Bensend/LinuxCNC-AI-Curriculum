# E01 — hm2_eth transport call flow

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Evidence level: **SOURCE-CONFIRMED** unless stated otherwise.

## Ownership and startup

`rtapi_app_main()` creates the HAL component, selects a network backend for every configured `board_ip[]`, initializes each socket/interface through `init_board()`, sets global `comm_active=1`, probes each board, creates transport diagnostics, installs per-interface traffic-isolation rules, exports `hm2_eth.realtime-init`, and finally calls `hal_ready()`.

`init_board()` is the transport-backend switch. At this revision the default/`posix` path installs POSIX init/realtime-init/close/send/recv callbacks. `evl` is accepted only in an EVL build running the EVL realtime type. The rest of `hm2_eth.c` reaches networking through these board callback pointers rather than directly depending on one socket implementation.

## Probe -> generic HostMot2 boundary

`hm2_eth_probe()` first sends an LBP16 board-info request and receives the 16-byte board name with `RECV_TIMEOUT_NON_RT_NS = 200 ms`. It maps recognized names to connector/FPGA metadata; the unrecognized-board fallback performs direct IDROM reads and is explicitly called a layering violation in source.

Probe then populates `hm2_lowlevel_io_t`: `read`, `write`, `queue_read`, `send_queued_reads`, `receive_queued_reads`, `queue_write`, `send_queued_writes`, optional `set_force_enqueue`, and `reset`. Only after this LLIO contract exists does it call `hm2_register(&board->llio, config[boards_count])`. Thus generic HostMot2 owns firmware/module interpretation while hm2_eth owns Ethernet transaction mechanics.

## Synchronous non-realtime I/O

`hm2_eth_read()` emits one LBP16 incremental HostMot2 read command, sends it, and waits for the requested bytes using the fixed 200-ms non-realtime timeout. It warns once if called from a realtime task because the extra request/response packet hurts performance. A negative receive returns failure; otherwise the bytes are copied to the caller.

`hm2_eth_write()` normally emits one LBP16 incremental write packet. In a realtime task, or when `force_enqueue` is set, it delegates to `hm2_eth_enqueue_write()` instead. This split is important: the ordinary read/write callbacks exist for initialization and exceptional access, while cyclic operation is designed around batching.

## Cyclic queued read path

1. Generic HostMot2 calls `queue_read()` repeatedly; hm2_eth appends LBP16 read commands and records destination buffers/offsets.
2. `send_queued_reads()` appends two transport-integrity operations: it reads the board's received-UDP/write count and writes then reads back the host `read_cnt` scratch value. It sends the combined request once.
3. `receive_queued_reads()` derives its timeout from HAL `packet-read-timeout`: default 80 means 80% of `llio.period`; values below 100 are percentages; the effective timeout is clamped to at least 100 us. Before HAL transport items exist it defaults to 1.6 ms.
4. A receive whose byte count differs from the expected aggregate size resets the queued-read bookkeeping and calls `record_soft_error()`. If the accumulated error limit is not yet exceeded, the function returns `-EAGAIN`; when the limit is exceeded it returns 0 after setting LLIO `io_error`.
5. A correctly sized packet is unpacked into queued destinations. If its echoed `read_cnt` is stale and the deadline has not expired, receive loops for another packet.
6. After queue reset, if a write has previously occurred and the board-confirmed `write_cnt` differs from the host count, that is also a soft communication error. Otherwise `decrement_soft_error()` reduces the accumulated level and clears current packet-error/exceeded indicators.

The counter echo therefore rejects stale/out-of-sequence receive data and detects failure of the preceding cyclic write; packet size alone is not the complete validity criterion.

## Cyclic queued write path

`queue_write()` appends LBP16 write commands and payloads to a board buffer. `send_queued_writes()` appends a write of incremented host `write_cnt` to the board timer space, marks `has_written_cnt`, sends the aggregate packet once, and resets the write buffer pointer. The following queued read obtains the board-side confirmation, creating the cross-cycle write-integrity check described above.

## Error state and recovery boundary

`record_soft_error()` sets `llio.needs_soft_reset`, asserts `packet-error`, increments total and weighted error level, clamps at `packet-error-limit`, and when the limit is reached asserts both `*llio.io_error` and `packet-error-exceeded`. A later successful cycle calls `decrement_soft_error()`. If a user clears `io_error` after the counter has reached its limit, the receive path resets the communication-error counter before continuing.

This is **not** evidence that a physical machine is safe after packet loss. It is software error accounting and LLIO fault propagation only.

`hm2_eth_reset()` is stronger than a communications retry: it sends a watchdog-register write intended to make the HostMot2 watchdog bite in 1 ns. E01 records this mechanism but does not claim physical watchdog effectiveness or safety rating; HM08 owns watchdog semantics.

## Shutdown/failure ownership

If startup fails, `rtapi_app_main()` closes configured boards, removes firewall state/lists, and exits HAL because `rtapi_app_exit()` will not be called for failed initialization. Normal unload first sets `comm_active=0`, then closes boards, removes firewall/list state, and calls `hal_exit()`.

## Important 1000-level conclusions

- hm2_eth is the Ethernet LLIO implementation; generic HostMot2 remains above it.
- Initialization/direct reads use a fixed non-realtime timeout, while cyclic queued receive uses a period-related configurable timeout.
- Realtime writes are batched; direct realtime reads are allowed but explicitly warned as a performance problem.
- Cyclic receive validity uses expected packet size plus host/board read/write counters.
- Communication faults accumulate through a soft-error policy before `llio.io_error` is asserted at the configured limit.
- `needs_soft_reset`, `io_error`, and the watchdog-bite reset path must not be conflated with safety certification.

## Promotion queue

- Exact POSIX socket setup, interface routing/ARP and firewall isolation interactions: **2000 / MEDIUM** unless needed to debug E01 lab behavior.
- Packet reordering/duplication/loss behavior under controlled network fault injection and exact `-EAGAIN` retry ownership: **2000 / HIGH**.
- Cross-version comparison of timeout/error policy and EVL backend: **2000 / HIGH**.
- Physical Ethernet latency/jitter and NIC/IRQ tuning: **commissioning/advanced / CRITICAL**, hardware required.
- Watchdog bite/effectiveness and safe-output behavior: **HM08 then advanced safety / CRITICAL**.

## Next experimental target

Build a no-hardware, bounded source/test harness around the pinned queued-receive state machine if practical. It should discriminate at least: successful counter-confirmed receive, stale read-counter retry, wrong-size receive -> soft error, error-limit -> `io_error`, and successful-cycle decrement. If isolating the static transport functions requires invasive production-source surgery, classify that harness cost explicitly and use existing upstream tests or a narrow compile-time fixture rather than pretending a static grep is runtime evidence.
