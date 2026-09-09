# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05**, **C01**, **C02**, **C03**, **C04**, and **C05** are **GRADUATED at 1000 level**. Phase 10 remains active. Highest-priority unblocked work is **C06 — communication/watchdog fault handling**, state **EXAM / HANDOFF / PROMOTION AUDIT**. The required independent behavioral experiment is now accepted.

## Blind external-feedback state

- **BL-DEV-001:** VALID, 10/10, 92% confidence.
- **BL-DEV-002:** VALID, 9/10, 88% confidence.
- **BL-DEV-002-TRANSFER-01:** VALID, **10/10**, 95% confidence. Novel numeric same-mechanism retest correctly retrieved the pinned velocity-scaled-plus-`MIN_FERROR` floor and strict `>` comparison. This is transfer evidence, not delayed-retention evidence.
- No new blind challenge is due merely because C06 reached its internal exam stage; delayed retention remains distinct.

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
- `results/C06-045-phase-publication-preflight-attempt-1.md`
- `results/C06-046-authoritative-phase-first-reconciliation.md` — **accepted TEST-CONFIRMED evidence**.
- accepted clean fixture patch: `lab-results/run-34306117465-1/c06-clean-hm2test.patch`.

Pinned-source findings remain unchanged:

- HostMot2 completes low-level receive before processing returned module/TRAM state; `io_error` causes early return from normal service.
- Successfully returned watchdog status is processed separately from low-level transport state.
- `watchdog.has_bit` is a real `HAL_IO` pin asserted from watchdog status and explicitly cleared by the user before generic recovery proceeds.
- Normal watchdog recovery is separately blocked while either `io_error` or `watchdog.has_bit` remains asserted.
- Pattern 15's watchdog status input is fake register `0x2004` bit 0; generic `watchdog.c` is not modified.
- The three-consecutive-failed-read C06 threshold is a deterministic test analogue of transport escalation, not a claim about a particular hm2_eth installation's packet-error-limit.
- At this pinned HAL revision, modern `hal_pin_new_*()` references are opaque handles and caller-provided handle storage must reside in HAL shared memory; the clean fixture uses one `hal_malloc()` structure.
- Pinned realtime `sampler` creates the stream before declaring the component ready; pinned `halsampler` attaches to `SAMPLER_SHMEM_KEY + channel` with `typestring=NULL`.
- `src/hal/utils/halcmd_commands.cc::do_show_cmd()` returns success after a recognized `show pin` dispatch regardless of whether the pattern matched any object. Therefore a filtered `halcmd show ...` exit code is not an object-existence proof; C06 readiness must match actual object names and confirm live `halrun` state.

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

Workflow `34306117465`, job `102323048875`, artifact `10086772790`. The fresh pattern-15 fixture compiled and loaded, exposed the required controls plus real generic `io_error`, `watchdog.has_bit`, and `timeout_ns`, and preserved production HostMot2 source hashes.

### Redesigned behavioral attempts C06-037 / C06-038 — HARNESS INVALID before observation

Workflows `34306570963` and `34306960420` produced zero authoritative sampler rows because the userspace reader attached before a valid stream was actually proven. C06-038's earlier statement that the simple race hypothesis was falsified is **retracted**.

### C06-039 — exact sampler configuration PASS / NON-AUTHORITATIVE

Workflow `34310141125`, job `102334943692`, artifact `10088152204`. Exact `depth=30000 cfg=uubbbuuuub` attached in isolation and retained all requested rows.

### C06-041 / C06-043 — readiness root cause confirmed

C06-041 workflow `34310509116`, job `102336017000`, artifact `10088240415` exposed the faulty readiness predicate. C06-043 workflow `34311305551`, job `102338355587`, artifact `10088513656` required actual object-name matches plus live `halrun`; it passed with `ready=1`, `halsampler_rc=0`, 20 rows, zero overruns. The root cause is both TEST-CONFIRMED and SOURCE-CONFIRMED through pinned `do_show_cmd()` behavior.

### C06-044 — HARNESS INVALID after valid observation; phase-publication defect

Workflow `34311582310`, job `102339170004`, artifact `10088629138` retained **2,967 strictly ordered single-stream rows**. Raw reconciliation showed the P1 fault mutation could be consumed before the P1 label became visible, with the same ordering defect visible at additional transitions. The frozen plan explicitly classifies phase-publication defects as HARNESS INVALID. This did not falsify the prediction.

The redesigned behavioral lineage reached three nonaccepted attempts (037, 038, 044), triggering **ESSENTIAL NOW / REDESIGN** rather than blind retry.

### C06-045 — phase-first publication preflight PASS / NON-AUTHORITATIVE

Attempt 1 workflow `34312449313` was PREFLIGHT INVALID before LinuxCNC because the editor targeted the 044 wrapper rather than its retained expanded harness. Corrected workflow `34312552726`, artifact `10088950336`, passed with **2,981** ordered rows and direct P1/P2/P3/P4/P6 publication-after-label PASS checks. Its embedded Gate A–H analyzer also passed but was not promoted because the run was predeclared non-authoritative.

### C06-046 — AUTHORITATIVE PASS / ACCEPTED

Workflow **`34312802937`**, job **`102342754452`**, artifact **`10089037385`**, authoritative runtime **3.4 min**. The preflight→authoritative diff changes exactly two label lines and no behavior. The run retained **2,976 strictly ordered single-stream rows**, empty sampler stderr, exact pinned-source/fixture provenance, and **frozen Gates A–H all PASS**.

Accepted TEST-CONFIRMED result at the pinned revision/fixture:

```text
communication failure state != watchdog-bite state
io_error can assert while watchdog.has_bit remains false
watchdog.has_bit can assert with healthy transport and io_error=false
transport recovery != watchdog recovery
fault reset != proof a physical machine is safe to resume
```

## Exact next-work checkpoint

1. Do **not** rerun C06-030. Its authoritative behavioral evidence is accepted.
2. Construct and score the C06 1000-level adversarial exam from the durable research/source/call-flow/experiment artifacts. It must include a misleading premise, version-sensitive documentation conflict, failure-path trace, and a small diagnostic/configuration change task.
3. Run a fresh-AI novel-scenario handoff that is not answered verbatim in the guide; require it to distinguish transport `io_error`, valid watchdog-status evidence, recovery state, and physical-safety uncertainty.
4. Incorporate any exam/handoff corrections into the guide before graduation.
5. Populate the higher-level promotion/uncertainty queue, including version-sensitive watchdog communication semantics and hardware/firmware-specific timing/physical validation that cannot be established by the current fixture.
6. Apply the counterfactual promotion test and minimum graduation evidence floor. If all central claims remain supported, graduate C06 at 1000 level and advance the dependency graph.
