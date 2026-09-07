# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through **S06 — fault injection framework** are **GRADUATED** at 1000 level. **S07 — restart/recovery/state integrity** is the highest-priority unblocked module and is now in **SOURCE** at pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`.

## S07 source checkpoint

Durable artifacts now include:

- `guides/S07-restart-recovery-state-integrity-research.md`
- `source-analysis/S07-lifecycle-homing-state-ownership.md`
- `call-flows/S07-restart-to-position-revalidation.md`

Pinned source establishes two important lifecycle boundaries. First, `hal_lib_init()` gives a userspace process a process-specific RTAPI identity and maps the shared HAL key, while global HAL data is initialized only when needed; a new client PID therefore does not itself prove that the HAL namespace is fresh. `hal_lib_exit()` is separately reference-counted and diagnoses final library exit while component references remain. Second, `src/emc/motion/homing.c` owns per-joint `homed` state in module-local `H[]`, publishes it through `joint.N.homed`, and `set_all_unhomed()` explicitly clears it. `VOLATILE_HOME` is an additional OFF-transition invalidation rule, not a persistence facility.

Current documentation reconciles with this model: homing establishes G53 machine origin; `VOLATILE_HOME` unhomes a joint on machine OFF when position may not be maintained; `HOME_ABSOLUTE_ENCODER` changes the configured homing/re-establishment procedure but does not make host process restart itself proof of position truth.

### S07 promotion/uncertainty additions

- Absolute-encoder driver/device-specific restart provenance: **2000 / HIGH** — generic 1000-level teaching can establish that revalidation is architecture-specific; exact retained device position/freshness semantics require a selected hardware/driver.
- Abnormal process death and dangling HAL namespace cleanup details across realtime backends: **2000 / MEDIUM** unless S07-017 exposes a core contradiction — orderly restart attribution will independently prove teardown; backend-specific crash recovery is deeper than the representative 1000-level path.

## Existing active promotion queue

Previously recorded S04–S06 promotion items remain active in their graduated handoffs, including device-specific freshness provenance, disagreement timing bounds, physical independence/common-cause coverage, sampler documentation/source conflict, automatic evidence ingestion, and physical fault representativeness.

## Current checkpoint / exact resume point

Continue **S07** from SOURCE toward EXPERIMENT.

1. Finish targeted pinned source inspection of launcher `Cleanup()` ordering and the representative motion startup initialization that makes the selected ordinary-homing fixture initially unhomed. Do not over-investigate backend-specific crash cleanup unless it threatens the representative conclusion.
2. Preserve targeted community findings only where they add a concrete restart/rehome trap; treat them as leads, not proof.
3. Freeze **S07-017** before implementation. Required experiment structure: runtime A healthy control -> establish ordinary `joint.0.homed=TRUE` -> record runtime/service/HAL identity -> orderly shutdown -> independently require old service endpoint and representative HAL namespace to disappear -> runtime B from same INI -> prove distinct fresh identity -> observe initial `joint.0.homed` before any homing request -> home again and prove state can be re-established.
4. Include a persistent configuration/file value only as a contrast if its ownership is unambiguous. Do not use a simulation homemod that forces homed state.
5. Predeclare HARNESS_INVALID separately: ambiguous teardown, ambiguous new-runtime identity, forced-homed simulation semantics, or inability to observe the selected pin invalidates lifecycle attribution.
6. Central prediction to freeze: reuse of the same INI does not inherit the representative ordinary motion homing state into a genuinely fresh runtime; successful process restart is not physical-machine recovery.
