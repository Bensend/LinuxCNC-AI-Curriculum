# Press-brake actuator-unavailable PID authority audit

Date: 2026-09-12
Status: **DEPENDENCY-SAFE 3600 SOURCE/DOC/COMMUNITY EVIDENCE**
LinuxCNC source revision: `8bf4605ae81042248add031e94c77300406e0413`

## Question

When a press-brake axis is physically unable to move because a brake is locked, an amplifier/valve is unavailable, or another downstream actuator condition removes authority, can stock LinuxCNC `pid` anti-windup by itself be treated as protection against sustained control effort?

## Public field evidence

LinuxCNC forum build diary:

`Ursviken Pullmax Optima 130 press brake retrofit with 4 axis backgage`

https://forum.linuxcnc.org/show-your-stuff/58003-ursviken-pullmax-optima-130-press-brake-retrofit-with-4-axis-backgage

The December 9, 2025 field report describes an R-axis with a mechanical brake. The builder reported that the brake allowed a small position drift, the position PID kept producing effort while the motor could not overcome the brake, and the DC servo motor eventually overheated and failed. The builder subsequently added automatic brake logic and then found that brake-release/servo-enable timing interacted with homing. Later posts describe a separate stalled-axis incident caused by bad encoder state/hard-stop contact and propose supervision using command effort versus observed velocity.

This is **COMMUNITY-REPORTED physical failure evidence**. It is not a controlled curriculum experiment, but it is unusually valuable because it exposes a real consequence of treating controller output as equivalent to actuator authority.

The same diary also contains intermediate configuration/component attachments during development, but the July 22, 2026 successful tandem-Y1/Y2 post still says the final configuration will be shared after loose ends are resolved. As of this audit there is still no later public post or public GitHub implementation exposing the final Y1/Y2 correction insertion, saturation path or realtime order. Intermediate attachments therefore do not satisfy the final tandem-source gap.

## Official `pid` behavior

Current LinuxCNC PID documentation states:

- `pid.N.enable = false` forces output to zero and resets internal integrators;
- `pid.N.maxoutput` limits the PID block's own output;
- while that **PID output limit** is active, the error integrator is held to prevent windup;
- a zero `maxoutput` means no output limit.

Reference:

https://www.linuxcnc.org/docs/stable/html/man/man9/pid.9.html

This documents anti-windup against the PID component's own output saturation. It does not claim awareness of a mechanical brake, downstream amplifier inhibit, valve-routing state, contactor state, hydraulic authority, or some later limiter/mux.

## Pinned-source trace

Source: `src/hal/components/pid.c`, function `calc_pid()` at revision `8bf4605ae81042248add031e94c77300406e0413`.

### Integrator authority

`calc_pid()` reads `pid->enable`. When disabled, `error_i` is reset to zero. When enabled, integration is suppressed only when the error would drive farther into `pid->limit_state`.

`limit_state` is set by the PID block's own `maxoutput` clipping branch. If `maxoutput == 0`, that clipping branch is not used. Therefore the anti-windup hold has no direct knowledge of whether the downstream actuator actually accepted the command.

### Output and saturation witness

When enabled, `calc_pid()` computes the PID/feed-forward output and applies `maxoutput`. Only this internal clipping sets `limit_state` and therefore `pid.N.saturated`, `saturated-s`, and `saturated-count`.

When disabled, output is forced to zero and `limit_state` is cleared.

**SOURCE-CONFIRMED conclusion:** stock `pid.N.saturated` is a witness for the PID component's own configured output limit, not a generic witness for final actuator saturation or loss of actuator authority.

## Call-flow / ownership consequence

For a brake-controlled or otherwise conditionally-authorized axis, the relevant chain is conceptually:

`position command -> PID -> downstream enable/brake/drive/hydraulic authority -> physical actuator -> feedback`

The PID block only sees `command`, `feedback`, its own `enable`, and its own configured limits. A downstream brake or amplifier inhibit can therefore leave the PID enabled while physical authority is absent unless machine-specific HAL/component logic explicitly couples the authority state back into controller enable/reset/fault handling.

This is the same architectural boundary exposed by the earlier PB-PREP-001 result: upstream PID saturation cannot substitute for a witness of downstream final-side saturation/authority.

## Failure-mode classification

### Case A — PID disabled when actuator authority is absent

Pinned source resets the integrator and forces output to zero. This is a strong ordinary-control containment behavior, assuming the authority predicate itself is correct and timely.

### Case B — PID remains enabled, finite `maxoutput` reached

The PID's own anti-windup stops further integration in the direction of its internal output limit. This limits one form of windup, but still does not prove the physical actuator is moving, available, or safe.

### Case C — PID remains enabled, downstream actuator is blocked before PID's own limit is reached

Nothing in stock `pid.c` detects the downstream block. Position error can persist while the controller continues to demand effort. This is the field-failure shape reported in the Ursviken R-axis incident.

### Case D — downstream limiter/driver saturates below PID `maxoutput`

`pid.N.saturated` may remain false because its witness is upstream of the actual final limitation. Final-command/authority supervision must therefore be separately observable if the application depends on it.

## Design lesson for 3600

A press-brake playbook should not teach "PID anti-windup protects a stalled/locked actuator." The defensible generic rule is:

1. model actuator authority explicitly;
2. revoke/reset controller authority when the actuator is deliberately unavailable where the architecture requires that behavior;
3. retain separate final-command/drive/feedback/stall witnesses for faults that occur after the PID output;
4. do not use `pid.N.saturated` as a proxy for a locked brake, disabled amplifier, closed hydraulic path, hard stop, or final-side saturation;
5. treat exact timing, thresholds and safety response as machine-specific commissioning/safety work.

This is ordinary-control guidance, not a functional-safety claim.

## Adversarial checks

**Misleading premise:** "If `pid.N.saturated` is false, the actuator cannot be stalled."  
Reject. `saturated` only reports the PID component's own `maxoutput` limit state.

**Misleading premise:** "A finite `maxoutput` means a locked brake is harmless."  
Reject. It bounds controller output; it does not prove motor thermal safety, brake release, hydraulic flow, drive enable, or motion.

**Recovery question:** after an actuator-authority fault clears, should a stale PID integral be trusted automatically?  
No generic press-brake claim is justified. Stock `pid` resets its integrator when disabled, so a design that deliberately disables the loop on authority loss gets a known reset behavior. If a machine-specific architecture keeps the PID enabled, recovery semantics must be specified and verified separately.

## Information-gain decision

No new laboratory simulation is justified for this question. The combination of a real field failure, official component semantics and pinned source directly resolves the generic ownership boundary. A toy motor/brake model would add model assumptions rather than LinuxCNC-specific evidence.

## Remaining uncertainty / promotion

- Exact final Ursviken Y1/Y2 HAL/component source remains unavailable after the bounded September 12 re-check.
- The intermediate December/February attachments prove source/config work existed during development but do not expose the mature July synchronization topology.
- Motor thermal limits, brake timings, stall thresholds, drive-fault behavior and hydraulic authority are machine-specific and must not be generalized from this field case.
- Functional-safety behavior remains outside the evidence provided here.

## Next checkpoint

Keep the generic 3600 information-gain stop. Re-open the tandem branch only if the final downloadable Ursviken configuration or another mature tandem source appears. Re-open actuator-unavailable PID analysis only if a concrete implementation exposes a downstream authority/saturation ambiguity not resolved by this source trace.
