# Press-brake 3600 — commissioning and recovery evidence checklist

Date: 2026-09-12
Status: SOURCE/DOC/COMMUNITY-SYNTHESIZED CHECKLIST
Pinned LinuxCNC source: `8bf4605ae81042248add031e94c77300406e0413`

## Purpose

Provide a generic evidence checklist for bringing a press-brake axis/control surface into ordinary production control without inventing machine-specific hydraulic values or treating LinuxCNC as a safety-rated system.

This is not an energized commissioning procedure. Physical machine work requires the actual machine documentation, hazard controls, qualified personnel and machine-specific acceptance criteria.

## 1. Reference and coordinate truth

Before trusting any target:

- record the configured home switch/index ownership and source;
- distinguish `HOME_OFFSET` (where the home event establishes the coordinate) from `HOME` (where the joint moves after homing);
- record whether the joint is volatile-home and under what state changes homing is lost;
- verify homed state and current reference episode before accepting runtime target authority;
- independently check at least one known machine-coordinate position after reference where practical;
- treat reference loss/re-home as a new runtime/reference episode even when the numeric target is unchanged.

LinuxCNC documentation explicitly separates HOME_OFFSET from HOME and documents index/latch and volatile-home behavior. The curriculum's pinned homing/source work further establishes that loss/abort of homing clears the trusted homed state.

## 2. Scale plausibility

For each measured axis/side:

- record encoder/drive scale and units;
- compare controller displacement with independently measured physical displacement over more than one position;
- use a long enough interval that measurement uncertainty does not dominate;
- check sign and direction explicitly;
- do not use one product dimension as the scale reference.

HostMot2 documentation defines encoder position from count/scale, so a scale error has a different travel-dependent signature from a constant datum error.

## 3. Direction and backlash/hysteresis

At selected machine coordinates:

- approach from positive direction;
- approach from negative direction;
- repeat to estimate measurement/repeatability spread;
- separate controller feedback residual from physical residual;
- if using ordinary-joint BACKLASH/COMP_FILE, retain its revision and map provenance.

LinuxCNC supports direction-dependent compensation maps; therefore direction-sensitive measurements are a required discriminator before declaring a constant correction.

## 4. Backgauge extra-joint authority

If a backgauge uses a LinuxCNC extra joint:

- verify it is homed before `posthome-cmd` authority is granted;
- bind each accepted TargetSet generation to a fresh runtime ExecutionEpisode;
- use an application-owned command/episode identity so reissuing the same numeric target cannot inherit stale completion;
- define `at-position` from current episode, reference validity, planner/command completion, feedback agreement and fault validity rather than target equality alone;
- invalidate the episode on reference loss, ordinary authorization loss, drive/feedback/controller fault, or reconciliation-required state.

At the pinned source revision, a homed extra joint publishes `posthome-cmd + motor_offset` to `motor-pos-cmd`, so application target/calibration ownership must be explicit upstream.

## 5. Tandem Y1/Y2 truth

Before using a global/Cartesian Y value as proof of beam state:

- inspect Y1 and Y2 feedback independently;
- verify scale/sign/reference for both sides independently;
- record differential `Y1-Y2` with defined sign convention;
- confirm which signal owns common trajectory request and which owns differential correction;
- retain final-side saturation/limit witnesses if used;
- do not infer squareness from a principal/Cartesian position that represents only one side.

Public field evidence supports independent side position loops plus differential synchronization as a feasible decomposition, while the exact final correction topology remains open in this curriculum.

## 6. Following and command validity

For ordinary coordinated joints:

- understand configured FERROR/MIN_FERROR semantics and expected velocity relationship;
- observe following-error behavior under representative commanded movement;
- do not simply enlarge limits to suppress unexplained trips;
- distinguish reported following error from independent physical truth.

LinuxCNC documentation states that FERROR/MIN_FERROR define a velocity-dependent permitted following-error envelope. These are ordinary motion fault thresholds, not functional-safety stopping guarantees.

