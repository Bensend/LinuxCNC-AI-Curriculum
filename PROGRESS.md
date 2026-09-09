# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05** and **C01–C08** are **GRADUATED at 1000 level**.

Phase 10 remains active. Highest-priority unblocked work is now **C09 — fresh-AI architecture handoff**, state **RESEARCH / HANDOFF DESIGN**.

## Blind external-feedback state

- **BL-DEV-001:** VALID, 10/10, 92% confidence.
- **BL-DEV-002:** VALID, 9/10, 88% confidence.
- **BL-DEV-002-TRANSFER-01:** VALID, 10/10, 95% confidence.
- Delayed retention remains separate; do not count the immediate transfer retest as delayed retention.
- Follow `evaluation/BLIND_FEEDBACK_PROTOCOL.md` cadence; C08 graduation alone does not require an unscheduled new blind challenge.

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

Accepted runtime model:

```text
request != achieved state
prerequisite restored != request retried
fault cleared != achieved state restored
achieved state restored != stale start authorization valid
Task/HAL logical recovery != physical safe restart
```

Primary evidence: `results/C07-049-authoritative-request-achieved-reconciliation.md`, adversarial exam, novel transfer, and graduation audit. Do not rerun absent a concrete defect.

## C08 — diagnostics and trace capture — GRADUATED at 1000 level

Pinned revision: `8bf4605ae81042248add031e94c77300406e0413`.

### Accepted evidence

Durable research/source/call-flow artifacts:

- `guides/C08-diagnostics-trace-research.md`
- `guides/C08-function-symbol-guide.md`
- `call-flows/C08-fault-to-retained-evidence.md`
- `guides/C08-hal-stream-doc-source-conflict.md`

Frozen experiment:

- `experiments/C08-050-diagnostic-discrimination-trace-plan.md`
- frozen-plan commit `5f1918372167337405f03373f6950602683cc89b`

Preflight:

- C08-051 workflow `34327928519`, job `102389431379`, artifact `10093374756`
- **PREFLIGHT PASS / NON-AUTHORITATIVE**
- main trace: 280 rows, producer overruns 0
- independent depth-4 FIFO: 31 producer overruns while retained tags `[0,1,2]` remained contiguous

Authoritative experiment:

- C08-052 workflow `34328731569`, job `102392025784`, artifact `10094968899`
- digest `sha256:9c53778cc743e4e393dea15145b0058cd7c35d49809d9fd3cb26187dd825f742`
- **PASS / TEST-CONFIRMED** under unchanged frozen Gates A–J
- 285 main realtime rows, main producer overruns 0, clean collector lifecycle
- Cause-B-only sampled row preceded Cause-B+symptom by one sampled boundary
- independent depth-4 FIFO accumulated 32 producer overruns while retained tags `[0,1,2]` were still contiguous

Evaluation:

- `evaluation/C08-adversarial-exam-draft.md` frozen before C08-052 result review
- `evaluation/C08-adversarial-exam-result.md`: **10/10 PASS**
- `evaluation/C08-fresh-ai-handoff.md`: **PASS**
- `evaluation/C08-promotion-audit.md`: **GRADUATED — 1000 level**

### Durable C08 teaching

```text
sequential point reads != one atomic realtime state
trace values require retained function-order provenance
HAL object existence != collector readiness/retention proof
consumer tag continuity != no attempted-sample loss at the pinned revision
producer-side overrun evidence is mandatory for a no-loss claim
same coarse symptom != same realtime causal history
HAL/Task/NML/process-log evidence != one atomic global clock unless explicitly synchronized
diagnostic evidence != physical plant truth != safety/restart authority
```

Current development `hal_stream(3)` prose conflicts with inspected source/sample-number behavior. The conflict is retained explicitly with a version boundary. C08-051 and C08-052 independently reproduced the pinned-source mechanism, so do not silently harmonize the manual and implementation.

Do not rerun C08-050 absent a newly discovered concrete defect.

## C09 — fresh-AI architecture handoff — RESEARCH / HANDOFF DESIGN

Purpose: test whether a fresh architecture/design handoff preserves the accumulated LinuxCNC boundaries from timing, HAL/NML/Task semantics, tandem-axis coordination, fault handling and diagnostic evidence without relying on private machine-specific design data.

### Exact next-work checkpoint

1. Read the accumulated 1000-level promotion artifacts for T02–T05 and C01–C08 and extract the minimum architecture invariants a fresh handoff must preserve.
2. Define a generic, public, non-machine-specific architecture scenario and freeze its evaluation rubric before generating/reviewing the fresh handoff answer.
3. Require the handoff to distinguish at minimum: realtime control vs userspace supervision; requested vs achieved state; feedback truth vs physical truth; transport/watchdog fault classes; diagnostic correlation vs atomic evidence; ordinary LinuxCNC control vs safety-rated authority.
4. Adversarially test the handoff for attractive architecture errors such as stale authorization reuse, single-sensor self-authentication, assuming network recovery restores watchdog/state, treating logging as safety evidence, or moving servo-critical logic into userspace.
5. Preserve a 2000/3000-level uncertainty queue rather than blocking 1000-level completion on hardware-specific validation that belongs to later work.
