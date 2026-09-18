# Hydraulic press-brake stop proof, periodic validation, and rescue boundary trace

Date: 2026-09-18

## Purpose

Continue the 4000 safety-course professional-machine trace at the boundary between a safety command and demonstrated physical stopping behavior. This study uses a real hydraulic press-brake OEM manual (BAYKAL APH) and current HAWE press-brake system documentation. It does **not** infer an OpenPressBrake hydraulic truth table.

## Evidence ledger

### BAYKAL APH hydraulic press brake

**DOC-CONFIRMED — machine-class architecture.** BAYKAL identifies the APH as a hydraulic press brake. Its valve-connection documentation identifies a pressure safety valve as additional safety for the directional valves, directional valves controlling Y-axis downward/upward motion, and a safety valve associated with the directional valves. The public text therefore exposes more than a generic `pump on/off` abstraction: the machine has hydraulic final elements explicitly assigned safety/directional roles.

Source: BAYKAL APH Series User's Manual, July 2005, valve connections / pages 30–31 as surfaced by ManualsLib: https://www.manualslib.com/manual/1616624/Baykal-Aph-Series.html

**DOC-CONFIRMED — safeguarding reaction.** The OEM manual says the beam-mounted Fissler AKAS laser guard protects the tooling area; intrusion before the muting point causes the beam to stop and retract automatically. This is machine-specific evidence of a protective-device demand producing an observable ram/beam reaction rather than merely changing a controller bit.

Source: BAYKAL APH manual, safety features, page 9.

**DOC-CONFIRMED — measured stop performance is a maintained property.** BAYKAL gives a stop-time value for the documented machine configuration and separately specifies stop-time control/measurement as a periodic maintenance item (six-month interval in the manual). The stop-time measurement device is connected to defined machine terminals. This supports the curriculum principle that safe-distance/stopping assumptions must be validated against physical machine behavior and maintained over service life; they are not permanently proven by schematic intent or initial commissioning.

Source: BAYKAL APH manual, stop-time control page 13; maintenance/stop-time measurement page 80.

**DOC-CONFIRMED — shipment/commissioning proof is broader than one signal.** Before dispatch, BAYKAL says the machine is checked and verified for safety guards, electrical circuit, hydraulic circuit, top-beam speed, switches/buttons, functional operation, tooling fixation, leakage and other items. This is evidence for treating recommissioning/return-to-service as a physical functional-validation activity rather than equating `controller ready` with machine ready.

Source: BAYKAL APH manual, finished-product checklist page 73.

**DOC-CONFIRMED — rescue is a separate operating state.** The maintenance section provides a specific rescue instruction for a person jammed between tools: a designated control moves the top beam to upper dead point from any position. This is important evidence that post-incident rescue motion is not ordinary production-cycle authority. It is a deliberately distinct hazardous-motion case that requires machine-specific design and validation.

Source: BAYKAL APH manual, section 6.6.5, page 80.

### HAWE current press-brake hydraulic systems

**DOC-CONFIRMED — physical beam holding and monitoring are explicit requirements.** HAWE's current press-brake application material names press-beam movement, reliable holding of the press beam, minimum switching time/short overtravel, operator safety, and safe monitoring of individual functions as press-brake requirements.

Source: HAWE, Press brakes application page: https://www.hawe.com/applications/manufacturing-efficiency/press-brakes/

**DOC-CONFIRMED — stored hydraulic energy can remain part of normal motion.** HAWE ePRAX modular documentation states that return stroke can be powered in part using temporarily stored hydraulic energy. Therefore motor-off, drive-disabled, or an electrical safe-state signal cannot generically be promoted to `all hydraulic energy absent`.

Source: HAWE ePRAX modular: https://www.hawe.com/products/product-finder/integrated%2Bsolutions/control%2Bfor%2Bpress%2Bbrakes/eprax-modular%2B-%2Bcontrol%2Bfor%2Bpress%2Bbrakes/downloads/

## Frozen curriculum distinctions

