# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05**, **C01**, **C02**, **C03**, **C04**, and **C05** are **GRADUATED at 1000 level**. Phase 10 remains active. Highest-priority unblocked work is **C06 — communication/watchdog fault handling**, state **EXPERIMENT DESIGN / FIXTURE CONSTRUCTION**.

## Blind external-feedback state

- **BL-DEV-001:** VALID, 10/10, 92% confidence.
- **BL-DEV-002:** VALID, 9/10, 88% confidence. Schedule a novel same-mechanism transfer challenge after roughly 3–8 subsequent lessons.

## C06 — communication/watchdog fault handling — EXPERIMENT DESIGN / FIXTURE CONSTRUCTION

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

Primary artifacts:
- `guides/C06-communication-watchdog-fault-research.md`
- `call-flows/C06-hostmot2-transport-watchdog-order.md`
- `experiments/C06-030-transport-watchdog-fault-plan.md` — Gates A–H frozen before implementation/output inspection.
- `experiments/C06-030-fixture-construction-notes.md`
- `lab-jobs/030-c06-watchdog-fixture-preflight.sh` — completed non-authoritative construction preflight.
- `lab-jobs/031-c06-watchdog-layout-preflight.sh` — follow-on non-authoritative layout preflight; resolves the final valid upstream test pattern and IDROM/MD field layout needed for the isolated watchdog pattern.

Pinned-source findings established:

- `hostmot2.c:hm2_read_request()` queues TRAM reads; `hm2_read()` completes low-level receive before module TRAM processors. `io_error` causes early return.
- On successful read, watchdog TRAM status is processed before ordinary module processors.
- `hm2_write()` returns immediately on `io_error`; normal watchdog petting is prepared into write TRAM before the rest of the write service.
- `watchdog.c` asserts `watchdog.has_bit` only from a successfully received watchdog-status image; transport failure and watchdog bite are therefore distinct observations even though one can causally contribute to the other.
- Pinned `hm2_test.c` is explicitly hardware-free. Construction preflight proved patterns 0–14 and no explicit `HM2_GTAG_WATCHDOG` descriptor.
- Construction preflight retained exact descriptor decoding: dword 0 packs `gtag[7:0]`, `version[15:8]`, `clock_tag[23:16]`, `instances[31:24]`; dword 1 packs `base_address[15:0]`, `num_registers[23:16]`, register-stride selector `[27:24]`, instance-stride selector `[31:28]`; dword 2 is `multiple_registers`.
- `hm2_watchdog_parse_md()` requires consistency shape `(version=0, num_registers=3, register_width=4, multiple_registers=0)` and uses one watchdog instance. Watchdog gtag is 2.

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

Construction-preflight workflow `34279261683` / artifact `10076964852` completed successfully and is non-authoritative. It retained pinned hashes, descriptor packing, watchdog parser contract, watchdog gtag, and confirmed no existing watchdog descriptor. Follow-on layout-preflight commit `e50c45212ae88a8270b903b82628f91469ac14ae` launched workflow `34284571175`; it was queued at the checkpoint and must not be scored against C06-030 Gates A–H.

## Exact next-work checkpoint

1. Inspect only layout-preflight workflow `34284571175` when complete. Extract patterns 11–13 and the exact valid IDROM module-descriptor offset/clock/stride fields.
2. Construct a **new** lab-only watchdog-bearing `hm2_test` pattern and deterministic fixture controls. Do not modify existing patterns. Generic pinned `hostmot2.c`, `tram.c`, `watchdog.c`, and `hostmot2-lowlevel.h` must remain byte-identical.
3. Run a non-behavioral load preflight proving `hm2_test.0.watchdog.has_bit` and `.timeout_ns` exist before launching the authoritative behavioral run.
4. Implement frozen C06-030 phases P0–P6 without changing Gates A–H. Preserve complete fixture patch and raw observation before analysis can exit.
5. Reconcile exactly one authoritative behavioral run. A valid behavioral failure is evidence; do not retune after output.
6. If accepted, perform the required adversarial exam, fresh-AI handoff, and promotion/counterfactual audit before C06 graduation.
