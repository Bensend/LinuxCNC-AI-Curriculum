# Emergency-stop span-of-control / adjacent-hazard authority study

Date: 2026-09-18
Lane: independent safety curriculum Lane B

## Why this branch

At selection time the newest durable primary/adjacent work was CIP Safety replacement/recommissioning, while the primary safety stream remained concentrated on gravity-axis retaining proof and accessible-cell entry/restart. This study intentionally uses a different function and new artifact: emergency-stop span of control in linked machinery.

## Evidence vocabulary

- **SOURCE-CONFIRMED** — directly stated by an authoritative standard/manufacturer source cited below.
- **DOC-CONFIRMED** — directly present in a specific implementation manual/schematic.
- **TEST-CONFIRMED** — demonstrated by a controlled test with retained evidence.
- **COMMUNITY-REPORTED** — reported by practitioners but not independently verified.
- **INFERENCE** — engineering conclusion derived from evidence, clearly marked.
- **UNKNOWN** — unresolved and not to be filled by assumption.

## Architecture freeze

**E-STOP DEVICE ACTUATED != EVERY MACHINE STOPPED != CORRECT SPAN OF CONTROL SELECTED != ADJACENT HAZARDS CONTROLLED != HAZARDOUS ENERGY ABSENT != RESET PERMITTED != RESTART AUTHORIZED.**

A second freeze is equally important:

**ONE ZONE E-STOP ACTIVE != ANOTHER ZONE'S E-STOP FUNCTION MAY BE DISABLED.**

And for ordinary control integration:

**LINUXCNC/HAL E-STOP INDICATION != PERSONNEL-SAFETY E-STOP AUTHORITY.** LinuxCNC may consume status and inhibit ordinary commands, but the personnel-safety function must not depend solely on ordinary LinuxCNC/FPGA software state.

## Source trace

### S1 — ISO 13850 span-of-control requirements as reproduced by IDEC

Source: IDEC, ISO 13850 machinery-safety explainer, https://www.idec.com/en-eu/solutions/safety/law/iso-iec/iso13850 (accessed 2026-09-18).

**SOURCE-CONFIRMED:** The normal rule is that an emergency-stop device covers the whole machine. Multiple spans are an exception where stopping all linked machinery could create additional hazards or unnecessarily affect production.

**SOURCE-CONFIRMED:** When multiple spans exist, they must be clearly defined/identifiable, the device must be readily associated with the relevant hazard, and its span must be identifiable at the operating position.

**SOURCE-CONFIRMED:** Actuating one span must not create an additional hazard or increase risk in any span, and must not prevent initiation of an emergency-stop function in another span.

**SOURCE-CONFIRMED:** Span assignment considers physical layout/visibility, ability to recognize hazards, process safety implications, foreseeable exposure, and adjacent hazards.

### S2 — Pilz emergency-stop function boundary

Source: Pilz, `Emergency stop halts a hazardous movement`, https://www.pilz.com/en-INT/support/law-standards-norms/iso-standards/choosing-guards/emergency-stop (accessed 2026-09-18).

**SOURCE-CONFIRMED:** Emergency stop is a manually initiated function for halting potentially hazardous movement; the actuated device remains latched until deliberately released.

**SOURCE-CONFIRMED:** Emergency stop is not synonymous with removing power from the entire machine. Pilz separately identifies emergency switching-off as removal of system power.

**INFERENCE:** Curriculum diagrams must therefore name the hazardous functions/final elements affected by an E-stop rather than drawing `E-STOP -> all power gone` as an assumed truth.

### S3 — Rockwell cable-pull implementation evidence

Source: Rockwell Automation, 440E Lifeline 5 cable-pull switch product/documentation page, https://www.rockwellautomation.com/en-us/products/hardware/safety-products/440e-lifeline-5-cable.html (accessed 2026-09-18).

**SOURCE-CONFIRMED:** A professional emergency-stop device can monitor a long physical cable span and expose device/rope diagnostics. This is useful for conveyors and distributed machinery where emergency access must exist along a hazard zone.

**UNKNOWN:** The product page alone does not prove what linked equipment a particular installation must stop, what stop category is required, or what restart sequence is correct. Those remain application/risk-assessment and implementation questions.

