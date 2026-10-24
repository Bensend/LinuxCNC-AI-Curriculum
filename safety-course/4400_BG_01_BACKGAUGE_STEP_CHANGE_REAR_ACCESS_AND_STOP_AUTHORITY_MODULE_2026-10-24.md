# 4400-BG-01 — Backgauge safety across program steps, rear access and recovery

**Level 4000 | 2026-10-24 | SOURCE-READING / NOT GRADUATED | no machine test**

## Prerequisites and learning objective

Requires 2520 hazards/SRS, 2530 E-stop, 2540 final elements, 2570 drive STO, 2580 energy isolation, 2590 guarding, 4400-GUARD-01 and 4400-RST-01. Learner must be able to distinguish **ordinary programmed backgauge step**, **safety-related motion inhibition**, **actual physical axis stop**, **guard/occupancy protection**, **maintenance isolation**, and **deliberate fresh start**, while mapping independent press-beam Y1/Y2 hazards.

Read [original manufacturer/source audit](../research/4400_PRESS_BRAKE_BACKGAUGE_STEP_CHANGE_REAR_ACCESS_AND_INDEPENDENT_STOP_OEM_AUDIT_2026-10-24.md) and [technician/witness exercise](4400_BACKGAUGE_PHASE_AND_REAR_ACCESS_TECHNICIAN_WITNESS_2026-10-24.md). The OEM example is TRUMPF B35 **2023-05-01**; it is not an OpenPressBrake configuration.

## Distinct hazard boundaries

- **H-BG1:** operator hand between backgauge finger and sheet/tool while programmed X/R/Z/L motion starts or resumes.
- **H-BG2:** rear helper/technician between moving gauge carriage and fixed frame/tooling after guard opening, restoration or setup.
- **H-BG3:** added finger, work support or loaded tool creates a new collision/pinch envelope that normal soft limits may not represent.
- **H-BG4:** normal STOP, E-stop, or guard input inhibits one axis but another continues, returns or restarts on a queued step.
- **H-BG5:** stopping gauge motion does not stop hydraulic ram gravity movement, sheet sweep or other independent hazards.

For each H-BG, capture exposed people, machine modes, energy source, approach/access route, protective demand, required physical state and restart rule. Never reuse a point-of-operation optical device's coverage claim for rear access without physical evidence.

## Source-grounded mechanism

TRUMPF B35 printed **1-11, 1-19, 1-21–25** documents fast/unexpected backgauge motion, the automatic step-change foil-clamping hazard, distinct side/rear door reactions, E-stop backgauge STO with drive power present, and a next-step manual strategy triggered by START or footswitch. AMADA's EGBe product page independently establishes contemporary high-speed multi-axis gauges. These are **DOC-CONFIRMED manufacturer examples**. No LinuxCNC code path, machine-specific reaction time or selected safety wiring is proven.

**Adversarial misconception:** `ram at top && gauge actual == target && guard input green` does not prove the gauge cannot move on a later step, that a rear person is clear, or that the ram cannot fall. The next-position queue is an ordinary control concept, not a safety grant.

## Machine-neutral safety function contract (INFERENCE, not an installed circuit)

1. **SF-BG-ACCESS:** entry to a protected gauge hazard volume causes the independently engineered protective response for *every relevant hazardous axis* and prevents unexpected restart. Determine the selected protective device, physical final element, response time and access geometry.
2. **SF-BG-STOP:** when protective demand occurs, all gauge motions that can harm people reach the defined safe physical state; evaluate actual motor/drive/final-element state, not only LinuxCNC command zero or normal drive READY.
3. **SF-BG-REARM:** closing a guard or resetting E-stop does not initiate an old queued gauge step. Require personnel-clear determination where needed, separate safety reset and deliberate new operator start; define what happens to pending CNC steps.
4. **SF-BG-SERVICE:** tooling/finger adjustment behind the machine requires the selected hazardous-energy control and prevention of unintended motion, with reinspection and revalidation after any mechanical alteration. E-stop and STO are not lockout/tagout.
5. **SF-BG-COMPOSITION:** ram Y1/Y2, backgauge and sheet movement remain distinct physical propositions. A successful gauge STO witness is not proof of hydraulic ram holding, and a ram stop is not proof of gauge stop.

