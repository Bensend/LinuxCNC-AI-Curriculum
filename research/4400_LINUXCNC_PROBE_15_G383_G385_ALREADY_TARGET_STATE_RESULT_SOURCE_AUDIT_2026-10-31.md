# 4000-LC-PROBE-15 — G38.3/G38.5 already-in-target-state and probe result provenance

**2026-10-31 | LinuxCNC-first source-depth rotation | NON-GRADUATED | no runtime test.**

## Concrete question

Can a non-error probing command report `#5070=1` when the probe input was already in the requested target state **before the move**? Does that report necessarily prove contact occurred during commanded travel?

## Pinned source and documentation

- LinuxCNC development commit [`24e84c4506b41634240f7087f0295e361a954886`](https://github.com/LinuxCNC/linuxcnc/tree/24e84c4506b41634240f7087f0295e361a954886): [`interp_convert.cc` lines 4688–4720](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/rs274ngc/interp_convert.cc#L4688-L4720), blob `379b21eaba65840ce4160e7ea70df60c12fad9ff`; [`command.c` lines 1571–1647](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/motion/command.c#L1571-L1647), blob `fd9760e59ac0e9801cbee90a379acd98d47ca6ea`; [`control.c` lines 252–258 and 752–789](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/motion/control.c#L752-L789), blob `7c9a35c237ba05326372294587c33d53aff1a6a9`.
- [`interp_execute.cc` lines 318–320](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/rs274ngc/interp_execute.cc#L318-L320), blob `46eb9e1a873011d783dc9b5b861c128055156a17`; [`interp_internal.cc` around line 490](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/rs274ngc/interp_internal.cc#L480-L493), blob `bcccebe27c2a1ee55073bf734b1a68d64e4bbf80`; [`emccanon.cc` lines 3703–3706](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/task/emccanon.cc#L3703-L3706), blob `5ad736c59e85495aa06573ebcad2d49d59145583`.
- Official same-revision [G38.2–G38.5 documentation](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/gcode/g-code.adoc#L1390-L1452), blob `46386681cce284fa0cc43e27192bee0aca208766`: G38.2/.4 signal failure errors, G38.3/.5 do not, and `#5070` reports success.
- Stable **v2.9.10** source independently checked for the same initial-state guard and trigger condition: `command.c` blob `0b79061d39be915bbea548b2c33bb794d31ab302` at ~1435–1441, `control.c` blob `b6e45d590c7d11030654d8f7d13d118f581b6439` at ~693. **SOURCE-CONFIRMED on these two revisions only.**

## Execution path

1. Interpreter maps G38.2/.3/.4/.5 to `probe_type = g_code - G_38_2`, respectively **0, 1, 2, 3**. Bit 0 suppresses an unsuccessful-probe error; bit 1 changes target from input asserted to input cleared. `convert_probe` issues `STRAIGHT_PROBE` and sets `probe_flag` to force an `INTERP_EXECUTE_FINISH` look-ahead barrier. **SOURCE-CONFIRMED.**
2. Realtime `EMCMOT_PROBE` validates coordinated/enabled mode, travel range and limits. Its **already-in-target-state precheck** is nested under `else if (!(probe_type & 1))`. Thus the initial-state rejection applies to G38.2 and G38.4, but is **skipped** for G38.3 and G38.5. The latter still must pass other command checks and trajectory insertion. **SOURCE-CONFIRMED.**
3. Once `probing=1`, servo `process_probe_inputs` reads `motion.probe-input`; when `probeVal XOR probe_whenclears` is true it latches `carte_pos_fb`, sets `probeTripped=1`, clears `probing`, and calls `tpAbort`. This condition checks the **level**, not a transition since the probe command began. Therefore, if G38.3 begins with input already TRUE (or G38.5 begins already FALSE), a subsequent servo check can report probe success immediately, without proof that a fresh contact/loss-of-contact edge occurred during that move. **SOURCE-CONFIRMED predicate; INFERENCE for exact physical travel/timing.**
4. Task `emcTrajUpdate` keeps the trajectory EXEC while `probing` is set even if the queue is empty, so a no-contact failure verdict can be posted by the later servo check. The interpreter resynchronizes after the probe barrier and sets `#5070` from `GET_EXTERNAL_PROBE_TRIPPED_VALUE`, which reads Task's `probe_tripped`. Thus `#5070=1` means the motion probe state machine took its success branch, **not** that a sensor edge, contact force or metrological calibration was independently verified.
5. The latched position is `carte_pos_fb` after the servo cycle's forward kinematics, not a separately timestamped hardware probe latch. Latency, servo period, feedback and mechanics affect metrological error; no numerical uncertainty or stop distance is inferred.

## Adversarial exercise (unscored, no machine execution)

| Initial input / command | Source-derived result | Confidence boundary |
|---|---|---|
| Input TRUE, G38.2 toward work | Command's initial-state check rejects as already tripped | SOURCE-CONFIRMED, subject to other command preconditions |
| Input TRUE, G38.3 toward work | Initial-state check skipped; if trajectory queues, next probe-input check can mark success | SOURCE-CONFIRMED conditional, no travel/edge proven |
| Input FALSE, G38.4 away | Initial-state check rejects as already clear | SOURCE-CONFIRMED |
| Input FALSE, G38.5 away | Check skipped; level condition can mark success without a new clearing edge | SOURCE-CONFIRMED conditional |
| Input remains opposite target through full probe move | G38.2/.4 set motion error; G38.3/.5 set `probeTripped=0` | SOURCE-CONFIRMED |

**Implementation lesson:** for automatic probing, explicitly verify the required starting input state and expected sequence before issuing even the non-error G38.3/G38.5 variants, then inspect `#5070` and the recorded probe coordinates. A single success bit is not proof of a physical transition or trustworthy measurement. Do not use normal LinuxCNC probing as a personnel-safety function.

**Evidence:** SOURCE-CONFIRMED interpreter/Task/motion predicates; DOC-CONFIRMED nominal G38 semantics; TEST-CONFIRMED none; UNKNOWN actual sensor edge, servo latency, stop distance, probe calibration, and any installed machine behavior. No tests, workflows, physical operation, or hosted/self-hosted compute. This is a new source question, not reopening graduated 1000/2000/3000 competencies.

**Next:** trace the exact Task/NGC synchronization and `#5061–#5070` update order across an unsuccessful G38.3 move or inspect an upstream probe fixture; freeze a bounded no-hardware lab only if static evidence leaves a consequential ambiguity and isolated self-hosted dispatch is available.
