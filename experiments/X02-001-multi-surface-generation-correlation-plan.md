# X02-001 — Multi-surface generation correlation experiment

Status: **FROZEN BEFORE EXECUTION**

LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Prerequisite evidence: X01-002 accepted recorder-integrity contract; `call-flows/X02-multi-surface-status-publication.md`; `call-flows/X02-motion-type-cross-surface-witness.md`.

## Objective

Demonstrate, in a software-only LinuxCNC fixture, what can and cannot be inferred when correlating realtime/HAL observations with Task/NML/Python observations that run at different rates. In particular, prove that generation witnesses are stronger than nearest-wall-clock matching and that equal state values do not imply equal generations.

## Predeclared prediction

1. Repeated Python polls can observe the same Task generation (`taskbeat` unchanged) even though observer monotonic time advances.
2. A later Task generation can legitimately carry an unchanged selected motion state; state equality is not freshness evidence.
3. Slowing Python observation will cause it to skip motion and/or Task generations rather than produce one observation per producer generation.
4. `motion.motion-type` and Python `stat.motion_type` will follow the same ordered state transitions because both derive from `emcmotStatus.motionType`, but Python will observe a later published representation and may omit intermediate generations.
5. No interval with X01-invalid realtime recorder evidence is eligible for exact cross-surface correlation.

## Selected state witness

- Realtime/HAL: `motion.motion-type` (`s32`, output).
- Task/NML/Python: `linuxcnc.stat().motion_type` from `status.motion.traj.motion_type`.
- Generation witnesses in Python: `taskbeat` and the motion heartbeat exposed by the pinned status interface if available under the fixture; the implementation must source-trace the exact Python member used before execution and abort preflight if it cannot be provenance-verified.
- Realtime recorder integrity/generation: deterministic X01-style payload-cycle counter, producer overrun count, retained-row continuity, and explicit topology/order metadata.

`motion_type` is deliberately **not** a generation identifier.

## Fixture

Use an existing repository LinuxCNC simulation configuration that can execute a deterministic software-only program without physical hardware. The program must create at least two known motion-type transitions (for example idle -> traverse/feed -> idle, preferably with both traverse and feed if the chosen sim supports deterministic command completion).

The implementation may adapt an already validated repository simulation fixture, but must record the exact INI/HAL/program provenance and must not alter the gates after seeing behavioral output.

The realtime/HAL recorder must reuse the accepted X01 recorder-health principles: deterministic payload-cycle witness, adequate FIFO sizing/drain, overrun accounting, complete retained artifact, and bounded stop/drain handling.

## Observation phases

P0 — **Topology/readiness**
- LinuxCNC reaches deterministic ready state.
- Record servo period, Task cycle time, recorder FIFO/depth/order, selected HAL pins, Python member provenance, and initial generation/state values.

P1 — **Fast Python polling / idle**
- Poll substantially faster than configured Task cycle for a bounded interval.
- Purpose: seek repeated observer records with identical `taskbeat` while monotonic observer time increases.

P2 — **Normal-rate transition sequence**
- Execute the deterministic motion program while polling at a moderate rate.
- Realtime recorder continuously captures payload cycle + HAL `motion.motion-type`.
- Python records monotonic time + taskbeat + motion heartbeat + `motion_type`.

P3 — **Slow Python polling**
- Poll substantially slower than Task and motion publication for a bounded interval while another deterministic motion sequence executes.
- Purpose: demonstrate skipped producer generations rather than one-to-one observation.

P4 — **Return/idle and bounded drain**
- Finish motion, observe return to idle, stop realtime production cleanly, drain recorder, retain all raw traces and health counters.

P5 — **Invalid-interval discriminator (preflight only unless cleanly implementable without contaminating authoritative data)**
- If a recorder-loss interval is deliberately created, it must be separately labeled and must satisfy the X01 producer-overrun/payload-discontinuity oracle. No correlation gate may use that interval as valid evidence. If deliberate loss would complicate the authoritative fixture, use the already accepted X01 artifact as the invalid-interval counterexample and do not manufacture loss in the authoritative X02 run.

## Frozen Gates A–J

**A — Provenance/readiness:** exact LinuxCNC SHA, fixture files, periods, thread/function order, Python member provenance, and raw artifact inventory are retained.

**B — Realtime recorder validity:** all authoritative P1–P4 realtime intervals used for correlation have zero unexplained producer overruns, deterministic payload continuity, no reader truncation, and a bounded valid stop/drain.

**C — Same-Task-generation repeat:** P1 contains at least one pair of successive Python observations with increasing monotonic observer time and identical `taskbeat`. If the environment cannot produce this despite polling faster than Task, classify the gate INCONCLUSIVE rather than rewriting the claim.

**D — Task-generation advance:** Python trace contains multiple strictly increasing `taskbeat` values and no unexplained backwards movement/wrap in the bounded run.

**E — Motion-generation relationship:** Python trace demonstrates that motion heartbeat and taskbeat are not assumed one-for-one: at least one observed adjacent pair has one generation witness advance without requiring the other to advance by exactly one, or the run is INCONCLUSIVE for this gate. No fabricated timing inference substitutes for the witness values.

**F — Selected-state transition consistency:** the ordered nonduplicate `motion_type` states observed by Python are a subsequence of the ordered HAL `motion.motion-type` states in the valid realtime trace, with expected deterministic program transitions represented. Exact timestamp equality is not required or scored.

**G — Equal-state/non-freshness discriminator:** retain at least one case where a generation witness advances while `motion_type` remains equal, proving equal state does not establish same generation/freshness.

**H — Slow-observer skip:** P3 contains an adjacent Python observation pair with a generation delta greater than one (`taskbeat` and/or motion heartbeat), demonstrating skipped producer generations under slower observation.

**I — Invalid-recorder exclusion:** analysis explicitly rejects every interval that fails the X01 recorder-validity oracle; if P5 uses prior X01 evidence rather than newly injected loss, record that provenance and show the correlation analysis excludes such evidence by construction.

**J — No timestamp-simultaneity claim:** final analysis contains no claim that nearest monotonic/wall-clock timestamps prove same-cycle correspondence. Correlations are stated in terms of ordered state and generation witnesses, with uncertainty where no shared generation ID exists.

## Acceptance rule

A valid preflight must exercise P0–P4 and produce raw retained traces sufficient to score A–J without changing the frozen gates. Gates C/E may be explicitly INCONCLUSIVE if the bounded scheduling realization does not expose the predicted relation; that outcome is behavioral information and must not trigger silent rate retuning inside the same authoritative lineage. A technically accepted authoritative run requires all non-inconclusive safety/evidence-integrity gates to pass and any inconclusive generation gate to be reconciled before graduation.

Workflow success alone is never the oracle; raw artifacts must be independently inspected.

## Adversarial failure cases to preserve

- Python polls rapidly but NML publication does not change: observer time advances, generation does not.
- Task republishes while motion state remains unchanged.
- Motion advances several generations before a slow Python observer sees another status.
- `motion_type` coincidentally has the same value before and after skipped generations.
- Recorder FIFO loss creates an apparently neat but incomplete HAL sequence; X01 health witnesses invalidate it.
- A tempting nearest-timestamp join pairs values that are ordered plausibly but lack a common generation identity.

## Next action

Implement a preflight exactly against this frozen contract. Before launching, source-trace the exact Python motion-heartbeat member available at the pinned revision and record it in the implementation notes. Do not alter P0–P4 or Gates A–J after observing results; harness-only defects may be corrected under the three-attempt rule.
