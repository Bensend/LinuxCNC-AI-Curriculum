# PLASMA-249 — QtPlasmaC shipped simulator: Z external-offset wiring and servo order (2026-11-06)

Status: **SOURCE/CONFIG-CONFIRMED for LinuxCNC v2.9.10; NOT RUNTIME-VERIFIED; NON-GRADUATED.** Follows PLASMA-248. This is a *shipped simulator*, not proof of a real Mesa installation or a physical torch.

## Provenance (immutable Git blobs, LinuxCNC/linuxcnc v2.9.10)
- `configs/sim/qtplasmac/qtplasmac_s_metric.ini` — `47347c3a414343b70e407cd736d7501b852adcd0` (wrapper, `#INCLUDE`).
- `configs/sim/qtplasmac/qtplasmac_metric_ini.inc` — `f1e601637a4be2972bc82bf5cd5d5dbcf5488e88` (effective HAL list, timing, axis limits).
- `configs/sim/qtplasmac/sim_no_stepgen.tcl` — `44cceff7ab2c7da24fcfdf4551e3a6fea2e65a0d` (loads and schedules motion/plasmac).
- `lib/hallib/qtplasmac_comp.hal` — `f3fc216a4932b02a2fe9e8de95cb7c08ced5931e` (external-offset net contract).
- `configs/sim/qtplasmac/sim_postgui.hal` — `f9196162591dc6c49b30b23c671e7c0300b43dad` (simulated arc voltage/sensors).
- PLASMA-248 pinned `src/hal/components/plasmac.comp` blob `8f22cf1789b8adb49fe0a8d7e7cd5bd33444bf6c` (component behavior).

## Effective inclusion chain — do not inspect the wrapper alone
`qtplasmac_s_metric.ini` includes `qtplasmac_metric_ini.inc`. Its `[HAL]` section sets `TWOPASS=ON`, loads `sim_no_stepgen.tcl`, then `qtplasmac_comp.hal`, then `custom.hal`; post-GUI loads `custom_postgui.hal` and `sim_postgui.hal`. `sim_stepgen.tcl` is commented out, not active. `[EMCMOT]` sets `SERVO_PERIOD=1000000` ns. `[KINS]` uses `trivkins coordinates=xyyz` with four joints and `[TRAJ]` coordinates `XYYZ`; Z maps to joint 3 in this configuration.

## Verified HAL connections
`qtplasmac_comp.hal` connects `plasmac.z-offset-counts => axis.z.eoffset-counts`, `plasmac.z-offset-enable => axis.z.eoffset-enable`, and `plasmac.offset-scale => axis.z.eoffset-scale`. The same scale is fanned to X and Y offset-scale; `plasmac.xy-offset-enable` controls both X and Y enables. Feedback `axis.z.eoffset => plasmac.z-offset-current` and `motion.eoffset-active => plasmac.offsets-active` closes the status path. `motion.current-vel => plasmac.current-velocity`, `motion.feed-upm => plasmac.feed-upm`, and `motion.motion-type => plasmac.motion-type` supply motion-dependent THC gates. This is an actual checked-in HAL connection, not merely a component pin declaration.

The simulator's `sim_postgui.hal` wires `sim-torch.voltage-out => plasmac.arc-voltage-in` and GUI-controlled arc-ok/float/ohmic/breakaway inputs through debouncers. **These are simulated process signals, not a validated ADC or torch I/O chain.**

## Same-thread order and latency boundary
`sim_no_stepgen.tcl` adds to `servo-thread` in this order:
1. `motion-command-handler`
2. `motion-controller`
3. `plasmac`
4. simulated joint PID/mux/velocity and home-switch functions
5. debounce functions

