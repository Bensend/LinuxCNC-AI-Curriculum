# S05 graduation audit and fresh-AI handoff

- Module: S05 — disagreement/redundancy monitoring patterns
- Course level: 1000
- Status: **GRADUATED**
- LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
- Prerequisite: S04 graduated
- Unlocks: S06 — fault injection framework

## What a fresh AI must know

A LinuxCNC redundancy monitor is not defined merely by the number of channels. The architecture must state the failure domain, numerical comparison rule, freshness/alignment assumptions, persistence rule, retained diagnostics, and the limits of any vote.

Representative numeric path:

`sensor/publication A + sensor/publication B -> sum2(A-B) -> wcomp(-T,+T) -> or2(under,over) -> timedelay -> diagnostic/ordinary response`

Representative boolean voting path:

`raw in1,in2,in3 -> maj3 -> functional vote`

with raw inputs and dissent diagnostics retained in parallel.

At the pinned revision, `wcomp` uses inclusive comparisons at the boundaries (`<= min`, `>= max`) and therefore reports healthy only for the strict interior. `maj3` is plain 2-of-3 arithmetic and carries no truth provenance, dissent identity, freshness, or common-cause knowledge. `timedelay.out` is the reliable persistence-state output for this lesson.

## Evidence chain

### Documentation

Current official LinuxCNC HAL documentation identifies `sum2`, `wcomp`, `maj3`, and `timedelay` as stock HAL components and describes HAL components as functions that must be loaded and added to realtime threads. This supports the public component vocabulary and the requirement that execution order is explicitly configured.

### Community knowledge

Community discussions were used as failure-domain and terminology leads: LinuxCNC users combine multiple feedback observations for different purposes, and discussions repeatedly distinguish ordinary controller logic from independent safety hardware/architecture. These observations were not treated as proof of safety integrity or diagnostic coverage.

### Source

Pinned source analysis established:

- `sum2`: affine sum, usable as `A-B`;
- `wcomp`: strict healthy interior with equality classified `under`/`over`;
- `maj3`: two-or-more true vote;
- `timedelay`: realtime-period accumulation while requested input differs from current output;
- function order is configured by HAL thread order rather than inferred from signal topology.

### Independent experiment

S05-015 workflow `34137614386` passed with exit code 0 and artifact digest `sha256:c97840e998d47702ef8672f9209a76b6f05fa276f03513c2f4eae48bf02ccb2a`. All predeclared Gates A–J passed without changing acceptance criteria after observing results.

### Prediction check

The predeclared predictions for exact-threshold inclusion in the fault region, on/off persistence, majority masking, common-mode agreement, and deterministic timing-skew arithmetic all matched evidence.

## Representative failure behavior

1. **Single-channel drift/freeze while the other changes:** disagreement can grow beyond threshold and, if persistent, assert the diagnostic.
2. **Common-mode equal wrong values:** comparator reports agreement because it has no independent truth reference.
3. **One dissenting boolean leg:** majority vote may preserve the majority function but vote alone loses dissent identity.
4. **Two bad/common-cause boolean legs:** majority can be wrong with no intrinsic warning.
5. **Timing skew:** individually correct samples from different instants can exceed the threshold during motion.
6. **Configuration mismatch:** sign/scale/offset errors can look like sensor disagreement; comparison alone does not diagnose cause.

## Design rules

- Preserve raw channels; do not retain only a vote.
- Separate agreement, freshness, validity, and provenance.
- State threshold boundary semantics from the actual component/version used.
- State time-alignment assumptions explicitly.
- State persistence latency explicitly; fault suppression and recovery delay are deliberate tradeoffs.
- Keep functional vote and dissent/maintenance diagnostics in parallel.
- State the failure domain and independence assumptions before using the word redundancy.
- Do not infer PL/SIL/category or safety-rated diagnostic coverage from ordinary HAL logic.

## Fresh-AI novel scenario

### Scenario

