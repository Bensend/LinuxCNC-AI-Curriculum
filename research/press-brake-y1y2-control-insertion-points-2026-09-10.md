# Generic Y1/Y2 differential-control insertion-point trace — 2026-09-10

## Scope

Continuation of `research/press-brake-y1y2-source-grounding-2026-09-10.md` at pinned LinuxCNC revision:

`8bf4605ae81042248add031e94c77300406e0413`

This artifact answers a narrower architecture question: if an explicit Y1/Y2 differential synchronization controller is eventually required, what changes depending on whether correction is inserted before the ordinary PID loops, after PID output, or by replacing the two independent PIDs with one joint-aware two-channel controller?

This is generic software/control research only. It is not a machine-specific valve command, tuning recommendation, or functional-safety design.

## Reference servo chain from pinned LinuxCNC examples

Pinned `configs/by_interface/mesa/hm2-servo/hm2-servo-eth.hal` gives a concrete ordinary position-servo chain:

1. `hm2_*.read` executes first in `servo-thread`.
2. `motion-command-handler` executes.
3. `motion-controller` executes.
4. each `pid.N.do-pid-calcs` executes.
5. `hm2_*.write` executes last.

Per joint, the example wires:

```text
encoder position --------------------------> pid.N.feedback
        |----------------------------------> joint.N.motor-pos-fb

joint.N.motor-pos-cmd ---------------------> pid.N.command
pid.N.output ------------------------------> hm2_*.pwmgen.N.value
joint.N.amp-enable-out --------------------> pid.N.enable
        |----------------------------------> hm2_*.pwmgen.N.enable
```

The pinned Woodpecker simulation contains the same logical split for velocity-mode stepgen: motion position command -> per-joint PID -> hardware-facing velocity command, with hardware position feedback returned to both the PID and `joint.N.motor-pos-fb`.

Classification: SOURCE-CONFIRMED for the pinned examples; these are architecture examples, not mandatory wiring for every machine.

## Important motion-side invariant

Pinned `control.c::process_inputs()` independently reads every active `joint.N.motor-pos-fb`, derives that joint's `pos_fb`, and computes motion's own following error against **motion's `joint->pos_cmd`**:

```text
joint ferror = joint pos_cmd - joint pos_fb
```

That calculation is not based on `pid.N.command`, `pid.N.error`, or `pid.N.output`.

Pinned `control.c::output_to_hal()` then writes `joint.N.motor-pos-cmd` from motion's per-joint target plus motion-owned backlash/motor-offset terms.

This creates two separate error domains in a conventional HAL servo:

- **motion following error:** motion joint target versus returned joint feedback;
- **PID error:** whatever signal HAL supplies to that PID instance as command minus its feedback.

They are identical only when the PID command is exactly the motion motor-position command and both consume the same effective position reference/feedback convention.

## Candidate insertion point A — adjust each PID position reference

Conceptual wiring:

```text
joint.Y1.motor-pos-cmd --+--> differential reference builder --> Y1 pid.command
joint.Y2.motor-pos-cmd --+--> differential reference builder --> Y2 pid.command
Y1/Y2 feedback ----------+
```

For duplicated Y coordinates, the two nominal motion targets are normally equal. A symmetric corrector could create equal/opposite bounded reference biases from `Y1_fb - Y2_fb`.

### Advantages

- The ordinary per-side PID still sees the actual corrected position reference, so its proportional/integral/derivative and feed-forward machinery operate on the commanded corrected trajectory.
- Hardware-facing effort remains entirely downstream of each PID's own output limit, making the local PID's saturation state more meaningful than with an unseen post-PID summing term.
- The correction can be made explicit and observable as a position-domain quantity.

### Crucial consequence

Motion still calculates its following error against its own unmodified `joint->pos_cmd`. Therefore an intentional reference bias that moves a side away from the nominal duplicate target appears to motion as real per-joint tracking error.

That is not automatically bad: it can provide an independent authority bound. But it means correction amplitude, duration and direction cannot be designed independently of `[JOINT_N]` following-error policy.

### Failure/adversarial case

Suppose the synchronization corrector requests a large Y2 offset to chase Y1. PID Y2 may be correctly tracking the adjusted reference while motion sees Y2 departing its nominal joint target and asserts following error. Calling that a false trip without analysis would be wrong: the correction has genuinely consumed part of the motion-level tracking-error budget.

