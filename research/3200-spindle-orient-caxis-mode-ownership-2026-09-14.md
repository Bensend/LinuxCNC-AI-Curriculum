# 3200 Lathe / Turning Center — spindle orient and C-axis mode ownership

Date: 2026-09-14
Pinned LinuxCNC revision for source claims: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`
Track: 3200 — Lathes / Turning Centers
Status: **OFFICIAL DOCS + PINNED SOURCE + REAL C-AXIS FIELD IMPLEMENTATION/BUG HISTORY INSPECTED**

## Purpose

Trace the boundary between ordinary spindle-speed control, M19 spindle orientation and a true C-axis/live-tooling mode. The central question is not merely “how do I command angle?” but **who owns the same physical spindle actuator, encoder and index signal in each mode, and how is ownership transferred without stale commands or conflicting writers?**

## 1. Native M19 contract

Pinned official documentation (`docs/src/gcode/m-code.adoc`) defines:

```text
M19 R<angle> Q<timeout> [P<mode>] [$<spindle>]
```

- `R`: requested angle, 0–360 degrees;
- `Q`: orient timeout; failure to receive `spindle.N.is-oriented` within the timeout is an error;
- `P=0/1/2`: shortest/CW/CCW positioning from the current quadrature position;
- `P=3/4/5`: same directional choices but first reacquire the encoder index;
- `$`: selects which spindle HAL pins carry the command.

The motion/HAL contract is explicit:

- `spindle.N.orient-angle` — target angle;
- `spindle.N.orient-mode` — requested orient mode;
- `spindle.N.orient` — orient transaction active;
- `spindle.N.is-oriented` — external completion acknowledgement;
- `spindle.N.orient-fault` — nonzero fault aborts the orient cycle;
- `spindle.N.locked` — LinuxCNC orient-complete state;
- spindle brake is asserted on successful orientation under the documented motion behavior.

`M3`, `M4` or `M5` clear the M19 orientation state.

### Important boundary

M19 is a **discrete spindle-orientation transaction**, not a general coordinated C axis. It can position the spindle to an angle and prove completion through `is-oriented`, but it does not create a continuously commanded C coordinate that can be blended/interpolated with X/Z during milling.

For index drilling or milling where the chuck can remain at discrete angular positions, M19 may be sufficient and materially simpler than building a full dual-role C axis.

## 2. `orient.comp` source trace

Pinned `src/hal/components/orient.comp` implements a reusable orientation command generator for drives that do not perform orientation internally.

Inputs/outputs include:

- `enable`;
- `mode`;
- measured spindle `position` in revolutions;
- target `angle` in degrees;
- output position `command` for a PID;
- `poserr`;
- `is-oriented` completion;
- IO `index-enable` for optional index reacquisition.

The documented example explicitly switches spindle control to a separate orient PID when `spindle.N.orient` is active.

The component state machine:

1. detects the rising edge of orient enable;
2. for modes 0–2, samples current position and computes the required target revolution consistent with shortest/CW/CCW direction;
3. for modes 3–5, arms `index-enable`, drives toward the index and waits for the encoder to clear the handshake;
4. after index reacquisition, proceeds to normal orient targeting;
5. requires position error within configured tolerance for more than 100 invocations before asserting `is-oriented`.

Thus even native M19 is already an example of **mode-specific command ownership plus explicit physical feedback acknowledgement**.

## 3. M19 versus true C-axis control

A turning center with live tooling can need either of two fundamentally different capabilities.

### Indexed spindle only

Use cases: cross drilling, bolt circles, flats/keyways where the part is positioned, held, then cut without coordinated angular motion.

A practical architecture can be:

```text
spindle speed mode -> M5 -> M19 requested angle -> orient feedback valid -> optional brake/lock -> live tool cut
```

No native C coordinate is required if all part rotation is discrete.

### Coordinated C axis

Use cases: interpolation where spindle angular position must be a trajectory coordinate coordinated with X/Z or another live-tool axis.

Now the spindle motor/encoder is participating in a servo axis. The implementation must arbitrate at least:

- spindle velocity command ownership;
- C-axis position command ownership;
- encoder feedback routing;
- index-enable ownership;
- PID/drive mode;
- homing/reference state;
- spindle enable/inhibit/brake state;
- transition alignment so enabling the C position loop does not create a one-revolution or stale-command step.

LinuxCNC community implementations solve this in HAL/remap/custom M-code logic; there is no single universal native “turn spindle into C axis” transaction.

## 4. Real dual-role C-axis bug and current fix — LinuxCNC issue #3556 / PR #4200

Issue `LinuxCNC/linuxcnc#3556` documents a real rotary/spindle configuration where the same encoder index-enable signal was used for C-axis homing and spindle-synchronized G33/G33.1 motion.

