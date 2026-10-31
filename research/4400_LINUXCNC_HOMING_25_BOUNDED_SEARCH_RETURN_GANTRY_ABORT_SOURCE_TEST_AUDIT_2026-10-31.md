# 4000-LC-HOMING-25 — Bounded search/latch/index and synchronized return on homing failure

**Session continuation:** 2026-10-31T05:40:07Z. **Status:** SOURCE-CONFIRMED development-only feature and upstream executable fixture inspection; TEST-CONFIRMED here none; NON-GRADUATED. Follows [HOMING-24](4400_LINUXCNC_HOMING_24_ABSOLUTE_ENCODER_REHOME_OFFSET_REGRESSION_SOURCE_TEST_AUDIT_2026-10-31.md).

## Pre-source discriminator

A switch that fails during *initial search* and one that fails during *latch/backoff/index* should not be treated as the same recovery problem. Hypothesis: a bounded initial search stops where it ends; a bounded latch failure should return to its move's starting position. Inspect the source to determine whether this behavior is real and version-gated.

## Pinned provenance

- Development [24e84c4506b41634240f7087f0295e361a954886 `src/emc/motion/homing.c`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/motion/homing.c), blob `adec003afe19a0ea0eae3c565c9d4bb708a0a5e6`: `home_start_move` ~159–189; `home_return` ~191–215; `home_do_moving_checks` ~230–293; `HOME_INDEX_SEARCH_WAIT` ~1329–1347; `HOME_RETURN_START/WAIT` ~1479–1517; `HOME_ABORT` ~1520–1530.
- Stable [v2.9.10 `homing.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/homing.c), blob `13f74f43a1169606e87c7bd8d48f44a2cad6fa74`: lacks `HOME_SEARCH_DIST`, `HOME_LATCH_DIST` and `HOME_RETURN_START/WAIT`; its `home_start_move` uses twice the configured joint travel.
- [Upstream change ee80cc1330dca14da5a1301e3dcac2b3d479d5fb](https://github.com/LinuxCNC/linuxcnc/commit/ee80cc1330dca14da5a1301e3dcac2b3d479d5fb), merged via [9203e1a4707cc49138c54c122e5c5902dcd84184](https://github.com/LinuxCNC/linuxcnc/commit/9203e1a4707cc49138c54c122e5c5902dcd84184): adds INI→Task→motion flags/parameters, state-machine return, documentation, and `tests/home-dist`.
- [Upstream gantry-abort correction d5509cada061dacabd98874d92448144444bd55e](https://github.com/LinuxCNC/linuxcnc/commit/d5509cada061dacabd98874d92448144444bd55e), related [issue #4572](https://github.com/LinuxCNC/linuxcnc/issues/4572): fixes an array-indexing error in the new multi-joint abort path.
- [Development `tests/home-dist/test.ini`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/tests/home-dist/test.ini), blob `7006d59d44ec376dc2e4630a00c9803b3ce0a1a9`; [`test-ui.py`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/tests/home-dist/test-ui.py), blob `977f66fb5bd4f7262496e2c0f05a51c80ff52b00`; [official development homing guide](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/config/ini-homing.adoc), blob `623769ebf8532130bce5cf77cd60fc42bbcd9620`.

## Exact implementation and version boundary

Development's `[JOINT_n]HOME_SEARCH_DIST` bounds the first search, while `HOME_LATCH_DIST` bounds backoff, switch latch and index search. Both default to **0**, which means the legacy planner target of **twice the configured joint travel**, not an infinite unbounded move. The INI loader sends these parameters through Task and the motion command handler to `base_set_joint_homing_params`; `home_start_move` records `move_start`, `move_dist`, and `move_vel` before commanding the free trajectory planner. Velocity is clamped to the joint velocity limit.

`home_do_moving_checks` is invoked by the relevant WAIT states via `ABORT_CHECK`:

- **Initial search exhausted:** if `move_dist>0` and state is `HOME_INITIAL_SEARCH_WAIT`, disable the planner, report `HOME_SEARCH_DIST` failure and abort. The joint **stays at its search endpoint**; a later attempt can search farther from there.
- **Backoff, latch or index exhausted:** if `move_dist>0` in the other moving states, report which kind of failure and call `home_return(jno)`. The affected joint and any moved joints in its synchronized negative-sequence group transition toward `HOME_RETURN_START/WAIT`, using saved start positions and velocities. When return motions finish, `HOME_ABORT` clears homed/homing and index-enable.
- **Default zero bound:** the explicit `move_dist>0` recovery path is not entered. Exhausting the twice-travel target uses the legacy abort route. A limit can still abort earlier unless configured to be ignored.
- **Index-only:** `HOME_INDEX_ONLY_START` arms `index_enable` and starts a latch-speed move. `HOME_INDEX_SEARCH_WAIT` accepts the encoder driver's clearing of the IO bit as the index event; the controller does **not** independently timestamp the physical edge. A bounded index failure enters the return path.

The negative `HOME_SEQUENCE` synchronizes participating joints; the code's `home_return` stops every joint in the current homing sequence but only returns the failed joint and moved members of its synchronized group. Do not promise that all unrelated joints return to their original position.

## Critical abort fix and why it matters

The newly introduced `HOME_ABORT` loops over `i=0..all_joints-1`. An earlier implementation used `joint[i].free_tp.enable=0` where `joint` already pointed to `&joints[joint_num]`. For a nonzero failing joint this addressed `joints[joint_num+i]`, potentially missing lower-numbered moving joints and accessing past the array. The [d5509c correction](https://github.com/LinuxCNC/linuxcnc/commit/d5509cada061dacabd98874d92448144444bd55e) replaces that with `joints[i].free_tp.enable=0`. **SOURCE-CONFIRMED fixed in the pinned development source.** This is an implementation reliability fix, not a proof that software homing is a personnel-safety function.

## Inspectable upstream fixture (not run here)

`tests/home-dist` uses three simulated joints: joint 0 homes alone, joints 1 and 2 form a synchronized `HOME_SEQUENCE=-1` pair. Its INI sets search distance 5, latch distance 2 for joints 0/1 and 3 for joint 2. The Python test checks a dead initial switch (joint 0 moves 5 and stays), stuck-on switch (backoff 2 then return), intermittent switch (latch fails then returns to latch start), synchronized pair with stuck switches (joint 1 exhausts 2 first, joint 2 stops before its own 3 and both return), and a normal working switch. It checks error strings, motor-pos-cmd endpoints, unhomed flags and machine-on state with a 0.01 position tolerance. **UPSTREAM-TEST-DEFINED, not executed.** This fixture is more useful than inventing a new harness; it is also not a substitute for a physical machine's switch/drive limits.

## Acceptance and failure boundaries

For a machine config, explicitly review search direction, latch direction, overshoot distance, switch active width, index period, joint acceleration, and whether limits are ignored. A too-short latch distance can make a healthy switch/index appear faulty; a too-long bound can permit unwanted travel. No arbitrary numerical bound is universally safe. A controlled return move is still commanded machine motion and can fail if the drive or feedback is wrong. Independent hardware/personnel safety remains authoritative.

**Claims ledger:** feature presence and state transitions SOURCE-CONFIRMED in pinned development; v2.9.10 absence SOURCE-CONFIRMED; fixture expectations UPSTREAM-TEST-DEFINED; gantry abort report COMMUNITY-REPORTED and correction SOURCE-CONFIRMED; actual upstream pass result, physical return accuracy, stop latency, fault handling under real drives UNKNOWN; TEST-CONFIRMED here none.

**Next:** if justified isolated software compute becomes available, run pinned `tests/home-dist/test.sh` and preserve logs; otherwise inspect homing IO index-enable edge ordering and version-specific HAL scheduling. Do not enable GitHub-hosted Actions or operate a machine.
