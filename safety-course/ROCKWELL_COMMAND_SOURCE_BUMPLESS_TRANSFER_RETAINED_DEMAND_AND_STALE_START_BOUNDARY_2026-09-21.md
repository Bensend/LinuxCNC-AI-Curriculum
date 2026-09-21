# Rockwell command-source bumpless transfer, retained demand, and stale-start boundary

## Question
Can a designer assume that changing command authority (Hand/Maintenance/Override back to Program/Operator) destroys old demands and therefore inherently requires a fresh start?

## Evidence

### DOC-CONFIRMED — Hand explicitly tracks for bumpless transfer
Rockwell PlantPAx Process Motor (`PMTR`), Process Valve (`PVLV`) and Process Variable Speed Drive (`PVSD`) command-source documentation says that while Hand is the active source, the instruction tracks the actual device state for **bumpless transfer back to one of the other command sources**. PVSD explains that the block aligns with actual drive status for that transfer.

Therefore command-source transfer is explicitly designed to avoid a discontinuity; it is not generically a state-sanitization operation.

### DOC-CONFIRMED — inactive source settings can be retained
Rockwell PlantPAx display/library guidance states that transitions between command sources can be bumpless and that, when not selected, Operator and Program settings can retain their values regardless of command source. For PPID, Rockwell documents configurable tracking behavior: with bumpless transition selected, inactive source settings mirror the selected source; with it cleared, Operator/Program/External settings are not modified by the instruction.

### DOC-CONFIRMED — commands can still be accepted under higher-priority ownership
The PlantPAx command-source model documents Maintenance as superseding Operator/Program/External/Override while Operator commands/settings from the HMI are accepted. This means "not currently authoritative" cannot safely be generalized to "no latent state/request exists."

### DOC-CONFIRMED — disabling/scanning an instruction can clear some commands
For relevant process instructions, when the rung/EnableIn is false, Program and Operator commands can be ignored and cleared, outputs de-energized, and the object placed Out of Service. This is a different transition from merely changing command source. It proves that clearing semantics are transition/object specific.

## Result

The prior recommendation to require a fresh production start remains sound as a human-factors design objective, but this source trace corrects any temptation to assume the underlying controller object automatically provides stale-demand invalidation.

Freeze:

- **COMMAND SOURCE NOT SELECTED != ITS SETTINGS ERASED.**
- **HAND/MAINTENANCE ACTIVE != ALL OTHER DEMAND STATE ABSENT.**
- **BUMPLESS TRANSFER != FRESH START.**
- **AUTHORITY TRANSITION != STATE SANITIZATION.**
- **SOURCE RELEASE != PROOF THAT A PREVIOUS OR TRACKED DEMAND CANNOT TAKE EFFECT.**
- **ONE OBJECT/TRANSITION CLEARS COMMANDS != ALL MODE TRANSITIONS CLEAR COMMANDS.**

## Safety/human-factors implication

For machinery where an unexpected restart or resumed cycle can expose a person to hazard, the ordinary-control architecture should explicitly decide what happens to production demand on entry to service/maintenance/hand/override and on return. Do not rely on command-source arbitration alone.

A defensible project pattern is:

- latch `fresh_start_required` on entry to exceptional/service authority;
- cancel or quarantine pending automatic-cycle demand as appropriate to the machine;
- allow exceptional-state cleanup and safety reset/rearm to restore **eligibility**, not motion demand;
- require a new deliberate production-start event after handoff;
- keep the independent safety architecture authoritative for personnel protection.

This pattern is **INFERENCE / design guidance**, not a claim about a built-in PlantPAx safety function.

## Important nuance

Bumpless transfer is often desirable process-control behavior. It is not inherently unsafe. The defect is using a process-control continuity feature without analyzing whether retained/tracked state can cause unexpected hazardous motion when personnel reasonably expect a maintenance/service transition to have invalidated the old demand.

## LinuxCNC transfer

LinuxCNC mode changes, HAL enables, GUI cycle requests, FPGA enables and machine-specific state machines need the same explicit contract. A normal-control implementation should document whether a request is edge-triggered, level-held, latched, queued, cancelled, or regenerated across mode/authority transitions. Do not let a safety-ready signal resurrect an old normal-control demand.

## Sources
- Rockwell Automation Studio 5000 online help, `PMTR Command Source`, retrieved 2026-09-21.
- Rockwell Automation Studio 5000 online help, `PVLV Command Source`, retrieved 2026-09-21.
- Rockwell Automation Studio 5000 online help, `PVSD Command Source`, retrieved 2026-09-21.
- Rockwell Automation, PlantPAx Display and Library Guidelines, PROCES-RM200I-EN-P, Nov. 2025.
- Rockwell Automation Studio 5000 online help, `Configure PPID instructions`, retrieved 2026-09-21.
- Rockwell Automation Studio 5000 online help, `Process Command Source (PCMDSRC)` / process instruction execution semantics, retrieved 2026-09-21.

## Branch disposition
This question produced useful authoritative evidence. The curriculum should now stop treating "fresh start" as merely a reset-button lesson and teach **demand freshness as a separate state-machine property**. Next work should turn that into a reusable 25C0/25E0 review checklist/exercise, then rotate to another safety branch rather than over-studying PlantPAx internals.
