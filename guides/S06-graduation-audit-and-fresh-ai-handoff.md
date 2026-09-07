# S06 — graduation audit and fresh-AI handoff

- Module: S06 — fault injection framework
- Course level: 1000
- Status: **GRADUATED**
- Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
- Authoritative experiment: S06-016 / workflow `34146966388` / fixture commit `c116c997e39506bb82bbae6cce777bde19015fde`

## Learning objective result

A fresh AI engineer can now choose a fault-injection layer, preserve the production mechanism under test, build a deterministic test boundary, independently prove that a fault actually occurred, separately prove downstream response, verify capture health and realtime ordering, classify harness failure apart from behavioral failure, test recovery, preserve non-claims, and serialize the result in a reusable evidence structure.

## Core mechanism from source — satisfied

Pinned source was inspected for the stock HAL primitives used to build/observe experiments:

- `streamer.c::update()` — realtime FIFO consumption, empty/underrun behavior, retained data outputs on no update;
- `sampler.c::sample()` — realtime pin capture, FIFO write, overrun/lost-sample behavior;
- HAL stream create/read/write single-reader/single-writer boundary;
- `comp.comp` strict zero-hysteresis comparison semantics;
- prior graduated `mux2`, `sample_hold`, `sum2`, `abs`, motion, HostMot2 test-double patterns reused only within their proven boundaries.

The complete S06 execution flow is documented in `call-flows/S06-fault-injection-evidence-flow.md`.

## Independent verification — satisfied

S06-016 passed on its first attempt with lab exit code `0` and no post-hoc gate changes.

Machine-readable evidence reports:

- correct thread order;
- 170/170 required trace rows;
- zero sampler overruns;
- healthy baseline pass;
- freeze injection/response/recovery pass;
- one-cycle jump injection/response/recovery pass;
- one-cycle stale/age-skew injection/response/recovery pass;
- explicit rejection of a circular injector-mode oracle;
- overall `PASS`.

Raw trace independently demonstrates the scheduled faults rather than trusting the fixture's mode pin.

## Representative failure behavior — satisfied

S06 defines two distinct failure classes:

- `HARNESS_INVALID` when the intended fault/capture/topology is not valid enough to support a LinuxCNC conclusion;
- `BEHAVIOR_FAIL` when the harness and injection are valid but the predeclared downstream behavior/recovery prediction fails.

Pinned sampler source provides a concrete representative failure: FIFO overrun loses samples, so an exact-cycle experiment with required missing rows becomes harness-invalid rather than product-failed.

## Prediction check — satisfied

Before implementation, S06-016 predicted:

- healthy publication -> both detectors clear;
- freeze -> age detector and eventually value detector;
- +5 single-cycle jump with current sequence -> value detector only;
- one-cycle-old 0.01-ramp sample -> age detector only because 0.01 < 0.05;
- removal of each fault -> fresh publication and detector clear.

All predictions matched independent runtime evidence.

## Adversarial exam — satisfied

`exams/S06-adversarial-exam-and-answer-key.md` passes source navigation, misleading-premise, version-conflict, harness-failure, injection-layer, deterministic-timing, recovery, and bounded-modification requirements.

One correction was incorporated: six-decimal trace formatting is not a bit-exact floating threshold oracle.

## Fresh-AI handoff test — satisfied

### Novel scenario

A downstream gateway retransmits a stale device measurement every servo cycle but generates a fresh local sequence number for every retransmission. The stationary value is plausible and the local sequence advances.

### Required reasoning

A fresh AI must recognize that the sequence proves only **gateway publication freshness**, not **device measurement freshness**. Freshness metadata has provenance. To claim device freshness, the freshness token must originate at or below the device/fault boundary or the injection/test-double must preserve that layer.

### Result

PASS. The developer guide's layer/oracle rules are sufficient to derive the correct answer without inventing a physical device behavior. This scenario extends beyond the exact S06-016 fixture and demonstrates transfer rather than rote repetition.

## Corrections incorporated

