# HM08 adversarial exam answer key and correction pass

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

1. **Premise false.** Ordinary cyclic pet data is prepared by `hm2_watchdog_prepare_tram_write()` as `0x5a000000` and transmitted with the combined HostMot2 TRAM write. `hm2_watchdog_write()` follows the generic write and handles enable/timeout changes/recovery.
2. On a healthy completed read, a watchdog status bit causes production watchdog processing to set HAL `has_bit` and LLIO `needs_reset`. The internal latch prevents a user-clearable HAL value from racing away the need for recovery.
3. Production intentionally waits while `has_bit` is true. The user clears that indication; the internal reset latch remains the authoritative recovery requirement.
4. After `has_bit` is clear, pending `needs_reset`/`needs_soft_reset` causes watchdog recovery to invoke generic `hm2_force_write()`. Reset flags are cleared only after that path returns without `io_error` becoming asserted.
5. Generic HostMot2 read/write/watchdog work returns early while `io_error` is asserted. Transport-specific loss/re-establishment belongs with the low-level driver, especially E03/E06/E07 for Ethernet.
6. The pinned source warns for a timeout below 1.5× the write period; it does not reject the value. The margin warning means configuration can make nuisance bites more likely when servicing is delayed; it is not a realtime guarantee.
7. The default is a requested software/FPGA timeout parameter, not proof of detection latency for every failure mode. Communication may fail differently; servicing and scheduling have jitter; firmware/board behavior is separate; output electrical behavior is hardware-specific; "safe" requires hazard analysis; LinuxCNC/HostMot2 watchdog behavior is not safety certification.
8. Existing `hm2_test` reads an unchanging compiled-in register image and discards all writes. Recovery requires mutable injected status plus observable production writes/state. Adding only a static bit cannot demonstrate the transition/recovery protocol.
9. A valid advanced fixture would keep production `watchdog.c`, add a test-only mutable LLIO register map, expose a deterministic test control for setting the watchdog status register, and capture addresses/data written by production HostMot2. It could prove host-side detection, HAL/internal state changes and emitted recovery/configuration writes. It must not emulate/claim real timer expiry, FPGA reaction latency, physical pin state, Ethernet failure behavior or safety.
10. The example demonstrates intended integration of the watchdog fault indication into ordinary machine fault/estop logic. It does not establish a safety-rated estop function or prove a hazard-safe physical state.

## Correction pass

No core call-flow correction was required. The exam exposed one wording discipline worth preserving: describe `0x5a000000` as the value prepared for the ordinary TRAM watchdog reset/pet write; do not casually call `hm2_watchdog_write()` the cyclic pet function. The fake-fixture experiment is promoted rather than used to imply hardware behavior.

Result: **PASS for HM08 1000-level reasoning**, subject to fresh-AI handoff and progress graduation update.
