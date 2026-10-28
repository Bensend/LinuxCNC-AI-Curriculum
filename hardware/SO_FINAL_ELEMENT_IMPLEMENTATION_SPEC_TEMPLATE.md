# SO — Safety Output / Final-Element Implementation Spec Template

Status: reusable curriculum engineering template; instantiate by final-element class. Not a certified machine design.

## 1. Traceability and physical energy path

Record instance ID, final-element class, selected product, `SRS-*`, required `PHY-*`, `AUTH-*`, `DEP-*`, `ARC-*`, `VAL-*`, `CHG-*`, current UNKNOWNs, commanded safety action and the exact hazardous-energy path affected.

### Mandatory final-element witness record

Keep these eight fields together as one auditable record; do not distribute them only across prose:

| Field | Required record | Package linkage |
|---|---|---|
| commanded safety action | Exact safety action demanded at this output boundary. | SRS, AUTH |
| physical final element | Exact contactor, drive safety function, valve/dump element, brake/restraint or other physical element affected. | AUTH, ARC |
| feedback target | Sensor/feedback and the exact physical/electrical target it observes. | PHY, VAL |
| legitimate proposition | What that feedback can prove, and explicit non-claims. | PHY, SRS, VAL |
| shared dependencies / CCF | Power, reference, pilot/supply, connector, mechanism, sensor target, controller resource and other common paths capable of producing plausible-but-wrong evidence. | DEP, ARC, VAL |
| residual hazardous energy | Energy/motion/pressure/gravity/stored-energy/alternate paths that can remain after the final element reaches its expected state. | PHY, SRS, ARC |
| machine-level physical witness | Independent physical evidence required to validate the machine-level proposition. | PHY, VAL |
| maintenance isolation / blocking | Boundary between the production safety function and lockable isolation, depressurization, blocking or restraint required for maintenance. | SRS, AUTH, ARC, VAL |

A material change to any field SHALL create/review a `CHG-*` record and mark affected downstream evidence `STALE` until re-verified/revalidated.

## 2. Class-specific evidence

Choose one or define another justified class.

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

Additional freezes:
- `MATCHING COMMAND/FEEDBACK != INDEPENDENT PHYSICAL WITNESS`.
- `FINAL-ELEMENT FEEDBACK HEALTHY != COMMON DEPENDENCY ABSENT`.
- `POWER RESTORED != REARM ELIGIBLE`.

## 4. Feedback independence / CCF

Trace whether actuation and feedback share supply, connector, pilot pressure, mechanism, sensor target, controller input, level shifter or wiring route. A plausible feedback signal sharing the failed element is not independent proof. Explicitly test whether a single common dependency can make both command and feedback appear mutually consistent while the physical safe-state proposition is false.

## 5. Power and fault transitions

Analyze output/safety-controller supply loss, final-element power/pilot loss, feedback supply loss, stuck/welded element, open conductor, short where relevant, controller reset, power restoration and repeated demand. Never assume de-energization is safe where gravity, stored pressure or external forces can maintain/create hazardous motion. Restoration of electrical or pilot power does not itself establish rearm eligibility.

## 6. Reset/rearm

Define which feedback/physical propositions must be established before rearm. Feedback restoration alone does not authorize hazardous restart. Ordinary start/cycle remains separate from safety reset unless the machine SRS explicitly establishes otherwise.

## 7. Maintenance / isolation boundary

State whether the final element is a production safety function, an energy-isolation device, or both only where product/application evidence supports it. `PRODUCTION INTERLOCK != MAINTENANCE ENERGY ISOLATION`. Identify lockout/isolation/restraint requirements separately.

## 8. Human factors

Provide clear state/fault diagnostics without requiring safeguard defeat; keyed replacement where practical; controlled access to manual overrides; explicit restoration after override/service; and replacement evidence checks so a nominally similar contactor/drive/valve/brake is not assumed equivalent.

## 9. Validation matrix

Validate normal demand/rearm, each relevant single fault, feedback disagreement, loss/restoration of each shared supply/pilot source, stuck/welded element, service override restoration, and the required physical witness. Include a plausible-but-wrong feedback test and a common-dependency test whenever physically credible. Where stopping distance/time, pressure, gravity restraint or holding force is part of `PHY-*`, use machine-specific measured/calculated acceptance criteria; do not invent generic values.

### Required contradiction case

Include at least one case in which final-element feedback is electrically healthy/expected while the independent machine-level physical witness required by `PHY-*` contradicts the claimed safe state.

