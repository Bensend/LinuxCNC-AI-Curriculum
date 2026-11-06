# PLASMA-256 — QtPlasmaC M190 discovery and M66 Task-level acknowledgment (2026-11-06)

**Status:** SOURCE/CONFIG-CONFIRMED for LinuxCNC v2.9.10, non-graduated, no runtime test. Follows PLASMA-255. This is a G-code/Task and userspace integration trace, not a personnel-safety claim.

## Immutable source provenance

- [QtPlasmaC metric simulator wrapper](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/qtplasmac/qtplasmac_s_metric.ini), blob `47347c3a414343b70e407cd736d7501b852adcd0`: [DISPLAY] PROGRAM_PREFIX and #INCLUDE.
- [QtPlasmaC included metric INI](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/qtplasmac/qtplasmac_metric_ini.inc), blob `f1e601637a4be2972bc82bf5cd5d5dbcf5488e88`: [RS274NGC] USER_M_PATH.
- [Task custom-M directory discovery](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctask.cc), blob `ef96ceb4de247a96a1ff64309850383864d05179`, around lines 120–164.
- [Interpreter M66 conversion](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc), blob `f01a359652d588d59c9e210fa441a99d2ee19598`, `convert_m` around lines 3275–3377.
- [Task M66 wait executor](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc), blob `7292a172023a5b42b023447c2458cb766c93fc9b`, around lines 1923–1934 and 2735–2790.
- [QtPlasmaC M190 program](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/usr_intf/qtplasmac/M190), blob `825ebe01292346d78580422d871264f5393644a6`; GUI install/copy behavior and acknowledgment detailed in PLASMA-255.

## Finding A — M190 is an external user M-code, not an INI REMAP declaration

**CONFIG/SOURCE-CONFIRMED.** The simulator wrapper defines `[DISPLAY] PROGRAM_PREFIX = ../../nc_files` and includes `qtplasmac_metric_ini.inc`. The included file defines `[RS274NGC] USER_M_PATH = ./:../../nc_files`. In `emctask.cc`, Task discovers custom M programs from [DISPLAY] PROGRAM_PREFIX and colon-separated [RS274NGC] USER_M_PATH (lines 120–164). This supports the QtPlasmaC handler's copying an executable `M190` file to a configuration-visible directory, rather than requiring an explicit `REMAP=M190 ...` INI entry. **Do not label M190 a built-in G-code or assume a copied file is executable/discoverable**: inspect filesystem permissions, actual launch directory, executable M190 path, and machine-specific INI.

The prior checkpoint asked for an “M190 remap INI.” That was overly specific: the correct admission test is *user-defined M-code discovery* through Task's search path. An absence of `REMAP=M190` is not by itself a configuration defect.

## Finding B — M66 P3 L3 Q1 is an existing-high-level check, not a fresh-edge acknowledgment

**SOURCE-CONFIRMED.** `interp_convert.cc` handles M66 in `convert_m`: P selects the digital input, L selects wait mode, Q supplies timeout; it emits canonical `WAIT(index, DIGITAL_INPUT, type, timeout)` and marks an input-queue boundary. Task's `EMC_AUX_INPUT_WAIT` handler records input index/mode and sets a deadline. In `emctaskmain.cc` around lines 2748–2757, `WAIT_MODE_HIGH` completes whenever `emcStatus->motion.synch_di[index] != 0`, clearing the timeout flag and marking execution done. **There is no fresh-low prerequisite in this HIGH branch.** The separate `WAIT_MODE_RISE` branch first looks for low, then switches to HIGH (lines 2759–2762). Therefore an already-high digital input 03 can satisfy `M66 P3 L3 Q1` even if no new material-selection event occurred. This upgrades PLASMA-255's *stale-high possibility* from mere conjecture to **source-confirmed level semantics**; whether a particular QtPlasmaC GUI leaves that pin high at the critical instant remains **runtime-unknown**.

**SOURCE-CONFIRMED timeout reporting:** the Task wait initializes `input_timeout=2` for a pending timed wait; completion clears it to 0; when the deadline expires with a pending wait it becomes 1. Do not confuse the Task M66 `input_timeout` with QtPlasmaC's separate userspace `material_change_timeout` pin. An M66 timeout is not an automatic assertion of an independent hardware safety interlock.

## Discriminating exercise (offline, no machine motion)

Prepare an isolated simulator only if the runtime prerequisite is satisfied; never substitute fake process signals for machine safety. Observe `motion.digital-in-03`, `qtplasmac.material_change`, `qtplasmac.material_change_timeout`, Task `input_timeout`, and effective `plasmac.cut-feed-rate` while testing:

1. **Input already HIGH:** execute `M66 P3 L3 Q1`; expect immediate/next Task-poll success without a new edge (source prediction). Compare `M66 P3 L1 Q1` only after confirming the exact documented L1 edge mode; Task's rise mode first needs a low observation.
2. **Input held LOW:** expect M66 deadline expiry and Task `input_timeout=1`; independently record M190's 0.5 s state-poll timeout, if a material change was requested.
3. **New material:** observe M190 request, GUI material selection and feed update, digital input low/high, then M66 completion. Assert the actual selected material number and feed, not just the M66 return.
4. **Already-selected material:** verify state-3 path, digital-in-03 acknowledgment and reset behavior.
5. **Unknown material/GUI stalled:** separate G-code-filter rejection, userspace M190 timeout, and Task M66 timeout; preserve all error outputs.

Expected results above are **falsifiable predictions, not executed observations**. If running an executable fixture later, use only a justified isolated `[self-hosted, openpressbrake]` runner; never GitHub-hosted Actions or physical equipment. Record exact tag, INI, HAL, command file, logs, actual job runtime and output.

## Reproduce source inspection

```sh
git -C linuxcnc show v2.9.10:configs/sim/qtplasmac/qtplasmac_s_metric.ini
git -C linuxcnc show v2.9.10:configs/sim/qtplasmac/qtplasmac_metric_ini.inc
git -C linuxcnc grep -n -E 'PROGRAM_PREFIX|USER_M_PATH' v2.9.10 -- src/emc/task/emctask.cc
git -C linuxcnc grep -n -E 'WAIT_MODE_HIGH|WAIT_MODE_RISE|input_timeout|emcAuxInputWaitIndex' v2.9.10 -- src/emc/task/emctaskmain.cc
git -C linuxcnc grep -n 'block->m_modes\[5\] == 66' v2.9.10 -- src/emc/rs274ngc/interp_convert.cc
```

## Evidence limits and next

No simulator, interpreter runtime, nesting engine, GitHub Actions, self-hosted compute or physical machine executed. M190's exact installation/permission behavior on a real machine and QtPlasmaC GUI timing remain open. **Next:** rotate to a pinned, inspectable open-source nesting engine's actual geometry/placement and license; evaluate DXF → polygon → placement → QtPlasmaC G-code boundaries and a minimal negative fixture. Avoid making a product build compulsory. Preserve graduated modules, independent personnel-safety authority, blind evaluator separation and evidence gates.
