# Safety Configuration Backup / Restore / Disaster-Recovery Failure Paths

Date: 2026-09-16
Status: DURABLE INDEPENDENT SAFETY STUDY
Lane: Safety Curriculum B

## Purpose

A backup is not a safety proof, and a successful restore is not proof that the restored machine is safe to operate. This study separates recovery of digital configuration from restoration and validation of the complete physical safety function.

Frozen rule:

> `backup restored` != `validated safety function restored`.

A recovery event can preserve logic perfectly while the replacement controller, safety I/O identity, firmware/compiler, field wiring, device parameters, calibration, network identity, valve/contact feedback, or mechanical protective arrangement differs from the validated baseline.

## Evidence vocabulary

Use the curriculum provenance classes literally:

- `SOURCE-CONFIRMED` — established directly from inspectable source/code/artifact.
- `DOC-CONFIRMED` — established by authoritative manufacturer/standards documentation.
- `TEST-CONFIRMED` — established by a controlled test whose stimulus and observations support the stated claim.
- `COMMUNITY-REPORTED` — reported by practitioners but not independently established here.
- `INFERENCE` — engineering conclusion derived from evidence; preserve its assumptions.
- `UNKNOWN` — evidence is insufficient. Do not fill the gap with a convenient value.

## 1. What a recovery package must identify

Treat the recoverable safety configuration as a versioned evidence package, not merely a PLC project file. Record, as applicable:

1. machine/system identity and the validated configuration baseline;
2. safety-controller project/application and safety signature or equivalent identity;
3. controller hardware identity and firmware revision;
4. safety I/O device identities, network/safety-network identities and device configurations;
5. drive/STO/safe-motion safety parameters and firmware where they participate in a safety function;
6. safety-relay or configurable-safety-device parameters;
7. protective-device configuration: light curtain/scanner/guard locking/muting/restart settings as applicable;
8. safety-relevant calibration/teach data where a validated function actually depends on it;
9. electrical drawings, terminal/wire identifiers and final-element feedback mapping;
10. hydraulic/pneumatic/mechanical safety-function drawings or configuration needed to understand the hazardous-energy boundary;
11. validation evidence tied to that exact baseline;
12. unresolved `UNKNOWN`s and restrictions.

A file hash or safety signature is useful configuration identity evidence. It does not prove the physical machine still matches the configuration.

## 2. Authoritative recovery lessons from GuardLogix

`DOC-CONFIRMED`: Rockwell Automation's GuardLogix 5580 safety documentation states that after downloading/restoring a safety application, application testing is required unless a safety signature exists. To verify the correct safety application was downloaded or restored from memory card, the safety signature must be manually checked against the original signature in the safety documentation.

`DOC-CONFIRMED`: if the signature does not match and a locked controller must be unlocked to download, the signature is deleted and the application must be revalidated.

`DOC-CONFIRMED`: download preservation checks include firmware revision and safety signature. Rockwell's download guidance states that an incompatible firmware minor revision can prevent preserving the safety signature; proceeding without preservation deletes the signature and requires revalidation.

`DOC-CONFIRMED`: Rockwell's controller replacement guidance says firmware/compiler migration can require removal/regeneration of the safety signature, review of release notes and compatibility, impact analysis, and testing of affected safety implementation.

`DOC-CONFIRMED`: GuardLogix safety-I/O replacement behavior is identity/configuration-sensitive. Replacement handling uses device identity including node/IP address and Safety Network Number, and replacement/configuration policy changes depending on whether a safety signature exists.

These are product-specific facts, but the transferable architecture lesson is broader: **controller program identity, runtime/firmware identity, distributed safety-device identity, and physical validation are different claims.**

## 3. Recovery-state model

Do not use a single `RESTORED` flag. Track at least these independent states:

- `backup_identity_known`
- `controller_hardware_identity_known`
- `firmware_runtime_compatible`
- `safety_application_identity_matches`
- `distributed_device_identity_matches`
- `device_parameters_restored`
- `field_wiring_correspondence_verified`
- `physical_protective_devices_correspond`
- `final_elements_correspond`
- `calibration_or_teach_data_valid`
- `affected_safety_functions_revalidated`
- `temporary_recovery_tools_removed`
- `restart_rearm_behavior_revalidated`
- `unresolved_unknowns_accepted_or_closed`

