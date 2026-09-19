# Press-Brake OEM Stop-Time Maintenance and Initial-Revalidation Trace

Date: 2026-09-19

## Question

Can a real press-brake OEM manual narrow the current gap between hydraulic maintenance/replacement, physical stopping-performance proof, and return to production without inventing a component-specific holding-valve test?

## Sources

1. BAYKAL APH hydraulic press-brake user's manual, July 2005, public manual reproduction. The manual identifies a dedicated pressure safety valve as additional safety for the directional valves and a separate safety valve associated with the directional valves. It also gives machine-level initial-test, maintenance, and stop-time-measurement instructions.
2. SAFed press-brake guidance, stopping-performance monitoring section, used as professional corroboration for the maintained-physical-property interpretation.

## Evidence ledger

### DOC-CONFIRMED — safety valves are explicit final elements in the machine architecture

The BAYKAL valve-connection description identifies a pressure safety valve as additional safety for directional valves and separately identifies a safety valve of the directional valves. This is useful because it shows that the machine-level safety architecture contains hydraulic final elements distinct from ordinary directional control.

### DOC-CONFIRMED — initial/recommissioning-style machine checks include a physical test run

BAYKAL section 6.5.1 requires an initial test/examination before operation. Among the required checks are guard function, switch/button condition, and a test run confirming that emergency, safety and limit switches fulfill their functions and that cylinders, valves, pipes and hoses do not leak.

This is machine-level functional evidence. It is not an individual static holding-valve retention proof.

### DOC-CONFIRMED — stopping performance is a maintained property, not a one-time design number

The manual's maintenance schedule requires stop-time control every six months. Section 6.6.6 specifies a machine connection point for the stop-time measurement device. The same manual states a machine stop time and corresponding minimum two-hand-control distance for that model/configuration.

SAFed independently recommends periodic assessment of hydraulic press-brake stopping performance where electro-sensitive safeguarding depends on it, using manufacturer recommendations, direct stop-time measurement, an on-demand test, or an automatic monitor as applicable.

### INFERENCE — repair scope and revalidation scope must not be silently collapsed

The OEM material supports a machine-level distinction between:

`hydraulic component/final element exists -> machine functional test -> stopping-performance measurement -> safeguarding-distance validity`.

It does NOT state that replacing a particular pressure/safety/directional valve automatically requires the six-month stop-time procedure immediately after that repair. It also does not specify a separate unmasked static retention challenge for either valve.

Therefore neither trigger may be invented.

## Durable safety freeze

**HYDRAULIC VALVE REPLACED != MACHINE FUNCTIONAL TEST PASSED != STOPPING PERFORMANCE MEASURED != SAFEGUARD DISTANCE STILL VALID != PRODUCTION AUTHORITY.**

**TEST RUN SHOWS SAFETY SWITCH RESPONSE != INDIVIDUAL HYDRAULIC FINAL ELEMENT PROVED.**

**PERIODIC STOP-TIME TEST REQUIRED != EVERY HYDRAULIC REPAIR AUTOMATICALLY TRIGGERS THAT TEST.**

**STOP-TIME PASS != STATIC LOAD-RETENTION PASS.**

## Practical commissioning implication

For a retrofit or repair, the validation plan should explicitly map the affected safety function to its physical witness instead of treating a generic successful cycle as proof. If safeguarding distance depends on stopping performance, the current stopping performance must be established by the machine/OEM-approved method at the required lifecycle point. If a hydraulic retaining function is safety-relevant, its load-retention proof requires its own authoritative procedure or design-specific validation; a stop-time measurement cannot substitute for it.

Ordinary LinuxCNC/HAL/FPGA logic may request motion and expose diagnostics, but it cannot turn a generic machine cycle or software state into evidence that a safety-related hydraulic final element physically retained load or achieved the required stopping performance.

## Human-factors implication

A maintainable retrofit should expose clear, accessible test points and a documented revalidation checklist. If proving the safety function after service is awkward enough that maintainers are likely to skip it, that is an engineering defect. The remedy is a safer test architecture and clearer procedure, not acceptance of an unproved repair.

## Remaining UNKNOWN

Public evidence reviewed here still does not establish the desired complete chain:

`specific holding/safety valve service/replacement -> companion path prevented from masking -> individual static retaining-function challenge -> physical ram/load witness -> explicit pass/fail criterion -> repair disposition -> stopping-performance re-proof when required -> safety reset/rearm -> fresh ordinary production START`.

Specifically UNKNOWN:

- whether replacement of the named BAYKAL pressure/safety valve automatically invokes stop-time measurement;
- whether the OEM has a separate post-replacement static load-retention test;
- how one retaining path is isolated/challenged without a companion path masking failure;
- allowed ram drift, test load, pressure, duration, and pass/fail threshold;
- whether a passed companion element must be re-proved after repair of the failed element.

Do not infer any of these values or procedures from the public manual.

## Compute decision

No simulation or executable test can answer the missing OEM hydraulic-service facts. No runner compute was justified or used.

## Next evidence target

Prefer a machine-specific OEM service manual, certified hydraulic commissioning procedure, or manifold manufacturer's machine integration procedure that explicitly ties safety-valve replacement to post-service functional tests and identifies the physical witness. If that source remains unavailable, rotate to another open safety module rather than creating a synthetic retention test.
