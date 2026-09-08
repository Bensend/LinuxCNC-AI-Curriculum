# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05**, **C01**, **C02**, **C03**, **C04**, and **C05** are **GRADUATED at 1000 level**. Phase 10 remains active. Highest-priority unblocked work is **C06 — communication/watchdog fault handling**, state **EXPERIMENT DESIGN**.

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

## C06 — communication/watchdog fault handling — EXPERIMENT DESIGN

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

Primary artifacts:
- `guides/C06-communication-watchdog-fault-research.md`
- `call-flows/C06-hostmot2-transport-watchdog-order.md`
- `experiments/C06-030-transport-watchdog-fault-plan.md` — Gates A–H frozen before implementation/output inspection.

Pinned-source findings now established:

- `hostmot2.c:hm2_read_request()` queues TRAM reads, then optional low-level queued send; `hm2_read()` finishes the low-level receive before any module TRAM processor is called. A temporary `-EAGAIN` receive skips module processing for that cycle; `io_error` causes early return.
- On a successful read, watchdog TRAM status is processed first by `hm2_watchdog_process_tram_read()` before GPIO/encoder/stepgen and other module processors.
- `hostmot2.c:hm2_write()` returns immediately on `io_error`, prepares watchdog TRAM first, queues the entire write TRAM, then calls module-specific writes including `hm2_watchdog_write()`, then finishes queued writes.
- `hm2_watchdog_prepare_tram_write()` writes `0x5a000000` into the watchdog reset/pet TRAM register every serviced write cycle. Thus ordinary petting is carried by the normal write TRAM; `hm2_watchdog_write()` handles enable/timeout and reset/reconfiguration state.
- `watchdog.c` sets `watchdog.has_bit=true` and `llio->needs_reset=1` only after a successful received TRAM image exposes status bit 0. It deliberately does not process watchdog status while `io_error` is asserted.
- `hostmot2-lowlevel.h` defines `io_error` as low-level-driver-owned failure state that HostMot2 honors by stopping llio calls until the user clears it; `needs_reset`/`needs_soft_reset` carry later reinitialization requirements.
- A deterministic hardware-free seam exists in pinned `hm2_test.c`: it is explicitly a pretend HostMot2 llio with in-memory register data and no special hardware requirement. C06 will use an auditable lab-only extension of this fixture rather than host-network timing disruption.

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

## Exact next-work checkpoint

1. Implement frozen `C06-030` without changing Gates A–H or its phase semantics. Modify only the hardware-free `hm2_test` fixture/instrumentation needed to inject deterministic read failure and watchdog status; generic pinned `hostmot2.c`, `tram.c`, and `watchdog.c` must remain byte-identical.
2. Before the authoritative run, verify that the chosen `hm2_test` pattern exposes a valid watchdog Module Descriptor. If it does not, add only the minimum retained fixture register/descriptor image needed to instantiate one watchdog and document that construction as harness code.
3. Preserve the complete patch and raw observation trace before any analyzer can exit. Sample enough state to prove P0 baseline, P1 transient read failure, P2 escalated `io_error`, P3 transport recovery, P4/P5 independent watchdog bite/hold, and P6 watchdog recovery.
4. Reconcile exactly one authoritative run against unchanged Gates A–H. A valid behavioral failure is evidence; do not retune thresholds or phase definitions after observing output.
5. If C06-030 is accepted, perform the already-required adversarial exam, fresh-AI handoff, and counterfactual promotion audit before graduation.
6. Backfill C05-029 attempts 8–11 lab compute and queued C03/C04 historical compute when it does not interrupt the critical path.
