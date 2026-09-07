# S07 — lifecycle and homing state ownership

Course level: 1000  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`  
Evidence: SOURCE-CONFIRMED unless otherwise marked.

## HAL lifetime boundary

Pinned `src/hal/hal_lib.c` separates a process-local library mapping/reference lifetime from the shared HAL namespace. `hal_lib_init()` creates a process-specific RTAPI identity (`HAL_LIB_<pid>`), opens/maps the HAL shared-memory key, and calls `init_hal_data()`. The source comment is explicit that global HAL data is initialized only if not already initialized; therefore attachment by a new userspace process is not itself evidence that the global HAL namespace was recreated.

`hal_lib_exit()` is reference counted. On its final library exit it releases that process's RTAPI/shared-memory resources only when the process's `hal_init()` component reference count is zero. If component references remain, it reports an error/dangling-reference condition rather than pretending orderly component teardown occurred.

**Teaching consequence:** process identity, process-local HAL mapping identity, component lifetime, and global HAL shared-memory lifetime are different observables. A restart experiment must independently prove the old runtime/namespace has disappeared before attributing initial state to a fresh runtime.

## Homing state ownership

Pinned `src/emc/motion/homing.c` owns per-joint homing state in static module-local `H[]`. `home_local_data` contains `home_state`, `homing`, `homed`, switch/index state, configuration values, and `volatile_home`. HAL pins `joint.N.homing`, `joint.N.homed`, and `joint.N.home-state` publish that module's state.

`set_all_unhomed()` explicitly clears `H[jno].homed`. Method `-1` clears all active joints; method `-2` clears only joints configured `volatile_home`. This gives VOLATILE_HOME a precise meaning: it is an additional OFF-transition invalidation rule, not a general persistence mechanism.

The homing sequence also clears/re-establishes homing state as it runs. The resulting `homed` bit is therefore software state representing completion/acceptance of the configured homing procedure; it must not be interpreted as an independent measurement of present physical truth.

## Documentation reconciliation

Current LinuxCNC homing documentation says homing establishes G53 machine origin and soft-limit reference. It documents `VOLATILE_HOME` as unhoming a joint whenever the machine transitions OFF, appropriate when the drive does not maintain position while off. It separately documents `HOME_ABSOLUTE_ENCODER=1/2`: on a homing request the current joint position is assigned according to HOME_OFFSET, with the final move optional. These are configuration-specific re-establishment semantics, not evidence that a fresh LinuxCNC process automatically knows physical position.

## State ownership/reset matrix

| State | Owner/storage | Representative initialization/reset | Observable | Physical-truth implication |
|---|---|---|---|---|
| HAL library mapping | userspace process + RTAPI mapping | `hal_lib_init/exit` refcount | process/RTAPI identity | none |
| Global HAL namespace/data | HAL shared memory | first initialization when not already initialized; survives individual attachment while namespace remains | HAL names/components | none by itself |
| HAL component record | HAL shared memory | `hal_init` / `hal_exit`; dangling refs are diagnosable | component list/readiness | component existence, not device truth |
| Joint homed | motion homing module `H[j].homed` | homing/unhoming state machine; volatile-home invalidation | `joint.N.homed` | configured position-establishment procedure accepted; not an independent freshness proof |
| Joint homing state | motion homing module | HOME state machine | `joint.N.homing`, `joint.N.home-state` | procedure progress only |
| G53 origin relationship | motion state established by homing semantics | configured homing/absolute-encoder procedure | machine coordinates + homed state | trustworthy only to extent sensor/mechanics/config are valid |
| External absolute encoder position | physical device/driver | device-specific | driver-specific feedback | may preserve physical position across host restart, but LinuxCNC must explicitly consume/revalidate it |
| INI configuration | filesystem | persists across process restart | config file/runtime parameters | persistent intent/configuration, not live machine state |

## Complete representative reasoning path

1. `linuxcnc` launcher creates a control runtime and HAL/realtime components.
2. HAL clients map the shared namespace through `hal_lib_init()`; a new client PID does not prove the namespace is new.
3. Motion's homing module owns `H[].homed` and publishes `joint.N.homed`.
4. A homing request runs the configured procedure and establishes the software machine-coordinate relationship; an unhome path clears it.
5. `VOLATILE_HOME` adds invalidation on machine OFF for joints that may lose physical position.
6. Launcher/process teardown and a subsequent new PID prove software lifecycle only. The restart must establish a clean namespace and then separately establish whatever physical position/freshness semantics the machine architecture requires.

## S07-017 experiment constraints derived from source

The experiment should use a normal simulated joint with explicit homing semantics, establish `joint.0.homed=TRUE` in runtime A, record runtime/HAL identity, shut runtime A down, independently prove both its service endpoint and representative HAL namespace disappear, then launch runtime B from the same configuration. Runtime B must be proven fresh before reading `joint.0.homed`. Prediction: ordinary volatile homing state is not inherited merely because the same INI is reused. A persisted file/config value may be included only as a contrast showing that persistent configuration and volatile runtime state have different owners.

HARNESS_INVALID conditions include ambiguous old-runtime teardown, inability to prove new-runtime identity, or a simulation homemod that forces homed state independently of the normal homing state machine.

## Non-claims / safety boundary

This source trace does not establish absolute-encoder driver behavior, physical stopping, actuator de-energization, brake/hydraulic state, sensor freshness, mechanical synchronization, or safety integrity after restart. Software restart is not physical recovery.
