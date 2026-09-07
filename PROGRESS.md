# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through **S06 — fault injection framework** are **GRADUATED** at 1000 level. **S07 — restart/recovery/state integrity** is the highest-priority unblocked module and is now in **EXPERIMENT** at pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`.

## S07 source + experiment checkpoint

Durable artifacts now include:

- `guides/S07-restart-recovery-state-integrity-research.md`
- `source-analysis/S07-lifecycle-homing-state-ownership.md`
- `source-analysis/S07-launcher-cleanup-startup-boundary.md`
- `call-flows/S07-restart-to-position-revalidation.md`
- `experiments/S07-017-restart-homing-state-plan.md`
- `lab-jobs/017-s07-restart-homing-state.sh`

Pinned source establishes three lifecycle boundaries. First, `hal_lib_init()` gives a userspace process a process-specific RTAPI identity and maps the shared HAL key, while global HAL data is initialized only when needed; a new client PID therefore does not itself prove that the HAL namespace is fresh. Second, `src/emc/motion/homing.c` owns per-joint `homed` state in module-local `H[]`; fresh `base_homing_init()` creates the pins, sets the homing state machine idle/default parameters, and does not restore a previous runtime's homed bit. `HOME_FINISHED` sets `H[j].homed=1`, and the value is published through `joint.N.homed`. Third, `scripts/linuxcnc.in::Cleanup()` tears down userspace controller processes, stops/unloads HAL, stops realtime, removes NML shared memory, and removes the lock file. Service-port disappearance alone is therefore weaker than completed controller teardown.

S07-017 was frozen before implementation. It uses the stock ordinary-homing `tests/linuxcncrsh/linuxcncrsh-test.ini`: runtime A must start unhomed, establish `joint.0.homed=TRUE`, then shut down. Before B starts, the harness independently requires A PID absence, TCP 5007 absence, and disappearance of `joint.0.homed` from HAL. Runtime B must have a distinct launcher identity, expose `joint.0.homed=FALSE` before any new home request, then re-establish TRUE after `set home 0`. The INI SHA-256 must remain unchanged across both runtimes. Ambiguous teardown/identity or forced-homed semantics are HARNESS_INVALID rather than persistence evidence.

The first S07-017 lab launch is triggered by commit `49ba7011e6df1b70b5f5b9be5baeb444a144578d`; no TEST-CONFIRMED claim exists until its own result and exit code are inspected.

### S07 promotion/uncertainty additions

- Absolute-encoder driver/device-specific restart provenance: **2000 / HIGH** — generic 1000-level teaching can establish that revalidation is architecture-specific; exact retained device position/freshness semantics require a selected hardware/driver.
- Abnormal process death and dangling HAL namespace cleanup details across realtime backends: **2000 / MEDIUM** unless S07-017 exposes a core contradiction — orderly restart attribution will independently prove teardown; backend-specific crash recovery is deeper than the representative 1000-level path.

## Existing active promotion queue

Previously recorded S04–S06 promotion items remain active in their graduated handoffs, including device-specific freshness provenance, disagreement timing bounds, physical independence/common-cause coverage, sampler documentation/source conflict, automatic evidence ingestion, and physical fault representativeness.

## Current checkpoint / exact resume point

Continue **S07-017** from EXPERIMENT.

1. Inspect the workflow triggered by `49ba7011e6df1b70b5f5b9be5baeb444a144578d` and read its own `LATEST.exit_code.txt`, stdout, stderr, and metadata. Do not infer PASS from workflow status alone.
2. Apply the frozen gates in `experiments/S07-017-restart-homing-state-plan.md` without weakening them after seeing results. In particular, require the independent A teardown barrier before accepting B as a fresh-runtime observation.
3. If PASS, commit accepted-result reconciliation, compare the observation against the source prediction, then proceed to S07 adversarial exam, corrections, fresh-AI handoff, counterfactual promotion audit, and graduation.
4. If failure is harness-related, classify it explicitly and correct the harness without changing the central prediction. Respect the three-materially-similar-attempt safeguard.
5. Preserve the central teaching regardless of fixture mechanics: successful host/process restart is not evidence that physical machine truth has been recovered; position revalidation semantics are architecture-specific.
