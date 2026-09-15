# 4000 HostMot2 watchdog/recovery first pass — 2026-09-15

Pinned LinuxCNC revision: `ebe65c0a915d618097b9dbb26cd24d67ce4a5700`.

## Driver state machine

`src/hal/drivers/mesa-hostmot2/watchdog.c` shows a materially different but mature watchdog/recovery contract from the two Colorlight/LiteX examples.

- HostMot2 exposes `watchdog.has_bit` as a HAL I/O pin and `watchdog.timeout_ns` as a writable parameter.
- Default timeout in the pinned driver is 5 ms.
- The first normal watchdog write enables the FPGA watchdog; the source explicitly notes that once writing wakes it, the host must continue petting it or it will bite.
- If hardware status reports a bite, the driver sets `watchdog.has_bit` and `llio->needs_reset`.
- While `has_bit` remains set, normal watchdog writes wait for user reset rather than silently resuming.
- Recovery occurs after the user clears the bite state: the driver clears watchdog status, force-writes all settings to the FPGA, verifies communication state, and only then clears `needs_reset`/`needs_soft_reset`.
- The driver warns when configured timeout is less than 1.5 times the `hm2_write()` period.

This is a strong explicit rearm/reconstruction model: **fresh communications returning is not by itself permission to resume stale pre-fault machine state.**

## Ethernet low-level behavior

Pinned `hm2_eth.c` contains an explicit low-level reset path that sends a HostMot2 watchdog write intended to make the timer bite almost immediately. This means the Ethernet driver can deliberately force the FPGA into its watchdog fault posture during reset/cleanup rather than relying only on host-side flags.

## HAL supervisory example

Shipped Mesa example HAL files feed `watchdog.has_bit` into an `estop-latch` fault input. This demonstrates a normal-control supervisory pattern where the FPGA freshness failure is also surfaced to LinuxCNC machine state.

Again, that HAL loop is not treated here as proof of independent functional safety.

## 4000 comparison result so far

All three inspected architectures agree on a core principle but differ in recovery details:

- **HostMot2:** FPGA watchdog + HAL bite witness + driver `needs_reset` + user-clear/force-write reconstruction before recovery.
- **Lcnc/ColorCNC-derived:** FPGA watchdog + explicit enable request/ack + hardware reset; watchdog can disable board and requires a new enable transaction.
- **LiteX-CNC:** FPGA watchdog with `has_bitten`; modules such as PWM are explicitly disabled on bite/reset; documentation supports latching the fault into LinuxCNC supervisory state.

This convergence is strong enough to freeze one hardware-level requirement before selecting firmware:

> The 4000 controller core SHALL implement an FPGA-local command-freshness watchdog whose expiry independently removes normal machine-facing output authority, exposes a diagnostic fault state to LinuxCNC, and requires an explicit recovery/rearm path rather than automatically restoring stale output commands when communications return.

The exact register protocol, timeout representation and recovery handshake remain firmware-architecture decisions.

## Next decision work

The next comparison should move beyond watchdogs to:

1. Ethernet transaction model and servo-period latency/jitter;
2. encoder/stepgen/PWM module semantics and extensibility;
3. how difficult it is to add a custom proportional-current/valve module;
4. compatibility with existing LinuxCNC tooling/config expectations;
5. firmware/toolchain portability to an ECP5 board derived from Colorlight.

No lab is justified yet.
