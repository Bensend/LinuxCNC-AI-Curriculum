# E01 initial research — hm2_eth architecture and LLIO transport boundary

Pinned source target: `8bf4605ae81042248add031e94c77300406e0413`
Status: **RESEARCH / SOURCE STARTED**

## Official documentation boundary

The LinuxCNC `hm2_eth(9)` documentation identifies `hm2_eth` as the HAL driver for Mesa Ethernet Anything I/O boards carrying HostMot2 firmware and states that it is a `uspace` realtime driver. The documented deployment assumption is a dedicated wired network interface; wireless and USB network interfaces are specifically discouraged. Current master documentation has acquired additional `board_rtnet` and firewall-backend controls, so those newer options must not be silently projected backward onto the pinned HM01/E01 revision without source comparison.

## Community field signal

Historical LinuxCNC forum discussion documents why packet-loss/recovery behavior deserves its own E01 trace rather than being inferred from generic HostMot2. Older hm2_eth generations could react badly to a missing request/response, potentially waiting long enough to affect realtime deadlines and allow a board watchdog to act. That report is useful as an adversarial question, not evidence for current/pinned behavior. E01 must source-trace the pinned timeout/error path before making any recovery claim.

## Pinned source observations started

At the pinned revision, `hm2_eth.c` is explicitly a low-level HostMot2 driver and includes the HostMot2 LLIO headers plus POSIX network support, with conditional EVL support. It defines a separate `RECV_TIMEOUT_NON_RT_NS` of 200 ms for initialization/non-realtime activity. This is already evidence that initialization transactions and realtime board-cycle transactions must not be described with one undifferentiated timeout model.

The source exports concrete LLIO callbacks including `hm2_eth_read()` plus queued-read send/receive paths. HM01 established that these are installed into `hm2_lowlevel_io_t` before `hm2_register()` hands control to generic HostMot2. E01 now owns the details beneath those callbacks.

## Working call-flow decomposition

The next source trace will document these layers separately:

1. module parameters / board selection (`board_ip`, board identity and config);
2. interface/socket and network-backend setup;
3. initialization-time register reads used before/during `hm2_register()`;
4. synchronous LLIO `read` / `write` transaction encoding and receive validation;
5. queued/split read and write lifecycle used by HostMot2's cyclic path;
6. receive timeout, packet validation, sequence/error accounting and `llio.io_error` propagation;
7. reset/recovery behavior and what remains usable after an error;
8. cleanup/unload ownership.

## Claims deliberately not promoted

- no packet-loss recovery claim yet;
- no fixed Ethernet latency or jitter number;
- no claim that 200 ms is a realtime-cycle receive timeout;
- no claim that a watchdog will always produce a safe physical state;
- no assumption that current-master EVL/firewall behavior exists identically at `8bf4605...`.

## Exact next source checkpoint

Locate and trace the pinned implementations of `hm2_eth_read`, `hm2_eth_write`, queued-read/write send/receive helpers, the network-backend calls they invoke, and every branch that writes LLIO `io_error` or changes communication state. Then trace board discovery/open/setup into the already-known `hm2_register(&board->llio, config[boards_count])` handoff. Convert that into an E01 call-flow artifact before designing a laboratory experiment.