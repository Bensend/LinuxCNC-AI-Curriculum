# Active Curriculum Session State

Session start UTC: `2026-09-14T19:33:49Z`
Session end UTC: `2026-09-14T19:42:32Z`
Actual elapsed: **8.7 minutes**
Status: **CLOSED — second production-style router ATC integrated; XYY gantry negative-HOME_SEQUENCE behavior source-closed; spindle/VFD readiness and dust/vacuum authority boundaries advanced.**

## Prerequisite state

The 1000 and 2000 series remain **GRADUATED / CLOSED**. F02 remains graduated under the preserved valid information-separated evaluation. This session did not reopen, poll or score closed prerequisite work.

## Active branch

Active 3000 work remains **3400 — Routers / Woodworking**.

Latest checkpoint: `checkpoints/3400-next-2026-09-14c.md`.

3300 remains open with preserved checkpoint `checkpoints/3300-next-2026-09-14f.md`. 3200 remains intentionally paused. 3600 remains at its branch-local information-gain stop.

Pinned LinuxCNC revision for upstream source claims: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`.

## Durable work completed

Created:

- `research/3400-funkenjaeger-dcnc-atc-dust-spindle-gantry-audit-2026-09-14.md`
- `research/3400-gantry-negative-home-sequence-source-trace-2026-09-14.md`
- `research/3400-router-spindle-vfd-readiness-fault-boundary-2026-09-14.md`
- `research/3400-router-vacuum-dust-authority-community-boundary-2026-09-14.md`
- `checkpoints/3400-next-2026-09-14c.md`

Updated `PROGRESS.md` to promote the evidence-backed 3400 contracts and preserve remaining gaps.

### Second real router ATC

`Funkenjaeger/fj-lcnc-cfg@f4877f862ab757bd396b02e54acb12e6835f8259` provides a materially different six-pocket rack ATC. The remapped M6 separates pneumatic source readiness, source/destination pocket occupancy, rack actuation, drawbar command, physical transfer evidence, logical `M61` tool identity, later fixed-tool measurement and prior dust-shoe restoration.

The inspected files expose six pocket sensors, an air-pressure switch and explicit drawbar/purge/rack outputs, but no direct drawbar-clamped/released feedback. Local abort paths clean some states; no global custom-output/tool-inventory reconciliation hook was found. Therefore an interrupted custom M6 remains a physical/logical reconciliation problem rather than an idempotent retry.

Repository history records a 2025 Auto-mode indefinite-pause fix involving spindle-at-speed behavior on the first feed move inside the toolchange and a subsequent physical adjacent-tool interference fix. This is useful commissioning chronology, not merely a final config snapshot.

### Dust / vacuum workholding

The DCNC dust shoe is a real auxiliary state machine with saved prior state, Z-clearance motion, pneumatic sequencing, retract-position feedback, timeout/abort and conditional restoration after M6. Its full down/swing-under completion remains partly dwell-based.

Community evidence supports multiple dust-collection ownership patterns and program/manual/VCP arbitration for vacuum clamping, but no trustworthy public production config surfaced with vacuum-zone control plus independent achieved/ready proof, loss response and restart recovery. Vacuum command and vacuum achieved remain separate; no universal threshold or recovery sequence was invented.

### Spindle / VFD

The real WJ200 userspace driver exposes `is_running`, `is_at_speed`, `is_ready`, `is_alarm`, actual frequency and a communications watchdog separately. The machine HAL wires at-speed into `spindle.0.at-speed` and surfaces alarm diagnostics, but no evidence was found that READY or watchdog freshness is used as a cut/ATC permissive. Status availability is not status authority.

### XYY gantry homing

Pinned LinuxCNC `homing.c` closes the previous gantry question. Negative HOME_SEQUENCE groups joints having the same absolute sequence value, but switch/search/latch reference acquisition remains per joint. `sync_ready()` synchronizes the **final HOME move** after participating joints reach the same final-move state.

If a homing episode reaches `HOME_ABORT`, the inspected source clears `homing`, `homed`, sequence membership and homing motion for **all joints**, not merely the failing gantry side. A one-side failed home therefore leaves the machine globally unhomed in this source contract. No synthetic gantry lab is justified.

## Adversarial / verification state

- second ATC / dust / gantry config audit: **8/8 passed**;
- synchronized gantry homing source trace: **7/7 passed**;
- spindle/VFD readiness/fault boundary: **7/7 passed**;
- vacuum/dust authority boundary: **7/7 passed**.

## Lab decision

No lab was run. `LAB_COMPUTE_LOG.md` remains unchanged at the preserved exact-recorded total of **338.56 minutes (5.64 h)**.

The gantry failure question was directly resolved by pinned source. The remaining potentially useful 3400 lab is narrow: if source inspection cannot resolve the user-visible state of an already-applied M64 Motion DOUT across Abort, machine OFF and E-stop, observe that DOUT in parallel with built-in iocontrol toolchange pins. Do not broaden it into a generic simulation campaign.

## Exact next checkpoint

Continue from `checkpoints/3400-next-2026-09-14c.md`:

1. finish source tracing arbitrary Motion DOUT behavior across program Abort, machine OFF / `EMCMOT_DISABLE`, E-stop/task state and shutdown/HostMot2 behavior;
2. run the bounded DOUT transition lab only if source still cannot answer the real runtime question;
3. reopen vacuum workholding only for a real implementation with pressure/ready/loss/recovery evidence;
4. if R5 closes or reaches a clean stop, checkpoint 3400 and rotate to an underdeveloped 3000 branch rather than over-mining routers.

Overlap: **No overlap.** Previous canonical session ended `2026-09-14T18:52:08Z`; this session began `2026-09-14T19:33:49Z`, **41m41s later**.
