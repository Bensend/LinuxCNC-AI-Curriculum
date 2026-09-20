# Rockwell Change-Impact, Partial Revalidation, and Physical-Application Boundary

Date: 2026-09-20
Course: 4000 safety course

## Question

Can a validated machine-safety application legitimately use partial revalidation after a change, and what prevents a safety signature or controller-level test from being mistaken for proof of the physical machine?

## Authoritative evidence

### 1. Full validation is application-specific and reaches sensors and actuators

Rockwell Automation GuardLogix 5580 safety documentation states that project validation requires a full application test in which each sensor and actuator involved in every safety function is activated, including shutdown functions that may not occur in normal operation. It also states that validation is valid only for the specific application tested; moving the safety application to another installation requires startup and validation in the context of the new sensors, actuators, wiring, networks, and physical control equipment.

Evidence class: **DOC-CONFIRMED**.

Source: Rockwell Automation, *Validate the Project*, GuardLogix 5580 / Compact GuardLogix 5380 Safety Reference Manual online documentation, accessed 2026-09-20.

### 2. Modification requires impact analysis; revalidation may be scoped to affected elements

The same Rockwell documentation requires an impact analysis for modifications/upgrades to a validated functional-safety system. It directs the engineer to plan, analyze, and document the impact of the change and choose the appropriate hardware/software revalidation level from that analysis. Rockwell explicitly notes that unchanged elements need not be revalidated when the validation plan and impact analysis support that conclusion.

Evidence class: **DOC-CONFIRMED**.

This is a useful manufacturer example of a real partial-acceptance rule: **scope follows affected safety dependencies, not a blanket rule that every possible test must always be repeated**.

### 3. Safety signatures support impact analysis but do not prove physical machine behavior

Rockwell documents the safety signature as an integrity mechanism for the safety application. Its hierarchy can identify which safety elements changed and can reduce certification effort when unchanged elements legitimately do not require revalidation.

Evidence class: **DOC-CONFIRMED**.

The signature covers the safety-controller project, not the complete physical machine. Rockwell's own validation requirement separately reaches sensors, actuators, wiring, networks, and physical equipment. Therefore:

**SAFETY SIGNATURE MATCH/CHANGE ANALYSIS != PHYSICAL SENSOR/ACTUATOR FUNCTION PROVED.**

That distinction is source-supported by the combination of the signature and validation documentation; the inequality wording is a curriculum **INFERENCE**.

### 4. Affected safety-program edits must be revalidated before resumed operation

Rockwell's *Edit a Safety Application* documentation says that safety-program changes require revalidation of all affected application elements as determined by impact analysis before operation resumes. At minimum, impacted software must be functionally tested and modifications/test results documented. It also warns that online edits can affect running safety functions and require alternative safety measures/constraints during the edit.

Evidence class: **DOC-CONFIRMED**.

### 5. Field validation includes physical circuit and machine-stop evidence

Rockwell's machine-safety validation services describe field validation as checking circuit performance, fault tolerance/action, software logic, device application/function, reset actions, and all operating modes; the service portfolio explicitly includes machine stop-time services.

Evidence class: **DOC-CONFIRMED**.

This supports the course boundary that controller/configuration evidence is only one layer of machine validation. A change affecting stopping performance, safeguard placement, hydraulic/mechanical final elements, or another physical dependency requires the corresponding physical evidence even if unrelated controller elements remain unchanged.

## Reusable change-impact rule

For each change, construct a dependency set:

`changed item -> affected safety function(s) -> affected sensor/logic/output/final-element/physical-performance dependencies -> invalidated evidence -> required revalidation -> production-release gate`

A partial revalidation is defensible only when the impact analysis positively identifies the unchanged dependencies and the validation plan permits their existing evidence to remain valid.

Do **not** reverse the burden into: "only test the thing that was edited." The relevant scope is the safety function and its affected dependencies, which may extend beyond the edited controller element.

## Curriculum freezes

- **CHANGE IDENTIFIED != IMPACT ANALYSIS COMPLETE.**
- **IMPACT ANALYSIS COMPLETE != AFFECTED SAFETY FUNCTIONS REVALIDATED.**
- **SAFETY SIGNATURE VERIFIED != PHYSICAL MACHINE SAFETY FUNCTION VALIDATED.**
- **CONTROLLER LOGIC UNCHANGED != SENSOR/ACTUATOR/WIRING/FINAL-ELEMENT EVIDENCE STILL VALID.**
- **PARTIAL REVALIDATION ALLOWED != MINIMAL EDIT-ONLY TESTING ALLOWED.**
- **AFFECTED TESTS PASSED != PRODUCTION AUTHORITY unless the machine's return-to-service/restart gates are also satisfied.**

## Mapping to the four evidence classes

A — normal-demand functional test: required when the change can invalidate normal safety-function behavior.

B — abnormal/fault-injection test: required when the change can invalidate diagnostics, fault tolerance, wiring/network fault response, or a required shutdown path.

C — quantitative physical performance: required when the change can invalidate stopping time/distance, safe speed, holding force/torque, hydraulic pressure/retention/decompression, safeguard geometry, or another physical acceptance criterion.

D — periodic/proof-test program: revisit when the change affects proof-test assumptions, architecture, component requirements, diagnostic coverage, or maintenance intervals.

The matrix is dependency-driven. It is not a rule to mechanically execute A+B+C+D after every change.

## OpenPressBrake boundary

This study does not establish OpenPressBrake PL/SIL, hydraulic truth tables, stopping limits, proof-test intervals, pressure thresholds, safe-speed values, diagnostic coverage, or safeguard distances. Those remain **UNKNOWN** until the actual machine architecture and risk assessment establish them.

LinuxCNC and the normal FPGA/controller may record diagnostics, test context, configuration identity, and evidence. They do not become the independent personnel-safety authority merely because they participate in validation records.

## Information-gain result

The generic controller-side partial-revalidation question is now sufficiently supported: authoritative manufacturer documentation explicitly permits impact-analysis-scoped revalidation while simultaneously requiring physical application validation through sensors and actuators.

The remaining higher-value gap is narrower and physical: find an OEM/high-energy-machine procedure that applies this same change-impact principle to hydraulic/mechanical final elements or safeguard geometry with quantitative acceptance and explicit return-to-production disposition. If public OEM documentation remains unavailable, mark that branch source-limited rather than inventing criteria.
