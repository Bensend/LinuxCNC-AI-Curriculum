# Active Curriculum Session State

Session start UTC: `2026-09-14T16:37:41Z`
Session end UTC: `2026-09-14T16:48:13Z`
Actual elapsed: **10.5 minutes**
Status: **CLOSED — 3300 plasma P1 source trace established; P2 real-machine commissioning and P3 production/recovery contracts materially advanced.**

## Prerequisite state

The 1000 and 2000 series remain **GRADUATED / CLOSED**. F02 remains graduated under its preserved valid information-separated evaluation. This session did not reopen, re-poll or re-score closed 2000 work.

## Active branch

Owner-selected active branch: **3300 — Plasma / Laser / Waterjet**.

Pinned LinuxCNC revision for source claims: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`.

Latest checkpoint: `checkpoints/3300-next-2026-09-14c.md`.

3200 remains intentionally paused and not graduated. 3600 remains at its preserved information-gain stop.

## Work completed

New durable artifacts:

- `research/3300-qtplasmac-process-eoffset-source-trace-2026-09-14.md`
- `research/3300-plasma-build-diary-comparison-2026-09-14.md`
- `research/3300-plasma-production-workflow-foundation-2026-09-14.md`
- `research/3300-plasma-rfl-pmx-source-trace-2026-09-14.md`
- `checkpoints/3300-next-2026-09-14b.md`
- `checkpoints/3300-next-2026-09-14c.md`
- updated `PROGRESS.md`

### P1 — process and external-offset ownership

Source-traced `plasmac.comp`, `qtplasmac_comp.hal`, Motion `axis.c`, Motion `control.c` and official external-offset documentation.

Established that QtPlasmaC owns realtime plasma process decisions and requested X/Y/Z external-offset count evolution, while LinuxCNC Motion owns the separately planned applied external offset, its velocity/acceleration allocation, insertion into Cartesian command and generic soft-limit clipping.

Preserved distinct nominal, requested and applied offset surfaces. Eoffset disable does not itself clear a nonzero offset. QtPlasmaC additionally maintains process-local Z bounds and explicit MAX_HEIGHT/END_JOB/recovery cleanup.

The source trace covered IHS/probe qualification, ohmic retry/float fallback, pierce, Torch On, Arc OK, separate arc-start failure versus arc-loss handling, pierce delay, puddle jump, cut-height transition, THC qualification, cut end/retract, limit faults, pause and cut recovery.

P1 bounded adversarial review: **8/8 passed**.

### P2 — real machine commissioning evidence

Preserved three materially different field histories:

1. Powermax 45XP + Mesa 7i96 + THCAD5 + external Arc OK — HAL-visible Arc OK still failed when QtPlasmaC mode was wrong; Mode 1 fixed Arc OK, then physical THCAD polarity had to be corrected; CAM/post behavior became the next layer.
2. QtPlasmaC + Mesa 7i96 + tandem-Y gantry — commissioning exposed Cartesian-axis versus physical-joint topology confusion; the machine remains XYZ with two Y joints/step generators.
3. Everlast 82i + Mesa 7i96 + THCAD-2 — credible voltage required correct THCAD frequency divide plus source-divider/scale/offset provenance; `/32` and scaling changes resolved the reported issue.

P2 bounded adversarial review: **6/6 passed**.

### P3 — material/CAM/recovery/PowerMax authority

Established production authority chain:

`CAD -> CAM/process intent -> postprocessor G-code/material commands -> QtPlasmaC filter -> interpreter/trajectory -> plasmac realtime state -> synchronized outputs/eoffsets -> physical process`.

Preserved M190 + material acknowledgement wait, P2 synchronized THC inhibit, P3 synchronized torch inhibit and E3 synchronized velocity reduction as command-intent surfaces distinct from realtime process qualification.

Pinned `run_from_line.py` was traced end-to-end far enough to establish that Run From Line reconstructs prefix modal/process state — units, path/distance modes, parameters, material+wait, feed, M03/M05, P2, P3 and E3 state — and synthesizes a new safe-entry program. It refuses active cutter compensation / unresolved subroutine contexts. This is distinct from realtime cut recovery using X/Y external offsets.

Pinned `pmx485.py` was traced as a Python userspace/non-realtime serial component with separate desired and reported mode/current/pressure, status, fault, limits and arc-time surfaces. It validates protocol replies, drops status and closes/returns remote control toward local state after repeated failures, and can attempt reconnection. `pmx485.status` is a communications witness, not realtime Torch/Arc OK or functional-safety authority.

P3 foundation adversarial review: **7/7 passed**. RFL/PMX continuation adversarial review: **8/8 passed**.

## Lab decision

No laboratory experiment was launched. Pinned source, official documentation and real-machine build histories provided higher information gain and directly resolved the active questions. `LAB_COMPUTE_LOG.md` therefore remains unchanged.

## Exact next checkpoint

Continue from `checkpoints/3300-next-2026-09-14c.md`:

1. trace exact `qtplasmac_gcode.py` hole/overcut transformations with representative input -> filtered output for P2/P3/E3 behavior;
2. inspect a current SheetCam and/or Fusion QtPlasmaC post to assign M190/P2/P3/E3 generation to the correct layer;
3. find a real `pmx485` field failure/recovery history and, if available, an inspectable/downloadable ohmic+float machine config;
4. integrate the result into a concise plasma production-diagnostics playbook;
5. when plasma P2/P3 reaches diminishing returns, rotate to **3300-L1** rather than over-mining plasma, then later W1.

Overlap: **No overlap.** Previous canonical session ended `2026-09-14T12:51:42Z`; this session began `2026-09-14T16:37:41Z`, **3h45m59s later**.
