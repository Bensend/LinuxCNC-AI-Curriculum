# Safety Document Provenance and Supersession Register

## Purpose

A safety claim is only as good as the evidence that actually applies to the installed device, firmware/configuration, machine revision, and safety function being claimed. This register prevents a common maintenance/retrofit failure: retaining a manual, certificate, application note, drawing, or configuration record that is authentic but no longer applicable to the installed state.

Use this with `INSTALLED_SAFETY_DEVICE_DOCUMENTATION_IDENTITY_AUDIT.md`, configuration-baseline control, replacement-equivalence validation, commissioning/validation, and the maintenance lifecycle.

## Evidence rule

Freeze the chain:

`installed identity -> installed firmware/configuration -> applicable document identity/revision -> applicable hardware/firmware range -> exact claim -> machine mapping -> physical verification`

If any safety-critical link is unresolved, classify the affected claim **UNKNOWN — NOT CLEARED**. Do not substitute a newer manual, similar catalog number, successor product, distributor page, remembered setting, or software CRC without proving applicability.

## Register fields

For every document used to support a safety-relevant claim, record:

| Field | Required record |
|---|---|
| Evidence ID | Stable local identifier used by worksheets/claims |
| Manufacturer / authority | Publisher responsible for the document |
| Document title | Exact title |
| Publication / document number | Exact manufacturer or standards identifier |
| Revision / edition | Exact revision, issue, edition, language suffix where relevant |
| Publication date | Date printed/published by the authority |
| Retrieval date | UTC date the evidence was retrieved |
| Authoritative source | Manufacturer/standards-body location; retain URL in the evidence ledger |
| Archived-copy identity | Controlled local filename plus hash or immutable repository/artifact identity when licensing permits storage |
| Installed hardware identity | Exact model/catalog number, suffix/options, hardware revision |
| Installed firmware/software identity | Exact firmware/software/configurator revision where applicability depends on it |
| Applicability range | Hardware, firmware, accessory, option, regional, language, machine or configuration range stated by the document |
| Safety function/claim IDs | Exact claims this document supports; never cite an entire manual as blanket proof |
| Supersession state | CURRENT / SUPERSEDED-APPLICABLE / SUPERSEDED-NOT-APPLICABLE / WITHDRAWN / UNKNOWN |
| Superseded by | New document/revision if known |
| Change impact reviewed | YES/NO plus reviewer/date and affected claim IDs |
| Conflict links | Other evidence that differs or narrows applicability |
| Evidence class | DOC-CONFIRMED / SOURCE-CONFIRMED / TEST-CONFIRMED / COMMUNITY-REPORTED / INFERENCE / UNKNOWN |
| Physical verification required | What installed-state check remains necessary |
| Disposition | ACCEPT / ACCEPT-WITH-BOUNDS / HOLD-UNKNOWN / RETIRE-FROM-ACTIVE-CLAIMS |

## Supersession is not deletion

Never erase an older document merely because a newer revision exists. Preserve the old evidence when it was the applicable basis for an installed/validated configuration. Mark its status and relationship to the newer revision.

A newer revision can do at least four different things:

1. clarify wording without changing the installed safety claim;
2. add support for newer hardware/firmware while the older revision remains the applicable installed reference;
3. change a configuration, restriction, diagnostic, validation, or replacement rule that requires impact review;
4. remove/withdraw a prior claim or reveal that the old evidence should no longer be relied upon.

Do not assume which case applies. Compare revision/change history and applicability.

## Firmware and configuration coupling

**DOC-CONFIRMED:** Rockwell GuardLogix documentation makes safety behavior/version applicability explicitly firmware-dependent. Current documentation distinguishes firmware revision 38-or-later behavior from revision 37-or-earlier behavior for safety-signature generation, and documents hardware/firmware incompatibility states. Therefore a manual/revision without the installed firmware context is incomplete evidence for version-sensitive claims.

**DOC-CONFIRMED:** Rockwell's GuardLogix safety reference documents that a controller firmware release changes the controller safety signature and is intended to force some functional-controller validation even where the safety application itself has not changed. It also documents exceptional cases where the safety-application signature may change across software/firmware releases. Treat firmware updates as change-control events, not clerical updates.

**DOC-CONFIRMED:** Rockwell instructs users to record the safety signature and compare it after downloads. Deleting a safety signature to make safety-related changes requires some level of retest/revalidation. A matching signature is evidence about the bounded signed configuration, not proof of unchanged field wiring, plumbing, guarding, mechanics or physical hazardous-energy behavior.

**DOC-CONFIRMED:** Pilz documentation for a current multi-axis drive identifies firmware, wiring, configuration/address and parameter changes as integrity/security risks and recommends unique device identification, checking that the intended device is connected, and testing/logging recommissioning. This reinforces binding the document/configuration evidence to the actual installed device.

