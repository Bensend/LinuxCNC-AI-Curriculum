# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05**, **C01**, **C02**, **C03**, **C04**, and **C05** are **GRADUATED at 1000 level**. Phase 10 remains active. Highest-priority unblocked work is **C06 — communication/watchdog fault handling**, state **CORRECTIONS / AUTHORITATIVE ATTEMPT 2 RUNNING**.

## Blind external-feedback state

- **BL-DEV-001:** VALID, 10/10, 92% confidence.
- **BL-DEV-002:** VALID, 9/10, 88% confidence.
- **BL-DEV-002-TRANSFER-01:** VALID, **10/10**, 95% confidence. Novel numeric same-mechanism retest correctly retrieved the pinned velocity-scaled-plus-`MIN_FERROR` floor and strict `>` comparison. This is transfer evidence, not delayed-retention evidence.

## C06 — communication/watchdog fault handling

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

Primary durable artifacts now include:

- `guides/C06-communication-watchdog-fault-research.md`
- `call-flows/C06-hostmot2-transport-watchdog-order.md`
- `guides/C06-transport-watchdog-injection-source-audit.md`
- `experiments/C06-030-transport-watchdog-fault-plan.md` — Gates A–H frozen before implementation/output inspection.
- `experiments/C06-030-fixture-construction-notes.md`
- `results/C06-032-watchdog-load-preflight-reconciliation.md`
- `results/C06-033-attempt-1-reconciliation.md`
- `lab-jobs/033-c06-transport-watchdog-authoritative.sh`
- `lab-jobs/034-c06-transport-watchdog-authoritative-api-fix.sh`

Pinned-source findings remain unchanged:

- HostMot2 completes low-level receive before processing returned module/TRAM state; `io_error` causes early return from normal service.
- Successfully returned watchdog status is processed separately from low-level transport state.
- `watchdog.has_bit` is a real `HAL_IO` pin asserted from watchdog status and explicitly cleared by the user before generic recovery proceeds.
- Normal watchdog recovery is separately blocked while either `io_error` or `watchdog.has_bit` remains asserted.
- The C06 fixture uses `hm2_test` because it is hardware-free and provides the narrow low-level read/write injection seam.
- Pattern 15's watchdog status input remains only fake register `0x2004` bit 0; generic `watchdog.c` remains byte-identical.
- The three-consecutive-failed-read C06 threshold is a deterministic test analogue of transport escalation, not a claim about a particular hm2_eth installation's packet-error-limit.

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

## C06-030 attempt 1 reconciliation

Workflow **`34298423081`**, job **`102299966701`**, artifact **`10084069925`**, head `77a274b1275cea22dd3f8df63c866b20ba4c4c40` is formally **HARNESS INVALID**.

The pinned tree built and retained its patch/logs, but `hm2_test` failed before P0 with `HAL: ERROR: data_ptr_addr not in shared memory`. The attempt-1 lab patch had incorrectly used deprecated `hal_bit_t *` / `hal_u32_t *` data-pointer exports and direct opaque `io_error` assignment against a revision whose current HAL API uses opaque `hal_bool_t` / `hal_uint_t` references and getter/setter functions. The compiler warnings independently exposed the same type mismatch. Since `hm2_test` never loaded, no sampler stream or behavioral phase existed and **Gates A–H remain UNSCORED**.

Actual attempt-1 job interval: `2026-09-09T01:15:05Z`–`01:18:16Z` (3.2 min). Add this HARNESS INVALID compute row to `LAB_COMPUTE_LOG.md` during the next ledger edit if not already present; do not omit failed compute from totals.

## C06-030 attempt 2

Source-grounded correction commit: **`994f452da0a599d13e4d41ce560c977dabe216be`**.

Attempt 2 changes only lab fixture access mechanics: C06 controls are converted to `hal_bool_t` / `hal_uint_t`, exported with `hal_pin_new_bool()` / `hal_pin_new_ui32()`, and read/written through `hal_get_*()` / `hal_set_*()`; the real generic I/O error is asserted with `hal_set_bool(*this->io_error, 1)`. Frozen P0–P6 semantics, threshold, fake watchdog-status address, prediction, source-integrity checks, and Gates A–H are unchanged.

Authoritative attempt-2 workflow **`34299295015`**, job **`102302593867`**, was in progress when this checkpoint was committed. Do not launch a duplicate.

## Exact next-work checkpoint

1. Inspect only workflow `34299295015`, job `102302593867`; retain final job times, artifact ID, complete patch, build/HAL logs, raw atomic sampler trace, controller log, and exit code.
2. If `hm2_test` still fails before P0, classify the precise load/topology problem as HARNESS INVALID and correct only that problem. Do not modify frozen Gates A–H or the transport-vs-watchdog prediction.
3. If the run reaches P0–P6, score the retained single realtime stream against the unchanged frozen gates. A valid gate violation is behavioral evidence and must not be retuned.
4. Pay particular attention to P6 ordinary user clearing of the real `HAL_IO watchdog.has_bit` while it is connected for atomic observation. Pinned `watchdog.c` requires user clear before generic recovery; if HAL signal topology prevents that command, treat it as an observation/control harness topology defect, not LinuxCNC behavioral evidence.
5. Once an attempt is accepted, update `LAB_COMPUTE_LOG.md` from actual job timestamps and then continue C06 adversarial exam, fresh-AI novel-scenario handoff, corrections, and promotion/counterfactual audit.
6. Keep BL-DEV-002 delayed retention separate from the successful 10/10 transfer retest.
