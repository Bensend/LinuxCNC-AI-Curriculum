# 4400-ENABLE-02 / ROBOT-STATUS-01 — A green safety output is not an all-mode permission
**2026-10-29 | practical technician desk card | UNSCORED / NOT AN EXTERNAL EVALUATION**

Read the [UR SW10_15 SF18/19/20 source audit](../research/4400_ENABLE_02_UR_SW10_15_THREE_POSITION_MODE_FREEDRIVE_SF19_SF20_OUTPUT_CONTRACT_OEM_AUDIT_2026-10-29.md), the [UR SF11/12 and stop/tool I/O audit](../research/4400_ROBOT_STATUS_01_UR_SW10_15_MOVING_NOT_STOPPING_TOOL_IO_AND_SAFEGUARD_STOP_SEMANTICS_AUDIT_2026-10-29.md), and existing [Rockwell 440J ENABLE-01](4400_ENABLE_01_GRIP_MODE_OCCUPANCY_AND_PEDAL_NON_EQUIVALENCE_FIELD_CARD_2026-10-25.md). This is an **adjacent source-depth exercise**, not a new graded 2520–25F0 module. The evaluator must use separate hidden novel questions and independent scoring.

## Eight unscored field decisions
1. A robot cell has a 3PE output labeled "enabled." It is HIGH in Automatic Mode with the grip on a hook. Can that output alone be used to energize a shared external clamp? Identify the exact manufacturer mode clause and missing safety authority.
2. A commissioning engineer uses SF19 HIGH to mean "every person is holding an enabling grip." A second technician selects Freedrive in Manual Mode. What does the **manufacturer's exact** all/any state table require the engineer to re-evaluate?
3. The operator panics, squeezes a 3PE fully, then releases it. Describe the expected **device contact** behavior, the **UR robot stop category** in Manual Mode, and the independent physical fact neither establishes.
4. Two technicians are inside a cell, but only the primary programmer has a 3PE. Which selected-personnel/occupancy requirement remains unproven? Is a second device alone sufficient to prove the space empty?
5. A dashboard says "Manual Reduced Speed 250 mm/s." The operator has temporarily enabled Manual High Speed. What is the distinction between **permitted limit**, actual velocity, selected safety setting and task-specific acceptable speed?
6. An external door lock is opened as soon as UR SF12 "Not stopping" becomes HIGH. Why is the label insufficient to establish **standstill**? What would a qualified guard-release design require?
7. A robot arm is in SF2 Safeguard Stop while a suction tool is holding a sheet. Which OEM statement prevents assuming the **tool output** has been disabled? What physical retained-load/landing witness is required before access?
8. A controls engineer treats SF11 "Moving" HIGH as proof that a magnetic gripper is safe to release, then reuses an old jog command after returning from Manual to Automatic. Identify separate **motion state**, **load support**, **guard restoration**, **mode authority**, and **fresh start** propositions.

## Selected-machine evidence fields (blank by design)
| Proposition | Qualified evidence required | Current status |
|---|---|---|
| Exact robot model, installed software/manual edition | Versioned OEM identity and as-built record | UNKNOWN |
| Manual/automatic/Freedrive/mode-switch truth | Selected safety configuration and validated mode transitions | UNKNOWN |
| 3PE device, entrants and contact variants | OEM model, independent channel monitoring, occupancy review | UNKNOWN |
| SF19/SF20/SF11/SF12 outputs used by external system | As-built interface truth table and receiving safety-system design | UNKNOWN |
| Stop category and tool/end-effector energy | Selected independent safety path and physical witness | UNKNOWN |
| Guard reset, release, restart, retained commands | Task-specific SRS and validated fresh start | UNKNOWN |
| Actual safe speed, space and stop/hold performance | Qualified independent physical acceptance | NOT RUN |
| Operator usability and foreseeable defeat | Unpowered task/fixture/guard walkthrough | UNKNOWN |

## Safer workflow and minimum boundary
Provide a comfortable enabling grip, independent task-specific start, a clearly visible mode indicator, accessible safe retreat and guards that reinstall easily. Never tape a grip, jumper a guard, or let a routine LinuxCNC/FPGA bit grant personnel-safety permission. A robot's Cat2 stopped state is **not** isolation or a guarantee that a suspended load cannot fall. Do not operate a machine with people exposed when selected protection and physical safe state are unproven. If a future experimental operation is independently justified, it must be isolated/remote with people outside the danger zone and residual risk stated.

**Evidence:** UR SW10_15 and IDEC/440J manufacturer claims **DOC-CONFIRMED** in scope; cross-machine safety transfer **INFERENCE**; actual machine/evaluator **UNKNOWN**; **TEST-CONFIRMED none**. OpenPressBrake G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No runtime or physical validation was performed.


## Two adjacent source-depth checks (UNSCORED; not a new competency)
9. The receiving safety controller samples a UR OSSD-configured output and sees brief LOW pulses during its otherwise HIGH state. What exact OEM timing/receiver compatibility and fault interpretation must be verified? Why is ordinary HAL debounce not an acceptable personnel-safety receiver?
10. A robot's external E-stop is released, its System Stop output returns HIGH, and an external conveyor has a retained run request. What distinct **E-stop state reset**, **external deliberate restart** and **physical final-element** conditions prevent unintended motion? Identify the original UR Safety I/O warning.
