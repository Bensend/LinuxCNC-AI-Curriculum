# 4000-LC-HOMING-27 — Home All overrides joint 0's absolute-encoder no-rehome guard; unsequenced joint 0 can become unhomed

**Source audit:** 2026-10-31. **Status:** SOURCE-CONFIRMED conditional control flow, DOC-CONFIRMED HOME_SEQUENCE exclusion, UPSTREAM-TEST-DEFINED but **NOT EXECUTED**. NON-GRADUATED. Follows [HOMING-24](4400_LINUXCNC_HOMING_24_ABSOLUTE_ENCODER_REHOME_OFFSET_REGRESSION_SOURCE_TEST_AUDIT_2026-10-31.md); no physical motion or safety authorization.

## Question and exact scope

Does an already-homed absolute-encoder joint really ignore every subsequent home request, including Home All? What happens if joint 0 is homed individually but its INI omits `HOME_SEQUENCE`? The answer is **not the same** as the individual `home(0)` path. This audit is a new Home All / regression-coverage discriminator, not a re-description of HOMING-24's offset algebra.

## Immutable source and documentation

- LinuxCNC development [24e84c4506b41634240f7087f0295e361a954886](https://github.com/LinuxCNC/linuxcnc/tree/24e84c4506b41634240f7087f0295e361a954886), published 2026-10-30: [`src/emc/motion/homing.c`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/motion/homing.c), blob `adec003afe19a0ea0eae3c565c9d4bb708a0a5e6`: `base_do_home_joint` 659–665, `do_home_all` 342–347, `do_homing_sequence` 413–571, `HOME_START` 861–899, `HOME_SET_SWITCH_POSITION` 1240–1271, `base_get_allhomed` 751–768. [`src/emc/ini/inijoint.cc`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/ini/inijoint.cc), `loadJoint` ~143–160: missing `HOME_SEQUENCE` defaults to **999**.
- Stable [v2.9.10 `homing.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/homing.c), blob `13f74f43a1169606e87c7bd8d48f44a2cad6fa74`: `base_do_home_joint` ~553–559 also clears `H[0].homed`; sequence exclusion and `HOME_NO_REHOME` checks also present. Unlike development, its absolute-offset path lacks [the September 13 correction](https://github.com/LinuxCNC/linuxcnc/commit/0d3e4ad9f50dd48fe07bdca18f42f151310dc68a).
- [Official development homing documentation](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/config/ini-homing.adoc), section `HOME_SEQUENCE`: an omitted sequence excludes a joint from Home All, but not individual homing.
- Upstream [`tests/home-absolute-encoder/test.ini`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/tests/home-absolute-encoder/test.ini) blob `e2c8aec4cf10144def41a80d9c941530984a1aa1` **omits HOME_SEQUENCE**. Its [`test-ui.py`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/tests/home-absolute-encoder/test-ui.py), blob `6e75e18e98f2fcdf57d5c704b150939d134906d7`, calls `c.home(0)` repeatedly but never `c.home(-1)`. The fixture uses `HOME_ABSOLUTE_ENCODER=2`, `HOME_OFFSET=5`, fixed synthetic motor feedback 10, and no physical actuator.

## Actual path: GUI/HALUI/Python Home All → realtime homing

`linuxcnc.command().home(-1)` creates an `EMC_JOINT_HOME` NML request. [`taskintf.cc::emcJointHome`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/task/taskintf.cc) ~762–799 sends `EMCMOT_JOINT_HOME` with joint `-1`; [`motion/command.c`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/motion/command.c) ~1498–1535 checks FREE/joint mode or a pending permitted FREE transition, homing inhibit, existing homing and motion enable, then invokes `do_home_joint(-1)`. A rejected command does not establish the behavior below.

For an **accepted** Home All, `base_do_home_joint(-1)` unconditionally executes `H[0].homed = 0` **before** `do_home_all()`. `do_home_all` starts `HOME_SEQUENCE_START` when not already homing. Sequence setup marks only joints with `HOME_SEQUENCE <= 100` as participants. For participating absolute joints other than joint 0, `HOME_NO_REHOME && homed` preserves their homed flag; for joint 0, the preemptive clear makes that guard false. If its sequence is valid, `HOME_START` then re-enters the absolute `HOME_SET_SWITCH_POSITION` path even though it had already been homed. **Therefore the statement “absolute encoders never rehome while homed” is false for accepted Home All on participating joint 0.**

### Two distinct conditional outcomes

| Starting state and config | Source-derived consequence | Confidence |
|---|---|---|
| One active joint, `HOME_ABSOLUTE_ENCODER=2`, `HOME_SEQUENCE=0`, already homed, motor feedback 10, offset 5; accepted `home(-1)` | Joint 0 is forcibly marked unhomed, enters absolute reference again, and ends homed. Development's offset normalization should retain position 15 and motor offset -5. Stable v2.9.10 can apply offset again (HOMING-24). | **SOURCE-CONFIRMED control flow and algebra**; actual test result UNKNOWN. |
| Same, but `HOME_SEQUENCE` omitted (loader sets 999); accepted `home(-1)` | `H[0].homed` is cleared **but joint 0 is excluded from the sequence**. It never reaches `HOME_START` and remains unhomed; the source's Home All progression does not restore that flag. This is a **distinct conditional state-loss path**, not an offset problem. | **SOURCE-CONFIRMED** in stable/development; runtime status/GUI effect UNKNOWN. |
| Individual `home(0)` on already-homed absolute joint | `HOME_NO_REHOME` check in `HOME_START` suppresses rehome; no unconditional `H[0].homed=0` in that path. | **SOURCE-CONFIRMED**. |

The omitted-sequence case is especially relevant because **the existing upstream regression's own INI omits `HOME_SEQUENCE`**. Simply replacing one `c.home(0)` with `c.home(-1)` in that fixture would test the *excluded* path, not the intended absolute-encoder rehome path. A correct two-case discriminator must run with and without `HOME_SEQUENCE=0` separately.

## Implementation consequences and boundaries

- This is not evidence that a particular installed machine lost its home reference, that any physical axis moved, or that every GUI's Home All button sends an accepted `-1` request. Record the exact GUI/Task mode and motion inhibit before interpreting observations.
- For a machine with multiple joints, joint 0's special clear and the exclusion of an unsequenced joint are independent of whether other participating joints run. `get_allhomed()` tests all active joints, not just Home All participants; an active excluded joint 0 can therefore keep the machine globally unhomed.
- A future regression should assert **both** the coordinate invariant and the `homed` state, not only joint input. A successful NML send is not proof that the servo homing state machine ran.
- No change to personnel-safety authority: LinuxCNC homing and HAL state are normal-control diagnostics; independent hardware safeguarding, drive limits and qualified physical commissioning remain separate.

## Proposed falsifiable simulation check (NOT RUN)

Use a *copy* of the pinned upstream `tests/home-absolute-encoder` fixture, not a real machine. First add `HOME_SEQUENCE = 0` to `[JOINT_0]`; after `home()` has established input 15, call `c.teleop_enable(0); c.wait_complete(); c.home(-1); c.wait_complete()`, then wait for the servo/status to settle and assert `s.homed[0] == 1`, joint input 15, `joint.0.motor-offset == -5`. Compare stable and development, logging status and errors. Second, restore the original INI **without** HOME_SEQUENCE, first home individually, then request Home All; assert that the homed flag is lost while motor feedback remains unchanged. Never call either variant a verified result until the pinned executable test is actually run and logs are retained. [Step-by-step discriminator](../guides/4000-linuxcnc-home-all-absolute-encoder-and-g282-discriminators-2026-10-31.md).

**Remaining:** actual simulation run on an isolated approved self-hosted `[self-hosted, openpressbrake]` runner (access/isolation unverified), exact UI error propagation and whether stable patch/backport ever changes these source lines. No GitHub-hosted Actions. No blind score or graduation claim.
