# Final-element witness matrix — contactor, STO, hydraulic, restraint — 2026-09-24

Status: learner-facing architecture comparison. **Not a machine design or validation.** Values such as stopping distance, valve truth table, pressure threshold, safe speed, PL/SIL target and proof-test interval remain selected-machine/design evidence.

## Purpose

A safety controller output is not itself the physical safe state. This matrix teaches learners to follow a safety demand through the selected final element, identify the strongest legitimate feedback proposition, then identify residual hazardous energy and the additional physical witness needed for the machine-level claim.

| Architecture | Safety demand / final element | Available architecture evidence | Narrow proposition legitimately supported | Residual-energy / CCF questions | Maintenance-isolation boundary | Machine-level witness still required |
|---|---|---|---|---|---|---|
| Redundant motor contactors | Safety output removes contactor coil power; selected main poles are expected to open. | Rockwell 450L -> 440C-CR30 -> 100S-C application; 100S-C mechanically linked N.C. auxiliary/mirror-contact relationship. | Selected mechanically linked feedback can support the expected contactor-mechanism/main-contact relationship and inhibit rearm on disagreement. | Motor/load inertia; alternate feed; common coil supply/reference/protection; feedback short/plausible state; bypass; stored electrical/mechanical energy. | Opening safety contactors is not automatically a lockable electrical-isolation procedure or proof of absence of voltage. | Actual stopping/safe position as required; gravity/external-load restraint; absence/control of relevant stored energy and alternate paths. |
| Drive STO | Safety function inhibits torque-generating capability inside selected drive. | Siemens SIMODRIVE documentation: STO prevents torque generation, does not electrically isolate line supply, does not itself establish standstill; external torque may require brakes. | Selected drive safety architecture can support the torque-inhibition proposition when activated/validated as specified. | Coasting; gravity/external torque; brake dependency; shared safety-input supply/reference; drive safety-channel faults; stored DC-link/line energy. | STO is explicitly not electrical isolation from line supply. | Standstill if required; safe position/holding for gravity/external loads; separate electrical isolation for maintenance. |
| Monitored hydraulic valve enable | Safety controller/interface withdraws valve enable; selected valve position transmitters report valve state. | Fiessler AKAS-F + AKFH/AKFR: interface reads hydraulic valve position transmitters, passes linked information to AKAS-F, and valve enables are blocked for protective-field, guard, E-stop, valve-switching or subsystem faults. Bosch Rexroth press-brake servo-pump package independently documents a safety block with end-position-monitored on/off valves. | Selected valve-position feedback can support the proposition that the monitored valve element reached its expected position under the documented architecture. | Pilot/supply dependency; shared valve power; feedback supply/reference; spool/seat/mechanical failure; manifold/internal leakage; alternate hydraulic path; trapped volume/accumulator; gravity-loaded beam; common mechanical path. | Valve enable removed or valve position expected is not a maintenance LOTO proof and does not establish zero pressure in all volumes. | Beam/ram motion/position or restraint as required; pressure/trapped-energy evidence where relevant; physical blocking/restraint for maintenance when required by the risk assessment/procedure. |
| Hydraulic amplifier safe shutdown | Safety-rated amplifier removes/blocks valve drive under its certified function. | HAWE EV2D manufacturer material states safe shutdown of valves is implemented for press-brake safety-relevant processes; HAWE press-brake material separately emphasizes beam holding, switching time and monitored functions. | Only the selected amplifier/valve-drive shutdown proposition supported by its safety manual/certification. | Valve fail state; hydraulic circuit response; pilot pressure; accumulator/trapped pressure; gravity; common supply; downstream valve/mechanical faults. | Electronic safe shutdown is not proof of hydraulic depressurization or mechanical blocking for maintenance. | Selected machine's actual ram/beam safe state, residual pressure/energy, and holding/restraint proposition. |
| Mechanical holding/restraint | Brake, block, pin, prop or other selected mechanism restrains hazardous motion/load. | Architecture-specific product/mechanical evidence required; no generic device is selected here. | Only the selected restraint's engagement/load-path proposition under its rated/validated conditions. | Load capacity, engagement completeness, common structure, release mechanism, gravity/load direction, wear/damage, sensing independence. | A production holding brake may not be an approved maintenance blocking device; maintenance restraint must be selected/procedurally justified. | Physical engagement/load support and absence/control of other hazardous energy appropriate to the task. |

## Hydraulic worked boundary

