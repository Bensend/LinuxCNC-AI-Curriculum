# Active Curriculum Session State

Session start UTC: `2026-09-14T23:33:04Z`
Session end UTC: `2026-09-14T23:44:24Z`
Actual elapsed: **11.3 minutes**
Status: **CLOSED — 3800 current breadth paths bounded; active work rotated to 3100 and advanced ATC/spindle-orient/probing authority.**

## Prerequisite state

The 1000 and 2000 series remain **GRADUATED / CLOSED**. F02 remains graduated under the preserved valid information-separated evaluation. No closed prerequisite work was reopened, repolled, or rescored.

## Branch selection and 3800 closeout

Repository-authoritative state at session start made **3800 Saws / Feeders / Indexing / Automation Cells** active.

A fresh bounded search still did not surface a mature public saw/bar-feeder/transfer implementation exposing request generation, physical completion, stale-ack rejection, stability/clamp proof, timeout/jam behavior and interrupted-cycle reconciliation. That branch is therefore preserved as a public-source gap rather than searched repetitively.

Created and source-closed:

- `research/3800-supervisory-freshness-and-locking-indexer-reconciliation-2026-09-14.md`

Key 3800 results:

- LinuxCNC command serial/`echo_serial_number`, Task/Motion heartbeat, execution/interpreter state and local physical completion are distinct supervisory evidence surfaces.
- Preserve: **command acknowledgement != program completion != physical transfer permission**.
- Native locking-indexer TP explicitly performs `unlock request -> wait is-unlocked=1 -> index motion -> lock request -> wait is-unlocked=0 -> complete segment`.
- No local elapsed-time timeout was found in that inspected TP wait path.
- `is-unlocked=0` does not generically prove a separate machine-specific locked/down witness.

With the remaining useful 3800 paths bounded, work rotated under `WORK_SELECTION_POLICY.md` to the genuinely underdeveloped **3100 Mills / VMCs** branch.

## Durable 3100 work completed

Created:

- `research/3100-mills-vmcs-breadth-foundation-2026-09-14.md`
- `research/3100-vmc-atc-field-chronology-first-pass-2026-09-14.md`
- `research/3100-atcduino-inspectable-config-abort-boundary-2026-09-14.md`
- `research/3100-probing-tool-setting-authority-foundation-2026-09-14.md`

Updated:

- `checkpoints/3100-next-2026-09-14.md`
- `PROGRESS.md`

### M6 / M19 / spindle authority

Pinned LinuxCNC documentation/source separates:

- tool selected;
- physical M6 transfer;
- logical tool identity;
- G43 tool-length-offset activation;
- spindle at-speed;
- spindle phase/index synchronization;
- M19 orientation/locked state.

M19 has explicit request/ack/fault/timeout semantics. Its Q word bounds the wait for `spindle.N.is-oriented`, unlike the inspected native locking-indexer path. Rigid tapping remains a spindle-synchronized-motion problem, not spindle orientation.

### Real VMC ATC chronology

Two materially different field architectures were preserved:

- EMCO VMC100/VMC300 spindle-driven carousel: the main spindle drive temporarily changes authority from machining spindle to carousel drive after orientation/mechanical coupling, with separate proximity feedback for carousel/reference/coupling state.
- OKADA VM500: independent carousel mechanism plus coordinated Z motion, favoring M6 remap/G-code orchestration for axis movement and a mechanism component such as `carousel.comp` for magazine positioning.

The chronology preserves failed/removed early HAL/NGC approaches, sensor noise/debounce, strobe-validity clarification and the fact that one exact VMC ATC sequence is not canonical.

### Inspectable ATCduino implementation

The public ATCduino source provides real bounded acknowledgements for carousel `INPOSITION` and piston-return/enable using M66 timeouts. However, spindle/toolholder lock/unlock and piston extension are dwell-based in the inspected routine rather than independently proven physical states.

Its visible `on_abort.ngc` does not establish complete recovery: direct output-clearing commands are commented and the called `reset_state` implementation was not found in the inspected default branch.

Preserve: **some physical acknowledgements + some timeouts != complete physical transfer proof**.

### Probing / tool-setting foundation

Pinned G38.x documentation establishes:

- G38.2/G38.4 signal error when the requested contact/release transition does not occur;
- G38.3/G38.5 leave failure handling to the macro;
- `#5061..#5069` receive probe-coordinate values even after an unsuccessful probe, where they become the programmed endpoint;
- `#5070` is the explicit success discriminator;
- probe coordinates are expressed in the active work coordinate frame.

Preserve: **a plausible `#506x` value != a successful measurement**. A machine-fixed tool setter still requires deliberate frame/calibration math before a persistent tool-table update, and writing the table is separate from activating compensation with G43.

## Next work

Continue from `checkpoints/3100-next-2026-09-14.md`.

Priority:

1. inspect a real production probing/tool-setting implementation, preferably with initial-state qualification, coarse/fine touches, calibration, `#5070` checks and explicit failure paths;
2. perform only a bounded search for a stronger VMC ATC with independent drawbar/tool-present proof plus meaningful abort/restart handling;
3. then inspect spindle/VFD readiness, lube, coolant/chiller, chip handling and fixture/pallet authority.

No lab should start merely because 3100 is new; source/config/field evidence still has higher information gain.

## Laboratory state

No laboratory run was launched. `LAB_COMPUTE_LOG.md` remains unchanged.

## Overlap

**No overlap.** Previous canonical session ended `2026-09-14T22:49:23Z`; this session began `2026-09-14T23:33:04Z`, **43m41s later**.
