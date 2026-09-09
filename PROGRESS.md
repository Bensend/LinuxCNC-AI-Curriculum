# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05**, **C01**, **C02**, **C03**, **C04**, and **C05** are **GRADUATED at 1000 level**. Phase 10 remains active. Highest-priority unblocked work is **C06 — communication/watchdog fault handling**, state **CORRECTIONS / ESSENTIAL-NOW OBSERVATION-HARNESS DIAGNOSTIC**.

## Blind external-feedback state

- **BL-DEV-001:** VALID, 10/10, 92% confidence.
- **BL-DEV-002:** VALID, 9/10, 88% confidence.
- **BL-DEV-002-TRANSFER-01:** VALID, **10/10**, 95% confidence. Novel numeric same-mechanism retest correctly retrieved the pinned velocity-scaled-plus-`MIN_FERROR` floor and strict `>` comparison. This is transfer evidence, not delayed-retention evidence.

## C06 — communication/watchdog fault handling

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

Primary durable artifacts:

- `guides/C06-communication-watchdog-fault-research.md`
- `call-flows/C06-hostmot2-transport-watchdog-order.md`
- `guides/C06-function-symbol-guide.md`
- `guides/C06-transport-watchdog-injection-source-audit.md`
- `experiments/C06-030-transport-watchdog-fault-plan.md` — Gates A–H frozen before implementation/output inspection.
- `experiments/C06-030-fixture-construction-notes.md`
- `results/C06-036-clean-fixture-preflight-reconciliation.md`
- `results/C06-037-redesigned-authoritative-attempt-1-reconciliation.md`
- `results/C06-038-redesigned-authoritative-attempt-2-reconciliation.md`
- accepted clean fixture patch: `lab-results/run-34306117465-1/c06-clean-hm2test.patch`
- retired original failed wrapper lineage: `lab-jobs/033-c06-transport-watchdog-authoritative.sh`, `034-c06-transport-watchdog-authoritative-api-fix.sh`, `035-c06-transport-watchdog-authoritative-shmem-ref-fix.sh`.

Pinned-source findings remain unchanged:

- HostMot2 completes low-level receive before processing returned module/TRAM state; `io_error` causes early return from normal service.
- Successfully returned watchdog status is processed separately from low-level transport state.
- `watchdog.has_bit` is a real `HAL_IO` pin asserted from watchdog status and explicitly cleared by the user before generic recovery proceeds.
- Normal watchdog recovery is separately blocked while either `io_error` or `watchdog.has_bit` remains asserted.
- Pattern 15's watchdog status input is fake register `0x2004` bit 0; generic `watchdog.c` is not modified.
- The three-consecutive-failed-read C06 threshold is a deterministic test analogue of transport escalation, not a claim about a particular hm2_eth installation's packet-error-limit.
- At this pinned HAL revision, modern `hal_pin_new_*()` references are opaque handles and caller-provided handle storage must reside in HAL shared memory; the clean fixture uses one `hal_malloc()` structure.

Official documentation requires source reconciliation rather than literal merging: the current HostMot2 driver guide describes watchdog I/O-pin disconnection without saying all communication stops, while current `hostmot2(9)` man-page text still says all communication stops. The course therefore does not use `watchdog.has_bit` alone to infer a version-independent communication state. Historical/field discussion supports the causal possibility `transport/timing delay -> delayed watchdog service -> watchdog bite`, but causal linkage is not state identity.

Retained C06 boundary:

```text
packet/read error != watchdog bite
io-error != necessarily watchdog.has_bit
host receive timeout != proof FPGA watchdog status
watchdog bite != proof a version-independent communication state
watchdog bite != proof complete physical safe state
transport recovery != watchdog recovery
fault reset != proof plant is safe to resume
ordinary HostMot2/HAL fault handling != functional-safety certification
```

## C06 experiment history

### Original attempts 1–3 — HARNESS INVALID

Workflows `34298423081`, `34299295015`, and `34302451216` never reached authoritative behavior. The three-attempt rule retired their wrapper/source-rewriter lineage. See `results/C06-033...`, `C06-034...`, and `C06-035...`.

### Clean fixture preflight C06-036 — PREFLIGHT PASS / NON-AUTHORITATIVE

Workflow `34306117465`, job `102323048875`, artifact `10086772790`. The fresh pattern-15 fixture compiled and loaded, used `hal_malloc()`-backed reference storage, exposed all eight lab controls plus real generic `io_error`, `watchdog.has_bit`, and `timeout_ns`, and preserved production HostMot2 source hashes. No P0–P6 phase ran.

### Redesigned behavioral attempt 1, C06-037 — HARNESS INVALID before observation

Workflow `34306570963`, job `102324397610`, artifact `10086921222`. Provenance/topology reached Gate-A prerequisites, but userspace `halsampler` returned `hal_stream_attach: Invalid argument`; zero atomic rows were retained. Analyzer FAIL labels from the zero-row trace are not behavioral evidence.

### Redesigned behavioral attempt 2, C06-038 — HARNESS INVALID; simple race hypothesis falsified

Workflow `34306960420`, job `102325539319`, artifact `10087055819`. The harness waited until both HostMot2 objects and realtime sampler-owned `sampler.0.pin.9` / `.enable` existed, yet userspace `halsampler` still returned `hal_stream_attach: Invalid argument` and exited before P0 observation. Therefore C06-037 was not merely an early-attach race. Gates A–H remain **UNSCORED**.

## Exact next-work checkpoint

Do **not** launch another authoritative C06-030 run yet. First execute a **non-authoritative minimal sampler/stream diagnostic** against the same pinned LinuxCNC build and without `hm2_test` or C06 phases:

1. Load one realtime thread plus `sampler` with exact C06 `depth=30000 cfg=uubbbuuuub`; prove `sampler.0.pin.9`, `.enable`, `.sample-num`, `.curr-depth`, and `.overruns` exist.
2. Record RTAPI/HAL stream/shared-memory state before userspace attach; retain complete stdout/stderr.
3. Run `halsampler -c 0 -n 10 -t`. If it fails, run a diagnostic-only known-small configuration from pinned sampler documentation, e.g. `depth=100 cfg=uffb`, to separate C06 stream configuration/size from a general userspace attach/environment defect.
4. Trace the observed `-EINVAL` through pinned `sampler_usr.c -> hal_stream_attach() -> RTAPI shared-memory/stream validation`; identify the exact failing precondition before modifying the behavioral harness.
5. Only after a minimal sampler attach preflight passes may the accepted C06-036 fixture be combined again with frozen P0–P6/Gates A–H. Do not change threshold 3, fake watchdog status `0x2004:0`, production HostMot2 code, phase semantics, or gate thresholds.
6. Record C06-036/037/038 exact compute in `LAB_COMPUTE_LOG.md`.
7. After accepted behavioral evidence, continue the frozen C06 adversarial exam, fresh-AI novel-scenario handoff, corrections, and promotion/counterfactual audit.
