# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05**, **C01**, **C02**, **C03**, **C04**, and **C05** are **GRADUATED at 1000 level**. Phase 10 remains active. Highest-priority unblocked work is **C06 — communication/watchdog fault handling**, state **RESEARCH / SOURCE**.

C05 graduation is supported by accepted TEST-CONFIRMED C05-028 frozen-feedback evidence, accepted TEST-CONFIRMED C05-029 wrong-scale/jump evidence, the already-recorded **10/10** adversarial exam, and the novel-scenario handoff plus promotion/counterfactual audit in `handoffs/C05-novel-feedback-truth-transfer.md`.

## Blind external-feedback state

- **BL-DEV-001:** VALID, 10/10, 92% confidence.
- **BL-DEV-002:** VALID, 9/10, 88% confidence. Schedule a novel same-mechanism transfer challenge after roughly 3–8 subsequent lessons.

## C05 — GRADUATED at 1000 level

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

Retained boundary:

```text
fixture true state != physical metrology truth
frozen measured feedback != proven frozen actuator
wrong measured scale != proven physical scale change
measurement jump != proven physical position jump
controller reaction to corrupted measurement != proof plant needed correction
ordinary HAL/PID logic != safety-rated sensor-fault handling
```

C05-028 accepted attempt 2: workflow `34247942092`, job `102134660105`, 5194 realtime samples, zero overruns, frozen measured-B span 0 while toy true-B moved 13.881798 in, max true/measured separation 13.994518 in, frozen Gates A–H PASS.

C05-029 accepted attempt 11: workflow `34263426729`, job `102186773618`, artifact `10070970999`, result `results/C05-029-attempt-11-accepted.md`. The single-FIFO atomic observer retained 6,568 strictly ordered 20-field realtime samples with zero overruns. The exact pinned checkout was used; the sole observer-only precision patch changed `HAL_REAL` text serialization from `%f` to `%.17g`. Frozen gates/behavioral parameters were unchanged. Scale transform residual was exactly 0; jump residual was approximately `4.44e-16`, below the frozen `1e-9` threshold. Gates A–H PASS.

Attempts 1–10 retain their original harness-invalid classifications; none are converted retroactively into behavioral evidence.

Fresh transfer and counterfactual audit: `handoffs/C05-novel-feedback-truth-transfer.md` — PASS. Promoted physical sensor signatures, fault discrimination, and safety-rated redundancy details cannot overturn the demonstrated 1000-level measurement-versus-plant-truth distinction, and the safety boundary remains explicit.

## C06 — communication/watchdog fault handling — RESEARCH / SOURCE

Primary new artifact: `guides/C06-communication-watchdog-fault-research.md`.

Pinned-source findings so far:

- `hm2_eth.c` treats packet/read communication health separately from the HostMot2 FPGA watchdog. Its queued receive path derives `packet-read-timeout`, performs receive, records soft communication errors, and escalates the communication error counter until `io_error` is asserted at `packet-error-limit`.
- Pinned defaults observed: `packet-read-timeout=80` (percentage-of-thread semantics) and `packet-error-limit=10`.
- `watchdog.c` exports the watchdog's independent `has_bit`/`timeout_ns` state. Default timeout is 5 ms. Watchdog processing and write/recovery return while low-level `io_error` is active; a watchdog status bite sets `has_bit` and `needs_reset`.
- `hm2_watchdog_write()` enables/maintains the watchdog during normal service and uses `hm2_force_write()` when reset state is pending; it warns when watchdog timeout is dangerously short relative to the service period.

Retained C06 boundary:

```text
packet error != permanent io-error
io-error != necessarily watchdog bite
host receive timeout != proof FPGA watchdog status
watchdog bite != proof complete physical safe state
fault reset != proof plant is safe to resume
ordinary HostMot2/HAL fault handling != functional-safety certification
```

## Exact next-work checkpoint

1. Continue pinned-source tracing from HostMot2 generic `read`/`write` through low-level hm2_eth queued read/write operations and place watchdog prepare/process calls in exact TRAM/servo-cycle order.
2. Trace every relevant state transition among `packet-error`, `packet-error-level`, `packet-error-exceeded`, `io_error`, `needs_reset`, `needs_soft_reset`, and `watchdog.has_bit`, including user-reset/recovery branches.
3. Inventory existing LinuxCNC tests or mock low-level interfaces that can inject deterministic communication failures without physical Ethernet hardware. Prefer an existing seam over timing-dependent host-network disruption.
4. Perform one prediction check before viewing its independent confirming evidence.
5. Freeze C06's first behavioral experiment before implementation. It must distinguish at minimum a transient packet/read error, escalated communication `io_error`, watchdog-bite state, and recovery; do not weaken thresholds after observing results.
6. Backfill C05-029 attempts 8–11 lab compute and queued C03/C04 historical compute when it does not interrupt the critical path.