All five are **design requirements to derive and validate**, not claims that the selected machine already implements them.

## Phase and fault reasoning table

| Phase/event | Normal motion question | Independent safety question | Required physical witness |
|---|---|---|---|
| Power-on / reference | Are axes homed and a step retained? | Can a restart or home motion begin without deliberate authority? | Protected absence of unintended gauge/ram motion. |
| Tooling/finger setup | Are X/R/Z/L positions and appendages compatible? | Is access isolated or independently protected? | Guard geometry and appropriate energy isolation. |
| Sheet loading | Is next gauge position pending or moving? | Are operator/helper hands and rear zone protected? | No hazardous reach into moving gauge envelope. |
| Bend / decompression / beam-up | Which event advances the gauge? | Does mode change defeat any safeguard? | Protected response for each hazardous axis. |
| Guard open / E-stop | What happens to pending steps? | Does the independent safety chain withdraw motion authority? | Actual gauge stop and separate Y1/Y2 hold. |
| Guard close / fault reset | Does controller preserve the step? | Is there a fresh-start gate and zone-clear method? | No automatic movement on reset/power return. |
| Fault / service recovery | Does ordinary control attempt auto-return? | Are all dangerous return paths covered? | Qualified protected observation, never a person-exposed trial. |

## Practical human factors

Make **the safe workflow faster**: visible next-step state, labeled access request, rear guard that aligns and reinstalls without fiddling, accessible nonhazardous inspection positions, safe finger change process and per-axis fault localization. Ask a real operator/maintainer about sheet loading, foil clamping, finger adjustment and jam clearing; record actual friction rather than inventing minutes. A warning or buzzer can complement, not replace, guarding and independent safety functions. If a design predictably encourages someone to defeat the rear guard, redesign the workflow.

## Evidence and qualification gates

- **G0/G1:** collect as-built axes, OEM drive/guard hardware, exact SRS, protective geometry, safe state and independent authority. **HOLD** until known.
- **G2:** prepare paper/source review, nonhazardous inspection and measurement plan; **NOT RUN**.
- **G3/G4:** only qualified protected physical stop/hold/restart validation after machine-specific review; **NOT AUTHORIZED**.
- **G5:** genuinely information-separated fresh evaluator; **OPEN**. The accompanying paper scenarios are not a blind score.

**Selected OpenPressBrake:** backgauge safety implementation and physical Y1/Y2 stop/hold/guard/rearm remain **UNKNOWN**. Do not invent a hydraulic truth table, PL/SIL, speed limit or stopping distance. No exposed-person operation until basic minimum safe-to-operate protection is established; isolated/remote experiments require people outside danger zone and explicit residual-risk review.

## Promotion and next questions

| Unresolved question | Classification | Consequence | Blocks graduation? |
|---|---|---|---|
| Actual X/R/Z/L hardware, triggers and queued-step cancellation | UNKNOWN | Unexpected gauge movement | **YES** for selected-machine proof |
| Independent rear/front/side guard authority and gauge drive stop | UNKNOWN | Exposure during rear access | **YES** |
| Measured worst-case stop and ram hold, separate from STO | UNKNOWN | Physical crush hazard | **YES** |
| Operator access friction and guard reinstallation quality | UNKNOWN | Foreseeable bypass | **YES** for field transfer |
| Novel information-separated learner evaluation | UNKNOWN | Transfer not demonstrated | **YES** |
| LinuxCNC implementation-specific backgauge step scheduler | UNKNOWN; ordinary control | Useful later 4000 integration detail; not needed for OEM safety source claims | **NO** for source-reading only; cannot graduate physical claims |

**Counterfactual:** any selected-machine UNKNOWN resolving differently could overturn the proposed machine safety claim, so this module is **not graduated**. No lab is frozen: authoritative documentation establishes the generic hazard; the remaining decisive questions require selected machine facts/qualified physical evidence, not synthetic tests.
