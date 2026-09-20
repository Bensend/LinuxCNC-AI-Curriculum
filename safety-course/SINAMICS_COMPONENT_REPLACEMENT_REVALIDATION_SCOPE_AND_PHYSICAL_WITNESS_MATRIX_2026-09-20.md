# SINAMICS component replacement — revalidation scope and physical-witness matrix

Date: 2026-09-20
Primary lane: 4000 safety course

## Question

After a safety-related component is replaced, what does an authoritative manufacturer actually require before the affected safety function is treated as revalidated, and how does that map to the curriculum's four evidence classes?

## Sources and provenance

1. Siemens, *SINUMERIK Operate acceptance test*, Function Manual 07/2023 / current indexed successor material. **DOC-CONFIRMED.** Siemens states that hardware changes can require a new complete or partial acceptance test, and that before re-entering the danger area or resuming operation a simplified function test must be performed for all drives affected by component replacement. Safety-related component CRCs expose hardware changes.
2. Siemens, *SINAMICS S210 servo drive system Operating Instructions*, component replacement section. **DOC-CONFIRMED.** After motor replacement Siemens requires acknowledgement plus a reduced acceptance test: operate briefly in both directions to check actual-value sensing; for Extended/Advanced Functions, perform the bidirectional check with motion monitoring such as SLS/SSM active; after encoder replacement test encoder parameterization; record hardware/software data, changed checksum and timestamp and countersign the acceptance protocol.
3. Siemens, *SINAMICS G220 converter Operating Instructions*, §16.4. **DOC-CONFIRMED.** The replacement matrix is change-specific: encoder replacement requires an STO/SS1 test plus bidirectional traversing to check actual-value acquisition; replacement of the OM-SMT option module requires SMT function testing including short-circuit and wire-break tests; replacement of safety-related I/O such as an E-stop requires checking control of the affected safety functions; documentation requirements vary by change.
4. Siemens, *SINUMERIK Operate acceptance test*, Function Manual 07/2024, §8.2. **DOC-CONFIRMED.** The current replacement/modification table scopes different acceptance-test parts and supplementary measures to the changed hardware/configuration rather than declaring every replacement equivalent.

No OpenPressBrake-specific performance level, SIL, speed, stopping distance, hydraulic threshold, diagnostic coverage or proof-test interval is inferred from these examples.

## What the evidence proves

### 1. Replacement does not create production authority

Siemens explicitly warns that non-safe states are possible after component replacement and requires an affected-drive function test before re-entering the danger area or resuming operation.

Freeze:

**COMPONENT REPLACED != SAFE STATE PROVED != DANGER-ZONE REENTRY AUTHORIZED != OPERATION RESUMED.**

A successful boot, restored parameter file, or absence of an immediate fault is therefore not sufficient return-to-service evidence.

### 2. Revalidation scope follows the changed safety dependency

The 2024 SINUMERIK table does not prescribe one generic post-repair test. Encoder systems, Motor Modules, MCU hardware, PROFIsafe I/O, drive assignment, safety clock-cycle changes and acceleration/jerk changes invoke different acceptance-test portions or supplementary checks.

This supports the Lane-B impact-analysis rule:

**CHANGE MADE != REVALIDATION SCOPE KNOWN.**

The scope must be justified from what the changed component can invalidate.

### 3. Physical direction/actual-value mapping is an acceptance object

The S210 and G220 instructions deliberately command physical motion after relevant replacement. The axis is operated in both directions; for safety motion-monitoring functions Siemens calls for the check with monitoring such as SLS/SSM active. This is stronger than comparing configuration files or checksums.

Freeze:

**CONFIGURATION RESTORED != ACTUAL-VALUE SENSING CORRECT != DIRECTION MAPPING PHYSICALLY PROVED != SAFETY MOTION MONITORING REVALIDATED.**

A checksum identifies a configuration/hardware state. It does not prove that the physical machine moves, senses and reacts in the intended direction.

### 4. Some replacements require deliberate abnormal/fault challenge

The G220 OM-SMT replacement procedure explicitly requires short-circuit and wire-break tests. This is a direct manufacturer example where post-replacement revalidation includes abnormal/fault evidence rather than only a happy-path demand.

Freeze:

