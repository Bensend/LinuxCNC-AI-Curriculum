# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05**, **C01**, **C02**, **C03**, **C04**, **C05**, **C06**, and **C07** are **GRADUATED at 1000 level**.

Phase 10 remains active. Highest-priority unblocked work is **C08 — diagnostics and trace capture**, state **EXPERIMENT DESIGN** after completing the required documentation/community/source/evidence-matrix pass.

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

## C08 — diagnostics and trace capture — EXPERIMENT DESIGN

Pinned revision: `8bf4605ae81042248add031e94c77300406e0413`.

### Source/evidence pass completed

Durable artifacts:

- `guides/C08-diagnostics-trace-research.md`
- `guides/C08-function-symbol-guide.md`
- `call-flows/C08-fault-to-retained-evidence.md`

Resolved source conclusions:

- `sampler.N` captures configured HAL values during one realtime function invocation, but its causal meaning depends on function order relative to producers.
- `hal_stream` is a single-producer/single-consumer ring with usable capacity `depth-1`.
- successful `hal_stream_write()` assigns the record's sample number immediately before publishing the input index.
- a full-FIFO write increments producer overrun and returns `-ENOSPC` **without incrementing the successful-enqueue sample number**. Therefore contiguous `halsampler` sample tags alone cannot prove that no producer sample attempts were rejected.
- actual `hal_stream_attach()` validates stream magic and optional type compatibility; HAL object presence alone is not an attach-readiness oracle.
- Task `emcOperatorError()` emits a process-print descendant and separately writes typed `EMC_OPERATOR_ERROR` to the NML error channel; userspace `updateError()` consumes that channel.
- command completion/status (`echo_serial_number`, EXEC/DONE/ERROR) is a separate diagnostic surface from operator-error text.
- HAL realtime trace, Task status, NML error text, and process logs do not share a universal atomic timestamp. Cross-surface evidence must be described as correlated unless explicit synchronization is proven.

Safety boundary remains: diagnostic visibility is evidence, not a safety function and not physical-state proof.

### Exact next-work checkpoint

1. Freeze the C08 experiment plan **before implementation or output inspection**. Require two phases with the same coarse userspace symptom but different realtime cause ordering.
2. Frozen gates must require: realtime trace discriminates the causes; exact HAL function order is retained; producer overrun/full/depth validity is retained; consumer attach/exit/stderr/tags are retained; consumer continuity alone is explicitly rejected as a sufficient no-loss oracle; sequential `halcmd` reads are not treated as atomic evidence.
3. Include a small-depth overrun subtest or preflight that predicts: rejected full-FIFO writes raise producer overrun while the sequence numbers of successfully enqueued records can remain contiguous.
4. Implement only after freeze, then run a **non-authoritative topology/function-order/collector-readiness preflight**.
5. Only after that preflight passes, execute one authoritative run against unchanged gates, retain raw evidence, reconcile surprises, then proceed to adversarial exam/handoff/promotion audit.
