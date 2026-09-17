# Installed Safety Device Documentation / Identity Audit

Status: ACTIVE CURRICULUM ARTIFACT  
Date: 2026-09-17

## Purpose

Prevent a machine safety case from silently relying on the wrong manual, wrong revision, wrong device variant, wrong configured option, or documentation for hardware that is no longer installed.

This audit is deliberately independent of the maintenance-lifecycle/bypass-pressure worksheet. It asks a narrower question: **does every safety claim point to documentation and configuration evidence that actually belongs to the installed device and installed revision?**

## Evidence labels

Use `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, or `UNKNOWN` on substantive claims. Do not upgrade a claim merely because a document is from the correct manufacturer.

## Frozen rule

`installed physical identity -> installed configuration identity -> applicable manufacturer document/revision -> claimed function/constraint -> machine drawing/configuration mapping -> physical verification`

A break anywhere in this chain leaves the affected claim `UNKNOWN — NOT CLEARED` until resolved.

A matching family name is not enough. A manual for a related relay, drive, light curtain, valve, encoder, safety PLC module, firmware generation, option card, or connector variant cannot be assumed to describe the installed unit.

## Audit 1 — physical device identity

For every safety-relevant device or final element, record what can actually be observed or recovered from controlled records:

| Field | Record |
|---|---|
| Machine / asset ID | |
| Device role | |
| Manufacturer | |
| Exact model / ordering code | |
| Hardware revision | |
| Serial / date code if relevant | |
| Firmware / OS / safety package revision if relevant | |
| Installed option modules / plug-ins | |
| Connector / terminal variant | |
| Safety configuration signature / CRC if provided | |
| Drawing reference / wire numbers | |
| Physical location | |
| Evidence label | |

Photographs, labels, configuration exports and procurement records can support identity, but conflicting evidence must be reconciled rather than averaged together.

## Audit 2 — documentation applicability

For each safety claim, identify the exact document used and why it applies.

| Claim | Installed device | Document number/title | Document revision/date | Applicable model/firmware range | Exact section/page | Applicability status |
|---|---|---|---|---|---|---|
| Example: EDM wiring behavior | | | | | | |
| Example: reset/restart behavior | | | | | | |
| Example: STO input requirements | | | | | | |
| Example: guard-lock behavior | | | | | | |
| Example: valve monitoring indication | | | | | | |

Allowed applicability states:

- `MATCHED` — document scope explicitly covers installed identity/revision;
- `MATCHED WITH BOUNDED DIFFERENCE` — difference is known and shown irrelevant to this claim;
- `CONFLICT` — installed identity and document disagree;
- `UNKNOWN` — applicability has not been established.

Do not use a newer manual as proof of an older device's behavior unless the manufacturer explicitly preserves that behavior across the relevant revisions or independent evidence establishes it.

## Audit 3 — configuration-sensitive safety behavior

A correct manual may still be insufficient when behavior depends on configuration. Record all settings that can alter the safety function or its diagnostics, including as applicable:

- input evaluation / channel architecture;
- manual versus automatic reset/restart behavior;
- EDM/external-device-monitoring configuration;
- muting/blanking/bypass/setup modes;
- operating-mode selection;
- safe-drive function selection;
- safety field / zone selection;
- discrepancy/equivalence behavior;
- safety network mapping;
- output pulse/test behavior;
- configured device identities;
- firmware-dependent function blocks;
- protected parameters or checksums.

A manual saying a device *can* perform a function does not prove that the installed configuration actually performs it.

## Audit 4 — machine drawing versus installed field state

Trace each credited safety path both directions:

`protective device -> safety input -> safety logic -> safety output -> final element -> feedback/witness`

and

`drawing/configuration identifier -> terminal/wire -> installed device -> installed terminal -> physical final element`

Record discrepancies such as:

- wire number exists in drawing but lands on a different terminal in the cabinet;
- replacement device uses a different terminal assignment;
- drawing references an obsolete model;
- safety PLC project references a module revision no longer installed;
- EDM auxiliary contact differs from the documented contact arrangement;
- valve connector pinout differs across variants;
- drive option card or firmware generation changes safe-function wiring/behavior;
- protective-device field/zone configuration differs from commissioning record;
- LinuxCNC/HAL/FPGA diagnostics still name an old device and could mislead troubleshooting.

The installed field state is not automatically correct merely because it differs from the drawing; the drawing is not automatically correct merely because it is controlled. A discrepancy is a change-control/revalidation trigger.

## Audit 5 — safety authority versus ordinary-control documentation

Keep ordinary LinuxCNC/HAL/FPGA evidence separate from personnel-safety evidence.

LinuxCNC/HAL/FPGA documentation may establish:

- normal command intent;
- machine-state context;
- command freshness/watchdog behavior;
- diagnostic mapping;
- ordinary enable/rearm logic.

It does **not** by itself establish:

- safety-rated input evaluation;
- safety-controller diagnostic coverage;
- final contactor/valve physical state;
- drive safe-function integrity;
- hydraulic/gravity energy control;
- guard/protective-device performance;
- actual stopping distance or pressure/force behavior.

Do not let a convenient HAL pin name such as `safe`, `sto-ok`, `guard-ok`, or `valve-safe` become stronger evidence than the physical signal and manufacturer-defined function behind it.

## Audit 6 — superseded and uncontrolled documents

Flag:

- screenshots with no document number/revision;
- distributor pages paraphrasing safety behavior;
- forum wiring sketches presented as manufacturer requirements;
- manuals for successor/predecessor products;
- archived manuals with uncertain applicability;
- translated excerpts missing revision identity;
- machine drawings marked preliminary/as-built status unknown;
- local PDF copies whose provenance cannot be traced;
- configuration printouts without device/project/version identity.

These can remain useful leads or `COMMUNITY-REPORTED`/`INFERENCE` evidence, but must not silently become `DOC-CONFIRMED` proof.

## Audit 7 — minimum release gate

Before a safety claim is accepted into commissioning, periodic inspection, maintenance release, or incident reconstruction, answer:

1. What exact installed device and revision performs the function?
2. What exact configuration makes that function active?
3. What exact manufacturer document/revision defines the behavior being claimed?
4. Does that document explicitly apply to the installed identity/configuration?
5. Does the machine drawing/configuration map that documented function to the actual field wiring/final element?
6. What physical or functional verification confirms the installed result where the claim requires more than documentation?
7. Is any contradictory evidence unresolved?

Any safety-critical `CONFLICT` or `UNKNOWN` affecting the proposed operating state is not cleared by a successful normal production cycle.

## OpenPressBrake application

Apply this audit before importing safety assumptions from a reference press brake or generic component manual. In particular, preserve as `UNKNOWN` until machine evidence exists:

- exact safety relay/PLC and firmware/configuration;
- exact front/rear protective-device models and field geometry;
- exact guard switch/lock behavior;
- exact drive STO/safe-motion implementation;
- exact safety contactors and EDM contact mapping;
- exact hydraulic safety-valve identities, monitored positions and plumbing;
- exact accumulator/gravity restraint architecture;
- exact reset/restart/rearm chain;
- exact stopping, pressure, force and timing performance.

The proportional valve command path, LinuxCNC state, FPGA watchdog and HMI diagnostics remain ordinary-control/context evidence unless the actual safety architecture explicitly assigns and validates a safety role.

## Failure-path prompts

- The cabinet contains the right manufacturer but a different suffix. Which claimed terminal assignments or safety functions are now uncertain?
- The safety PLC project checksum matches the backup, but one I/O module was replaced with a later revision. Which claims require applicability/revalidation review?
- A drive manual found online describes STO, but the installed drive lacks the referenced safety option card. What remains proven?
- The electrical drawing shows two contactors in EDM, but the field auxiliary wiring monitors only one. Can the drawing or software state prove the second contactor?
- A light curtain family manual describes multiple resolutions/ranges and muting options. Which installed ordering code and configuration establish the actual protective behavior?
- A valve data sheet proves electrical ratings but does not expose the machine hydraulic circuit. Can it prove ram/gravity safety behavior? No; that physical energy path remains separately traceable and testable.

## Next-work handoff

Next independent branch: build `SAFETY_DOCUMENT_PROVENANCE_AND_SUPERSESSION_REGISTER.md` if the primary lane has not entered documentation-control work. It should track manufacturer source URL/document number, revision/date, applicable hardware/firmware range, retrieval date, supersession status, archived local copy identity, claim links, and unresolved applicability conflicts without treating a newer document as automatically applicable to older installed hardware.

No executable verification is required for this audit. Machine-specific physical values remain measurement/design evidence obligations.