The test configuration used:

- a C rotary joint homed to spindle index;
- a spindle mode using the same physical stepgen/encoder;
- mode-switch M-codes that changed stepgen settings and feedback routing;
- M420-style transition back to rotary mode by first orienting the spindle to 0° and reconnecting C feedback;
- disconnection of `joint.N.index-enable` in spindle mode as a workaround.

Observed failure before the fix:

- G33 could rapid to the target instead of waiting for spindle index when `joint.N.index-enable` shared the signal with `spindle.N.index-enable`;
- unlinking the joint index-enable restored expected synchronized behavior.

### Root cause found upstream

Merged PR `#4200`, commit `1db4ebe2b71ded81713c0304aca04d3aa921ece5`, identified the concrete ownership bug:

`joint.N.index-enable` is a `HAL_IO` pin. Homing and the encoder legitimately share it, but idle homing code wrote its value every servo cycle. When homing was not actively owning an index search, it still clamped the shared signal low and could overwrite the spindle synchronization request in the same cycle.

The fix changed homing to drive this IO pin only on its own request/release edges, leaving the shared signal alone when homing does not own it.

The original reporter independently retested the same hardware and confirmed the fix worked.

### Version consequence

The current 3200 pinned revision `f666f1a...` is **638 commits ahead of and contains** merged fix commit `1db4ebe2...`. Therefore the old “always disconnect joint index-enable or G33 will break” workaround is historical evidence, **not a generic requirement at the pinned revision**.

The durable lesson is more important than the workaround:

> A dual-role spindle/C-axis design often shares IO/feedback signals across subsystems. HAL_IO/shared-state writers must have explicit ownership. A subsystem that is idle must not clamp a shared signal and accidentally cancel another subsystem's request.

## 5. Current field architecture — 2026 Schaublin C-axis discussion

A March–April 2026 LinuxCNC forum retrofit provides a useful current implementation pattern.

One contributor describes a spindle/C-axis system where the C axis is conceptually always configured but is paused/disconnected while spindle or orient control owns the hardware. The transition logic is roughly:

### Startup / C-axis homing

- start with C-axis control available;
- home axes, including C to index;
- once C is homed, automatically switch the physical spindle hardware to ordinary spindle mode.

### C-axis -> spindle mode

- verify C axis homed;
- move C to a known angular position;
- disconnect C encoder/PID ownership;
- disable C PID;
- change shared stepgen/drive settings to spindle values;
- ordinary spindle control owns the actuator.

### Spindle -> C-axis mode

- require C homed;
- issue M5 / inhibit spindle command ownership;
- use M19 to orient the spindle to the known C zero alignment;
- change shared drive/stepgen parameters to C-axis values;
- reconnect encoder feedback;
- enable C PID;
- C starts from the aligned known position rather than an arbitrary stale command.

The same field report adds an important failure lesson: mode switching without explicit spindle stop/inhibit can leave an earlier M3 state latent. On return to spindle mode, a later S command can immediately cause rotation. Their corrected transition explicitly uses M5 and `spindle.N.inhibit` during ownership switching.

This is community evidence, not a universal LinuxCNC architecture, but it demonstrates the right systems question: **which controller owns the motor now, and what stale command could become live when ownership changes?**

## 6. Real C-axis ownership model

For curriculum purposes, represent a dual-role spindle as an ownership state machine rather than a mux diagram alone:

```text
SPINDLE_SPEED
    owner: spindle velocity loop / drive
    allowed commands: M3/M4/M5/S
    C PID: inactive or safely paused

ORIENT
    owner: orient position command / orient PID or drive-native orient
    entry: ordinary spindle stopped
    completion: is-oriented + optional brake/lock witness

C_AXIS
    owner: C joint/axis position loop
    entry: spindle stopped/inhibited, reference valid, feedback aligned,
           C command initialized to current known angle
    ordinary spindle command path: unable to assert drive motion
```

Optional separate states such as FREEWHEEL/MAINTENANCE or FAULT/RECONCILE should be explicit if the machine supports them.

### Transition requirements

