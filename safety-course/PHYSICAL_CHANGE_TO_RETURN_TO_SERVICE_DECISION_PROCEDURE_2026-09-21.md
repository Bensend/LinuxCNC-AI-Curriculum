# Physical change -> return-to-service decision procedure

Date: 2026-09-21

Purpose: turn the accumulated 4000 safety evidence into an AI-readable commissioning/maintenance decision procedure without inventing machine-specific acceptance values.

This is an educational engineering scaffold. It does not assign PL/SIL, stopping limits, hydraulic thresholds or proof-test intervals.

## 1. Start with the changed physical item, not the edited file

Record exactly what changed: sensor, safeguard mount/geometry, wiring, safety I/O, contactor, drive/encoder, brake, valve/manifold, pressure-sensing path, hydraulic hose/cylinder, mechanical restraint, tooling/fixture geometry, machine anchoring/level, safety logic/configuration, or another item.

Do not begin with `software unchanged therefore safety unchanged`.

## 2. Trace affected safety functions

For each changed item, ask which safety functions depend on it. Trace the complete dependency chain where applicable:

`protective demand -> safety input -> safety logic -> safety output -> final element -> hazardous-energy state -> physical machine response -> performance acceptance -> reset/rearm -> fresh ordinary START`

A dependency may be physical geometry rather than an electrical signal. A light-curtain mount, guard position or machine layout can invalidate safeguarding evidence without changing software.

## 3. Mark invalidated evidence classes

Use the existing four-class scaffold deliberately, not mechanically.

### A — normal-demand functional evidence

Examples: E-stop demand, guard opening, protective-field interruption, enabling-device release/full squeeze, safety-input demand.

Invalidate A when the change can alter demand detection, logic routing, output actuation or the physical response expected from the function.

### B — abnormal-operation / fault-injection evidence

Examples already preserved in manufacturer evidence include channel short, wire break, network loss and disagreement/fault behavior.

Invalidate B when the change can alter diagnostics, redundancy, wiring identity, fault detection, final-element monitoring or restart inhibition under fault.

### C — quantitative physical-performance evidence

Examples: stopping time/distance, physically measured reduced speed, brake holding performance, safety-function response time, pressure/motion/retention behavior where the actual architecture defines a criterion.

Invalidate C whenever the changed item can alter the physical performance on which safeguarding or safe motion depends. A configuration checksum cannot preserve C if the physical plant changed.

### D — periodic functional/proof-test evidence

Invalidate or revise D when component replacement, architecture change, duty change, proof-test method change or manufacturer requirement changes the periodic test obligation. Never copy an example interval into a different machine.

A change need not invalidate all four classes. The justification for every class retained as still valid must be explicit.

## 4. Require the right witness level

For every affected function, identify the strongest witness actually required by the hazard:

1. command/request state;
2. output/actuator command state;
3. actuator or safety-function status;
4. external-device/final-element physical feedback;
5. hazardous-energy-path state;
6. actual physical machine response;
7. quantitative performance acceptance.

Do not collapse these into a generic `SAFE=true` bit.

Examples from preserved evidence:

- EDM can prove external contactor contact state but not every hazardous energy path.
- STO status does not prove a gravity-axis brake can hold the required load.
- monitored valve position does not automatically prove downstream pressure is removed.
- a light-curtain receiver/alignment indication does not prove that field interruption causes the required machine response.
- displayed position does not prove physical position; Haas explicitly instructs comparison of displayed and physical crowning-sensor position during troubleshooting.

## 5. Separate installation/configuration restoration from validation

Installation evidence can include correct part identity, wiring, seal/connection condition, network identity, configuration ownership, checksum, parameter restoration, physical alignment and backup restoration.

Those are necessary where applicable, but do not relabel them as physical validation.

Freeze:

**INSTALLED CORRECTLY != FUNCTIONALLY VALIDATED != QUANTITATIVE PERFORMANCE ACCEPTED != PRODUCTION RELEASED.**

## 6. Challenge the affected function

Derive tests from the actual safety requirement and manufacturer/OEM procedure.

Where authoritative evidence requires it, include normal demand, representative faults, physical direction/mapping, actual final-element state and quantitative performance. If the required criterion is machine-specific and unavailable, mark it UNKNOWN rather than substituting a convenient number.

A failed test creates a repair/retest loop. Do not repeat until one favorable run appears and then call it accepted. Identify cause, repair it, and repeat the affected validation scope.

## 7. Requalify physical safeguarding

If stopping performance, safeguard geometry, machine layout, tooling, access path or protective-field geometry can have changed, explicitly requalify the installed safeguard against the current machine condition.

Freeze:

**STOPPING PERFORMANCE ACCEPTED != SAFEGUARD PHYSICALLY REQUALIFIED.**

**CONFIGURED FIELD/GEOMETRY != PHYSICAL FIELD/GEOMETRY VERIFIED.**

## 8. Keep personnel-clear/reset/rearm/start authorities separate

Return-to-service evidence does not itself command production motion.

Preserve:

`fault removed -> required validation complete -> safeguard restored/requalified -> personnel clear -> safety reset/rearm -> production release -> fresh ordinary START`

Reset is not START. A stale pre-reset START/JOG request must not become fresh post-reset motion authority merely because the safety chain becomes ready.

## 9. Production-release record

A durable release record should identify:

- changed item and reason;
- affected safety functions;
- evidence classes invalidated;
- evidence classes intentionally retained and why;
- tests performed and source/procedure revision;
- physical witnesses used;
- quantitative criteria and their authority, if applicable;
- failures, repairs and retests;
- safeguard requalification result;
- unresolved UNKNOWN items;
- person/role authorized to release the machine under the actual shop/OEM process;
- confirmation that a separate fresh ordinary START remains required.

## 10. Minimum-safe-to-operate disposition

If a required safety function or required physical acceptance criterion cannot be established, do not convert uncertainty into permission. The machine should not be operated with people exposed to the affected hazard. Any necessary experimental operation should be isolated/remote with people outside the danger zone and residual risk stated plainly.

## Human-factors review before closure

Before calling the change complete, ask whether the repair made the safeguard harder to use, test, align, reinstall or diagnose. If normal work now strongly incentivizes bypass, treat that inconvenience as a design defect and correct it where practical.

## LinuxCNC / FPGA boundary

LinuxCNC, HAL, the ordinary FPGA and HMI can retain maintenance state, inhibit ordinary commands, display safety status, reject stale commands, record test evidence and expose disagreement. They must not be promoted to independent personnel-safety authority merely because doing so simplifies software integration.

## Evidence provenance used to build this procedure

This procedure synthesizes already-preserved course evidence including Siemens component-replacement/acceptance procedures, ABB post-replacement function testing and physical reduced-speed measurement, Rockwell change-impact/partial-revalidation and fault-injection guidance, SICK/Rockwell enabling/reset authority, Rockford press-brake stopping/safeguard lifecycle evidence, Bosch Rexroth hydraulic final-element/recommissioning evidence, and the current Haas HPB installation/troubleshooting evidence.

Claims imported from those studies retain their original DOC-CONFIRMED/SOURCE-CONFIRMED status. This synthesis itself is an INFERENCE/engineering scaffold until applied and validated against a specific machine design.

## Compute

No executable compute was required to construct this procedure.
