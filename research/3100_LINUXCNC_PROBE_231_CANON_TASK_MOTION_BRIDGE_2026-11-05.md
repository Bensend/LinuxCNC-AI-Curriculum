# PROBE-231 — G38.x canonical → Task → motion command bridge (3100 mills, non-graduated)

## Evidence scope
Read START_HERE and mission, numbering, work-selection, source, curriculum, blind and compute governance; resume PROBE-230. Source inspection is limited to LinuxCNC tag **v2.9.10**. This is **SOURCE-CONFIRMED for the command bridge**, not runtime-tested. Immutable upstream Git blob IDs:

- [emccanon.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc) `663e9b7eb1504bbc2e59a404abe67cdc8a6bcc11`, `STRAIGHT_PROBE` around line 1141, `TURN_PROBE_ON` around 2431, `GET_EXTERNAL_PROBE_TRIPPED_VALUE` around 2732.
- [emctaskmain.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc) `7292a172023a5b42b023447c2458cb766c93fc9b`, `EMC_TRAJ_PROBE_TYPE` dispatch around 1915, execution synchronization around 1506.
- [taskintf.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/taskintf.cc) `96a041d1feef8560f37159a2f18b109171f084c3`, `emcTrajProbe` around 1489.
- [interp_execute.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_execute.cc) `4e0367f84676142ebacb7024795aa9bc3a85b589`, `probe_flag` returns `INTERP_EXECUTE_FINISH` around 319.
- PROBE-230 pins [interp_convert.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc) `f01a359652d588d59c9e210fa441a99d2ee19598`, [command.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c) `0b79061d39be915bbea548b2c33bb794d31ab302`, and [control.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/control.c) `b6e45d590c7d11030654d8f7d13d118f581b6439`.

## Concrete implementation path

1. Interpreter `convert_probe` encodes G38.2/3/4/5 into `probe_type` 0/1/2/3 and emits `TURN_PROBE_ON`, `STRAIGHT_PROBE(..., probe_type)`, `TURN_PROBE_OFF`; `probe_flag` causes the interpreter to finish/synchronize instead of immediately consuming subsequent blocks.
2. Canonical `STRAIGHT_PROBE` constructs `EMC_TRAJ_PROBE` (rather than a regular linear move), transforms program coordinates, and carries the `probe_type` byte. `TURN_PROBE_ON` queues `EMC_TRAJ_CLEAR_PROBE_TRIPPED_FLAG`; therefore the prior result flag is deliberately cleared before a new probe transaction.
3. Task's `EMC_TRAJ_PROBE_TYPE` handler passes `pos`, `type`, `vel`, `ini_maxvel`, `acc`, and **`probe_type`** to `emcTrajProbe`. Task classifies the probe command as waiting for motion and I/O, with a comment explicitly preventing blending.
4. `emcTrajProbe` assigns `EMCMOT_PROBE` to `emcmotCommand.command` and transfers motion parameters to the motion interface. The downstream `EMCMOT_PROBE` admission and sampled input/abort path are pinned in PROBE-230.
5. Canonical `GET_EXTERNAL_PROBE_TRIPPED_VALUE` reads `emcStatus->motion.traj.probe_tripped`. This proves a status-accessor path, **not yet the exact interpreter parameter-index writeback** to `#5061`–`#5070`.

## Distinctions and practical failure interpretation

- A successful command admission, a completed probe motion, and a successful contact are **three different states**. Probe position may be populated even on an unsuccessful probe (PROBE-230); consumer code must check the success flag.
- Clearing a prior `probe_tripped` value at command start matters: a stale prior success must not be interpreted as the current touch. Source ordering and NML status refresh must still be checked in any executable test.
- Probe trigger coordinates are sampled Cartesian feedback, not an FPGA-latched edge coordinate. Stop position can differ due to servo sampling and deceleration; neither hardware contact timing nor overshoot has been measured.
- The probe pin is an application input, not independent personnel protection. No live machine, motion enabling, or hardware experiment is authorized by this document.

## Reproducible disconnected exercise (inspection only)

At LinuxCNC tag `v2.9.10`, inspect `convert_probe` → `STRAIGHT_PROBE` → Task `EMC_TRAJ_PROBE_TYPE` → `emcTrajProbe` → `EMCMOT_PROBE`. Record each stage's message type and the unchanged 0/1/2/3 probe type. Independently inspect the task's wait-for-motion classification and interpreter's `probe_flag` sync. Analytical expectation: G38.3 (type 1) differs from G38.2 (type 0) in suppressed-failure semantics, not in its motion message family. No executable test was run; treat this as a falsifiable source walkthrough rather than a PASS.

## Evidence ledger and next checkpoint

**SOURCE-CONFIRMED (v2.9.10):** canonical probe message construction, Task dispatch with `probe_type`, Task wait-for-motion classification, motion-interface command type, status accessor, interpreter synchronization. **SOURCE-CONFIRMED from PROBE-230:** probe input state/abort and unsuccessful completion. **UNVERIFIED:** precise `#5061`–`#5070` writeback and coordinate-frame mapping, real mill probe HAL/INI polarity/debounce, runtime synchronization/race outcomes, actual stopping error. Do not graduate or claim TEST-CONFIRMED.

Next: find interpreter parameter publication code by searching for `GET_EXTERNAL_PROBE_POSITION`, `GET_EXTERNAL_PROBE_TRIPPED_VALUE`, `5061`, `5070`, `probe_flag` across the v2.9.10 source tree; pin the exact writer and frame transforms. Then inspect a real mill HAL/INI probe signal, including thread order, polarity and filtering. Rotate to tool-change or spindle internals if probing source yields no new evidence. Preserve blind evaluation, graduated levels and independent personnel-safety authority. No compute or GitHub Actions dispatched; only `[self-hosted, openpressbrake]` permitted if a justified future test is designed.
