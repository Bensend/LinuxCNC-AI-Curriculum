# Change-Boundary Escape and Revalidation-Scope Worksheet

Date: 2026-09-17
Status: DURABLE SAFETY CURRICULUM ARTIFACT
Priority: 4000 safety course

## Purpose

This worksheet prevents a common commissioning/maintenance error: declaring a change "outside safety" because the edited object is ordinary LinuxCNC/HAL/FPGA/HMI, a non-safety controller routine, a network setting, firmware, or a replacement device whose safety program appears unchanged.

Frozen rule:

> Revalidation scope follows every dependency by which a change can alter a safety function or the physical hazardous-energy result. It does not stop at the file, controller, board, or organizational boundary where the change was made.

A narrow revalidation scope is acceptable only after the boundary has been positively shown not to escape into a safety-relevant dependency.

This artifact complements `DISASTER_RECOVERY_CHANGE_IMPACT_REVALIDATION_MATRIX.md`; it focuses on **scope escape through indirect/shared dependencies** rather than repeating the component-by-component replacement matrix.

## Evidence vocabulary

Use repository labels literally: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, `UNKNOWN`.

## 1. The scope-escape question

For every proposed change, trace:

`changed object -> direct outputs/state -> shared timing/data/power/configuration/physical dependency -> safety function(s) that can observe or depend on it -> final element -> physical hazard result`

Then trace the reverse path:

`physical final element/feedback -> safety input/EDM/diagnostic -> reset/rearm/mode logic -> ordinary-control interface -> changed object`

A change is not "non-safety" merely because it is absent from the safety program. It is non-safety-relevant only if the dependency trace shows it cannot affect a required safety behavior, safety input interpretation, safety output authority, reset/restart condition, mode, diagnostic coverage, or physical hazard exposure.

## 2. Authoritative anchor points

### Rockwell GuardLogix

`DOC-CONFIRMED`: Rockwell's current GuardLogix documentation states that changes to safety-signature elements require revalidation. Safety-signature elements include the safety application, controller attributes, tags/tag mapping, task/program/routines, safety AOIs, and safety-I/O configuration.

`DOC-CONFIRMED`: Rockwell also explicitly warns that edits confined to standard routines still require the engineer to ensure that **timing and tag mapping** remain acceptable to the safety application. For safety-program changes, all affected elements identified by impact analysis must be revalidated; modification records include authorization, impact analysis, execution, tests, and revision information.

`INFERENCE`: therefore "standard code only" is not a sufficient closure argument. A standard task can escape its nominal boundary through mapped data, timing, mode/request signals, reset/start interfaces, shared resources, or changed assumptions used by the safety task.

### Siemens Safety Integrated

`DOC-CONFIRMED`: Siemens states that acceptance testing is required when Safety Integrated functions are commissioned or changed. Its acceptance-test guidance records safety-relevant components/software versions, safety functions, test results, safety parameters, checksum, date, and tester confirmation.

`DOC-CONFIRMED`: Siemens also describes partial acceptance as potentially appropriate for some hardware changes, software upgrades, functional enhancements, or transferred commissioning data, but the allowed depth depends on the change and affected safety functions. Current SINUMERIK Safety Integrated guidance warns that changes to accepted safety functions can cause unwanted motion and requires a new acceptance test after such changes.

`DOC-CONFIRMED`: Siemens cautions that measured acceptance-test distances/times are typical observations, not worst-case values from which maximum overtravel may be derived.

`INFERENCE`: a prior acceptance report is baseline evidence, not a blanket permission to scope later tests narrowly. The change dependency determines which functions and physical paths must be re-challenged.

## 3. Boundary-escape matrix

