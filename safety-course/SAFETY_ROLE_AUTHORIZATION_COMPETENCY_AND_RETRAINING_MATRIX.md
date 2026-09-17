# Safety Role Authorization, Competency, and Retraining Matrix

## Purpose

A technically sound safeguard can still fail in use when the person operating, servicing, resetting, bypassing for a controlled test, validating, or releasing the machine does not have the authority and competence required for that action. This worksheet keeps **role**, **authorization**, **demonstrated competence**, and **machine state** separate.

It is intentionally independent of the LinuxCNC/HAL/FPGA permission model. A login, UI button, HAL pin, FPGA command, key switch, or possession of a password can restrict ordinary control, but does not by itself establish personnel-safety competence or authority.

## Frozen rule

**Access is not authorization; authorization is not competence; training attendance is not demonstrated competence; competence on one machine/configuration is not automatically competence after a material change.**

For every safety-relevant task, identify who may perform it, what they must understand and demonstrate, which hazardous-energy boundaries apply, and what changes or observed deficiencies trigger review/retraining.

## Evidence classes

Use the repository provenance vocabulary without promotion:

- **SOURCE-CONFIRMED** — directly established by inspectable authoritative source material.
- **DOC-CONFIRMED** — established by applicable manufacturer/official documentation.
- **TEST-CONFIRMED** — established by a controlled test with bounded scope.
- **COMMUNITY-REPORTED** — useful experience report, not authoritative proof.
- **INFERENCE** — engineering conclusion derived from evidence; identify premises.
- **UNKNOWN** — not established. UNKNOWN does not become acceptable through familiarity or production history.

## Role matrix

| Role / task | Typical authority boundary | Minimum competency evidence | Safety-state prerequisites | Prohibited assumption |
|---|---|---|---|---|
| Normal operator | Normal production controls only | Machine-specific operating hazards, safeguards, stop/E-stop behavior, prohibited defeat, abnormal-state response | Machine released for operation; guards/protective functions available as required | `Can run machine = can service/reset safety system` |
| Setup/operator-adjustment | Approved setup functions only | Setup-mode hazards, permitted reduced/limited functions, enabling-device or protective-mode behavior where applicable | Correct validated mode; no unapproved safeguard defeat | `Setup mode = unrestricted maintenance mode` |
| Authorized servicing/LOTO worker | Apply/remove assigned hazardous-energy controls and perform bounded service | Recognize applicable hazardous-energy sources; isolation/control methods; stored/reaccumulating energy; verification | Task-specific isolation/control established and verified | `Machine Off / E-stop / zero command = energy isolation` |
| Safety reset/restart operator | Perform the defined reset/restart sequence | Difference among acknowledgement, safety reset, normal-control rearm and START; area-clear/sightline requirements | Cause removed; required protective devices restored; restart conditions satisfied | `Reset = permission to start` |
| Controlled test/positioning worker | Temporary energized test only under defined procedure | Exact test purpose, temporary safeguards, personnel exclusion, restoration to isolation, stop criteria | Only the minimum energy/functions needed; bounded test state | `Diagnostic need justifies general bypass` |
| Safety configuration maintainer | Read/change approved safety configuration | Exact device/configuration tool, configuration identity/signature semantics, change control, required revalidation | Controlled change authorization; baseline captured | `Valid CRC/signature = field hardware physically correct` |
| LinuxCNC/HAL/FPGA maintainer | Ordinary-control configuration and diagnostics | Normal-control authority boundary, stale-command/rearm behavior, watchdog semantics, safety interface mapping | Independent safety authority remains intact | `Ordinary controller can substitute for personnel-safety authority` |
| Validator/commissioning witness | Challenge claims and record bounded evidence | Test method, expected evidence layers, independence/common-cause concerns, installed-document applicability | Controlled commissioning/test plan; safe test setup | `Designer assertion or HMI state = independent validation` |
| Return-to-service releaser | Release only within defined organizational authority | Change impact, unresolved UNKNOWNs, restoration evidence, configuration identity, physical final-element/energy-path evidence | Required revalidation complete; temporary measures removed/reconciled | `Repair succeeded = all prior safety claims restored` |

