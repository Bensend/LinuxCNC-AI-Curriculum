# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05 — custom operator interface patterns**, **C01 — simulated dual-actuator machine**, **C02 — independent feedback loops**, **C03 — explicit cross-coupling**, and **C04 — asymmetric actuator response** are **GRADUATED at 1000 level**.

Phase 10 remains active. The highest-priority unblocked module is **C05 — feedback sensor failure modes**, state **RESEARCH**.

## Blind development baseline — BL-DEV-001

The learner response was immutably committed in `evaluation/development/BL-DEV-001-precommit.md` before oracle inspection.

Result: **VALID, 10/10, 92% confidence**. Detailed evaluation is in `evaluation/development/BL-DEV-001-evaluation.md`; the score ledger is `evaluation/FEEDBACK_SCORE_LOG.md`.

A novel retention/development challenge should sample a different mechanism after roughly 10 subsequent lessons or about 24 hours, preserving the actual delay.

## C01 — simulated dual-actuator machine — GRADUATED 1000

Accepted C01-023: workflow `34209185893`, job `102005842122`, artifact `10049218375`, inner exit `0`, Gates A-H PASS. Realtime sampling observed 5 inches of movement on both duplicated Y commands with `max-abs-j1-j3-command-diff=0` and zero sampler overruns.

Retained boundary:

```text
same coordinated command
!= same observation instant
!= independent feedback agreement
!= same physical position
!= synchronized plant
!= safety-rated protection
```

## C02 — independent feedback loops — GRADUATED 1000

C02 established that two PID instances receiving a common command retain separate command/feedback/error/output state and can diverge under an asymmetric plant disturbance.

Retained boundary:

```text
shared command
!= shared feedback state
!= shared control error
!= synchronized physical plant
!= implicit cross-coupling
!= safety-rated disagreement protection
```

## C03 — explicit cross-coupling — GRADUATED 1000

Accepted C03-025: workflow `34228231147`, job `102067547546`, artifact `10056799485`, source commit `99f7c35ce3cfd23aa96c11f0168c798ff8607c7c`, inner exit `0`, Gates A-H PASS after two retained HARNESS INVALID phase-publication attempts.

The explicit `Kc=0.5` relative-feedback coupler reduced sustained deterministic simulated disagreement from `0.703374228 in` to `0.377045040 in` (about 46.4%); removing it raised disagreement to `0.738476396 in` (about 1.96x the coupled value).

Retained boundary:

```text
reduced simulated disagreement
!= proven physical alignment
!= proven stability across gains, delays, saturation, loads or faults
!= validated hydraulic/mechanical press-brake synchronization law
!= safety-rated anti-racking protection
```

## C04 — asymmetric actuator response — GRADUATED 1000

Pinned revision: `8bf4605ae81042248add031e94c77300406e0413`.

Primary guides/results:

- `guides/C04-asymmetric-actuator-response-research.md`
- `guides/C04-pid-saturation-transition-semantics.md`
- `results/C04-026-attempt-1-reconciliation.md`
- `results/C04-026-attempt-2-behavioral-reconciliation.md`
- `experiments/C04-027-source-corrected-recovery-plan.md`
- `results/C04-027-accepted.md`
- `evaluation/C04-adversarial-exam-result.md`
- `evaluation/C04-fresh-ai-handoff.md`
- `evaluation/C04-promotion-audit.md`

### C04-026 preserved falsification

C04-026 attempt 1 was HARNESS INVALID because Gate F paired PID-B saturation with the wrong output tuple field and the workflow artifact omitted the raw realtime trace. Two subsequent correction-wrapper jobs failed before LinuxCNC started; they provide no machine-behavior evidence. After the three-attempt investigation-control boundary, the harness was materially redesigned rather than patched again.

The valid C04-026 rerun was workflow `34243768815`, job `102120345513`, artifact `10063237523`, source `5f42434b2a67d79d8ea2ccaa9f17e902df8423e5`. It produced 14,262 realtime rows and passed Gates A-F/H, but **legitimately failed frozen Gate G**. Phase 3 sustained B-only saturation for 3,011 rows, yet after phase 4 changed B `maxoutput` directly from `1.0` to `0`, `pidB.saturated` remained true and `saturated-count` continued increasing even after A/B feedback converged.