| Change that may look ordinary/local | Hidden escape path to check | Evidence that may remain valid | Gate that must reopen if dependency exists | Minimum physical question |
|---|---|---|---|---|
| LinuxCNC HAL rewiring | safety reset, mode request, permissive, shared sensor, output request, stale command after safety recovery | independent safety logic/config identity if truly untouched | reset/restart, mode integrity, stale-command/rearm, affected final-element challenge | Can the changed HAL state make hazardous motion effective without a new deliberate safe operating sequence? |
| LinuxCNC task/PLC timing change | timing of mapped request, heartbeat, watchdog, reset pulse, mode transition, sequencing assumed by safety logic | independent safety hardware evidence not timing-dependent | interface timing and fault/recovery tests | Does delay, jitter, held state, or reordered sequence create an unsafe accepted state? |
| FPGA firmware/I/O-map change | pin remap, polarity, output default, watchdog, feedback mapping, shared sensor preprocessing | independent safety system evidence only if FPGA is outside all safety dependencies | field correspondence, stale/fresh authority, feedback integrity, startup/power-cycle | Can a remapped/default/stale FPGA output energize an actuator when safety permits normal operation? |
| HMI update | combined reset/start control, hidden mode selection, retained command, bypass/muting UI, misleading status | physical safeguard evidence unrelated to HMI | reset/start separation, mode integrity, human-factors/defeat review | Can one HMI action restore safety readiness and simultaneously request hazardous action? |
| Standard/non-safety PLC routine edit | mapped tags, timing, mode/request generation, reset/restart, safety input preprocessing | safety signature may remain identity evidence for unchanged safety application | impact analysis on mapped/timing dependencies | Does the safety application receive a materially different value or timing pattern? |
| Network/IP/topology change | safety-device identity, routing, SNN/connection ownership, loss/recovery semantics, stale distributed command | unrelated local hardwired safety paths | device identity, network-fault recovery, rearm | After loss/recovery, can old data or wrong-device data regain authority? |
| Controller/drive firmware update | compiler/runtime behavior, safety-signature compatibility, initialization, diagnostics, safe-motion implementation | hazard analysis and unaffected physical inventory | manufacturer-defined impact/acceptance scope, startup/fault persistence | Does the affected safety function still reach the required physical result after update and reboot? |
| Replacement safety I/O with automatic configuration | correct configuration but wrong field correspondence/device identity, replacement-state assumptions | upstream requirements/design | device identity/keying/SNN/config plus real channel challenge | Does each real sensor/final element still correspond to the intended safety channel? |
| Protective-device parameter/field change | blanking/muting/zone geometry, restart interlock, detection coverage | unrelated final-element evidence | protective-field geometry + full affected safety function | Is the hazard reachable without generating the required demand? |
| Contactor/valve replacement with same electrical interface | changed feedback behavior, response, failure mode, mechanical/fluid function | upstream demand logic | EDM/feedback integrity + physical final-element challenge | Does OFF command actually create the required physical energy-control state, and is failure detected? |
| Shared 24-V/control-power redesign | simultaneous loss or false state across redundant channels, sensors, feedback, safety outputs | logic independent of supply assumptions | CCF/power-loss/power-return analysis | Can one supply/common fault defeat both channels or manufacture a false-safe feedback state? |
| Connector/harness consolidation | formerly separated channels now share connector/common/route | software/config evidence | CCF + wiring correspondence + channel fault injection where justified | Can one connector/common/short/open defeat nominal redundancy? |
| Mechanical guard/service-access redesign | new reach-around, trapped-person, defeat incentive, actuator misalignment | safety logic identity | guarding geometry, escape/occupancy, defeat resistance | Can a person enter/remain in danger while safety logic believes access is protected? |

## 4. Revalidation-scope levels

Use these as **scope labels**, not safety-performance ratings.

### R0 — documentation/correspondence only

Allowed only when the change cannot affect any safety-function dependency and this is positively demonstrated. Update provenance/baseline records. No claim about physical behavior is newly created.

### R1 — interface revalidation

Use when the safety architecture is unchanged but an ordinary/safety boundary signal, mapped tag, timing assumption, network identity, or diagnostic interface changed. Re-test affected boundary states including fault, recovery, reset/rearm, and stale/held values.

### R2 — safety-function revalidation

Use when a sensor, safety logic element/configuration, mode/reset path, safety I/O, final element, or feedback dependency changed. Re-challenge every affected safety function from demand to physical final element and feedback/restart behavior.

### R3 — physical hazard-path revalidation

Use when the change affects energy removal/control, stopping/holding, protective geometry, hydraulic/pneumatic path, drive safe motion, mechanical restraint, or another dependency that determines the actual hazardous result. Re-establish the physical result under a bounded safe test plan. Machine-specific values remain `UNKNOWN` until measured/calculated from authoritative design evidence.

### R4 — safety-concept/risk-assessment reopen

Use when the change creates a new operating mode, hazard, access path, energy source, automation/robot interaction, bypass/muting behavior, substantially different performance, or invalidates the assumptions behind the selected safety functions. Do not treat this as merely a commissioning retest.