Thus **motion-controller executes before plasmac in each servo cycle**. The newly calculated `plasmac.z-offset-counts` cannot affect the already-executed motion-controller invocation in that same cycle. It becomes eligible for consumption on the following motion-controller invocation, assuming the motion implementation samples that pin as expected. This is a schedule-based **INFERENCE about effective one-servo-cycle response**, not a measured delay; command timing, HAL pin publication, external-offset filtering/limits and process scheduling can add latency. Likewise, the debouncers execute after plasmac and their newly computed outputs cannot be read by plasmac until a later invocation.

The simulator has **no Mesa read/write functions**; do not describe its schedule as `Mesa read → motion → plasmac → Mesa write`. For real hardware, inspect that machine's actual HAL addf order separately.

## External-offset motion budget
The included INI sets `[AXIS_Z] MAX_VELOCITY=120`, `MAX_ACCELERATION=1200`, `OFFSET_AV_RATIO=0.5`; `[JOINT_3]` max velocity/acceleration are 60/600 (mm/s, mm/s²). The INI comments say axis limits are double corresponding joint limits and the ratio shares available axis motion budget equally between planned motion and external offset. This is **CONFIG-CONFIRMED intended allocation**, not proof of runtime clamp implementation; follow the motion source before claiming exact clipping/interaction at limits.

## Reproducible inspection (no machine required)
At pinned upstream tag `v2.9.10`:
```sh
git show v2.9.10:configs/sim/qtplasmac/qtplasmac_s_metric.ini
git show v2.9.10:configs/sim/qtplasmac/qtplasmac_metric_ini.inc
git show v2.9.10:configs/sim/qtplasmac/sim_no_stepgen.tcl
git show v2.9.10:lib/hallib/qtplasmac_comp.hal
git show v2.9.10:configs/sim/qtplasmac/sim_postgui.hal
```
With an isolated, compatible LinuxCNC simulator, log `axis.z.eoffset`, `axis.z.eoffset-counts`, `axis.z.eoffset-enable`, `plasmac.z-offset-counts`, `motion.current-vel`, `plasmac.thc-active` and arc-voltage feedback at servo cadence. Compare THC lock/release and offset response at controlled velocity transitions. Capture the exact config, sample timestamps, limits, and command sequence. **Not executed in this session.**

## Predictions and falsifiers (pre-runtime)
- When the plasmac output counts change after `motion-controller` runs, the motion update cannot reflect that newly calculated value *in that earlier invocation*. A trace showing an immediate same-invocation response would falsify the assumed scheduling interpretation.
- With offset enable false, count changes should not produce an active external offset; if they do, inspect motion pin semantics and existing offset state before blaming THC.
- A GUI display of simulated voltage is not independent proof of hardware ADC correctness; substituting a real voltage acquisition chain requires a separate wiring and scaling audit.
- Reducing feed below the PLASMA-248 anti-dive threshold should inhibit THC even while arc voltage remains present; capture actual state transitions before calling this TEST-CONFIRMED.

## Evidence ledger and next dependencies
| Claim | Class | Evidence | Open item |
|---|---|---|---|
| INI wrapper loads included metric configuration | CONFIG-CONFIRMED | two pinned INI blobs | runtime parser check |
| QtPlasmaC outputs wired to axis.z eoffset pins | CONFIG-CONFIRMED | pinned qtplasmac_comp.hal | runtime value trace |
| motion-controller precedes plasmac | CONFIG-CONFIRMED | pinned sim_no_stepgen.tcl | runtime latency measurement |
| one-cycle minimum for newly computed offset | INFERENCE | HAL order | source sampling path + servo trace |
| actual torch response | UNKNOWN | simulator only | physical machine evidence |
| exact external-offset limit/clamp behavior | UNKNOWN | INI intent only | motion source trace |

Next: **PLASMA-250** inspect LinuxCNC v2.9.10 motion source for axis external-offset count conversion, enable, velocity/acceleration limiting and homing/limit interactions; tie it to the above 1 ms simulation order. If diminishing returns, rotate to 4000 HostMot2 or 3300 plasma DXF/CAM interface. Preserve independent personnel safety authority; simulator tool-change loopback and fake sensors are not a real machine permissive. No compute or Actions used.
