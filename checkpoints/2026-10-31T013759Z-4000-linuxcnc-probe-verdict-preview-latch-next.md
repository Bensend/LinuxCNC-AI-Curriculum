# 2026-10-31T01:37:59Z — LinuxCNC G38 verdict, Task race and preview continuation

**NON-GRADUATED | LinuxCNC-first | UTC start:** [session witness](2026-10-31T013759Z-session-start-linuxcnc.md).

## Authority and work completed
Read START_HERE first, then mission, LEVEL_ORDER, WORK_SELECTION_POLICY (LinuxCNC-first owner update), CURRICULUM, SOURCE_POLICY, MODULE_TEMPLATE, PROGRESS, blind protocol/score, compute ledger and latest [00:36Z checkpoint](2026-10-31T003629Z-4000-linuxcnc-ecat-wkc-hm2-ppoll-next.md). Recovered PROBE-15 and examined pinned upstream LinuxCNC stable/development source, maintainer commits and issue history. No sealed answer material used. 1000/2000/F02/3000 CLOSED.

- [PROBE-16](../research/4400_LINUXCNC_PROBE_16_TASK_VERDICT_BARRIER_PREVIEW_AND_POSITION_SOURCE_VERSION_AUDIT_2026-10-31.md): source-traced G38 no-contact verdict from servo through Task's queue-buster and `#5061–#5070`. Stable v2.9.10 can report motion DONE while probe verdict is pending; development October 13/18 changes add probing, command-heartbeat and failed-status-read guards. Upstream #3650 is a field report, not a runtime result here.
- [Practical guide](../guides/4000-linuxcnc-g38-probe-result-preview-and-status-review-2026-10-31.md): result gating, initial input state, preview stub `#5070=0`, and separate encoder-latch path in upstream simulation HAL.
- PROGRESS reconciled with the latest 4000 LinuxCNC-first work; LESSON_LOG to receive actual UTC end/duration in a separate safe append.

## Next highest-value unblocked work
1. Inspect `encoder.comp` latch-position semantics, HAL scheduling, and one real maintained probe HAL+INI setup. Explain when a hardware encoder latch provides a better timestamp than G38's servo `carte_pos_fb` snapshot, without inventing resolution or accuracy.
2. If that branch has no new source information, rotate to LinuxCNC realtime/HostMot2/Mesa or G-code interpreter implementation, or maintained CAD/CAM post/ROS integration with a concrete unanswered question.
3. No routine lab: existing source and maintainer changes resolve the G38 ordering question. Only freeze a bounded test for a consequential unresolved runtime claim with verified local runner access and physical I/O isolation.

## Boundaries
Zero GitHub-hosted and self-hosted Actions compute, no workflow, build, simulation, machine operation or evaluator. No new authoritative job runtime; LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged. Runner dispatch/isolation UNKNOWN. OpenPressBrake G0/G1 HOLD; independent safety/evaluator gates unchanged. Hourly curriculum remains enabled.


## Same-session continuation — ENCODER-17
[Direct stable/development software encoder audit](../research/4400_LINUXCNC_ENCODER_17_SOFTWARE_LATCH_DOC_CONFLICT_AND_G38_METROLOGY_BOUNDARY_2026-10-31.md) found that `encoder.c` **does** implement fast-thread latch edge/count capture and slower `counts-latched`/`position-latched` publication. Official `rtcomps.adoc` calls the pins unused, conflicting with man9 and implementation. Multiple enabled edges before capture can overwrite the earlier buffered count. This is a **software HAL encoder**, not proven HostMot2/FPGA timestamp capture; G38 `#506x` remains a separate servo feedback snapshot. No lab or machine operation. Next: inspect HostMot2 index/latch source and one real HAL/INI if there is a concrete integration question; otherwise rotate to another LinuxCNC subsystem.


## Same-session source continuation — HM2-ENCODER-18
[HostMot2 encoder probe latch audit](../research/4400_LINUXCNC_HM2_ENCODER_18_FIRMWARE_GATED_PROBE_LATCH_VS_G38_SOURCE_AUDIT_2026-10-31.md) distinguishes **three** mechanisms: G38 servo feedback, software `loadrt encoder` edge sample, and firmware-gated HostMot2 FPGA encoder probe latch. Development and v2.9.10 source support `probe-enable`/`probe-invert` only for descriptor versions 0x83/0x84; `index-enable` has priority; probe event auto-clears the arm. No automatic `#506x` integration or installed-firmware proof. Next: a maintained real HAL/INI with supported probe-latch firmware if available; otherwise rotate to core motion/HAL/HostMot2 or CAD/CAM/ROS source work. No compute or machine operation.
