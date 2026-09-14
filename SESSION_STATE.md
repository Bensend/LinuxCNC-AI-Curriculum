# Active Curriculum Session State

Session start UTC: `2026-09-14T18:36:53Z`
Session end UTC: `2026-09-14T18:52:08Z`
Actual elapsed: **15.3 minutes**
Status: **CLOSED — 3300 W1/L1 evidence paths bounded and checkpointed; upstream fiber `laser_mode` source history promoted; work-selection rotation opened substantive 3400 router/woodworking ATC and abort-recovery source work.**

## Prerequisite state

The 1000 and 2000 series remain **GRADUATED / CLOSED**. F02 remains graduated under the preserved valid information-separated evaluation. This session did not reopen, poll or score closed prerequisite work.

## Active branch

Active 3000 work rotated from 3300 to **3400 — Routers / Woodworking** after the currently highest-value 3300 public-source paths reached branch-local information-gain stops.

Latest checkpoint: `checkpoints/3400-next-2026-09-14b.md`.

3300 remains open with preserved checkpoint `checkpoints/3300-next-2026-09-14f.md`. 3200 remains intentionally paused. 3600 remains at its branch-local information-gain stop.

Pinned LinuxCNC revision for upstream source claims: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`.

## Durable work completed

### 3300 Waterjet W1

Created `research/3300-waterjet-w1-field-chronology-pressure-authority-2026-09-14.md`.

A 2022 real-machine retrofit chronology establishes separate water/abrasive process wiring, a machine-specific active-low waterjet command chosen so controller loss leaves the pressure path de-energized/depressurized, and a clear separation between successful LinuxCNC control commissioning and later independent hydraulic leaks. An older converted FLOW machine adds long-lived deployment evidence but not process sequencing.

Industrial comparator evidence supports a CNC pressure-mode request being handed to a separate pump controller/PLC that owns the physical transition. No real downloadable LinuxCNC implementation exposing the full `pump/intensifier request -> pressure transition -> READY/fault -> cut authorization -> recovery` chain surfaced. That sub-branch is checkpointed as a source-availability gap, not promoted by inference.

### 3300 Laser L1

Created:

- `research/3300-laser-laserpower-deployment-availability-audit-2026-09-14.md`
- `research/3300-laser-qtplasmac-laser-mode-source-history-2026-09-14.md`

A bounded global source audit found upstream `laserpower.comp` loads only in the shipped laser simulation and source-tree copies, not an independently evidenced physical machine. The component remains native reusable infrastructure, not a proven canonical production architecture.

More importantly, the 2024 community fiber-height-control experiment was traced into merged upstream QtPlasmaC PR #2973. At the pinned source revision, `laser_mode` substitutes for plasma `torch_on` at the main CUT_MODE_01 height-control gate and bypasses the initial near-requested-velocity target-acquisition gate. It does **not** bypass later configured corner-lock/void-lock suppression and does not define source READY/FAULT, gas, focus, pierce or recovery. The result is source-confirmed fiber-specific height-control support, not a complete fiber process controller.

3300 was checkpointed in `checkpoints/3300-next-2026-09-14f.md` and then rotated under work-selection policy rather than repeatedly searched.

### 3400 Router / Woodworking

The repository already contained `research/3400-router-woodworking-breadth-survey-2026-09-14.md`; this session deepened one of its named real-machine targets instead of duplicating the survey.

Created:

- `research/3400-fenja-router-atc-source-audit-2026-09-14.md`
- `research/3400-fenja-atc-abort-recovery-audit-2026-09-14.md`
- `research/3400-linuxcnc-abort-motion-dout-source-trace-2026-09-14.md`
- `checkpoints/3400-next-2026-09-14b.md`

At `GuiHue/myfenjalinuxcnc@16af9ade9484e9f6897b19bd6453ab4bbe79c0ac`, the ATC config separates manual and automatic drawbar authority, gates release using a VFD running-state witness, distinguishes drawbar and tool-present sensors, updates logical tool identity only after physical pickup checks, then separately measures tool length. A dedicated 6-bar air-pressure signal exists.

The source audit also corrected a comment-level ambiguity: `M66 ... L0` is an immediate sample after the macro's fixed dwell, not a transition wait with timeout.

The interrupted-M6 audit found the config's `ON_ABORT_COMMAND` commented out. Its preserved `on_abort.ngc` only restores G90/G40/G49 and does not reconcile drawbar, physical tool, rack/pocket, pressure or tool-length state.

Pinned LinuxCNC source then established the generic ownership boundary: `emcTaskAbort()` and realtime `EMCMOT_ABORT` stop/clear execution state, while `Task::emcIoAbort()` explicitly clears built-in `iocontrol.0.tool-change/tool-prepare`; an upstream regression test covers that built-in handshake cleanup. The inspected generic abort paths do not explicitly clear arbitrary current `motion.digital-out-NN` values used by a custom M64/M65 drawbar path. Therefore custom ATC recovery must own actuator and tool-state reconciliation rather than borrowing assumptions from the built-in iocontrol handshake.

This conclusion is deliberately bounded and does not claim identical behavior for machine OFF, E-stop, startup or module unload.

## Adversarial / verification state

- Waterjet field/pressure authority review: **8/8 passed**.
- Laser `laserpower.comp` deployment availability review: **6/6 passed**.
- QtPlasmaC `laser_mode` source-history review: **8/8 passed**.
- FENJA ATC source audit: **9/9 passed**.
- FENJA abort/recovery audit: **7/7 passed**.
- LinuxCNC abort/Motion-DOUT authority review: **9/9 passed**.

## Lab decision

No lab was run. `LAB_COMPUTE_LOG.md` remains unchanged at the preserved exact-recorded total of **338.56 minutes (5.64 h)**.

A future bounded lab is now legitimate, but not yet mandatory, for one nonduplicate question: observe an already-applied M64 Motion DOUT across program Abort, machine OFF and E-stop while separately observing the built-in iocontrol toolchange pins. First compare another production ATC recovery architecture.

## Exact next checkpoint

Continue from `checkpoints/3400-next-2026-09-14b.md`:

1. inspect a second materially different router ATC with explicit failure/recovery behavior;
2. source-trace real vacuum-zone/pressure-proof and dust collector/dust-foot authority;
3. inspect spindle/VFD ready/fault around cutting and ATC;
4. compare XYYZ gantry squaring/home fault behavior;
5. only then freeze/run the bounded Motion-DOUT abort lab if it still adds independent evidence.

Overlap: **No overlap.** Previous canonical session ended `2026-09-14T17:50:56Z`; this session began `2026-09-14T18:36:53Z`, **45m57s later**.
