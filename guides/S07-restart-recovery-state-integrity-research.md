# S07 — restart/recovery/state integrity: research kickoff

- Course level: 1000
- Status: RESEARCH started after S06 graduation
- Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
- Prerequisites: S01–S06 graduated

## Learning objective

A fresh AI engineer must be able to distinguish software/process restart, estop reset, machine enable, homing/re-homing, HAL/realtime component teardown/reinitialization, and actual recovery of physical machine truth. It must identify which state is freshly initialized, which state may persist outside the process, and which state must be revalidated rather than assumed correct after restart.

## Initial official-documentation pass

### LinuxCNC process startup

Current `linuxcnc(1)` documentation describes the launcher as starting the realtime system and initializing LinuxCNC components such as IO, motion, GUI, and HAL. This establishes that a new launcher instance rebuilds a software control runtime; it does not state that external hardware/mechanical state is thereby recovered.

URL: https://linuxcnc.org/docs/master/html/en/man/man1/linuxcnc.1.html

### Homing is machine-position establishment, not generic process state

Current homing documentation states that homing establishes the G53 machine-coordinate zero and that soft limits are defined relative to that machine origin. Current user-concept documentation says axes/joints are normally homed after starting LinuxCNC before running programs/MDI unless configuration deliberately disables forced homing.

This is an important S07 boundary: a process that starts successfully is not automatically evidence that machine coordinates are trustworthy. Homing/absolute-position architectures require their own position-establishment semantics.

URLs:

- https://www.linuxcnc.org/docs/master/html/es/config/ini-homing.html
- https://www.linuxcnc.org/docs/stable/html/de/user/user-concepts.html

### Estop latch initializes faulted

Current `estop_latch(9)` documentation says its initial state is `Faulted`; transition to `OK` requires fault clear, `ok-in`, and a reset transition. This is one useful example where a software component deliberately initializes conservatively instead of restoring an earlier OK state.

URL: https://linuxcnc.org/docs/master/html/fr/man/man9/estop_latch.9.html

S07 must not generalize this one component's reset semantics to every subsystem.

## Initial pinned-source inventory

### `scripts/linuxcnc.in`

The pinned launcher is the high-level lifecycle owner. It resolves configuration, launches the realtime/control stack, installs exit/error handling, and contains a `Cleanup()` path that shuts down LinuxCNC components.

Earlier curriculum work already found a practical lifecycle hazard here: cleanup itself can invoke HAL teardown commands, so teardown completion must be independently observed before a subsequent runtime is accepted as a fresh instance. S04 experiment development also encountered a real harness race when a new runtime became observable before the old HAL/runtime namespace had fully disappeared.

S07 should convert that prior laboratory lesson into an explicit lifecycle/state-integrity model rather than treating it as incidental harness trouble.

### `src/hal/hal_lib.c`

Priority source questions for S07:

- what global/shared state is allocated/initialized when the first HAL component attaches;
- how `hal_init()` / `hal_exit()` affect component records and shared-memory lifetime;
- what happens if a process dies without orderly `hal_exit()`;
- which cleanup/recovery utilities identify dangling components;
- under what conditions HAL shared memory is destroyed versus reused by remaining references.

### motion/homing/task state

Priority source questions:

- initial `homed`/joint state on motion startup;
- how homing state is cleared/set and exposed to task/HAL/status;
- what machine-on/estop state is initialized on a new task/motion runtime;
- whether any runtime state is reconstructed from files/configuration rather than volatile process memory;
- how absolute-encoder homing changes the restart/revalidation boundary.

## First S07 claims to test, not assume

1. **A new LinuxCNC process identity is not proof of physical machine recovery.** Strong conceptual confidence; needs source/call-flow plus experiment.
2. **Old-runtime teardown must be independently established before a restart experiment can attribute state to the new runtime.** Supported by earlier curriculum harness races; formalize in S07.
3. **Normal homing state is expected to require re-establishment after a fresh runtime unless an architecture/configuration explicitly supplies position truth by another mechanism.** DOC-supported generally, but exact pinned-source state reset must be traced before freezing a claim.
4. **Some software components intentionally initialize faulted/disabled.** DOC-CONFIRMED for `estop_latch`, not yet generalized.
5. **Persistent files/device state and volatile HAL/motion state must be cataloged separately.** Framework requirement; individual mechanisms still require source evidence.

## S07 experiment direction — not yet frozen

Do not implement until the source trace identifies representative state with unambiguous semantics.

Candidate software-only fixture:

- launch one bounded LinuxCNC simulation runtime;
- establish a known runtime state (enabled/homed or a simpler representative HAL/motion state);
- record old process/HAL identities;
- shut it down and independently prove old runtime disappearance;
- start a fresh runtime from the same configuration;
- prove new process/HAL identity;
- observe which selected state resets versus is reconstructed;
- include a deliberately persisted external file/parameter only if source/config semantics make it legitimate;
- require re-homing/revalidation where the source/docs say machine position truth is not retained.

Use S06 classification: an incomplete teardown/new-runtime identity ambiguity is `HARNESS_INVALID`, not evidence about LinuxCNC state retention.

## Safety boundary

Restarting LinuxCNC software, clearing a software diagnostic, or seeing a new process does not prove actuators stopped, hydraulic/pneumatic energy is removed, a physical encoder is truthful, the machine is mechanically synchronized, or a safety function has reset safely. S07 must keep software lifecycle recovery separate from physical commissioning/recovery.

## Exact next research

1. Trace pinned `linuxcnc.in::Cleanup()` and startup ordering to the point where HAL/realtime is created/destroyed.
2. Trace pinned `hal_init()` / `hal_exit()` / HAL shared-memory reference lifetime and dangling-process handling.
3. Locate pinned motion initialization and homing-state reset/set/publication symbols.
4. Run a targeted community pass for restart-after-fault, stale HAL namespace, rehome expectations, absolute encoder restart behavior, and failed teardown cases.
5. Build a state matrix (`state`, `owner`, `storage`, `initial value`, `reset trigger`, `observable`, `physical-truth implication`) before freezing S07-017.
