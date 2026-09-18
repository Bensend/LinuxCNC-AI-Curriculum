# Dual-Axis Hydraulic Disagreement and Machine-Integrator Boundary

Date: 2026-09-18

## Question

What new safety lesson appears when a press beam has two hydraulic Y axes and the component supplier provides monitored final elements but leaves the higher-level safety controller and machine operating modes to the machine builder?

Primary source: HAWE Hydraulik SE B 6340 - 04-2026 - 1.5 en.

## Source-confirmed architecture

HAWE documents two hydraulic single axes, Y1 and Y2, acting on the common upper beam. Each axis has its own safety-related QM2–QM5 valve set and BG2–BG5 position feedback. The machine safety controller actuates and monitors these elements according to the function diagram.

HAWE also states that the **machine manufacturer** must provide the necessary safety equipment/functions/controller, determine safe operating modes, integrate evaluation of valve-position, pressure, level/temperature and servomotor signals, and ensure product faults cannot create a hazard.

This is an important responsibility boundary: a certified/professional hydraulic subsystem is not a complete machine safety system by itself.

## Asymmetric state is a first-class fault

**DOC-CONFIRMED + INFERENCE clearly separated**

HAWE's decompression sequence independently stops each drive when that axis's BP1 indicates the piston side has reached the manufacturer's relief criterion, and the overall DECOMPRESSION state ends only after **both axes** have been relieved.

DOC-CONFIRMED fact: the two axes can therefore reach the pressure criterion at different times, and the sequence explicitly waits for both.

INFERENCE for curriculum design: the same discipline should be applied to any two-axis physical safety claim. A common-beam machine must not turn `left side proved` into `beam proved`.

### Freeze

`Y1 SAFE CLAIM != Y2 SAFE CLAIM != COMMON BEAM SAFE CLAIM`.

The common-beam claim requires the set of axis-specific evidence required by the hazard analysis, plus evidence that an asymmetric state itself cannot create a hazardous beam condition.

## Disagreement matrix

| Y1 evidence | Y2 evidence | Required interpretation |
|---|---|---|
| BG expected | BG expected | valve-position layer agrees; continue to pressure/load witnesses as required |
| BG expected | BG unexpected/stale | final-element disagreement; do not re-enable hazardous motion |
| BP relieved | BP not relieved | decompression incomplete |
| stationary | moving | hazardous common-beam disagreement regardless of command state |
| drive active | drive inactive during gravity descent | active-control asymmetry; invoke the validated stop path, not a software averaging assumption |
| all ordinary commands zero | all ordinary commands zero | says nothing by itself about gravity holding or pressure symmetry |

No OpenPressBrake threshold, allowable skew, stopping distance or pressure differential is inferred here.

## Why LinuxCNC/FPGA cannot paper over this

Ordinary LinuxCNC, HAL and the normal FPGA may:

- display Y1/Y2 diagnostics;
- compare ordinary position feedback;
- command synchronized motion;
- detect ordinary command/feedback disagreement;
- remove normal actuator authority through non-safety watchdog/fault logic.

They must not become the sole personnel-safety authority merely because they already know both axis positions. The independent safety architecture must own whatever axis-specific final-element, speed/position, pressure and re-enable evidence the validated safety functions require.

A software `Y1 == Y2` comparison also cannot prove:

- either holding valve is physically closed;
- either pressure volume is relieved;
- a parallel hydraulic path is blocked;
- stored accumulator energy is absent;
- a maintenance restraint is installed.

## Machine-builder integration lesson

HAWE explicitly leaves higher-level safety integration to the machine manufacturer. The curriculum should therefore teach component evidence and machine evidence as separate layers:

1. **component capability** — documented valve type, feedback switch, pressure sensor, drive interface;
2. **subsystem behavior** — HAWE operating-state and hydraulic-path behavior;
3. **machine safety logic** — integrator-defined safety controller, operating modes and evaluation logic;
4. **machine physical validation** — actual beam, tooling, guarding, stopping, pressure, load retention and stored-energy behavior;
5. **maintenance isolation** — task-specific physical isolation/discharge/blocking/restraint.

A strong component certificate or vendor safe-state description cannot skip layers 3–5.

## Commissioning challenges to carry forward

For a two-axis press architecture, validation should include controlled tests for:

- one BG feedback failing to transition while its mate does;
- one BP pressure witness reaching the expected state before the other;
- one drive-active witness disappearing during gravity-driven descent;
- one axis motion witness disagreeing with the other;
- a stale/failed axis diagnostic while the other remains healthy;
- safety reset attempted while an axis-specific discrepancy remains;
- ordinary LinuxCNC command retained across resolution of a safety discrepancy;
- common-beam stationary appearance despite an unresolved final-element discrepancy.

Physical challenge testing must be designed so the injected fault cannot expose personnel to the press hazard. If that cannot be achieved, test remotely/isolated with people outside the danger zone or use a validated lower-energy test method.

## Minimum-operate rule

If a hazardous common-beam operating mode depends on two axis-specific safety paths and the installed system cannot detect a required single-axis discrepancy before hazardous re-enable, that mode is **DO-NOT-OPERATE with people exposed** until the discrepancy-detection/validation gap is corrected.

This is qualitative. It does not assign PL/SIL/category/DC or invent a diagnostic interval.

## Next evidence target

Find an authoritative complete-machine or safety-controller implementation that shows how two hydraulic Y-axis valve-position/speed/pressure discrepancies are evaluated and latched through reset/re-enable. If public evidence does not expose that logic, preserve it as UNKNOWN and rotate to another safety branch rather than inventing a press-brake safety PLC program.