For homed extra joints, the pinned source makes ordinary motmod following error irrelevant, so an application-level backgauge following/at-position witness must not assume the ordinary joint ferror mechanism provides that supervision.

## 7. Product correction versus machine calibration

When a trial bend misses:

1. validate the measurement and provenance;
2. determine whether independent machine-coordinate error is actually present;
3. if physical coordinates are correct, investigate product/tool/material/gauge-plan correction;
4. if coordinate residual is systematic across unrelated programs, route to machine-calibration review;
5. preserve nominal geometry separately from empirical correction;
6. create a new TargetSet generation for every accepted correction revision.

Do not change HOME_OFFSET, scale, or machine geometry merely to make one product come out correctly.

## 8. Press-cycle completion witnesses

For each semantic process state (approach, bend, hold, decompression, return, etc.), record:

- requested state/mode;
- current ordinary authorization;
- physical or independently justified completion witness where one exists;
- timeout ownership and consequence;
- invalidation/fault transitions;
- recovery/reconciliation destination.

A timer expiring without a defined transition is not a complete timeout policy. Internal command state is not physical completion evidence.

## 9. Pressure/tonnage/process signals

Generic curriculum rules:

- retain sensor identity, units, scaling and calibration provenance;
- separate measured pressure from inferred tonnage/force unless a justified model exists;
- record where pressure/tonnage limits are enforced and whether they are ordinary control or an external safety/protection function;
- do not copy numeric limits from another machine;
- treat pressure/decompression plumbing and valve decoder truth tables as machine-specific.

The public Accurpress chronology shows pressure acquisition/control becoming integrated over time, but it does not supply universal press-brake numeric values.

## 10. Abort, pause and restart

- distinguish LinuxCNC Pause/Resume from Task Stop/Abort;
- preserve row/BendStep selection only as operator context after abort, not as motion authority;
- after abort/reference loss/restart, enter reconciliation before a fresh ExecutionEpisode;
- explicitly establish current physical workpiece/bend state before issuing motion again;
- do not use generic Run From Selected Line as automatic recovery from an interrupted physical bend.

Pinned Task source confirms `emcTaskAbort()` clears pending/interpreter execution state and resets/closes the task plan.

## 11. Diagnostics and evidence retention

For debugging/qualification captures:

- record LinuxCNC revision/config revision;
- record function/thread ordering relevant to the signals;
- preserve recorder producer-overrun evidence and deterministic continuity witnesses;
- use generation/episode IDs where correlating userspace/realtime/application state;
- do not rename nearest timestamps as 'same cycle' without a shared generation witness;
- keep independent physical references separate from transport/software health.

These rules inherit directly from the completed 2000-level recorder and multi-surface diagnostics work.

## 12. Recovery acceptance

A generic recovery gate should require the independently applicable facts, for example:

```text
transport/current communication acceptable
AND physical I/O/watchdog authority acceptable
AND required reference state valid
AND feedback independently revalidated as needed
AND required interlocks valid
AND process/workpiece state reconciled
AND current TargetSet generation accepted
AND explicit fresh rearm/execution episode
```

Restoration of one layer must not silently recreate authority owned by another.

## Evidence classes and stop rules

### Generic/source-supported

- home/reference semantics;
- encoder scale relationship;
- ordinary ferror semantics;
- Task abort versus pause distinction;
- extra-joint posthome ownership;
- recorder/generation integrity requirements;
- correction/calibration provenance separation.

### Machine-specific/physical

- hydraulic truth table and valve polarities;
- pressure/tonnage/decompression values;
- allowable Y1/Y2 differential;
- tooling/material correction limits;
- stopping performance and safeguarding;
- actual commissioning tolerances and acceptance criteria.

Do not fill the second category with synthetic numbers merely to make the checklist look complete.

## Next-work discriminator

This checklist closes the current generic commissioning/recovery pass. Re-check the F02 external handoff first next session. If still blocked, the highest-value remaining 3600 domain surface from the evidence-gap map is HMI/visualization of program state, target provenance and fault/stale state, unless new public tandem/hydraulic implementation evidence has appeared.
