# C06 — Communication / Watchdog Fault Handling — 1000-level Adversarial Exam and Corrections

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Evidence available to the learner: C06 research guide, function/symbol guide, call-flow guide, injection-source audit, frozen C06-030 plan, and accepted C06-046 experiment reconciliation. The exam is an internal module adversarial test, not a blind external-feedback-bank challenge.

## Questions

### Q1 — Misleading premise / state identity
A technician says: "The Ethernet read timed out, so the FPGA watchdog definitely bit. Clear `watchdog.has_bit` and continue." Evaluate every part of that statement. Identify the distinct state variables/evidence involved and the minimum recovery/safety conclusions that may and may not be drawn.

### Q2 — Failure-path call flow
At the pinned revision, trace one servo-cycle path in which `receive_queued_reads()` fails and later transport escalation asserts `io_error`. State which generic HostMot2 processing does *not* occur in that cycle, what happens to watchdog-status processing, and why a failed read is not independent evidence of a watchdog bite.

### Q3 — Independent watchdog event
Assume transport is healthy and a valid returned watchdog status register has bit 0 set. Trace the relevant generic HostMot2 state changes through `hm2_watchdog_process_tram_read()` and the later recovery boundary. What must be true before `hm2_force_write()` recovery is attempted?

### Q4 — Version-sensitive documentation conflict
One current official HostMot2 driver guide says a watchdog bite disconnects I/O pins from module instances and leaves module state running. The current `hostmot2(9)` man page additionally says all board communication stops. How should a 1000-level engineer reason about the conflict when the pinned implementation can successfully process watchdog status and has a force-write recovery path? Give a version/firmware-safe diagnostic rule.

### Q5 — Small diagnostic/configuration change
A real hm2_eth installation intermittently accumulates packet errors. An engineer proposes increasing `packet-error-limit` from 10 to 1000 so production will stop faulting. What would you inspect/change first, and what measurements/evidence would discriminate a genuinely too-aggressive receive timeout from actual network/realtime trouble? Explain why changing the limit alone is not an adequate fix.

### Q6 — Recovery and physical safety
The host network has recovered, `io_error` has been manually cleared, the watchdog status has been cleared, and HostMot2 service resumes. The commanded axis position equals reported feedback. Is automatic machine-cycle resume now justified? State what software evidence has been established and what physical/safety evidence is still missing.

## Committed answers

### A1
The premise conflates three different things. A host receive timeout/packet error is transport evidence; repeated transport errors may eventually cause the low-level driver to assert `io_error`; a HostMot2 watchdog bite is FPGA-side status that generic HostMot2 learns from a successfully returned watchdog-status word. Therefore `receive timeout -> watchdog definitely bit` is invalid. At the pinned revision C06-046 independently demonstrates `io_error=true` while `watchdog.has_bit=false`, and also the reverse state with healthy transport. Clearing `watchdog.has_bit` is only part of watchdog recovery; it does not clear an unrelated transport fault, and clearing either software-visible state does not prove the attached plant is physically safe to resume.

### A2
`hm2_read_request()` queues TRAM reads and the llio request unless `io_error` is already asserted. `hm2_read()` then finishes the queued read through `hm2_finish_read()`, which delegates to the llio receive path. If receive fails/returns the temporary failure path, normal returned-TRAM processing is skipped. On repeated hm2_eth communication errors, the driver's soft-error counter can reach `packet-error-limit` and assert llio `io_error`; generic HostMot2 then returns early rather than continuing normal low-level service. Because `hm2_watchdog_process_tram_read()` runs only after successful read completion and the `io_error` checks, a failed receive neither processes nor independently proves watchdog status.

### A3
With a successful transport read and watchdog status bit 0 set, `hm2_watchdog_process_tram_read()` can set the real HAL `watchdog.has_bit=true` and `llio->needs_reset=1`, provided it is not suppressed by current `io_error`/reset state. `hm2_watchdog_write()` will not perform ordinary recovery while `io_error` remains asserted or while the user-visible `has_bit` remains true. After the operator/control logic clears `has_bit`, pending reset state can drive `hm2_force_write()`; if `io_error` reappears, recovery aborts. A cleared watchdog pin alone is therefore not proof that reconfiguration completed.

