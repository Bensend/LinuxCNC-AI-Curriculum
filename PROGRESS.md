# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05**, **C01**, **C02**, **C03**, **C04**, and **C05** are **GRADUATED at 1000 level**. Phase 10 remains active. Highest-priority unblocked work is **C06 — communication/watchdog fault handling**, state **EXPERIMENT / AUTHORITATIVE RUN IN PROGRESS**.

## Blind external-feedback state

- **BL-DEV-001:** VALID, 10/10, 92% confidence.
- **BL-DEV-002:** VALID, 9/10, 88% confidence.
- **BL-DEV-002-TRANSFER-01:** VALID, 10/10, 95% confidence. Novel numeric same-mechanism retest correctly retrieved the pinned velocity-scaled-plus-`MIN_FERROR` floor and strict `>` comparison. Delayed retention remains separate.

## C06 — communication/watchdog fault handling — EXPERIMENT / AUTHORITATIVE RUN IN PROGRESS

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
- `lab-jobs/033-c06-transport-watchdog-authoritative.sh` — authoritative P0–P6 implementation committed as `77a274b1275cea22dd3f8df63c866b20ba4c4c40`.

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

Authoritative C06-030 workflow **`34298423081`**, job **`102299966701`**, was launched automatically from commit `77a274b1275cea22dd3f8df63c866b20ba4c4c40` and was still executing when this checkpoint was written. Do not launch a duplicate while it is running.

The authoritative harness extends only lab-scoped `hm2_test.c` pattern-15 behavior. It SHA-checks generic `hostmot2.c`, `tram.c`, `watchdog.c`, and `hostmot2-lowlevel.h`; uses a deterministic three-consecutive-failed-read threshold before the low-level fixture asserts the real generic `io_error`; injects watchdog bite only through fake register `0x2004` bit 0; observes state in one atomic realtime sampler stream; and retains the complete patch/raw trace before gate analysis.

Frozen C06-030 Gates A–H and P0–P6 semantics remain unchanged.

## Exact next-work checkpoint

1. Inspect only authoritative workflow `34298423081`, job `102299966701`; preserve final job runtime, artifact ID, readable result, raw trace, controller log, full fixture patch, build log, and final exit code.
2. Reconcile the raw single-stream evidence against **unchanged** C06-030 Gates A–H. Any build, HAL topology, sampler, retention, or phase-publication defect is HARNESS INVALID; a valid frozen-gate violation is behavioral evidence and must not be retuned post hoc.
3. If the run is accepted, update `LAB_COMPUTE_LOG.md` from actual job timestamps, then perform the required C06 adversarial exam, fresh-AI novel-scenario handoff, correction pass, and promotion/counterfactual audit before graduation.
4. If the run is harness-invalid, diagnose only the actual harness defect and preserve the frozen behavior. Do not weaken gates or change the prediction to fit output.
5. Keep BL-DEV-002 delayed retention separate from the successful transfer retest; do not repeat the transfer surface as retention evidence.
