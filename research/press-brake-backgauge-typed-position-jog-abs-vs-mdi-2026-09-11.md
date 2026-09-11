# Press-brake backgauge typed positioning — internal JOG_ABS versus MDI/G53

Date: 2026-09-11
Course context: 3600 press-brake preparation only; F02 remains blocked on information-separated S02/E20/X01/X02 handoffs.
Pinned LinuxCNC source baseline: `8bf4605ae81042248add031e94c77300406e0413`

## Question

For the first-stage press-brake backgauge UI, the operator should be able to type an absolute X/R/Z-style position and command the gauge there. PB-BG-001 already established the abstract ownership/revocation rule: typed positioning is a distinct owner, requires a valid reference and target, and may not automatically replay after interruption.

This note asks which LinuxCNC command surface best implements that owner without confusing command acceptance with physical completion or weakening the reference/limit contract.

## Bottom-line decision

For a Python/QtVCP-style first-stage HMI controlling a backgauge represented as a normal LinuxCNC coordinate, prefer an explicit **machine-coordinate MDI move (`G53 G0` or deliberately velocity-controlled `G53 G1`)** behind an application-owned typed-move state machine, rather than depending on internal `EMC_JOG_ABS`.

This is a bounded implementation recommendation, not a claim that MDI itself supplies all machine supervision. The application must still require reference validity, machine authorization, healthy feedback/drive state, target-range validation, explicit ownership, independent abort/revoke handling, and a completion witness stronger than 'the command channel returned DONE'.

If later architecture makes the backgauge an extra joint or otherwise removes it from the ordinary Cartesian/trajectory coordinate set, this recommendation must be revisited; MDI/G53 cannot be assumed to own a joint that is deliberately outside coordinated kinematics.

## Evidence 1 — `JOG_ABS` is real but it is an internal jog surface

Pinned `src/emc/task/emctaskmain.cc` recognizes `EMC_JOG_ABS_TYPE` and dispatches it immediately through `emcJogAbs(...)`. The file's own principles-of-operation note distinguishes these immediate commands from interpreter-list commands with pre/postconditions.

Pinned `src/emc/task/taskintf.cc::emcJogAbs()` selects joint or Cartesian-axis mode, caps requested velocity to the configured joint/axis maximum, then publishes:

- `EMCMOT_JOG_ABS`
- target in `emcmotCommand.offset`
- selected velocity

Pinned `src/emc/motion/command.c` then handles `EMCMOT_JOG_ABS` as an absolute jog. In joint mode it:

1. runs the ordinary jog-eligibility checks;
2. assigns the requested absolute target to `joint->free_tp.pos_cmd`;
3. refreshes jog limits;
4. clamps the jog target to the current jog limit if necessary;
5. runs the free-mode planner toward that target.

In teleop mode it calls `axis_jog_abs(...)`.

This is useful machinery, but it is still the free/teleop jogging path, not an interpreter trajectory command.

## Evidence 2 — absolute jog does not by itself mean 'referenced machine coordinate'

`command.c::refresh_jog_limits()` explicitly changes jog-limit meaning according to homed state:

- once homed, jog limits are the configured absolute soft limits;
- while unhomed, jog limits are synthesized around the current feedback position by plus/minus the configured travel range.

Therefore the fact that `EMCMOT_JOG_ABS` accepts an absolute target does **not** establish that the target belongs to a valid, referenced backgauge machine-coordinate frame. Jogging before homing is a supported LinuxCNC concept; that is intentionally different from the press-brake typed-position contract.

PB-BG-001's stronger application rule therefore remains necessary even if `JOG_ABS` were selected: typed positioning must be rejected when the backgauge reference is invalid.

## Evidence 3 — the documented Python command API does not expose JOG_ABS

Current LinuxCNC Python-interface documentation exposes:

- `JOG_STOP`
- `JOG_CONTINUOUS`
- `JOG_INCREMENT`

through `linuxcnc.command().jog(...)`.

It does not document a public `JOG_ABS` command constant/method. LinuxCNC's documentation also notes that the C++ NML API is broader than the subset exposed through Python.

For the planned Python/QtVCP-style HMI, selecting internal `EMC_JOG_ABS` would therefore mean adding a lower-level NML/custom binding or another nonstandard interface solely to obtain typed absolute positioning. That is a maintainability cost with no demonstrated first-stage benefit.

This does **not** mean internal JOG_ABS is defective. It means it is not the cleanest public Python surface for this particular HMI requirement.

