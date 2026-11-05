# SPINDLE-238 — M3/M4 default at-speed request and Task forwarding (2026-11-05)

**Track:** 3100 mills / spindle control. **Status:** SOURCE-CONFIRMED for the inspected LinuxCNC v2.9.10 paths; NON-GRADUATED. **No execution or machine test.**

## Why this investigation matters
SPINDLE-236 established the motion-side `atspeed_next_feed` mechanism, but SPINDLE-237 correctly left the canonical default and Task forwarding unverified after a transient upstream retrieval failure. This investigation closes that narrow gap by retrieving the exact upstream implementation, not by extrapolating from documentation.

## Source provenance and bounded trace
Inspected the upstream LinuxCNC `v2.9.10` tag through the public GitHub raw source interface on 2026-11-05. References below identify exact files and line numbers at that tag. For a stronger future immutable audit, resolve and record the tag's peeled commit SHA and source blob hashes; the current evidence is **tag-pinned**, not blob-SHA-pinned.

1. [`src/emc/rs274ngc/interp_convert.cc` lines 3471–3496](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L3471-L3496): M3/M4 conversion invokes `enqueue_START_SPINDLE_CLOCKWISE(...)` or `enqueue_START_SPINDLE_COUNTERCLOCKWISE(...)` with a spindle number and **no explicit wait argument**.
2. [`src/emc/nml_intf/canon.hh` lines 528–533](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/nml_intf/canon.hh#L528-L533): both canonical declarations specify `int wait_for_atspeed = 1`. Consequently, the one-argument calls in this compilation path request at-speed synchronization by default. This is a C++ default argument at the call site, not a global rule about all spindle commands.
3. [`src/emc/task/emccanon.cc` lines 1870–1915](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc#L1870-L1915): clockwise and counterclockwise implementations flush queued segments, set direction and CSS or ordinary speed, copy `wait_for_atspeed` into `EMC_SPINDLE_ON.wait_for_spindle_at_speed`, and append the message to the interpreter list.
4. [`src/emc/task/emctaskmain.cc` lines 2004–2008](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc#L2004-L2008): Task passes `spindle_on_msg->wait_for_spindle_at_speed` to `emcSpindleOn(...)` alongside spindle, speed, factor and xoffset.
5. [`src/emc/task/taskintf.cc` lines 1924–1933](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/taskintf.cc#L1924-L1933): `emcSpindleOn` constructs `EMCMOT_SPINDLE_ON` and assigns `emcmotCommand.wait_for_spindle_at_speed = wait_for_at_speed` before writing the motion command.

**Result:** The ordinary M3/M4 interpreter call path requests `wait_for_atspeed=1` by default and forwards it to motion without a Task-layer override in the inspected dispatch. Combined with SPINDLE-236, this explains why a subsequent eligible feed can wait for spindle-at-speed; it **does not** mean M3 blocks until measured speed is ready, that every G1 always waits, or that HAL feedback necessarily represents actual RPM.

## Minimal reproducible source audit (read-only)
```sh
git clone --filter=blob:none https://github.com/LinuxCNC/linuxcnc.git
cd linuxcnc
git checkout v2.9.10
git rev-parse HEAD
grep -n 'START_SPINDLE_CLOCKWISE\|START_SPINDLE_COUNTERCLOCKWISE' src/emc/nml_intf/canon.hh src/emc/rs274ngc/interp_convert.cc
grep -n 'wait_for_spindle_at_speed' src/emc/task/emccanon.cc src/emc/task/emctaskmain.cc src/emc/task/taskintf.cc
```
Record the checkout SHA and `git hash-object` for each source before treating it as immutable provenance.

## Practical diagnostic walkthrough
For a mill where `M3 S6000` is followed by `G1 X10 F100` and the feed never begins: first check `motion.spindle-at-speed` / spindle-specific HAL feedback and the scheduled comparator function, not merely the commanded RPM or VFD enable. Compare the HAL input and output pins with `halcmd show pin`, inspect the `addf` order and confirm the speed feedback is updated before the motion-controller consumes it. Use a controlled simulation first; do not bypass an at-speed interlock to conceal a wiring or scaling problem.

**Discriminating predictions (not executed):**
- One-argument M3/M4 from the interpreter requests a wait flag of 1.
- A direct canonical caller explicitly passing 0 can suppress that request; this says nothing about other prerequisites.
- A stale-low at-speed HAL value can hold a flagged feed even when the VFD indicates a nonzero speed.
- Changing the HAL comparator's scheduling order may change the number of servo passes before the planner sees readiness; it cannot make a physically slow spindle instantly ready.

## Evidence limits and next dependency
This closes the SPINDLE-237 default/Task evidence gap. It does **not** resolve M5 pending-flag cancellation, spindle orientation M19 status/acknowledgement, M6 tool-change completion, multiple-spindle readiness policy, or actual machine timing. Next investigation should trace M5/M19/M6 with the same pinned source discipline, then inspect a real ATC configuration. Do not infer an implementation from a comment or a GUI indication. No GitHub Actions, self-hosted compute, executable tests or physical-machine activity were performed. Existing blind evaluation, graduation and independent personnel-safety gates remain unchanged.
