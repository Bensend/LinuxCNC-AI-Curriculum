# Optical Protective Device Replacement, Acceptance, and Revalidation Boundary Study

Date: 2026-09-19
Lane: independent safety curriculum Lane B
Status: durable source/documentation study; no machine-specific acceptance values asserted

## Why this lane was selected

The primary safety lane is currently advancing press-brake hydraulic valve service/replacement and post-service physical proof. This Lane-B study deliberately uses a different device class, evidence package, and files: electro-sensitive protective equipment (ESPE), specifically safety laser scanners, and the commissioning boundary after replacement/configuration work.

The curriculum already separates ordinary LinuxCNC/FPGA control from personnel-safety authority. This study extends that separation into maintenance: a replacement device that powers up, communicates, and reports a clear field is not thereby proved suitable for return to production.

## Frozen authority chain

**REPLACEMENT DEVICE INSTALLED != CONFIGURATION/IDENTITY CORRECT != PROTECTIVE FIELD GEOMETRY VALID != DETECTION FUNCTION PHYSICALLY PROVED != RESTART INTERLOCK VALID != MACHINE STOP FUNCTION VALID != SAFETY ACCEPTANCE COMPLETE != PRODUCTION AUTHORITY**

Also freeze:

**FIELD CLEAR != PERSONNEL CLEAR**

**OSSD ON != MACHINE SAFE TO RESTART**

**DIAGNOSTIC/NETWORK DATA VALID != SAFETY FUNCTION VALIDATED**

**ORDINARY LINUXCNC INPUT TRUE != PERSONNEL-SAFETY AUTHORITY**

## Evidence

### SICK S3000 operating instructions — replacement and acceptance

Evidence class: **DOC-CONFIRMED**.

SICK's current S3000 operating instructions state that if the system plug is also replaced, the configuration must be transferred to the scanner and acceptance by qualified safety personnel is required. The same manual identifies periodic/monthly protective-device checks as a separate maintenance activity.

Engineering consequence: replacement/configuration restoration is not equivalent to acceptance. A service action can create a new validation boundary even when the scanner powers up normally.

Source: SICK, *S3000 Safety laser scanner — Operating instructions*, document 8009942, revision shown by source as 2025-08-19.

### SICK S300 restart behavior — restart interlock remains a distinct function

Evidence class: **DOC-CONFIRMED**.

SICK's S300 instructions distinguish start interlock from restart interlock. With restart interlock configured, clearing the protective field does not itself return the scanner OSSDs to ON; the operator must perform the restart/reset action. The manual also warns that when protective-field status rather than OSSD status is consumed by a Flexi Soft controller, scanner-internal restart behavior does not automatically provide the controller-side restart interlock; that function must be implemented at the appropriate safety-control layer.

Engineering consequence: a replacement acceptance test must trace the complete safety architecture, not merely the scanner display or raw field-clear status.

Source: SICK, *S300 Safety laser scanner — Operating instructions*, 8010948/ZD09/2024-09-12.

### SICK scanner configuration guidance — personnel detectability matters

Evidence class: **DOC-CONFIRMED**.

SICK scanner configuration guidance requires restart interlock when a person can leave the protective field toward the hazardous point or cannot remain detectable everywhere in the hazard area.

Engineering consequence: a scanner reporting a clear field cannot be promoted to `personnel_clear` unless the application architecture actually guarantees continuous detection for the relevant hazard geometry or supplies another personnel-clear/restart-control measure.

## Architecture lesson for LinuxCNC/OpenPressBrake

An optical protective device may provide ordinary diagnostic information to LinuxCNC: field interrupted, device fault, warning field, reset requested, configuration/device status, and maintenance diagnostics. Those are useful for operator guidance and troubleshooting.

They do not grant LinuxCNC authority to decide that a replacement scanner is correctly configured, that its field geometry still covers the hazard, that its response is integrated correctly into the independent safety evaluator, that the final elements actually stop the hazard, or that personnel are clear.

A robust architecture keeps at least these witnesses distinct:

1. device identity/configuration witness;
2. physical protective-field/detection witness;
3. independent safety-output/evaluator witness;
4. actual machine final-element response witness;
5. physical hazardous-state/stop witness where required;
6. restart-interlock/personnel-clear authority;
7. ordinary LinuxCNC production command.

## Replacement/recommissioning verification worksheet

