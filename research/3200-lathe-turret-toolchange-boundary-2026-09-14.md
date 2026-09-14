# 3200 — Lathe turret/tool-change state and authority boundary

Date: 2026-09-14
LinuxCNC source revision: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`
Status: dependency-safe 3000-series preparation

## Why this sub-branch

After bounding the spindle/threading foundation, the next high-value lathe-specific mechanism is the turret/tool-change state machine. Real lathes commonly require more than selecting a pocket: lift/unclamp, rotate, decelerate, lock, verify position, and sometimes coordinate axis clearance or tailstock/turret selection. LinuxCNC intentionally separates the generic tool-change handshake from machine-specific mechanics.

## Generic LinuxCNC I/O handshake

Official `io(1)` and tool-compensation documentation expose two separate request/acknowledgement episodes:

- preparation: `iocontrol.0.tool-prepare` / `tool-prep-number` / `tool-prep-pocket` are outputs; external logic asserts `iocontrol.0.tool-prepared` when preparation is complete;
- change: M6 asserts `iocontrol.0.tool-change`; external logic asserts `iocontrol.0.tool-changed` when the physical change is complete.

The acknowledgement pins are inputs to LinuxCNC's I/O layer. Therefore LinuxCNC does not itself know a turret is physically locked merely because it requested a change. Machine logic owns the evidence used to assert completion.

Evidence: `DOC-CONFIRMED`.

## Carousel component source

Pinned `src/hal/components/carousel.comp` is a realtime helper for orienting a carousel/toolchanger. It supports multiple feedback encodings:

- Gray code;
- straight binary;
- BCD;
- one sensor per position;
- index + pocket pulse;
- edge counting;
- encoder/stepgen counts.

It also supports unidirectional/bidirectional movement, shortest-path selection, homing for index/count modes, optional deceleration/final alignment, reverse pulses for ratchet/stop locking, manual jog, parity indication, and direct count targets.

Important pins include `pocket-number`, `enable`, `active`, `ready`, `current-position`, `motor-fwd`, `motor-rev`, `motor-vel`, `homed`, `parity-error`, sense inputs, and an encoder-style `index-enable` handshake.

The component description says `ready` goes high when the carousel is in-position. That is narrower than saying "the entire machine tool change is mechanically safe and complete." A turret can need additional lift/down, clamp, lock-pressure, axis-clearance, or tool-present witnesses outside `carousel`.

Evidence: `SOURCE-CONFIRMED`.

## Source-visible internal state machine

`carousel.comp` declares states including:

- `WAITING`;
- `DIR_CHOOSE`;
- `MOVE`;
- `REV_TIME`;
- `WAIT_STOP`;
- `BACK_UP_INDEX`;
- `BACK_OFF_INDEX`;
- `FINAL_MOVE_BACK`;
- `WAIT_ENABLE_FALSE`;
- `HOME_START`;
- `HOME_WAIT`;
- `JOG`.

That state list is useful because it shows that "move to pocket" can itself require a multi-stage mechanical episode: choose direction, move, wait for deceleration, back off/on a marker, apply reverse lock pulse, and require enable-reset semantics. This is a reusable state-machine building block, not a complete lathe-turret supervisor.

The component explicitly warns that jog inputs should be debounced and probably interlocked so they operate only while the machine is idle. It also notes that setting `enable` low does not halt a homing move once homing has started. Both details matter for operator/recovery design.

Evidence: `SOURCE-CONFIRMED`.

## Community implementations

LinuxCNC forum build/config discussions show several common integration patterns.

### Multi-stage lift/rotate/lock turret

A Hardinge Superslant discussion describes a turret/toolchanger sequence that must distinguish turret versus tailstock, clear axes, raise the selected mechanism, rotate toward the requested pocket, brake/lock, lower, verify the down state, and only then acknowledge the tool change. This illustrates why raw carousel position is not sufficient completion evidence on all machines.

Classification: `COMMUNITY-REPORTED` architecture pattern.

### Carousel wired directly to iocontrol

A public forum example for an 8-tool lathe turret wires approximately:

`tool-prep-pocket -> carousel.pocket-number`

`tool-change -> carousel.enable`

`carousel.ready -> tool-changed`

This is compact and may be valid when the carousel component's `ready` truly represents all required mechanical completion for that machine. It is not a universal recommendation for turrets with separate unclamp/clamp/down/lock witnesses.

Classification: `COMMUNITY-REPORTED` config pattern.

### Ratchet/pawl turrets

Another lathe thread discusses a ratchet-style changer that rotates past the selected point then reverses to lock against the pawl. That maps directly to carousel's source-visible reverse-pulse/final-alignment capabilities, but machine-specific sensing still determines whether position/lock is trustworthy.

Classification: `COMMUNITY-REPORTED`, reconciled with `carousel.comp` capabilities.

## Architecture playbook boundary

A robust lathe toolchange should distinguish at least these concepts:

`ToolRequest`
`-> preparation/selected pocket`
`-> machine-clearance authorization`
`-> unclamp/lift`
`-> orient/rotate carousel`
`-> position confirmation`
`-> clamp/lock/lower`
`-> mechanical completion witnesses`
`-> iocontrol tool-changed acknowledgement`

For simple hardware some middle stages collapse together. For complex hardware they must remain explicit.

Do not equate:

- desired tool number;
- carousel current-position;
- carousel ready;
- turret clamped/locked;
- correct tool actually presented at the cutting station;
- LinuxCNC's logical current tool.

Those are separate states unless a particular machine supplies evidence that makes them equivalent.

## Failure and recovery cases

1. **Position code invalid/parity fault** — carousel can expose a parity error, but external supervisory logic must decide whether this blocks `tool-changed` and how to recover.
2. **Carousel reaches pocket but clamp fails** — `ready` from position logic alone must not be treated as machine-complete if a separate clamp witness exists.
3. **Lift/down switch fails** — a multi-stage turret can rotate correctly yet remain mechanically unsafe for cutting.
4. **Enable/reset sequencing mismatch** — `WAIT_ENABLE_FALSE` means request/ack logic must provide a clean episode boundary rather than leave a stale enable asserted indefinitely.
5. **Homing interrupted conceptually by dropping enable** — carousel documentation states homing continues; external abort/recovery logic cannot assume enable-low alone cancels every internal state.
6. **Manual jog during active machine motion** — component documentation itself warns that jog should be interlocked to machine idle.
7. **Axis clearance omitted** — generic carousel does not know whether X/Z are safely clear of a turret swing.

## Adversarial review

1. Does `carousel.ready` universally mean a lathe toolchange is physically complete? **No.**
2. Does LinuxCNC's M6 request itself prove the mechanism changed tools? **No; external logic must acknowledge `tool-changed`.**
3. Can one component support binary, Gray, index/pulse and counts feedback? **Yes.**
4. Can a ratchet turret require motion after nominal pocket detection? **Yes; reverse pulse/final alignment is explicitly supported.**
5. Does dropping `carousel.enable` necessarily abort a homing move? **No; the component documentation says homing continues.**
6. Should carousel jog be considered safe to expose without other gating? **No; source documentation recommends debounce and idle interlock.**
7. Does this pass establish a universal turret sequence? **No; it establishes the handshake/state boundaries and variation points.**

Result: **7/7 PASS** for the bounded claims.

## Laboratory decision

No new synthetic lab was launched. The source-visible carousel state machine and real community integration patterns already establish the current architectural boundary. A useful later experiment should test a frozen recovery claim, such as a failed clamp/down witness or stale `tool-changed` acknowledgement, rather than simply animating a toy carousel.

## Next evidence-gain path

1. Inspect at least one complete public lathe toolchanger configuration/remap/ClassicLadder program, including failure and manual recovery behavior.
2. Trace LinuxCNC's I/O-side tool preparation/change state transitions deeply enough to document abort/restart semantics.
3. Compare non-random lathe turret conventions with LinuxCNC's generic random/nonrandom tool-table model.
4. Then either freeze a real fault/recovery experiment or rotate to CSS/X-origin/diameter-mode and C-axis/live-tooling topics based on evidence availability.