**Disposition:** technically coherent candidate; requires explicit correction limits and an experiment checking interaction with motion ferror.

## Candidate insertion point B — add differential effort after each PID

Conceptual wiring:

```text
pid.Y1.output --+--> effort summer/limiter --> hardware Y1 command
sync effort ----+

pid.Y2.output --+--> effort summer/limiter --> hardware Y2 command
-sync effort ---+
```

### Apparent attraction

- The position-loop reference remains the stock `joint.N.motor-pos-cmd`.
- Differential action can be expressed directly in valve/velocity/effort units.

### Major hidden-state problem

Pinned `pid.c` owns and reports its own `maxoutput`, `saturated`, integral state and anti-windup-related internal behavior based on **the PID's output**, not on a later arbitrary HAL sum.

If another component adds effort after `pid.N.output`, the physical/hardware-facing command can saturate even while `pid.N.saturated` is false. Conversely, the PID integrator can continue responding without knowing that an external differential term has consumed actuator headroom.

The example HostMot2 chain places `pid.N.output` immediately onto `pwmgen.N.value`, so inserting a post-PID summer is a real change in the saturation/authority boundary, not a transparent extension.

### Failure/adversarial case

Y1 PID requests +70% effort; differential controller adds +40%; final hardware limiter clips at +100%. If the PID only knows it requested +70%, its own saturation witness does not describe the actuator. The paired Y2 side may meanwhile receive the opposite correction and remain unsaturated. A supervisory controller that trusts only `pid.N.saturated` would miss the asymmetric authority loss.

**Disposition:** possible but high-risk for hidden saturation/anti-windup semantics unless final-command saturation is centralized and explicitly fed back into the controller design.

## Candidate insertion point C — replace the two independent PIDs with one explicit two-channel controller

Conceptual interface:

Inputs:

- nominal Y1/Y2 motion commands;
- independent Y1/Y2 feedback;
- enable/validity state;
- optional velocity/feed-forward witnesses.

Outputs:

- final bounded hardware-facing Y1 effort;
- final bounded hardware-facing Y2 effort;
- common-mode error/state;
- differential error/state;
- per-side and shared saturation/authority witnesses;
- controller-valid/fault state.

### Advantages

- Common and differential control can share one explicit saturation allocator instead of two unaware PID saturators plus a hidden summing layer.
- Anti-windup can be designed around the **actual final side commands** and remaining common/differential authority.
- The controller can expose the exact quantities needed for later diagnostics: nominal common request, differential correction, pre-limit effort, final effort, side saturation, shared authority exhaustion, encoder disagreement and validity.
- Motion's independent per-joint following-error calculation can remain in place as a separate ordinary-controller fault boundary because both physical feedbacks can still be returned to `joint.N.motor-pos-fb`.

### Cost / risk

- This is custom realtime control code rather than ordinary configuration; it therefore carries a larger verification burden.
- A custom controller must reproduce any desired PID/feed-forward behavior intentionally rather than assuming the stock `pid` component still provides it.
- Thread ordering, enable semantics, reset behavior and stale-input handling become explicit design responsibilities.

**Disposition:** strongest candidate for a deeply coupled hydraulic pair if experiments later show that shared saturation allocation matters, but too early to endorse without plant-model evidence.

## Candidate insertion point D — put feedback coupling in kinematics

Rejected as the default architecture.

Pinned `trivkins` inverse kinematics receives Cartesian pose and returns joint target positions. Its source-level role is coordinate transformation/mapping. The ordinary inverse call does not consume the live Y1/Y2 encoder feedback as the control error input for a synchronization servo.

A feedback-dependent control law hidden inside custom kinematics would also blur the established separation between coordinate mapping, motion's joint trajectory/ferror model, and the HAL actuator loops.

**Disposition:** do not use kinematics as a hidden differential servo merely because duplicate coordinates are configured there.

## Common/differential saturation problem

For two side efforts `u1` and `u2`, it is useful to reason in transformed coordinates:

```text
u_common = (u1 + u2) / 2
u_diff   = (u1 - u2) / 2

u1 = u_common + u_diff
u2 = u_common - u_diff
```

