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
| X02 | Synchronized multi-surface diagnostics | **13** | requires accepted X01 recorder perturbation evidence |
| X01 | Recorder perturbation and long-duration retention | **12** | **ACTIVE; frozen preflight launched** |
| T20 | UI/Task/NML freshness and ownership under stress | **11** | strengthened by X02 |
| T21 | 3D HMI, QtVismach and live machine visualization | **10** | follows T20; consume X02 diagnostics/freshness findings |
| H30? | Custom HostMot2 FPGA/driver/distributed realtime extension | — | **3000 candidate only**; D01/S02/E20 do not currently justify promotion |

## Dependency graph

```text
1000-series graduated
        |
        +--> D01 GRADUATED --> S02 technical evidence complete --fresh handoff--+
        |                                                                      |
        +--> X01 recorder perturbation ACTIVE --> X02 correlation -------------+--> F02 compound faults
        |                                              |
        |                                              +--> T20 UI/Task/NML stress --> T21 3D HMI / QtVismach
        |                                                                      |
        +--> E20 technical evidence complete --fresh handoff-------------------+

E20 / X02 / later evidence --only if justified--> H30? 3000 candidate
```

## D01 closure

Authoritative workflow `34375315740` passed unchanged frozen Gates A–J; frozen adversarial exam scored 20/20. D01 established that duplicated-coordinate command agreement and principal-looking Cartesian feedback do not prove duplicate-joint agreement or physical tandem geometry. It did not justify H30/3000.

## S02 technical closure and remaining boundary

Authoritative workflow `34395556653` passed frozen Gates A–J **10/10** from retained atomic evidence; its frozen adversarial exam scored **20/20** with all critical traps rejected. The counterfactual/promotion test did not justify H30.

The only remaining S02 graduation requirement is a genuinely fresh-AI handoff. The same learner instance must not self-certify this information-separated test. Independent work may continue while this handoff remains pending.

## E20 technical acceptance and remaining boundary

E20 completed its frozen authoritative transport/watchdog recovery experiment in workflow `34399792261`. Independently inspected retained evidence passed unchanged Gates A–J **10/10**, the already-frozen adversarial exam passed **20/20**, and the counterfactual/promotion review did not justify H30/3000.

The module is therefore technically accepted but not labeled graduated until a genuinely information-separated fresh-AI handoff is completed. The central retained distinction is that current transport health, accumulated driver error state, HostMot2 watchdog/physical-I/O authority, state revalidation and machine motion authorization are separate evidence/authority surfaces.

## X01 activation — recorder integrity before cross-surface correlation

X01 is the next independent prerequisite because X02 cannot responsibly correlate multiple diagnostics until the recorder itself has an accepted integrity and perturbation contract.

Pinned-source work at LinuxCNC `8bf4605ae81042248add031e94c77300406e0413` now establishes:

- `sampler.c::sample()` executes as a scheduled realtime HAL function, snapshots configured HAL inputs, and attempts one `hal_stream_write()` per retained record;
- a full stream loses the recorder record and increments producer-side `sampler.N.overruns` rather than proving that the underlying control loop skipped a cycle;
- `sampler_usr.c::main()` is a userspace consumer that obtains the stream's implicit sample number from `hal_stream_read()` and reports discontinuity as `overrun`;
- the pinned source exports `sampler.N.sample-num`, but the inspected realtime path does not use that exported pin as the `halsampler -t` sequence, so X01 treats implicit stream tags plus producer-side recorder-health evidence as the current oracle;
- userspace drain lifecycle can truncate evidence independently of realtime producer behavior, so stop/drain behavior is part of the experiment rather than an afterthought.

`guides/X01-recorder-perturbation-and-long-duration-retention.md` preserves the source/community/evidence model. `experiments/X01-001-sampler-retention-perturbation.md` freezes P0–P5 and Gates A–J before execution.

`lab-jobs/027-x01-sampler-retention-preflight.sh` is a non-authoritative implementation preflight. Its creation automatically launched workflow **`34411511393`**. The run must be judged from the retained artifact, not workflow status. The frozen gates remain unscored until the preflight proves that the harness actually exercises the declared model.

## T21 advanced HMI / 3D visualization addition

T21 was added after research found both official LinuxCNC support and press-brake-specific community precedent for moving 3D machine models inside custom HMIs.

Key discoveries now assigned to the 2000 level:

- **QtVismach is an official QtVCP machine-graphics library.** It supports embedded 3D viewports, STL/OBJ model import, hierarchical rigid assemblies, and HAL-driven `HalTranslate` / `HalRotate` animation.
- **LinuxCNC users have built a press-brake simulator around Vismach.** The published forum work includes a bend-sequence table, press state machine and moving Vismach brake through rapid/start/bend/finish behavior, with backstop/operator-sequence work also discussed.
- **A press-brake Vismach model has been embedded inside QtDragon.** The community example imports a press-brake model window and inserts it into a QtDragon layout, demonstrating a practical custom-HMI integration route rather than a separate graphics-only application.
- **Rigid machine visualization and sheet deformation are different problems.** QtVismach directly addresses transformed rigid parts; realistic workpiece bending/collision/deformation must be investigated separately rather than assumed.
- **Visualization inherits the T20 authority problem.** Smooth 3D motion is not proof of fresh status, physical synchronization, collision safety or realtime authority. T21 must deliberately test stale/frozen/disagreeing data behavior.

The detailed discovery notes, proposed experiments and graduation traps are in `guides/T21-3d-hmi-qtvismach-discovery.md`.

T21 should cover custom QtVCP/QtVismach architecture, CAD-to-HMI STL/OBJ workflow, independent multi-joint motion, auxiliary-axis/backgauge/tooling visualization, provenance/freshness indicators, deliberate stale-state behavior, optional clearly-labelled diagnostic exaggeration of small joint disagreement, rendering/performance perturbation, and the boundary between schematic bend visualization and validated deformation/collision models.

T21 follows T20 and may consume X02 synchronized diagnostic findings. It is part of completing the advanced HMI branch but is **not** a prerequisite for F02 compound-fault sequencing.

## Re-promotion safeguards

1. Do not create a 3000 module merely because a 2000 experiment is difficult.
2. Preserve version-specific conclusions as version-specific until a source/version matrix supports generalization.
3. Keep physical sensor coupling, actuator authority, stopping performance and functional-safety certification outside software-only proof.
4. A successful synthetic fault/recovery state model proves only the modeled software distinctions.
5. The end-of-1000 sealed benchmark and fresh-AI tests remain information-separated.
6. Do not promote 3D work to 3000 merely because CAD or graphics are involved. Promote only if evidence shows that validated deformation/collision physics, custom rendering infrastructure or another specialized prerequisite is actually needed.

## Exact next dependency checkpoint

Inspect only X01 preflight workflow `34411511393`. On completion, independently inspect its retained artifact and classify the result as harness-valid PASS, harness failure, source-model contradiction, or infrastructure failure. Do not score or retune frozen Gates A–J from workflow status alone. If the preflight validly exercises P0–P5, launch a separate authoritative X01 run unchanged; otherwise correct only the demonstrated harness defect and apply the three-attempt rule. X02 remains blocked until X01 has an accepted recorder-integrity/perturbation contract. Do not advance F02 until S02 and E20 fresh handoffs plus accepted X02 are complete.
