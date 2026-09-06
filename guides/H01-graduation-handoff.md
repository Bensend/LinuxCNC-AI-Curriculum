# H01 Graduation Handoff — HAL Architecture and Object Model

Course level: LinuxCNC 1000 series. Pinned development revision: `8bf4605ae81042248add031e94c77300406e0413`.

## What a fresh AI must know

HAL's public objects are backed by a shared-memory object graph rooted in `hal_data_t`. Shared-memory offsets are used where mappings may differ between processes. Components register themselves and their owned objects; `hal_ready()` is component readiness/lifecycle state rather than a global HAL freeze.

Pins have component-side dummy value storage when unlinked. Linking redirects a pin's data pointer to typed signal-owned shared storage. Unlinking redirects it back to dummy storage and, for the scalar path studied here, preserves a snapshot of the signal value. HAL also enforces signal writer ownership: a second OUT writer is rejected.

Function export and execution are distinct. `hal_export_funct()` registers a callable function; `addf`/`hal_add_funct_to_thread()` creates its thread scheduling entry; the periodic thread dispatcher later walks entries and invokes functions. Therefore “listed by `show funct`” is not equivalent to “periodically executing.”

## Runtime verification

Corrected bounded experiment `006`, Actions run `34018699909`, job `101447160463`, curriculum SHA `43fae7ea1835058e9f6e85b9c5adcb7360f35195`, built pinned LinuxCNC and exited 0. Fresh output observed:

- dummy pin 1.25 -> newly linked signal 1.25;
- linked signal update to 2.5 propagated to the pin;
- unlink snapshot retained pin 2.5 while later signal change reached 3.5;
- second OUT writer was rejected with rc=1 and explicit writer diagnostic;
- `siggen.0.update` was exported, then appeared under a 1,000,000 ns HAL thread after `addf`;
- threadbeat advanced to 254 after `start`;
- explicit successful-completion marker was reached.

These are TEST-CONFIRMED only for the pinned software build/host. They do not prove realtime determinism, physical I/O behavior, or functional safety.

## Adversarial/fresh-AI sufficiency

`exams/H01-adversarial-exam.md` and its answer key test ready-state semantics, storage ownership, pointer redirection, unlink behavior, writer invariants, export-vs-scheduling, debugging, revision discipline, bounded configuration modification, and safety boundaries. The answer key passes without requiring unresolved detail that blocks the 1000-level objective.

A fresh AI can now reason about HAL object ownership/connectivity and distinguish registration from scheduling strongly enough to begin H04 execution-order study without inventing missing behavior.

## Promotion queue

- **2000 / MEDIUM:** deeper concurrency/locking and deletion lifetime behavior across multiple HAL processes. Valuable internals, but not required to understand the 1000-level object/connectivity model.
- **2000 / MEDIUM:** systematically compare ready/unready and object lifetime semantics against stable `v2.9.10`; current source conclusions remain revision-pinned.
- **2000 / HIGH:** investigate races/atomicity and memory-ordering assumptions for shared pin/signal data on supported architectures. Consequential for advanced component/driver work, but outside H01 foundation scope.
- **H04 / HIGH, next now:** execution ordering within/between HAL threads, addf ordering, timing consequences, and failure behavior. This is a separate critical-path module rather than unresolved H01 architecture.

## Graduation decision

H01 is sufficient to GRADUATE at the 1000 level. Source, community, call-flow, bounded experiment, verification, adversarial exam, correction cycle, and fresh-AI handoff are present. Remaining depth is explicitly promoted and does not invalidate the core object/connectivity conclusions.
