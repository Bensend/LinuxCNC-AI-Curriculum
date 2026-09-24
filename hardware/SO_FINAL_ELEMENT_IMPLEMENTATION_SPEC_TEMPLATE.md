# SO — Safety Output / Final-Element Implementation Spec Template

Status: reusable curriculum engineering template; instantiate by final-element class. Not a certified machine design.

## 1. Traceability and physical energy path

Record instance ID, final-element class, selected product, `SRS-*`, required `PHY-*`, `AUTH-*`, `DEP-*`, `ARC-*`, `VAL-*`, `CHG-*`, current UNKNOWNs, commanded safety action and the exact hazardous-energy path affected.

## 2. Class-specific evidence

Choose one or define another justified class:

### A. Relay / contactor
Record coil/output interface, contact arrangement, de-energized behavior, positively guided/mirror feedback if applicable, contact ratings/application constraints, welded/stuck fault handling and EDM semantics.

**Freeze:** `EDM HEALTHY != PHYSICAL SAFE STATE PROVED` and `SAFETY OUTPUT OFF != FINAL ENERGY PATH OPEN PROVED`.

### B. Drive STO
Record exact drive/STO product manual, STO electrical interface, activation/fault behavior, restart behavior and any product-specific diagnostics.

**Freeze:** `STO ACTIVE != MOTOR STANDSTILL PROVED` and `STO ACTIVE != ELECTRICAL ISOLATION`. Analyze coast, gravity and external-force hazards separately.

### C. Monitored valve / dump / exhaust
Record exact valve architecture, pilot/supply dependencies, documented de-energized/fault position, position feedback, trapped volumes/accumulators and physical pressure witness where required.

**Freeze:** `VALVE POSITION EXPECTED != PHYSICAL SAFE STATE PROVED`; `DUMP COMMANDED != PRESSURE SAFE PROVED`.

### D. Brake / load-holding
Record exact brake/restraint mechanism, engage/release energy, gravity/external load, wear/failure feedback, holding assumptions and physical validation method. Electrical command alone does not prove load restraint.

## 3. Authority chain

Complete every stage or mark it UNKNOWN:

`safety demand -> output interface -> final-element actuation -> final-element witness -> physical hazard proposition -> qualified rearm`

For each witness state exactly what it proves and what it does **not** prove.

## 4. Feedback independence / CCF

Trace whether actuation and feedback share supply, connector, pilot pressure, mechanism, sensor target, controller input, level shifter or wiring route. A plausible feedback signal sharing the failed element is not independent proof.

## 5. Power and fault transitions

Analyze output/safety-controller supply loss, final-element power/pilot loss, feedback supply loss, stuck/welded element, open conductor, short where relevant, controller reset, power restoration and repeated demand. Never assume de-energization is safe where gravity, stored pressure or external forces can maintain/create hazardous motion.

## 6. Reset/rearm

Define which feedback/physical propositions must be established before rearm. Feedback restoration alone does not authorize hazardous restart. Ordinary start/cycle remains separate from safety reset unless the machine SRS explicitly establishes otherwise.

## 7. Maintenance / isolation boundary

State whether the final element is a production safety function, an energy-isolation device, or both only where product/application evidence supports it. `PRODUCTION INTERLOCK != MAINTENANCE ENERGY ISOLATION`. Identify lockout/isolation/restraint requirements separately.

## 8. Human factors

Provide clear state/fault diagnostics without requiring safeguard defeat; keyed replacement where practical; controlled access to manual overrides; explicit restoration after override/service; and replacement evidence checks so a nominally similar contactor/drive/valve/brake is not assumed equivalent.

## 9. Validation matrix

Validate normal demand/rearm, each relevant single fault, feedback disagreement, loss/restoration of each shared supply/pilot source, stuck/welded element, service override restoration, and the required physical witness. Where stopping distance/time, pressure, gravity restraint or holding force is part of `PHY-*`, use machine-specific measured/calculated acceptance criteria; do not invent generic values.

## 10. Freeze gate

No schematic freeze until exact product behavior, energy path, feedback proposition, dependency/CCF analysis, power/fault behavior, rearm condition, maintenance boundary and physical validation plan are established. Component PL/SIL claims do not by themselves establish the machine safety function's achieved integrity.