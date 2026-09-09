# C09 — frozen-rubric architecture handoff evaluation

Result: **20/20 PASS**

Rubric authority: `evaluation/C09-architecture-handoff-rubric.md`, committed before the handoff answer.
Answer evaluated: `evaluation/C09-fresh-ai-handoff-answer.md`.

## Gate scoring

| Gate | Score | Evidence in handoff |
|---|---:|---|
| A realtime placement | 2/2 | Per-actuator loops, synchronization/cross-coupling and cyclic hardware I/O are placed in the realtime servo graph; UI is supervisory. |
| B two-loop topology / epistemology | 2/2 | Separate A/B feedback/controller/command paths retained; agreement/disagreement is explicitly not physical self-authentication. |
| C request vs achieved | 2/2 | Request, achieved state and authorization are separate; sequencing waits for returned achieved state. |
| D fresh authorization / recovery | 2/2 | Active fault consumes authorization; prerequisite restoration does not retry; new authorization + request + achieved confirmation required. |
| E transport vs watchdog | 2/2 | `io_error`-class transport state and watchdog status remain distinct; watchdog can be unobservable during transport loss; network recovery is not watchdog/state recovery. |
| F diagnostic validity | 2/2 | Ordered realtime capture, function-order provenance, producer-overrun telemetry and collector lifecycle required; logs/NML are only correlated absent synchronization. |
| G software vs physical truth | 2/2 | Encoder agreement/disagreement and controller diagnostics are bounded as software-observable evidence, not proof of geometry/authority/safety. |
| H safety authority | 2/2 | External safety system explicitly owns safety-rated stop/interlock/restart authority. |
| I verification strategy | 2/2 | Tests independently cover asymmetric response, sensor faults, blocked request, stale authorization, transport/watchdog discrimination, recorder overflow and UI freshness. |
| J uncertainty discipline | 2/2 | Hardware/version/certification unknowns are named with required evidence rather than invented. |

No mandatory gate scored zero. Safety boundary passes.

## Adversarial trap review

All ten frozen traps were rejected:

1. no servo-critical UI loop;
2. no single-sensor truth oracle;
3. request not treated as achieved state;
4. no automatic post-communication resume;
5. `io_error` not equated to watchdog bite;
6. false watchdog indication during transport loss not treated as negative proof;
7. userspace/log observations not promoted to atomic realtime state;
8. consumer continuity not used as sole no-loss proof;
9. sensor agreement not treated as proof of physical alignment;
10. ordinary LinuxCNC/HostMot2 mechanisms not treated as safety certification.

## Novel integrated failure/recovery trace

The answer's Ethernet-loss trace successfully composes C06, C07 and C08 constraints: transport evidence causes ordinary cycle authorization revocation; watchdog state is not invented while unobservable; restored transport triggers reacquisition/recovery rather than stale-cycle continuation; a new authorization/request/achieved-state chain is required; physical safe-restart authority remains external.

This is an integration result, not new physical-machine evidence.

## Corrections required

None at 1000 level. One wording discipline remains important for later work: 'revoke authorization immediately' is an architecture requirement for the ordinary realtime/control state machine, not a claim that userspace Task/UI can provide safety-rated immediate response. The handoff already places safety authority externally and servo-critical response in realtime, so no guide correction is required.

## Higher-level promotion queue

- **2000 / HIGH:** quantify and design cross-coupling stability/authority under realistic asymmetric plants and delays; current handoff proves architecture boundaries, not physical stability.
- **2000 / HIGH:** compare version-specific HostMot2/hm2_eth watchdog/transport recovery behavior beyond the pinned revision.
- **2000 / HIGH:** explicitly synchronized multi-surface diagnostic correlation across realtime HAL, Task/NML and process logs.
- **2000 / HIGH:** sensor common-cause/diversity and independent plausibility architectures; software pair agreement is intentionally not accepted as physical truth.
- **2000 / MEDIUM:** long-duration recorder design, overflow recovery, jitter/perturbation measurement.
- **3000 candidate / HIGH, only if later evidence justifies:** custom FPGA/driver and distributed realtime failure engineering.
- **Hardware/safety-specific / CRITICAL but not a 1000 software blocker:** actual external safety architecture/certification, stopping performance, sensor coupling, actuator/drive authority and physical commissioning.

## Counterfactual promotion test

If every promoted implementation detail differs from current expectations, the C09 central teachings still hold: servo-critical work belongs at the deterministic realtime boundary; request is not achieved state; stale authorization must not be reused; measurements do not self-authenticate physical truth; transport and watchdog evidence must not be conflated; diagnostic ordering must match recorder evidence; and ordinary LinuxCNC control is not safety certification. Therefore these items are safely promotable from C09 1000.

## Graduation evidence decision

C09 is an integration/handoff capstone rather than a new low-level implementation subsystem. Its independent evidence is inherited from the already-graduated source-grounded and laboratory-confirmed T02–T05/C01–C08 prerequisites, while C09 adds a pre-frozen cross-module architecture rubric and a novel integrated design/failure scenario. The handoff passed 20/20 without weakening prior boundaries.

Decision: **C09 GRADUATED — 1000 level**.