The exact test pieces, distances, response-time limits, field coordinates, stop-performance limits, and acceptance criteria must come from the actual device/machine documentation and risk assessment. They are **UNKNOWN** for OpenPressBrake here.

A machine-specific commissioning procedure should answer, with retained evidence:

| Challenge | Required observation | Evidence status before machine-specific test |
|---|---|---|
| Wrong or missing configuration after replacement | safety release withheld; diagnostic state unambiguous | architecture requirement; exact behavior UNKNOWN |
| Correct configuration loaded but field geometry not physically proved | production acceptance withheld | INFERENCE from documented acceptance boundary |
| Intrusion at representative field locations | protective function demands safe response through independent safety path | exact test method UNKNOWN |
| Field clears while a person could remain in an unmonitored area | no automatic promotion of `field_clear` to `personnel_clear` | DOC-CONFIRMED principle |
| Restart/reset operated | reset/restart cannot itself become an ordinary production start unless the machine design explicitly and safely provides that behavior | DOC-CONFIRMED restart distinction; machine behavior UNKNOWN |
| LinuxCNC START/CYCLE/JOG is stale during safety recovery | stale ordinary command must not silently convert restored safety permission into unintended hazardous motion | curriculum architecture requirement |
| Scanner/network diagnostics appear healthy | diagnostics alone do not substitute for physical field/function validation | INFERENCE supported by replacement acceptance requirement |
| Mount, connector, system plug, or configuration is serviced again | define whether acceptance/revalidation is retriggered | device/machine-specific; UNKNOWN |

## Failure-path analysis

### Failure A — replacement powers up with plausible diagnostics

A technician replaces the scanner. LinuxCNC sees expected status and the field is clear.

Unsafe shortcut: treat communications and `field_clear` as proof of return-to-service readiness.

Required boundary: hold production authority until configuration/identity and required acceptance tests are complete.

### Failure B — correct scanner, wrong field/configuration

The device itself is healthy but its field set, mounting reference, or transferred configuration does not correspond to the guarded geometry.

Unsafe shortcut: equate device self-test success with application validation.

Required boundary: physically validate the protective function and application geometry using the manufacturer/machine procedure.

### Failure C — person leaves the sensed field toward the hazard

The scanner becomes clear while the person remains in the hazardous area.

Unsafe shortcut: map scanner clear directly to machine restart permission.

Required boundary: restart interlock/personnel-clear architecture must address the actual access geometry.

### Failure D — safety recovery meets stale ordinary motion request

The independent safety path becomes healthy while LinuxCNC still contains START, CYCLE, JOG, or another ordinary motion request from before the intervention.

Required boundary: restored safety permission is not itself a fresh ordinary production command.

## Provenance labels used here

- **DOC-CONFIRMED** — explicit manufacturer documentation.
- **SOURCE-CONFIRMED** — source code or implementation artifact directly establishes behavior; none newly claimed in this study.
- **TEST-CONFIRMED** — physically or executably tested in the relevant environment; none claimed.
- **COMMUNITY-REPORTED** — community report not independently proved; none relied upon.
- **INFERENCE** — engineering conclusion derived from documented boundaries, explicitly labeled.
- **UNKNOWN** — requires actual OpenPressBrake device/machine documentation, configuration, measurement, or physical validation.

## What remains UNKNOWN for OpenPressBrake

No claim is made here about whether OpenPressBrake will use a safety laser scanner or light curtain, its device type, protective-field dimensions, resolution, response time, mounting, safety distance, restart arrangement, PL/SIL/category/DC/CCF, stop time, hydraulic response, final elements, personnel-clear method, test piece, test interval, or acceptance threshold.

## Compute decision

No simulation, synthesis, benchmark, or executable test answers the present question better than manufacturer documentation. Therefore no compute was launched and no GitHub-hosted runner was used.

## Precise next Lane-B checkpoint

Find a professional machine/device replacement or commissioning procedure that exposes the complete chain:

`ESPE replacement -> configuration/identity restoration -> physical field/detection acceptance test -> independent safety evaluator -> actual final element -> physical machine stop/safe-state witness -> restart-interlock/personnel-clear challenge -> failed-test disposition -> correction -> renewed acceptance -> safety rearm -> fresh ordinary production start`.

Prefer an example with a documented wrong-configuration, altered-mounting, failed test-piece, or restart-interlock fault case. Keep it independent of the primary lane's hydraulic valve-service evidence package.