`PROTECTIVE-DEVICE DEMAND != SAFETY OUTPUT CHANGED != HYDRAULIC FINAL ELEMENT REACHED SAFE POSITION != RAM STOPPED/RETRACTED AS REQUIRED != MEASURED STOP PERFORMANCE VALID != ACCESS SAFE`.

`INITIAL STOP-TIME ACCEPTANCE != LIFETIME STOP-PERFORMANCE PROOF`.

`SCHEMATICALLY REDUNDANT / SAFETY-NAMED VALVES != PHYSICAL STOPPING PERFORMANCE PROVED`.

`PUMP OFF / MOTOR STO != STORED HYDRAULIC ENERGY ABSENT != GRAVITY LOAD RESTRAINED`.

`RESCUE MOTION AUTHORITY != RESET/REARM AUTHORITY != PRODUCTION CYCLE AUTHORITY`.

## Failure-path / adversarial review

A commissioning or maintenance validation should deliberately reject these shortcuts:

1. Light/laser safeguard trips and safety outputs change, but measured ram stopping performance is outside the validated machine requirement: **do not operate with personnel exposed** until the stopping/safeguarding defect is corrected and revalidated.
2. Electrical feedback says a valve/relay command changed, but the beam does not stop/retract as required: command/feedback evidence cannot overrule the physical hazard witness.
3. A historical stop-time certificate exists but the hydraulic system, valves, tooling/ram dynamics, safeguard, or relevant control chain has been serviced or changed: stale proof is not automatically current proof.
4. Pump/drive is disabled while hydraulic energy remains stored or the beam remains gravity-loaded: electrical disable is not maintenance isolation or physical load retention.
5. A rescue command is available after entrapment: it must not be reused as an ordinary bypass, setup shortcut, reset, or fresh cycle command merely because it can produce motion.
6. A machine passes a normal production cycle after service but the safety-device stop test was not repeated: successful production motion is not proof of the protective stop function.

## Human-factors implication

Periodic stop validation must be made easy to perform and difficult to omit: clear test points/procedure, retained result/date, explicit out-of-service disposition on failure, and no ordinary `RESET` path that hides an overdue/failed required validation. If the practical validation workflow is so inconvenient that maintainers predictably skip it, that inconvenience is itself a design problem.

## LinuxCNC / FPGA boundary

LinuxCNC or the ordinary FPGA may display measured stop results, maintenance due state, valve diagnostics, and production permissives. They must not become the sole personnel-safety authority merely because those signals are convenient to expose in HAL. The independent safety architecture owns the required protective reaction; the physical machine validation establishes whether that architecture actually stops/restrains the hazard as intended.

## Evidence limits / UNKNOWN

The public BAYKAL material inspected here is an older machine/manual and must not be generalized to current APH machines or OpenPressBrake. Its documented numerical stop time, safety distance, valve designations, and rescue implementation are machine-specific and are intentionally **not** adopted as design values.

Public evidence inspected here does not expose the complete internal safety logic, diagnostic coverage, valve spool-position feedback, exact redundant hydraulic topology, failure disposition for one failed retaining element, post-valve-service re-proof sequence, PL/SIL/category, or a safe rescue truth table. Those remain **UNKNOWN**.

## Next evidence target

Find a professional hydraulic press/press-brake implementation that exposes the disagreement path end-to-end:

`protective stop demand -> redundant hydraulic final elements -> valve/final-element feedback -> direct ram/pressure/motion witness -> failed disagreement latch/inhibit -> physical load-safe disposition -> repair -> required stop/restraint re-proof -> safety rearm -> separate fresh production initiation`.

Prefer an OEM/manufacturer source with an actual fault or commissioning procedure. Do not invent degraded production after one failed retaining element.

## Compute decision

No executable lab was justified. The unresolved questions are machine-specific physical/safety facts and are better answered by authoritative documentation or actual machine validation than by synthetic software simulation. No GitHub-hosted or self-hosted compute was consumed.
