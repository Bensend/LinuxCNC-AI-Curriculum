# Separate 24 V control-supply backfeed / isolation boundary study — Lane B — 2026-09-18

## Scope and parallel-work selection

This Lane-B study is intentionally independent of the primary lane's current professional press reset/restart/EDM and hydraulic final-element work. It addresses a different boundary: whether an apparently de-energized safety/control domain can remain powered or asserted through another 24 V source, signal path, output, interposing device, or common return.

No OpenPressBrake wiring topology is assumed. This is an architecture and verification study, not a claim about the present machine.

## Evidence labels

- **SOURCE-CONFIRMED** — directly inspectable primary source/source code.
- **DOC-CONFIRMED** — authoritative manufacturer documentation.
- **TEST-CONFIRMED** — observed by a controlled test with recorded setup/result.
- **COMMUNITY-REPORTED** — community report not independently reproduced.
- **INFERENCE** — engineering conclusion derived from evidence; not itself directly stated by a source.
- **UNKNOWN** — requires the actual machine/design, measurement, or additional evidence.

## Authoritative evidence

### Pilz PNOZmulti external supply boundary

**DOC-CONFIRMED:** Pilz PNOZmulti installation documentation requires safe electrical isolation for the external power supply that generates the control-system supply voltage. This is direct evidence that the 24 V supply boundary is part of the safety architecture and cannot be treated as an irrelevant convenience supply.

Source: Pilz, *PNOZmulti Installation Manual*, 1002265-EN-02, current public PDF retrieved 2026-09-18.
https://www.pilz.com/download/open/PNOZmulti_Inst_Manual_1002265-EN-02.pdf

### Pilz PNOZpower — direct safe switching of supply voltages

**DOC-CONFIRMED:** Pilz describes PNOZpower modules as able to shut down supply voltages and motors directly and safely, including supply voltages on valves and contactors. This establishes that removing a control/actuator supply can itself be an intentional safety final-element strategy when the selected architecture and devices support it.

Source: Pilz, *PNOZpower safety relays* product/application page, retrieved 2026-09-18.
https://www.pilz.com/en-US/products/relay-modules/safety-relays-protection-relays/pnozpower-safety-relays

### Rockwell Guardmaster — safety device supply and feedback are distinct functions

**DOC-CONFIRMED:** Rockwell's Guardmaster MSR138DP is a 24 V AC/DC safety relay with a feedback circuit and start input. The documented separation between device supply, safety outputs, feedback and start supports treating each conductor/path according to its actual function rather than collapsing all 24 V wiring into one logical state.

Source: Rockwell Automation, Guardmaster MSR138DP 440R-M23143S product data, retrieved 2026-09-18.
https://www.rockwellautomation.com/en-us/products/details.440R-M23143S.html

## Frozen architecture distinctions

**24 V SUPPLY A OFF != SAFETY DOMAIN DE-ENERGIZED.**

**SAFETY OUTPUT COMMAND OFF != OUTPUT NODE PROVEN UNPOWERED.**

**CONTACTOR/VALVE COIL COMMAND OFF != COIL TERMINALS PROVEN UNENERGIZED.**

**ONE SUPPLY DISCONNECTED != ALL SOURCES/BACKFEEDS REMOVED.**

**COMMON 0 V != AUTOMATICALLY BENIGN COMMON CAUSE.**

**HMI/LINUXCNC REPORTS OFF != PHYSICAL ABSENCE OF CONTROL VOLTAGE.**

## Failure-path analysis

| Fault / condition | Misleading observation | Required question / proof | Status |
|---|---|---|---|
| Safety 24 V supply switched off but another 24 V source is tied through a signal/output | PSU-A indicator is dark | Can any alternate source energize the safety/output node? | INFERENCE; machine topology UNKNOWN |
| Ordinary FPGA/PLC sourcing output connected into a safety-domain node | Safety controller commands OFF | Is ordinary I/O electrically capable of sourcing safety authority? | INFERENCE; OpenPressBrake wiring UNKNOWN |
| Two supplies share a load or distribution point without defined isolation | One disconnect is open | Is reverse current blocked under all relevant states/faults? | UNKNOWN until schematic/component data |
| Interposing relay/contactor coil has an alternate feed | Safety output is OFF | Measure/trace both coil terminals and all feeds; does a second path sustain coil current? | INFERENCE |
| Suppressor/indicator/interface module bridges domains | Main feed removed | Does the accessory create a reverse or sneak path? | UNKNOWN until component topology inspected |
| Common return opens or shifts | +24 V appears normal | Can return-path faults create unintended current through signal commons/shields/interfaces? | INFERENCE |
| USB/service/programming connection bridges control domains | Machine supply isolated | Does connected service equipment provide a powered reference/path? | UNKNOWN; must inspect interfaces |
| Field device has separate logic and actuator supplies | actuator supply OFF | Can logic-side output/backfeed keep an enable input asserted? | UNKNOWN; device-specific |
| Safety PLC is alive from UPS/aux supply while final-element supply is removed | safety CPU healthy | Is CPU health being mistaken for final-element power state? | INFERENCE |
| LinuxCNC/HAL bit says output=0 | software status looks safe | Is status a command echo or independent physical voltage/current witness? | INFERENCE |

