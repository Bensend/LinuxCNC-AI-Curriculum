# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05**, **C01**, **C02**, **C03**, **C04**, and **C05** are **GRADUATED at 1000 level**. Phase 10 remains active. Highest-priority unblocked work is **C06 — communication/watchdog fault handling**, state **EXPERIMENT / BEHAVIORAL HARNESS IMPLEMENTATION**.

## Blind external-feedback state

- **BL-DEV-001:** VALID, 10/10, 92% confidence.
- **BL-DEV-002:** VALID, 9/10, 88% confidence. Schedule a novel same-mechanism transfer challenge after roughly 3–8 subsequent lessons.

## C06 — communication/watchdog fault handling — EXPERIMENT / BEHAVIORAL HARNESS IMPLEMENTATION

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

Primary artifacts:
- `guides/C06-communication-watchdog-fault-research.md`
- `call-flows/C06-hostmot2-transport-watchdog-order.md`
- `guides/C06-transport-watchdog-injection-source-audit.md`
- `experiments/C06-030-transport-watchdog-fault-plan.md` — Gates A–H frozen before implementation/output inspection.
- `experiments/C06-030-fixture-construction-notes.md`
- `results/C06-032-watchdog-load-preflight-reconciliation.md`
- `lab-jobs/030-c06-watchdog-fixture-preflight.sh`
- `lab-jobs/031-c06-watchdog-layout-preflight.sh`
- `lab-jobs/032-c06-watchdog-load-preflight.sh`

Pinned-source findings established:

- `hostmot2.c:hm2_read_request()` queues TRAM reads; `hm2_read()` completes low-level receive before module TRAM processors. `io_error` causes early return.
- On successful read, watchdog TRAM status is processed before ordinary module processors.
- `hm2_write()` returns immediately on `io_error`; normal watchdog petting is prepared into write TRAM before the rest of the write service.
- `watchdog.c` asserts `watchdog.has_bit` only from a successfully received watchdog-status image; transport failure and watchdog bite are therefore distinct observations even though one can causally contribute to the other.
- Pinned `hm2_test.c` is explicitly hardware-free and its low-level `read()`/`write()` functions are the narrow deterministic injection seam.
- Accepted pattern 15 adds one IOPort plus one watchdog without changing existing upstream patterns. Watchdog base `0x2000` resolves timer `0x2000`, status `0x2004`, reset `0x2008`; the emulated bite input is status bit 0 at `0x2004`.
- `hm2_watchdog_process_tram_read()` returns while `io_error` or `needs_reset` is asserted; only a valid processed status image can raise the real `watchdog.has_bit` and set `needs_reset`.
- `hm2_watchdog_write()` separately withholds recovery while `io_error` or `has_bit` is asserted. Clearing `has_bit` with healthy transport permits force-write recovery and only then clears `needs_reset`.
- hm2_eth's `packet-error-level` accumulator belongs to the transport driver: detected cycle errors increase it, clean cycles decrease it, and reaching `packet-error-limit` raises `io-error`. The C06 fixture's small consecutive-failure threshold is a deterministic laboratory analogue, not a claim that its numeric threshold reproduces a particular Ethernet installation.

Retained C06 boundary:

```text
packet/read error != watchdog bite
io-error != necessarily watchdog.has_bit
host receive timeout != proof FPGA watchdog status
watchdog bite != proof complete physical safe state
transport recovery != watchdog recovery
fault reset != proof plant is safe to resume
ordinary HostMot2/HAL fault handling != functional-safety certification
```

## Current lab checkpoint

Watchdog load-preflight workflow `34289817535`, job `102273633349`, tested curriculum commit `3847152bb8f6dad0a0a4612f2276aec448f12bf3` and completed successfully. Retained exit code is 0. The HAL output proves `hm2_test.0.watchdog.has_bit`, `.timeout_ns`, `.read`, and `.write` exist and ends with `LOAD_PREFLIGHT_PASS`. This result is **non-authoritative** and must not be scored against C06-030 Gates A–H.

The descriptor/topology blocker is closed. No frozen C06-030 behavioral gate, threshold, or phase was changed.

## Exact next-work checkpoint

1. Implement the authoritative C06-030 harness by extending only lab-scoped `hm2_test.c` pattern-15 instrumentation. Add deterministic read-failure controls/counters and an emulated watchdog-status control at register `0x2004` bit 0. Do **not** alter generic `hostmot2.c`, `tram.c`, `watchdog.c`, or `hostmot2-lowlevel.h`.
2. P0–P6 must remain exactly as frozen. P2 communication escalation must be caused by consecutive injected failed low-level reads before the fixture asserts the real generic `llio->io_error`; P4 must set only the fake watchdog status bit and let a successful generic HostMot2 read assert the real `watchdog.has_bit`.
3. Use one atomic realtime sampler stream for phase, injection state, `io_error`, `watchdog.has_bit`, and normal-service activity evidence. Retain raw trace and complete fixture patch before analysis can exit; any overrun or missing decisive phase is HARNESS INVALID.
4. Execute exactly one authoritative run and reconcile unchanged Gates A–H. A valid behavioral failure is evidence and must not be retuned post hoc.
5. If accepted, perform the already-required adversarial exam, fresh-AI novel-scenario handoff, and promotion/counterfactual audit before C06 graduation.
