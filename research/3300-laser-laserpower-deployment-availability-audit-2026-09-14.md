# 3300-L1 — `laserpower.comp` real-deployment availability audit

Date: 2026-09-14
Pinned upstream LinuxCNC revision for course claims: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`
Status: SOURCE-SEARCHED DEPLOYMENT GAP; native component remains real upstream infrastructure, but no non-sim public deployment was found in this bounded pass

## Purpose

The L1 checkpoint called for a real machine using upstream `laserpower.power`. Existing course evidence already establishes three materially different real laser architectures — historical custom CO2/PPI/raster, Fusion/M67 -> Mesa PWM diode, and Sector67 Raycus fiber adapted through QtPlasmaC/spindle/PWM — while upstream LinuxCNC ships `laserpower.comp`, `raster.comp`, and a simulator integration.

This audit asks one narrow question: **is there public source evidence that a real LinuxCNC machine actually loads and consumes upstream `laserpower.comp` rather than merely copying the shipped simulator?**

## Bounded GitHub source search

Fresh global code searches targeted:

- `loadrt laserpower`
- `laser.control.power`
- `laserpower.power`

### `loadrt laserpower`

The relevant hits were:

1. upstream `LinuxCNC/linuxcnc/configs/sim/axis/laser/laser.hal`;
2. `hangsman/windowscnc/configs/sim/axis/laser/laser.hal`;
3. `lxlt8/linuxcnc_scurve_compact/configs/sim/axis/laser/laser.hal`;
4. `DuyHieu89/1.Linuxcnc-source/configs/sim/axis/laser/laser.hal`.

The latter three results are source-tree forks/copies of the same shipped simulator structure, not independent machine configurations.

### `laser.control.power`

The relevant hits likewise resolve to upstream `configs/sim/axis/laser/postgui.hal` and copies. In the shipped sim, `laser.control.power` is netted to the PyVCP display power indicator. This proves the simulator's observable integration but does not establish physical source/PWM hardware use.

### `laserpower.power`

This query is dominated by unrelated software projects that use similarly named laser-power structures. No additional LinuxCNC machine configuration surfaced in the bounded search.

## Evidence boundary

This result **does not mean `laserpower.comp` is unused in the field**. Public machine configurations are often private, attached to forum posts, or not indexed under the exact upstream symbol names. The correct classification is:

**SOURCE-SEARCHED PUBLIC DEPLOYMENT GAP.**

The component itself remains upstream source-confirmed and its behavior remains valid course material. What is not supported is promoting it to a canonical or dominant real-machine laser architecture.

## Comparison with evidence-backed real machines

The course currently has stronger public real-machine evidence for architectures that do *not* consume `laserpower.power` directly:

1. **Historical Buildlog CO2** — M3/M5 permission, analog power, custom PPI/raster timing, chiller/assist and overscan.
2. **JTrantow diode/Fusion** — CAM emits M67 power and `motion.analog-out-00` drives Mesa PWM.
3. **Sector67 Raycus C500 fiber** — QtPlasmaC material `CUT_AMPS` is transformed into spindle speed, then Mesa PWM and an external PWM-to-0-10 V converter feed the source's analog power input; source enable/modulation/READY and gas remain separate surfaces.

Therefore the L1 teaching hierarchy should be:

- upstream `laserpower.comp` / `raster.comp`: **native reusable realtime infrastructure with an inspectable shipped simulation**;
- real production architecture: **machine/process dependent and must be established from actual source/config evidence**;
- do not infer CO2, diode or fiber source readiness, gas/focus, emission permissives, fault recovery, or safeguarding from the existence of `laserpower.comp`.

## Architectural consequence

The useful transferable abstraction is not "laser machines use laserpower.comp". It is:

`CAM/process power intent -> synchronized or immediate command surface -> realtime power shaping when required -> hardware modulation interface -> independent source enable/readiness/fault authority -> optical emission`

Different real machines place the shaping and hardware adaptation at different points in that chain.

For vector cutting, corner/deceleration compensation may be implemented by `laserpower.comp`, by CAM/postprocessor output, by source/controller-specific logic, or not at all. Evidence for one path cannot be silently generalized to another.

## Adversarial review — 6/6

1. Does the lack of a public non-sim hit prove no real machine uses `laserpower.comp`? **No. It establishes only a bounded public-source gap.**
2. Is `laserpower.comp` therefore irrelevant? **No. It is real upstream realtime infrastructure and is useful for understanding velocity/distance-aware power shaping.**
3. Does the shipped simulator prove a physical laser source wiring contract? **No. Its power output is demonstrated into simulation/UI surfaces.**
4. Can the JTrantow or Sector67 configs be described as `laserpower.comp` deployments? **No; their preserved power paths are different.**
5. Does native power shaping establish source READY/FAULT, gas or focus semantics? **No; those remain process/source-specific authority layers.**
6. Should L1 keep searching the same exact symbols every session? **No. Reopen only on genuinely new candidate machine evidence or a specific behavior question.**

## Information-gain stop / reopen condition

Treat the "find a real upstream `laserpower.power` deployment" subtask as a branch-local information-gain stop after this bounded search.

Reopen when one of the following appears:

- a non-sim HAL file that actually `loadrt laserpower`;
- a machine repository that nets `laserpower.*` to PWM/analog source hardware;
- a build diary explicitly describing upstream `laserpower.comp` in physical operation;
- a source/test question whose answer depends on exact component scheduling or power behavior.

Until then, higher information gain lies in mature fiber source READY/FAULT, gas/focus/pierce and abort/recovery evidence, or another open 3000 specialization rather than repeating symbol searches.
