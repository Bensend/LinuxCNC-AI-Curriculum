# IO07 graduation handoff — hardware enable and fault patterns

Status: **GRADUATED** at 1000-level scope.  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

## What a fresh AI must know

IO07 separates five layers that are easy to conflate:

1. LinuxCNC motion/joint enable intent (`motion.motion-enabled`, `joint.N.amp-enable-out`).
2. Downstream output-module/remote enable commands (PWMGen, Smart Serial, stepgen, etc.).
3. External amplifier/drive fault reporting into `joint.N.amp-fault-in`.
4. HostMot2 watchdog/LLIO communication state (`watchdog.has_bit`, `io_error`, reset/recovery state).
5. Independent physical safety functions such as drive STO, safety relays/controllers, contactors, and machine E-stop architecture.

A correct diagnosis must identify which layer supplied the evidence before claiming what happened.

## Source-confirmed representative fault path

At the pinned revision, one `emcmotController()` invocation orders the relevant stages as:

`process_inputs()` → `check_for_faults()` → `set_operating_mode()` → … → `output_to_hal()`.

For an active+enabled joint, `process_inputs()` samples `joint.N.amp-fault-in`. `check_for_faults()` detects that fault, reports it, marks error state, and clears desired enabling. `set_operating_mode()` disables active joints/motion. `output_to_hal()` publishes the resulting disabled HAL state, including `joint.N.amp-enable-out=FALSE` and `motion.motion-enabled=FALSE`.

This is LinuxCNC machine-control logic. It is not itself STO.

## Test-confirmed behavior

Accepted run `34076164338`, artifact `linuxcnc-lab-010-io07-amp-fault-disable-34076164338-1`, used a realtime servo-thread sampler after the motion controller.

From a verified enabled baseline it injected a sole-writer fault signal into `joint.0.amp-fault-in`. The 500-sample capture reported zero overruns and contained:

- 34 clean enabled baseline cycles;
- 466 cycles with injected fault high;
- 465 cycles with `faulted=1`, `motion-enabled=0`, `amp-enable=0`;
- 2 cycles that additionally captured transient `joint.error=1`;
- 463 later cycles with `faulted=1`, disabled motion/amp enable, but `joint.error=0`.

The LinuxCNC error channel also reported `ERROR joint 0 amplifier fault`.

Therefore the software/HAL fault-disable path is **TEST-CONFIRMED for the pinned simulation**.

## Important correction from the lab

`joint.N.error` is not a reliable late userspace polling oracle for the fault transition. The corrected realtime capture proved that the error bit can be present during the disable transition and absent later while `joint.N.faulted` and the disabled state remain.

Use a cycle-synchronous capture when the claim concerns transient realtime state.

## What is explicitly not proven

Do not infer any of these from IO07:

- a fresh HostMot2 command reached hardware;
- a drive-enable terminal changed voltage;
- a drive removed current or torque;
- STO engaged;
- torque removal occurred within one servo period;
- a safety function meets a required PL, SIL, category, stop time, or diagnostic coverage.

Those require transport/hardware evidence and, for safety claims, suitable certified components plus a machine-specific safety/risk analysis and validation.

## Failure-debugging decision tree

When an actuator unexpectedly disables:

1. Determine whether LinuxCNC motion disabled and whether `joint.N.faulted/error` changed.
2. Determine whether `joint.N.amp-fault-in` was actually asserted and fresh.
3. Check HostMot2/transport/watchdog state independently.
4. Trace the downstream module/remote enable command.
5. Only then diagnose electrical drive enable, STO, power stage, and physical motion/torque behavior.

When an actuator appears to remain energized after LinuxCNC disables, reverse the trace: prove the software output, prove fresh transport delivery, prove physical drive input/output response, and keep safety validation separate.

## Promotion queue handed forward

- Combined amp-fault + HostMot2 `io_error`/watchdog/stale-feedback injection: **S03/S06/2000 / HIGH**.
- Command-to-physical-torque disable reaction time: **2000 + commissioning / CRITICAL**.
- Drive-specific fault reset and STO semantics: **safety/commissioning / CRITICAL**.

## Fresh-AI handoff test

A fresh AI passes IO07 if, without relying on conversational context, it can answer all of these from the durable artifacts:

- why `amp-enable-out=FALSE` does not prove zero torque;
- why LLIO `io_error` is not automatically `amp-fault-in`;
- why the accepted lab used realtime sampling;
- what the two `exact_fault_cycle` samples establish;
- why the red workflow badge did not invalidate the zero-exit lab;
- which claims must move into S01/S03/S06 or commissioning.

The durable guide, call flow, accepted experiment result, and adversarial correction key contain enough information to answer those questions without hidden session context. IO07 therefore satisfies the course handoff criterion at its intended level.