The organization may combine roles in a small shop, but the **logical roles must remain distinguishable**. One person wearing several hats does not eliminate the need to perform each required check.

## Hazard-specific competency map

Do not issue a generic `MAINTENANCE QUALIFIED` label. Record competency against the hazards and tasks actually present.

| Competency domain | Worker must be able to identify / demonstrate | OpenPressBrake status |
|---|---|---|
| Electrical hazardous energy | Sources, disconnect/isolation points, stored electrical energy, verification method | Machine-specific details **UNKNOWN** until installed evidence is captured |
| Hydraulic energy | Pump/pressure sources, accumulator/stored pressure, trapped pressure, gravity interaction, safe dissipation/restraint method | Exact circuit/truth table/pressure behavior **UNKNOWN** |
| Gravity / ram / mechanical storage | Elevated or movable members, blocking/restraint points, springs/mechanical storage, safe placement/removal sequence | Exact machine restraint method **UNKNOWN** |
| Pneumatic/auxiliary energy | Sources, stored volume, isolation/dump behavior, actuators that can move unexpectedly | Installed scope **UNKNOWN** |
| Protective devices | What hazard each device addresses, expected response, what loss/fault means | Device-specific mapping **UNKNOWN** |
| E-stop | Intended emergency function and limits; distinction from servicing isolation | Architecture must remain independent of ordinary LinuxCNC authority |
| Reset/rearm/start | Separate state transitions and area-clear responsibilities | Machine-specific sequence **UNKNOWN** until validated |
| Safety final elements | Contactors/STO/valves/brakes or other credited elements and what their feedback proves | Exact installed implementation **UNKNOWN** |
| Ordinary controller | LinuxCNC/HAL/FPGA command, watchdog, diagnostics and rearm behavior; limits of its safety authority | Ordinary control is not sole personnel-safety authority |
| Change/replacement control | When hardware, firmware, wiring, plumbing, guards or configuration invalidate prior evidence | Use existing change/revalidation artifacts |

## Authorization record

For every person authorized for a safety-relevant task, record at minimum:

| Field | Record |
|---|---|
| Person / role | Named individual and logical role(s) |
| Machine / equipment scope | Exact machine or bounded equipment family |
| Authorized task scope | Normal operation / setup / LOTO / controlled energized test / safety configuration / validation / release, etc. |
| Hazard domains covered | Electrical / hydraulic / pneumatic / gravity / mechanical / other |
| Procedure/document identities | Exact applicable procedure revisions |
| Training date | Date completed |
| Demonstrated competency evidence | Observation, practical demonstration, supervised task, exam, or other bounded evidence |
| Assessor / authorizer | Person responsible for competency/authorization decision |
| Configuration baseline | Machine/configuration revision for which competence was demonstrated when material |
| Restrictions | Explicit exclusions or supervision requirements |
| Retraining/review triggers | Changes, deficiencies, incidents, long-unused specialist tasks, procedure revisions, etc. |
| Current status | AUTHORIZED / SUPERVISED-ONLY / SUSPENDED-PENDING-REVIEW / NOT AUTHORIZED |

Do not infer authorization from employment title alone.

## Retraining and reauthorization triggers

**SOURCE-CONFIRMED:** OSHA 29 CFR 1910.147(c)(7) requires training for hazardous-energy control and retraining when job assignments change, machines/equipment/processes present a new hazard, energy-control procedures change, or inspection/other evidence reveals deviations or inadequacies in knowledge/use. OSHA also requires training certification to be kept up to date.

Use that as a concrete floor for covered hazardous-energy work, while treating the broader machine-safety list below as an engineering curriculum rule rather than claiming every item is an OSHA mandate:

- machine or process change introduces a new hazard or materially changes exposure;
- energy-control procedure or isolation point changes;
- safety controller, protective device, final element, hydraulic/pneumatic architecture, guard, or safety configuration changes in a way relevant to the worker's task;
- reset/restart/rearm procedure changes;
- LinuxCNC/HAL/FPGA change alters normal-control behavior at a safety-system interface;
- periodic inspection or incident review exposes incorrect practice, uncertainty, defeat, or knowledge gaps;
- worker uses an undocumented shortcut, jumper, force, override, or bypass;
- a previously authorized task expands into a hazard domain not covered by the worker's demonstrated competence;
- documentation supersession changes the applicable procedure or device behavior.

Do **not** invent a universal retraining interval where no applicable rule, risk assessment, manufacturer instruction, or organizational policy establishes one.

## Periodic inspection independence

**SOURCE-CONFIRMED:** For OSHA-covered LOTO periodic inspections, 29 CFR 1910.147(c)(6) requires an authorized employee other than the employee(s) using the procedure being inspected to perform the inspection, correct deviations/inadequacies, review responsibilities, and certify the inspection. The certification identifies the machine/equipment, date, employees included, and inspector.

Curriculum implication: where a check is intended to detect drift in how a safety procedure is actually used, avoid making it a self-certification ritual. Preserve enough independence to challenge habitual shortcuts. Do not generalize OSHA's exact LOTO inspection rule into a claim that every functional-safety validation must use the same personnel arrangement; apply the requirement to its actual scope.

## Human-factors / bypass-pressure test

Authorization controls should make the safe path easier, not merely add passwords.

During review, ask:

- Can the authorized worker reach the correct isolation/blocking information quickly?
- Are isolation points and stored-energy hazards identifiable at the machine?
- Is the approved test/setup path practical enough that workers are not pushed toward jumpers or undocumented forces?
- Does the HMI distinguish alarm acknowledgement, safety reset, normal rearm, and START?
- Are diagnostics useful without granting ordinary LinuxCNC/HAL/FPGA authority over the independent safety function?
- Can a worker tell which UNKNOWN requires engineering help rather than guessing?
- Are replacement procedures and applicable manufacturer documents easy to retrieve?
- Does a person returning after a machine/configuration change receive the changed information before resuming the affected task?

A safeguard or procedure that is routinely defeated because correct service is impractical is an engineering problem requiring root-cause review, not evidence that the bypass should become normal practice.

## Small-shop implementation

A home or small-shop project may have one technically responsible person. Keep the process lightweight but preserve the distinctions:

1. identify the role being performed now;
2. identify the hazardous energy and protective functions relevant to the task;
3. use the current applicable procedure/document baseline;
4. verify isolation/physical state rather than relying on controller indications;
5. for energized testing, define the question, minimum necessary energy, exclusion/guarding, stop condition, and restoration step;
6. after changes, perform scoped revalidation before normal operation;
7. record unresolved safety-critical items as **UNKNOWN — NOT CLEARED** rather than relying on memory.

Where independent review is not practically available, record that limitation. Do not rename self-review as independent validation.

## Evidence consulted

- OSHA, 29 CFR 1910.147, Control of hazardous energy, especially (c)(4), (c)(6), (c)(7), and (e). **SOURCE-CONFIRMED.**
- OSHA, LOTO periodic-inspection guidance/eTool: inspection purpose, authorized inspector independence, responsibility review, correction of deficiencies, and certification fields. **SOURCE-CONFIRMED.**
- OSHA interpretation on LOTO program documentation/certification: energy-control procedures, periodic-inspection records, and current training certification. **SOURCE-CONFIRMED.**
- Pilz MYZEL lifecycle material: machine inspections, employee qualifications, validation/maintenance documentation and lifecycle record management as a professional implementation example. **DOC-CONFIRMED** for the product/workflow description; not used as a normative requirement.

## Release boundary

This matrix does not establish machine-specific PL/SIL, diagnostic coverage, stopping time/distance, hydraulic truth table, pressure/force threshold, safe speed, safe distance, proof-test interval, or competency duration. Those remain **UNKNOWN** until applicable evidence establishes them.

No simulation or executable verification is justified for this role/competency question.