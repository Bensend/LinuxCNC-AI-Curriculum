# Open-Source Surge-Protected Safety Hardware — Initial Survey

## Executive finding

A direct open-source equivalent of the proposed three independently actuated series relays + per-node voltage sensing + hardwired E-stop + automatic proof testing has not yet been found. However, several open projects contain important pieces of the architecture, including mechanical E-stop relays, TVS suppression, RC snubbers, flyback networks, watchdogs, opto-isolation, and deliberate separation of safety authority from diagnostics.

The strongest open-source hardware precedent found so far is `OUXT-Polaris/estop-driver`, which is a KiCad emergency-stop board for an autonomous mobile robot using mechanical relays. Its power-relay schematic includes an Omron G7EB relay and a TVS diode in the relay-control circuitry.

## Projects to study

### 1. OUXT-Polaris / estop-driver

Repository: https://github.com/OUXT-Polaris/estop-driver

Why it matters:
- explicitly designed to provide an emergency-stop function using mechanical relays;
- full KiCad schematic and PCB files are open;
- power-relay schematic uses an Omron G7EB relay;
- TVS protection is present in the power-relay circuit;
- additional kill-switch receiver schematic also contains TVS protection.

Research task:
- reconstruct the relay driver and suppression network from the KiCad schematic;
- identify whether the TVS clamps the relay coil, driver node, supply, or multiple locations;
- determine the relay load, contact current, and whether downstream inductive-load suppression is included;
- compare against the proposed three-series-relay architecture.

### 2. openAMRobot carrier-board safety architecture

Project discussion: https://github.com/orgs/openAMRobot/discussions/9

Relevant design choices:
- flyback/snubber network across each relay coil;
- relay contact ratings selected with at least 1.5x margin over maximum rail current/voltage;
- power-monitoring MCU may read E-stop and safety-edge diagnostic contacts but has no electrical or firmware path able to actuate the E-stop relays;
- diagnostics and status indication are deliberately kept outside the E-stop authority path.

Research value:
This is a good precedent for separating supervisory intelligence from final hardware safety authority, similar to using an FPGA for diagnostics while a hardwired E-stop physically removes relay-coil power.

### 3. HumayunNaveedKhan / Latching-Relay-HV-System

Repository: https://github.com/HumayunNaveedKhan/Latching-Relay-HV-System

This is especially valuable because it documents a real failure:
- a hobby relay switching a large contactor coil welded due to coil inrush/arcing;
- the final deployed system replaced the contact relay with an SSR;
- an RC snubber (approximately 0.1 uF X2 + 100 ohm) is connected directly across the contactor coil;
- optocouplers isolate field signals;
- separate power domains are used;
- watchdog and brownout/EMI diagnostics are implemented;
- the author reports deployed/load-tested circuits controlling a 500 A contactor.

Research value:
This provides direct field evidence that coil suppression is not theoretical: the unsuppressed switching element welded, while suppression and a non-contact switching element were adopted to solve the problem.

### 4. geezacoleman / owl-driver-board

Repository: https://github.com/geezacoleman/owl-driver-board

Not a safety relay, but a useful open industrial/noisy-load protection reference:
- open schematics and PCB files;
- TVS + Schottky protection against inductive spikes, noise, reverse polarity, and over-voltage;
- self-resetting polyfuses / blade fuses;
- global E-stop / output-enable input;
- designed for relays, solenoids, motors, and other noisy 7–26 V loads.

Research value:
Good source for inexpensive 24 V protection blocks that can be reused around the safety-relay design.

### 5. oscardvs / haller_ws

Repository: https://github.com/oscardvs/haller_ws

Relevant safety pattern:
- mushroom E-stop breaks relay-coil power rather than carrying the high-current arm load;
- TVS protection is included on the switched servo power rail;
- commissioning procedure explicitly tests the E-stop and then physically pulls the relay coil wire to confirm that loss of coil power produces the same safe shutdown.

Research value:
A useful low-cost example of de-energize-to-safe operation and testing the broken-wire failure directly.

### 6. VectorRobotics 24 V supervisory board

