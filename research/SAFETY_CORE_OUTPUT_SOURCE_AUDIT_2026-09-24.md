# Independent safety core + safety-output source audit — 2026-09-24

Status: authoritative-source curriculum audit; not a machine-specific certified design.

Session start: `2026-09-24T08:33:07Z`.

## Question

What reset/rearm, external-device-monitoring, drive STO and output-witness semantics can be frozen for reusable `SC-CORE` and `SO` contracts, and what remains product/application specific?

## DOC-CONFIRMED — reset is a distinct safety-control behavior

Rockwell Guardmaster safety-relay documentation distinguishes monitored manual reset from automatic/manual reset. Monitored manual reset requires a prescribed OFF->ON->OFF reset-signal sequence and performs reset on the trailing edge; automatic/manual reset can execute immediately when the reset input is held active and safety inputs restore.

Rockwell safety instructions likewise require correct reset actions before their safety output can energize.

**Freeze:** reset/rearm semantics are architecture/product specific and SHALL be declared. A reusable `SC-CORE` shall not silently substitute automatic restart behavior for a monitored/manual-reset requirement.

**Freeze:** `RESET ACCEPTED != HAZARDOUS MOTION COMMANDED`. Reset/rearm may restore eligibility/permissive state; ordinary machine control remains responsible for a separate start/cycle request unless the machine-specific SRS explicitly and validly establishes otherwise.

## DOC-CONFIRMED — reset location / visibility is a human-factor requirement

Rockwell SafeShield documentation states that, with internal restart interlock, the reset button is installed outside the hazardous area, cannot be operated from inside it, and should give the operator full view of the hazardous area.

**Freeze:** where the risk/SRS requires a deliberate reset after protected-space entry, reset placement and visibility are part of `HF-*`/`VAL-*`; they are not merely HMI preferences. Where full visibility is impossible, the application requires a separately justified occupancy/restart architecture rather than assuming a reset button clears the space.

## DOC-CONFIRMED — EDM proves contactor response, not the physical hazard proposition

Rockwell SafeShield documents EDM using positively guided/closing feedback contacts from external contactors. After the protective device responds, failure to observe the expected de-energized contactor feedback prevents restart.

This supports a narrow proposition: EDM can monitor whether the selected external switching devices report the expected contact state. It does not prove motor standstill, electrical isolation, hydraulic pressure removal, gravity restraint, or absence of another energy path.

**Freeze:** `EDM HEALTHY != PHYSICAL SAFE STATE PROVED` remains controlling.

**Freeze:** an `SO` implementation must record what its feedback proves, what it does not prove, and whether the feedback path shares power/mechanical/common-cause dependencies with the final element.

## DOC-CONFIRMED — STO removes torque-generating capability but is not electrical isolation

Siemens SIMODRIVE/SINUMERIK safety documentation states that STO prevents torque generation / unexpected starting but does not electrically isolate the drive from the supply. It also warns that external forces or gravity can require additional braking/holding measures and that STO applied to a moving drive does not itself provide braking.

**Freeze:** `STO ACTIVE != ELECTRICAL ISOLATION`.

**Freeze:** `STO ACTIVE != MOTOR STANDSTILL PROVED`.

**Freeze:** a gravity-loaded/external-force axis requires an independently justified safe-state proposition and holding/braking architecture; STO alone cannot be generalized as load restraint.

## Architecture consequence for SC-CORE

A reusable independent safety controller specification must distinguish:

1. safety demand state;
2. reset request;
3. reset accepted / rearm eligible;
4. safety permissive restored;
5. ordinary start/cycle request.

These states may be connected differently by a selected certified/product architecture, but curriculum artifacts must not collapse them into one `enable` bit.

Power-up and fault recovery default non-permissive until the required input, dependency, feedback and rearm propositions are established. Communications recovery from LinuxCNC/FPGA cannot itself rearm the safety function.

## Architecture consequence for SO family

A reusable output template must be instantiated by final-element class because evidence differs:

- **relay/contactor output:** contact state/EDM may witness selected contactor state, not downstream physical standstill or isolation unless the architecture separately establishes it;
- **drive STO:** selected drive safety manual establishes STO input semantics and fault behavior; STO does not equal line isolation or standstill;
- **monitored hydraulic/pneumatic valve:** position feedback proves only the documented valve-state proposition; pressure/beam/load safe state requires appropriate physical evidence;
- **dump/exhaust path:** command/valve state does not prove residual pressure is below a machine-specific safe threshold;
- **brake/load-holding path:** electrical command does not prove mechanical load restraint without appropriate feedback/validation.

## Dependency / CCF additions

Before schematic freeze, `SC-CORE`/`SO` implementations SHALL trace:

- reset device wiring and possibility of stuck/held reset;
- reset location/visibility and foreseeable defeat;
- safety-controller supply, clock/reset/watchdog dependencies;
- output-channel common supplies and protection;
- contactor/valve common pilot/mechanical dependencies;
- feedback supply and whether feedback can remain plausible after the actuation path fails;
- drive STO supply/reference and product-specific input requirements;
- gravity/external-force paths that persist after torque removal;
- restart after power loss/restoration;
- service/bypass/maintenance isolation boundaries.

## Evidence classification and source provenance

DOC-CONFIRMED sources consulted in this audit:

- Rockwell Automation, *Guardmaster Safety Relays User Manual*, 440R-UM013, reset definitions.
- Rockwell Automation, *SafeShield Safety Light Curtain Hardware User Manual*, 442L-IN002, EDM and reset-button placement.
- Rockwell Automation, Studio 5000 safety instructions (DCST), reset required before output energization.
- Siemens, *SIMODRIVE 611 digital Configuration Manual*, STO behavior, braking/holding caveat and no electrical isolation.
- Siemens, *SINUMERIK Safety Integrated Function Manual*, STO torque-generation boundary and external-force caveat.

Product values/timings in those manuals are not generalized beyond their cited devices.

## Remaining UNKNOWN / next work

No generic reset timing, EDM timing, contactor architecture, STO electrical interface, brake architecture, valve truth table, pressure threshold, proof-test interval, diagnostic-coverage value, PL/SIL target or safe stopping value is established here.

Next: convert this audit into `SC-CORE` and per-class `SO` implementation-spec templates. Then perform an adversarial restart/rearm/output-witness review that attacks stuck reset, feedback welded/plausible, gravity/external force, loss/restoration of power, and service/maintenance transitions before any reusable schematic is frozen.

No executable question survives authoritative-source reasoning at this stage; no compute is justified.