Expected reasoning:
1. retain credit only for the narrow proposition actually supported by the final-element feedback;
2. mark the broader `PHY-*` proposition **NOT ESTABLISHED**;
3. do not permit rearm/release from controller status alone;
4. open/retain the discrepancy through the applicable `VAL-*`, `DEP-*`, `UNK-*` and, after a material change, `CHG-*` records;
5. keep people outside the hazard during experimental diagnosis when the minimum safe-to-operate proposition is not established.

For hydraulics, a valve-position indication may support a valve-position proposition; it does not by itself prove pressure decay, ram/beam standstill or restraint. Exact pressure/motion acceptance criteria remain machine-specific or UNKNOWN until justified.

## 10. Freeze gate

No schematic freeze until exact product behavior, energy path, feedback proposition, dependency/CCF analysis, power/fault behavior, rearm condition, maintenance boundary and physical validation plan are established. Before schematic capture, the instance SHALL satisfy the repository minimum selected-block evidence package: exact product/revision, traceability allocation, electrical interface evidence, state/restart semantics, energy-path definition, witness proposition, dependency/CCF record, failure-state table, human/service boundary, validation plan, integrity-claim boundary and disposition of every remaining UNKNOWN. Any UNKNOWN capable of changing interface compatibility, fail-safe state, diagnostic behavior, reset/rearm behavior, energy-path authority or a safety-critical dependency is schematic-blocking.

Component PL/SIL claims do not by themselves establish the machine safety function's achieved integrity. Passing this gate authorizes engineering capture only; it does not authorize machine operation or establish machine-level validation.

## 2026-10-28 SO relay/contactor exact-mirror-variant requirement (MIRROR-01 service addendum)
The [original Schneider/Rockwell/Omron accessory-variant audit](../research/4400_MIRROR_01_ROCKWELL_SUVA_AND_SCHNEIDER_ACCESSORY_SOURCE_DEPTH_ADDENDUM_2026-10-28.md) adds a mandatory **selected base contactor SKU + auxiliary SKU + mounting/retention + manufacturer's mirror-contact declaration** to class A. Do not equate an arbitrary NC terminal, generic 'safety contactor' branding, red housing or successful normal-cycle continuity with IEC 60947-4-1 Annex F mirror performance. Distinguish mirror NC (main NO cannot be closed simultaneously) from the stronger mechanically linked NO/NC relationship where actually certified. Record whether the NC is integrated, factory-retained front, or conditional side-mounted; inspect correct mounting/function per selected OEM and approved safe validation. An auxiliary-block substitution, relocation, loosened retention or changed feedback terminal map triggers CHG and makes prior affected EDM evidence STALE. Correct EDM remains narrower than actual energy interruption, hydraulic gravity holding and deliberate restart. Exact PL/DC/B10d and physical stop/hold remain UNKNOWN until selected design/evidence; no machine operation authorized.

**MIRROR-01 service addendum source-depth refinement (2026-10-28):** separately record (a) auxiliary **terminal numbering** (Schneider LADN11 versus LADN11P), (b) **auxiliary NO/NC make-before-break sequence** where relevant (LADC22), (c) **main-pole-to-NC mirror declaration**, and (d) allowed **front/side mounting/retention** for the exact coil/contact assembly. These are not interchangeable properties. A wiring diagram copied by terminal number or an accessory swapped because it physically fits can invalidate EDM even when continuity appears normal. See [same source audit](../research/4400_MIRROR_01_ROCKWELL_SUVA_AND_SCHNEIDER_ACCESSORY_SOURCE_DEPTH_ADDENDUM_2026-10-28.md); no PL/DC/timing inferred.

**2026-10-28 COORD-01 short-circuit fault envelope:** For a relay/contactor final element, record its selected **SCPD + contactor + overload/drive combination** and applicable Type I/II coordination conditions separately from **panel SCCR** and **safety-function integrity**. Manufacturer Type II permits limited contact welding and is **not** proof the contactor is unwelded or the machine safe after a real fault. A breaker/fuse/contactor substitution or post-fault repair triggers CHG/STALE; qualified inspection/validation and physical energy-path witness are required. [Original OEM audit](../research/4400_COORD_01_TYPE1_TYPE2_SHORT_CIRCUIT_COORDINATION_CONTACT_WELD_POST_FAULT_REARM_SOURCE_AUDIT_2026-10-28.md). No universal fault kA, PL/DC or post-fault acceptance values inferred.
