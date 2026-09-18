# Two-hand control: anti-tiedown, multi-operator, and restart-authority study

Date: 2026-09-18
Lane: independent safety curriculum Lane B

## Why this branch

The primary lane's newest durable checkpoint is advancing gravity-axis retaining/brake proof, ABB SafeMove recovery, and dual-brake independent proof. Lane B's preceding work covered three-position enabling devices. This study deliberately selects a different press safeguarding function: two-hand control and multi-operator concurrence.

## Evidence labels

- **SOURCE-CONFIRMED** — directly supported by cited manufacturer material.
- **DOC-CONFIRMED** — repository/manufacturer documentation establishes the stated architecture or behavior.
- **TEST-CONFIRMED** — demonstrated by a controlled test; none claimed here.
- **COMMUNITY-REPORTED** — community report only; none relied upon here.
- **INFERENCE** — engineering consequence drawn from confirmed evidence and clearly marked.
- **UNKNOWN** — machine-specific fact not established by available evidence.

## Authoritative evidence trace

### SICK Guide for Safe Machinery — two-hand device

**SOURCE-CONFIRMED:** SICK's 2024 Guide for Safe Machinery states that hazardous function is triggered only by deliberate actuation of two control switches and ends when either is no longer actuated. It states that a two-hand device protects only one operator; multiple operators require a separate device for each operator. For Type II/III, a new function requires both controls to be released and actuated again. For Type III, both must be actuated synchronously within 0.5 s. The guide also requires prevention of accidental/easy defeat and positioning so the device cannot be brought into the hazardous area.

Source: https://www.sick.com/media/docs/8/78/678/special_information_guide_for_safe_machinery_en_im0014678.pdf — Two-hand control device, p. 85, document 8007988, 2024-10-21.

### SICK Flexi Soft Safety Designer — Multi operator

**SOURCE-CONFIRMED:** SICK's current Flexi Soft Safety Designer manual provides a Multi operator function block that can monitor simultaneous operation of up to three two-hand systems. In its press example, multiple operators' two-hand systems must trigger downward movement in unison. Optional Release inputs can incorporate other safeguards. Crucially, Reset and Restart are handled independently of the Multi operator block. Its Cycle request can require every operator to release at least once before restart, preventing one or more two-hand controls from remaining permanently actuated.

Source: https://www.sick.com/media/docs/3/83/083/operating_instructions_flexi_soft_in_the_safety_designer_configuration_software_en_im0081083.pdf — Multi operator function block, Figure 115 / p. 152, document 8014519, 2025-07-30.

### Pilz P2HZ X4P

**SOURCE-CONFIRMED:** Pilz documents the P2HZ X4P as a two-hand control unit for press controllers. Its circuit is redundant and self-monitoring; Pilz states that the safety function remains effective after a component failure and that further press stroke is prevented for listed relay failure, welded contact, relay-coil defect, open circuit, and short circuit cases. The device is intended to keep both hands outside the danger zone during hazardous movement.

Source: https://www.pilz.com/download/open/P2HZ__X4P_Data_Sheet_1001960-EN-03.pdf — P2HZ X4P data sheet 1001960-EN-03.

## Architecture freeze

`TWO BUTTONS HIGH != VALID TWO-HAND ACTUATION != SAFETY OUTPUT RELEASE != PHYSICAL HAZARD CONTROLLED.`

`ONE OPERATOR VALID != ALL REQUIRED OPERATORS VALID != MULTI-OPERATOR RELEASE.`

`MULTI-OPERATOR RELEASE != RESET/RESTART SATISFIED != ORDINARY START AUTHORITY.`

`BUTTONS STILL HELD AFTER A CYCLE != FRESH TWO-HAND INTENT FOR THE NEXT CYCLE.`

`LINUXCNC/HAL SEES BOTH BUTTONS != PERSONNEL-SAFETY AUTHORITY.`

These inequalities are **INFERENCE** from the source-confirmed functional separation above. They are curriculum architecture rules, not claims that a particular OpenPressBrake implementation already satisfies them.

## Practical safety architecture

A two-hand safeguarding chain should be taught as distinct stages:

1. Physical actuator arrangement must make deliberate use of both hands necessary and make easy defeat difficult.
2. Independent safety evaluation determines whether the two actuations form a valid two-hand event, including the required simultaneity/release behavior for the selected device/function.
3. In a multi-operator station, each required operator gets an independently evaluated two-hand function; a safety-side multi-operator stage decides whether all required operators concur.
4. Other protective-device release conditions remain separate inputs where the application requires them.
5. Cycle/reinitiation logic prevents a permanently held/tied-down actuator from becoming continuing permission for repeated hazardous cycles.
6. Reset/restart handling is separate from the two-hand/multi-operator evaluation.
7. Final-element command, physical final-element response, hydraulic/mechanical energy state, and actual hazardous motion remain separate facts requiring their own validation.
8. LinuxCNC/HAL/ordinary FPGA may receive status for diagnostics and ordinary sequencing, but must not be the sole authority deciding that the personnel-protective two-hand condition is valid.