Pinned `pid.c::calc_pid()` explains the result: an enabled PID updates/clears `limit_state` only inside the `if (maxoutput != 0.0)` output-limit block. A direct transition to zero skips that block, so a previously nonzero `limit_state` can persist and drive stale `saturated`/duration telemetry. This source structure is also present in current LinuxCNC master as inspected 2026-09-08. Current PID documentation describes zero as 'no limit' and `saturated` as current saturation, so the dynamic transition exposes a documentation/telemetry-semantic mismatch that must be taught explicitly.

### Accepted C04-027 source-corrected recovery

C04-027 was frozen before implementation after the C04-026 falsification. It retained phases 1-3 and every phase-3 authority value/threshold, changing only phase-4 recovery to a deliberately huge finite `maxoutput=1000.0` sentinel so pinned `calc_pid()` would execute the explicit `limit_state=0` branch. Gate G additionally required proof that the sentinel never bound.

Authoritative workflow `34244865738`, job `102124147558`, artifact `10063683101`, source commit `4a9412e0d83dedfcd32bd6543cd0cf00231d40bf`, inner exit `0`, Gates A-H PASS.

Key results:

- 14,268 realtime rows;
- `S1=0`, `S2=0.230824132`, `S3=1.477344334`, `S4=0`;
- 3,018 consecutive phase-3 rows with B saturated at `+1.0` while A remained unsaturated;
- phase-4 final-500 B unsaturated fraction `1.0`;
- phase-4 final-500 B saturated-count-zero fraction `1.0`;
- phase-4 sentinel nonbinding fraction `1.0`;
- raw trace SHA-256 `2e4a924e10766a2cc8b4c5834cb89a94c5c423968a2965f1104889e597edec73`.

The frozen C04 adversarial exam scored **10/10** and the fresh-AI combined sensor-scale + PID-saturation handoff passed. Promotion/counterfactual audit therefore graduates C04 at 1000 level.

Retained boundaries:

```text
corrected command separation
!= available local actuator authority
!= achieved plant response
!= feedback convergence
```

```text
pid.saturated telemetry
must be interpreted with current maxoutput + enable + transition history + pinned source
!= self-authenticating proof of present physical saturation
```

```text
PID software saturation
!= physical actuator stall
!= drive current limit
!= hydraulic pressure/flow limit
!= sensor fault diagnosis
!= safety-rated fault decision
```

## C05 — feedback sensor failure modes — RESEARCH

Highest-priority unblocked next module. C05 inherits the C04 distinction between measured disagreement and plant truth and must deliberately exercise at least freeze, scale and jump/offset feedback faults with independent observation evidence.

### Exact next-work checkpoint

1. Read current LinuxCNC encoder/feedback documentation and pinned source for the minimum deterministic simulated sensor path suitable for injecting freeze, scale and jump/offset faults without conflating them with plant response.
2. Trace `true toy plant state -> sensor transformation -> PID/cross-coupler measured feedback -> resulting control effort` at function/thread order level.
3. Research community reports where encoder scale, frozen counts, wiring/noise or discontinuity produced misleading servo/gantry symptoms; classify them COMMUNITY-REPORTED, not source truth.
4. Define what independent evidence can distinguish 'measured disagreement' from 'known physical disagreement'. Do not let C05 prematurely choose final stop/fault behavior.
5. Freeze the first C05 experiment before implementation. It should preserve raw same-cycle true-plant-state and transformed-feedback evidence so a sensor fault cannot masquerade as a plant-authority result.

## Laboratory compute / timing notes

`LAB_COMPUTE_LOG.md` contains authoritative compute accounting. Invalid runs are retained rather than hidden. C03 and C04 authoritative jobs still require a complete compute backfill if not already present; include pre-LinuxCNC harness failures rather than hiding their cost.
