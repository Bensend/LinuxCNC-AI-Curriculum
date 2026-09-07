# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through **S06 — fault injection framework** are **GRADUATED** at 1000 level. **S07 — restart/recovery/state integrity** is the highest-priority unblocked module and remains in **EXPERIMENT** at pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`.

## S07 source + experiment checkpoint

Durable artifacts now include:

- `guides/S07-restart-recovery-state-integrity-research.md`
- `source-analysis/S07-lifecycle-homing-state-ownership.md`
- `source-analysis/S07-launcher-cleanup-startup-boundary.md`
- `call-flows/S07-restart-to-position-revalidation.md`
- `experiments/S07-017-restart-homing-state-plan.md`
- `experiments/S07-017-run-34154858918-analysis.md`
- `experiments/S07-017-run-34158535337-analysis.md`
- `lab-jobs/017-s07-restart-homing-state.sh`

Pinned source establishes three lifecycle boundaries. First, `hal_lib_init()` gives a userspace process a process-specific RTAPI identity and maps the shared HAL key, while global HAL data is initialized only when needed; a new client PID therefore does not itself prove that the HAL namespace is fresh. Second, `src/emc/motion/homing.c` owns per-joint `homed` state in module-local `H[]`; fresh `base_homing_init()` creates the pins, sets the homing state machine idle/default parameters, and does not restore a previous runtime's homed bit. `HOME_FINISHED` sets `H[j].homed=1`, and the value is published through `joint.N.homed`. Third, `scripts/linuxcnc.in::Cleanup()` tears down userspace controller processes, stops/unloads HAL, stops realtime, removes NML shared memory, and removes the lock file. Service-port disappearance alone is therefore weaker than completed controller teardown.

S07-017 was frozen before implementation. It uses the stock ordinary-homing `tests/linuxcncrsh/linuxcncrsh-test.ini`: runtime A must start unhomed, establish `joint.0.homed=TRUE`, then shut down. Before B starts, the harness independently requires A PID absence, TCP 5007 absence, and disappearance of the exact `joint.0.homed` HAL pin. Runtime B must have a distinct launcher identity, expose `joint.0.homed=FALSE` before any new home request, then re-establish TRUE after `set home 0`. The INI SHA-256 must remain unchanged across both runtimes. Ambiguous teardown/identity or forced-homed semantics are HARNESS_INVALID rather than persistence evidence.

### S07-017 attempt history

- **Attempt 1 — workflow `34154858918`, exit 21: HARNESS INVALID.** Runtime A began with `joint.0.homed=FALSE` and successfully established `TRUE`, but the harness then sent TERM directly to the outer `linuxcnc` launcher and the launcher survived the harness's 15-second wait. Runtime B never began after a valid teardown barrier, so this run is not persistence evidence.
- **Attempt 2 — workflow `34158535337`, exit 22: HARNESS INVALID.** Runtime A again passed FALSE→TRUE and documented linuxcncrsh shutdown produced `SHUTDOWN ACK`; the launcher and TCP 5007 disappeared. The harness nevertheless reported `hal-pin-gone=0` because it incorrectly treated successful exit of `halcmd show pin joint.0.homed` as proof that the pin still existed.
- Pinned `src/hal/utils/halcmd_commands.cc::do_show_cmd()` returns success for a recognized `show` type after dispatching the print routine whether or not the supplied pattern matched an object. Therefore the attempt-2 HAL disappearance test was not an existence oracle and its `hal-pin-gone=0` is not persistence evidence.
- **Attempt-3 correction commit `cf5ef10c2b635c1305e3be199a7ef94a4e7ec575`:** readiness and teardown now use exact `halcmd getp joint.0.homed` success/failure. Frozen prediction and acceptance gates are unchanged. This is the last materially similar attempt before the three-attempt safeguard requires explicit ESSENTIAL NOW / PROMOTE / DROP classification.

No S07 cross-runtime TEST-CONFIRMED claim exists until attempt 3's own exit code and output are inspected.

### S07 promotion/uncertainty additions

- Absolute-encoder driver/device-specific restart provenance: **2000 / HIGH** — generic 1000-level teaching can establish that revalidation is architecture-specific; exact retained device position/freshness semantics require a selected hardware/driver.
- Abnormal process death and dangling HAL namespace cleanup details across realtime backends: **2000 / MEDIUM** unless S07-017 exposes a core contradiction — orderly restart attribution will independently prove teardown; backend-specific crash recovery is deeper than the representative 1000-level path.

## Existing active promotion queue

Previously recorded S04–S06 promotion items remain active in their graduated handoffs, including device-specific freshness provenance, disagreement timing bounds, physical independence/common-cause coverage, sampler documentation/source conflict, automatic evidence ingestion, and physical fault representativeness.

## Current checkpoint / exact resume point

Continue **S07-017** from EXPERIMENT.

1. Inspect the workflow triggered by attempt-3 harness commit `cf5ef10c2b635c1305e3be199a7ef94a4e7ec575`; read that run's own exit code, stdout, stderr, and metadata. Do not infer PASS from workflow status alone.
2. Apply the frozen gates in `experiments/S07-017-restart-homing-state-plan.md` without weakening them. Require runtime A initial FALSE→TRUE, successful protocol shutdown, A PID disappearance, port disappearance, exact HAL-pin disappearance via `getp`, distinct runtime-B launcher identity, B initial `homed=FALSE`, successful B re-home to TRUE, and unchanged INI SHA-256.
3. If PASS, commit accepted-result reconciliation and prediction comparison, then proceed directly through S07 adversarial exam, corrections, fresh-AI handoff, counterfactual promotion audit, graduation, and activation of the next dependency-graph module.
4. If attempt 3 fails or stalls, do **not** launch a fourth materially similar run. Explicitly classify S07-017 as ESSENTIAL NOW / PROMOTE / DROP under the three-attempt safeguard before any further experiment design.
5. Preserve the central teaching regardless of fixture mechanics: successful host/process restart is not evidence that physical machine truth has been recovered; position revalidation semantics are architecture-specific.
