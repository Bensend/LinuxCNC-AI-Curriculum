# SPINDLE-240 — realtime spindle stop/orient and iocontrol M6 acknowledgement (2026-11-05)

**Scope:** 3100 mill spindle/tool-change implementation, transferable to 3200 lathes. **Status:** SOURCE-CONFIRMED for inspected LinuxCNC `v2.9.10` paths, NON-GRADUATED; no executable or physical tests.

## Immutable provenance and source locations

Retrieved via GitHub repository connector at tag `v2.9.10`, 2026-11-05. Git blob SHA-1s: `src/emc/motion/command.c` **0b79061d39be915bbea548b2c33bb794d31ab302**; `src/emc/motion/control.c` **b6e45d590c7d11030654d8f7d13d118f581b6439**; `src/emc/motion/motion.c` **febe7f3ff3f2b80e34b00a9e60d3cdb3e9e41841**; `src/emc/iotask/ioControl.cc` **09cbd6ff4e5e119df04e61ffb8916b283a2f2014**; `src/emc/task/emctaskmain.cc` **7292a172023a5b42b023447c2458cb766c93fc9b**. Tag's peeled commit remains to be recorded. Links below identify symbol/line ranges; claims are revision-specific.

## Mechanism findings

1. **M5 command clears requested spindle state, not verified physical rotation.** [command.c L1630–1659](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c#L1630-L1659): `EMCMOT_SPINDLE_OFF` sets each selected spindle's `state=0`, `speed=0`, `direction=0`, `brake=1`; clears `spindle_locked`, `spindle_orient`, and sets `orient_state=NONE`. The **inspected OFF case does not reset `emcmotStatus->atspeed_next_feed`**, whereas [L1622](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c#L1610-L1627) sets that global pending flag during ON. **INFERENCE:** an ON then OFF before an eligible feed may retain a pending next-feed wait, subject to other code paths. This is a precise, falsifiable test candidate, *not* a demonstrated stall. Do not infer mechanical standstill from commanded zero.

2. **M19 publishes an orientation request, not an encoder-verified angular result.** [command.c L1661–1704](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c#L1661-L1704) sets `orient_state=IN_PROGRESS`, requested speed/direction zero, brake released, spindle on output zero, `orient-angle`, `orient-mode`, `locked=0`, `orient=1`, and resets orient fault status. [motion.c L723–728](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/motion.c#L723-L728) declares HAL output pins `spindle.N.orient-angle`, `orient-mode`, `orient`, `locked` and input pins `is-oriented`, `orient-fault`. The external drive/HAL must implement actual orientation and acknowledge it.

3. **Orientation status follows HAL inputs while orientation is requested.** [control.c L520–539](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/control.c#L520-L539): nonzero `orient-fault` takes precedence, marks FAULTED, clears orient request, reports error and aborts trajectory. Otherwise `is-oriented` sets `orient=0`, `locked=1`, `brake=1`, `orient_state=COMPLETE`. This confirms the status transition, **not** actual physical angle, independent zero-speed verification, or whether external HAL feedback is trustworthy. SPINDLE-239's Task Q wait is an additional, separate layer; do not treat Task completion as physical confirmation.

4. **M6's iocontrol acknowledgement is HAL-level.** [emctaskmain.cc L1536–1550](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc#L1536-L1550) requires motion and I/O wait for `EMC_TOOL_LOAD`; [L2073–2075](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc#L2073-L2075) forwards to `emcToolLoad()`. [ioControl.cc L937–966](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/iotask/ioControl.cc#L937-L966) asserts `iocontrol.0.tool-change` for a load that requires a change and sets `RCS_EXEC` pending response. [L608–652](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/iotask/ioControl.cc#L608-L652) accepts simultaneous `tool-change && tool-changed`, updates tool-in-spindle and table, clears tool-change, and returns `RCS_DONE`. Tool preparation has an analogous `tool-prepare && tool-prepared` handshake. There are early exits for already-loaded tools and particular random/nonrandom pocket cases. **An asserted `tool-changed` is not by itself proof of a mechanically completed exchange**; that guarantee belongs to the external ATC controller and independently validated feedback.

## Reproducible review exercise (not executed)

At a pinned LinuxCNC checkout, inspect:
```sh
git checkout v2.9.10
sed -n '1608,1706p' src/emc/motion/command.c
sed -n '505,540p' src/emc/motion/control.c
sed -n '720,738p' src/emc/motion/motion.c
sed -n '600,655p' src/emc/iotask/ioControl.cc
sed -n '935,969p' src/emc/iotask/ioControl.cc
```
For a **simulation-only** ATC, drive `iocontrol.0.tool-changed` low while `tool-change` is high; expect I/O execution pending, then assert `tool-changed` and inspect `RCS_DONE`, `tool-number`, and reset. Also test already-loaded tool bypass, false acknowledgement, orient-fault vs is-oriented simultaneous assertion, and M3→M5→G1 with `at-speed=0`. These are **analytical predictions, not test results**. Do not connect a fake acknowledgement to a physical changer.

## Evidence ledger / limits

**SOURCE-CONFIRMED:** spindle OFF command fields and orient cancellation; M19 output/feedback state machine; iocontrol prepare/load handshake; Task I/O wait classification. **INFERENCE:** possible retained pending at-speed flag after M5; potential next-feed wait. **UNKNOWN:** other resets to pending flag on abort/reinitialization; runtime reproduction; exact multi-spindle Task wait and timeout edge cases; physical encoder angle and ATC feedback validity; real Mesa ATC wiring. No builds, simulations, hosted Actions, self-hosted compute, or physical operations performed. Existing graduation/blind/independent personnel-safety gates unchanged.

**Next:** inspect all assignments to `atspeed_next_feed` across motion and abort lifecycle, then use a real Mesa ATC HAL/INI to trace the complete feedback path; if no independently inspectable ATC config is available, rotate to 3200 G33/G76 spindle index/phase source implementation rather than manufacturing an example.