A two-channel ram-position diagnostic compares A and B using a ±0.10 unit window and a 40 ms persistence delay. A and B are produced by different physical sensors, but both values pass through the same userspace bridge before entering HAL. During motion the bridge stalls for 100 ms and republishes the last pair unchanged. The two values continue to agree perfectly.

Question: what should a fresh AI conclude, and what modification is needed to make the diagnostic architecture stronger without overclaiming safety?

### Expected reasoning

The agreement monitor alone cannot detect this common publication-path freshness failure because both values can remain equal. Physical sensor separation does not imply end-to-end information-path independence. The architecture needs a freshness/validity mechanism whose evidence is not destroyed by the shared bridge failure — for example device- or transport-owned sequence/timestamp/heartbeat evidence where available, with channel-specific provenance carried into HAL — and the raw agreement diagnostic should remain separate. S04's freshness distinction and S05's common-cause distinction combine here. Even after adding freshness evidence, ordinary LinuxCNC/HAL logic is not automatically safety-rated.

**Fresh-AI competency result: PASS.** The scenario is not answered verbatim by the experiment but follows from the graduated S04/S05 artifacts without inventing behavior.

## Minimum graduation evidence floor

- [x] Core mechanism identified and traced from actual pinned source
- [x] Behaviorally significant numeric and majority-voter call flows documented
- [x] Independent runtime verification completed
- [x] Representative failure paths documented
- [x] Predeclared predictions checked against experiment
- [x] Adversarial exam passed
- [x] Fresh-AI novel scenario solved
- [x] No unresolved item can overturn the central teaching
- [x] Safety/reliability boundary remains explicit

## Promotion / uncertainty queue

| Item | Destination | Priority | Why unresolved | Why it does not block S05 |
|---|---|---:|---|---|
| Hardware/protocol-specific freshness metadata and end-to-end independence evidence | 2000 | HIGH | Depends on actual devices/transports | S05 teaches that agreement is insufficient and explicitly requires separate freshness/provenance evidence |
| Sensor/process-specific threshold design, including velocity/noise models | 2000 | HIGH | No universal threshold exists | The 1000-level objective is component semantics and failure-domain reasoning, not selecting a machine-specific threshold |
| Physical common-cause/diagnostic-coverage analysis | later safety engineering | CRITICAL | Requires architecture/hardware-specific evidence | S05 makes no diagnostic-coverage or safety-integrity claim |
| `timedelay.elapsed` exact observability/version behavior | 2000 | LOW | Pinned source can retain a published nonzero value after internal reset | `timedelay.out` is the tested state oracle; no central conclusion depends on `elapsed` being zero |
| Hardware-specific simultaneous-sampling/skew bounds | 2000 | HIGH | Requires device and bus timing evidence | S05 establishes only the generic skew mechanism and the need for an alignment assumption |

## Counterfactual promotion test

If every promoted item turned out differently than currently expected, would a central S05 claim become wrong, a downstream prerequisite become unreliable, the evidence chain become invalid, or an important safety boundary materially change?

**No.** The central claims are intentionally narrower: numerical agreement is not correctness/freshness/independence; majority arithmetic does not identify truth; timing alignment matters; ordinary HAL logic is not by itself a safety-rated redundancy architecture. The promoted items refine machine-specific implementation and assurance, not these claims.

## Graduation decision

**S05 graduates at 1000 level.** The evidence floor is satisfied and the remaining uncertainty is explicitly machine/device/safety-specific. S06 may now build a reusable fault-injection framework on top of the graduated failure models rather than inventing ad-hoc fault fixtures lesson by lesson.

## Exact handoff to S06

Start S06 by inventorying the fault-injection mechanisms already used across S03–S05 and classify each injection point by layer: HAL pin/value, publication/freshness, motion feedback, HostMot2 LLIO, communication transport, scheduling/order, and restart/state. Define a framework contract that separates injected fault, oracle, control case, recovery criterion, and non-claims before writing another large lab. Prefer composable stock HAL mechanisms (`mux2`, `sample_hold`, `halstreamer`/synthetic pins where appropriate) and test-only LLIO fixtures only when the fault belongs below HAL.