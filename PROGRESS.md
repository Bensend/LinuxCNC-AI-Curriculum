# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05**, **C01**, **C02**, **C03**, **C04**, and **C05** are **GRADUATED at 1000 level**. Phase 10 remains active. Highest-priority unblocked work is **C06 — communication/watchdog fault handling**, state **EXPERIMENT DESIGN / FIXTURE PREFLIGHT**.

## Blind external-feedback state

- **BL-DEV-001:** VALID, 10/10, 92% confidence.
- **BL-DEV-002:** VALID, 9/10, 88% confidence. Schedule a novel same-mechanism transfer challenge after roughly 3–8 subsequent lessons.

## C06 — communication/watchdog fault handling — EXPERIMENT DESIGN / FIXTURE PREFLIGHT

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

Primary artifacts:
- `guides/C06-communication-watchdog-fault-research.md`
- `call-flows/C06-hostmot2-transport-watchdog-order.md`
- `experiments/C06-030-transport-watchdog-fault-plan.md` — Gates A–H frozen before implementation/output inspection.
- `experiments/C06-030-fixture-construction-notes.md`
- `lab-jobs/030-c06-watchdog-fixture-preflight.sh` — non-authoritative construction preflight; does not exercise or score frozen behavioral gates.

Pinned-source findings established:

- `hostmot2.c:hm2_read_request()` queues TRAM reads; `hm2_read()` completes low-level receive before module TRAM processors. `io_error` causes early return.
- On successful read, watchdog TRAM status is processed before ordinary module processors.
- `hm2_write()` returns immediately on `io_error`; normal watchdog petting is prepared into write TRAM before the rest of the write service.
- `watchdog.c` asserts `watchdog.has_bit` only from a successfully received watchdog-status image; transport failure and watchdog bite are therefore distinct observations even though one can causally contribute to the other.
- Pinned `hm2_test.c` is explicitly hardware-free. Source inspection found patterns 0–14 and no explicit `HM2_GTAG_WATCHDOG`, so a new isolated lab-only pattern is expected rather than modifying an upstream pattern.

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

Construction-preflight commit `83eeaada78060c9d643e50bc4eb6347bd040109a` launched workflow `34279261683`, job `102239797346`. This run is deliberately non-authoritative: it retains the exact pinned `hm2_test` final pattern, HostMot2 Module Descriptor decode, watchdog parser consistency contract, source hashes, and watchdog gtag evidence needed to construct the fixture without guessing descriptor packing. It must not be scored against C06-030 Gates A–H.

## Exact next-work checkpoint

1. Inspect only construction-preflight workflow `34279261683` / job `102239797346` when complete. Extract the exact three-dword Module Descriptor packing and the final valid `hm2_test` IDROM/MD layout from its retained output.
2. Construct a **new** lab-only watchdog-bearing `hm2_test` pattern and deterministic fixture controls. Do not modify existing patterns. Generic pinned `hostmot2.c`, `tram.c`, `watchdog.c`, and `hostmot2-lowlevel.h` must remain byte-identical.
3. Run a non-behavioral load preflight proving `hm2_test.0.watchdog.has_bit` and `.timeout_ns` exist before launching the authoritative behavioral run.
4. Implement frozen C06-030 phases P0–P6 without changing Gates A–H. Preserve complete fixture patch and raw observation before analysis can exit.
5. Reconcile exactly one authoritative behavioral run. A valid behavioral failure is evidence; do not retune after output.
6. If accepted, perform the required adversarial exam, fresh-AI handoff, and promotion/counterfactual audit before C06 graduation.
