# 3300-L1 — QtPlasmaC `laser_mode` source history and exact THC semantics

Date: 2026-09-14
Pinned LinuxCNC revision for source conclusions: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`
Status: COMMUNITY -> UPSTREAM SOURCE trace; fiber-specific height-control adaptation is merged upstream, but remains narrower than a production fiber process controller

## Why this trace matters

The breadth pass had already documented real fiber machines adapting QtPlasmaC, but it had treated the adaptation largely as machine-local compatibility glue. A targeted search for mature fiber behavior surfaced an important upstream history: a 2024 community experiment to make capacitive height control active independently of plasma torch/velocity semantics was converted into a LinuxCNC pull request and merged into `plasmac.comp` as the `laser_mode` input.

This is stronger evidence than a forum-only modification and materially refines the statement that upstream laser support is limited to `laserpower.comp` / `raster.comp`.

## Community chronology

LinuxCNC forum thread: `Always Active THC for Fiber Laser`, April-May 2024.

The machine builder's physical premise was that a capacitive fiber-laser head can measure standoff regardless of whether optical emission is active. The initial local modification therefore removed two plasma-oriented THC qualifications:

- dependence on `torch_on`;
- the initial requirement for current velocity to reach approximately requested cutting velocity before THC target acquisition/control proceeds.

The developer discussion explicitly proposed making the behavior a `LASER_MODE` rather than leaving a local source patch, and the contributor submitted an upstream change.

## Pull-request history

An initial draft PR #2972 was closed unmerged. It added a `laser_mode` pin and changed the two relevant conditions.

A cleaned PR #2973, `Plasmac.comp - laser_mode for fiber lasers`, was then merged on 2024-05-04 as merge commit `c4625fda63114cdb392d33b8c992f71bff5db9cb` (source commit `fd9022f06c1aac7be1696e517f0f88f57c260de9`). QtPlasmaC version history records `007.042 2024 May 3 — add laser_mode input pin for fiber laser use to plasmac.comp`.

This chronology matters because PR #2972 being closed does **not** mean the feature was rejected; equivalent cleaned work was merged through #2973.

## Pinned-source trace

At course-pinned revision `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`, `src/hal/components/plasmac.comp` exports:

`pin in bool laser_mode "laser mode for fiber lasers";`

Inside `CUT_MODE_01`, normal plasma THC processing enters its height-control section only while:

`(torch_on || laser_mode) && !mesh_enable && !ignore_arc_ok_0 && !ignore_arc_ok_1`

Thus `laser_mode` substitutes for the physical/plasma-oriented `torch_on` requirement at this gate. It does **not** erase the mesh or ignore-Arc-OK conditions.

When `target_volts == 0`, the initial velocity qualification is:

`current_velocity * 60 > requested_feed_rate * 0.999 || laser_mode`

Thus `laser_mode` also allows target acquisition/progression without first reaching the near-commanded cutting velocity threshold.

## Critical nuance — `laser_mode` does not remove every velocity lock

Downstream in the same source, once `thc_enabled` is active, the ordinary corner-lock path remains:

- when `cornerlock_enable` is true and current velocity falls below `requested_feed_rate * cornerlock_threshold`, `cornerlock_is_locked` becomes true;
- it unlocks only after velocity rises above approximately 99% of requested velocity;
- actual height-control correction executes only when neither corner lock nor void lock is active.

There is no `laser_mode` bypass in that downstream corner-lock block at the pinned revision.

Therefore the precise source-grounded statement is **not** “laser_mode makes THC unconditionally active at any velocity.” It removes `torch_on` and the *initial* near-requested-velocity gate from the main CUT_MODE_01 entry/target-acquisition path, while ordinary configured corner-lock/void-lock behavior can still suppress corrections.

This distinction is important because the original commit prose says laser mode allows THC to be active even when current velocity is lower than the commanded threshold. The implementation supports that at the initial gate, but later corner-lock configuration can still reintroduce velocity-dependent suppression.

## What `laser_mode` does not establish

The merged pin is a narrow fiber-specific height-control adaptation. It does not define:

- laser-source READY or FAULT qualification;
- source enable/modulation startup ordering;
- optical emission proof;
- assist-gas type, pressure or readiness;
- manual/motorized focus position;
- fiber-source pierce power/frequency recipe;
- source/chiller interlocks;
- abort/restart reconciliation of those process states;
- functional-safety or enclosure/interlock architecture.

The Sector67 real machine remains a useful contrast: it documents distinct source analog power, modulation, enable and READY surfaces, but its preserved config does not integrate READY into machine-on qualification and its gas control is intentionally simple. No `laser_mode` setting surfaced in the bounded search of that public configuration, so do not retroactively claim that machine used this upstream pin unless direct config evidence appears.

## Updated fiber height-control abstraction

The source now supports this bounded architecture:

`capacitive standoff signal -> QtPlasmaC voltage-like height input -> fiber-aware CUT_MODE_01 qualification (`laser_mode`) -> target/THC logic -> corner/void-lock qualification -> Z external-offset command`

This is specifically a **height-control adaptation**. It remains separate from:

`source ready/fault -> enable/modulation -> power request -> optical emission`

and from:

`gas recipe -> valve/regulator -> pressure/flow readiness`.

## Adversarial review — 8/8

1. Was the 2024 fiber-height change merely a private forum patch? **No. A cleaned version was merged upstream through PR #2973.**
2. Does closed PR #2972 show LinuxCNC rejected the feature? **No. PR #2973 merged the cleaned equivalent.**
3. Does `laser_mode` require `torch_on` for the main THC gate? **No; the condition is `torch_on || laser_mode`.**
4. Does `laser_mode` bypass the initial approximately-99.9%-requested-velocity condition? **Yes.**
5. Does it bypass every later velocity-dependent lock? **No; downstream corner-lock logic remains and contains no laser-mode exception at the pinned revision.**
6. Does it define laser READY/FAULT or emission proof? **No.**
7. Does it make QtPlasmaC a complete production fiber-laser controller by itself? **No. It adds a real fiber-aware height-control mechanism only.**
8. Can plasma Arc OK semantics be inferred from the existence of this pin? **No. Fiber source/readiness semantics remain distinct and machine-specific.**

## Promotion / next work

Promote `laser_mode` to the durable L1 source map as a first-class upstream fiber-specific QtPlasmaC feature.

Highest-value next evidence remains a real mature fiber configuration that connects source READY/FAULT, gas readiness/selection, focus/pierce and recovery into LinuxCNC authority. Do not spend another session re-searching the exact `laser_mode` history unless later source changes or a fault/recovery question make it relevant.
