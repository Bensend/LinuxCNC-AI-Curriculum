# Safety Evidence Provenance / Chain-of-Custody Worksheet

Date: 2026-09-16
Status: durable curriculum artifact
Scope: LinuxCNC / OpenPressBrake safety curriculum; generic machinery-safety evidence discipline

## Purpose

A safety conclusion is only as strong as the evidence chain connecting the physical claim to the observation that supports it. This worksheet prevents screenshots, HMI states, command echoes, copied CSV files, configuration signatures, or remembered test results from silently becoming stronger evidence than they actually are.

The governing rule is:

> **Preserve the raw observation, its configuration identity, its observer/authority, and every transformation between that observation and the conclusion. If a link is missing, bound the conclusion and mark the missing fact UNKNOWN.**

This worksheet does not establish PL, SIL, Category, PFHd, stopping distance, hydraulic pressure thresholds, proof-test intervals, or machine suitability. Those require the applicable design requirements and evidence for the actual machine.

## Provenance vocabulary

Use the repository vocabulary without promotion by convenience:

- **SOURCE-CONFIRMED** — directly supported by inspectable source code or equivalent primary implementation source.
- **DOC-CONFIRMED** — directly supported by authoritative documentation/manuals/standards-oriented documentation.
- **TEST-CONFIRMED** — directly observed in a defined test, bound to the tested configuration and conditions.
- **COMMUNITY-REPORTED** — reported by a community/user source but not independently reproduced here.
- **INFERENCE** — engineering conclusion derived from stated evidence; assumptions must be explicit.
- **UNKNOWN** — not established by available evidence.

A copied or transformed artifact retains the provenance limits of its source; export does not upgrade evidence.

## Evidence-chain record

Create one record per safety claim. Do not combine unrelated claims merely because they occurred during one test.

| Field | Required entry |
|---|---|
| Claim ID | Stable identifier |
| Physical claim | Exact physical fact being asserted, e.g. `K1 main contacts opened after E-stop demand` |
| Safety function / hazard | Function and hazard this claim supports |
| Claim boundary | What the claim explicitly does **not** establish |
| Originating authority/source | Device, sensor, observer, test instrument, safety controller, manual, source file, etc. |
| Raw artifact | Original trace/log/photo/video/instrument record/file/report reference |
| Raw artifact retention | Location, filename/ID, format, read-only/hash/signature method if available |
| Configuration identity | Machine revision; safety logic/signature; safety-I/O configuration; wiring revision; device MPN/revision; relevant parameters |
| Test conditions | Operating mode, energy state, guard state, commanded state, fault injection, environmental conditions when relevant |
| Time identity | Wall-clock time and timezone if known |
| Sequence/session identity | Boot/session/run ID, monotonic sequence, test-step number, or `UNKNOWN` |
| Independent witness | Separate observation of the physical consequence where required; otherwise explain why not required |
| Transformations | Export, CSV conversion, screenshot, cropping, filtering, resampling, annotation, summary, transcription, unit conversion |
| Transformer | Person/tool/version performing each transformation |
| Integrity gaps | Missing raw data, clock reset, logger outage, dropped samples, edits, unknown wiring/configuration, stale cache, uncertain ordering |
| Provenance label | SOURCE/DOC/TEST/COMMUNITY/INFERENCE/UNKNOWN |
| Bounded conclusion | Narrowest conclusion justified by the chain |
| Explicit UNKNOWNs | Facts that must not be implied from this record |
| Revalidation trigger | Changes that would make this evidence require review or retest |
| Reviewer/date | Who checked the chain and when |

## Authority ladder: what an observation can actually prove

Treat these as different evidence classes:

1. **Command evidence** — proves that a command was issued or represented at the observed point.
2. **Logic-state evidence** — proves that software/logic represented a state at the observed point.
3. **Electrical feedback evidence** — proves the observed electrical feedback state, subject to wiring/device integrity.
4. **Independent final-element evidence** — observes the actual contactor/valve/drive/mechanism state independently of the command path.
5. **Physical hazard evidence** — observes the hazardous motion/energy condition itself.
6. **Personnel/space evidence** — addresses whether people are exposed/clear; it is not implied by motion or guard status alone.

Do not jump upward in this ladder without an evidence link. For example, `linuxcnc.estop-out = FALSE` is command/logic evidence, not proof that a contactor opened or hydraulic/mechanical energy is absent.

## Configuration binding

Evidence belongs to the configuration tested.

