# T05 — 1000-level graduation decision

Status: **GRADUATED at 1000 level**  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Learning objective demonstrated

A fresh AI can now design and review a LinuxCNC custom operator interface without collapsing presentation, command ownership, status freshness, physical evidence, diagnostics, and safety authority into one UI state.

## Graduation evidence

- **Official documentation reviewed:** current QtVCP/HALUI interface roles and handler customization behavior were reconciled with pinned implementation details.
- **Community knowledge reviewed:** HALUI/MDI mode surprises and multi-producer Python-interface reports were retained as hypothesis evidence rather than silently promoted to source truth.
- **Source mechanism traced:** HALUI input -> NML command; NML status -> HALUI output; QtVCP handler startup -> explicit status synchronization; GStat construction/update behavior; direct Python command/status/error ownership.
- **End-to-end execution paths documented:** `call-flows/T05-custom-operator-interface-boundaries.md`.
- **Representative failure path understood:** failed GStat update leaves status invalid while generic GUI periodic activity may continue; retained cache is not current observation proof.
- **Predeclared prediction independently tested:** T05-022 attempt 2, workflow `34193926426`, job `101957458393`, artifact `10043263546`, exit 0, passed unchanged Gates A-H after attempt 1 was rejected as harness-invalid.
- **Adversarial exam passed:** `exams/T05-custom-operator-interface-adversarial.md`, including misleading startup, HALUI physical-truth, multi-producer ownership, diagnostic ownership, stale-status, safety-function, failure-path, implementation, novel-scenario, and version-sensitive questions.
- **Correction incorporated:** `_GStat.__init__()` may make a best-effort poll/merge before the screen handler's explicit forced-update point. The course now distinguishes constructor cache from validated/current observation rather than claiming `initialized__()` precedes every possible status poll.
- **Fresh-AI handoff:** `checkpoints/T05-fresh-ai-handoff.md` contains and solves a novel HALUI + QtVCP + remote-producer status-loss scenario from the durable boundaries.

## Minimum graduation evidence floor

- [x] Core mechanism identified and traced from actual source
- [x] Behaviorally significant execution paths traced end-to-end
- [x] Independent runtime verification beyond source rereading
- [x] Representative failure/invalid-observation path understood
- [x] Predeclared prediction checked against independent evidence
- [x] Fresh-AI handoff includes a novel course-level scenario
- [x] No promoted item can overturn a central teaching
- [x] No promoted item invalidates a downstream prerequisite
- [x] No promoted item invalidates the evidence chain
- [x] No promoted item materially changes the 1000-level safety/reliability boundary
- [x] Every promoted item explains why promotion is safe

## Central retained teaching

```text
operator intent
!= command ownership/result
!= status observation/freshness
!= physical machine truth
!= diagnostic presentation
!= safety authority
```

For controller-dependent UI controls, **construction cache is not a freshness certificate**. Start fail-defined and require an explicit successful/current observation policy for advisory enablement. Task/controller semantics remain authoritative for command acceptance; physical and safety evidence remain separate.

## Higher-level promotion queue

| Item | Destination | Priority | Blocks? | Why promotion is safe |
|---|---|---:|---|---|
| detailed multi-command-producer correlation/races | 2000 | HIGH | No | May refine arbitration design but cannot make one local widget/result oracle globally authoritative. |
| error-channel fan-out/multiple consumers | 2000 | HIGH | No | May refine diagnostic architecture; semantic result remains separate from message presentation. |
| remote UI/NML reconnect/packet/timing faults | 2000 | HIGH | No | Adds distributed failure modes without changing the need for explicit freshness/ownership. |
| physical pendant/HALUI latency and failure behavior | 2000 | MEDIUM | No | Hardware timing refines implementation but HALUI projection remains distinct from direct physical/safety truth. |
| safety-HMI architecture/certification | specialized higher level | HIGH | No for ordinary OI scope | 1000-level material explicitly refuses to claim GUI/HALUI is safety-rated. |

## Counterfactual promotion test

**PASS.** Even if every promoted item's detailed behavior differs from current expectations, none makes presentation equal to fresh observation, fresh observation equal to semantic acceptance, acceptance equal to physical action, or ordinary UI state equal to safety authority. No downstream prerequisite depends on those unresolved details being one particular way.

## Next curriculum boundary

T05 completes Phase 9. Phase 10 begins with **C01 — simulated dual-actuator machine**. However the curriculum's required **blind development-bank baseline**, due after T03 and before leaving the current major module cluster, still has no valid score because evaluator/learner information separation has not yet been established. Do not fabricate or contaminate that baseline merely to enter Phase 10.

The next critical-path work is therefore to execute a genuinely blind development challenge using a hidden external oracle, commit the learner precommit before answer revelation, score it under `evaluation/BLIND_FEEDBACK_PROTOCOL.md`, and only then activate C01.
