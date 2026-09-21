# BD03 — Machine I/O to Board Resource and Connection Plan

## Purpose

This is the first board-integration lesson. The goal is to turn machine requirements into a board plan without silently turning unknown machine facts into circuit requirements or hiding board-specific connector decisions inside reusable blocks.

Design flow:

`MACHINE I/O -> BLOCK INSTANCES -> FPGA/BUS/POWER/DOMAIN BUDGET -> CONNECTION DEFINITIONS -> UNRESOLVED LEDGER`

The output is not a schematic. It is the evidence-backed contract that makes schematic capture defensible.

## Learning outcomes

Students will be able to:

1. decompose a machine interface into electrical functions rather than connector names;
2. select reusable blocks only for requirements inside their qualified envelope;
3. instantiate a reusable block N times without copying machine names into its reusable contract;
4. aggregate FPGA pins, buses and power from block contracts;
5. distinguish logical demand from routed FPGA fit and timing evidence;
6. define board-specific connection requirements separately from functional blocks;
7. trace power and returns as domains, not as a generic `GND` assumption;
8. maintain an unresolved-resource ledger whose unknowns remain `TBD` or `VERIFY_AT_MACHINE`;
9. preserve the boundary between ordinary LinuxCNC/FPGA control and independent personnel-safety authority.

## Student-facing evidence audit for this lesson

The following OpenPressBrake files were opened in their current main-branch form during lesson construction and rechecked for the claims made here:

- `hardware/blocks/differential_encoder/engineering.yaml` — **VERIFIED_FOR_LESSON** for ownership boundaries, scalable receiver current/GPIO equations, machine-configuration unknowns and ordinary-control safety boundary.
- `hardware/blocks/differential_encoder/STATUS_CHECKLIST.md` — **VERIFIED_FOR_LESSON** for current implementation/release limits and Rev1 allocation state.
- `hardware/connections/rev1/J_PVR_ELEC_PWR.yaml` — **VERIFIED_FOR_LESSON AS AN INCOMPLETE CONNECTION-DEFINITION CASE**, not as a capture-ready connector. Its electrical mapping is explicit while exact connector, footprint, ratings, harness and placement remain unresolved.

Do not treat any of these classifications as permanent. Re-open the current files before a later lesson relies on them.

## 1. Start with functions, not existing connectors

A machine survey may say `X encoder`, `valve`, `limit switch`, `24 V feed`, or `PVR X12`. Those names are observations, not yet reusable block requirements.

For every machine interface record at least:

| Field | Question |
|---|---|
| machine function | What physical information or actuation is involved? |
| direction | Into or out of the controller? |
| electrical class | Differential, 24 V discrete, analog, SPI, RS-485, power, etc.? |
| channel/instance count | How many independent functions are required? |
| source/load envelope | What voltage/current/rate/impedance is known? |
| return/shield | What current return and shield/chassis relationship is actually evidenced? |
| ordinary vs safety | Is this ordinary machine control or part of an independently validated personnel-safety function? |
| evidence state | CALCULATED, DATASHEET, MACHINE_CONFIG, TEST/SYNTHESIS, VERIFY_AT_MACHINE, or TBD? |

A connector can carry several functions and one function can cross several connectors. Do not use connector count as I/O count.

## 2. Select blocks by contract fit

A reusable block owns its electrical function and reusable envelope. Board integration owns instance count and allocation. Machine configuration owns installed-device facts.

The current differential-encoder contract is a good example. One primitive receives one A/Abar, B/Bbar, Z/Zbar encoder and produces three 3.3 V FPGA logic outputs. The block owns the AM26LV32E receiver topology, pair protection requirements and termination variants. Board integration owns instance count, FPGA allocation, physical connector mapping, aggregate 3.3 V budget and protected encoder field supply. Installed encoder rate/current and cable/termination remain machine configuration.

That ownership split is the test for reuse. A mill spindle encoder, lathe spindle encoder, router axis encoder or press-brake axis encoder can instantiate the same primitive if its electrical contract fits; `Y1` does not belong inside the reusable primitive.