## Practical design rule for OpenPressBrake

**INFERENCE:** Any conductor or interface that crosses from ordinary LinuxCNC/FPGA/control electronics into a personnel-safety authority path must be reviewed not only for logical direction but for **electrical power direction under normal, power-down, reset, fault and service conditions**.

A signal that is logically an input can still participate in a current path through protection structures, pull-ups, interface power, relay coils, indicator circuits, USB/service connections, or common returns. Therefore a schematic review must ask, for every safety-relevant node:

1. What sources can put energy on this node?
2. What happens when each source is individually absent?
3. What happens when one source remains while another domain is unpowered?
4. Is reverse current explicitly blocked or merely assumed absent?
5. Does any ordinary controller output have a path that can create personnel-safety authority?
6. What independent witness proves the final element actually reached the demanded state?

## Separation from LinuxCNC / FPGA authority

**INFERENCE:** LinuxCNC/HAL and the ordinary FPGA may receive diagnostic copies of safety state and may be required to remove their own ordinary commands. They must not become the sole element preventing a backfed safety final element from energizing. The independent safety path must remain safe when the ordinary controller is powered, unpowered, rebooting, misconfigured, or connected for service.

A useful review invariant is:

**ORDINARY CONTROL POWER PRESENT + SAFETY DOMAIN POWER REMOVED -> NO ORDINARY PATH MAY RECREATE SAFETY OUTPUT AUTHORITY.**

This is a design/validation objective, not a claim that any specific performance level or category is achieved.

## Commissioning / fault-injection worksheet

Do not perform these tests on an exposed hazardous machine. First establish a safe test condition with hazardous energy removed, blocked/restrained, or otherwise controlled.

For the actual completed design, create a source/path matrix for every safety-relevant 24 V node. With hazardous outputs made physically harmless, question-driven tests should include where applicable:

- remove ordinary-control 24 V while retaining safety 24 V;
- remove safety 24 V while retaining ordinary-control 24 V;
- remove field-actuator 24 V while retaining logic supplies;
- remove logic supply while retaining field-actuator supply;
- connect/disconnect service USB/Ethernet/programming equipment in the defined safe test state;
- verify voltage at both sides of isolation elements, not only PSU LEDs;
- verify safety outputs and final-element coils cannot remain energized from alternate paths;
- verify recovery after restoring supplies requires the intended reset/rearm/start sequence rather than replaying retained ordinary commands.

Record each actual observation as **TEST-CONFIRMED** only after the test setup, measurement point, instrument, expected result, actual result and recovery behavior are captured.

## What remains UNKNOWN for OpenPressBrake

- number and identity of 24 V supplies;
- whether any supply is UPS-backed or separately switched;
- exact safety-controller and safety-I/O family;
- ordinary FPGA/MCU I/O isolation topology;
- relay/contactor/valve coil feeds and suppressors;
- drive STO input supply/reference arrangement;
- shared 0 V, shield and PE topology;
- service-port isolation and any phantom/backfeed behavior;
- field-device dual-supply behavior;
- actual isolation components and reverse-current specifications;
- PL/SIL/category/DC claims;
- hydraulic/mechanical state resulting from any electrical test.

No values for those items are inferred here.

## Next independent evidence work

Highest-value continuation: obtain a complete professional schematic/manual example that exposes **separate safety/control/field 24 V supplies -> isolation/coupling element -> safety output -> final-element coil/STO -> feedback -> power-down/restart behavior**, then trace whether alternate supplies can cross the intended isolation boundary.

If the primary lane begins that same package first, rotate Lane B to gravity-axis brake/load-retention sequencing or service/bypass key-transfer authority rather than duplicating it.

## Compute

No executable verification was needed for this source/documentation study. No GitHub-hosted runner and no self-hosted runner compute was consumed.