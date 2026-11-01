# 4000 / 3100 / 3200 — Fanuc M98 L0 zero-repeat and LinuxCNC call-stack preflight

**Audience:** LinuxCNC interpreter implementers and mill/lathe CAM-post authors. **Status:** source-derived, **NOT RUN**, non-graduated. Read [M98-121](../research/4400_LINUXCNC_M98_121_L0_ZERO_REPEAT_CALL_FRAME_LEAK_SOURCE_AUDIT_2026-11-01.md) first.

## The controller contract

LinuxCNC supports Fanuc-style `M98 Pn Lcount` with a later `On` numbered subprogram ending in `M99`. The official [O-code manual](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/gcode/o-code.adoc#L137-L211) says L0 executes the subprogram zero times, but this does **not** imply that the interpreter's internal call-frame accounting is unchanged. In both inspected revisions, `convert_control_functions` calls `enter_context` before `execute_call` checks L0, and the L0 branch skips `control_back_to` without calling `leave_context`.

For a CAM post, the simplest stable rule is:

```text
if repeats < 0 or repeats is not an integer:
    reject("Invalid M98 repeat count")
elif repeats == 0:
    emit nothing                     # no M98 call
else:
    emit("M98 P" + number + " L" + repeats)
```

This is a **postprocessor workaround**, not a claim that LinuxCNC has been patched. It preserves the intended zero-iteration body semantics and avoids consuming a call frame in the source path.

**Parser distinction:** LinuxCNC already rejects negative L in [`read_l`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_read.cc#L1007-L1021). The proposed post rule is an additional conservative zero-repeat handling rule, not a claim that negative L is accepted by LinuxCNC.

## Narrow disconnected verification

Use the upstream [M98 loop fixture](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/interp/m98m99/05-M98-loops/test.ngc) as a baseline: it contains L10, one L0, then L2. Its expected file checks that the L0 body does not execute, **not** whether L0 leaks a call frame.

A single **new** diagnostic fixture (below) is sufficient. It is deliberately a software-only test, not a physical machine program. It must be run only on an independently qualified isolated interpreter, never a controller attached to actuators.

```ngc
(UNCONNECTED INTERPRETER ONLY; DO NOT RUN ON MACHINE)
G21 G90 G94
M98 P1 L0
M98 P1 L0
M98 P1 L0
M98 P1 L0
M98 P1 L0
M98 P1 L0
M98 P1 L0
M98 P1 L0
M98 P1 L0
M98 P1 L0
M30
O1
(PRINT,SUB BODY SHOULD NOT EXECUTE)
M99
```

**Frozen source prediction:** stable/development `INTERP_SUB_ROUTINE_LEVELS=10`; repeated L0 consumes call levels 1..9 and the tenth attempts level 10, potentially returning `NCE_TOO_MANY_SUBROUTINE_LEVELS` even though the subprogram body never executes. Stable checks the bound after increment; development before. This is a **source prediction**, not a reproduced error. If the standalone interpreter accepts all ten lines, record the actual result and revisit the trace rather than declaring the test wrong.

Compare with a control that **omits all ten L0 lines** and terminates normally. Do not test arbitrary larger counts; this is a bounded discriminator, not stress testing.

## Capture and interpretation

For each pinned binary revision, record: exact commit/tag, executable identity, standalone interpreter startup config, invocation, complete stdout/stderr, exit status, canonical output, actual start/end/runtime and whether the `PRINT` marker appeared. Do not treat the checked-in upstream expected file as a runtime result. If testing requires the local runner, use only reviewed, positively qualified **`[self-hosted, openpressbrake]`** with independently established physical isolation; no GitHub-hosted Actions or connected panel PC. No workflow dispatch or lab run occurred while writing this guide.

The smallest code-level candidate is to avoid entering a call frame for L0 or to balance it immediately; review file-pointer/sequence-number restoration, nested M98, M73 and development provenance nodes before proposing a patch. A source inspection alone does not prove a physical or memory-safety defect.

**Related source:** [CYCLE-119/120](../research/4400_LINUXCNC_CYCLE_119_G17_G18_G98_INITIAL_LEVEL_STICKY_AXIS_SOURCE_AUDIT_2026-11-01.md) addresses a separate G81 modal-state/CAM issue. Both exemplify why a CAM post must distinguish *documented G-code effect* from *interpreter internal state lifetime*. Graduated levels and independent personnel-safety gates remain unchanged.