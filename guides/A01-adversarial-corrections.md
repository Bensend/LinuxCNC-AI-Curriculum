# A01 Adversarial Corrections — Process / Component Architecture

Pinned LinuxCNC development revision: `8bf4605ae81042248add031e94c77300406e0413`.

This is the correction pass for `exams/A01-process-component-architecture-adversarial.md`. It records the distinctions a fresh engineer must preserve before A01 graduation. Runtime topology remains pending until experiment `004` actually reaches its assertions.

## Corrections / invariants

1. **Do not collapse LinuxCNC IPC into NML.** UI/external-control ↔ Task uses NML/RCS channels, while Task ↔ realtime motion uses RTAPI shared `emcmot_struct_t`. The userspace writer is `usrmotWriteEmcmotCommand()` and the realtime receiver is `emcmotCommandHandler()`.
2. **HAL component identity is not process identity.** `iocontrol.0` is registered by Task code linked into `milltask` at this revision. Seeing `iocontrol.0.*` pins is not evidence for a standalone `iocontrol` executable.
3. **Dependency is not launcher order.** Task can be started before normal HAL files have loaded motmod; startup code retries motion attachment while the launcher continues bringing the machine configuration up.
4. **Realtime must not block on Task's command write.** The realtime command handler try-locks the command mutex and skips that invocation if userspace owns it. Replacing this with a blocking lock would change an important realtime property.
5. **Acknowledgement is not command success.** Matching `commandNumEcho` establishes that the realtime side observed that command number. `commandStatus` must still be evaluated separately. Timeout-before-echo and acknowledged rejection are different failures.
6. **Version scope is mandatory.** Historical/community diagrams that depict conceptual `task` and `iocontrol` modules do not establish process topology for the pinned revision. Repeat build/source/runtime checks before making the same claim about another release.
7. **Cancelled workflow artifacts are not experimental evidence.** Run `33957356410` never reached topology assertions and its `LATEST.*` publication was stale workspace content. Experiment identity must be checked against workflow head SHA, job identity, pinned LinuxCNC SHA, and actual assertion execution.
8. **A debug counter belongs on the existing realtime path.** A contention counter should increment in the try-lock failure branch using realtime-safe state; it must not add logging, NML transport, or blocking work to the realtime handler. ABI/HAL exposure requires separate review of existing diagnostic structures.

## Current laboratory caveat

Corrected run `33960179986`, workflow head `26cf7fd3266741db2943211fe538ca145a3a0743`, was still in its `Run lab job and capture complete output` step when this correction pass was written. Therefore this document does **not** promote the predicted process/component topology to `TEST-CONFIRMED`.

The experiment must show that its fresh output identifies job `004-a01-runtime-topology`, pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`, and that the runtime assertions actually executed. Only then may observed `ps`/`pgrep` and `halcmd` results be used as test evidence.

## Graduation gate remaining

A01 still requires: (1) successful fresh runtime-topology observation or a preserved/reconciled discrepancy; (2) fresh-AI handoff artifact grounded in the source and verified experiment; (3) progress-state update. Until those are complete, R01 remains blocked by the dependency graph.
