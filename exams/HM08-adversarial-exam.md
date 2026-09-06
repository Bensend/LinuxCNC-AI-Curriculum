# HM08 adversarial exam — HostMot2 watchdog

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

1. A reviewer says `hm2_watchdog_write()` is the function that pets the watchdog every servo cycle. Correct the premise and reconstruct the normal write-side sequence.
2. A watchdog status bit arrives in a successful HostMot2 read. What host-visible/internal state changes, and why is the internal reset latch needed in addition to the HAL pin?
3. `watchdog.has_bit` is still true. Explain why clearing `needs_reset` directly would not describe the production recovery protocol.
4. The operator clears `watchdog.has_bit`. Trace the recovery path and state exactly when `needs_reset`/`needs_soft_reset` may be cleared.
5. `llio->io_error` is asserted. What does generic HostMot2 do on read/write/watchdog paths, and which module family owns transport-specific recovery questions?
6. A configuration requests `watchdog.timeout_ns` shorter than 1.5 times the HostMot2 write period. Does pinned source reject it? What does it do instead, and what reliability concern follows?
7. Misleading premise: "The 5 ms default proves outputs become safe within 5 ms after any PC or Ethernet failure." Identify every unsupported leap in that statement.
8. Explain why the existing `hm2_test` write-success stub cannot verify user-clear -> force-write watchdog recovery merely by adding a status bit to its static register image.
9. Bounded modification task: design the smallest *2000-level* fake-LLIO extension that could test host-side watchdog state transitions without copying `watchdog.c`. State what it may and may not prove.
10. A machine HAL file wires `watchdog.has_bit` into an estop latch. What architectural conclusion is justified, and what safety conclusion is not?

## Pass criteria

A passing answer must distinguish ordinary pet preparation from watchdog configuration/recovery, distinguish `has_bit` from reset latches, preserve `io_error` boundaries, reject physical/safety overclaims, and correctly classify a synthetic fake-LLIO experiment as host-software evidence only.
