# S07 — restart to position revalidation call flow

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

## Runtime A -> teardown -> runtime B

`linuxcnc <ini>`
→ launcher starts realtime/HAL/control components
→ HAL userspace attaches through `hal_lib_init()`
→ motion/homing module owns and publishes joint homing state
→ configured homing procedure may establish `H[j].homed=1` and G53 relationship
→ shutdown invokes launcher cleanup/component teardown
→ **observation barrier:** old process/service and representative old HAL namespace must disappear
→ start runtime B
→ prove distinct runtime identity and valid fresh HAL namespace
→ inspect newly initialized motion/homing state
→ perform required homing/absolute-position revalidation before treating machine coordinates as established.

## Why the observation barrier is part of the call flow

`hal_lib_init()` maps a shared HAL key and only globally initializes it when needed. A newly observed userspace process can therefore coexist with or momentarily observe an existing namespace. Earlier S04 laboratory development encountered exactly this class of lifecycle race. S07 treats teardown proof as evidence validity, not as optional test hygiene.

## Homing branch

Normal configured homing:

HOME command
→ homing sequence selects joint(s)
→ `H[j].homed` is cleared/re-established by state-machine behavior
→ switch/index/absolute-encoder-specific procedure establishes coordinate relationship
→ `joint.N.homed` publishes accepted homing state.

Machine OFF with `VOLATILE_HOME`:

OFF transition
→ unhome method for volatile joints
→ `set_all_unhomed(... -2 ...)`
→ `H[j].homed=0`
→ `joint.N.homed` publishes false.

This OFF rule is stronger than ordinary nonvolatile homing behavior inside one running motion instance. It does not imply that homing state is a persistent database across a complete process teardown.

## Absolute encoder branch

Current documentation defines `HOME_ABSOLUTE_ENCODER` as changing what happens **when homing is requested**: current joint position is assigned using HOME_OFFSET and the final move can be suppressed. Therefore an absolute encoder can provide a different position-establishment mechanism, but host process restart alone is still not the validating event. Device/driver data provenance and the configured homing/revalidation action remain separate evidence.

## Failure interpretation

- New PID while old HAL namespace is still observable: HARNESS_INVALID for restart-state attribution.
- Fresh runtime starts unhomed: expected software lifecycle result for the representative ordinary-homing fixture; operator/system must establish position before relying on machine coordinates.
- Fresh runtime appears homed only because a simulation homemod forces it: invalid fixture for the representative claim.
- Fresh runtime plus externally retained absolute feedback: requires device-specific validation; do not generalize from process lifecycle alone.