A change may require several levels simultaneously. The highest label does not erase lower-level interface/correspondence tests.

## 5. Mandatory scope-escape gates

Before approving a narrow scope, answer all of these:

1. **DATA** — Can changed data, mapping, scaling, polarity, validity, freshness, or default state enter a safety decision or a normal command that becomes effective after safety recovery?
2. **TIME** — Can changed timing, scheduling, watchdog behavior, sequencing, or communication recovery alter a safety assumption?
3. **POWER** — Did a supply, common, fuse, connector, grounding, or isolation change create a common-cause path?
4. **MODE** — Can the change select, request, retain, or misrepresent a less-protective operating mode?
5. **RESET/START** — Can the change merge reset/rearm with a start/motion request or preserve a stale request through recovery?
6. **FEEDBACK** — Can the change alter, mask, synthesize, share, or mis-map EDM/final-element feedback?
7. **PHYSICAL PATH** — Did anything affecting electrical isolation, STO/safe motion, brake, hydraulic/pneumatic control, gravity restraint, guarding geometry, or hazardous energy change?
8. **DIAGNOSTICS** — Can the change suppress a fault, widen a discrepancy/timing window, alter proof-test behavior, or create a latent undetected fault?
9. **HUMAN FACTORS** — Did the change make correct safeguard use harder, bypass easier, status less clear, or maintenance/setup more likely to defeat protection?
10. **BASELINE** — Can the installed hardware, firmware, configuration, drawings, and physical machine still be bound to the prior validated baseline?

Any unresolved safety-relevant answer is `UNKNOWN`; the affected exposed operating state is not cleared.

## 6. LinuxCNC/OpenPressBrake architecture rule

Ordinary LinuxCNC/HAL and the normal FPGA may:

- issue normal motion/current/valve requests;
- report diagnostics and safety-system status;
- maintain command-freshness/watchdog containment;
- require ordinary-control rearm after faults;
- refuse normal motion when baseline correspondence is incomplete.

They must not become the sole personnel-safety authority merely because doing so makes change management easier.

For OpenPressBrake specifically, treat changes to proportional-current commands, SPI/ADC mappings, watchdogs, output polarity/defaults, mode/reset interfaces, or feedback routing as potential **boundary-escape** changes even when the independent safety controller and safety final elements are physically untouched. The revalidation question is whether those changes can alter what happens when independent safety authority permits normal operation or when safety is restored after a demand.

## 7. Change record template

For every safety-relevant change record:

- change ID / date / reason;
- before and after baseline identities;
- exact changed objects;
- affected machine modes and hazards;
- DATA/TIME/POWER/MODE/RESET/FEEDBACK/PHYSICAL/DIAGNOSTIC/HUMAN-FACTORS/BASELINE gate results;
- dependencies proven unchanged and evidence supporting that conclusion;
- selected R0–R4 scope(s) with rationale;
- tests/challenges performed and raw observations;
- retained, narrowed, or invalidated prior evidence;
- unresolved `UNKNOWN`s and operating restrictions;
- new validated baseline identity when complete.

## 8. Compute decision

No compute is justified. The unresolved work is authoritative-document interpretation, dependency tracing, and physical validation scope. No GitHub-hosted Actions minutes or self-hosted runtime were consumed.

## 9. Sources

- Rockwell Automation, GuardLogix 5580 / Compact GuardLogix 5580, `Safety Signature Elements`, current online documentation.
- Rockwell Automation, GuardLogix 5580 / Compact GuardLogix 5580, `Edit a Safety Application`, current online documentation.
- Rockwell Automation, GuardLogix 5580 / Compact GuardLogix 5580, `Safety I/O Device Replacement`, current online documentation.
- Siemens, `Acceptance test for the safety functions of a SIMATIC MICRO-DRIVE PDC/PDC-F drive`, Entry ID 109780463, V1.1, 07/2020.
- Siemens, `Safety Integrated`, Function Manual 07/2024, A5E52052187B AD.

## 10. Next evidence-gain branch

Apply this worksheet to one concrete cross-boundary OpenPressBrake change: an ordinary FPGA/HAL I/O-map or command-freshness change. Trace the command from LinuxCNC/HAL through transport/FPGA/output request, independent safety authority, final element, and physical actuator; identify exactly which R0–R4 gates reopen without inventing hydraulic or stopping facts.
