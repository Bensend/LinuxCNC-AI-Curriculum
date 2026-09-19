# Pneumatic safe-exhaust, stored-pressure, and restart-authority study

Date: 2026-09-18
Lane: independent safety curriculum B

## Purpose and parallel-work boundary

Study a safety-energy path not being advanced by the primary hydraulic press-brake lane: pneumatic supply isolation, redundant safe exhaust, valve-state/pressure feedback, stored downstream pressure, fault retention, and deliberate restart authority.

This is a transferable machine-safety architecture study. It does **not** assert that OpenPressBrake presently has a pneumatic hazardous-energy function or that a pneumatic safe-exhaust valve is required on that machine.

## Evidence vocabulary

- **SOURCE-CONFIRMED** — directly stated by a manufacturer/public source reviewed for this study.
- **DOC-CONFIRMED** — confirmed in durable manufacturer documentation or product documentation.
- **TEST-CONFIRMED** — demonstrated by a controlled test. None in this study.
- **COMMUNITY-REPORTED** — reported by community material. None relied upon here.
- **INFERENCE** — engineering conclusion drawn from confirmed evidence and kept visibly separate.
- **UNKNOWN** — requires machine-specific design evidence, measurement, risk assessment, or commissioning.

## Durable architecture freeze

**PNEUMATIC SAFETY OUTPUT OFF != SUPPLY ISOLATED != SAFE-EXHAUST ELEMENTS IN EXPECTED STATE != DOWNSTREAM PRESSURE EXHAUSTED != TRAPPED/GRAVITY ENERGY CONTROLLED != PERSONNEL ACCESS SAFE.**

For restart:

**AIR SUPPLY AVAILABLE != SAFE-EXHAUST VALVE READY != DOWNSTREAM PRESSURE RESTORED != SAFETY REARMED != FRESH ORDINARY START/JOG/CYCLE AUTHORITY.**

For diagnostics:

**REDUNDANT VALVES PRESENT != BOTH ELEMENTS PROVED != PRESSURE STATE PROVED != PHYSICAL ACTUATOR HAZARD ABSENT.**

## Professional implementation evidence

### ROSS Controls DM2C redundant safe-exhaust valve

**SOURCE-CONFIRMED.** ROSS describes the DM2C as two identical valve elements with internal dynamic monitoring. Asynchronous element movement is detected and the valve latches in a safe condition. ROSS also distinguishes the valve's deliberate reset from ordinary supply cycling: removing and reapplying supply does not clear the latched fault; an explicit reset is required.

**SOURCE-CONFIRMED.** ROSS exposes a pressure switch with NO and NC contacts as status feedback indicating lockout versus ready-to-run condition. This is useful curriculum evidence because command state, internal valve-element monitoring, and a pneumatic pressure/status witness are separate claims.

Sources:
- https://www.rosscontrols.com/en/series/1295-dmc2-series-double-valve
- https://www.rosscontrols.com/en/documents/339/dm2-series-c-double-valves

The product page publishes Category/PL/SIL claims for the product when integrated as specified. Those claims are **not** transferred to OpenPressBrake or to any generic learner design.

### ROSS M35 / RSe external-monitoring architecture

**SOURCE-CONFIRMED.** ROSS's M35 safe-exhaust architecture uses two valve elements with individual pressure sensors and external safety-system monitoring. Its stated function is to supply air during operation and, when commanded safe, shut off supply and exhaust downstream pneumatic energy.

**SOURCE-CONFIRMED.** ROSS's RSe architecture uses two valve elements with individual position sensors. Both solenoids must be operated for the supply state; the individual sensors report actual spool position to an external safety control system.

Sources:
- https://www.rosscontrols.com/en/series/1296-m35-series-double-valve
- https://www.rosscontrols.com/en/series/1297-rse-series-double-valve

**INFERENCE.** These architectures make a useful teaching comparison: internal dynamic monitoring, external element-position monitoring, and downstream pressure monitoring are different evidence paths. A design must state which physical claim each witness supports instead of collapsing them into one `AIR_SAFE` bit.

### SMC VP/VG residual-pressure release architecture

**SOURCE-CONFIRMED.** SMC documents VP/VG residual-pressure release valves with main-valve position detection. It explicitly describes inconsistency detection between input signal and valve operation and shows redundant use where one valve can release residual pressure if the other fails to operate.

**SOURCE-CONFIRMED.** SMC states that the product is a component of a safety system and does not by itself guarantee safety of the complete machine.

Source:
- https://www.smcworld.com/newproducts/en-sg/vpvg/

That last statement is an important curriculum boundary: a certified/monitored pneumatic component does not prove the whole hazardous-energy path is safe.

## Energy-path decomposition

A learner should trace a pneumatic safety function through at least these distinct nodes:

1. protective-device / E-stop / safety-function demand;
2. independent safety evaluator;
3. electrical command to each safe-exhaust element;
4. actual position/state witness for each monitored element, where provided;
5. supply path physically blocked;
6. downstream exhaust path physically opened;
7. downstream pressure witness, where provided;
8. trapped branches, check valves, accumulators, pilot circuits, cylinders and other volumes that may retain energy;
9. gravity or mechanically stored energy that can remain hazardous even after air exhaust;
10. physical actuator/hazard state;
11. fault latch / restart inhibit;
12. deliberate repair, reset and safety rearm;
13. separate fresh LinuxCNC/HAL production intent.

The chain must stop wherever evidence stops. Valve-position agreement is not pressure proof. Pressure decay at one sensor is not proof that every isolated branch is depressurized. Depressurization is not proof that a raised or spring-loaded mechanism cannot move.

## Failure-path worksheet

Challenge the implementation without inventing timing or pressure thresholds:

| Challenge | Required architectural question |
|---|---|
| One exhaust element sticks in the supply state | Does redundancy preserve the required safe function, and is the failed element diagnosed rather than masked? |
| One position/pressure sensor remains falsely healthy | What independent evidence remains, and can the latent fault survive the next demand? |
| Elements move asynchronously | Is disagreement latched/inhibited, or can ordinary control continue? |
| Safety command drops but downstream pressure remains | Which witness detects failure to exhaust, and what authority is removed? |
| Main header exhausts but a check-valved branch stays charged | Is that branch part of the hazard analysis and separately discharged/restrained? |
| Cylinder is depressurized while a vertical load remains elevated | What non-pneumatic retaining/blocking function controls gravity? |
| Air or electrical power is cycled after a diagnosed valve fault | Does cycling improperly erase fault memory or create automatic restart? |
| Valve is repaired/replaced | What functional proof must be repeated before safety rearm? |
| Pressure is restored while LinuxCNC START/JOG/CYCLE remains asserted | Can stale ordinary intent become motion, or is fresh intent required? |
| Exhaust silencer/path is obstructed | Is the required exhaust function still physically achieved and detectable? |

## LinuxCNC/OpenPressBrake boundary

Ordinary LinuxCNC/HAL/FPGA logic may display pneumatic diagnostics, inhibit ordinary motion redundantly, and consume a safety-system permissive. It must not become the sole personnel-safety authority that decides a hazardous pneumatic circuit is exhausted, a failed safety valve is repaired, or access is safe.

A practical architecture should expose diagnostic truth rather than one optimistic permissive. Useful HMI states include `safety demand active`, `valve element disagreement`, `pressure not proved safe`, `fault latched`, and `safety rearm required`, while keeping the actual safety decision outside ordinary LinuxCNC control.

## What remains UNKNOWN

Do not infer any of the following for OpenPressBrake or another machine from this study:

- whether hazardous pneumatic energy exists;
- required safe-exhaust topology or number of elements;
- allowable residual pressure;
- exhaust or pressurization time;
- required pressure-sensor location or threshold;
- cylinder/load behavior after exhaust;
- gravity restraint or mechanical blocking requirements;
- PL/SIL/category/DC/CCF requirements;
- required proof-test interval;
- reset/rearm sequence;
- whether soft-start is safety-related;
- whether a specific machine may safely restore pressure before personnel clear.

These require the actual machine hazard analysis, circuit, component documentation and commissioning evidence.

## Commissioning / validation plan

Question-driven physical commissioning should verify, where applicable:

- each safe-exhaust element can be challenged independently without a healthy companion masking its diagnostic;
- commanded safe state is matched by the intended valve-state witness;
- downstream pressure actually follows the intended safe reaction at the relevant hazard zone;
- trapped branches and pilot volumes are identified rather than assumed exhausted;
- loss/restoration of air and electrical power cannot silently clear a retained safety fault where fault retention is required;
- reset does not itself start hazardous motion;
- re-pressurization does not convert stale LinuxCNC/HAL intent into a new cycle;
- any gravity/mechanical hazard has a separate physical retaining/isolation proof.

No executable simulation is justified for these documentation-level questions. The decisive unresolved facts are physical circuit topology and machine commissioning evidence, not software compute.

## Precise next-work checkpoint

Find a complete OEM or professional machine implementation exposing:

`protective-device demand -> independent safety evaluator -> redundant pneumatic safe-exhaust elements -> individual element/pressure witness -> downstream physical pressure decay -> trapped-energy/gravity disposition -> disagreement/failure latch -> repair/replacement -> required functional re-proof -> deliberate safety reset/rearm -> separate fresh ordinary START`.

Prefer a machine with both a pneumatic actuator hazard and a gravity/mechanical consequence so the evidence explicitly demonstrates why `air exhausted` is not synonymous with `hazard absent`. Keep this lane independent of the primary hydraulic press-brake valve-disagreement/re-proof package.