At minimum, capture every identity that could materially affect the claim. Examples include safety-controller application/signature, safety-I/O configuration signature, device identity/revision, wiring drawing revision, guard geometry, safety parameters, final-element model, ordinary FPGA image/version when it participates in diagnostics or normal control, LinuxCNC configuration/version when relevant to the tested normal-control behavior, and any temporary maintenance/bypass state.

**DOC-CONFIRMED:** Rockwell GuardLogix documentation states that safety-signature elements change when their associated safety application elements are modified and require revalidation. Rockwell also documents per-device safety-I/O configuration signatures and states that a configuration signature is only considered verified after user testing.

A matching signature is configuration-identity evidence. It does **not** prove that field wiring is correct, a guard is physically restored, a contactor actually opened, hazardous energy dissipated, or personnel are clear.

## Raw evidence retention

Prefer retaining the earliest practical artifact rather than only a presentation copy.

For an instrumented test, retain the original trace or instrument export when possible. For a controller event, retain the original controller/log export plus session/configuration identity. For a photo or video, retain the original file before cropping or annotation. For a manual/source claim, retain a durable URL/document identifier, title/revision, and the exact relevant section/page where practical.

A screenshot is useful as a human-readable pointer but is normally weaker than the underlying trace/configuration because it can omit channels, scale, sequence, metadata, context, and preceding/following events.

## Transformation ledger

Every meaningful transformation gets a row.

| Step | Input artifact | Transformation | Tool/version | Output artifact | Information lost/changed? | Reviewer note |
|---|---|---|---|---|---|---|
| 0 | physical observation | acquisition | instrument/controller | raw artifact | acquisition limits | |
| 1 | raw artifact | export/conversion | | | | |
| 2 | | filtering/cropping/annotation | | | | |
| 3 | | summary/report | | | | |

If a transformation cannot be reconstructed, state that. Never silently treat an edited image or manually copied table as raw evidence.

## Independent-witness rule

Ask: **Is the observation independent of the thing whose success is being claimed?**

Examples:

- Safety controller commanded K1 OFF; a controller output bit echo is not an independent witness that K1's power contacts opened.
- An EDM/mirror-contact path can provide stronger final-element evidence when correctly designed and validated, but it still does not prove every downstream energy source is harmless.
- A valve command going inactive is not proof of hydraulic pressure decay or ram immobility.
- A LinuxCNC GUI showing `SAFE` is not independent proof of the safety controller, final element, hydraulic state, guard state, or personnel clearance unless the displayed signal's provenance and physical meaning are separately established.

## Timing and ordering quality

Record both human-readable time and causal-order evidence where available.

Wall-clock timestamps can step after NTP correction, reboot, battery failure, timezone change, or manual adjustment. Buffered events may be written later than they occurred. Prefer a boot/session ID plus monotonic event sequence or test-step number for causal reconstruction. If only wall-clock time exists, do not invent ordering beyond what the records establish.

## Evidence-strength quick test

Before accepting a conclusion, answer all seven:

1. What exact physical claim is being made?
2. What observed it?
3. Is that observer independent enough for this claim?
4. Is the raw artifact retained?
5. Is it bound to the tested configuration?
6. Are time/order and transformations traceable?
7. What remains UNKNOWN even if the evidence is genuine?

Any unanswered item weakens or bounds the conclusion; it does not authorize filling the gap by assumption.

## Adversarial examples

### A — HMI screenshot says `E-STOP ACTIVE`

Evidence: screenshot from LinuxCNC HMI.

Valid conclusion: **TEST-CONFIRMED** only that the HMI displayed that state at the captured instant if screenshot provenance is trusted.

Not established: contactor state, drive torque removal, hydraulic energy state, ram stop, guard state, personnel clearance. Those remain **UNKNOWN** absent independent evidence.

### B — Command echo matches command

Evidence: FPGA/LinuxCNC command register reads zero after watchdog timeout.

Valid conclusion: command-path state at that observation point may be **TEST-CONFIRMED**.

Invalid promotion: `therefore the proportional valve closed and the ram cannot move.` Valve current, spool state, hydraulic response and ram motion require their own witnesses.

### C — CSV copied into a report

Evidence: selected columns pasted from a raw trace into a spreadsheet/CSV summary.

Required chain: retain raw trace; record extraction/filtering; preserve channel units/sample rate; identify omitted channels; keep configuration identity.

If the raw trace is missing, the summary may still be useful but the missing chain is an integrity gap and conclusions must be narrowed.

### D — Safety signature mismatch

Evidence: archived validation report identifies signature A; current controller shows signature B.

Conclusion: prior evidence is not automatically transferable to the current safety application. The mismatch is a revalidation trigger. Do not infer whether the change is safe or unsafe without impact analysis and required testing.

