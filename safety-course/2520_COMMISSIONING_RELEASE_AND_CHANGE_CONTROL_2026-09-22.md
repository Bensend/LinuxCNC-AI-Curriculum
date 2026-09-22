# 2520 — Commissioning, Release, and Change Control

Date: 2026-09-22

## Purpose

Bridge a validated safety design into controlled machine release, then preserve the validity of that evidence when hardware, software, configuration, mechanics, guards, fluid power, networking, tooling, or procedures change.

This stage follows verification/validation; it is not a paperwork substitute for it.

## Lifecycle chain

`approved SRS/design baseline -> identifiable implementation -> commissioning readiness -> controlled tests -> findings resolved -> temporary measures removed -> acceptance evidence complete -> release baseline frozen -> change proposed -> impact analysis -> affected evidence stale -> partial/full revalidation -> new accepted baseline`

## Professional anchors

**DOC-CONFIRMED — Rockwell Automation:** its current Logix SIS commissioning lifecycle proceeds from safety-function specification through project creation, safety signature generation, project validation/confirmation and controller locking/access control. Rockwell states that the safety signature identifies the safety logic, constant data and configuration. This supports treating configuration identity as part of the evidence chain rather than an administrative afterthought.

**DOC-CONFIRMED — Rockwell AADvance:** commissioning measures must be system-specific and defined before commissioning; temporary measures used for testing or partial commissioning must be removed before the whole system goes live; commissioning records should preserve tests, problems and resolutions; integrated validation is against the SRS and includes normal startup/shutdown, abnormal fault modes, performance criteria and external common causes.

**DOC-CONFIRMED — Siemens Safety Integrated:** first commissioning requires a complete acceptance test; later safety-related functional expansion, hardware change, software upgrade, data transfer/series commissioning or modular-machine change can require a new complete or partial acceptance test. Siemens warns that component replacement can produce non-safe states and requires function testing before danger-zone re-entry/resumed operation for affected drives.

These sources establish lifecycle discipline. They do not establish the acceptance values for an unspecified LinuxCNC machine.

## Commissioning readiness gate

Before hazardous commissioning begins, require:

- approved machine/lifecycle boundary and SRS revision;
- identified `HZ/PROP/SF/FLT/ARCH` chain;
- applicable integrity method/edition and required target established where required;
- released schematics/wiring/configuration/software identities;
- safety-controller/drive/device configuration identities or signatures where available;
- test plan and acceptance criteria defined before observing results;
- safe test sequence, instrumentation and competent human roles identified;
- hazardous energy and exposure controls for the test itself;
- explicit list of temporary bypasses, forces, jumpers, test modes, inhibited outputs or partial-commissioning measures;
- rollback/containment plan for failed tests;
- no unsupported machine-specific value silently promoted from `UNKNOWN`.

If a test requires people exposed to a hazard before the minimum safe-to-operate propositions are established, do not perform exposed operation. Use isolated/remote testing where technically justified and keep people outside the danger zone.

## Configuration identity is evidence

A validation result applies to an identifiable implementation. Record, as applicable:

- machine/assembly identity;
- electrical/mechanical/fluid-power drawing revisions;
- safety logic/configuration revision and signature/checksum;
- LinuxCNC configuration/software revision for ordinary-control interactions being tested;
- FPGA/firmware revision when it affects interfaces or ordinary demand behavior;
- safety device/final-element identity and relevant parameters;
- network/topology configuration when it is part of the validated architecture;
- calibration/instrument identity for physical measurements.

Freeze: **TEST PASSED != CURRENT MACHINE PROVED IF CONFIGURATION IDENTITY IS LOST OR CHANGED.**

Ordinary LinuxCNC/FPGA identity can be necessary evidence for interactions such as fresh-demand behavior without making LinuxCNC/FPGA personnel-safety authority.

## Temporary commissioning measures

Track every temporary measure as an explicit finding/obligation with owner, purpose, installation state, removal criterion and independent removal check where consequence warrants it.

Examples: bypassed guard input, forced safety input, temporary jumper, disabled diagnostic, temporary software branch, commissioning password/access, overridden pneumatic valve, mechanical prop, temporary reduced-speed setup, disconnected actuator, or test-only network path.

A successful test obtained with a temporary measure does not prove the production configuration unless the test's scope explicitly remains valid after removal.

Freeze: **COMMISSIONING BYPASS REMOVED != SAFETY FUNCTION REVALIDATED WHERE THE BYPASS CHANGED THE TESTED PATH.**