## 3. Build a typed resource ledger

Every resource line needs both a quantity and an evidence class.

Recommended evidence classes:

- `BLOCK_CALCULATED` — equation/value owned by the reusable block contract;
- `BOARD_CONFIGURATION` — instance count or deliberate board allocation;
- `MACHINE_CONFIGURATION` — installed-machine fact with evidence;
- `TEST_OR_SYNTHESIS` — measured or executable fit evidence;
- `VERIFY_AT_MACHINE` — physical fact intentionally unresolved;
- `TBD_ENGINEERING` — engineering decision not yet made.

Example using only the verified encoder contract:

| Resource | Per instance | N instances | Aggregate | Evidence |
|---|---:|---:|---:|---|
| FPGA inputs | 3 | N | `3N` | BLOCK_CALCULATED |
| 3.3 V receiver current max | 0.017 A | N | `0.017N A` | BLOCK_CALCULATED |
| receiver packages | 1 | N | `N` | BLOCK_CALCULATED |
| encoder field-supply current | unknown | N | unknown | VERIFY_AT_MACHINE |
| termination population | selectable variant | N | unresolved until cable evidence | VERIFY_AT_MACHINE |
| LUT/FF/BRAM/timing cost | not quantified by this block contract | N | unknown | TEST_OR_SYNTHESIS required |

The current OpenPressBrake status reserves 9 FPGA GPIO for its first-machine three encoders and 18 GPIO for six-instance reusable capacity. That is allocation evidence, not proof that an arbitrary future FPGA image routes and meets timing.

### Hard rule

`logical pins available != routed FPGA fit != timing closure`.

Do not promote LUT/FF/BRAM/PLL or timing numbers from guesses. When a real synthesis/place-route question is needed, use only the permitted self-hosted OpenPressBrake runner and preserve the resulting evidence.

## 4. Budget buses separately from pins

For every block instance record:

- dedicated GPIO;
- shared bus membership;
- chip-select/address requirement;
- interrupt/enable/fault lines;
- clock/PLL requirements;
- protocol bandwidth/latency assumptions;
- startup ownership and bus-contention behavior.

A shared SPI ADC, for example, is not `one analog pin per channel`. Conversely, a block with three FPGA outputs cannot be compressed into one resource merely because its field connector is one plug.

The board ledger must expose shared resources so integration can discover collisions before schematic capture.

## 5. Budget power as domains and current paths

For each block and connection, record:

1. source domain;
2. normal current;
3. worst-case simultaneous current basis;
4. startup/inrush where material;
5. return domain;
6. protection/fault-current return;
7. chassis/PE/shield relationship;
8. enable/inhibit behavior;
9. what happens de-energized.

Never merge `AGND`, `DGND`, field 0 V, chassis and PE because they all look like returns on a block diagram.

The current `J_PVR_ELEC_PWR.yaml` is a useful incomplete example: it preserves machine domains `L6` and `L06` and explicitly refuses undocumented joins to logic, analog, digital, chassis, PE or another field return. That is good integration behavior. The same file deliberately leaves exact connector mechanics, contact ratings, footprint, wire/current envelope and placement unresolved, so it is not a capture-ready connection.

## 6. Create connection definitions only after function ownership exists

A board-specific connection definition is a mold for this board, not a reusable electrical function. It should eventually freeze:

- connector manufacturer/family/MPN and footprint;
- every pin disposition and semantic net;
- power and return requirements;
- functional block instance/interface connected to each pin;
- FPGA/logical mapping where applicable;
- board edge/region, orientation and service access;
- machine/harness destination;
- printed connector/pin labels, polarity and silkscreen;
- mating hardware and wire/current envelope;
- verification evidence and unresolved physical-machine facts.

If exact mechanics are unknown, keep the connection definition incomplete. Do not push the uncertainty backward into the reusable block and do not choose a convenient connector merely to make the schematic drawable.

## 7. The unresolved-resource ledger is a deliverable

