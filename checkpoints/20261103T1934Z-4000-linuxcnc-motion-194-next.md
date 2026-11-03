# Next checkpoint — MOTION-194 — 2026-11-03 19:34 UTC

Read START_HERE.md and required governance, evaluation and compute records; read MOTION-194 and MOTION-193.

**Next priority:** locate a complete revision-pinned Mesa encoder-backed *axis* HAL/INI pair with explicit `encoder.scale`, `addf` read→motion→PID→output conditioning→write, amplifier enable, output scale, and following-error limits. The LinuxCNC issue #2388 A-axis signal dump demonstrates mixed feedback provenance but is **not** a complete or pinned config. Smithy 924 is a negative control: its axis feedback is stepgen-derived, its encoder is spindle-only. If no complete Mesa config is available, inspect upstream Pico servo HAL/INI as a non-Mesa comparator or rotate to OpenPressBrake/plasma DXF-CAM source. Avoid repeating signal-topology-only lessons.

**Runtime gate:** no compute without independently verified isolated `[self-hosted, openpressbrake]`; MOTION-144 first executable. No hosted Actions, physical machine, or blind-evaluator contamination. Preserve graduated levels, independent safety authority and hourly schedule.

Update PROGRESS.md, LESSON_LOG.md and a precise checkpoint; commit substantive work.