## Evidence 4 — MDI has a stronger default reference gate

Pinned `emctaskmain.cc` handles `EMC_TASK_PLAN_EXECUTE_TYPE` (MDI) with an explicit check:

`if (!all_homed() && !no_force_homing) ... Can't issue MDI command when not homed`

The override is `[TRAJ]NO_FORCE_HOMING=1`.

Official documentation says the same thing: LinuxCNC normally requires axes/joints to be homed before MDI or program execution; it warns that with `NO_FORCE_HOMING=1` LinuxCNC does not know the joint travel limits in the normal referenced sense.

For a press-brake backgauge, do **not** use `NO_FORCE_HOMING=1` merely to make typed positioning convenient. A typed dimensional target is meaningful only after the gauge has a trusted reference (or a separately justified absolute-encoder reference procedure).

## Evidence 5 — use G53 to make the coordinate intent explicit

Official LinuxCNC G-code documentation defines `G53` as a nonmodal move in the machine coordinate system, independent of G54-G59.3 work offsets, G92/G52 offsets, etc. A typed backgauge dimension that is defined from the machine's calibrated gauge datum should therefore not silently inherit whichever work offset happens to be active in the interpreter.

For an ordinary coordinate-backed gauge, the first-stage command should be constructed explicitly, e.g. conceptually:

`G53 G0 X<validated-machine-target>`

or a deliberately feed-limited `G53 G1 ...` where process requirements call for a controlled rate.

The HMI must generate the axis letter from a configured backgauge-axis identity rather than hard-code X if the installation uses R/Z-like mapped coordinates.

`G53` must be present on every such move because it is nonmodal.

## Evidence 6 — MDI and jog limits are not the same mechanism

The jog path refreshes/clamps against jog limits as described above. Coordinated linear motion instead passes trajectory endpoints through the normal coordinate/joint range machinery in `command.c`, including axis constraints, inverse kinematics and joint position limits.

The HMI should still pre-validate a typed target against the configured commissioned backgauge range before sending it. That produces a clear operator error at the ownership boundary and avoids treating motion's downstream rejection as the normal UI validation mechanism.

Pre-validation is a duplicate sanity boundary, not permission to bypass LinuxCNC's own limit checks.

## Completion is a witness, not a send result

LinuxCNC's Python `wait_complete()` reports the execution status of the last command on the command/status interface. That is useful command-lifecycle evidence, but the press-brake application must not turn it into a claim that the physical gauge is trustworthy and at the target.

For `TYPED_MOVE`, completion should require a conjunction such as:

1. the command was accepted without an error-channel failure;
2. Task/interpreter/motion status is no longer executing the move (use the relevant status witnesses rather than an arbitrary sleep);
3. LinuxCNC reports in-position/idle as appropriate;
4. current backgauge feedback is valid;
5. measured/feedback position is within the commissioned target tolerance;
6. drive/fault and application stall-supervision inputs remain healthy;
7. no authorization/revocation episode occurred during the move.

The exact numerical target tolerance is machine/feedback dependent and is intentionally **not** invented here.

`linuxcnc.stat().inpos` is a useful LinuxCNC motion-state witness, not an independent functional-safety or physical-truth proof. PB-BG-001's distinct `feedback_valid`, `drive_ok`, and reconciliation rules therefore remain in force.

## Interruption and replay contract

PB-BG-001 already passed the following abstract requirement: authorization loss during a typed move revokes the owner; when authorization returns the stale target does not automatically replay; explicit reconciliation and a new typed request are required.

Implement MDI accordingly:

- application `TYPED_MOVE` owner acquires only from referenced idle;
- any application authorization/feedback/drive/stall fault triggers the ordinary abort/revoke path and enters `FAULTED`/`RECONCILE`;
- returning to a healthy state does not resend the previous MDI string;
- if reference validity was lost, reconciliation ends `UNREFERENCED` and another typed target is refused until the reference is restored.

Do not use repeated MDI submission as a persistence mechanism.

## Ownership conflict with jog

The public documentation recommends polling LinuxCNC status before issuing commands and checking that the current state/mode is compatible. A first-stage HMI should enforce one backgauge owner at a time:

- `HOMING`
- `JOG_CONT_POS/NEG`
- `TYPED_MOVE`
- later, `PROGRAM_MOVE`

