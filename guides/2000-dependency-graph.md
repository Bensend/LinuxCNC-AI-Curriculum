# 2000-series dependency graph

Status: **ACTIVE**

This graph is the dependency-driven promotion pass after completion of T02–T05 and C01–C09 at 1000 level. Difficulty alone does not justify promotion; 3000 work requires evidence that specialized prerequisites or infrastructure are actually necessary.

## Priority heuristic

Working priority score is `P + U + C + IG - IC` for prerequisite value, uncertainty, consequence, expected information gain, and infrastructure-cost penalty. It schedules work; it is not a risk metric.

| ID | Advanced module | Score | State / dependency |
|---|---|---:|---|
| D01 | Coupled-control stability and tandem-joint authority | **17** | **GRADUATED 2000; 2026-09-09** |
| F02 | Compound-fault state-machine sequencing | **16** | blocked by S02, E20 and X02 |
| S02 | Feedback integrity, diversity and common-cause reasoning | **15** | authoritative gates + exam + promotion complete; **fresh-AI handoff pending** |
| E20 | HostMot2/hm2_eth watchdog/recovery across versions | **14** | **TECHNICALLY ACCEPTED; fresh-AI handoff pending** |
| X02 | Synchronized multi-surface diagnostics | **13** | **ACTIVE RESEARCH; X01 technical prerequisite accepted** |
| X01 | Recorder perturbation and long-duration retention | **12** | **TECHNICALLY ACCEPTED; fresh-AI handoff pending** |
| T20 | UI/Task/NML freshness and ownership under stress | **11** | strengthened by X02 |
| T21 | 3D HMI, QtVismach and live machine visualization | **10** | follows T20; consume X02 diagnostics/freshness findings |
| H30? | Custom HostMot2 FPGA/driver/distributed realtime extension | — | **3000 candidate only**; D01/S02/E20 do not currently justify promotion |

## Dependency graph

```text
1000-series graduated
        |
        +--> D01 GRADUATED --> S02 technical evidence complete --fresh handoff--+
        |                                                                      |
        +--> X01 technical evidence ACCEPTED --fresh handoff pending            |
        |          |                                                            |
        |          +--> X02 correlation ACTIVE --------------------------------+--> F02 compound faults
        |                       |
        |                       +--> T20 UI/Task/NML stress --> T21 3D HMI / QtVismach
        |                                                                      |
        +--> E20 technical evidence complete --fresh handoff-------------------+

E20 / X02 / later evidence --only if justified--> H30? 3000 candidate
```

Technical acceptance and full graduation are deliberately distinguished. X02's prerequisite is accepted X01 recorder evidence; it does not require the current learner to violate information separation by self-certifying X01's fresh-AI handoff.

## D01 closure

Authoritative workflow `34375315740` passed unchanged frozen Gates A–J; frozen adversarial exam scored 20/20. D01 established that duplicated-coordinate command agreement and principal-looking Cartesian feedback do not prove duplicate-joint agreement or physical tandem geometry. It did not justify H30/3000.

## S02 technical closure and remaining boundary

Authoritative workflow `34395556653` passed frozen Gates A–J **10/10** from retained atomic evidence; its frozen adversarial exam scored **20/20** with all critical traps rejected. The counterfactual/promotion test did not justify H30.

The only remaining S02 graduation requirement is a genuinely fresh-AI handoff. The same learner instance must not self-certify this information-separated test. Independent work may continue while this handoff remains pending.

## E20 technical acceptance and remaining boundary

E20 completed its frozen authoritative transport/watchdog recovery experiment in workflow `34399792261`. Independently inspected retained evidence passed unchanged Gates A–J **10/10**, the already-frozen adversarial exam passed **20/20**, and the counterfactual/promotion review did not justify H30/3000.

The module is therefore technically accepted but not labeled graduated until a genuinely information-separated fresh-AI handoff is completed. The central retained distinction is that current transport health, accumulated driver error state, HostMot2 watchdog/physical-I/O authority, state revalidation and machine motion authorization are separate evidence/authority surfaces.

