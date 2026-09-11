# Ursviken/Pullmax — press-state vs hydraulic-decoder boundary and decompression evidence

Date: 2026-09-11
Status: **DEPENDENCY-SAFE 4600 COMMUNITY ARCHITECTURE RESEARCH**
Public thread: https://forum.linuxcnc.org/show-your-stuff/58003-ursviken-pullmax-optima-130-press-brake-retrofit-with-4-axis-backgage

## Why this source matters

The Ursviken/Pullmax diary is independently useful from the Accurpress case because it is a tandem Y1/Y2 hydraulic machine whose builder encountered exactly the distinction the generic 4600 state contract now makes: **press-process semantics are not the same thing as machine-specific hydraulic decoding**.

The evidence below is chronological. Most February 2026 architecture statements are design proposals/community reports, not final source-confirmed behavior. The July 2026 bend report establishes that the Y1/Y2 control concept reached physical operation, but the promised final downloadable config was still not public in the inspected thread.

## Physical hydraulic modes are genuinely distinct

In December 2025 the builder documented a machine hydraulic table with distinct combinations for:

- high-speed down;
- press-speed down;
- pressure holding;
- pressure relief;
- creep up;
- high-speed up.

The machine uses two side servo valves, a proportional relief/tonnage valve, and multiple discrete spool valves. The builder specifically notes that incorrect coordination can dead-head the pump and stall the 18 kW motor.

**Evidence class:** `COMMUNITY-REPORTED MACHINE DOCUMENTATION / FIELD OBSERVATION`.

### 4600 implication

This independently supports keeping **DECOMPRESSION / PRESSURE RELIEF** as a first-class process/hydraulic mode rather than treating return as merely “reverse Y velocity.” The exact valve combination is machine-specific and should not be generalized, but the existence of a distinct pressure-relief mode is domain evidence for the generic state contract.

## Independent hardware/safety authority is visible in the diary

The builder reports that:

- the E-stop circuit cuts power to the servos and hydraulics;
- the PWM-controlled valve supply has a power-disconnect contactor associated with the E-stop circuit;
- ram down motion also passes through a contactor wired to the foot pedal's down position;
- original machine logic included hardwired constraints around contradictory pedal commands, and the builder considered restoring an up-order behavior in hardwiring.

**Evidence class:** `COMMUNITY-REPORTED PHYSICAL ARCHITECTURE`.

This is much stronger evidence for an independent hardware authority boundary than the public Accurpress HAL, whose physical SSR destinations are unknown. It still does not establish a formal PL/SIL/category or certify the resulting retrofit.

## Architecture evolved toward two components, not one monolith

On February 10, 2026 the builder reported that a single `pullmax` component sitting above the joint command path created an ownership problem: it did not know when to activate hydraulic spool valves during LinuxCNC homing without also monitoring more motion internals. The proposed correction was to split responsibilities:

1. `press-state` — press-brake process state machine;
2. `pullmax-optima` — machine-specific hardware interface between LinuxCNC joint command/PID surfaces and the physical hydraulic spool/servo-valve behavior.

The stated motivation was to keep LinuxCNC motion/homing ownership usable while avoiding growing “spaghetti code” in one component.

**Evidence class:** `COMMUNITY-REPORTED ARCHITECTURE EVOLUTION`.

### 4600 implication

This independently reinforces the generic layered contract:

```text
press process state
    -> abstract motion/process request
    -> machine-specific hydraulic decoder/interface
    -> final actuator interfaces
```

rather than embedding every hydraulic truth table directly in the semantic press-cycle state machine.

## Proposed reusable state/decoder interface

On February 12, 2026 the builder explicitly proposed a common interface between generic press-state logic and machine-specific hardware decoders. The proposed surfaces included:

- Y position command;
- Y velocity command;
- Y tonnage command;
- decoded pedal-down state;
- an enumerated `motion_type_cmd` containing classes for fast/medium/slow up/down, **pressure dump**, halt, dwell, and homing motion.

The builder also proposed that each hardware decoder publish or configure which abstract motion types it supports, because individual presses have different spool-valve arrangements.

**Evidence class:** `COMMUNITY-REPORTED DESIGN PROPOSAL`, not final source-confirmed API.

