# Validation Fixture Storage, Control, and Human-Factors Failure Analysis

Status: curriculum working artifact — independent Safety Lane B

## Purpose

Validation fixtures, jumpers, test plugs, force/simulation tools, temporary grounds, adapters, service keys, and diagnostic overrides can make testing practical. They can also become durable defeat mechanisms if their lifecycle is treated as a technician-memory problem.

This module asks a narrow architecture question: **how do we make the safe/restored state easier to achieve and harder to accidentally defeat after testing?** It does not define machine-specific PL/SIL/category, stopping distance, pressure, safe speed, hydraulic truth table, or proof-test interval.

## Evidence labels

Use: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, and `UNKNOWN`. `UNKNOWN` never means safe.

## Frozen architecture rule

**A fixture that can alter a safety-related signal, energy path, interlock state, or validation result must be controlled as a temporary machine configuration, not merely as a loose tool.**

Removing a software force does not prove a physical jumper was removed. Removing a jumper does not prove the original wiring was restored. Closing a cabinet does not prove a fixture is absent. An HMI `NORMAL` indication does not prove any of these physical facts unless an appropriately independent mechanism actually establishes them.

## Source-confirmed boundaries

- `SOURCE-CONFIRMED` — OSHA 29 CFR 1910.333(b)(2)(v)(A) requires tests/visual inspections as necessary before reenergization to verify tools, electrical jumpers, shorts, grounds, and similar devices have been removed so equipment can be safely energized.
- `SOURCE-CONFIRMED` — OSHA 1910.334(c)(2)-(3) requires electrical test instruments and associated leads/cables/probes/connectors to be visually inspected and appropriately rated for the circuit/equipment and environment.
- `SOURCE-CONFIRMED` — OSHA machine-guarding guidance says maintenance is not finished until guards are replaced, and return to service includes inspection that guards/safety devices are in place and functional plus checking the area before startup.
- `SOURCE-CONFIRMED` — OSHA LOTO guidance for testing/positioning treats temporary reenergization as a controlled transition: clear tools/materials and employees, energize only for the necessary test/positioning, then deenergize, isolate, and reapply energy control.

These sources establish useful restoration and test-equipment principles. They do **not** by themselves establish the safety performance of a particular OpenPressBrake fixture or machine.

## Human-factors failure paths

| Failure path | Why it is plausible | Architectural countermeasure | What still needs proof |
|---|---|---|---|
| Jumper left installed after test | Small, visually unobtrusive, test interrupted | bright/keyed captive fixture; fixture register; explicit physical removal gate | actual absence and restored wiring |
| Software force survives technician handoff | state may persist outside person's memory | force inventory visible at entry/exit; production mode refuses ordinary rearm while known force state exists | controller-specific persistence behavior |
| Fixture removed but original connector not restored | removal and restoration are separate actions | keyed parking/restoration checklist; independent connector-state inspection/challenge | correct wiring/function after restoration |
| Test plug stored beside production connector | convenient but easy to reinsert casually | controlled storage away from machine; unique ID; issue/return accounting | inventory accuracy |
| Adapter can mate with wrong channel | similar connectors and rushed maintenance | physical keying/polarization plus channel-specific identity | mis-mating resistance on actual hardware |
| Fixture powers circuit through USB/bench supply after machine isolation | hidden alternate energy path | explicit auxiliary-energy map; disconnect sequence; backfeed-resistant interface | actual backfeed behavior |
| Cabinet closed with leads still routed through door | visual closure mistaken for restoration | lead/tool sweep before closure; defined test-port architecture | physical absence |
| Technician assumes green HMI means restored | UI collapses command and physical state | HMI wording separates `NO KNOWN FORCE` from `PHYSICALLY RESTORED/TESTED` | independent restoration evidence |
| Reboot clears fixture accounting but hardware remains | software state is volatile; fixture is physical | reboot cannot promote UNKNOWN fixture state to clear; physical reconciliation required | implementation behavior |
| Spare/master service key becomes permanent bypass | convenience pressure | controlled custody, checkout, exceptional-use log, return verification | local administrative procedure |
| Shift change during active validation | ownership becomes ambiguous | explicit handoff state: machine remains TEST/OUT-OF-SERVICE until receiving person accepts configuration | procedure effectiveness |
| Fixture damaged but still used | schedule pressure | pre-use inspection; remove damaged fixture from service | electrical/mechanical fitness |

## Make the safer path easier

Human factors are part of the architecture. Prefer designs where:

1. The normal production connector is the easiest configuration to install correctly.
2. Test fixtures are conspicuous, uniquely keyed, and difficult to leave installed unnoticed.
3. A fixture has a defined storage location away from the production connection, so `fixture in storage` can be checked independently of software state.
4. Test ports minimize the need to defeat guards or disturb permanent wiring.
5. The test state is physically and visually obvious at the machine, not only on a remote HMI.
6. The restoration workflow is shorter and simpler than improvised bypass removal.
7. Production release requires a deliberate challenge of the affected safety function when the test configuration could have changed its physical path.

