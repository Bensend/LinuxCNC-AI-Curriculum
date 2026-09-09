# E20-003 — frozen adversarial exam grade

Date: 2026-09-09
Module: E20 — hm2_eth / HostMot2 watchdog recovery across versions
Exam: `evaluation/E20-adversarial-exam-draft.md`
Status: **PASS — 20/20**

The questions and scoring traps were frozen before authoritative E20-001 result review. The responses below were produced after that freeze without changing the exam.

## Q1 — Green transport is not machine authority — 2/2

The conclusion does **not** follow. A clean current hm2_eth transaction, cleared `io_error`, and cleared watchdog establish only selected transport/driver/watchdog conditions. They do not establish that machine state, homing/reference, commanded-vs-physical state, interlocks, or other post-fault assumptions remain valid. Motion reauthorization requires an independent machine-state revalidation witness plus an explicit reauthorization decision/request after transport/driver/board and physical-I/O authority conditions are good.

## Q2 — Saturating history versus current error — 2/2

Starting at level 0 with increment 2/decrement 1:

- failed transaction: current error true, level 2;
- next clean transaction: current error false, level 1.

The current-error bit describes the present observation; the accumulator describes retained error history. Therefore `packet-error == FALSE` cannot be interpreted as “the preceding window was fault-free,” nor as machine authorization.

## Q3 — Threshold edge — 2/2

Consecutive failures produce levels 2, 4, 6, 8, 10. With the frozen/source-informed model using `level >= limit`, the **fifth** failure reaches the limit and asserts exceeded/`io_error`. To distinguish `>= limit` from `> limit`, retain the exact source predicate for the pinned version and atomic evidence for the sample where level first equals the configured limit; a black-box observation only after overshoot would not establish the edge.

## Q4 — Watchdog reset proves output continuity — 2/2

The premise contains several unsupported jumps. Resetting/clearing a watchdog does not by itself prove that every physical output immediately resumes its old command, that this occurs in the same servo period, that the pre-fault command is still semantically safe, or that machine state remains valid. E20's source-grounded conclusion is narrower: HostMot2 watchdog action is an I/O-authority mechanism distinct from host transport error accounting, and internal module state may continue despite disconnected physical pins. E20 does not measure physical Mesa-output restoration timing or real-machine continuity, so a separate machine-state check remains necessary.

## Q5 — Version-sensitive recovery — 2/2

One generic description is unsafe because hm2_eth recovery machinery changed materially. The inspected 2015-era source used a fixed roughly 200 ms queued-read recovery loop and did not contain the later inspected packet-error accumulator/decay/`io_error` threshold state machine. Current v2.9.x source has the later soft-error accounting and recovery interaction. Before modifying either deployment, identify its exact LinuxCNC commit/release, inspect that lineage's `hm2_eth` transport/error paths and HostMot2/watchdog code, then verify the configured HAL/driver parameters rather than transplanting behavior from another release.

## Q6 — Failure-path call flow — 2/2

Conceptually:

1. **Transaction observation:** receive/confirmation logic determines whether the current hm2_eth transaction is good or bad.
2. **Driver error accounting/recovery:** a bad current transaction updates current/cumulative/error-level state; saturation can assert `io_error`; later clean traffic/explicit clear/driver reset may recover driver state according to the pinned version.
3. **Watchdog/physical-I/O authority:** HostMot2 watchdog state is separate; clean transport or driver recovery does not automatically prove physical output-pin authority, and watchdog recovery does not prove machine-state correctness.
4. **Machine revalidation:** the integrator must independently establish required machine state/interlocks/reference and explicitly reauthorize motion.

None of transport recovery → watchdog recovery, watchdog recovery → machine-state validity, or driver reset → motion authorization is proven as an automatic consequence of the preceding transition.

## Q7 — Atomic evidence attack — 2/2

Three independently timed userspace reads can be torn across servo cycles and can manufacture a combination of states that never coexisted. They are therefore insufficient for a same-cycle recovery/authorization claim. The minimum defensible arrangement is one realtime-ordered producer/sampler stream that captures the relevant inputs, driver/watchdog/revalidation states, authorization output, phase/sample tag, and timing/ordering provenance in the same cycle, with retained thread/topology evidence.

## Q8 — Recorder-health trap — 2/2

No. Producer overruns create unobserved intervals; contiguous retained row numbers do not prove that a brief authorization pulse was absent in those lost intervals. Negative same-cycle/absence-of-event claims require a producer-health record showing no relevant sample loss. Correct the recorder/sample-rate/harness until the authoritative run records zero producer overruns, then rerun; do not infer absence from a lossy trace.

## Q9 — bounded recovery interlock — 2/2

Minimum explicit state should include:

- current transport fault/good state;
- accumulated/escalated driver fault state such as error level/`io_error`;
- driver/board reset-required and recovery-complete state;
- watchdog/physical-I/O-authority state;
- independent machine-state-revalidated state;
- explicit reauthorization request;
- final motion-authorized latch/output.

The output fails closed on any new transport/escalated/watchdog/physical-authority fault. Recovery may clear transport/driver/board state without setting motion authorization. Authorization may transition true only after all lower-layer recovery predicates are good **and** independent machine revalidation is true **and** an explicit reauthorization request occurs. A new communication fault immediately clears authorization and invalidates any assumption that prior validation alone permits continued motion.

## Q10 — scope and safety boundary — 2/2

Supported claims include:

1. in the pinned current-lineage model, current packet status and accumulated error history are distinct;
2. the frozen numeric model reaches limit 10 on the fifth consecutive +2 error from zero and decays on clean cycles as declared;
3. driver/transport recovery can be represented separately from watchdog/physical-I/O authority and machine-state revalidation;
4. a bounded interlock can require explicit independent revalidation/reauthorization and revoke authorization on a fresh fault.

Not supported:

1. **functional safety:** E20 is not a safety integrity/certification or diagnostic-coverage demonstration;
2. **physical timing:** it does not establish exact Mesa physical-output disconnect/reconnect or stopping timing;
3. **universal versions:** it does not prove identical hm2_eth recovery semantics across LinuxCNC releases, hardware, or configurations;
4. **real machine behavior:** the software-only synthetic watchdog/authority fixture does not prove physical actuator state, Ethernet fault physics, or safe automatic restart on a real machine.

## Trap audit

The response rejects all frozen failure traps:

- no clean-transport ⇒ machine-valid inference;
- no watchdog-reset ⇒ restored-output-semantics inference;
- no v2.9.10 ⇒ all-version generalization;
- no workflow-status substitution for retained evidence;
- no torn userspace evidence for same-cycle claims;
- no absence-of-event claim with recorder overruns;
- no functional-safety claim;
- no collapse of driver/board reset into machine revalidation.

**Final score: 20/20 — PASS.**

## Correction requirement

None triggered. No conceptual or evidence trap was accepted. Proceed to E20 counterfactual/promotion review and the information-separated fresh-AI handoff packet. The current learner instance must not certify itself as the fresh evaluator.
