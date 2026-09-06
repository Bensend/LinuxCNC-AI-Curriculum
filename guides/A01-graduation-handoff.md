# A01 — Graduation Handoff

Status: GRADUATED

Primary LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Curriculum run used for runtime confirmation: GitHub Actions run `34000879408`, job `101399404407`, curriculum commit `5a8fa43fcb162a0cbc1a8a1a0472e5e6d5458445`.

## What a fresh AI must retain

LinuxCNC's coarse conceptual blocks are not reliable OS-process boundaries. At the pinned development revision:

- `scripts/linuxcnc.in` is the userspace launcher/orchestrator.
- `linuxcncsvr` is started first to create/own the NML buffers used by the external-control/UI ↔ Task boundary.
- `milltask` is the non-realtime Task executable. Its link inputs include `emctaskmain.cc`, `taskintf.cc`, `usrmotintf.cc`, and `taskclass.cc`.
- Task attaches the `emcCommand`, `emcStatus`, and `emcError` NML channels.
- Task ↔ realtime motion is not another RCS/NML command channel. `taskintf.cc` builds `emcmot_command_t`; `usrmotintf.cc::usrmotWriteEmcmotCommand()` writes it through RTAPI shared `emcmot_struct_t`, then waits for a matching `commandNumEcho` and separately checks `commandStatus`.
- `motion.c` exports `emcmotCommandHandler` to HAL as `motion-command-handler`; `command.c::emcmotCommandHandler()` observes/echoes new command numbers and dispatches commands in the realtime side.
- `iocontrol.0` is a userspace HAL component registered inside `milltask`, not a standalone `iocontrol` OS process at this revision. `Task::Task()` calls `hal_init("iocontrol.0")`; `Task::iocontrol_hal_init()` exports its pins and calls `hal_ready()`.
- HAL component names, executable names, source-file names, and conceptual subsystem names are different namespaces. Never infer one boundary from another without linkage/launcher/source evidence.

## Runtime experiment 004 — accepted evidence

The accepted artifact is `linuxcnc-lab-004-a01-runtime-topology-34000879408-1` (artifact ID `9979483654`, SHA-256 digest recorded by GitHub as `45d93f735728abae4fbe727ef4ead746d4f0a2a9d30c5937a26c1d52989a54c9`). Its metadata records:

- job file `lab-jobs/004-a01-runtime-topology.sh`;
- curriculum commit `5a8fa43fcb162a0cbc1a8a1a0472e5e6d5458445`;
- upstream pin `8bf4605ae81042248add031e94c77300406e0413` in stdout;
- UTC experiment interval `2026-09-06T00:17:09Z` through `2026-09-06T00:20:43Z`;
- exit code `0`.

The predeclared acceptance gates all passed before cleanup:

1. `process-readiness: linuxcncsvr visible at probe 2`.
2. `process-readiness: milltask visible at probe 3`.
3. `process-readiness: linuxcncrsh visible at probe 3`.
4. HAL readiness returned `rc=0`.
5. Bounded `halcmd list comp` and `halcmd list funct` returned `rc=0`; no HAL probe required a forced kill, so the HAL instance remained admissible for topology evidence.
6. HAL component output contained `motmod`, `trivkins`, and `iocontrol.0`.
7. HAL function output contained `motion-command-handler` and `motion-controller` among the simulation's functions.
8. The `Key component assertions` section executed.
9. `halcmd show comp iocontrol.0` reported one ready userspace component with PID `17515`.
10. The sole live `milltask` process had PID `17515`; therefore the observed HAL owner PID exactly equaled the observed `milltask` PID.
11. The process snapshot showed `linuxcncsvr`, `milltask`, `linuxcncrsh`, and `rtapi_app`; there was no standalone `iocontrol` process.
12. The script printed `A01 topology observation completed successfully.`

Classification: these listed runtime-topology facts are `TEST-CONFIRMED` for this pinned build/configuration on the GitHub uspace runner, in addition to the corresponding source evidence. They do **not** establish realtime scheduling quality, deterministic latency, hardware behavior, or functional safety.

Cleanup produced a separate, non-fatal observation: the top-level `linuxcnc` launcher did not exit within the lab's bounded TERM window and the harness forced launcher exit after preserving a process snapshot. This occurred only after all accepted topology assertions and does not invalidate them. It remains evidence about shutdown behavior, not realtime qualification.

## Source/call-flow evidence a fresh AI should use

Primary guide: `guides/A01-process-component-architecture.md`.