Only the final safety-function validation can support the physical safety claim. Earlier states are prerequisites/evidence, not substitutes.

## 4. Failure-path analysis

### A. Stale but internally valid backup

The backup has a valid signature/hash but predates a validated safety change.

- Digital integrity: possibly valid for the old baseline.
- Current-machine correspondence: not established.
- Required response: compare backup identity/date/change record against the current validated baseline before restore.
- Classification until resolved: `UNKNOWN` for current-machine suitability.

### B. Correct project restored to the wrong controller/machine

The program and signature may be internally correct while machine identity, I/O addresses or field hardware differ.

- Reject `signature matches -> correct machine` reasoning.
- Bind recovery evidence to machine/controller/device identity.

### C. Controller replacement with firmware/compiler change

The source application appears unchanged but execution environment changed.

- Perform documented compatibility/impact analysis.
- Treat invalidated/deleted signature as a revalidation trigger where the selected platform requires it.
- Do not assume a successful compile/download preserves the old validation claim.

### D. Safety I/O replacement with stale or wrong device identity

A replacement device may have different network/safety identity or parameters.

- Verify actual device identity/configuration rather than only controller tags.
- Challenge the affected physical input/output path after replacement according to the selected safety architecture.

### E. Backup restores logic but not device-local safety parameters

Examples can include safe-drive parameters, scanner fields, muting settings, guard-lock configuration or device-local discrepancy/restart behavior.

- Maintain an inventory of every safety-function parameter authority.
- `PLC project restored` cannot imply `all safety parameters restored`.

### F. Field wiring changed while software backup remained unchanged

A matching safety signature cannot detect arbitrary terminal swaps, bypass jumpers, welded/changed final elements, wrong feedback contact, altered hydraulic plumbing, removed guard hardware, or misaligned actuators unless those changes affect what the signature covers.

- Configuration identity is not physical correspondence.
- Inspect/rechallenge affected physical paths.

### G. Calibration/teach metadata missing

If a safety function actually depends on validated position, zone, timing, tool or device calibration, missing metadata may invalidate that function even though logic restores correctly.

- Do not invent replacement values.
- Preserve as `UNKNOWN` until authoritative data or a valid recalibration procedure establishes them.

### H. Recovery image contains temporary forces/bypass/test state

A backup made during commissioning or maintenance may preserve non-production state, depending on platform and what the backup includes.

- Recovery package must identify whether forces, inhibits, overrides, maintenance modes or temporary device substitutions can be represented/restored.
- Before production rearm, independently prove temporary defeat mechanisms are absent and affected physical safety functions are restored.

### I. Auto-load after power loss causes unexpected restart path

Automatic project loading can restore configuration but should not be confused with permission for hazardous operation.

- Prefer recovery behavior that requires deliberate operator/authorized intervention before production operation when supported by the selected architecture.
- Validate reset/restart/rearm behavior after disaster recovery.

### J. Backup server says success but artifact is unreadable or incomplete

A scheduled backup job is not proof of recoverability.

- Periodically verify artifact readability and identity using a safe, question-driven recovery exercise where justified.
- Do not run a live-machine restore merely to generate activity; design the test around a concrete recovery claim and safe boundary.

## 5. Minimum recovery adjudication worksheet

| Claim | Evidence needed | Example inadequate evidence | Result if missing |
|---|---|---|---|
| Correct backup selected | baseline ID + change record + artifact identity | filename only | REVIEW / UNKNOWN |
| Correct safety application restored | platform-defined signature/hash comparison | download succeeded | REVIEW / UNKNOWN |
| Runtime is equivalent/approved | firmware/compiler compatibility evidence | same controller family name | REVIEW / UNKNOWN |
| Correct distributed safety devices restored | device identity + config | PLC I/O tags online | REVIEW / UNKNOWN |
| Physical wiring corresponds | inspection/continuity/physical challenge as appropriate | matching program signature | UNKNOWN |
| Final element responds safely | physical stimulus + appropriate independent witness | output bit OFF | UNKNOWN |
| Guard/protective device works | physical device challenge through full affected path | HMI icon changes | UNKNOWN |
| Reset/restart behavior is correct | actual demand-clear-reset-rearm test | machine powers up | UNKNOWN |
| Recovery tools/bypasses absent | physical/software restoration evidence | technician says done | REVIEW / UNKNOWN |

