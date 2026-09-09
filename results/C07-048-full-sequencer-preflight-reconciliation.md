# C07-048 — Full Sequencer / Ordering Preflight Reconciliation

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Classification: **NON-AUTHORITATIVE PREFLIGHT PASS**. This result validates the full C07-047 harness topology and observation ordering only. Frozen C07-047 Gates A–J remain **UNSCORED**.

## Run identity

- Curriculum commit: `69e2119afdb941e27a6bfa62fa2fae040a46f571`
- Workflow: `34318296679`
- Job: `102359108023`
- Artifact: `10090952801`
- Artifact digest: `sha256:c908c434cc440c717911a0aab6f01fa5b77ef845a064951eb2917806d5a998ad`
- Job start/end: `2026-09-09T06:15:57Z` / `2026-09-09T06:19:25Z`
- Exact job runtime: 208 s = **3.47 min**
- Inner lab exit: `0`

## Predeclared question

Before output inspection, the job declared that one fresh authorization should cause exactly one machine-ON request; a blocked request should not advance from request history; restoring the prerequisite should not implicitly retry; successful ON should be entered only after observed `halui.machine.is-on`; active status loss should revoke cycle permission; and post-fault recovery should require a fresh authorization.

The job explicitly declared itself non-authoritative and explicitly prohibited scoring the frozen C07-047 Gates A–J from this run.

## Observation integrity

The retained single userspace observer produced **109 monotonically ordered rows** with sequence number, monotonic `t0_ns`/`t1_ns`, sample span, sequencer tick, phase, state, authorization, internal and actual request, `motion.enable`, `motion.motion-enabled`, `halui.machine.is-on`, E-stop state, cycle permission, and event label.

Maximum one-row HAL-read span was **11.357478 ms**. The sequencer makes state transitions only from values acquired by that same observer/evaluation process, and emits a separate post-transition sample. Thus the decisive claim is not that all HAL objects were physically atomic at one nanosecond; it is that the policy's request/status/state ordering is explicitly serialized in one monotonic process and cannot be inferred from unrelated streams.

Every decisive phase marker was recorded before its mutation. This addresses the phase-label contamination problem previously exposed in C06.

## Preflight findings

The retained analyzer reported:

```text
PRECHECK observation-ordering=PASS
PRECHECK phase-before-mutation=PASS
PRECHECK one-authorization-one-request=PASS P2=1 P5=1 P8=1 P3/P4/P7=0
PRECHECK blocked-request-waits-for-achieved-state=PASS
PRECHECK restore-without-retry=PASS
PRECHECK explicit-retry-status-gating=PASS
PRECHECK active-status-loss-revokes-permission=PASS same-sequencer-tick
PRECHECK no-auto-restart=PASS
PRECHECK guarded-recovery=PASS
PRECHECK safety-boundary=ordinary state-integrity fixture only; NOT functional-safety evidence
PRECHECK RESULT=PASS; frozen C07-047 Gates A-J remain UNSCORED
```

Specific topology/policy behavior established for harness validity:

- P2 emitted exactly one actual `halui.machine.on` rising edge while `motion.enable=false`; the sequencer stayed out of `ON_CONFIRMED` because achieved status stayed false.
- P3 emitted no retry.
- P4 restored `motion.enable=true` but emitted no request and did not reach achieved ON.
- P5 used a fresh authorization and exactly one fresh request. `ON_CONFIRMED` / cycle permission followed observed `halui.machine.is-on=true`, not the request itself.
- P6 injected `motion.enable=false` only after publishing P6. Once the observer saw achieved machine-ON fall, the sequencer revoked cycle permission and entered recovery in that same sequencer evaluation tick.
- P7 restored the injected prerequisite without authorization. The sequencer could become `RECOVERY_WAIT_START`, but emitted no request and did not restore ON/cycle permission.
- P8 required a fresh post-fault authorization and a fresh request, then returned active only after achieved ON was observed.

## Provenance and safety boundary

Production HALUI/Task/Motion source was checked at the pinned revision and retained by SHA-256. The harness uses test configuration, a test-only userspace sequencer/observer, and direct control of the unlinked `motion.enable` HAL input; it does not modify production HALUI/Task/Motion source.

`cycle_permission` is only a laboratory policy state. This experiment does **not** prove functional safety, external E-stop behavior, drive/valve state, stored-energy state, physical-position validity, or restart-interlock compliance.

## Decision

**C07-048 PREFLIGHT PASS.** The full P0–P8 harness and ordering contract is sufficiently validated to permit one authoritative C07-047 execution against the already-frozen, unchanged Gates A–J. Do not alter phase semantics, authorization policy, request counts, safety boundary, or Gates A–J between this preflight and the authoritative run.