**NORMAL FUNCTION PASSED != REQUIRED WIRING/FAULT DIAGNOSTICS REVALIDATED.**

### 5. The final acceptance record is part of the evidence chain

Siemens requires changed checksums, relevant hardware/software data and acceptance-protocol completion/countersignature for applicable changes. Documentation is not a substitute for physical tests, but neither should physical testing be detached from the configuration identity that was tested.

Freeze:

**TEST PERFORMED != TESTED CONFIGURATION IDENTIFIED != ACCEPTANCE RECORD COMPLETE.**

## Four-class validation mapping

| Change / check | A — normal-demand function | B — abnormal/fault injection | C — quantitative physical performance | D — periodic proof test | What remains unproved |
|---|---|---|---|---|---|
| Encoder replacement: STO/SS1 + bidirectional traversing | Yes | Not inherently | Physical mapping/actual-value behavior, but not necessarily a quantitative stopping-performance test | No | Machine-specific stopping distance/time and safeguard placement unless separately measured |
| S210 motor/encoder-related actual-value recheck with SLS/SSM active | Yes | Not inherently | Physical direction and monitored-motion behavior | No | Application-specific safe-speed/stopping acceptance limits unless the relevant acceptance test measures them |
| OM-SMT option-module replacement | Yes | Yes: short circuit + wire break | Not established by this replacement row | No | Other physical machine performance |
| Safety-related I/O replacement such as E-stop | Yes: affected safety functions | Only if required by the affected device/function procedure | Not automatically | No | Final-element performance unless separately included |

This is deliberately not forced into “all four classes every time.” The change impact determines which evidence classes are necessary. The important rule is to name what was invalidated and what the chosen tests actually re-establish.

## Return-to-service chain supported by Siemens

For the component-replacement cases above, the strongest defensible chain is:

`named change -> changed/affected safety dependency identified -> replacement acknowledged/configuration identity updated -> prescribed affected-function test -> physical actual-value/direction test where applicable -> representative fault challenge where explicitly required -> acceptance record/checksum completion -> danger-zone reentry / operation may resume only after required testing`

This is materially stronger than `repair -> machine runs -> return to production`.

## Boundary: what this source package does not prove

The indexed Siemens procedures do **not** establish one universal end-to-end machine return-to-production checklist that also proves every external guard, retained-person condition, hydraulic final element, stale ordinary command, and fresh production START after every possible component replacement. Those remain application/change dependent.

Therefore:

**REDUCED ACCEPTANCE TEST COMPLETE != EVERY MACHINE SAFEGUARD REQUALIFIED UNLESS THE IMPACT ANALYSIS INCLUDED IT.**

**DRIVE SAFETY REVALIDATED != HYDRAULIC/MECHANICAL HAZARD PATH REVALIDATED.**

**ACCEPTANCE RECORD COMPLETE != FRESH ORDINARY START AUTOMATICALLY AUTHORIZED.**

## Curriculum use

For OpenPressBrake and other LinuxCNC machines, teach post-change validation as dependency-directed evidence collection:

1. Name the changed component/configuration and the safety functions it can affect.
2. Identify which field sensors, final elements, mappings, timing/performance quantities and safeguards can have been invalidated.
3. Select evidence classes A/B/C/D only where justified, but never substitute configuration identity for physical witness.
4. Preserve independent safety authority. LinuxCNC/ordinary FPGA diagnostics may record results but do not self-authorize personnel safety merely because normal control behaves correctly.
5. Require a separate return-to-service decision after the affected safety evidence is complete; where unexpected restart is hazardous, ordinary motion still requires the established reset/rearm and fresh-start semantics.

## Information-gain disposition

This closes the generic question “does a manufacturer actually scope post-replacement acceptance tests to the changed safety dependency and sometimes require physical motion or deliberate fault injection?” at DOC-CONFIRMED level.

The higher-value remaining branch is a machine/OEM procedure that explicitly couples a safety-related repair to **quantitative machine performance** (for example measured stop time/distance or holding capability), physical safeguard requalification/repositioning if required, and explicit release to production. Prefer a press/press-brake or another high-energy machine. Do not reopen generic drive replacement cataloging unless new evidence adds that downstream physical/safeguard layer.

## Compute

No simulation, build, synthesis, benchmark or test-suite compute was justified. No GitHub-hosted runner was used.
