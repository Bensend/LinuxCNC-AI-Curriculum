# 3600 press-brake backgauge — native jog ownership and revocation trace

Date: 2026-09-11
Pinned LinuxCNC source: `8bf4605ae81042248add031e94c77300406e0413`
Evidence classes used below: DOC-CONFIRMED, SOURCE-CONFIRMED, COMMUNITY-REPORTED, INFERENCE.

## Question

For the first-stage press-brake backgauge UI, should hold-to-jog be implemented by repeatedly issuing target positions, or by LinuxCNC's native continuous-jog command plus an explicit stop? What happens to an already-active jog if machine/motion authorization disappears before the UI emits the button-release stop?

## Documentation evidence

Current LinuxCNC documentation describes continuous jog as a planner operation: `JOG_CONT` activates a free-mode trajectory planner with a target beyond travel and continues until an abort or limit. The Python API exposes separate `JOG_CONTINUOUS`, `JOG_INCREMENT`, and `JOG_STOP` operations. `motion.jog-stop` decelerates an active jog using configured acceleration; `motion.jog-stop-immediate` stops immediately and may therefore create following-error consequences. `motion.enable=FALSE` stops motion and places the machine in machine-off state. These are distinct mechanisms and should not be collapsed into one UI gesture.

Useful current documentation:
- https://linuxcnc.org/docs/devel/html/en/config/python-interface.html
- https://linuxcnc.org/docs/devel/html/en/man/man9/axis.9.html
- https://linuxcnc.org/docs/html/code/code-notes.html

DOC-CONFIRMED conclusion: a press-and-hold arrow should map to one native continuous-jog start and release should map to stop/abort; repeated absolute-position writes are not the native hold-to-jog contract.

## Source call flow

### 1. Task accepts jog commands only in bounded states

`src/emc/task/emctaskmain.cc::emcTaskPlan()` admits `EMC_JOG_CONT`, `EMC_JOG_INCR`, `EMC_JOG_ABS`, and `EMC_JOG_STOP` as immediate commands while Task is ON/MANUAL. The OFF/ESTOP/ESTOP_RESET branch does not admit new jog commands; rejected commands report that the machine must be out of E-stop and turned on.

`allow_while_idle_type()` also permits jog command classes while AUTO/MDI are idle, but this does not convert them into program motion and does not erase motion-side mode checks.

### 2. Task translates NML jogs to motion commands

`src/emc/task/emctaskmain.cc::emcTaskIssueCommand()`:
- `EMC_JOG_CONT` -> `emcJogCont()`
- `EMC_JOG_INCR` -> `emcJogIncr()`
- `EMC_JOG_ABS` -> `emcJogAbs()`
- `EMC_JOG_STOP` -> `emcJogStop()`

`src/emc/task/taskintf.cc` then bounds velocity against configured joint/axis maximums and publishes motion commands through `usrmotWriteEmcmotCommand()`:
- `emcJogCont()` -> `EMCMOT_JOG_CONT`
- `emcJogIncr()` -> `EMCMOT_JOG_INCR`
- `emcJogAbs()` -> `EMCMOT_JOG_ABS`
- `emcJogStop()` -> `EMCMOT_JOG_ABORT`

Important semantic point: `EMC_JOG_STOP` is not a zero-velocity `JOG_CONT`; it becomes the distinct motion command `EMCMOT_JOG_ABORT`.

### 3. Motion makes continuous jog persistent planner state

`src/emc/motion/command.c::emcmotCommandHandler_locked()` handles `EMCMOT_JOG_CONT` by first rejecting a new request when motion is disabled, `motion.jog-inhibit` is true, homing is active, mode/joint-axis addressing is invalid, a locking joint cannot be jogged, or the requested direction would continue through a limit.

For a free/joint jog, the accepted command:
- refreshes jog limits;
- sets `joint->free_tp.pos_cmd` to the applicable maximum/minimum jog limit;
- sets planner max velocity and acceleration;
- marks `kb_jjog_active=1`;
- sets `joint->free_tp.enable=1`.

The source comment explicitly describes continuous jog as a move toward the travel limit that is stopped when the button release produces an abort.

Therefore the UI does not need to continuously refresh a motion request. A single accepted start leaves an active realtime planner state until a stop/limit/authorization mechanism changes it.

### 4. Ordinary button release follows the explicit jog-abort path

`EMCMOT_JOG_ABORT` is accepted at any time. In teleop mode it invokes `axis_jog_abort()`. In free/joint mode it sets `joint->free_tp.enable=0`, clears keyboard/wheel jog-active ownership, and cancels homing if applicable.

SOURCE-CONFIRMED conclusion: `JOG_STOP`/`EMCMOT_JOG_ABORT` is the proper ordinary release path for hold-to-jog.

## Authorization-loss path

The critical adversarial case is: **continuous jog is already active, then machine/motion authorization disappears before the UI sends JOG_STOP.**

This is not dependent on another UI command.

### Motion enable/fault observation

`src/emc/motion/control.c::check_for_faults()` sets `emcmotInternal->enabling=0` when an enabled system loses the `motion.enable` input. The same desired-disable variable is also set by representative motion-side faults including joint hard-limit faults, joint amplifier faults, following error, spindle amplifier fault, and configured miscellaneous errors.