## Failure-path worksheet

| Challenge | Safety question | Required evidence before acceptance |
|---|---|---|
| E-stop in Zone A | What hazardous functions in A and adjacent zones must stop? | documented span + hazard map + output/final-element trace |
| Zone A stop while Zone B continues | Can continued B motion/energy injure the person responding in A? | adjacent-hazard analysis |
| Zone A stop causes material/process upset in B | Does stopping A create a new hazard elsewhere? | process/hazard analysis; do not optimize only for uptime |
| E-stop A active | Can E-stop B still initiate its own safety function? | logic/configuration review + commissioning test where safe/practical |
| Two nearby E-stops have different spans | Can a responder identify the correct span without prior tribal knowledge? | physical identification/location review |
| HMI says `E-STOPPED` | Which physical final elements actually changed state? | safety-output and physical witness/feedback trace |
| E-stop device released | Is the emergency condition cleared and is separate reset/rearm required? | documented reset/restart sequence |
| Safety reset performed | Can stale LinuxCNC START/JOG/CYCLE immediately produce motion? | fresh-intent/restart test |
| Safety controller power cycle | Is span identity/configuration preserved and validated? | configuration/commissioning evidence |
| Cable-pull slack/break | Does the device detect the abnormal rope condition and what safe reaction follows? | device manual + installation test |

## Practical architecture pattern

For a linked system, teach the student to draw separate layers:

1. **Hazard/task zones** — where people can be exposed and which adjacent hazards can reach them.
2. **E-stop devices** — physical location and intended span, including cable pulls/portable stations where applicable.
3. **Independent safety evaluation** — which device maps to which safety functions/spans; ordinary LinuxCNC status is downstream information, not sole authority.
4. **Safety outputs/final elements** — contactors, STO channels, valves, brakes or other elements actually commanded by each span.
5. **Physical witnesses** — EDM, drive state, valve/pressure/position witness, standstill or other evidence where required by the safety design.
6. **Recovery** — emergency condition cleared -> device unlatch -> safety reset/rearm as required -> final-element proof -> separate fresh ordinary start.

This prevents a common conceptual error: treating a red mushroom as a global Boolean instead of a human emergency function with a defined physical hazard reach.

## Commissioning questions

- From every emergency-stop location, can a responder identify what it controls?
- Does every required operator/intervention/loading/exit location have emergency-stop access justified by the risk assessment?
- If spans overlap, are the overlaps intentional and documented?
- Can operation remaining outside the stopped span create or increase danger in the stopped span?
- Can a stopped span inhibit another span's ability to initiate emergency stop?
- Does every safety output trace to a real final element rather than stopping at a software bit?
- Does unlatching an E-stop avoid automatic hazardous restart?
- Does safety reset/rearm avoid converting stale LinuxCNC/HAL motion commands into fresh intent?
- Are inactive/detached portable E-stop devices unmistakably inactive if portable stations exist?
- After modification of zoning, linked equipment, safety logic or final elements, is span-of-control validation repeated?

## OpenPressBrake boundary

**UNKNOWN:** whether an OpenPressBrake installation is a single machine with one span, part of a linked cell requiring multiple/overlapping spans, or requires emergency switching-off in addition to emergency stop.

**UNKNOWN:** exact stop category, final elements, hydraulic response, brake behavior, stopping distance/time, PL/SIL/category/DC, E-stop placement, or any zone mapping.

Do not infer these from this study. They require the actual machine hazard analysis, architecture and measurements/documentation.

## No-compute decision

This is a source/architecture question. Executable verification would not answer the unresolved physical span and hazard questions, so no simulation, synthesis, benchmark, hosted Actions, or self-hosted runner job was justified.

## Exact next independent work

Find a complete professional linked-machine/cell implementation that exposes:

`E-stop device/location -> identified span of control -> safety evaluator -> outputs/final elements in that span -> adjacent-zone behavior -> physical witness -> latched stop -> deliberate reset/rearm -> separate fresh ordinary START`.

Prefer an implementation with two overlapping/different spans and an explicit failure/commissioning case. Preserve **UNKNOWN** wherever public evidence does not expose the final-element or adjacent-hazard behavior.
