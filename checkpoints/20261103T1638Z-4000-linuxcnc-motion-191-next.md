# Next checkpoint — MOTION-191 — 2026-11-03 16:38 UTC

Read START_HERE.md, required governance, current progress/evaluation/compute, MOTION-190 and [MOTION-191](../research/4400_LINUXCNC_MOTION_191_G64_PQ_CONVERSION_AND_MODAL_ORDER_2026-11-03.md).

**Next highest-value work:** locate pinned v2.9.10 simulation INI/HAL by actual tree paths (the previous `configs/sim/axis/core_sim.hal` lookup returned NOT_FOUND); trace `loadrt motmod`, `addf motion-command-handler` / `motion-controller`, joint motor-pos-cmd and motor-pos-fb nets. Distinguish synthetic command loopback from independently measured feedback. Then prepare a reproducible geometry-sensitive interpreter fixture for G64 P-only versus P/Q and flush boundaries; do not claim TEST-CONFIRMED without actual execution. Recheck existing lab predecessor MOTION-144 before any executable experiment.

**Gates:** Only isolated `[self-hosted, openpressbrake]` for justified compute; never hosted Actions. No physical machine use; graduated 1000–3000 and independent blind/safety gates unchanged. If source gains plateau, rotate to real Mesa/QtPlasmaC machine configs or DXF→G-code integration. Update PROGRESS, LESSON_LOG and checkpoint, commit. Hourly remains enabled.