Important supporting artifacts:

- `call-flows/A01-task-to-motion-command-ack.md` — Task command construction through shared-memory acknowledgement.
- `guides/A01-adversarial-corrections.md` — corrections produced by the adversarial exam.
- `guides/A01-iocontrol-component-ownership-verification.md` — why HAL's recorded userspace PID is direct ownership evidence.
- `guides/A01-halcmd-observation-boundary.md` and `guides/A01-halcmd-hal-lock-call-flow.md` — why a whole-command `halcmd` hang cannot be casually localized.
- `guides/A01-bounded-probe-errexit-lock-integrity.md` — shell/error and post-force-kill evidence integrity.
- `guides/A01-linuxcnc-cleanup-boundary.md` — launcher cleanup can itself enter unbounded HAL commands.
- `exams/A01-process-component-architecture-adversarial.md` — adversarial questions and source-navigation requirements.

## Fresh-AI handoff audit

The handoff was checked against `MODULE_TEMPLATE.md` by resolving representative tasks using only A01 artifacts plus the pinned LinuxCNC source locations named by those artifacts:

### Locate the subsystem

A fresh reader is directed to launcher ordering in `scripts/linuxcnc.in`, Task linkage in `src/emc/task/Submakefile`, Task runtime in `src/emc/task/emctaskmain.cc`/`taskclass.cc`, the userspace motion bridge in `src/emc/motion/usrmotintf.cc`, and the realtime command handler in `src/emc/motion/command.c`/`motion.c`.

Result: PASS — executable, component, IPC, and source boundaries are explicitly locatable.

### Explain the behavior

The artifacts distinguish three architectural interfaces that are easy to conflate: NML/RCS at UI/external-control ↔ Task, RTAPI motion shared memory at Task ↔ realtime motion, and HAL for exported realtime/userspace pins/functions/components.

Result: PASS — the main misleading premise, “all LinuxCNC IPC is NML,” is explicitly contradicted and replaced with a source-backed model.

### Reproduce the experiment

`lab-jobs/004-a01-runtime-topology.sh` pins the upstream revision, uses an upstream `linuxcncrsh` simulation, waits for three required processes, bounds every HAL observation, and performs explicit component/ownership assertions. The accepted run ID, SHA, artifact identity, and expected markers are preserved above.

Result: PASS — another AI can distinguish a valid rerun from stale or incomplete output.

### Diagnose a representative failure

The A01 lock/readiness/cleanup guides establish that a stalled `halcmd` may block during startup `hal_init()` or later `hal_list_*()` acquisition of the shared HAL metadata lock; a whole-command timeout alone does not identify which. The harness captures the original PID before termination, and any force-killed HAL participant makes later HAL assertions from that instance inadmissible.

Result: PASS — the failure can be classified as startup/registration, list-query, or UNKNOWN without inventing evidence.

### Make a bounded change

A safe bounded A01 change is to add observation/instrumentation around launcher/process/HAL boundaries without changing upstream LinuxCNC behavior. Any behavioral change to LinuxCNC itself requires separate defect evidence and belongs in a later implementation task/module.

Result: PASS — modification scope and evidence boundary are explicit.

## Graduation checklist

- [x] Official docs reviewed.
- [x] Community knowledge reviewed and kept subordinate to pinned source.
- [x] Source inventory completed.
- [x] Significant functions/symbols traced.
- [x] Important call flows documented.
- [x] Claims ledger reconciled, including contradicted premises.
- [x] Reproducible runtime experiment passed with fresh metadata and bounded observation.
- [x] Failure modes documented, including startup, command acknowledgement, HAL-lock observation, and cleanup boundaries.
- [x] Adversarial exam completed.
- [x] Corrections incorporated.
- [x] Fresh-AI handoff audit passed.

## Open questions deliberately deferred

A01 does not attempt to prove or deeply teach realtime scheduling, servo-thread execution order, HostMot2 behavior, hardware timing, or functional safety. Those are dependency-ordered later modules. In particular, R01 is now unblocked and should become the next highest-priority lesson.

## Exact next-work checkpoint

Begin **R01 — Realtime model**. Preserve A01's evidence boundary: the passing GitHub uspace experiment demonstrates software topology only and must not be reused as realtime-performance evidence. R01 should start with official realtime/RTAPI documentation, pinned source inventory for realtime startup/thread/scheduling primitives, and a claims ledger that separates LinuxCNC's uspace execution model from actual host realtime-kernel qualification.