`INFERENCE` — these are design principles derived from the source-confirmed requirement to remove temporary test devices, restore safeguards, control test transitions, and inspect test equipment. Exact mechanisms remain design-specific.

## Fixture-control record

For each fixture capable of influencing a safety-related path, record:

| Field | Required record |
|---|---|
| Fixture ID | unique durable identifier |
| Purpose / bounded claim | what it is allowed to stimulate or observe |
| Forbidden uses | what it must never be used to claim or bypass |
| Connection points | exact intended machine/test ports |
| Energy sources introduced | USB, bench supply, field supply, battery, pneumatic/hydraulic, other |
| Isolation/backfeed implications | alternate paths created by installation |
| Keying/polarization | physical misconnection controls |
| Firmware/config revision | for active fixtures |
| Calibration/inspection state | when relevant |
| Storage location | controlled normal location |
| Issue/return owner | who has custody |
| Installed-state indication | physical/local indication, not just software echo |
| Removal/restoration evidence | how absence and original configuration are established |
| Post-removal challenge | affected safety function/test to repeat |
| Exceptions/deviations | unresolved `UNKNOWN`s and approvals |

## State model

Do not compress the lifecycle into `fixture_present`.

- `STORED / ACCOUNTED`
- `ISSUED / NOT INSTALLED`
- `INSTALLED / TEST CONFIGURATION`
- `REMOVAL CLAIMED / RESTORATION UNVERIFIED`
- `RESTORED / POST-REMOVAL CHALLENGE PENDING`
- `RESTORED / EVIDENCE COMPLETE`
- `UNKNOWN / ACCOUNTING CONFLICT`

Any reboot, lost record, unexplained inventory discrepancy, unplanned handoff, or physical/software disagreement should move the affected state toward `UNKNOWN`, not automatically toward production-ready.

## LinuxCNC / FPGA boundary

Ordinary LinuxCNC/HAL and the normal FPGA may:

- display test/configuration state;
- inhibit ordinary commands more restrictively;
- log fixture IDs and force inventories;
- reject stale commands after reconnect;
- require ordinary rearm after validation.

They do not become personnel-safety authority by tracking a fixture. A LinuxCNC flag cannot prove a jumper is physically absent, a guard is restored, an energy source is isolated, or a hydraulic final element is safe.

## Commissioning / maintenance questions

Before production release, answer with evidence rather than assumption:

- Are all temporary physical conductors, jumpers, grounds, adapters, test plugs and external energy sources accounted for?
- Are all software forces/simulations/diagnostic overrides cleared, and is their persistence across reboot/mode change understood?
- Is permanent wiring restored to the identified drawing/configuration revision?
- Were guards/interlocks disturbed, and if so are they physically restored and challenged?
- Could the fixture have bypassed a sensor, final element, feedback path, reset path, or independent witness?
- Did the fixture create a hidden backfeed or common-mode reference path?
- Does any inventory or observation conflict remain? If yes, release stays blocked/UNKNOWN.
- Was the affected safety function challenged after restoration at the physical layer the fixture could have altered?

## Adversarial exercises

1. A jumper is removed, but its original connector remains unplugged. Identify why `jumper absent` is insufficient.
2. LinuxCNC reports zero forces after reboot, but a physical test plug remains installed. Define the correct state.
3. A USB-powered fixture keeps a sensor interface energized with the main disconnect open. Trace the alternate energy path without assuming it is harmless.
4. A fixture is back in its cabinet slot, but another identical untracked fixture exists. Explain why storage occupancy alone is weak evidence.
5. A technician leaves mid-test and the next shift finds no notes. Define a fail-safe handoff state.
6. A bright keyed bypass plug is physically obvious but defeats both guard channels. Explain why visibility is not safety performance.
7. A post-removal software test passes while the physical guard actuator is misaligned. Identify the missing physical stimulus/witness.

## What remains UNKNOWN until established

- exact OpenPressBrake test-port pinout and safe ratings;
- fixture connector family and keying;
- whether any proposed fixture can backfeed specific field circuits;
- persistence semantics of specific controller forces/overrides;
- required proof-test interval or diagnostic coverage;
- machine-specific safe speed, pressure, stopping distance, hydraulic state, PL/SIL/category;
- which maintenance tasks qualify for any specific alternative-protection exception.

## Next independent study

Build a **safety commissioning package index / evidence manifest** only if it can add value beyond the existing `COMMISSIONING_PERIODIC_VALIDATION_EVIDENCE_WORKSHEET.md`. The manifest should link rather than duplicate existing worksheets and should expose missing/UNKNOWN evidence at package level. If that would duplicate primary-lane work, rotate instead to **safety configuration backup/restore provenance and disaster-recovery failure paths**: controller replacement, stale backups, parameter restores, firmware downgrade, lost signatures, field-wiring mismatch, and the validation boundary after recovery.