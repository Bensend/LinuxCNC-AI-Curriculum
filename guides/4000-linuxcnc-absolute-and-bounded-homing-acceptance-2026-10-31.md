# Practical LinuxCNC homing review — absolute feedback, index handshake and bounded failures

**Scope:** pinned stable v2.9.10 versus development commit `24e84c4506b41634240f7087f0295e361a954886`. [HOMING-24](../research/4400_LINUXCNC_HOMING_24_ABSOLUTE_ENCODER_REHOME_OFFSET_REGRESSION_SOURCE_TEST_AUDIT_2026-10-31.md) , [HOMING-25](../research/4400_LINUXCNC_HOMING_25_BOUNDED_SEARCH_RETURN_GANTRY_ABORT_SOURCE_TEST_AUDIT_2026-10-31.md), and [HOMING-26](../research/4400_LINUXCNC_HOMING_26_INDEX_ENABLE_HAL_IO_HOSTMOT2_ORDER_SOURCE_AUDIT_2026-10-31.md) are the source-backed rationale. **Review/diagnostic guide, not a physical commissioning authorization.**

## Acceptance matrix for an inspectable config

| Situation | Observable signals / values | Expected conditional behavior | Version and caveat |
|---|---|---|---|
| Absolute encoder mode 2, feedback 10, HOME_OFFSET 5 | `joint.0.motor-pos-fb`, `joint.0.motor-offset`, `joint.0.pos-fb`, homed | After home, feedback 15; rehome/unhome/restart must not accumulate offsets | Development has Sept 13 normalization and upstream test; v2.9.10 source lacks fix. |
| Home All after already homed | `joint.0.home-state`, `joint.0.homed`, `joint.0.pos-fb` | Confirm whether Home All enters `HOME_START`; do not assume `HOME_NO_REHOME` prevents it | `base_do_home_joint(-1)` deliberately clears joint 0 homed; upstream regression tests `home(0)`, not `home(-1)`. |
| Stale POSITION_FILE | saved file, fixed raw motor feedback, joint position after home | Raw feedback plus configured HOME_OFFSET should determine final coordinate | A file can preload prior state; no inferred absolute accuracy from software-only test. |
| Initial switch never seen | `joint.N.home-state`, home switch, motor-pos-cmd, error channel | Explicit positive HOME_SEARCH_DIST: search endpoint, then abort | Development-only. Zero means twice joint travel, not a small bound. |
| Switch fails to clear or relatch | state, home input, move start/end, errors | Explicit positive HOME_LATCH_DIST: return to beginning of failed move, then abort | Development-only; physical stop/return remains unverified. |
| Index pulse never clears | `joint.N.index-enable`, encoder index-enable, motor feedback, state | Waits until IO flag clears or bounded motion fails | HAL IO signal requires a compatible encoder/driver and correct `addf` ordering. |
| Negative-sequence gantry pair | both joint positions/states and switches | Synchronized group stops and returns from bounded latch failure | Pinned development includes abort indexing correction; don't generalize to every fault. |

## Minimal upstream-style software verification (NOT EXECUTED)

Use a dedicated isolated LinuxCNC run-in-place build matching the pinned commit; no physical drive outputs. In a working source checkout, the upstream scripts are `tests/home-absolute-encoder/test.sh` and `tests/home-dist/test.sh`. Run each from its test directory under the appropriate LinuxCNC RIP environment; capture full output, exit code, revision, HAL/INI and position files. The first fixture has a constant synthetic encoder and a two-launch stale-position-file check. The second has synthetic home switches and a three-joint synchronized pair.

For an additional **new test, not part of upstream**, copy the absolute fixture and add a Home All (`linuxcnc.command().home(-1)`) path with checks before/after the request. Record whether it enters `HOME_START`, and whether the motor feedback, offset and joint feedback remain invariant. Separately test absolute mode 1 only with an appropriate simulation of final motion; do not reuse the mode-2 fixed-feedback fixture and then mistake its lack of physical following for a LinuxCNC defect.

## Interpreting results

`joint.N.homed` says the controller completed its homing state machine, **not** that an absolute encoder has a valid multi-turn origin or that an independent reference agrees. `index-enable` is HAL IO: motion arms it, the encoder clears it on index, and scheduling can add a servo-cycle delay. If a failed latch moves back, the return is an ordinary software-planned motion, not a guaranteed stop or safe recovery. Avoid changing a production INI merely because a newer development option exists; first verify the running LinuxCNC version, firmware, HAL writer count, physical limits and independent safety chain.

**Verification status:** two upstream executable fixtures inspected but not run; no new tests or machine operations. For a Mesa encoder, compare `hm2.encoder.N.no-clear-on-index` with `HOME_INDEX_NO_ENCODER_RESET`, and inspect the exact `hm2.read → motion-controller → hm2.write` ordering. Development publishes the shared index-enable IO signal only on state changes, while v2.9.10 writes it every motion iteration; neither is a substitute for an actual index-event trace.\n\nThe original graduated levels, independent evaluator and OpenPressBrake G0/G1 HOLD are unchanged.