## X01 technical acceptance — recorder integrity contract

Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`.

X01-001 exhausted its three materially similar attempts after the forced-loss experiment falsified the old assumption that producer FIFO loss must create a `halsampler -t` tag gap. It was explicitly classified **ESSENTIAL NOW / MATERIAL REDESIGN** rather than tuned into a pass.

X01-002 froze a corrected loss oracle before execution: producer overrun evidence plus a discontinuity in a deterministic sampled cycle witness; `-t` tags remain ordering evidence for successfully returned stream records only.

The valid redesigned preflight was workflow `34428664862`, artifact `10133717168`.

The first authoritative wrapper attempt `34432706789` failed before LinuxCNC behavior because of a Python source-rewrite syntax error and remained harness-invalid/unscored. A wrapper-only correction then launched authoritative workflow `34436256547`, job `102741829103`, artifact `10136342576`.

Independent raw-artifact audit passed frozen Gates A–J **10/10**:

- 2,000-row baseline: contiguous stream/payload, zero producer overruns;
- bounded stop/drain: exactly 354 residual rows drained, terminal payload within frozen three-cycle boundary and final FIFO depth zero;
- forced depth-64 saturation: producer overruns 192 -> 206 while deterministic source counter advanced 282 -> 473; retained `-t` tags remained contiguous but deterministic sampled payload jumped **79 -> 286**;
- narrow/wide timing evidence retained with zero overruns, without converting cloud timing into a production deadline guarantee;
- predeclared P5: exactly 10,000 retained narrow-config rows, contiguous stream and payload, producer overruns zero.

`call-flows/X01-sampler-recording-and-loss-boundary.md` records the source boundary. `exams/X01-adversarial-exam.md` was frozen before answers and scored **20/20** with all critical traps passed. `handoffs/X01-fresh-ai-recorder-integrity-transfer.md` is prepared and intentionally UNSCORED by the current learner.

**Decision:** X01 is technically accepted at 2000 level; full graduation awaits a genuinely fresh-AI handoff. That is sufficient to unlock X02 under this graph's prerequisite wording.

## X02 activation — synchronize evidence, not wall-clock appearances

`guides/X02-synchronized-multi-surface-diagnostics.md` has begun the official/community/source inventory.

Initial boundaries now established:

- motion/HAL state has a realtime ownership/update path;
- pinned `taskintf.cc` documents `emcMotionUpdate()` as the motion-status acquisition point whose local `emcmotStatus` is then reused by joint/trajectory status updates;
- pinned `emctaskmain.cc` owns cyclic Task execution plus command/status/error NML channels and global `EMC_STAT`;
- current Python-interface documentation describes `linuxcnc.stat().poll()` as a userspace status-channel observation;
- a community pattern republishes polled NML status into HAL, demonstrating why a HAL-visible value can still have userspace/NML freshness semantics;
- X01 recorder health must invalidate/qualify cross-surface correlation intervals rather than being ignored because a trace looks plausible.

X02's next source task is to trace `emcMotionUpdate()` through Task `EMC_STAT` publication and trace Python `linuxcnc.stat().poll()` to the status-channel read, identifying explicit heartbeat/sequence/echo fields before freezing X02-001.

## T21 advanced HMI / 3D visualization addition

T21 was added after research found both official LinuxCNC support and press-brake-specific community precedent for moving 3D machine models inside custom HMIs.

Key discoveries now assigned to the 2000 level:

- **QtVismach is an official QtVCP machine-graphics library.** It supports embedded 3D viewports, STL/OBJ model import, hierarchical rigid assemblies, and HAL-driven `HalTranslate` / `HalRotate` animation.
- **LinuxCNC users have built a press-brake simulator around Vismach.** Published forum work includes a bend-sequence table, press state machine and moving Vismach brake through rapid/start/bend/finish behavior, with backstop/operator-sequence work also discussed.
- **A press-brake Vismach model has been embedded inside QtDragon.** The community example demonstrates practical custom-HMI integration rather than a graphics-only side application.
- **Rigid machine visualization and sheet deformation are different problems.** QtVismach directly addresses transformed rigid parts; realistic workpiece bending/collision/deformation must be investigated separately rather than assumed.
- **Visualization inherits the T20 authority problem.** Smooth 3D motion is not proof of fresh status, physical synchronization, collision safety or realtime authority. T21 must deliberately test stale/frozen/disagreeing data behavior.

The detailed discovery notes, proposed experiments and graduation traps are in `guides/T21-3d-hmi-qtvismach-discovery.md`.

T21 follows T20 and may consume X02 synchronized diagnostic findings. It is not a prerequisite for F02 compound-fault sequencing.

## Re-promotion safeguards

1. Do not create a 3000 module merely because a 2000 experiment is difficult.
2. Preserve version-specific conclusions as version-specific until a source/version matrix supports generalization.
3. Keep physical sensor coupling, actuator authority, stopping performance and functional-safety certification outside software-only proof.
4. A successful synthetic fault/recovery state model proves only the modeled software distinctions.
5. The end-of-1000 sealed benchmark and fresh-AI tests remain information-separated.
6. Do not promote 3D work to 3000 merely because CAD or graphics are involved. Promote only if evidence shows that validated deformation/collision physics, custom rendering infrastructure or another specialized prerequisite is actually needed.

## Exact next dependency checkpoint

Continue X02 source tracing at pinned revision `8bf4605ae81042248add031e94c77300406e0413`. Locate the exact Task call order for `emcMotionUpdate()` and `emcStatusBuffer->write(...)`; locate the Python `linuxcnc.stat().poll()` implementation/status read; identify heartbeat/sequence/echo fields that can act as freshness/order witnesses. Only after that source-grounded model exists should X02-001 choose the smallest multi-surface fixture and freeze its prediction/gates. Preserve X01/S02/E20 fresh handoffs as pending and do not self-certify them. F02 remains blocked until S02 and E20 fresh handoffs plus accepted X02 are complete.
