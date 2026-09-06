# E01 graduation handoff — hm2_eth architecture and board discovery

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Status: **GRADUATED — 1000-level E01 scope**

## What a fresh AI must know

`hm2_eth` is not generic HostMot2. It is a low-level Ethernet transport implementation that constructs an `hm2_lowlevel_io_t` contract. Generic HostMot2 begins above that boundary at `hm2_register()`, where firmware identity, IDROM/module interpretation, TRAM/HAL construction and module semantics are handled.

Startup ownership is: `rtapi_app_main()` establishes the HAL component and per-board networking context; `init_board()` chooses/installs the network backend; probing communicates with and identifies the configured board, supplies connector/FPGA metadata, installs concrete LLIO callbacks/capabilities, and only then hands the LLIO object to `hm2_register()`.

The driver contains distinct direct and cyclic transaction paths. Direct initialization reads use a fixed non-realtime receive timeout. Cyclic operation is designed around queued/batched I/O and has a period-related receive deadline plus transport-integrity counters. Those deeper mechanics are useful context here but are owned for full treatment by E03-E07.

A correctly sized cyclic UDP response is not automatically current: source also uses echoed read/write counters. Communication failures feed a soft-error policy and eventually LLIO `io_error`. These are SOURCE-CONFIRMED implementation facts at the pinned revision, not physical-network qualification.

## Discovery/registration boundary

A useful debugging cut is the `hm2_register()` handoff. Failure while opening/probing/identifying/filling LLIO is transport/discovery-side. Failure inside generic registration after a valid LLIO handoff is HostMot2 registration/module interpretation. Later cyclic communication faults after successful registration should not be mislabeled as board-discovery or IDROM failures without evidence.

## Evidence and experiment boundary

Documentation, community leads, and pinned source were traced through the complete E01 architecture/discovery path. The adversarial exam passed.

No suitable upstream no-hardware fixture was found for production `hm2_eth` packet state-machine execution. The key helpers are static and coupled to board/socket/HAL state. A copied-function mock would test a model rather than production code and would falsely inflate evidence. Physical board discovery is unavailable in the cloud lab. Therefore E01 graduates without a new runtime promotion; the missing production-path fault-injection experiment is explicitly promoted to E03/E06/2000-level work and is not represented as TEST-CONFIRMED.

## Safety boundary

Do not infer physical latency, jitter, deterministic deadline performance, watchdog effectiveness, safe-output state, or functional-safety properties from E01. `hm2_eth_reset()`'s watchdog-write mechanism is source behavior only; HM08 and later safety modules own the consequential behavior.

## Promotion queue

- Production-path hm2_eth fault-injection fixture for stale/duplicate/wrong-size/lost packets: **E03/E06 or 2000 / HIGH**.
- Exact POSIX socket/interface/routing/firewall setup: **E02 / MEDIUM**.
- Servo-period packet timing and deadline interaction: **E05 / HIGH**.
- Recovery after accumulated `io_error`: **E07 / HIGH**.
- EVL/current-master versus pinned backend behavior: **2000 / HIGH**.
- Physical NIC latency/jitter/IRQ tuning: **commissioning / CRITICAL**.
- Physical watchdog and safe-output behavior: **HM08 + safety / CRITICAL**.

## Next critical-path module

**HM08 — HostMot2 watchdog.** Begin from generic HostMot2 watchdog registration and HAL-visible watchdog parameters/pins, then trace pet/write/bite/error/reset behavior and its relationship to LLIO `io_error`. Preserve the distinction between watchdog mechanism and safety-rated machine behavior.