# LinuxCNC Curriculum Lesson Log

This log records the actual wall-clock timing of autonomous curriculum sessions so hourly scheduling can be checked for overlap.

All timestamps are ISO-8601 UTC. Each session must append its row immediately before ending and commit the update whenever repository write access is available.

| Date | Module / Lesson | Start UTC | End UTC | Elapsed min | Status | Next lesson / checkpoint | Overlap / Notes |
|---|---|---|---|---:|---|---|---|
| 2026-09-05 | L00/L01 build-lab failure diagnosis | 2026-09-05T04:12:29Z | 2026-09-05T04:20:00Z | 7.5 | EXPERIMENT | Inspect rerun from `62777cc`; capture successful build/test evidence or diagnose next preserved failure | No prior logged lesson to overlap; first scheduled timing row |
| 2026-09-05 | L00/L01 successful rerun + L02 build/test source map | 2026-09-05T05:08:57Z | 2026-09-05T05:17:00Z | 8.1 | SOURCE | Run bounded `002` representative upstream HAL/RTAPI test and preserve evidence | No overlap; prior lesson ended 48m57s before this lesson began |
| 2026-09-05 | L02 representative upstream HAL/RTAPI test + stable pin | 2026-09-05T06:08:55Z | 2026-09-05T06:17:07Z | 8.2 | checkpoint | Build/test stable `v2.9.10` commit `86cdca76fa2a36274c432caa21952b23c267989a`, then begin Phase-0 adversarial exam/corrections | No overlap; prior lesson ended 51m55s before this lesson began. `002` passed 1/1 in POSIX non-realtime fallback mode. |
| 2026-09-05 | L01 stable baseline launch + L00-L03 adversarial/evidence pass | 2026-09-05T07:14:41Z | 2026-09-05T07:20:53Z | 6.2 | checkpoint | Inspect stable `003` run `33952061943`; reconcile result, run corrections/handoff, then graduate Phase 0 before A01 | No overlap; prior lesson ended 57m34s before this lesson began. Stable build/test was still in progress at checkpoint; exam, L01 version guide, L03 evidence guide, and progress state committed. |
| 2026-09-05 | L01 stable result + Phase-0 graduation + A01 architecture start | 2026-09-05T08:09:15Z | 2026-09-05T08:13:51Z | 4.6 | checkpoint | Continue A01: trace launcher startup order, milltask/NML initialization, Task→motion boundary, iocontrol role, then add process-topology lab | No overlap; prior lesson ended 48m22s before this lesson began. Stable `003` passed; L00-L03 graduated; A01 entered RESEARCH. |