`src/emc/motion/command.c` also handles `EMCMOT_DISABLE` by setting `emcmotInternal->enabling=0`; the comment says the controller-cycle disable is deferred but will be honored.

### Servo-cycle revocation

`emcmotController()` executes `check_for_faults()` and then `set_operating_mode()` every servo invocation before generating the new position command.

Inside `set_operating_mode()`, when desired enabling is false while motion is still enabled, LinuxCNC:
- clears the coordinated trajectory planner;
- for every joint, sets `joint->free_tp.enable=0` and clears current free-planner velocity/acceleration;
- drains coordinated interpolators;
- calls `axis_jog_abort_all(1)` for teleop axis jogging;
- clears the motion-enable flag while preserving relevant error state.

SOURCE-CONFIRMED conclusion: an already-active native jog has a motion-layer authorization-loss revoke path independent of UI button release. Free-mode jog planners are disabled and teleop jogs are aborted on the controller-cycle transition to disabled.

This is a stronger ownership model than a design in which the GUI is the sole entity responsible for eventually sending a stop.

## Separate `motion.jog-stop` path

The realtime controller also watches the HAL `motion.jog-stop` and `motion.jog-stop-immediate` inputs while a jog is active. The normal jog-stop path requests a controlled stop using the associated acceleration. The immediate path stops immediately and can create following-error consequences. These pins are useful as independent ordinary-control revocation inputs, but no safety rating is inferred.

## Press-brake community evidence

The public Ursviken Pullmax Optima retrofit identifies the original backgauge as X forward/back, R up/down, and independent Z1/Z2 fingers. The builder's early implementation used post-home position commands and direct encoder feedback. A later field failure occurred when an incorrect encoder reading let a backgauge-related joint drive into a hard stop while the motor remained at maximum effort. The builder proposed a commanded-effort + insufficient-velocity timeout and additional brake-state checks. This is COMMUNITY-REPORTED field evidence that command ownership alone is insufficient; a backgauge also needs feedback plausibility/stall supervision and explicit recovery.

Thread: https://forum.linuxcnc.org/show-your-stuff/58003-ursviken-pullmax-optima-130-press-brake-retrofit-with-4-axis-backgage

A separate production press-brake example (Langmuir Titan) describes a backgauge homing sequence in which paired X motors independently stop on their switches, back off, then re-approach to establish alignment. Reports of swapped motor/limit wiring and physical binding show why homing must be treated as a distinct ownership/calibration operation rather than merely another typed move.

## First-stage 3600 ownership contract

For the initial manual backgauge feature set:

1. **Homing/reference owner** establishes the machine coordinate frame and validity needed for absolute positioning. It is distinct from jog and typed positioning.
2. **Hold-to-jog owner** uses one native `JOG_CONTINUOUS` start on press and one `JOG_STOP` on release. It must not emulate jogging by repeatedly queuing targets.
3. **Typed-position owner** is a bounded absolute-position operation. It requires a valid reference, target within configured limits, healthy axis/drive feedback, and no competing owner. It must not silently inherit ownership after an interruption.
4. **Motion authorization/fault layer** can revoke an already-active jog independently of the UI release path. UI release remains required as normal operator semantics but is not the only stop authority.
5. **Independent stall/feedback plausibility layer** is required before treating this as a robust press-brake backgauge design. The Ursviken hard-stop event is sufficient reason to keep commanded effort vs observed motion as a distinct fault discriminator.
6. **Recovery/reconciliation** after authorization loss must require current position/reference/drive state to be reconciled before another typed target or program owner is permitted. Do not auto-resume an interrupted target merely because authorization returns.
7. None of these ordinary LinuxCNC mechanisms are claimed to implement functional safety or replace required machine safeguarding.

## Adversarial checks

- **Lost button-release event:** native motion-disable/fault revocation still stops the active planner; a GUI-only stop design would be weaker.
- **GUI process stalls while button held:** the active continuous jog remains active until limit or another revoke input; therefore independent motion authorization and optional jog-stop supervision matter.
- **Authorization disappears and returns:** returning authorization must not be interpreted by the UI as permission to recreate the previous jog/typed command automatically.
- **Encoder frozen or wrong while command remains high:** native jog ownership does not diagnose the physical mismatch; stall/plausibility logic is separate.
- **Unhomed operator asks for typed absolute target:** reject/withhold absolute-position ownership. Manual recovery jog policy may be separately permitted by machine design, but must not masquerade as a valid absolute frame.
- **Mode switch during jog:** do not assume UI state alone stopped motion; verify the actual motion-side revoke/transition state.

## Evidence boundary

This trace proves software command and ordinary-control revocation architecture at the pinned source revision. It does **not** prove physical stopping distance/time, servo-drive behavior, backgauge mechanical clearance, safe speed, functional-safety performance, or appropriate commissioning limits for a real press brake.

## Next discriminating work

Freeze and execute a small software-only ownership/revocation experiment. It should test command ownership and state transitions, not motor physics. Minimum cases should include native jog start/release, authorization loss before release, jog-inhibit/jog-stop revocation, typed target preconditions, and explicit post-fault reconciliation/no-auto-resume behavior.