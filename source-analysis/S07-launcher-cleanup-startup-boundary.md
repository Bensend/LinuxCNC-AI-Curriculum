# S07 — launcher cleanup and homing startup boundary

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

## Orderly launcher cleanup

`scripts/linuxcnc.in::Cleanup()` is deliberately broader than killing one UI process. It first terminates display/helper processes, optionally executes `[HAL]SHUTDOWN`, terminates `linuxcncsvr`, `milltask`, and `motion-logger`, calls `halcmd stop`, then `halcmd unload all`, waits for the HAL component list to collapse, invokes `realtime stop`, removes configured NML shared-memory segments, and finally removes `/tmp/linuxcnc.lock`. `KillTaskWithTimeout()` first sends TERM and escalates to KILL after a bounded wait.

This establishes an important S07 evidence rule: disappearance of the linuxcncrsh TCP endpoint alone is weaker than completed controller teardown. The representative experiment must separately require the old service endpoint to disappear and a representative motion/HAL object to disappear before runtime B is started.

The launcher's stale-lock path itself calls `Cleanup other` and waits for the prior lock file to disappear. This is useful operational recovery behavior, but it is not evidence that machine position has been physically re-established.

## Fresh homing-module initialization

`src/emc/motion/motion.c` calls `homing_init(...)`; the default `homing_init()` delegates to `base_homing_init()` in `src/emc/motion/homing.c`. `base_homing_init()` binds the new motion joint array, creates homing pins, sets `homing_active=0`, and initializes each `H[i]` entry with `HOME_IDLE`, zero velocities/offset/home/flags, an unrealizable startup sequence `1000`, and `volatile_home=0`. The static `H[]` storage is zero-initialized for a freshly loaded module, so `H[i].homed` begins false; initialization does not load a previous runtime's homed bit from the INI or a persistence file.

Normal configuration is applied later through `set_joint_homing_params()`. Completing `HOME_FINISHED` sets `H[j].homed=1`; `HOME_ABORT` clears it. `write_homing_out_pins()` publishes `H[j].homed` as `joint.N.homed`.

Therefore the representative source prediction is precise: after a genuinely fresh unload/reload, ordinary homing state is reconstructed as unhomed and must be re-established by the configured homing procedure. Reusing the same INI is configuration persistence, not homing-state persistence.

## Boundary / non-claims

This does not claim that all physical machines must execute a switch-search cycle after every host restart. Absolute-encoder and architecture-specific recovery can establish position by different configured procedures. It also does not prove abnormal-crash cleanup behavior across realtime backends. Those remain promoted S07 items. The 1000-level claim is narrower: process restart and configuration reuse are not themselves proof of retained physical position truth.
