# 4000-LC-HOMING-167 — Upstream home-dist executable oracle, coverage and blind spots

**2026-11-02; 4000 implementation research, NON-GRADUATED.** LinuxCNC-first continuation, with 3100 mill, 3400 router/gantry and 3500 custom-kinematics transfer. **SOURCE/TEST-SOURCE CONFIRMED, NOT TEST-CONFIRMED HERE.** This is a **new upstream test-coverage/evidence audit**, not a new discovery of bounded homing or global abort: those mechanisms were already traced in [HOMING-90](4400_LINUXCNC_HOMING_90_BOUNDED_MOVE_ABORT_FANOUT_SOURCE_AUDIT_2026-11-01.md), [HOMING-91](4400_LINUXCNC_HOMING_91_CONFIGURED_JOINT_COMMAND_BOUNDARY_SOURCE_AUDIT_2026-11-01.md) and [HOMING-131](4400_LINUXCNC_HOMING_131_HOME_ALL_FAILURE_SEQUENCE_CONTINUATION_VERSION_AUDIT_2026-11-01.md). The predecessor check also examined PROGRESS, LESSON_LOG, LAB_COMPUTE_LOG and prior homing-related lab/result references. No previous retained HOME_DIST runtime verdict was found in the reviewed ledger; **absence from this ledger does not establish upstream CI never ran it**.

## Immutable upstream provenance

