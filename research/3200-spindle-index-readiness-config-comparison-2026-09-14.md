# 3200 — Spindle index/readiness and real-config comparison

Date: 2026-09-14
LinuxCNC source revision for core behavior: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`

## Purpose

Continue the lathe spindle-synchronization branch below the G76 interpreter layer and compare the core contract against real public HAL configurations. The goal is to distinguish LinuxCNC requirements from machine-specific implementations.

## Core index handshake

Official spindle documentation wires the encoder and Motion bidirectionally:

`encoder.index-enable <=> spindle.N.index-enable`

while encoder position feeds `spindle.N.revs` and velocity feeds `spindle.N.speed-in`.

The core-components documentation explicitly says `spindle.N.index-enable` must be connected to the spindle encoder's index-enable for correct spindle-synchronized motion and that `spindle.N.revs` must increase by 1.0 per clockwise spindle revolution.

Source: LinuxCNC master/stable spindle and core-component documentation.

Classification: `DOC-CONFIRMED`.

## TP index wait behavior

Pinned `src/emc/tp/tp.c` contains explicit state for both:

- `waiting_for_index`;
- `waiting_for_atspeed`.

When a synchronized trajectory requires index alignment, TP records the motion ID as waiting for index and requests the index reset. While Motion spindle status still reports `spindle_index_enable` asserted, TP returns `TP_ERR_WAITING`; it therefore does not silently start the synchronized segment before the index handshake completes.

Pinned `src/emc/motion/control.c` transports spindle index-enable state across the HAL/Motion boundary and tracks changes between the Motion and HAL sides. `src/emc/motion/motion.h` stores `spindle_index_enable` separately from spindle revolutions, measured speed and other spindle status.

This gives a source-grounded boundary:

`TP requests index alignment -> spindle.N.index-enable handshake -> encoder observes physical index and clears/reset-completes handshake -> Motion status reflects completion -> TP may leave WAITING state -> synchronized trajectory proceeds`

The exact hardware implementation of the index capture/reset remains encoder-driver specific, but TP's wait is not merely a delay timer.

Classification: `SOURCE-CONFIRMED` for TP/Motion state behavior; hardware edge-capture specifics remain driver-specific.

## Readiness is a separate wait

TP also tracks `waiting_for_atspeed` independently of `waiting_for_index`. Official docs separately expose `spindle.N.at-speed` as an input that can gate the first feed after spindle start/speed change, synchronized-motion chains, and CSS rapid-to-feed transitions.

Therefore the following are independent predicates:

- encoder/index phase reference acquired;
- spindle measured phase/revolutions available;
- spindle considered at requested cutting speed.

A configuration can satisfy one and fail another.

## Public configuration A — tinic/el-linuxcnc-electron

Pinned public file:

`tinic/el-linuxcnc-electron@a587f561a2b1e8739b095024855c8668da972c75/elle-app/elle-hal/lathe.hal`

Relevant behavior:

- HostMot2 7i96 encoder scale is configured with a sign chosen to represent spindle rotation correctly;
- `spindle.0.index-enable <=> hm2_7i96.0.encoder.00.index-enable`;
- HostMot2 encoder position drives `spindle.0.revs`;
- encoder velocity drives `spindle.0.speed-in`;
- `spindle.0.at-speed` is forced TRUE because this machine describes the spindle as mechanically synchronized.

This is a concrete counterexample to any claim that every valid LinuxCNC lathe must calculate `at-speed` from a VFD/encoder comparison. The correct readiness witness is machine architecture dependent. In this config, spindle synchronization still uses an encoder/index handshake even though readiness is treated as unconditional under the machine's mechanical-drive assumption.

Classification: `PUBLIC CONFIG / SOURCE-VISIBLE`, not a LinuxCNC universal recommendation.

Important boundary: forcing at-speed TRUE is acceptable only if the machine's physical/command architecture truly makes waiting unnecessary for the intended operations; copying this line into a VFD-driven spindle would erase a real readiness check.

## Public configuration B — JTrantow/configs latheMesa

Pinned public file:

`JTrantow/configs@bc9e5f0d85b4a1a30623c6103d92293ad0c90757/latheMesa/LatheSpindle.hal`

This machine takes a different path:

- a Commander SK VFD provides an at-speed signal into `spindle.0.at-speed`;
- a Mesa encoder independently supplies spindle position and velocity;
- `spindle.0.index-enable` is bidirectionally connected to the Mesa encoder index-enable;
- the configuration derives signed encoder feedback, low-pass filtered spindle speed, and an inferred gear ratio;
- a `lincurve` maps detected mechanical gearing to command scaling for the VFD.

This exposes another important ownership split:

`requested spindle RPM -> machine-specific gearing/drive conversion -> VFD command`

while

`physical spindle encoder -> phase/revs/speed feedback -> LinuxCNC synchronization`

and

`VFD readiness -> spindle.0.at-speed`.

Command scaling, phase feedback and readiness can therefore come from three different physical/logical paths.

Classification: `PUBLIC CONFIG / SOURCE-VISIBLE`, not canonical.

## Community reconciliation: index-enable semantics

A LinuxCNC forum explanation by experienced contributor Andy Pugh states that the encoder normally counts continuously; at the beginning of spindle-synchronized motion it is zeroed to the index once and then continues counting rather than being reset every revolution. This is consistent with the documented bidirectional index-enable handshake and TP waiting-for-index behavior.

Community source: `forum.linuxcnc.org/10-advanced-configuration/29778-spindle-index-enable`.

Classification: `COMMUNITY-REPORTED`, reconciled with source/docs.

## Cross-config engineering lessons

The two inspectable configurations support a reusable lathe architecture model:

`G-code spindle intent`
`  -> machine-specific command conversion (VFD frequency, gear ratio, servo command, mechanical drive, etc.)`
`  -> physical spindle`

Parallel observations:

`physical spindle -> encoder position/index -> spindle.N.revs + index-enable handshake -> synchronized trajectory authority`

`physical/VFD state -> readiness predicate -> spindle.N.at-speed -> cutting transition authorization`

Those paths may share sensors but should not be collapsed conceptually.

## Failure classes

1. **Wrong encoder sign/scale** — one revolution no longer maps to the required signed 1.0-rev semantic; synchronization geometry can be wrong even while counts look smooth.
2. **Index-enable not bidirectionally wired** — TP can wait indefinitely or synchronize without the intended reset/reference behavior depending on the failure.
3. **At-speed forced TRUE on a spindle that actually needs acceleration/settling time** — cutting authorization may precede physical readiness.
4. **At-speed based on the wrong semantic quantity** — e.g. absolute command versus signed measured speed can fail reverse-direction operation.
5. **Gear-command scaling wrong while encoder feedback is right** — Motion can observe true spindle motion yet the VFD command mapping may miss requested speed or readiness.

## Adversarial review

- Is index-enable merely an ordinary one-way enable output? **No; the documented encoder connection is bidirectional and participates in index-reset completion.**
- Is at-speed the same event as index acquisition? **No.**
- Must at-speed always come from `near` comparing command/feedback? **No; that is a common example, not a universal machine contract.**
- Does forcing at-speed TRUE prove a config is wrong? **No; it depends on the physical spindle architecture, but it removes a readiness witness and must be justified.**
- Can a multi-gear spindle preserve correct synchronization while using machine-specific command mapping? **Yes; the inspected JTrantow config separates command gearing from encoder feedback.**
- Does correct spindle encoder feedback prove VFD command scaling is correct? **No.**
- Do these two configs establish a universal lathe pattern? **No; they demonstrate architectural variation around a common LinuxCNC contract.**

Result: **7/7 PASS** for bounded claims.

## Laboratory decision and next evidence

No lab was launched. Source plus two independent real configs produced meaningful evidence without synthetic duplication.

Next evidence-gain path:

1. inspect TP's exact synchronized-state/index completion and pause/resume code sufficiently to document recovery boundaries;
2. inspect available upstream tests for spindle sync, threading and rigid tap;
3. only then freeze a fault experiment if encoder stall/jump/index/readiness independence remains untested;
4. after spindle-sync foundation is bounded, rotate within 3200 to turret/tool-change state machines and failure recovery.