### A4
The current official documentation surfaces conflict, so the extra phrase "all communication stops" must not be treated as a version-independent invariant. The safe diagnostic rule is: use the exact driver revision plus the actual board/firmware contract, and infer only what the observed evidence establishes. `watchdog.has_bit` proves that HostMot2 processed watchdog status in the tested contract; it does not by itself prove the current communication state on every board/version. Conversely, absence of a visible watchdog bit during broken transport does not prove the FPGA watchdog did not bite, because the returned status may be unobservable while reads fail.

### A5
First inspect the actual failure mechanism: `packet-error`, `packet-error-level`, `packet-read-timeout`, servo-thread period/latency, receive timing, interface/link counters where available, cabling/switch topology, and whether failures correlate with realtime overruns or network load. `packet-read-timeout` semantics matter because a too-short receive window can create false packet errors, while a too-long one can itself damage realtime behavior. Make a bounded change to timeout only with before/after traces and retain fault counts/timing. Raising `packet-error-limit` to 1000 mainly delays fault escalation and can hide persistent communication degradation; it does not repair packet delivery, realtime scheduling, or stale/late data.

### A6
Software evidence establishes only that the host transport path and HostMot2 watchdog/reset path have returned to an apparently serviceable state and that controller-visible command/feedback currently agree. It does not establish actuator position from independent metrology, output-stage state, hydraulic/pneumatic stored energy, contactor/drive state, mechanical integrity, guarding/interlock state, or safe restart sequencing. Automatic resume is therefore not justified from these signals alone. Physical-machine restart needs a separately engineered state-integrity/restart policy and applicable safety analysis; ordinary HostMot2/HAL fault recovery is not a safety-rated resume authorization.

## Scoring

Each question is scored 0–2 for source/mechanism accuracy and required boundary handling; 12/12 normalizes to 10/10.

| Question | Score | Reason |
|---|---:|---|
| Q1 | 2/2 | Correctly rejects transport/watchdog identity, names `io_error` and `watchdog.has_bit`, and preserves the safety boundary. |
| Q2 | 2/2 | Correctly traces failed receive -> skipped TRAM/module processing -> escalation and explains why watchdog status is not independently observable. |
| Q3 | 2/2 | Correctly traces status -> `has_bit`/`needs_reset` and the `io_error`/`has_bit` recovery guards. |
| Q4 | 2/2 | Treats the documentation wording as a real conflict and applies revision/firmware-scoped reasoning rather than silently merging it. |
| Q5 | 2/2 | Uses discriminating timing/network/realtime evidence and rejects masking by an inflated error limit. |
| Q6 | 2/2 | Separates software fault-state recovery from physical safe-resume evidence. |

**Result: 12/12 = 10/10 — PASS at 1000 level.**

## Adversarial checks against overclaiming

- The answer does **not** claim the fixture's three-failure threshold is the hm2_eth default; it remains a deterministic experiment analogue.
- The answer does **not** claim absence of `watchdog.has_bit` proves the FPGA did not bite during a communication outage.
- The answer does **not** universalize one documentation surface over another.
- The answer does **not** treat fault reset as a safety-rated restart permission.

## Corrections exposed by the exam

No central C06 mechanism was contradicted. One wording improvement is required in the main guide: explicitly state the asymmetric observability rule — `watchdog.has_bit=true` requires watchdog status to have been processed, but `watchdog.has_bit=false` during failed transport is not proof of no watchdog bite. This is a retrieval/diagnostic discriminator worth making explicit because Q4 depends on it.

## Evidence references

- `call-flows/C06-hostmot2-transport-watchdog-order.md`
- `guides/C06-communication-watchdog-fault-research.md`
- `guides/C06-transport-watchdog-injection-source-audit.md`
- `results/C06-046-authoritative-phase-first-reconciliation.md`
- LinuxCNC HostMot2 driver guide (current stable): https://linuxcnc.org/docs/stable/html/drivers/hostmot2.html
- LinuxCNC `hostmot2(9)` current man page: https://linuxcnc.org/docs/html/man/man9/hostmot2.9.html