Development LinuxCNC commit [67437d8865e431a9a33f74cee912dbf891d3b4c5](https://github.com/LinuxCNC/linuxcnc/tree/67437d8865e431a9a33f74cee912dbf891d3b4c5), with exact fetched blobs:
- [tests/home-dist/test-ui.py](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/tests/home-dist/test-ui.py) blob `977f66fb5bd4f7262496e2c0f05a51c80ff52b00`; `home`, `check_moved`, `check_return`, five test cases.
- [tests/home-dist/test.ini](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/tests/home-dist/test.ini) blob `7006d59d44ec376dc2e4630a00c9803b3ce0a1a9`; 1 ms servo, three joints, J0 independent, J1/J2 synchronized `HOME_SEQUENCE=-1`; search bound 5 mm, latch bounds 2/2/3 mm.
- [tests/home-dist/home-dist.hal](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/tests/home-dist/home-dist.hal) blob `a9cb8f37c7f79519fa9f0519d1c8e1c122b887c9`; `comp` switch synthesis, `flipflop` intermittent-switch mask, and **joint motor-pos-cmd wired directly to motor-pos-fb**.
- [tests/home-dist/test.sh](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/tests/home-dist/test.sh) blob `f5cfb134143cf9e332f25b027b0f3411bfb1b154`; invokes `linuxcnc -r test.ini`.
- [src/emc/motion/homing.c](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/src/emc/motion/homing.c) blob `adec003afe19a0ea0eae3c565c9d4bb708a0a5e6`, especially `home_return` ~198–215, `home_do_moving_checks` ~235–287, `HOME_INITIAL_SEARCH_START` ~989–1019, `HOME_RETURN_START/WAIT` ~1479–1518, `HOME_ABORT` ~1520–1529.
- [src/emc/ini/inijoint.cc](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/src/emc/ini/inijoint.cc) blob `b0c79c3ddc05c53f93ea0d4f87e16c5bac3b1a54`: INI `HOME_SEARCH_DIST` and `HOME_LATCH_DIST` read and sent to homing params.
- [Official development homing manual](https://linuxcnc.org/docs/devel/html/en/config/ini-homing.html), sections HOME_SEARCH_DIST/HOME_LATCH_DIST. Documentary page is moving; source links above are immutable.

Stable comparison: [v2.9.10 homing.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/homing.c) fetched blob `13f74f43a1169606e87c7bd8d48f44a2cad6fa74` has no distance fields. The four `tests/home-dist` paths above returned NOT_FOUND at v2.9.10. **Do not run development INI/test unchanged on stable and infer a stable bounded-distance verdict.**

## Actual test oracle, not just proposed examples

The Python driver uses `linuxcnc.command/stat/error_channel`, sets synthetic switch thresholds with `halcmd sets`, requests `teleop_enable(0)` and `home(j)`, then polls until homing ceases. It captures `joint.N.motor-pos-cmd` peaks and endpoints and errors. `TOLERANCE=0.01` machine units (mm here). The test checks machine remains `STATE_ON` and all three joints report unhomed **after each expected failure**. Cases, all **test-source assertions, not observed outcomes here**:

| Case | Stimulus | Upstream assertion / discriminant |
|---|---|---|
| Dead switch | J0 threshold -1000; search -20 mm/s | error contains HOME_SEARCH_DIST; maximum J0 excursion magnitude 5 mm; endpoint -5 mm relative to start |
| Stuck-on switch | J0 threshold +1000 | error contains `did not clear`; J0 max excursion 2 mm, returns within 0.01 mm of its **backoff-move** start |
| Intermittent | J0 threshold current-3; flipflop masks switch at home-state 10 | error contains HOME_LATCH_DIST; final J0 displacement about -3 mm from original home-command start, maximum excursion below -4.9 mm; **not** a return to the original home-command start |
| Synchronized stuck-on pair | J1/J2 thresholds +1000; both -1 sequence; latch bounds 2/3 | J1 reaches 2 mm and returns; J2 returns and its peak is **less than** its own 3 mm bound, demonstrating peer stop |
| Working switch | J0 threshold current-3 | J0 becomes homed within 20 s |

The `home()` helper's `c.wait_complete()` only waits for command completion; subsequent `s.poll()`/homing loops provide the actual state observation. Failure messages come from realtime homing source, not from Python's guesses. The fixture's 0.2-unit switch comparator hysteresis and 1 ms servo period are part of the test conditions.

## New coverage conclusion: what the upstream test does NOT establish

1. **No independent physical feedback.** `motor-pos-cmd => motor-pos-fb` is ideal synthetic feedback. Even a passing run proves **software commanded trajectory and simulated switch response**, not actual encoder motion, following-error recovery, switch wiring, or machine stopping distance.
2. **No stable/development global-abort discriminator.** The failure helper asserts `not any(s.homed[:3])`, but never first establishes an unrelated, previously homed joint. Therefore it does **not** distinguish development's all-joint `HOME_ABORT` invalidation from stable's local abort. HOMING-90/131 remain source-only on that version difference. The final working-switch test does not revisit the earlier failure.
3. **No negative-distance normalization or zero-distance fallback assertion.** The INI uses positive 5/2/3 only; it does not check `fabs` of negative inputs or the default `dist<=0` twice-travel-span target.
4. **No real joint limit, following-error, or HOME_IGNORE_LIMITS fault.** The HAL intentionally shorts commanded to feedback and the tests use virtual switch levels.
5. **Harness diagnostic caveat:** on failure to observe the start of homing, `home()` returns a bare `start` list, not the expected `(start,farthest,end)` tuple. Callers unpack it into scalars and subsequent index operations can throw an exception instead of emitting the intended structured failure; an early exception is a **harness failure**, not evidence that LinuxCNC passed/failed the homing oracle. This is an inspected Python control-flow issue, not a runtime observation.

## Call-flow and executable-evidence ladder

`test.ini` → `inijoint.cc::loadJoint` → Task/NML homing configuration → realtime `homing.c` `home_start_move` → free joint TP `pos_cmd` → HAL synthetic feedback and switch → `home_do_moving_checks` → either `HOME_ABORT` (search bound) or `home_return` → `HOME_RETURN_START/WAIT` → abort → userspace `linuxcnc.stat/error_channel` and `hal.get_value` assertions. The **test source exists** and is a ready-made independent oracle, but we have **not executed it**. Do not label TEST-CONFIRMED without exact LinuxCNC build, test output, exit code, configuration and job metadata.

## Next bounded discriminator and handoff

See [reproduction/coverage card](../guides/3100-3400-3500-4000-linuxcnc-home-dist-upstream-test-coverage-and-extension-2026-11-02.md). The **highest-value extension** is to home J0 successfully first, then deliberately fail J1's shared-switch homing, and compare J0's `homed` status after failure across pinned stable and development using a *version-compatible* shared-switch configuration (not development-only distance keys). Freeze this before execution. This is a control/status distinction, not a personnel-safety claim. Physical gantry, hydraulic axes and OpenPressBrake remain out of scope and on independent HOLD.

**Evidence labels:** SOURCE-CONFIRMED for source/test assertions and version boundaries; DOC-CONFIRMED for development homing options; INFERENCE for predicted regression outcomes until executed; TEST-CONFIRMED none; no LinuxCNC runtime, HAL, machine, evaluator, Actions or lab compute used. Existing graduated levels remain CLOSED.
