# Practical discriminator — LinuxCNC Home All, absolute encoders and development G28.2

**Scope:** [HOMING-27](../research/4400_LINUXCNC_HOMING_27_HOME_ALL_JOINT0_NO_REHOME_AND_UNSEQUENCED_JOINT_SOURCE_AUDIT_2026-10-31.md) and [GCODE-28](../research/4400_LINUXCNC_GCODE_28_G282_HOME_CYCLE_TASK_MOTION_MODE_AND_RESULT_SOURCE_AUDIT_2026-10-31.md). **SOURCE-CONFIRMED expectations, NOT EXECUTED.** For a verified disconnected software-only LinuxCNC simulation, never a real actuator. Only use approved isolated `[self-hosted, openpressbrake]` compute if it becomes justified and available. Do not dispatch a GitHub-hosted workflow.

## Reuse the actual upstream fixture

At LinuxCNC development commit [24e84c4506b41634240f7087f0295e361a954886](https://github.com/LinuxCNC/linuxcnc/tree/24e84c4506b41634240f7087f0295e361a954886), copy [`tests/home-absolute-encoder/`](https://github.com/LinuxCNC/linuxcnc/tree/24e84c4506b41634240f7087f0295e361a954886/tests/home-absolute-encoder) into a separate temporary working directory. Keep original `test.sh`, `test.ini`, `home-absolute-encoder.hal`, `test-ui.py`, and their SHA provenance. The fixture's synthetic encoder is `joint.0.motor-pos-fb=10`, not motor command feedback. Its HAL loops normal-control estop status **inside a simulation**; that loopback is not suitable for a physical machine.

The upstream test script launches twice with a deliberately stale `POSITION_FILE`. The original Python script exercises individual `home(0)`, but not `home(-1)`. **Do not modify the upstream copy in place or call a modified result an upstream pass.**

## Two configurations, one deliberately changed parameter

| Case | `[JOINT_0]` in copied `test.ini` | Starting condition | Home All expectation after accepted `c.home(-1)` |
|---|---|---|---|
| A — included | `HOME_ABSOLUTE_ENCODER=2`, `HOME_OFFSET=5`, **`HOME_SEQUENCE=0`** | individually homed, feedback 10, input 15 | Joint 0 re-enters homing; on fixed development source ends homed, input 15, motor offset -5. v2.9.10 may accumulate +5 (compare exact version). |
| B — excluded | Same, but **omit `HOME_SEQUENCE`** | individually homed, feedback 10, input 15 | Joint 0 is marked unhomed by Home All but excluded from all sequence groups; it remains unhomed. Position need not change. |
| C — individual control | Either INI | individually homed | `c.home(0)` respects `HOME_NO_REHOME`; no forced joint-0 clear. |

**Why B matters:** the *unmodified* upstream fixture is Case B. The INI loader defaults missing `HOME_SEQUENCE` to 999, while Home All selects only sequence numbers <=100. The existing upstream test cannot cover Case A without an INI change.

## Minimal extension to the upstream Python test

In the **copied** `test-ui.py`, add `import os` near the imports, and insert the following **after** the final `check("home after encoder changed back", ...)` but **before** `machine_off()`. Set the environment variable separately for each configuration. This is a small discriminating extension, not a replacement for the upstream regression.

```python
# Non-upstream Home All discriminator; original test has just homed at encoder=10.
expected_homed = bool(int(os.environ.get("HOME_ALL_EXPECT_HOMED", "0")))
c.teleop_enable(0)
c.wait_complete()
c.home(-1)
c.wait_complete()             # NML completion is NOT servo homing completion
time.sleep(0.5)               # preliminary status settling only; capture a trace for proof
s.poll()
report("after Home All discriminator")
if bool(s.homed[0]) != expected_homed:
    failures.append("Home All homed flag: got %s expected %s" %
                    (bool(s.homed[0]), expected_homed))
if expected_homed:
    # Only assert this when HOME_SEQUENCE=0 and the development fix is present.
    check("Home All included joint coordinate", encoder + HOME_OFFSET)
    motor_offset = hal.get_value("joint.0.motor-offset")
    if abs(motor_offset + HOME_OFFSET) > TOLERANCE:
        failures.append("Home All motor-offset %.6f, expected %.6f" %
                        (motor_offset, -HOME_OFFSET))
```

Run **A** with `HOME_ALL_EXPECT_HOMED=1` and `HOME_SEQUENCE=0`; run **B** with `HOME_ALL_EXPECT_HOMED=0` and that line removed. Preserve both launches' stdout/stderr, LinuxCNC revision, exact modified file hashes, final `position.txt`, and process exit code. On v2.9.10, Case A's coordinate assertion is deliberately expected to expose the earlier accumulation mechanism, not to pass; document the result rather than weakening the assertion. The half-second sleep is a **provisional observation window** and can miss delayed/failed starts. For authoritative proof, capture the servo status transition or extend the fixture with a bounded, explicitly verified completion witness; do not infer homing from `c.wait_complete()` alone.

## Development G-code integration discriminator (separate experiment)

Only on a verified build containing `convert_home_cycle` and `WAITING_FOR_HOMING`, exercise `G28.2 P0` and `G28.2 P-1` in a simulation with matching Case A/B INIs. Record Task mode before/after, `homing_active`, `homing_runs`, per-joint `homing/homed`, operator errors, and the following interpreter coordinate state. Expect `P-1` with excluded joint 0 to fail Task's all-target-homed criterion; expect a legal included sequence to finish and restore the prior trajectory mode. This is **not** supported by inspected stable v2.9.10; do not conflate `G28.2` with `G28` or `G30`.

## Acceptance checklist and uncertainty

- Confirm the command was accepted by motion (FREE mode, enabled, not inhibited, no concurrent home), not merely sent through NML.
- Assert **both** coordinate and `homed` state, and distinguish a skipped home from a completed home. Preserve a second-launch result if using the upstream position-file fixture.
- Compare source tags separately. Development's offset normalization is not a proven v2.9.10 backport.
- For multi-joint machines, check which joints actually participate in Home All, not only whether the GUI offers a Home All button.
- Mark runtime outcomes **UNKNOWN** until a recorded isolated test; never infer encoder trust, physical switch alignment, travel clearance or personnel-safety validity from a synthetic test.

**Next:** if no isolated runner is verified, rotate to LinuxCNC trajectory-planner or tool-change internals rather than repeatedly drafting a larger Home All harness. Existing independent safety/evaluator gates remain unchanged.
