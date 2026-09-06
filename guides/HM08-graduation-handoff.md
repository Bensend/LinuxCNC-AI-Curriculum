# HM08 graduation handoff — HostMot2 watchdog

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Course level: LinuxCNC 1000 foundations

## Fresh-AI minimum model

A fresh engineer should treat the HostMot2 watchdog as a hardware-facing mechanism serviced through the normal HostMot2 I/O cycle, with host-side state and recovery logic in generic HostMot2. Do not treat it as a safety-certified subsystem.

On registration, the watchdog module exports `<board>.watchdog.has_bit` and RW `<board>.watchdog.timeout_ns`; the pinned default timeout is 5 ms. The normal write cycle prepares watchdog reset/pet value `0x5a000000` into the TRAM write region before the combined HostMot2 write. `hm2_watchdog_write()` is a separate post-write configuration/recovery function, not the ordinary pet operation.

After a successful read/TRAM completion, watchdog status processing may observe a bite. A bite sets user-visible `has_bit` and internal LLIO `needs_reset`. Recovery intentionally waits while `has_bit` remains asserted. Once the user clears the pin, pending reset state can drive `hm2_force_write()` to restore HostMot2 configuration/state. Reset flags clear only when recovery does not leave `io_error` asserted.

`io_error` is a major boundary: generic HostMot2 read/write/watchdog paths return early while it is asserted. How an Ethernet or other low-level transport detects and restores communication is not HM08's generic-watchdog responsibility.

A timeout shorter than 1.5× the HostMot2 write period produces a warning, not rejection. This is a configuration/reliability warning, not a guarantee of timing margin.

## Evidence boundary

SOURCE-CONFIRMED at the pinned revision: software call order, exported HAL state, reset/pet preparation, bite-to-state transition, user-clear recovery gating, force-write recovery and `io_error` boundary.

DOC-CONFIRMED: public 5 ms default/`has_bit` behavior and documented high-impedance HostMot2 I/O behavior after a watchdog bite.

NOT TEST-CONFIRMED here: physical bite latency, real FPGA timer progression, electrical output state, firmware-specific behavior, Ethernet-failure timing, or any safety-rated property.

The upstream `hm2_test` fixture is static and its write callback discards writes. A meaningful host-state experiment would require a mutable/capturing fake LLIO model, so that experiment is promoted to 2000 level rather than presented as 1000-level hardware evidence.

## Debugging reasoning

When a watchdog bite appears, do not immediately blame realtime latency. Check timeout/write-period margin, realtime stalls, transport errors/loss, NIC/network behavior for Ethernet boards, firmware/hardware faults and whether `io_error` is also asserted. Community reports are useful leads, not diagnoses.

## Promoted work

- mutable fake-LLIO production host-state experiment — 2000 / MEDIUM;
- transport-specific `io_error` recovery — E03/E06/E07 or 2000 / HIGH;
- physical bite timing/electrical behavior — representative hardware commissioning / CRITICAL;
- safety architecture/hazard analysis — advanced safety / CRITICAL.

## Graduation decision

**GRADUATED at 1000 level.** Remaining uncertainty does not invalidate the foundation architecture or downstream encoder/PWM study because all physical/safety claims remain explicitly bounded and promoted.

Next critical-path module: **IO01 — Encoder path**.