A robust transition should establish, in a machine-specific order:

1. outgoing owner has ceased commanding motion;
2. drive/actuator mode is suitable for incoming owner;
3. shared feedback routing belongs to the incoming owner;
4. position reference is valid (orient/index/homing as required);
5. incoming command is initialized consistently with actual position;
6. brake/inhibit/enable state is correct;
7. only then is incoming control authority released.

Do not use a timing delay as a substitute for these state witnesses unless the hardware genuinely provides no stronger signal and that limitation is explicit.

## 7. Failure modes to teach

| Failure | Likely consequence | Required diagnostic separation |
|---|---|---|
| M19 never asserts `is-oriented` | M19 times out; do not pretend indexed cut is ready | orient request, angle command, measured position, poserr, drive output, brake, fault |
| `orient-fault` nonzero | orientation aborts | retain drive-specific fault reason separately from generic M19 failure |
| C enabled at stale commanded angle | abrupt rotation/following error | actual angle, commanded C, handoff alignment |
| spindle M3 state remains latent during C mode | unexpected rotation when speed/ownership returns | spindle command state, inhibit, drive mode, C ownership |
| C and spindle loops both enabled | fighting controllers / unstable output | ownership bits, PID enables, mux/drive-mode selection |
| index-enable shared writer conflict | synchronization/homing corruption | IO ownership and version; PR #4200 fixed one concrete LinuxCNC case |
| C feedback disconnected then reconnected without reference reconciliation | coordinate jump / wrong part angle | encoder continuity, home/orient reference, joint feedback offset |
| drive mode changed but not acknowledged | command interpreted in wrong mode | drive mode command + actual mode witness |

## 8. Indexed live-tooling versus continuous C-axis recommendation boundary

At 3200 level, choose the simpler architecture when it satisfies the process:

- **Discrete angular positioning only:** prefer M19/orient plus appropriate spindle brake/holding verification.
- **Continuous coordinated polar/rotary interpolation:** a real C axis is justified, and mode ownership/reconciliation becomes part of machine architecture.

Do not build a full C-axis servo transition solely because “live tooling” exists. Live tooling can be used at a fixed indexed spindle angle without a continuously interpolated C axis.

## Evidence classification

| Claim | Classification | Evidence |
|---|---|---|
| M19 publishes angle/mode/orient and waits for `is-oriented` with Q timeout | OFFICIAL DOCS CONFIRMED | pinned `m-code.adoc` |
| `orient.comp` provides target-position generation, optional index reacquisition and debounced in-position completion | PINNED SOURCE CONFIRMED | `orient.comp` |
| M19 is not itself a continuously coordinated C coordinate | ARCHITECTURE/INTERFACE CONFIRMED | native M19 contract versus trajectory-axis semantics |
| Dual-role C-axis/index sharing caused a real G33 failure before June 2026 | FIELD + REPRODUCTION CONFIRMED | issue #3556 |
| Root cause was idle homing clamping shared HAL_IO index-enable | UPSTREAM FIX CONFIRMED | PR #4200 |
| Same-hardware retest confirmed fix | INDEPENDENT FIELD RETEST | PR #4200 comment / issue closeout |
| Current pinned revision contains the fix | REPOSITORY ANCESTRY CONFIRMED | `f666f1a...` is 638 commits ahead of merge `1db4ebe2...` |
| Every C-axis machine must use the described M254/M255 architecture | REJECTED | community pattern, not generic requirement |
| Every live-tool lathe requires a true C axis | REJECTED | M19 indexed positioning can satisfy discrete-angle operations |

## Lab decision

No new toy C-axis simulation is launched from this pass. The most valuable current evidence is unusually strong: official M19 contract, inspectable `orient.comp`, a reproducible upstream dual-role C-axis bug with root-cause patch, same-hardware retest, and a recent field implementation describing the mode-transfer hazards.

A future 3200 lab is justified when freezing one of these remaining implementation questions:

- command/feedback bumpless transfer between spindle and C ownership;
- stale M3/S reactivation during transition;
- drive-mode acknowledgement failure;
- abort/restart while in ORIENT or midway through C/spindle ownership transfer.

## 3200 teaching rule

A turning-center spindle used as a C axis is **one physical plant with multiple possible command owners**. Safe, diagnosable behavior requires an explicit ownership state machine and fresh reference/command alignment at every transfer. The mux is implementation detail; ownership and witnesses are the engineering contract.