Fiessler's AKAS-F with AKFH/AKFR is valuable because it exposes a complete *authority chain* without requiring us to invent a press-brake hydraulic circuit. The hydraulic valve position transmitters are read by the interface and linked to the AKAS-F safety controller; AKAS-F checks valve operation and provides safe enable back to the interface, which enables valve controls through safe contacts. Valve release is blocked for protective-field interruption, guard opening, E-stop, valve switching error, interface error or AKAS-F error.

That evidence supports a monitored-valve architecture. It does **not** identify the selected machine's spool truth table, pilot arrangement, cylinder plumbing, accumulator, counterbalance/holding path, leakage behavior, pressure decay or beam response. Those remain `UNKNOWN` until the actual hydraulic design and selected component manuals are available.

Bosch Rexroth independently documents a servo-pump press-brake package whose normal motion comes from a servo motor/four-quadrant axial-piston pump while a separate safety block contains end-position-monitored on/off valves. This is important transfer evidence: **normal motion authority and safety final-element authority need not be the same mechanism.** A servo-pump zero command is therefore not a substitute for the separately engineered safety block.

HAWE provides a third architecture family: EV2D implements safety-relevant valve shutdown for press-brake systems. This demonstrates that safe valve-drive removal can be allocated in a certified amplifier architecture, but it still does not let the curriculum infer downstream hydraulic safe state without the selected valve/circuit evidence.

## Adversarial hydraulic questions

A learner must answer these before crediting a monitored hydraulic output as a machine safe state:

1. Does the feedback report the command, amplifier output, valve actuator/spool/end position, pressure, cylinder/beam position, or actual restraint? These are different propositions.
2. Can a single loss/short of the feedback supply/reference create a plausible valve state?
3. Do two monitored valves share pilot pressure, electrical supply, protection, connector, manifold, mechanical actuator or feedback reference?
4. If the monitored valve reaches its expected position, can trapped volume or an accumulator still drive hazardous motion?
5. If pump/servo command is zero, can gravity, stored pressure or an alternate path move the beam?
6. Does the production safety function stop motion, hold position, dump pressure, isolate supply, or some combination? Do not silently substitute one for another.
7. What proves the required physical proposition during validation: valve position, pressure, beam motion/position, a mechanical restraint, or a combination?
8. What additional isolation/blocking is required before a person enters a maintenance danger zone?

## Curriculum freezes

- **VALVE POSITION EXPECTED != RAM/BEAM SAFE STATE PROVED**.
- **SERVO PUMP ZERO COMMAND != HYDRAULIC SAFETY FUNCTION PROVED**.
- **SUPPLY ISOLATED != DOWNSTREAM PRESSURE EXHAUSTED**.
- **DUMP COMMANDED != PRESSURE SAFE PROVED**.
- **NORMAL MOTION AUTHORITY != SAFETY FINAL-ELEMENT AUTHORITY**.
- **FINAL-ELEMENT ARCHITECTURE DETERMINES THE LEGITIMATE WITNESS**.

## Template consequence

Every `SO` / selected-block qualification should carry, explicitly and separately:

1. commanded safety action;
2. physical final element;
3. feedback sensor and the exact target it observes;
4. proposition the feedback can legitimately prove;
5. shared dependencies/CCFs that can make the feedback plausible but wrong;
6. residual hazardous-energy paths after the final element reaches its expected state;
7. machine-level physical witness required for validation;
8. maintenance-isolation/blocking boundary.

If any of these are absent, the output block is not ready for schematic freeze or machine-safety credit.

## Sources

- Rockwell Automation, SAFETY-AT164A-EN-P; 100-TD013; 100S-CT015A-EN-E — contactor architecture and mechanically linked/mirror feedback.
- Siemens, SIMODRIVE 611 Configuration Manual PJU 02/2012 — STO torque-inhibition, standstill/external-torque and electrical-isolation boundaries.
- Fiessler Elektronik, AKAS press-brake protection / AKFH-R system description — hydraulic valve-position transmitters, safety-controller checking and safe valve-enable withdrawal.
- Bosch Rexroth, *System solutions for press brakes* — servo-pump normal-motion package with separate safety block using end-position-monitored on/off valves.
- HAWE Hydraulik, EV2D press-brake safety material and press-brake system overview — safety-relevant valve shutdown and beam-holding/function-monitoring context.

Claims above are `DOC-CONFIRMED` where tied to the named manufacturer material; selected-machine behavior not stated by those sources is `UNKNOWN`. No runtime/test evidence was generated.