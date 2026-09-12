# Press-brake 3600 — GaugePlan boundary and LinuxCNC `limit3`

Date: 2026-09-12
Status: SOURCE / COMMUNITY / ARCHITECTURE NOTE
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Question

After PB-DXF-002 produces an accepted BendStep, what should the next human-selected GaugePlan layer own, and what does the public extra-joint/`limit3` pattern actually guarantee?

## Community evidence

Two public LinuxCNC press-brake discussions support a deliberately staged first implementation:

- the full-GUI discussion separates a bend-program table from a basic editor that enters per-bend go-to positions, while treating a later geometry/tooling editor as a richer future layer;
- the Ursviken/Pullmax diary reports an extra-joint pattern where the UI feeds a requested position into `limit3`, whose output feeds `joint.N.posthome-cmd` after homing.

These are COMMUNITY-REPORTED architecture/workflow observations, not generic proof that the same mapping is correct for every press brake.

## Pinned source: `limit3.comp`

At the pinned revision, `src/hal/components/limit3.comp` exports:

- `in` requested position;
- `out` bounded position;
- `min` / `max` position constraints;
- `maxv` and `maxa` dynamic constraints;
- `load`, which can immediately set output to input while ignoring velocity/acceleration limits;
- `enable`.

The component computes a bounded position trajectory so its output follows the input while respecting position, velocity and acceleration limits. It is therefore suitable as a **command-shaping/planning primitive** in the observed extra-joint pattern.

### Important enable semantic

`enable == 0` does **not** mean "freeze last valid command". The source explicitly substitutes an input value of zero, causing the output to return toward zero while still obeying its constraints.

Therefore an application must not treat `limit3.enable` as a generic ordinary-control authorization latch without deliberately accepting that zero-return behavior.

In the already traced extra-joint path, `joint.N.posthome-cmd` gains ordinary post-home command authority only while the joint is homed. This can prevent an unhomed joint from following the changing `limit3.out`, but it does not change `limit3`'s own internal/output evolution. On re-establishing reference, the application still needs current command/episode ownership and must not treat an old `limit3.out` value as proof of a valid current GaugePlan.

## GaugePlan ownership

For the first-stage press-brake UI, a GaugePlan should own the human-confirmed **relationship between a BendStep and the part datum/contact concept used for gauging**, not LinuxCNC planner internals.

Minimum conceptual fields:

- stable `gauge_plan_id`;
- bound current `step_id`, `bend_id`, and source revision;
- selected source datum/edge/surface identity and provenance;
- participating gauge mechanisms;
- operator confirmation state;
- plan revision/generation;
- explicit invalidation/review reason;
- target-calculation method/provenance once that calculation is introduced.

A GaugePlan should become `REVIEW_REQUIRED` or `INVALID` when its BendStep becomes stale/invalid, when its selected datum disappears or changes on reimport, or when the mechanism set changes incompatibly.

## What this layer must not infer

An accepted BendStep plus a selected gauging datum does not by itself establish:

- the correct numeric X/R/Z target;
- whether a flange already formed requires compensation;
- tooling suitability;
- collision freedom;
- finger contact geometry;
- bend allowance/deduction or springback correction;
- machine reachability;
- physical backgauge location;
- safety-rated authorization.

The LinuxCNC `limit3` component likewise does not validate any of those semantics. It shapes the numeric command it is given.

## Data/control boundary

The intended staged ownership is:

`ImportedPart -> BendFeature -> BendStep -> GaugePlan -> target calculation -> TargetSet episode -> bounded mechanism planner/controller -> posthome-cmd`

Each arrow must preserve provenance. A downstream numeric target must remain explainable in terms of the accepted step, selected gauging datum, calculation method and target-set generation.

## Source-grounded failure note

Because `limit3.enable=0` returns its output toward zero, using that pin as a generic "authorization off" signal can create hidden command-state evolution even while downstream physical authority is absent. A robust design therefore separates:

1. recipe/GaugePlan validity;
2. target-set episode/rearm authority;
3. numeric trajectory shaping (`limit3` or equivalent);
4. extra-joint post-home physical command authority.

This is the same general lesson established earlier in F02 and backgauge work: recovery/green lower-layer state is not equivalent to renewed motion authorization.

## Next evidence target

Do not simulate motor physics. The next useful 3600 step is a small GaugePlan provenance/invalidation contract or source integration that tests datum ownership across recipe reorder/reimport, then separately research the **target calculation** problem (commercial/open-source bend deduction and gauging-surface concepts) before generating numeric machine targets.

## Evidence boundary

SOURCE-CONFIRMED: exact `limit3` signal/limit/enable behavior at pinned revision.
COMMUNITY-REPORTED: public press-brake extra-joint and editor architecture examples.
INFERENCE/DESIGN CONTRACT: proposed GaugePlan fields and ownership separation.
No physical-machine, collision, tooling, target-accuracy or functional-safety claim is made.
