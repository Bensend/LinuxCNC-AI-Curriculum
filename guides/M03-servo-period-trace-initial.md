# M03 initial research — one servo-period trace

Status: RESEARCH/SOURCE entry point

Pinned LinuxCNC development revision: `8bf4605ae81042248add031e94c77300406e0413`

Stable behavior must be checked separately before any version-general claim.

## Documentation baseline

Official LinuxCNC documentation describes `motmod` as the realtime motion component and identifies two HAL functions normally added to the servo thread in this order:

1. `motion-command-handler` — receive/process incoming motion commands.
2. `motion-controller` — run the LinuxCNC motion controller.

The motion man page explicitly says these functions are generally added to the servo thread in the order shown. The INI documentation identifies `SERVO_PERIOD` as the servo task period (commonly 1,000,000 ns in examples, configuration-dependent). Core-component documentation says joint/axis pins are read/updated by `motion-controller`.

Useful official references:

- `https://linuxcnc.org/docs/master/html/man/man9/motion.9.html` (language variants may differ)
- `https://linuxcnc.org/docs/html/code/code-notes.html`
- `https://linuxcnc.org/docs/html/config/ini-config.html`

Evidence: **DOC-CONFIRMED** for documented intended roles, not yet a complete cycle.

## Community/field configuration pattern

LinuxCNC forum configurations repeatedly place hardware input/read functions before motion calculation and hardware output/write functions after motion/PID calculation. A representative EtherCAT discussion explicitly advises moving the fieldbus read before `motion-command-handler`/`motion-controller` so motion uses values read in that cycle. Mesa examples similarly appear as:

`hardware read -> motion-command-handler -> motion-controller -> PID -> hardware write`

Representative field references:

- LinuxCNC Forum, “Rookie: Ethercat Servos wont budge...” (2021), where execution order/read-before-motion is discussed.
- LinuxCNC Forum Mesa configurations showing `hm2_*.read`, motion functions, PID, then `hm2_*.write`.

Evidence: **COMMUNITY-REPORTED**. These are valuable topology leads, not proof that every machine must use the exact same chain.

## Source: motmod creates the servo thread but exports rather than auto-schedules motion functions

Pinned `src/emc/motion/motion.c`, `init_threads()`:

1. If base/traj periods are omitted, defaults are derived from the servo period.
2. Servo period is rounded to an integer multiple of the base period.
3. `hal_create_thread("servo-thread", servo_period_nsec, 1)` creates the floating-point HAL servo thread.
4. `hal_export_funct("motion-controller", emcmotController, ...)` exports the controller.
5. `hal_export_funct("motion-command-handler", emcmotCommandHandler, ...)` exports the command handler.
6. `setServoCycleTime()` and `setTrajCycleTime()` seed internal cycle-time state.

Crucial H04-to-M03 boundary: `init_threads()` does **not** itself `addf` these two exported functions. HAL configuration determines their actual position in `servo-thread`. Therefore a source-level servo-period trace has two layers:

- motmod's internal behavior once each exported function is invoked;
- the machine HAL file's ordered composition of hardware reads, motion functions, PID/control functions, and hardware writes.

Evidence: **SOURCE-CONFIRMED** at the pinned revision.

## Source: motion-command-handler is a realtime shared-command ingestion boundary

Pinned `src/emc/motion/command.c` documents `emcmotCommandHandler_locked()` as reading the shared command buffer in the main cycle while the command structure is locked. The public `emcmotCommandHandler()` wrapper uses a nonblocking mutex attempt: when Task holds the command mutex while updating the command, the realtime side does not block waiting for Task; the command processing opportunity is deferred rather than turning the servo thread into a blocking userspace wait.

The large locked handler dispatches `EMCMOT_*` command values and updates motion configuration/state accordingly.

Initial implication: “Task sent a command” is not synonymous with “the exact next servo invocation must process it.” M03 must trace command number/echo semantics and the try-lock failure path before defining command-to-servo-cycle latency.

Evidence: **SOURCE-CONFIRMED** for the nonblocking boundary; detailed acknowledgment semantics still open.

## Source: motion-controller is the main servo-rate state/control body

Pinned `src/emc/motion/control.c` identifies `emcmotController()` as the main loop running at servo-cycle rate, from which state logic and trajectory calculations are called. Later controller code writes joint HAL outputs including:

- `joint.N.motor-pos-cmd`
- joint commanded/feedback positions
- amp enable
- commanded velocity/acceleration/jerk
- following-error data

and updates shared motion status.

This establishes the controller as a major state-to-HAL publication point, but the exact per-cycle order inside `emcmotController()` still needs reconstruction from its top-level call sequence.

Evidence: **SOURCE-CONFIRMED** for role and HAL output publication; full call flow pending.

## First-cycle model — intentionally provisional

For a conventional feedback servo HAL configuration, the working model to test is:

`device/fieldbus read`
` -> motion-command-handler`
` -> motion-controller`
` -> external PID/control functions`
` -> device/fieldbus write`

H04 proves that, when these functions are placed in one HAL thread, their list order is their sequential call order. M03 must now determine exactly what values are sampled/published at each boundary and which relationships are same-cycle versus one-cycle delayed.

Do **not** yet label the full chain TEST-CONFIRMED.

## High-information questions for the next M03 lesson

1. Reconstruct the top-level call order inside `emcmotController()` at the pinned SHA: HAL input sampling, state transition logic, trajectory/interpolation, kinematics, compensation, following-error/fault checks, output-to-HAL, status publication.
2. Trace `emcmotCommandHandler()` try-lock, command-number/echo and acknowledgment behavior. Determine what happens in a cycle where Task owns the mutex.
3. Identify the exact functions that copy `joint.N.motor-pos-fb` from HAL into private joint state and later publish `joint.N.motor-pos-cmd` back to HAL.
4. Determine where kinematics forward/inverse calls occur in coordinated, teleop, and free/joint modes at foundation depth.
5. Select one canonical simulation HAL configuration and one HostMot2-style configuration, recording actual servo-thread `addf` order. Do not generalize configuration examples into hard-coded architecture.
6. Design a bounded M03 experiment that makes cycle ordering observable—for example a tagged/synthetic feedback change and observable motion-controller input/output timing—without requiring physical hardware or realtime qualification.

## Promotion candidates already visible

- Exact cross-thread timing if base/servo or other realtime threads exchange signals: 2000/HIGH unless needed for the one-servo-thread trace.
- Scheduler deadline/overrun consequences: use R04/advanced realtime path, not M03 foundation proof.
- Physical encoder/DAC network timing: later HostMot2/hm2_eth/IO modules.
- Functional-safety interpretation of enable/fault paths: safety series; do not infer safety rating here.

## Current conclusion

M03 is unblocked by graduated H04. The first source pass establishes that the servo period is not one monolithic C function: it is an ordered HAL-thread composition. `motmod` creates the thread and exports the motion command/controller functions; HAL configuration schedules them relative to hardware/control functions. The next work must descend into `emcmotController()` and the HAL feedback/command boundaries before any laboratory design is frozen.