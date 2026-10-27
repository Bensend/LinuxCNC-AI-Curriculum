# 4400 FEED-JOG-01 predecessor reconciliation and wheel-jog source correction

**Date:** 2026-10-27; **status:** evidence/novelty correction, no machine test or new competency. This is an engineering learning-method correction, not a claim of newly discovered safety behavior.

## What was wrong with the first-pass novelty statement

The 08:32Z session scanned the full canonical learner index and research plan for literal `feed-hold`, `feed-inhibit`, `jog-stop` and nearby safety terms. It then initially described the feed/jog distinction as an uncovered source mechanism. That was **incorrect**: the [2026-10-24 original SET-01 audit](4400_LINUXCNC_FEED_INHIBIT_JOG_DOCUMENTATION_VERSION_DRIFT_2026-10-24.md) had already compared LinuxCNC 2.7 and current documentation, traced v2.7.15 versus master new-jog command acceptance, and found a **joint wheel-jog exception**. Historical [PROGRESS](../PROGRESS.md) and cumulative [Safety Design Package §11CC](../safety-course/SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md) preserved those details even though the index did not surface the exact keywords in the inspected headings.

The new [FEED-JOG-01 audit](4400_LINUXCNC_FEED_HOLD_INHIBIT_JOG_STOP_SAFETY_AUTHORITY_SOURCE_AUDIT_2026-10-27.md) is therefore classified **predecessor source reinspection + incremental M53/homing/stable-version evidence**, not a new generic feed/jog competency. Preserve the earlier artifact; do not rename or overwrite it.

## Technical correction: the official manual's generalization has an exception

- **DOC-CONFIRMED:** pinned [current motion(9) documentation](https://github.com/LinuxCNC/linuxcnc/blob/c9a5a0a5034177c8db64cb44abf14d4f2eb166f7/docs/src/man/man9/motion.9.adoc#L150-L172) says feed-hold/feed-inhibit apply to G-code, **not jogs**.
- **SOURCE-CONFIRMED:** pinned development [`control.c` joint wheel-jog handler](https://github.com/LinuxCNC/linuxcnc/blob/c9a5a0a5034177c8db64cb44abf14d4f2eb166f7/src/emc/motion/control.c#L1111-L1185) rejects new wheel-count deltas when `net_feed_scale < 0.0001`. [Stable v2.9.10](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/control.c#L1099-L1100) contains the same guard. `net_feed_scale` is set by ordinary feed scaling and feed-inhibit conditions, subject to enabled-mode bits.
- **SOURCE-CONFIRMED:** pinned development [`command.c` JOG_CONT handler](https://github.com/LinuxCNC/linuxcnc/blob/c9a5a0a5034177c8db64cb44abf14d4f2eb166f7/src/emc/motion/command.c#L842-L845) checks separate `jog_inhibit` for new keyboard/halui jog commands.
- **UNKNOWN:** exact runtime effect on all axis/wheel/jog modes, an already active jog, and any selected machine; no test was run. Neither path is personnel-safety authority.

The manual wording cannot be generalized to all jog entry paths, and a wheel-jog source gate cannot be generalized into a safety-rated jog stop. Both mistaken generalizations can produce dangerous retrofit assumptions.

## Information-gain / process correction

For proposed 'unworked' safety-source mechanisms, scanning canonical index/research plan **alone is insufficient** when historical research artifacts and PROGRESS contain deeper source addenda. Before claiming novelty, also inspect **repository research filenames** and the **historical PROGRESS/cumulative package** for exact subsystem and synonym matches, follow the most relevant predecessor, and classify the delta against its source paths and version. A match may require examining code symbols (e.g. `handle_jjogwheels`) rather than generic words like 'feed stop'. Record a concrete increment or mark duplication; do not multiply paper exercises.

**Actual increments retained this session:** M66 Task wait/timeout/volatile result; M0/M1 default pause/resume chain; FEED-JOG additional M53 P0/P1 gating, v2.9.10 cross-check, and homing-inhibit initiation-only source. Existing 2026-10-24 feed/jog findings remain authoritative prior art. **No independent evaluation, physical stop/hold proof, PL/SIL, local/hosted compute or machine release. G0/G1 HOLD.**
