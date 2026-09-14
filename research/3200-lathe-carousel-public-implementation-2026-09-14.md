# 3200 Lathe / Turning Center — public automatic turret implementation

Date: 2026-09-14
Pinned LinuxCNC source revision used for component semantics: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`
Track: 3200 — Lathes / Turning Centers
Status: **PUBLIC CONFIG + SOURCE INSPECTED**

## Purpose

Inspect a real public LinuxCNC lathe automatic tool turret far enough to map the tool-change request, target, physical feedback, motor command and completion acknowledgement, then separate what the implementation actually proves from stronger clamp/lock claims that are not present.

## Public implementation selected

LinuxCNC issue #2025, **“Carousel stopped working concurrently with a Buildbot 2.9 update”**, documents an actual automatic tool turret (ATT) on a CNC lathe and includes the relevant HAL configuration.

Public issue:
https://github.com/LinuxCNC/linuxcnc/issues/2025

The reporter describes a five-position lathe turret using LinuxCNC's realtime `carousel` component and a velocity-mode stepgen. The original symptom was especially useful diagnostically: the first physical change worked, later commands could update the AXIS graphical tool state while the physical turret no longer indexed. That is a concrete reminder that software tool state and physical changer completion are separate evidence surfaces.

## HAL path reconstructed

The posted configuration contains this functional chain:

```text
iocontrol.0.tool-prep-pocket
        -> carousel.0.pocket-number

iocontrol.0.tool-change
        -> carousel.0.enable

carousel.0.ready
        -> iocontrol.0.tool-changed

carousel.0.motor-vel
        -> stepgen.3.velocity-cmd
        -> physical turret motor step/dir outputs

physical index/pulse sensors
        -> carousel.0.sense-0 / sense-1