Switching to MDI for typed position is therefore an explicit owner/mode transition. The UI must not allow a held jog or homing request to coexist with the MDI target. PB-BG-001 already adversarially verified the abstract single-owner rule.

## Why not implement typed position as incremental jog to `target-current`?

The documented Python API exposes incremental jog, so this shortcut is tempting. Reject it for the first-stage typed-position command:

- it converts an absolute dimensional intent into a delta calculated from an observation;
- observer age and coordinate-frame mistakes then enter target generation;
- it has the same pre-home jog semantics as the jog family;
- it obscures the difference between 'operator asked for machine position 125.0' and 'move +37.2 from whatever position I observed'.

Incremental jog remains useful for deliberate nudge controls, not as the canonical absolute target owner.

## Adversarial cases the implementation must preserve

1. **Unhomed typed request** — reject; do not enable `NO_FORCE_HOMING` to bypass it.
2. **Target outside configured range** — reject before command send; retain LinuxCNC downstream range checks too.
3. **Work offset active** — explicit `G53` prevents an accidental work-coordinate target.
4. **Jog button held when typed target is requested** — reject owner conflict; do not silently switch owners.
5. **Authorization loss mid-move** — abort/revoke, reconcile, do not replay.
6. **Command reports completion but feedback invalid** — no successful typed-move completion.
7. **`inpos` true but external/drive feedback fault present** — no successful completion.
8. **Reference lost after a fault** — typed positioning stays unavailable until re-reference.
9. **Future extra-joint architecture** — do not assume G53/MDI owns that joint; reopen the architecture decision.

## What this work does not establish

- real stopping time or distance;
- safe speed;
- physical collision avoidance;
- encoder plausibility thresholds;
- servo sizing or stall thresholds;
- whether a particular commercial press maps its gauge to X, R, Z or another coordinate;
- functional-safety performance;
- suitability of MDI/G53 for a future backgauge implemented as a LinuxCNC extra joint outside coordinated kinematics.

## Research/source references

Pinned source:

- `src/emc/task/emctaskmain.cc` — immediate jog dispatch; MDI homing gate; interpreter-list execution model.
- `src/emc/task/taskintf.cc::emcJogAbs()` — internal NML-to-motion translation for `EMCMOT_JOG_ABS`.
- `src/emc/motion/command.c` — `EMCMOT_JOG_ABS`, `refresh_jog_limits()`, normal coordinated-motion range checking.

Official documentation checked 2026-09-11:

- LinuxCNC Python Interface — public jog constants/methods; `mdi()`; status-polling pattern; `wait_complete()` status semantics.
- LinuxCNC INI Configuration / Important User Concepts — default MDI/program homing requirement and `NO_FORCE_HOMING` warning.
- LinuxCNC Coordinate Systems / G-codes — `G53` machine-coordinate semantics.
- LinuxCNC Homing Configuration — homing establishes the machine coordinate datum and makes configured soft limits meaningful.

## Verification status

**SOURCE/DOCUMENTATION-CONFIRMED implementation decision for the first-stage ordinary-coordinate Python HMI.**

No new laboratory run is justified yet. PB-BG-001 already tested the ownership/revocation behavior at the correct abstraction level; adding a motor simulation would not discriminate `JOG_ABS` from MDI. The remaining high-information uncertainty is architectural: whether the final X/R/Z gauge is represented as an ordinary trajectory coordinate or as a separately owned extra joint/custom actuator.

## Exact next-work checkpoint

1. Trace one minimal **MDI `G53` typed-move lifecycle** at pinned source level through interpreter output, Task pre/postconditions, trajectory command, motion completion/status and abort behavior. The purpose is to freeze the exact completion/revocation witness set, not to re-prove G-code basics.
2. Bounded-search later Ursviken/Pullmax attachments/configs for the actual X/R/Z/backstop architecture. Classify SOURCE UNAVAILABLE if no downloadable implementation is found rather than repeatedly mining the same thread.
3. If the final backgauge is a normal coordinate, freeze PB-BG-002 around the MDI/G53 owner with adversarial stale-target, offset, limit, completion and abort cases. If evidence instead points to an extra-joint architecture, first compare `joint.N.posthome-cmd`/extra-joint ownership against the typed-move requirements before freezing PB-BG-002.
4. Keep stall/feedback plausibility as a separate supervision requirement; do not invent thresholds during typed-position work.
5. Preserve F02's fresh-AI handoff block; 3600 remains dependency-safe preparation only.