The exact test method and acceptance criteria must come from the selected machine architecture, device documentation, risk assessment and applicable requirements. Do not invent stopping distances, pressures, response times or hydraulic states.

## 6. OpenPressBrake/LinuxCNC boundary

Ordinary LinuxCNC, HAL, the normal FPGA and HMI may:

- store/display expected safety-system identity;
- report diagnostic state;
- inhibit ordinary motion requests when recovery state is incomplete;
- log controller/device/version information;
- require an ordinary control rearm after safety permission is restored.

They do **not** gain personnel-safety authority merely by checking hashes, versions or status bits. The independent safety system and its physical final elements retain safety authority. A LinuxCNC-side `configuration OK` indication must therefore be worded as a diagnostic/configuration claim, not `machine safe`.

## 7. Disaster-recovery commissioning sequence — generic, not machine-specific

A defensible generic sequence is:

1. keep hazardous operation inhibited and establish the appropriate safe work boundary;
2. identify the machine and validated recovery baseline;
3. verify backup artifact identity and provenance;
4. verify replacement controller/device hardware and firmware compatibility;
5. restore the required controller and device configurations;
6. verify platform-defined signatures/identities against retained documentation;
7. verify field wiring, protective devices, feedback paths and final-element correspondence affected by the recovery;
8. restore/re-establish required calibration/teach data through authoritative procedures;
9. challenge affected safety functions through the real physical paths with appropriate independent observations;
10. test fault persistence, reset, restart and rearm behavior;
11. prove temporary recovery tools, forces, jumpers, overrides and test fixtures are removed/restored;
12. retain raw evidence and explicitly record remaining `UNKNOWN`s before authorizing production.

This is an architecture/traceability sequence, not a substitute for the selected safety system manufacturer's commissioning procedure.

## 8. Provenance and sources

Authoritative documentation consulted:

- Rockwell Automation, GuardLogix 5580 / Compact GuardLogix 5580 Safety Reference documentation, `Download/Upload a Safety Application Program`: https://www.rockwellautomation.com/en-no/docs/technical/logix5000/_online/1756-rm012/guardlogix-5580-and-compact-guardlogix-5580-safety/safety-applications/download-upload-a-safety-application-program.html
- Rockwell Automation, `Download Considerations for a Safety Project`: https://www.rockwellautomation.com/en-us/docs/technical/logix5000/_online/1756-um543/controllogix-5580-and-guardlogix-5580-controllers-/create-a-controller-project/considerations-for-download-to-a-safety-controller.html
- Rockwell Automation, `Safety I/O Replacement Options`: https://www.rockwellautomation.com/en-us/docs/technical/logix5000/_online/1756-um543/controllogix-5580-and-guardlogix-5580-controllers-/safety-i-o-devices/safety-i-o-replacement-options.html
- Rockwell Automation, *Replacement Guidelines: Logix 5000 Controllers Reference Manual*, publication 1756-RM100M-EN-P, Oct. 2025.

All product-specific statements above are `DOC-CONFIRMED` to those sources. Translation to a generic OpenPressBrake architecture is `INFERENCE` unless independently established by another cited source. No machine-specific hydraulic safe state, stopping performance or pressure value is asserted.

## 9. Compute decision

No simulation, synthesis or executable verification was justified. The unresolved questions are architecture, provenance and physical-validation questions. No GitHub-hosted or self-hosted runner compute was consumed.

## 10. Precise next independent work

If the primary lane remains on professional OEM safety wiring/final-element traces, Lane B should next build a **disaster-recovery validation scope / change-impact matrix** answering: after controller replacement, firmware change, safety-I/O replacement, protective-device replacement, field-wiring repair, restored backup, calibration loss or drive replacement, exactly which prior evidence remains valid, which evidence is invalidated, and which physical safety functions must be re-challenged. Keep the matrix claim-relative and do not invent universal retest intervals or machine-specific acceptance thresholds.