# 4400-PROBE-EDGE-01 — Touch probe ≠ protective stop
**One-pass technician card | 2026-10-28 | documentary transfer only, not a qualified test.** Read the [exact LinuxCNC source audit](../research/4400_PROBE_EDGE_01_LINUXCNC_2910_G38_PRESTATE_EDGE_AND_FALSE_SUCCESS_SOURCE_AUDIT_2026-10-28.md) after [M66 ordinary-input review](4400_M66_01_PROGRAM_WAIT_TIMEOUT_AND_PHYSICAL_INTERLOCK_REVIEW_CARD_2026-10-27.md).

## Why the distinction matters
On LinuxCNC v2.9.10, **G38.3 and G38.5 can accept a probe already in the desired state**. Their no-error bit also skips the initial-state rejection, so normal probe status may report success without a newly observed touch/release edge. G38.2/G38.4 reject an already-target input. This is **SOURCE-CONFIRMED** at the tagged revision; no machine test was run. The official G38 page's unqualified already-target error sentence is broader than the inspected source.

## Before interpreting a probe result
| Question | Ordinary control evidence | Not established |
|---|---|---|
| Which G38 variant? | G38.2/4 require target or error; G38.3/5 are no-error variants | That a target was physically contacted or released |
| Was the input already at target? | Review actual `motion.probe-input` state and polarity before a normal probe episode | New transition, redundancy, tamper resistance |
| Did `#5070` become 1? | Motion's `probe_tripped` status reported ordinary completion | A fresh edge, verified contact force or safe stop |
| Probe triggered during another move? | Ordinary `tpAbort` can occur on a sampled rising edge | Instant stop, safety-rated response, guaranteed detection of a stuck-HIGH input |
| Is jog/homing exception enabled? | Check `[TRAJ] NO_PROBE_JOG_ERROR` and `NO_PROBE_HOME_ERROR` | Independent collision or personnel protection |

**Preferred ordinary process design:** check prestate/polarity, perform a bounded normal probing operation, inspect the returned success result and reject unexpected states with an intelligible fault; use qualified machine-specific limits and collision controls separately. This is a review pattern, **not** deployment-ready G-code and not an independent safety function.

**Safer/easier operator path:** label the actual probe and its polarity, provide a visible prestate diagnostic and straightforward authorized tool-setter service procedure. Never require a worker to bypass a guard or defeat a sensor just to clear a confusing probe fault. A bypass-friendly routine is a design problem to correct.

**Physical boundary:** `#5070`, HAL bits, HMI lamps and planner abort are **normal control**. Independent safety logic and physical final elements must still prove guard/access behavior, hazardous-motion stop, gravity holding, energy isolation and deliberate restart. If that basic protection is unproved, **do not operate with people exposed**; any separately authorized experiment must be isolated/remote and people kept outside the danger zone.

**Selected OpenPressBrake:** installed Pilz/AKAS, K1/K2/EDM, Y1/Y2 independent hydraulic stopping/holding, guards, isolation and fresh restart remain **UNKNOWN/NOT RUN**; no assertion that this machine has a G38 probe. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; independent evaluator OPEN.** No test or safety-performance numbers claimed.


**Concrete upstream examples:** the tagged LinuxCNC simulated GladeVCP `probe.ngc` checks `#5070` after `G38.3` before `G10 L20` coordinate-offset updates; the simulated manual tool-change subroutine checks `#5070` before calculating `G43.1` tool offset. These are legitimate ordinary-control patterns but **do not check that contact was newly made**. A stuck-HIGH probe can therefore make the returned status misleading; no actual machine failure was observed. See the audit's source-depth continuation for immutable links.