1. **Do not trust formatted floating equality for an exact threshold claim.** Capture adequate precision or compare in realtime.
2. **Freshness tokens have provenance.** A sequence generated downstream of a stale source can prove message cadence while hiding source staleness.
3. **Current documentation and pinned source conflict on exported `sampler.N.sample-num`.** Do not use it as the S06 cycle oracle; preserve the discrepancy for higher-level/version study.
4. **Userspace-fed streamer is not automatically an exact-cycle fault scheduler.** Prefilled FIFO sequences are useful, but non-realtime refill arrival can be an uncontrolled timing variable.

## Higher-level promotion / uncertainty queue

| Item / question | Current evidence | Why deferred | Consequence if wrong | Destination | Priority | Blocks S06? | Why promotion is safe |
|---|---|---|---|---|---|---|---|
| Exported `sampler.N.sample-num` documented vs pinned-source behavior | docs/source conflict | Not used by accepted experiment; needs version/source-history trace | Could affect tools that assume the exported field is a cycle tag | 2000 | LOW | No | S06 samples an explicit realtime cycle and teaches the conflict |
| Source-origin timestamp/sequence/heartbeat semantics for real devices | generic framework + novel scenario | Device/protocol-specific | Could invalidate a hardware freshness claim if token provenance is misunderstood | 2000 | HIGH | No | S06 explicitly forbids inferring physical freshness and teaches provenance |
| General lab-runner automatic ingestion/indexing of `linuxcnc-ai-fi-v1` | schema proved once at job level | Tooling should stabilize through reuse | Affects convenience/auditability, not S06 mechanism | 2000/tooling | MEDIUM | No | Raw/result artifacts are already durable and independently readable |
| Physical fault representativeness/diagnostic coverage | not established | Requires real hardware/failure models and separate safety engineering | High for machine safety claims | later safety engineering | CRITICAL | No | S06 explicitly makes no physical/safety coverage claim |
| Exact floating comparator threshold under formatted traces | source + one rounded observation | Not part of frozen S06 objective | Could matter to exact-boundary tests | 2000 | LOW | No | No S06 acceptance gate depends on formatted equality at the boundary |

## Counterfactual promotion test

If every promoted item turned out differently from the present expectation:

- S06's central teaching that fault injection must be layer-bounded and independently evidenced would remain correct;
- S06-016's evidence chain would remain valid because it does not use `sampler.N.sample-num`, device timestamps, hardware diagnostic coverage, or exact formatted threshold equality;
- downstream curriculum can safely rely on the PASS/BEHAVIOR_FAIL/HARNESS_INVALID distinction and evidence schema;
- the safety boundary would not become less conservative, because physical/safety claims are explicitly excluded.

**Counterfactual result: PASS.** No promoted item blocks 1000-level graduation.

## Minimum graduation evidence floor

- [x] Core mechanism identified and traced from actual source
- [x] Behaviorally significant execution path traced end-to-end
- [x] Independent runtime verification beyond source reading
- [x] Representative failure/invalid-input path understood
- [x] Predeclared prediction checked against independent evidence
- [x] Fresh-AI novel course-level scenario solved
- [x] No promoted item can overturn a central teaching
- [x] No promoted item invalidates downstream prerequisite value
- [x] No promoted item invalidates the evidence chain
- [x] No promoted item weakens the stated safety boundary
- [x] Every promotion explains why it is safe

## Graduation decision

**S06 is GRADUATED at 1000 level.**

The reusable framework is now suitable for later curriculum experiments: identify injection layer; preserve mechanism under test; predeclare gates; independently prove injection; independently prove response; verify ordering/capture health; test recovery; classify harness invalid separately from behavior fail; serialize evidence; and preserve non-claims.

## Next dependency

Activate **S07 — restart/recovery/state integrity**. Begin with intended restart/recovery semantics and a source inventory of HAL/LinuxCNC teardown/reinitialization paths, then select representative retained/reset state and design a bounded restart experiment without conflating process restart with physical-machine recovery.