Project page: https://mrsdprojects.ri.cmu.edu/2026teama/system-implementation-pcb-implementation/

Relevant details:
- 24 V power-distribution / supervisory board;
- relay controlled by MOSFET driver;
- flyback diode across relay coil;
- emergency-stop input and filtered sensing.

Limitation:
The E-stop is read by an ESP32 rather than mechanically removing relay-coil power, so this is primarily useful as a protected relay-driver reference, not as the final safety architecture.

## Important distinction: protecting the relay coil is not the same as protecting the relay contacts

There are two separate inductive events:

1. **The small relay's own coil.**
   Suppression here protects the FPGA/PIC/MOSFET driver and reduces EMI.

2. **The inductive load switched by the relay contact** — for example a contactor coil, hydraulic-solenoid enable coil, or other relay coil.
   Suppression must be placed at or near this load to reduce the opening arc that damages/welds the safety relay contact.

A design that includes only a flyback diode on K1/K2/K3's own coils does not necessarily protect K1/K2/K3's contacts from the inductive load they switch.

## Manufacturer guidance that should shape the open design

Omron and Panasonic relay guidance agree on several useful rules:

- DC inductive loads: a flyback diode gives strong arc suppression but slows load release.
- If release speed matters, a diode + Zener or TVS-style clamp can allow a higher turn-off voltage and faster current decay while still limiting the transient.
- AC inductive loads: RC snubber or varistor/MOV is generally appropriate.
- protective components should be located close to the inductive load; long wiring reduces effectiveness.
- some poorly arranged capacitor-only contact-protection circuits can create large closing current and actually increase contact-welding risk.

This matters for E-stop applications because a plain diode across a contactor or valve coil may lengthen dropout time. A diode + Zener / TVS clamp is therefore especially worth studying for 24 VDC safety-enable loads.

## Welding prevention is two problems, not one

### Opening-arc welding / erosion

Reduce by:
- diode, diode+Zener, TVS, MOV, or RC suppression selected for the load;
- placing suppression physically close to the inductive load;
- keeping contact current well within the relay's inductive-load rating;
- minimizing wiring inductance.

### Closing / inrush welding

Surge suppression on turn-off does not solve high make-current welding.

Address separately with:
- relay contacts rated for the actual inrush current;
- current limiting or precharge for capacitive loads;
- using the PCB safety relays only to switch low-current contactor/STO/valve-enable circuits rather than the machine's main load;
- staggered/controlled actuation where appropriate;
- fusing to prevent fault current far beyond the relay rating.

## Proposed protection stack for the three-relay reference architecture

For a 24 VDC permission chain switching a downstream contactor/valve-enable coil:

- K1, K2, K3 contacts in series;
- individually controlled relay-coil drivers;
- local suppression on every K1/K2/K3 coil for driver/EMI protection;
- direct A/B/C voltage sensing between contacts;
- hardwired NC E-stop removes common relay-coil supply;
- external watchdog can also remove relay-coil supply;
- downstream inductive load has its own suppression located close to the load;
- prefer diode+Zener/TVS clamp when rapid dropout is important, rather than an ordinary diode selected only for minimum spike voltage;
- optional downstream state feedback from contactor/STO/valve where available;
- fuse/limit the safety-chain supply so a wiring short cannot generate destructive contact current;
- choose the contact suppression only after measuring or obtaining coil current, inductance/inrush, and required release time.

## Next research tasks

1. Fully reconstruct `OUXT-Polaris/estop-driver` and identify every TVS and relay-driver function.
2. Find additional open robot/industrial safety boards using redundant relays rather than a single relay.
3. Search EV/BMS/open-inverter projects for proven contactor-coil clamp and precharge circuits.
4. Compare flyback diode, diode+Zener, TVS, MOV, and RC suppression for representative 24 V contactor and hydraulic-solenoid coils.
5. Measure the effect of each clamp topology on contactor/relay release time, because overly aggressive suppression can slow an emergency stop.
6. Add contact-welding fault injection to the three-relay proof-test architecture.
7. Separate the BOM into `contact protection`, `driver protection`, `supply protection`, and `diagnostic sensing` so each added dollar has an explicit risk-reduction purpose.
