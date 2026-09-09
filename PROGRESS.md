# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05**, **C01**, **C02**, **C03**, **C04**, and **C05** are **GRADUATED at 1000 level**. Phase 10 remains active. Highest-priority unblocked work is **C06 — communication/watchdog fault handling**, state **CORRECTIONS / ESSENTIAL-NOW HARNESS REDESIGN**.

## Blind external-feedback state

- **BL-DEV-001:** VALID, 10/10, 92% confidence.
- **BL-DEV-002:** VALID, 9/10, 88% confidence.
- **BL-DEV-002-TRANSFER-01:** VALID, **10/10**, 95% confidence. Novel numeric same-mechanism retest correctly retrieved the pinned velocity-scaled-plus-`MIN_FERROR` floor and strict `>` comparison. This is transfer evidence, not delayed-retention evidence.

## C06 — communication/watchdog fault handling

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

Primary durable artifacts:

- `guides/C06-communication-watchdog-fault-research.md`
- `call-flows/C06-hostmot2-transport-watchdog-order.md`
- `guides/C06-transport-watchdog-injection-source-audit.md`
- `experiments/C06-030-transport-watchdog-fault-plan.md` — Gates A–H frozen before implementation/output inspection.
- `experiments/C06-030-fixture-construction-notes.md`
- `results/C06-032-watchdog-load-preflight-reconciliation.md`
- `results/C06-033-attempt-1-reconciliation.md`
- `results/C06-034-attempt-2-reconciliation.md`
- `results/C06-035-attempt-3-reconciliation-and-redesign-decision.md`
- retired failed lineage: `lab-jobs/033-c06-transport-watchdog-authoritative.sh`, `034-c06-transport-watchdog-authoritative-api-fix.sh`, `035-c06-transport-watchdog-authoritative-shmem-ref-fix.sh`.

Pinned-source findings remain unchanged:

- HostMot2 completes low-level receive before processing returned module/TRAM state; `io_error` causes early return from normal service.
- Successfully returned watchdog status is processed separately from low-level transport state.
- `watchdog.has_bit` is a real `HAL_IO` pin asserted from watchdog status and explicitly cleared by the user before generic recovery proceeds.
- Normal watchdog recovery is separately blocked while either `io_error` or `watchdog.has_bit` remains asserted.
- Pattern 15's intended watchdog status input is fake register `0x2004` bit 0; generic `watchdog.c` is not to be modified.
- The three-consecutive-failed-read C06 threshold is a deterministic test analogue of transport escalation, not a claim about a particular hm2_eth installation's packet-error-limit.
- At this pinned HAL revision, modern `hal_pin_new_*()` references are opaque handles, but the caller-provided handle-storage address must still reside in HAL shared memory. `hal_malloc()` is the supported allocator for pin/parameter storage.

Official documentation continues to distinguish hm2_eth packet-error escalation from HostMot2 watchdog state: packet errors increase `packet-error-level` toward low-level `io-error`, while the firmware watchdog is serviced by normal HostMot2 write activity and changes board I/O connectivity when it bites. Historical developer discussion additionally warns that a communication delay may *cause* a watchdog bite by delaying service; causal linkage is not state identity.

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

## C06-030 authoritative attempt history

### Attempt 1 — HARNESS INVALID before P0

Workflow `34298423081`, job `102299966701`, artifact `10084069925`. Legacy/direct HAL pointer export was incompatible with the pinned opaque-reference HAL API. No behavioral phase ran; Gates A–H UNSCORED.

### Attempt 2 — HARNESS INVALID before P0

Workflow `34299295015`, job `102302593867`, artifact `10084380381`, curriculum head `994f452da0a599d13e4d41ce560c977dabe216be`. The outer workflow completed its evidence-capture path, but retained inner evidence exited `24`: `HAL: ERROR: data_ptr_addr not in shared memory`. The API correction moved to opaque references/getters/setters but left the reference slots as file-scope C storage rather than HAL shared memory. No P0-P6 phase ran; Gates A–H UNSCORED.

### Attempt 3 — HARNESS INVALID before LinuxCNC execution

Workflow `34302451216`, job `102312063998`, artifact `10085401335`, curriculum head `99f8890e466706fc182dfd7b79f2929ca9680b2f`. The wrapper intended to move the eight reference slots into a `hal_malloc()` structure, but nested Python triple-quoted source rewriting produced a `SyntaxError`; inner exit `1`. LinuxCNC did not run; Gates A–H remain UNSCORED.

### Three-attempt decision

**ESSENTIAL NOW / REDESIGN.** The communication-vs-watchdog distinction is central to C06 and later failure-engineering work, so behavioral verification is not dropped or promoted. The `033 -> 034 -> 035` wrapper lineage is retired. Do not launch a fourth incremental patch of that family.

## Exact next-work checkpoint

1. Build a **clean standalone construction fixture** from the pinned `hm2_test` source/pattern-15 requirements; do not generate it by text-wrapping any of attempts 1–3.
2. Put all lab-only opaque HAL reference slots in one `hal_malloc()`-allocated structure and keep value access through `hal_get_*()` / `hal_set_*()`.
3. Run a **non-authoritative compile/load preflight only**. Prove the lab injection/observation pins, real generic `io_error`, and real watchdog `has_bit`/`timeout_ns` objects exist; retain patch/source hashes and production HostMot2 SHA checks. Do not score P0-P6 in this preflight.
4. If and only if the clean preflight passes, freeze that exact fixture patch/source hash and execute one new authoritative C06-030 behavioral run against the already-frozen P0-P6 and Gates A–H. A valid gate violation is behavioral evidence and must not be retuned.
5. Backfill C06 attempts 1–3 into `LAB_COMPUTE_LOG.md` from authoritative job timestamps; failed compute counts.
6. After accepted behavioral evidence, continue the frozen C06 adversarial exam, fresh-AI novel-scenario handoff, corrections, and promotion/counterfactual audit.
