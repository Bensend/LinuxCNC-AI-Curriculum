# 3600 tandem-source availability re-check

Date: 2026-09-12
Status: **BOUNDED SOURCE-AVAILABILITY AUDIT**

## Purpose

Re-open the 3600 tandem branch only long enough to test the repository's explicit information-gain condition: has genuinely new public implementation/source appeared that exposes a mature Y1/Y2 correction path, final saturation/authority, per-side feedback ownership and realtime order?

## Ursviken / Pullmax Optima re-check

Primary diary:

https://forum.linuxcnc.org/show-your-stuff/58003-ursviken-pullmax-optima-130-press-brake-retrofit-with-4-axis-backgage

The full four-page public chronology was re-checked through the latest visible post.

Newly preserved nuance:

- December 2025 posts did include intermediate configuration attachments while the builder was bringing individual extra joints/servos online.
- February 2026 posts included preliminary `pullmax` / `pullmax-optima` component drawings/work while the architecture was still changing.
- February 13 closed-loop testing showed left/right valve commands driven through separate cascaded position/velocity control paths, but tuning was still incomplete.
- July 20 says the hydraulic flow-divider function was being emulated electronically in LinuxCNC/HAL.
- July 22 reports a successful steel bend and the mature *described* concept: one position PID per side plus a zero-command sync PID fed by Y1-Y2, slowing the leading side.
- The July 22 post still says the configuration will be shared after loose ends are resolved.
- No later post, public repository, or directly inspectable final Y1/Y2 configuration was located in this bounded re-check.

Therefore the evidence classification remains:

**COMMUNITY-REPORTED FIELD SUCCESS / FINAL SOURCE UNAVAILABLE.**

Intermediate development attachments must not be treated as the final tandem implementation. They can establish architecture evolution and real failure history, but not the mature correction insertion/saturation/addf/ferror details required by the 3600 source gap.

## Independent 2018 LinuxCNC press-brake thread re-check

Thread:

https://forum.linuxcnc.org/30-cnc-machines/35266-hydraulic-press-brake-control

The chronology was re-checked rather than treating the initial inline COMP skeleton as the whole project.

The later posts establish that the builder did progress beyond the skeleton:

- November 2018: configuration/HAL attachments and machine motion were reported;
- November 27: a custom component was reported working sufficiently to move the machine, with no homing yet and jumpy motion;
- November 28: updated files were posted after changing non-linear compensation; the builder reported a pressure-relief event kicking the mechanically driven hydraulic valve out of position and identified the need for closed-loop valve-position feedback.

This is useful field evolution evidence, but it still does not yield a mature inspectable final tandem controller source with all required ownership details. Later follow-up in the thread asks whether the machine was ever completed rather than publishing a final validated configuration.

Evidence classification remains **COMMUNITY-REPORTED / DEVELOPMENT SOURCE PARTIAL**, not a source-confirmed mature tandem architecture.

## Search result

A fresh bounded web/GitHub search for LinuxCNC press-brake Y1/Y2, sync-PID, tandem HAL/config and sensor-bending source returned:

- the already-known Ursviken diary;
- the already-known 2018 hydraulic press-brake thread;
- generic LinuxCNC examples unrelated to press-brake tandem control;
- commercial press-brake descriptions without inspectable LinuxCNC source;
- no new public repository containing a mature final tandem Y1/Y2 LinuxCNC configuration.

## Decision

The repository's information-gain stop remains justified. Do not spend repeated sessions re-searching the same two threads or build another synthetic architecture comparison merely because mature source is absent.

The only source events that justify reopening this branch are:

1. a newly posted/downloadable mature Ursviken configuration;
2. another mature tandem LinuxCNC implementation with actual HAL/COMP/INI/source;
3. source exposing exact correction insertion, downstream limiter/saturation, realtime function order, per-side following-error/fault ownership, and disable/recovery behavior.

PB-PREP-001 remains **INCONCLUSIVE / NO ARCHITECTURE RECOMMENDATION** and must not be retuned from these community reports.