This is a close independent match to the curriculum's current generic contract: semantic state and abstract hydraulic mode should be separated from machine-specific coil combinations.

## Important correction: do not copy the proposed enum as a standard

The public proposal is valuable architectural evidence, but its exact integer values and names are not a LinuxCNC standard and were not located in a final published implementation. The curriculum should therefore retain the **interface concept**, not canonize the numbers.

## Tandem result months later

By July 2026 the builder reported that electronic flow-divider behavior was being implemented in LinuxCNC HAL. On July 22, 2026 the builder reported a successful physical steel bend and described the working control concept as:

- one position PID for Y1;
- one position PID for Y2;
- one sync PID with command zero and feedback from Y1−Y2;
- sync action slows the side that is ahead.

This establishes useful field viability of the multi-loop tandem concept, but the final source/config was still promised for later and was not found in the bounded thread/repository search.

**Evidence class:** `COMMUNITY-REPORTED FIELD SUCCESS / FINAL SOURCE UNAVAILABLE`.

## Failure-engineering evidence from the same diary

The diary also contains concrete reminders that seemingly secondary auxiliary-axis logic can create destructive failures:

- an R-axis brake/servo timing interaction allowed the PID to wind up against a locked brake and a motor overheated;
- a later hard-stop/stalled-motor incident motivated a proposed timeout based on substantial amplifier command with insufficient joint velocity;
- brake timing logic caused motion glitches and homing overshoot.

These are not Y1/Y2 press-cycle proofs, but they strongly support the curriculum's rule that **command authority, achieved motion, timing qualification, and recovery ownership must be explicit**.

## Comparison with the generic state contract

| Generic contract idea | Independent Ursviken evidence | Strength |
|---|---|---|
| semantic press state separated from hydraulic decoder | explicit Feb 2026 split proposal after integration problem | COMMUNITY architecture evolution |
| decompression/pressure relief is distinct from ordinary return | machine documentation lists pressure-relief mode separately from creep/high-speed up | COMMUNITY machine evidence |
| hardware decoder differs by press make/model | builder explicitly proposes machine-specific decoder components | COMMUNITY design proposal |
| abstract command interface should avoid embedding coil truth table in GUI/state layer | proposed pos/vel/tonnage/motion-type interface | COMMUNITY design proposal |
| independent safety/hardware authority must remain separate | E-stop/valve-power/foot-pedal contactor descriptions | COMMUNITY physical architecture report |
| tandem common/differential loops can work physically | July 22 successful bend with 2 position + 1 sync PID | COMMUNITY field success |
| final correction insertion/saturation/fault path must still be traced | final downloadable config absent | UNKNOWN / blocks source-level conclusion |

## Adversarial checks

### “Because the builder proposed `motion_type_cmd`, those numeric values are a LinuxCNC standard.”

Rejected. They are one builder's proposed interface while the project was evolving.

### “Pressure dump can just be represented as negative Y velocity.”

Rejected as a generic assumption. The machine's own hydraulic documentation distinguishes pressure relief from creep/high-speed up; pressure-state change and geometric motion are not identical concepts.

### “The hardware interface component should own bend sequencing because it owns the valves.”

Rejected by the architecture lesson. Machine-specific valve decoding needs process-state context, but that does not require it to own semantic bend-program progression. The builder's own evolution moved toward a split.

### “A hardware E-stop contactor means LinuxCNC safety design is solved.”

Rejected. It provides evidence of an independent physical authority path, not a complete safety assessment or certification.

## Precise next checkpoint

1. Preserve the **state-machine -> abstract process/motion mode -> machine-specific hydraulic decoder** boundary as a 4600 candidate architecture supported by two independent public histories (Accurpress and Ursviken), while marking the Ursviken exact API as proposal-level evidence.
2. Search later public attachments/repositories only once more for the promised post-July-2026 working config. If absent, keep `FINAL SOURCE UNAVAILABLE` rather than inferring implementation details.
3. When 4600 becomes active, design an executable generic simulation around abstract modes such as HALT / APPROACH / WORK / HOLD / DECOMPRESS / RETURN rather than using any one machine's relay numbers.
4. Make downstream command saturation, Y1/Y2 differential fault, ordinary authorization loss, and recovery-state reconciliation explicit in that simulation; these details are still absent from the public field report.