```

The configuration uses:

```text
loadrt carousel pockets=5,1 encoding=index num_sense=2 dir=1
addf carousel.0 servo-thread
```

and a velocity-mode stepgen for the turret. It configures forward/reverse velocities and a nonzero `rev-pulse`, giving the changer a reverse-lock/latching phase after finding the requested pocket.

Tool preparation is looped back separately; physical indexing is done during the actual change request.

## `carousel.comp` source semantics

Pinned source:
https://github.com/LinuxCNC/linuxcnc/blob/f666f1a51ae7c4d991cc61233e785dcc53fbe98d/src/hal/components/carousel.comp

The component explicitly supports lathe-style carousel arrangements, including index+pulse sensing and a reverse-against-stop locking phase.

Relevant state machine behavior at the pinned revision:

1. `enable` starts the transaction and `ready` is cleared.
2. In index mode, position advances from physical pocket sensor transitions after homing.
3. The changer drives until `current-position == requested pocket` with debounce.
4. If `rev-pulse > 0`, it executes a timed reverse/latch move.
5. It then stops the motor, clears `active`, raises `ready`, and enters `WAIT_ENABLE_FALSE`.
6. A new transaction is not armed until the external `enable` request goes low and the component returns to `WAITING`.

For slower final alignment configurations the component instead runs a stop/back-up/back-off/final-move sequence and performs a final in-position check before `ready`.

This request-release requirement is important: `carousel.ready` is not intended to be an always-high global “turret is okay” bit. It is the completion acknowledgement for the currently enabled transaction and the component explicitly waits for enable to be released before accepting another.

## Physical witness map for this lathe

| Layer | Public implementation witness |
|---|---|
| Desired pocket | `iocontrol.0.tool-prep-pocket -> carousel.0.pocket-number` |
| Transaction request | `iocontrol.0.tool-change -> carousel.0.enable` |
| Rotation command | `carousel.0.motor-vel -> stepgen.3.velocity-cmd` |
| Physical pocket progression | index + pulse sensors into `sense-0` / `sense-1` |
| Latching action | configured nonzero `rev-pulse` reverse phase |
| Completion acknowledgement | `carousel.0.ready -> iocontrol.0.tool-changed` |
| Separate hydraulic clamp/down switch | **not shown in this configuration** |

### What `ready` proves here

For the inspected implementation, `ready` means the `carousel` state machine completed its configured pocket-detection and latching/alignment sequence under the signals supplied to it.

That is a useful and real completion predicate for this changer design.

### What `ready` does not universally prove

The posted lathe configuration does not show a separate clamp-pressure, turret-down, shot-pin, or lock-switch input feeding the final `tool-changed` decision. Therefore this example must not be generalized to say that `carousel.ready` universally proves every automatic lathe turret is mechanically clamped and safe to cut.

A different lathe whose turret has lift/unclamp/rotate/shot-pin/reclamp mechanics needs those machine-specific witnesses integrated into the completion predicate before asserting `tool-changed`.

## Useful second public pattern from the issue discussion

A second posted carousel configuration in the same issue uses binary position feedback, an explicit valid/strobe input, and a magazine-door movement interlock. Its author describes the intended handshake in plain terms:

```text
set requested pocket -> enable true -> wait for ready true -> enable false
```

That matches the pinned component's `WAIT_ENABLE_FALSE` state and reinforces that acknowledgement lifecycle is part of the interface contract, not a cosmetic detail.

## Failure-history lesson from issue #2025

The issue history records a version/configuration-dependent failure where the physical ATT could stop responding after the first change while the GUI continued to reflect requested tool changes. Debugging focused on `pocket-number`, `current-position`, component state, `ready`, and motor velocity.

The curriculum lesson is not to infer a universal historical root cause from the thread. The durable lesson is the diagnostic decomposition:

- requested tool/pocket state;
- changer state-machine state;
- physical sensor-derived position;
- motor command;
- completion acknowledgement;
- GUI/tool-table state.

Those surfaces can disagree, and the GUI is not a physical-completion witness.

## Comparison rule for heavier lathe turrets

For a simple ratchet/index carousel, `carousel.comp` may own nearly the entire physical indexing transaction.

For a hydraulic/pneumatic multi-stage turret, prefer a higher-level machine-specific state machine such as:

```text
REQUEST
 -> verify safe preconditions
 -> unclamp/lift
 -> rotate/index
 -> verify target pocket
 -> engage shot pin / reverse lock
 -> lower/clamp
 -> verify physical lock/down/pressure
 -> ACK tool-changed
```

`carousel.comp` can still be reused as the orientation sub-state machine, but its `ready` output should become one input to the larger completion predicate rather than automatically being wired to `iocontrol.0.tool-changed`.

## Evidence classification

| Claim | Classification | Evidence |
|---|---|---|
| A real LinuxCNC lathe ATT uses `tool-change -> carousel.enable` and `carousel.ready -> tool-changed` | PUBLIC CONFIG CONFIRMED | LinuxCNC issue #2025 |
| The public changer uses physical index/pulse feedback and velocity-mode stepgen | PUBLIC CONFIG CONFIRMED | issue #2025 HAL |
| `carousel.comp` contains explicit request, move, optional reverse-latch/alignment, ready, and request-release states | SOURCE-CONFIRMED | pinned `carousel.comp` |
| `ready` universally proves hydraulic clamp/down/lock state | REJECTED | no such universal inputs in the component; inspected lathe config shows none |
| GUI/tool identity proves physical turret movement | REJECTED | issue failure history demonstrates surfaces can diverge |

## Lab decision

No duplicate simulation was launched. The combination of a real lathe configuration, real field failure history, and inspectable component state machine has higher information value than recreating a toy carousel fixture.

## 3200 design rule

Map every lathe turret's `tool-changed` acknowledgement to the **actual final physical completion predicate for that mechanism**. Reuse `carousel.ready` directly only when the inspected mechanism and its supplied sensors make that predicate valid. Otherwise wrap it in machine-specific lift/clamp/lock/fault logic.