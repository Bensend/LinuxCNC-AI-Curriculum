# 4400-LC-BORING-123 — G88 is not an automatic manual retract; G86 stop has no standstill witness
**2026-11-01 | 4000 LinuxCNC interpreter/Task; 3100/3400 CAM-post transfer | NON-GRADUATED**

## Source question
What does LinuxCNC actually queue for the unusual G86/G88 boring cycles, and how does that differ from a CAM post's assumed spindle-stop, manual retract, or spindle-restart contract? This is distinct from G87's orientation-mode mapping in [BORING-122](4400_LINUXCNC_BORING_122_G87_ORIENT_ENUM_MODE_AND_MISSING_WAIT_SOURCE_AUDIT_2026-11-01.md).

## Pinned evidence
At stable v2.9.10 `86cdca76fa2a36274c432caa21952b23c267989a` [`interp_cycles.cc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_cycles.cc) blob `3d3fd818ac1f36fd7a36620c654ad6b3677295be`, `convert_cycle_g86` ~line 456 and `convert_cycle_g88` ~line 612; development `06864e23559e70463fc7112d5ce77138bcbc288c` blob `bbebc0d6ed872688c701a12f5a1467bff5f4fd94` contains the same significant sequence.

- **G86:** feed to bottom → dwell(P) → `STOP_SPINDLE_TURNING(selected)` → `cycle_traverse` to clear plane → `START_SPINDLE_...`. Source checks that the selected spindle was *commanded* turning on entry. No `WAIT_SPINDLE_ORIENT_COMPLETE` or independent measured zero-speed check is inserted between STOP and rapid retract. A stop command is not proof of zero shaft RPM. The [official G86 reference](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/gcode/g-code.adoc) describes the same command order; physical deceleration and spindle status are UNKNOWN.
- **G88:** feed to bottom → dwell(P) → `STOP_SPINDLE_TURNING` → `PROGRAM_STOP` → `START_SPINDLE_...`. **There is no `cycle_traverse` or `cycle_feed` retract after PROGRAM_STOP in this function.** [`emccanon.cc::PROGRAM_STOP`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/task/emccanon.cc) ~line 2443 queues `EMC_TASK_PLAN_PAUSE`, and the source comment expects the operator to retract manually. On resume the next canonical action restarts the spindle; that is not a machine-confirmed tool withdrawal.
- Both [stable](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/gcode/g-code.adoc) ~line 2627 and [development](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/docs/src/gcode/g-code.adoc) official G-code references say **G88 is accepted but unimplemented/undefined**. The interpreter still emits the above sequence. This is a **DOC/SOURCE scope conflict**: documentation warns not to rely on G88, while code does not simply reject it.
- `G89` is the clear contrast: `convert_cycle_g89` feeds down, dwells and **feeds back out** without spindle stop. It must not be conflated with G86 or G88.

## Operational contract for a postprocessor
A post must not interpret G88 as a self-contained automatic retract, or G86 as guaranteed stationary-spindle clearance. G88 requires operator action that is not automatically witnessed by the interpreter. Native G87/G88 should be rejected in the default generic LinuxCNC post profile pending deliberate machine-specific implementation, independent clearance/feedback review and disconnected test. G86 may be emitted only when the actual boring process permits its stop/retract semantics and the spindle coast-down requirement is handled explicitly by the machine design; a `STOP_SPINDLE_TURNING` command alone is insufficient evidence.

## Verification ladder (NOT RUN)
1. Disconnected standalone interpreter: compare G86/G88/G89 canonical command sequences and confirm G88 lacks a commanded retract; do not treat a stored `expected` trace as execution.
2. Disconnected Task simulation: hold `spindle.N.speed-in` nonzero after G86 stop, record whether a rapid is issued without a standstill acknowledgement.
3. G88 simulation: pause at bottom, record command position and Task mode, resume without simulated manual movement and observe whether spindle restart is commanded. Do not run this sequence on physical machinery.
4. Confirm installed HAL spindle feedback and independent machine-specific interlocks before any commissioning claim.

**Evidence:** SOURCE-CONFIRMED static and DOC-CONFIRMED warning; possible real-world premature motion/restart is **conditional INFERENCE**, physical result **UNKNOWN**; TEST-CONFIRMED none. No Actions compute, simulator, interpreter, hardware or evaluator. Existing graduated levels and independent safety G0/G1 HOLD unchanged.