## Failure-path / commissioning questions

| Fault or challenge | Required observation / question | Evidence state |
|---|---|---|
| Press only left actuator | Hazardous release must not result from one hand alone | SOURCE-CONFIRMED principle |
| Press only right actuator | Same | SOURCE-CONFIRMED principle |
| Actuate controls outside the permitted simultaneity relationship | For a Type III implementation, invalid timing must not become a valid initiation | SOURCE-CONFIRMED; actual device timing UNKNOWN |
| Hold one actuator continuously, cycle the other | Must not permit repeated hazardous cycles where reinitiation/release is required | SOURCE-CONFIRMED principle |
| Hold both controls through end of cycle | Next hazardous cycle must require the specified release/reinitiation rather than treating stale held state as fresh intent | SOURCE-CONFIRMED principle |
| Mechanically tie down/wedge one actuator | Validate that layout plus safety logic does not make defeat equivalent to normal two-hand use | SOURCE-CONFIRMED design requirement; machine result TEST-CONFIRMED only after test |
| Two operators required; Operator 1 valid, Operator 2 absent | Multi-operator release must remain absent | SOURCE-CONFIRMED |
| Two operators required; one station permanently actuated | Cycle/release mechanism must prevent the stuck station from supplying indefinite concurrence | SOURCE-CONFIRMED function capability; configuration UNKNOWN |
| One operator releases during hazardous movement | Verify safety output/final-element reaction and actual hazard cessation against the machine's validated safety design | Logical requirement SOURCE-CONFIRMED; physical response UNKNOWN |
| Reset already asserted when valid two-hand state returns | Do not assume reset equals start; validate restart architecture independently | SOURCE-CONFIRMED separation / INFERENCE |
| Ordinary START/JOG/CYCLE command remains asserted while two-hand permission drops and later returns | Stale ordinary command must not silently become fresh hazardous-motion intent if the safety concept requires reinitiation/restart | INFERENCE; exact machine sequence UNKNOWN |
| LinuxCNC or FPGA reports both buttons true while safety evaluator rejects them | Personnel safety follows independent safety evaluation; ordinary control indication is diagnostic only | INFERENCE |
| Safety evaluator reports release but contactor/valve/drive fails to enter commanded state | Treat logical release and physical final-element state separately | INFERENCE; physical topology UNKNOWN |
| Power cycle with one/both actuators held | Verify no unintended hazardous restart and required reinitiation behavior | TEST required for actual machine |

## Press-brake relevance without inventing a design

**INFERENCE:** Two-hand control is especially useful curriculum material because it exposes a common conceptual error: treating a pair of ordinary digital inputs as if their Boolean AND were the safety function. The safety function also depends on physical actuator arrangement, anti-defeat behavior, timing/reinitiation rules, fault behavior, operator count, safety-side evaluation, and the downstream final-element/hazard chain.

This does **not** establish that OpenPressBrake should use two-hand control for any particular mode or machine. Safeguard selection, safety distance, applicable performance level, machine stopping behavior, operator geometry, and whether two-hand control is suitable for a specific press brake remain machine/risk-assessment questions.

## UNKNOWN — do not invent

- Whether the target OpenPressBrake machine will use a two-hand device at all.
- Applicable two-hand type or required PL/SIL/category/DC.
- Actual actuator spacing, shrouding, mounting position, or safety distance.
- Actual synchronization/discrepancy settings.
- Number of simultaneous operators.
- Hydraulic valve truth table, stopping time/distance, pressure, force, or retained energy.
- Exact reset/restart sequence and final-element feedback topology.
- Whether a machine-specific standard permits or requires a given two-hand arrangement for a particular operating mode.

## Compute decision

No simulation, synthesis, benchmark, or executable test answers the open question better than the authoritative source trace at this stage. No GitHub-hosted compute is justified. A future executable/physical verification should be question-driven and, if repository compute is needed, use only `[self-hosted, openpressbrake]`.

## Precise next independent work

Find a complete professional press implementation or safety-controller application that exposes the entire chain:

`physical two-hand stations -> per-operator safety evaluation -> multi-operator concurrence -> other safeguard release -> anti-tiedown/reinitiation -> safety output -> final element -> physical hazardous-motion response -> release of either operator -> stop -> reset/restart -> separate fresh ordinary cycle command`.

Prefer evidence that includes at least one fault case such as a welded/stuck actuator contact, permanently actuated station, channel discrepancy, or one operator releasing during the hazardous phase. Preserve machine stopping values and hydraulic truth as UNKNOWN unless directly documented or measured.