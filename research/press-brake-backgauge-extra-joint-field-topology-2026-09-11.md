# Press-brake backgauge — extra-joint field topology and typed-position consequence

Date: 2026-09-11
Course context: 3600 press-brake preparation
Pinned LinuxCNC source baseline for future source tracing: `8bf4605ae81042248add031e94c77300406e0413`

## Why this note exists

The preceding `JOG_ABS` versus MDI/G53 analysis reached a bounded result for an **ordinary LinuxCNC trajectory coordinate**: MDI/G53 is the cleaner documented Python surface for an absolute machine-coordinate target than relying on internal `EMC_JOG_ABS`.

A bounded community search immediately found stronger architecture evidence for the actual press-brake problem: the public Ursviken Pullmax Optima retrofit deliberately moved its machine axes into LinuxCNC **extra joints**. That changes the backgauge implementation question materially and must supersede any assumption that X/R/Z will necessarily be ordinary trajectory coordinates.

## Ursviken architecture evolution

In the public build diary the machine began with conventional press-brake names:

- Y1/Y2 ram sides;
- X backgauge forward/back;
- R backgauge vertical;
- Z1/Z2 independent finger positions.

The builder initially considered a simple HAL/Glade application without motmod, then chose full LinuxCNC specifically to reuse LinuxCNC homing and related motion infrastructure.

After community guidance, the builder created a conventional simulated XYZ kinematic shell and **six extra joints for the real machine mechanisms**. The diary explicitly says the six extra joints are the ones actually used.

For the demonstrated extra-joint command path, the builder documented this intended flow after homing:

1. UI requests/controls a target position;
2. the target is passed through a `limit3` component;
3. `limit3.out` feeds `joint.N.posthome-cmd`;
4. LinuxCNC routes the post-home command to `joint.N.motor-pos-cmd` with the joint's motor offset;
5. a PID closes the position loop against encoder feedback;
6. PID output becomes the velocity/drive command.

The builder then successfully homed the R-axis joint and corrected `HOME_OFFSET` so commanding R=0 corresponded to the desired physical/readout zero. The GUI was changed to display `joint.N.pos-fb` rather than raw encoder position, preserving LinuxCNC's homing/motor-offset coordinate semantics.

This is much closer to the intended press-brake X/R/Z problem than generic mill-style MDI.

## Official LinuxCNC documentation independently confirms the mechanism

The LinuxCNC `motion(9)` manual defines `num_extrajoints` as joints that:

- participate in LinuxCNC homing;
- are excluded from kinematics transformations;
- transfer control after homing to `joint.N.posthome-cmd`;
- must be managed by an independent motion planner/controller, typically a `limit3` component.

The manual further states that `joint.N.posthome-cmd` is ignored before homing. After homing its value is augmented by the motor offset and routed to `joint.N.motor-pos-cmd`.

This produces a very important architectural property for first-stage backgauge typed positioning: **the post-home command pin itself supplies a hard reference boundary.** A UI may hold or calculate a target before homing, but motmod does not use that value as the extra-joint motor command until the joint is homed.

## Consequence for typed positioning

For a backgauge axis represented as an extra joint, do **not** force the ordinary-coordinate MDI/G53 design onto it merely because MDI is convenient in Python.

The higher-fidelity candidate architecture is instead:

`typed target -> application ownership/range validation -> bounded planner (e.g. limit3) -> joint.N.posthome-cmd -> LinuxCNC motor-pos-cmd -> position controller/drive`

This preserves:

- LinuxCNC homing and motor-offset coordinate handling;
- a machine-specific axis that does not need to participate in toolpath kinematics;
- independent velocity/acceleration limiting through the post-home planner;
- direct HMI ownership suitable for X/R/Z-style dimensional entry;
- compatibility with PB-BG-001's explicit owner/revocation state machine.

It also means `G53`, work offsets, interpreter modal state and MDI mode do not need to be involved in ordinary manual backgauge entry for that topology.

## Critical limitation: extra-joint motmod does not supply normal post-home following-error authority

