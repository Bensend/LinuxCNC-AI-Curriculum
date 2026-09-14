# 3400 Routers / Woodworking — synchronized gantry homing source trace

Date: 2026-09-14
Pinned LinuxCNC revision: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`
Trigger: second real router (`Funkenjaeger/fj-lcnc-cfg`) uses `trivkins coordinates=XYYZ` with Y joints 1 and 2 both `HOME_SEQUENCE=-1` and independent home switches.

## Documentation contract

Pinned `docs/src/config/ini-homing.adoc` states that negative `HOME_SEQUENCE` values mean joints sharing the same absolute sequence value home together and **synchronize the final move** to `[JOINT_n]HOME`. Joint-mode jogging of joints with negative HOME_SEQUENCE is disallowed to reduce gantry-racking risk.

This is more precise than saying the entire homing search is mechanically synchronized. The source confirms that the per-joint homing state machines still perform their own switch/search/latch work; the synchronization barrier is explicitly applied at the final-move states.

## Source-level execution

`do_home_one_joint()` treats a negative home sequence specially: a request to home one such joint sets every joint having the same absolute sequence number to `HOME_START` and runs the whole sequence group.

`update_home_is_synchronized()` marks joints sharing that absolute negative sequence as synchronized.

During `HOME_FINAL_MOVE_START` and `HOME_FINAL_MOVE_WAIT`, `sync_ready()` blocks progress until every participating non-absolute-encoder joint in the current sequence has reached the same homing state. Only then is the synchronized final move allowed to proceed.

Thus the useful model for an XYY gantry is:

`independent joint switch/search/latch episodes -> both sides establish individual home references -> synchronization barrier -> final move to HOME together -> coordinated world-Y becomes usable`

Do not simplify this to `both motors hit switches simultaneously`.

## One-side failure behavior

The source gives a strong answer to the previous checkpoint question.

Normal moving homing states call `home_do_moving_checks()`. If a joint reaches the end of its planned search move without the required switch/index event, or hits a non-ignored limit, that joint is put into `HOME_ABORT`.

The `HOME_ABORT` case is **global across all configured joints**:

- `homing = 0` for every joint;
- `homed = 0` for every joint;
- `joint_in_sequence = 0` for every joint;
- every joint free trajectory planner is disabled;
- every joint home state returns to `HOME_IDLE`;
- every joint index-enable is cleared.

Therefore, in the source contract, a failed home episode on one side of a synchronized gantry does not leave the partner side formally homed while the failed side alone retries. The abort invalidates homed state globally.

This is conservative ordinary-control state handling and materially useful for router commissioning/recovery.

## Recovery implication

After a one-side search/latch failure, the correct curriculum model is:

`detect failing side/cause -> homing abort stops homing and clears homed state globally -> inspect mechanical/switch condition and gantry alignment -> restart a valid grouped homing sequence`

Do not teach:

- continuing in world coordinates with the other Y joint still trusted as homed;
- manually marking only the failed side homed;
- independently jogging a negative-HOME_SEQUENCE gantry side as normal recovery without an explicit engineered mode/config that allows it.

Pinned docs show an advanced pattern that can temporarily select a positive sequence for individual pre-homing joint jogging, but that is a deliberate configuration/authority change, not the default negative-sequence contract.

## Relation to the real DCNC config

The inspected DCNC machine has:

- `KINEMATICS = trivkins coordinates=XYYZ`;
- JOINT_1 and JOINT_2 assigned to the same Y world coordinate;
- independent `yl_home_sw` and `yr_home_sw` physical inputs;
- both Y joints configured `HOME_SEQUENCE=-1`, `HOME_SEARCH_VEL=3`, `HOME_LATCH_VEL=-0.1`, `HOME_IGNORE_LIMITS=YES`.

This is a direct real-machine instance of the source contract above. The two switch trip positions are what establish squaring; the synchronized final HOME move then keeps the two joints together after those independent references are captured.

## Important boundary

`HOME_IGNORE_LIMITS=YES` means the homing state machine ignores the configured limit input for that joint during homing. The pinned documentation warns that a machine started on the wrong side of a separate home switch with ignored limits can hard-crash if switch behavior/configuration is wrong.

Therefore a negative home sequence is **not** a substitute for correctly designed/validated switch geometry or physical overtravel protection.

## Adversarial checks

1. Does negative HOME_SEQUENCE make the two motors a single feedback loop? **No.** They remain distinct joints.
2. Must both home switches trip at the same instant? **No.** Individual search/latch state machines establish each reference independently.
3. What is synchronized? **The final move to HOME**, after participating joints reach the corresponding state.
4. If one side never finds its switch, can the other side remain officially homed? **No under the inspected source path.** HOME_ABORT clears `homed` for all joints.
5. Does HOME_IGNORE_LIMITS guarantee safe overtravel behavior? **No.** It suppresses ordinary limit handling during the home episode for that joint.
6. Does the source prove mechanical racking cannot occur during a failed search? **No.** Source defines software state/stop behavior, not mechanical stiffness, stopping distance or independent hardware protection.
7. Is individual gantry-side jogging impossible under all configurations? **No.** Default negative-sequence mode disallows it; docs describe an explicit selectable sequence workaround for pre-homing alignment.

Result: **7/7 boundary checks passed.**

## Promotion decision

Promote to the 3400 playbook:

- gantry squaring should be reasoned at the **joint** layer, not the world-axis layer;
- negative HOME_SEQUENCE groups participating joints and synchronizes the final HOME move after independent reference acquisition;
- one-joint homing failure invalidates all joint homed state in the inspected LinuxCNC source, so recovery begins from a globally unhomed machine state;
- separate home switches and switch geometry remain critical even when final motion is synchronized;
- homing software is ordinary machine control, not a functional-safety substitute for mechanical/hardware overtravel protection.

No lab is needed for this question: the pinned source directly resolves the state-machine behavior that the proposed synthetic gantry lab would have duplicated.
