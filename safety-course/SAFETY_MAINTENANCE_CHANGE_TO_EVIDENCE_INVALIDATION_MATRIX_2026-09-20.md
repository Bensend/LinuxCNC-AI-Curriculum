# Safety Maintenance Change-to-Evidence Invalidation Matrix

Date: 2026-09-20

## Purpose
Convert the four-class validation scaffold into a practical maintenance rule: **revalidate the evidence dependencies a change can invalidate; do not blindly rerun everything, and do not let configuration identity substitute for physical evidence.**

Evidence classes:
- **A:** normal-demand functional test
- **B:** deliberate abnormal-operation / fault-injection test
- **C:** quantitative physical performance test
- **D:** periodic functional/proof-test program

This matrix is a curriculum engineering synthesis (`INFERENCE`) grounded in the existing manufacturer/OEM studies. It is not an OpenPressBrake acceptance specification.

## Change-impact matrix

| Maintenance/change | Evidence potentially invalidated | Minimum reasoning before return to service | What remains UNKNOWN until machine-specific design is known |
|---|---|---|---|
| Replace safety input device with same approved type | A; B when wiring/diagnostics changed; D identity/interval record | Verify physical mounting/actuation geometry, channel behavior, safe demand, reset/restart disposition; deliberately test relevant wiring faults when the architecture's diagnostic claim depends on them | required PL/SIL, exact fault set, discrepancy time, proof interval |
| Replace/reterminate safety input wiring | A + B; possibly D record | Normal demand is insufficient where diagnostic coverage depends on wire-break/cross-short detection; challenge the affected fault paths | architecture-specific diagnostic coverage and fault assumptions |
| Replace safety output module / safety network node | A + B; affected final-element witness; D record | Restore identity/ownership/configuration, then prove the affected safety function physically; network/configuration health alone is not functional safety revalidation | device-specific ownership, signatures, proof interval |
| Replace external contactor / power switching final element | A + affected EDM/final-element physical witness; B if welded/stuck detection claim affected; D | Demand safe state, verify physical feedback/restart inhibition, and verify actual hazardous-energy interruption appropriate to the machine | contactor sizing, diagnostic coverage, required test interval |
| Replace drive / encoder / motor feedback | A + C for actual-value/direction/safe-motion functions; B when replacement procedure calls for fault testing; D record | Siemens evidence supports bidirectional physical motion/actual-value recheck and affected safety-function acceptance; checksum alone is insufficient | OpenPressBrake speed limits, direction conventions, acceptance tolerances |
| Service/replace mechanical holding brake | A + C + D | Command/feedback proves are insufficient when holding performance can change; perform the design-specific physical holding/proof test before relying on brake retention | test torque, load, allowable movement, interval |
| Hydraulic valve/manifold service affecting safe stopping or retention | A + likely C; B if monitored-position/mismatch diagnostics affected; D | Re-establish valve function and any monitored-position witness; where the safety claim depends on pressure removal/retention or ram stopping, obtain the corresponding physical pressure/motion/performance evidence | hydraulic truth table, pressure thresholds, leakage/retention limits, stop acceptance |
| Work affecting press-brake stopping performance | A + C + safeguard requalification | Rockford RHPS requires post-maintenance all-mode function testing before production; when stopping-dependent safeguarding authority is affected, remeasure/reaccept stopping performance and requalify safeguard placement/geometry | actual stop-time limit, distance formula inputs, machine-specific acceptance threshold |
| Relocate light curtain/scanner/press-brake optical safeguard | A + C physical geometry/boundary; possibly stopping-performance C | Physically verify field/boundary/overlap and machine reaction; recalculate/recheck safety distance if location or stopping dependency changed | exact field dimensions, minimum distance, response-time stack |
| Change safety logic/configuration only | A for every affected safety function; B/C only where the change can alter those claims; D documentation | Trace affected safety functions end-to-end. A software/configuration diff can invalidate physical behavior without physically changing hardware | scope depends on actual logic dependency graph |
| Ordinary maintenance demonstrably unrelated to a safety function (e.g. cosmetic panel work outside hazard/control dependencies) | Usually no B/C invalidation; Rockford RHPS still calls for post-maintenance all-mode function test before production in its press-brake procedure | Document why safety evidence is unaffected; do not invent extra destructive/fault tests merely to fill a matrix | local maintenance policy and machine/OEM requirements |

## Decision algorithm

1. Identify exactly what changed, including connectors, mounting geometry, parameters, calibration, firmware, network identity, and physical energy path.
2. Trace every safety function that depends on the changed item.
3. For each affected safety function, identify which evidence class(es) established the pre-change claim.
4. Mark only evidence whose assumptions can have been invalidated by the change.
5. Repeat those tests with their original physical acceptance criteria; if the repair changes the acceptance basis itself, perform a new engineering validation rather than merely repeating an obsolete test.
6. Requalify any safeguard whose safe placement/geometry depends on changed stopping performance or changed physical mounting.
7. Restore normal safeguards/modes and require the normal reset/rearm/fresh-start sequence before production.
8. Record residual `UNKNOWN` items instead of importing thresholds or intervals from another manufacturer's example.

## Anti-shortcut rules

**SAME PART NUMBER != SAME PHYSICAL INSTALLATION/ALIGNMENT.**

**CHECKSUM MATCH != SENSOR/ENCODER DIRECTION OR PHYSICAL RESPONSE PROVED.**

**NORMAL DEMAND PASS != DIAGNOSTIC FAULT COVERAGE REVALIDATED WHEN WIRING/DIAGNOSTIC ASSUMPTIONS CHANGED.**

**FINAL-ELEMENT FEEDBACK PASS != QUANTITATIVE HOLDING/STOPPING PERFORMANCE PROVED WHEN MECHANICAL/HYDRAULIC PERFORMANCE CHANGED.**

**STOPPING PERFORMANCE ACCEPTED != STOPPING-DEPENDENT SAFEGUARD PHYSICALLY REQUALIFIED.**

**RETURN-TO-SERVICE TEST COMPLETE != STALE ORDINARY COMMAND AUTHORIZED; production still requires the defined fresh start/rearm behavior.**

## Human-factors application

The maintenance workflow should make the correct revalidation path easier than bypassing it: identify the changed component, automatically present the affected test checklist, retain prior acceptance criteria and measurement locations, and clearly mark production authority unavailable until required evidence is complete. Diagnostics in LinuxCNC may guide and record this workflow, but ordinary LinuxCNC/FPGA software does not become the personnel-safety authority.

## Next evidence target

Find a manufacturer/OEM maintenance system that explicitly uses a change-impact or partial-acceptance matrix across safety functions, then compare its scoping logic against this synthesis. Siemens replacement tables are a foundation; seek a machine-level example that also includes hydraulic/mechanical final elements or safeguard geometry.