## Release gate

Do not collapse “tests mostly green” into machine release. Release requires, at minimum:

1. required validation rows completed for the accepted configuration;
2. required physical propositions proven with their declared witnesses/measurements;
3. failed/UNKNOWN findings dispositioned without inventing closure;
4. temporary commissioning measures removed and checked;
5. reset/rearm and fresh-start behavior validated where applicable;
6. required maintenance/operator instructions and residual-risk controls available;
7. accepted configuration identity frozen;
8. authority to accept release identified;
9. unresolved residual risk explicitly stated.

A machine below its basic safe-to-operate threshold must not be released for operation with people exposed.

## Change-impact method

For every proposed change, trace both directions:

`changed item -> DEP/ARCH -> FLT/diagnostic assumptions -> SF -> PROP -> HZ`

and

`changed item -> existing EVID/VAL rows -> evidence freshness`

Ask whether the change can alter:

- hazard boundary or operating mode;
- safe-state proposition;
- trigger/reaction/reset/restart semantics;
- safety input or final-element behavior;
- diagnostic timing/coverage assumptions;
- common-cause or independence assumptions;
- integrity calculation/input data;
- stopping/load-holding/pressure/geometry proposition;
- power/network/reintegration behavior;
- human interaction, access, maintenance or bypass incentives;
- configuration identity/signature;
- validation method or acceptance criterion.

Mark affected evidence `STALE` until re-proved. Unaffected evidence may remain fresh only when the impact analysis justifies that conclusion.

## Partial versus complete revalidation

A partial revalidation is justified by bounded impact, not by convenience. Define the affected requirement/proposition set first, then derive the test scope.

Escalate toward complete revalidation when the change crosses poorly bounded interfaces, alters safety architecture or safety-related software broadly, changes hazard boundaries/modes, invalidates common-cause assumptions, replaces a final element with materially different behavior, or leaves uncertainty about what prior evidence still applies.

Do not infer a universal rule from a vendor-specific acceptance-test workflow; use the applicable machine standard, SRS and change impact.

Freeze: **SMALL CODE/COMPONENT CHANGE != SMALL SAFETY IMPACT.**

## Human-factors/change-control test

A technically valid safeguard that operators predictably defeat because normal use or maintenance is unnecessarily difficult has an engineering problem. During commissioning and post-change review, explicitly record:

- nuisance trips and their actual causes;
- awkward reset/restart locations;
- guards that are difficult to reinstall correctly;
- bypasses needed for legitimate setup/maintenance;
- diagnostics that fail to tell maintainers what actually blocks recovery;
- production pressures likely to encourage defeating a safeguard.

Correct the design where practical so the safe path is the easy path. Do not solve usability problems by transferring personnel-safety authority to ordinary LinuxCNC/FPGA logic.

## Required record set

A durable release/change package should link:

- SRS and risk/hazard basis;
- `HZ/PROP/SF/FLT/ARCH` trace;
- integrity-method/target evidence;
- released design/configuration identities;
- verification/validation matrix and raw evidence references;
- physical measurement records;
- commissioning findings and dispositions;
- temporary-measure removal record;
- acceptance/release decision;
- change history and impact analyses;
- revalidation records and next proof/inspection triggers.

## New freezes

- **VALIDATION COMPLETE != RELEASE AUTHORIZED UNTIL THE ACCEPTED CONFIGURATION AND FINDINGS ARE CONTROLLED.**
- **TEST PASSED != CURRENT MACHINE PROVED IF CONFIGURATION IDENTITY IS LOST OR CHANGED.**
- **TEMPORARY COMMISSIONING MEASURE REMOVED != AFFECTED SAFETY PATH REVALIDATED.**
- **COMPONENT REPLACED WITH SAME PART NUMBER != PRIOR PHYSICAL PROPOSITION AUTOMATICALLY FRESH.**
- **SMALL CHANGE != SMALL SAFETY IMPACT.**
- **PARTIAL REVALIDATION SCOPE COMES FROM IMPACT ANALYSIS, NOT CONVENIENCE.**
- **ORDINARY LINUXCNC/FPGA REVISION TRACEABILITY != PERSONNEL-SAFETY AUTHORITY.**

## Learner completion condition

The learner can move a safety design from validated requirements to a controlled release baseline, identify configuration evidence, control temporary commissioning measures, perform bidirectional change impact analysis, decide what prior evidence becomes stale, and derive a defensible partial/full revalidation scope without inventing machine-specific facts.