The LinuxCNC documentation is explicit that extra joints use independent post-home motion planners/controllers. Prior 3600 source work has already established that ordinary motmod following-error semantics are not equivalent after homing for extra joints.

Therefore the extra-joint topology requires application/HAL ownership of at least:

- planner target and completion;
- target-versus-feedback plausibility;
- drive fault;
- stall/no-motion-under-command supervision;
- post-home travel/range enforcement appropriate to the planner;
- fault latching/reconciliation;
- non-replay of an interrupted target.

The Ursviken diary supplies a real warning: a bad encoder reading allowed the R joint to drive into a hard stop while motor effort remained at maximum. The builder proposed command-effort-versus-velocity timeout logic after that event. This is field evidence that `posthome-cmd` convenience does not eliminate independent feedback/stall supervision.

## Completion witness for an extra-joint typed move

A `limit3`-style target planner must not mark a typed move complete merely because the operator target has been copied to its input.

A future PB-BG-002 contract should require a conjunction such as:

1. joint is homed/reference-valid;
2. typed target is within the commissioned application range;
3. exclusive `TYPED_MOVE` ownership is active;
4. planner output has converged to the requested target;
5. valid joint/encoder feedback is within commissioned tolerance of the target;
6. velocity/drive/stall supervision is healthy;
7. no revocation occurred during the episode.

Numeric tolerances remain machine-specific and must not be invented in the generic curriculum.

## Jog versus typed target with extra joints

The HMI should preserve the user-facing behavior established earlier:

- press/hold arrow = jog owner;
- typed number = typed-position owner;
- home = homing owner;
- later bend sequence = program owner.

But for an extra joint the internal implementation can share one bounded post-home planner rather than switching the backgauge into LinuxCNC MDI mode. The owner state chooses whether the planner target is advanced continuously for jog or assigned an absolute typed target.

The exact jog-generation method still needs to be frozen before implementation so a held button cannot accidentally become a queue of stale absolute targets.

## Architecture comparison after this search

| Surface | Ordinary coordinate | Extra joint |
|---|---|---|
| Homing | LinuxCNC homing, MDI normally all-homed gated | LinuxCNC homes extra joint; `posthome-cmd` ignored pre-home |
| Typed target | `G53` MDI is a documented Python option | direct post-home target through independent bounded planner |
| Work offsets | must explicitly use G53 | not part of interpreter coordinate offsets |
| Planner | coordinated trajectory planner | independent planner, typically `limit3` |
| Normal kinematics | yes | intentionally no |
| Natural fit for X/R/Z press-brake mechanisms | possible | public Ursviken implementation specifically chose this |
| Completion/fault supervision | Task/motion plus independent feedback checks | application/HAL planner + independent feedback/drive/stall checks |

## Decision

**Do not freeze PB-BG-002 around MDI/G53 yet.** The public Ursviken source changes the architecture discriminator enough that the extra-joint path is now the leading candidate for press-brake X/R/Z manual positioning.

The MDI/G53 research remains valid and reusable for ordinary-coordinate designs, but it is conditional—not the default press-brake recommendation.

## Exact next-work checkpoint

1. Trace the pinned LinuxCNC **extra-joint post-home source path**: homing transition -> `posthome-cmd` sampling -> motor-offset addition -> `motor-pos-cmd`, and identify exactly what motmod does and does not monitor after homing.
2. Inspect `limit3` source/docs for target clamping, velocity/acceleration behavior, reset/enable semantics and completion witnesses suitable for X/R/Z typed position and hold-to-jog.
3. Locate/download the Ursviken attached config if publicly retrievable. Trace the actual R/X/Z signal names, planner placement, brake/unlock logic and any later corrections. If attachment retrieval is unavailable, classify the diary topology as COMMUNITY SOURCE/ATTACHMENT UNAVAILABLE rather than inventing unseen HAL.
4. Then freeze PB-BG-002 around the evidence-supported extra-joint planner topology with reference, range, completion, stale-target, authorization-loss, feedback/stall and reconcile gates.
5. Preserve the ordinary-coordinate MDI/G53 call-flow as an alternate architecture, not discarded work.
