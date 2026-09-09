# C06-032 Watchdog-Bearing `hm2_test` Load Preflight Reconciliation

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Workflow: `34289817535`
Job: `102273633349`
Curriculum head tested: `3847152bb8f6dad0a0a4612f2276aec448f12bf3`
Classification: **PREFLIGHT PASS — NON-AUTHORITATIVE**

## Evidence

The GitHub Actions job completed successfully. Repository-retained `exit_code.txt` is `0`.

The retained HAL output proves lab-only `test_pattern=15` registered one HostMot2 board and exported the real watchdog objects:

- `hm2_test.0.watchdog.has_bit` — bit I/O, initial FALSE
- `hm2_test.0.watchdog.timeout_ns` — u32 RW, initial 5,000,000 ns
- `hm2_test.0.read`
- `hm2_test.0.write`

The board registered 24 I/O pins and the run ended with `LOAD_PREFLIGHT_PASS` at `2026-09-08T23:18:37Z`.

The harness retained SHA-256 hashes for generic `hostmot2.c`, `tram.c`, `watchdog.c`, and `hostmot2-lowlevel.h` before and after the lab-only `hm2_test.c` patch and required byte-identical comparison. No generic HostMot2 behavior was changed.

## Interpretation boundary

This proves only fixture construction and HAL-object registration. It does **not** satisfy or score frozen C06-030 behavioral Gates A–H. In particular, it does not demonstrate packet-error escalation, `io_error`, watchdog bite, recovery, physical I/O behavior, machine safety, or realtime timing.

The preflight removes the remaining descriptor/topology blocker. The authoritative experiment may now use pattern 15, provided fault injection remains confined to the fake low-level driver and the frozen P0–P6 phases/Gates A–H are unchanged.