This does not define the correct hydraulic control law, but it exposes a central authority question: when one actuator reaches its final command limit, common motion and differential correction compete for the same side's remaining range.

A controller therefore needs an explicit policy rather than independent clipping that happens to produce some result. Candidate policies to compare later include:

- preserve common motion and reduce differential correction first;
- preserve differential alignment and reduce common motion first;
- reduce both according to a bounded allocator;
- withdraw ordinary motion authority when required differential correction exceeds a validated envelope.

Which policy is correct is plant- and safety-context dependent. The curriculum must not choose one from software aesthetics alone.

## Interaction with LinuxCNC following error

The source trace supports a useful independent-layer interpretation:

- Motion ferror asks: **Did this physical joint remain sufficiently close to the trajectory LinuxCNC says that joint should follow?**
- A differential synchronizer asks: **Did the two physical sides remain sufficiently related to each other, and what bounded correction is permitted?**

These checks overlap but are not equivalent. A common-cause shift can leave Y1-Y2 difference small while both sides are wrong relative to the nominal trajectory. Conversely, a bounded symmetric differential correction can intentionally create side deviations relative to the common nominal target.

Therefore a later design should retain both absolute/per-joint tracking witnesses and differential disagreement witnesses.

## Thread-order consequence

Pinned HostMot2 Ethernet servo example orders:

```text
hm2 read
motion command handler
motion controller
pid calculations
hm2 write
```

An eventual synchronization function that consumes fresh encoder feedback and influences the same cycle's hardware write must be deliberately placed relative to motion and the per-side controller. Its placement determines whether it uses the encoder values just read this cycle, whether motion has already updated nominal targets/ferror state, and whether its correction reaches the current `hm2.write`.

Any timing claim must be verified with same-cycle realtime instrumentation; sequential userspace reads are insufficient, as established earlier by C01/X01/X02.

## Recommended experiment sequence once dependency gate permits

### Experiment 1 — reference-bias architecture

Use duplicated Y, separate synthetic plants and two stock PID loops. Insert a bounded equal/opposite **position-reference** correction before PID command. Sweep a B-only plant asymmetry and correction limit. Record atomically:

- nominal Y1/Y2 motion command;
- adjusted PID commands;
- Y1/Y2 feedback;
- PID errors/outputs/saturation;
- motion per-joint ferror and limits;
- differential error;
- final plant commands.

Primary question: does useful differential correction consume motion ferror margin predictably, and can a defensible bound be stated?

### Experiment 2 — post-PID effort architecture

Repeat the same plant/disturbance with correction summed after stock PID. Add an explicit final per-side limiter and retain both PID saturation and final-command saturation witnesses.

Primary question: can the architecture avoid hidden actuator saturation and integrator conflict, or does it require enough feedback plumbing that a joint controller is cleaner?

### Experiment 3 — explicit two-channel controller

Implement a minimal realtime common/differential controller with a single final authority allocator. Compare against Experiments 1 and 2 using frozen identical plant disturbances and metrics.

Primary question: is the added implementation complexity justified by materially better bounded behavior/observability under asymmetric saturation?

Do not use physical hydraulic hardware for these curriculum experiments.

## Adversarial conclusions

1. **Same duplicated target is not a synchronization loop.** SOURCE + C01/C02/D01 evidence agree.
2. **Pre-PID correction is visible to the side PID but not to motion's nominal command.** Therefore motion ferror can act as an independent bound, but must be included in design.
3. **Post-PID correction can make stock PID saturation state incomplete.** Final actuator authority must be independently represented.
4. **A custom two-channel controller improves explicit shared saturation semantics but raises verification burden.**
5. **Kinematics is not the natural place to hide a live feedback servo.**
6. **No software placement result here establishes safety-rated behavior or a correct hydraulic control law.**

## Exact next checkpoint

The source-side architecture question is now narrow enough for an experiment contract. The next useful unblocked task is to draft/freeze a **software-only comparative experiment specification** for the three insertion architectures, including a synthetic two-side plant, identical disturbances, final-effort saturation, frozen metrics/gates, X01-valid recorder-health criteria, and explicit failure/no-verdict classifications. Do not execute paid compute until the experiment provides information not already established by C02/D01, and do not let it activate F02 or substitute for the four pending fresh-AI handoffs.
