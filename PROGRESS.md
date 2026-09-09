# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05**, **C01**, **C02**, **C03**, **C04**, **C05**, **C06**, and **C07** are **GRADUATED at 1000 level**.

Phase 10 remains active. Highest-priority unblocked work is **C08 — diagnostics and trace capture**, state **EXPERIMENT / PREFLIGHT**.

## Blind external-feedback state

- **BL-DEV-001:** VALID, 10/10, 92% confidence.
- **BL-DEV-002:** VALID, 9/10, 88% confidence.
- **BL-DEV-002-TRANSFER-01:** VALID, 10/10, 95% confidence.
- Delayed retention remains separate; do not count the immediate transfer retest as delayed retention.
- A new blind challenge is not required merely because C08 is active; follow `evaluation/BLIND_FEEDBACK_PROTOCOL.md` cadence.

## C06 — communication/watchdog fault handling — GRADUATED

Pinned revision: `8bf4605ae81042248add031e94c77300406e0413`.

Accepted teaching:

```text
packet/read error != watchdog bite
io-error != necessarily watchdog.has_bit
watchdog.has_bit=false during broken transport != proof FPGA watchdog did not bite
transport recovery != watchdog recovery
fault reset != proof plant is physically safe to resume
ordinary HostMot2/HAL fault handling != functional-safety certification
```

Do not rerun C06-030 absent a newly discovered specific defect.

## C07 — state-machine sequencing — GRADUATED at 1000 level

Pinned revision: `8bf4605ae81042248add031e94c77300406e0413`.

Accepted runtime model:

```text
request != achieved state
prerequisite restored != request retried
fault cleared != achieved state restored
achieved state restored != stale start authorization valid
Task/HAL logical recovery != physical safe restart
```

Primary evidence: `results/C07-049-authoritative-request-achieved-reconciliation.md`, adversarial exam, novel transfer, and graduation audit. Do not rerun absent a concrete defect.

## C08 — diagnostics and trace capture — EXPERIMENT / PREFLIGHT

Pinned revision: `8bf4605ae81042248add031e94c77300406e0413`.

### Source/evidence pass completed

Durable artifacts:

- `guides/C08-diagnostics-trace-research.md`
- `guides/C08-function-symbol-guide.md`
- `call-flows/C08-fault-to-retained-evidence.md`
- `guides/C08-hal-stream-doc-source-conflict.md`
- frozen experiment `experiments/C08-050-diagnostic-discrimination-trace-plan.md`

Resolved source conclusions:

- `sampler.N` captures configured HAL values during one realtime function invocation, but its causal meaning depends on function order relative to producers.
- `hal_stream` is a single-producer/single-consumer ring with usable capacity `depth-1` at the pinned revision.
- successful `hal_stream_write()` assigns the record's sample number immediately before publishing the input index.
- a full-FIFO write increments producer overrun and returns `-ENOSPC` **without incrementing the successful-enqueue sample number** at both the pinned source and currently inspected development source. Therefore contiguous `halsampler` sample tags alone cannot prove that no producer sample attempts were rejected.
- current development `hal_stream(3)` documentation conflicts with that implementation by describing sample numbering as incrementing even on failed writes. This conflict is explicitly recorded and must not be silently harmonized; C08-050's tiny-FIFO subtest is the bounded independent discriminator.
- actual `hal_stream_attach()` validates stream magic and optional type compatibility; HAL object presence alone is not an attach-readiness oracle.
- Task `emcOperatorError()` emits a process-print descendant and separately writes typed `EMC_OPERATOR_ERROR` to the NML error channel; userspace `updateError()` consumes that channel.
- command completion/status (`echo_serial_number`, EXEC/DONE/ERROR) is a separate diagnostic surface from operator-error text.
- HAL realtime trace, Task status, NML error text, and process logs do not share a universal atomic timestamp. Cross-surface evidence must be described as correlated unless explicit synchronization is proven.

Safety boundary remains: diagnostic visibility is evidence, not a safety function and not physical-state proof.

### Frozen C08-050 experiment

The plan was committed **before implementation/output inspection**. It requires two phases with the same coarse `symptom=TRUE` userspace observation but different realtime cause ordering, an exact producer-before-sampler function-order record, actual collector attach/lifecycle evidence, producer-side no-loss evidence for the main trace, and a separate depth-4 overrun subtest proving why consumer continuity alone is insufficient.

Frozen Gates A–J must not be weakened after output is known. A run that fails provenance/topology/collector/main-trace validity is HARNESS INVALID rather than a LinuxCNC behavioral failure.

### Active laboratory checkpoint

- Non-authoritative implementation/topology/order/collector preflight: `lab-jobs/051-c08-diagnostic-trace-preflight.sh`
- Source commit launching it: `a5ca22019320b3bb7f04eebf8eca4230dcea37e3`
- Workflow run: `34327928519`
- Job: `102389431379`
- Status at this checkpoint: running; do not launch a duplicate while it remains active.

### Exact next-work checkpoint

1. Inspect only workflow `34327928519` / job `102389431379` and retain its actual artifact, logs, exact job runtime, evidence directory, collector stderr/exit, function-order record, main trace validity, and tiny-FIFO producer/consumer evidence.
2. If C08-051 passes its explicitly non-authoritative preflight contract, reconcile it durably and create a separate authoritative wrapper/run declared authoritative before execution, scoring unchanged C08-050 Gates A–J.
3. If C08-051 is harness-invalid, diagnose only the concrete harness defect; do not alter the frozen causal predictions or Gates A–J merely to fit output.
4. After authoritative evidence is accepted, continue C08 adversarial exam, corrections, fresh-AI novel-scenario handoff, higher-level promotion queue, counterfactual audit, and minimum-evidence graduation decision.
