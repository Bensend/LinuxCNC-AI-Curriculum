# 4000-LC-HOMING-24 — Absolute-encoder rehome offset: stable/development source and upstream regression

**Session:** 2026-10-31T05:40:07Z. **Status:** SOURCE-CONFIRMED version delta; UPSTREAM-TEST-DEFINED (not locally executed); COMMUNITY-REPORTED issue; NON-GRADUATED. No physical machine or CI execution.

## Engineering question and prediction

A controller using `HOME_ABSOLUTE_ENCODER=2`, `HOME_OFFSET=5` and an unchanged absolute feedback value of 10 should establish joint feedback 15 after every permitted homing operation, regardless of a stale `POSITION_FILE`. A repeated homing operation should not accumulate another +5. This is a pre-source invariant; whether LinuxCNC actually enforces it is revision-dependent.

## Immutable provenance

- LinuxCNC development [24e84c4506b41634240f7087f0295e361a954886](https://github.com/LinuxCNC/linuxcnc/tree/24e84c4506b41634240f7087f0295e361a954886), published 2026-10-30: [`src/emc/motion/homing.c`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/motion/homing.c), blob `adec003afe19a0ea0eae3c565c9d4bb708a0a5e6`, `base_do_home_joint` ~659–665, `HOME_START` ~864–897, `HOME_SET_SWITCH_POSITION` ~1240–1272; [`control.c`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/motion/control.c), blob `7c9a35c237ba05326372294587c33d53aff1a6a9`, feedback ~510–535 and motor command ~2131–2139.
- Stable [v2.9.10 `homing.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/homing.c), blob `13f74f43a1169606e87c7bd8d48f44a2cad6fa74`, `HOME_SET_SWITCH_POSITION` ~1118–1146: **does not contain** the development normalization.
- Both revisions' [`taskintf.cc` development](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/task/taskintf.cc) blob `2a429b0f66b2593cf669d6d25c5e54105390a696` ~308–321 and [stable](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/taskintf.cc) blob `96a041d1feef8560f37159a2f18b109171f084c3` ~326–340 set `HOME_ABSOLUTE_ENCODER|HOME_NO_REHOME` for modes 1/2, plus `HOME_NO_FINAL_MOVE` for mode 2.
- [Fix commit 0d3e4ad9f50dd48fe07bdca18f42f151310dc68a](https://github.com/LinuxCNC/linuxcnc/commit/0d3e4ad9f50dd48fe07bdca18f42f151310dc68a), dated 2026-09-13; [regression fixture commit adbc11f244e9c0bdf17ac4a5b435c1673a6938db](https://github.com/LinuxCNC/linuxcnc/commit/adbc11f244e9c0bdf17ac4a5b435c1673a6938db), same day. [Upstream issue #3717](https://github.com/LinuxCNC/linuxcnc/issues/3717) opened 2026-01-19, closed 2026-09-13; maintainer/community simulation and machine reports are **COMMUNITY-REPORTED**, not our runtime proof.
- [Upstream test `tests/home-absolute-encoder/`](https://github.com/LinuxCNC/linuxcnc/tree/24e84c4506b41634240f7087f0295e361a954886/tests/home-absolute-encoder): `README` blob `540e6fd0de03edaffd335bfbc46dd85063e12ab9`, `test-ui.py` blob `6e75e18e98f2fcdf57d5c704b150939d134906d7`, `test.ini` blob `e2c8aec4cf10144def41a80d9c941530984a1aa1`.

## Actual data path, not just an INI rule

`control.c::process_inputs` reads `joint.N.motor-pos-fb` into `joint->motor_pos_fb`, then normally computes:

```text
joint.pos_fb = joint.motor_pos_fb - (joint.backlash_filt + joint.motor_offset)
joint.motor_pos_cmd = joint.pos_cmd + joint.backlash_filt + joint.motor_offset
```

This means `motor_offset` is a coordinate-transform state variable, not a new physical encoder measurement. The stable `HOME_SET_SWITCH_POSITION` absolute branch uses `offset = HOME_OFFSET` and adds it to `pos_cmd`, `pos_fb`, `free_tp.curr_pos`, then subtracts it from `motor_offset`. If a homing path runs again, the previous `motor_offset` survives and another HOME_OFFSET can accumulate even with constant motor feedback. The community reproduced that symptom in simulations with fixed feedback; the source algebra establishes the conditional mechanism.

Development adds four operations *before* applying HOME_OFFSET: add the existing `motor_offset` to `pos_cmd`, `pos_fb`, and `free_tp.curr_pos`, then set `motor_offset=0`. The subsequent common code adds HOME_OFFSET and sets `motor_offset=-HOME_OFFSET`. For unchanged backlash, feedback becomes `motor_pos_fb - backlash_filt + HOME_OFFSET`, independent of the prior motor offset. **SOURCE-CONFIRMED algebra**, not an executed numerical test.

The two absolute modes differ in the final move: mode 1 enters `HOME_FINAL_MOVE_START`; mode 2 takes `HOME_FINISHED` directly. This source fix applies to both.

## Rehome protection has an important exception to test

`taskintf.cc` sets `HOME_NO_REHOME` for both absolute modes, and `HOME_START` normally ignores a rehome request while `homed=1`. But `base_do_home_joint(-1)` explicitly sets `H[0].homed=0` before invoking `do_home_all()`, to force at least one joint into the home-all sequence. **SOURCE-CONFIRMED:** the protection is not a blanket guarantee that a Home All request can never re-enter the absolute homing path for joint 0. Whether a particular GUI's Home All triggers the full path must be measured, not assumed.

The new upstream `test-ui.py` calls `c.home(0)` for repeated homing and `c.unhome(0)` before later attempts. It **does not exercise `c.home(-1)`** in the inspected script. That is a concrete remaining regression-coverage gap, not evidence that the fix fails.

## Upstream regression oracle and limitations

The pinned test config uses `HOME_ABSOLUTE_ENCODER=2`, `HOME_OFFSET=5`, one joint, fixed HAL `motor-pos-fb=10`, a deliberately stale `POSITION_FILE`, and generous FERROR for a synthetic non-following motor. It checks the expected joint input 15 within `1e-6` after first home, three repeated home requests, three unhome/rehome cycles, feedback changes 10→20→10, and two LinuxCNC launches with the position file retained. This is a **real upstream executable regression fixture inspected**, not a test we ran or a statement about a particular physical encoder. It does not validate mode 1 final motion, multi-joint gantry squaring, physical absolute validity after power loss, or Home All's special `-1` path.

**Version boundary:** the inspected v2.9.10 source still lacks the normalization even though the issue is closed on development. Do not infer a stable backport from issue closure, a GUI label, or a release name.

## Diagnostic/transfer exercise (PENDING)

On a verified isolated software-only LinuxCNC RIP installation, run the pinned `tests/home-absolute-encoder/test.sh` unchanged, retain stdout/stderr, source SHA and exit code. Then add a separate, clearly labeled *non-upstream* `c.home(-1)` discriminator and test mode 1 in a copy. Observe `joint.0.motor-pos-fb`, `joint.0.motor-offset`, `joint.0.pos-fb`, homed status and the position file before/after; never equate an encoder number or homed flag with independently trusted machine geometry.

**Claims ledger:** stable cumulative-offset path and development normalization SOURCE-CONFIRMED; fixed-input regression expectations UPSTREAM-TEST-DEFINED; historical behavior COMMUNITY-REPORTED; actual stable/development test pass, Home All outcome, machine calibration and safe physical travel UNKNOWN; TEST-CONFIRMED here **none**. Existing independent personnel safety and OpenPressBrake G0/G1 HOLD unchanged.

**Next:** inspect the Home All `-1` behavior with a controlled upstream-style fixture if justified compute is available, and investigate bounded homing failure handling in HOMING-25. No GitHub-hosted Actions.