A board plan with explicit unknowns is stronger than a complete-looking plan built on assumptions.

Minimum ledger columns:

| ID | Requirement/resource | Owner | Current value | Evidence | Blocks capture? | Closure action |
|---|---|---|---|---|---|---|
| U-01 | installed encoder current | machine configuration | unknown | VERIFY_AT_MACHINE | field-supply freeze | measure/identify installed encoder |
| U-02 | encoder cable/end termination | machine configuration | unknown | VERIFY_AT_MACHINE | termination population | inspect cable and remote termination |
| U-03 | FPGA routed fit/timing | board integration | unknown | TEST_OR_SYNTHESIS | FPGA release | local synthesis/P&R/timing when justified |
| U-04 | PVR power connector mechanics | connection definition | unknown | VERIFY_AT_MACHINE | connector capture | inspect retained connector/harness |
| U-05 | L6/L06 board-domain assignment | board integration | unresolved | TBD_ENGINEERING + machine evidence | power routing | establish source/fusing/return evidence |

Unknowns must have an owner and a closure action. `TBD` with no owner is hidden work.

## 8. Cross-machine transfer exercise

Create four requirement sets: a mill, plasma table, robot and press brake. For each, classify ten interfaces into reusable functional blocks versus board-specific connection definitions. Reuse a block only when the electrical contract fits. Machine names, connector positions and harness destinations stay outside reusable circuitry.

Then answer: which resources scale linearly with instance count, which are shared, which depend on machine evidence, and which require executable FPGA evidence?

## 9. OpenPressBrake adversarial exercise

Using the verified encoder contract only, assume a hypothetical board configuration with four differential encoders. This is a resource-planning exercise, not an OpenPressBrake machine claim.

Derive:

- 12 FPGA inputs;
- 0.068 A maximum aggregate receiver demand on 3.3 V from the reusable receiver contract;
- four receiver packages;
- unknown encoder field-supply demand;
- unresolved termination population until cable evidence exists;
- unknown quantitative LUT/FF/BRAM/timing cost until suitable synthesis evidence exists.

Now change the hypothetical board to two encoders. Identify which values recalculate automatically and which machine facts remain unresolved. If the answer requires editing the reusable circuit to change `Y1` into another machine name, the architecture has failed the reuse test.

## 10. Safety boundary

The ordinary controller may receive encoder feedback, monitor independent safety status, inhibit ordinary outputs, and interface to drive enable/STO mechanisms. None of that makes this FPGA/LinuxCNC board the independent personnel-safety authority. The current differential-encoder contract explicitly assigns no personnel-safety credit.

Do not put a safety function into the ordinary-control resource budget and then infer that budgeting it made it safety-rated.

## Lab deliverable

Produce a machine-to-board integration worksheet containing:

1. machine I/O decomposition;
2. selected reusable block and instance for each ordinary-control function;
3. FPGA GPIO/bank/bus/clock resource ledger;
4. power-domain and current-return ledger;
5. required board-specific connection definitions;
6. unresolved-resource ledger;
7. evidence class for every nontrivial value;
8. explicit safety-authority boundary;
9. capture blockers and closure actions.

A passing submission may contain unknowns. It may not contain disguised unknowns.

## Catalog stress-test findings

This lesson confirms two useful catalog properties and one open gap:

- the encoder block's scalable GPIO/current equations are sufficiently explicit for board planning;
- the connection-definition model can preserve machine electrical mapping without contaminating reusable circuitry;
- quantitative FPGA logic/timing resource cost is still not published by the encoder block contract and therefore cannot yet support a complete quantitative FPGA-fit lesson.

The third item remains an engineering-evidence gap, not a number to invent. No OpenPressBrake engineering file is changed by BD03.

## Next lesson

BD04 should return to block engineering and teach startup/default/de-energized behavior, enable authority, watchdog interaction and fault containment using a currently verified ordinary-output block. Candidate output blocks must be opened and audited in current form before being named to students. If no output block is coherent enough, BD04 should become a catalog-defect-and-repair lesson rather than lowering the verification bar.
