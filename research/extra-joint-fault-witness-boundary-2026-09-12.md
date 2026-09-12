# Extra-joint fault-witness boundary for press-brake backgauges

Date: 2026-09-12
Status: **SOURCE-CONFIRMED 3600 SUPPORTING TRACE**
Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`

## Question

After a press-brake X/R/Z-style mechanism is modeled as a homed LinuxCNC extra joint and motion ownership transfers to `joint.N.posthome-cmd`, which ordinary MOTMOD fault witnesses still retain meaning?

## Pinned source result

`src/emc/motion/control.c::process_inputs()` explicitly distinguishes homed extra joints from ordinary kinematic joints when calculating following error:

- if `IS_EXTRA_JOINT(joint_num)` and the joint is homed, `joint->ferror` is forced to zero with the source comment `not relevant for homed extrajoints`;
- otherwise following error is `pos_cmd - pos_fb` and is checked against the normal velocity-scaled/floor limit;
- in the same per-joint input pass, hard-limit states are still read;
- `joint.N.amp-fault-in` is still read and mapped to the joint fault flag.

Later, `check_for_faults()` independently trips enabled active joints for amplifier fault, hard limit, or following error. Because homed extra-joint ferror is deliberately zero, the MOTMOD following-error branch cannot be treated as post-home tracking/stall supervision for an extra-joint backgauge.

## Consequence for press-brake backgauge architecture

For a homed extra joint driven from an external bounded planner through `posthome-cmd`:

- LinuxCNC still provides reference state and motor feedback surfaces;
- hard-limit inputs remain meaningful;
- amplifier fault input remains meaningful if machine hardware/HAL drives it;
- ordinary MOTMOD following error is intentionally not a tracking witness after homing.

Therefore production `at-position`, stall, tracking-error and downstream-authority supervision must come from the external controller/planner/drive-feedback architecture rather than assuming MOTMOD will trip on post-home extra-joint tracking disagreement.

This directly supports the existing PB-BG contract requiring an independent completion witness and application-owned command episode identity.

## Important distinction

`joint.N.amp-fault-in` is not a substitute for a tracking-error monitor. It tells MOTMOD that the amplifier/drive fault input is asserted. A drive may be enabled and non-faulted while the mechanism is mechanically blocked, slipping, incorrectly scaled, or otherwise failing to follow the external command.

Conversely, a machine-specific external supervisor may legitimately derive a drive/stall fault and feed that into a suitable fault path, but the threshold, persistence time and physical meaning are machine-specific and are not supplied by stock MOTMOD for homed extra joints.

## Field-evidence connection

The Ursviken backgauge diary includes a real stalled/locked-axis history. Combined with the source rule above, this is a strong warning against designing a post-home extra-joint mechanism around the assumption that ordinary LinuxCNC following error will protect it.

## Adversarial checks

**Premise:** "A homed extra joint still has `joint.N.f-error`, so MOTMOD will stop it if `posthome-cmd` is not followed."  
Reject. Pinned source explicitly forces `ferror = 0` for homed extra joints.

**Premise:** "If `amp-fault-in` remains false, tracking is therefore valid."  
Reject. Amplifier fault and tracking validity are distinct witnesses.

**Premise:** "The external planner's target equals encoder position once, therefore the move is complete."  
Reject. Completion must remain bound to the current command episode and whatever convergence/validity criteria the external architecture defines.

## Curriculum consequence

The 3600 backgauge playbook should show a post-home extra-joint fault matrix with at least separate columns for:

- homed/reference validity;
- hard limits;
- amplifier/drive fault;
- external command episode validity;
- external tracking/convergence error;
- downstream actuator readiness/authority where observable;
- stale/frozen feedback detection;
- completion/at-position.

Do not label ordinary `joint.N.f-error` as the post-home extra-joint tracking monitor.

No laboratory job is needed for this narrow question because the behavior is an explicit source branch, already consistent with the previously tested PB-BG ownership fixtures. A new lab would mostly re-encode the source condition rather than add independent information.