## Product-page/document-library trap

**DOC-CONFIRMED:** Pilz product documentation pages can expose multiple operating-manual document numbers/revisions for the same product family. The presence of a newer manual beside an older one is not evidence that every revision applies to every installed unit. Capture exact document number, revision/date and applicability rather than a generic product-page bookmark.

## Claim-level provenance

Do not write:

> Manual X proves the guard switch is safe.

Write bounded claims such as:

> `CLM-GUARD-014` — **DOC-CONFIRMED** for catalog/revision/firmware range shown in Evidence `DOC-PSEN-003`: manufacturer specifies the documented output behavior under condition Y. **UNKNOWN** for the installed machine until model suffix, wiring, configured evaluation, guard geometry and physical response are reconciled.

One document may support many claims, but every safety-critical claim should point to the exact evidence and applicability boundary.

## Conflict and supersession workflow

When a newer or conflicting document appears:

1. freeze the current validated baseline; do not silently replace citations;
2. identify exact old/new document numbers, revisions and applicability ranges;
3. inspect manufacturer revision/change history where available;
4. enumerate affected claim IDs;
5. classify each change as editorial, applicability expansion/contraction, configuration/behavior change, validation/maintenance change, or unresolved;
6. compare installed hardware/firmware/configuration to both documents;
7. determine whether physical inspection, configuration readback, functional test or scoped revalidation is required;
8. keep the affected exposed operating state **NOT CLEARED** when the conflict could materially change a safety function and cannot yet be resolved;
9. record the new validated baseline only after required reconciliation/revalidation closes.

## Adversarial audit prompts

Before accepting a document as safety evidence, ask:

- Is this the exact model including suffix, option and hardware revision?
- Is the installed firmware inside the document's applicability range?
- Does the document describe the exact configured function, or only an available capability?
- Is an accessory, cable, encoder, contactor, valve, feedback contact, network profile or safety I/O revision part of the claim?
- Has the manufacturer issued a newer revision, correction, withdrawal, safety notice or compatibility note?
- Did a firmware/software upgrade change signature semantics, diagnostics, timing configuration, replacement behavior or validation requirements?
- Could a valid old CRC/signature now coexist with changed field hardware?
- Does the drawing reference an obsolete device while the cabinet contains its successor?
- Does the successor require different EDM, fuse/protection, test-pulse, reset, STO, valve-monitoring or diagnostic assumptions?
- Is a distributor/cache/search snippet being used where the manufacturer's controlled document is available?
- Can another engineer retrieve the same authoritative evidence later and prove it is the version used during validation?

## Minimum release gate

A safety-relevant document may support release/return-to-service only when:

- its identity and revision are known;
- its applicability to the installed hardware/firmware/configuration is established;
- supersession/conflict status has been checked;
- claim-level links identify what it actually proves;
- required installed-state/physical verification is complete; and
- any change since the previous validated baseline has received the required scoped revalidation.

Otherwise the affected safety claim remains **UNKNOWN — NOT CLEARED**.

## OpenPressBrake / LinuxCNC boundary

LinuxCNC source/configuration, HAL files, FPGA firmware and ordinary controller diagnostics belong in the machine configuration baseline and may be critical to normal-control correctness. They do not become personnel-safety authority merely because their versions are tightly controlled. Independent safety logic, final elements and physical hazardous-energy controls retain their separate evidence and validation chains.

For OpenPressBrake specifically, do not claim exact protective-device model/revision, safety-controller configuration, hydraulic safety-valve arrangement, STO/safe-motion implementation, EDM mapping, stopping distance/time, pressure/force threshold, gravity retention, PL/SIL or diagnostic coverage until machine-specific evidence establishes it.

## Evidence consulted for this register

- Rockwell Automation, GuardLogix/Logix SIS current online safety documentation: safety-signature generation and comparison; firmware-dependent behavior; hardware/firmware compatibility status; controller/application signature behavior. **DOC-CONFIRMED.**
- Rockwell Automation, GuardLogix 5580 / Compact GuardLogix 5580 Safety Reference Manual, publication 1756-RM012J-EN-P (September 2025), including safety-signature revision behavior and history-of-changes material. **DOC-CONFIRMED.**
- Pilz, PMC SI6/PS6 operating manual 1005342-EN-12, device/firmware/configuration integrity and recommissioning guidance. **DOC-CONFIRMED.**
- Pilz PSEN product documentation listing showing multiple manual document identities/revisions for a product family. **DOC-CONFIRMED.**

No simulation or executable compute was required for these documentation-control questions.