### E — Matching safety signature after undocumented wiring work

Evidence: controller safety signature matches the validated project; field wiring was changed but revision/verification records are missing.

Conclusion: the matching controller signature does not validate the changed physical installation. Wiring-dependent claims are **UNKNOWN** until the actual installation is inspected/tested as required.

### F — Edited/cropped screenshot

Evidence: screenshot shows only the `SAFE` indicator; timestamp, faults and adjacent channels were cropped out.

Conclusion: use only as a presentation artifact. Locate the original capture/raw record. If unavailable, record missing context and do not use the crop as sole evidence of complete safety-function performance.

### G — Stale log after reconnect

Evidence: HMI reconnects and displays the last cached `guard_closed = true` event.

Conclusion: historical state only. It cannot establish present guard state or reset eligibility without freshness/session evidence.

### H — Test proves input but not final element

Evidence: opening an interlock changes safety-controller input and output logic as expected, but the external contactor/valve path was not exercised or independently observed.

Conclusion: input/logic behavior may be **TEST-CONFIRMED**; complete physical safety-function performance remains **UNKNOWN**.

### I — Good physical observation, wrong configuration identity

Evidence: video clearly shows a contactor dropping during an E-stop test, but the video cannot be tied to the current machine revision/configuration.

Conclusion: the video can document the observed historical event, but transfer to the current configuration is **UNKNOWN**.

### J — Log says maintenance bypass cleared

Evidence: audit log records `bypass=false`.

Conclusion: the administrative/logic state was recorded. It does not prove removed guards were reinstalled, temporary jumpers removed, alternate safeguards restored, or the complete safety function proof-tested.

## Return-to-service evidence bundle

For maintenance/change work, the evidence bundle should make it difficult to clear the paperwork while leaving the physical machine altered. A practical bundle can include:

- work/change identifier;
- affected safety functions and hazard boundaries;
- before/after configuration identities;
- physical restoration inspection;
- removal of temporary jumpers/bypasses/test forces;
- guard/interlock/final-element restoration evidence;
- required functional tests with raw observations;
- independent witness for final elements/physical outcomes where appropriate;
- reset/restart/rearm checks;
- unresolved UNKNOWNs and restrictions;
- reviewer/authorization for return to service.

**DOC-CONFIRMED:** OSHA machine-guarding guidance describes return-to-service steps after maintenance including inspecting that guards and safety devices are in place and functional and checking the area before reenergization/startup. This supports treating physical restoration as distinct from merely clearing a software bypass flag.

## Curriculum scoring rule

A learner gets credit for a narrower, traceable conclusion over a broad conclusion built from weak evidence. Explicitly writing `UNKNOWN` is correct when the chain does not establish the fact.

Automatic failure patterns include:

- command = physical outcome;
- HMI status = independent safety evidence;
- matching safety signature = complete machine validation;
- log entry = physical event;
- screenshot = raw trace when the raw trace exists but is discarded;
- copied table = unchanged evidence without recording transformation;
- wall-clock timestamp = guaranteed causal ordering;
- prior PASS = current PASS after an unreviewed configuration/wiring/guard change;
- missing evidence filled with a plausible machine-specific number or behavior.

## Source notes

- **DOC-CONFIRMED — Rockwell Automation, GuardLogix safety-signature documentation:** safety signatures verify safety-application integrity; signature elements identify changed portions and changes require revalidation. A restored/downloaded application with mismatched signature requires revalidation.
- **DOC-CONFIRMED — Rockwell Automation, Safety I/O Device Signature / Configuration Signature and Ownership:** each safety device has a configuration signature; the signature verifies configuration identity and is considered verified only after user testing.
- **DOC-CONFIRMED — OSHA Machine Guarding eTool, Additional Safety Considerations:** after servicing, return-to-service includes inspection that guards/safety devices are in place and functional and checking the area before reenergization/startup.
- **DOC-CONFIRMED — Pilz safety validation guidance/compendium:** validation tests require a test plan and traceable records; test results are compared against defined specifications.

## Open questions intentionally left UNKNOWN

For any actual OpenPressBrake installation, this worksheet does not yet establish:

- required PL/SIL/Category for any function;
- stopping time or protective distance;
- hydraulic pressure/decay behavior;
- gravity/load retention behavior;
- exact final-element feedback architecture;
- exact proof-test interval;
- which measurements require calibrated instrumentation;
- actual safety-controller/device models and configuration-signature mechanisms.

These are machine/configuration-specific and must be established from the real architecture, risk assessment, device documentation and physical validation.
