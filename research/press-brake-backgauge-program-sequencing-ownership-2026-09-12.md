# Press-brake backgauge — bend-program sequencing ownership

Date: 2026-09-12
Course context: dependency-safe 3600 preparation while F02 final fresh-AI transfer remains information-separated
Pinned source baseline for prior source conclusions: LinuxCNC `8bf4605ae81042248add031e94c77300406e0413`

## Question

After establishing extra-joint homing, post-home command ownership, and PB-BG-003 episode-safe completion, determine the clean ownership boundary for a future press-brake bend-program sequencer. Specifically: should X/R/Z-style backgauge mechanisms be treated as ordinary coordinated G-code axes, or as independently planned extra-joint targets owned by the press-brake application?

## Documentation findings

Current LinuxCNC `motion(9)` documentation explicitly defines extra joints as joints that participate in homing but are not used by kinematics transformations. After homing, their control transfers to `joint.N.posthome-cmd`; motor feedback is ignored by LinuxCNC motion and independent planners/controllers are required, with `limit3` identified as a typical choice.

This makes the ordinary extra-joint architecture materially different from a Cartesian coordinate managed by LinuxCNC's trajectory planner. A program sequencer that chooses to use the extra-joint architecture should therefore not pretend those mechanisms are automatically synchronized members of a G-code XYZABCUVW move.

`switchkins` provides a different mechanism: a configuration can deliberately switch kinematics so individual joints are manipulated using coordinate letters. That is a distinct architecture requiring explicit kinematics switching and interpreter/motion synchronization. It is not evidence that ordinary extra joints are coordinates by default.

Evidence classification: **DOC-CONFIRMED** for the architectural distinction.

## Community field evidence

The Ursviken/Pullmax press-brake build diary provides a concrete field design consistent with the documented extra-joint ownership boundary. The builder describes the UI triggering homing, using `joint.5.homed` to enable `limit3`, sending the UI's requested position into `limit3.in`, and feeding `limit3.out` to `joint.5.posthome-cmd`, followed by a PID/drive path. The builder explicitly describes this as enabling "program control" of the servo after homing.

This is useful **COMMUNITY-REPORTED** evidence that a press-brake application can own post-home backgauge targets above an independent planner. The inspected material does not provide a complete downloadable final bend-program sequencer or prove a canonical step-advance algorithm.

## Sequencer ownership contract

For the extra-joint architecture studied here, keep three layers distinct:

1. **Bend-program layer** — owns the ordered bend-step recipe and the requested target set for the current step (for example whichever X/R/Z mechanisms are actually present).
2. **Backgauge target/episode layer** — validates the requested target set, starts a new application-owned generation/episode, sends each mechanism's target to its independent bounded planner/controller, and publishes coherent current-episode completion/fault state.
3. **LinuxCNC extra-joint layer** — owns homing/reference lifecycle and the `posthome-cmd -> motor-pos-cmd` handoff, but does not make the extra mechanisms coordinated G-code coordinates merely because their numeric positions are visible in HAL.

The program layer should advance from bend step `k` to `k+1` only from a completion object that belongs to the **same current target-set episode**. Numeric equality alone is not sufficient, especially when consecutive bends reuse one or more identical gauge positions.

## Multi-mechanism completion identity

A future X/R/Z target set should receive one parent `target_set_generation`. Each participating mechanism may retain its own internal command generation, but the sequencer should not declare the step ready until every required mechanism reports completion associated with the current parent generation.

Conceptually:

`bend step k -> target_set_generation G -> {X target, R target, Z... target}`

then:

`ready_for_step(G) = all required mechanisms complete for G AND reference/authority/fault policy valid for G`

This is an architecture contract, not a claim that a specific HAL component already exports such a generation token. PB-BG-003 demonstrates why an application-owned identity witness is useful when numeric targets can repeat.

## Interruption and reconciliation

The sequencer should distinguish **recipe identity** from **motion authority**. Losing reference, ordinary authorization, drive/feedback validity, or another required completion witness should invalidate readiness for the current target-set generation. When raw health returns, the application should reconcile the mechanism state rather than automatically advancing the bend recipe because the displayed positions happen to match.

A conservative software workflow is:

`step selected -> validate target set -> authorize new generation -> planners move -> coherent completion for generation -> operator/process layer may proceed`

On invalidation:

`generation invalid -> hold/reconcile -> verify reference and mechanism state -> explicitly reissue or create a new generation -> reacquire completion`

Whether actual bending may commence also depends on press-cycle and safeguarding conditions outside the backgauge completion contract. This document does not define or replace those conditions.

## Consecutive identical targets

A useful adversarial case is two successive bend steps whose X value is identical while R or another gauge value changes—or where the complete target set is identical but the recipe step is still logically new. A purely numeric `X_at_position` latch can look valid before the new step has been authorized. Parent generation identity prevents the previous step's completion from being misinterpreted as proof that the new step has executed.

Therefore recipe-step identity and target-set generation should be explicit even when no mechanism needs to move.

## Alternative architecture boundary

Do not universalize this design. A machine could intentionally model a mechanism through coordinated/identity/switchable kinematics and command it through G-code/MDI. If that architecture is chosen, its interpreter, trajectory, limit, interruption and synchronization semantics must be traced separately. The current evidence supports extra-joint/application ownership for the studied press-brake backgauge pattern; it does not prohibit other LinuxCNC architectures.

## Evidence ledger

| Claim | Classification | Evidence / boundary |
|---|---|---|
| Extra joints are not kinematic coordinates and transfer to post-home command control | DOC-CONFIRMED + prior SOURCE-CONFIRMED | LinuxCNC `motion(9)` plus pinned motion/control traces |
| A press-brake UI can feed `limit3 -> posthome-cmd` after homing | COMMUNITY-REPORTED | Ursviken/Pullmax build diary; not a canonical implementation |
| A bend-program sequencer should own target-set/recipe generation above independent extra-joint planners | INFERENCE supported by PB-BG-003 | architectural recommendation; no claim LinuxCNC natively supplies the generation ID |
| Step advance should require completion belonging to the current target-set generation | TEST-GROUNDED INFERENCE | PB-BG-003 validates stale-completion discriminator for a single abstract mechanism; multi-mechanism aggregation is not yet experimentally tested |
| Functional safety or permission to initiate a physical bend follows from backgauge completion | **NOT ESTABLISHED** | explicitly outside this ordinary-control contract |

## Investigation decision

No immediate motor or hydraulic simulation is justified. The next information-bearing experiment, if the F02 gate remains external, would be a small pure-software **multi-mechanism target-set generation** contract: repeated/partially repeated X/R/Z targets, one mechanism completing late, invalidation of one mechanism after others complete, and reconciliation without stale step advance. It should test aggregation/identity semantics only.

Before freezing that experiment, first inspect any public press-brake UI/config source that exposes an actual bend-step/backgauge recipe interface. If no inspectable final sequencer source is available after a bounded search, preserve SOURCE UNAVAILABLE rather than inventing UI behavior.

## Critical-path note

This is dependency-safe 3600 preparation. It does not change the fact that full 2000-series closure still awaits the genuinely information-separated F02 fresh-AI handoff. The current learner must not self-score that packet.
