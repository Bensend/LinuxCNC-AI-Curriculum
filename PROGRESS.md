# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05**, **C01**, **C02**, **C03**, **C04**, and **C05** are **GRADUATED at 1000 level**. Phase 10 remains active. Highest-priority unblocked work is **C06 — communication/watchdog fault handling**, state **CORRECTIONS / ESSENTIAL-NOW PHASE-PUBLICATION REDESIGN**.

## Blind external-feedback state

- **BL-DEV-001:** VALID, 10/10, 92% confidence.
- **BL-DEV-002:** VALID, 9/10, 88% confidence.
- **BL-DEV-002-TRANSFER-01:** VALID, **10/10**, 95% confidence. Novel numeric same-mechanism retest correctly retrieved the pinned velocity-scaled-plus-`MIN_FERROR` floor and strict `>` comparison. This is transfer evidence, not delayed-retention evidence.
- No new blind challenge is due merely because C06 remains in corrections; delayed retention remains distinct and should not contaminate the active C06 evidence repair.

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
- `results/C06-039-sampler-stream-attach-diagnostic-reconciliation.md`
- `results/C06-041-043-readiness-diagnostic-reconciliation.md`
- `results/C06-044-phase-publication-reconciliation.md`
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
- Pinned realtime `sampler` creates the stream before declaring the component ready; pinned `halsampler` attaches to `SAMPLER_SHMEM_KEY + channel` with `typestring=NULL`. `hal_stream_attach()` validates stream magic and remaps the full size from the retained stream header; an explicit caller type-string mismatch is not possible in this `halsampler` path.
- A successful filtered `halcmd show ...` command is not, by itself, proof that the requested HAL object exists; C06 readiness must match actual names in complete HAL listings and confirm the `halrun` process remains alive.

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

Workflows `34298423081`, `34299295015`, and `34302451216` never reached authoritative behavior. The three-attempt rule retired their wrapper/source-rewriter lineage.

### Clean fixture preflight C06-036 — PREFLIGHT PASS / NON-AUTHORITATIVE

Workflow `34306117465`, job `102323048875`, artifact `10086772790`. The fresh pattern-15 fixture compiled and loaded, used `hal_malloc()`-backed reference storage, exposed all eight lab controls plus real generic `io_error`, `watchdog.has_bit`, and `timeout_ns`, and preserved production HostMot2 source hashes.

### Redesigned behavioral attempts C06-037 / C06-038 — HARNESS INVALID before observation

Workflows `34306570963` and `34306960420` produced zero authoritative sampler rows because the userspace reader attempted to attach before a valid stream was actually proven. C06-038's earlier statement that the simple race hypothesis was falsified is **retracted**: its readiness test used `halcmd show ...` exit status rather than proving a matching object existed.

### C06-039 — exact sampler configuration PASS / NON-AUTHORITATIVE

Workflow `34310141125`, job `102334943692`, artifact `10088152204`. Exact `depth=30000 cfg=uubbbuuuub` attached in isolation and retained all requested rows.

### C06-041 / C06-043 — readiness root cause confirmed

C06-041 workflow `34310509116`, job `102336017000`, artifact `10088240415` reproduced an apparent full-P0 attach failure, but retained snapshots showed the readiness predicate could pass before sampler objects/FIFO existed. C06-043 workflow `34311305551`, job `102338355587`, artifact `10088513656` required actual object-name matches plus live `halrun`; it passed with `ready=1`, `halsampler_rc=0`, 20 rows, zero overruns. Startup/readiness plumbing is therefore resolved.

### C06-044 — HARNESS INVALID after valid observation; phase-publication defect

Workflow `34311582310`, job `102339170004`, artifact `10088629138` retained **2,967 strictly ordered single-stream rows**. Its analyzer printed A–C/E–H PASS and D FAIL, but raw-trace reconciliation shows the run is **HARNESS INVALID**, not a behavioral falsification. The controller wrote the P1 fault command before the P1 phase label; the one failed read occurred in the interval between those asynchronous commands, so the first P1 row already has `read_fail=1`. Similar early transitions are visible at P2, P4, and P6. The frozen experiment explicitly classifies phase-publication defects as HARNESS INVALID.

The redesigned behavioral lineage has now had three nonaccepted attempts (037, 038, 044). Per the three-attempt rule the decision is **ESSENTIAL NOW / REDESIGN**, not blind retry.

### C06-045 — phase-first publication preflight / NON-AUTHORITATIVE

`lab-jobs/045-c06-phase-publication-preflight.sh` was committed before inspecting its output. It changes only observation protocol: publish each phase first, retain realtime rows in that phase, then apply the unchanged fault/recovery mutation. It directly verifies that P1/P2/P3/P4/P6 decisive mutations occur after their intended phase labels. Frozen threshold `3`, watchdog register `0x2004:0`, production HostMot2 logic, phase meanings, and Gates A–H are unchanged. Workflow `34312449313` is the only active C06-045 run at this checkpoint.

## Exact next-work checkpoint

1. Reconcile only C06-045 workflow **`34312449313`**. Retain its artifact, raw trace, publication proof, executed harness, and diff.
2. C06-045 is **not authoritative behavioral evidence**, even if its embedded unchanged gate analyzer happens to pass. Accept it only if every direct publication check proves that the decisive mutation occurs after at least one realtime sample carrying the intended phase label.
3. If C06-045 passes, construct one redesigned authoritative C06-030 run using that exact phase-first publication protocol and the already-proven C06-043 readiness barrier. Do not change threshold `3`, watchdog status `0x2004:0`, P0–P6 semantics, production HostMot2 code, or frozen Gates A–H.
4. If C06-045 fails, inspect the raw transition rows and redesign the publication barrier; do not launch another authoritative run.
5. After an accepted authoritative behavioral run, score the already-frozen C06 adversarial exam, fresh-AI novel-scenario handoff, corrections, and promotion/counterfactual audit before graduation.
