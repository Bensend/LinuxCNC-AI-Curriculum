# Safety Event Logging / Audit-Trail Evidence Integrity

Status: independent curriculum architecture/source-trace — 2026-09-16

## Purpose

Teach how event records can support commissioning, maintenance, fault reconstruction, change control, and safety validation **without confusing a log entry with proof that a physical safety function occurred**.

This artifact is machine-agnostic. It does not assign OpenPressBrake safety performance, stopping distance, pressure thresholds, hydraulic truth tables, PL/SIL, proof-test intervals, or diagnostic-coverage percentages.

## Evidence labels

- **SOURCE-CONFIRMED** — directly supported by an authoritative external source.
- **DOC-CONFIRMED** — supported by repository/manufacturer documentation but not independently tested here.
- **TEST-CONFIRMED** — demonstrated by controlled test with preserved evidence.
- **COMMUNITY-REPORTED** — reported by practitioners/community sources.
- **INFERENCE** — engineering conclusion derived from evidence.
- **UNKNOWN** — insufficient evidence; UNKNOWN never means safe.

## Source-backed findings

### Configuration identity and change detection

**SOURCE-CONFIRMED — Rockwell GuardLogix:** a safety signature verifies integrity of the safety application; Rockwell says the signature should be recorded/stored separately for audit or suspected-tampering checks. Safety-signature elements and timestamps can support impact analysis by identifying changed portions of the safety project.

**SOURCE-CONFIRMED — Rockwell GuardLogix:** after a download/restore, the safety signature must be manually checked against the original safety documentation. If the signature does not match and the application is unlocked/changed, the signature is deleted and the application must be revalidated.

**SOURCE-CONFIRMED — Rockwell safety I/O:** each safety I/O device has a configuration signature identifying its configuration.

**SOURCE-CONFIRMED — Rockwell controller change detection:** monitored controller changes can update an audit value. Candidate tracked events include online edits, forces, firmware-update attempts, mode changes, major faults, property changes, media insertion/removal, constant-tag changes, custom log entries, alarm-log clearing, and port-configuration changes.

**INFERENCE:** configuration signature/audit value is evidence of configuration identity or change. It is not evidence that a guard physically closed, a contactor opened, hydraulic energy dissipated, a ram stopped, or a person was clear of a hazard.

### Inspection records

**SOURCE-CONFIRMED — OSHA machine-guarding guidance:** documented inspections should identify the machine, inspection date, problems noted, and corrective action. OSHA notes that records help communicate hazards and reveal repeat-problem patterns.

**INFERENCE:** records improve traceability and maintenance discipline, but the record itself cannot replace the inspection or functional test that generated it.

## Frozen evidence rule

> `event_logged` is not `physical_event_proven`.

A useful safety-related record should identify **what observed the event**, **which configuration produced the observation**, **how fresh the observation was**, and **what independent evidence supports any physical claim**.

For example:

- `LinuxCNC commanded output OFF` proves only the ordinary-controller command state unless additional evidence exists.
- `FPGA output register = 0` proves a digital/controller state, not that an external contactor opened.
- `EDM auxiliary contact changed state` may be useful independent final-element feedback if the architecture and contact are validated for that claim; it still does not prove unrelated hydraulic/mechanical energy is absent.
- `safety signature = X` identifies a safety-application configuration; it does not prove current field wiring matches drawings.
- `guard closed` does not prove a whole-body-access space is empty.

## Event-record schema

For curriculum and future implementation work, safety-significant records should preserve as many of these fields as the architecture can support without inventing unavailable evidence:

1. **Event ID** — monotonic sequence or other ordering witness.
2. **Event class** — protective-device trip, E-stop, final-element fault, reset, rearm, bypass/override, configuration change, power/reboot, communications fault, inspection/test, etc.
3. **Source authority** — independent safety system, field device, ordinary FPGA, LinuxCNC, HMI, maintenance record, or external test instrument.
4. **Observed state** — the actual observed signal/state, not an embellished physical conclusion.
5. **Timestamp** — plus clock source/quality if known.
6. **Boot/session ID** — distinguishes events across reboot and clock reset.
7. **Sequence number** — permits detection of missing/reordered records where supported.
8. **Configuration identity** — software/FPGA/safety-controller/device signature or revision relevant to interpretation.
9. **Command generation/freshness** — where ordinary control commands are involved.
10. **Feedback generation/freshness** — where feedback is involved.
11. **Operator/maintenance action identity** — where policy permits and where authorization matters.
12. **Reason/task reference** — especially for exceptional reset, test/position, override or maintenance state.
13. **Independent witness reference** — test record, EDM observation, inspection result, instrument capture, photograph, signed checklist, etc., where needed for the claim.
14. **Provenance label** — SOURCE-CONFIRMED, DOC-CONFIRMED, TEST-CONFIRMED, COMMUNITY-REPORTED, INFERENCE or UNKNOWN.
15. **Integrity state** — complete, gap detected, clock uncertain, configuration mismatch, tamper suspected, export incomplete, UNKNOWN.

A minimal implementation may not have all fields. Missing fields must reduce the strength of the conclusion rather than being silently assumed.

## Clock and ordering integrity

Wall-clock time is useful but not sufficient for causal reconstruction.

### Failure cases

- controller clock resets to a default value after power loss;
- HMI and safety controller clocks disagree;
- NTP/PTP/time service steps the clock backward or forward;
- buffered events arrive late after communications recovery;
- two devices report the same timestamp resolution;
- LinuxCNC restarts and begins a new log with no boot identity;
- an export sorts by timestamp and accidentally changes causal order.

### Architecture rule

Where practical, combine wall-clock time with monotonic sequence/session information. If causal ordering cannot be established, label it **UNKNOWN** rather than inferring a sequence from timestamps alone.

No safety function should depend on a general-purpose log server remaining reachable unless that dependency is explicitly engineered and validated as part of the safety function. Ordinary logging should fail diagnostically, not become hidden personnel-safety authority.

## Reboot and communications gaps

A reboot boundary is itself safety-significant evidence.

Preserve:

- last known event/sequence before restart;
- restart/boot identity;
- configuration identity after restart;
- whether buffered records survived;
- whether outputs/commands were cleared;
- whether feedback freshness was re-established;
- whether explicit safety reset and separate ordinary production rearm were required.

**INFERENCE:** if a logger cannot prove what happened during an outage, the gap must remain a gap. Filling it with the last-known state is dangerous because a stale `safe=true` can masquerade as current evidence.

## Configuration identity and validation linkage

Every validation record should be tied to the configuration actually tested.

Useful identities can include:

- safety-controller signature;
- safety-I/O configuration signature;
- ordinary FPGA gateware hash/revision;
- LinuxCNC configuration/repository revision;
- safety-device parameter set/revision;
- wiring/drawing revision;
- hydraulic/mechanical configuration revision where applicable;
- test procedure revision and test-instrument identity.

When a relevant identity changes, use the curriculum change-control/evidence-invalidation matrix rather than automatically carrying old PASS evidence forward.

## Exceptional-event classes that deserve durable attention

At minimum, consider durable records for:

- E-stop demand and restoration;
- guard/interlock/protective-device demand;
- channel disagreement or diagnostic fault;
- final switching device / EDM fault;
- safety-controller fault;
- safety reset;
- ordinary production rearm/start after reset;
- maintenance bypass, override, muting or setup/test state entry/exit where applicable;
- escape release / trapped-person access event where applicable;
- LOTO/test-position transitions where electronically recorded;
- safety-configuration/signature change;
- safety-related field-device replacement;
- forces/test overrides enabled or removed;
- controller/FPGA/HMI reboot;
- communications loss/recovery;
- clock loss/change;
- audit-log clear/export failure;
- commissioning/periodic-validation test and corrective action.

Do not log only faults. Recovery events matter because unsafe behavior often appears at the transition back toward permissive operation.

## Tamper and deletion model

An audit trail that can be silently rewritten by the same ordinary HMI/operator account that it is supposed to audit has weak evidentiary value.

Practical architecture goals:

- append-oriented records where feasible;
- explicit record when a log is cleared, rotated, exported or storage becomes full;
- preserve configuration identity with exports;
- restrict modification/deletion privileges;
- retain an independent copy for important validation/signature evidence where practical;
- detect obvious gaps or sequence discontinuities;
- never let loss of logging silently create a more permissive machine state;
- do not claim cryptographic tamper evidence unless actually implemented and validated.

**UNKNOWN:** the required retention period, cybersecurity assurance, legal record requirements and cryptographic controls for a particular OpenPressBrake installation. Those depend on the actual application, jurisdiction, company policy and selected safety architecture.

## Authority separation for OpenPressBrake-style architecture

### Independent personnel-safety layer

May originate authoritative safety state/diagnostics appropriate to its validated architecture. Its physical safety action must not depend on LinuxCNC or the normal FPGA successfully writing a log.

### Normal FPGA

May timestamp or sequence ordinary command/feedback events, record watchdog/freshness state and forward independent-safety diagnostics. Its event stream remains ordinary-control evidence unless a particular function is separately safety-qualified.

### LinuxCNC / HMI

May display, correlate, export and annotate records. It must not convert `log says safe` into personnel-safety permission. Reconnect must not replay stale commands or stale `safe` status.

### External validation/maintenance evidence

May provide stronger independent proof for physical observations: meter/instrument capture, inspection, witnessed functional test, pressure measurement, stopping measurement, physical guard test, LOTO verification, etc. The exact witness depends on the claim.

## Question-driven verification plan

Executable testing is warranted only when it answers a concrete integrity question. Candidate future tests:

| Question | Test | Required evidence |
|---|---|---|
| Are events reordered across reconnect? | Inject disconnect/reconnect with known event sequence | preserved sequence IDs and capture |
| Does reboot create a silent gap? | power/restart logger/controller in a safe test fixture | boot IDs, before/after sequence, gap indication |
| Can stale safety status survive reconnect? | hold old status while source freshness expires | source/freshness trace; permissive state must not be inferred |
| Does clock rollback reorder history? | controlled clock adjustment in non-production test environment | wall clock + monotonic sequence comparison |
| Can log storage fill silently? | bounded storage-exhaustion test | diagnostic behavior and retained integrity state |
| Does configuration change invalidate prior evidence? | change nonhazardous test config and compare IDs | before/after identity plus evidence linkage |

These tests are **not needed merely to make the module look complete**. If later executed, use only the self-hosted runner labeled `[self-hosted, openpressbrake]` when repository automation is appropriate. Never fall back to GitHub-hosted compute.

## Adversarial Safety Sandbox cases

1. **Command echo masquerades as proof:** LinuxCNC logs `contactor_off=true`; EDM remains made. Expected: physical final-element claim fails.
2. **Stale safe status:** HMI reconnects showing the last pre-disconnect `guard_safe=true`. Expected: freshness UNKNOWN; no safety conclusion.
3. **Clock rollback:** reset appears to precede the trip. Expected: sequence/session evidence governs; otherwise ordering UNKNOWN.
4. **Logger reboot:** event IDs restart at zero with no session ID. Expected: gap/ambiguity flagged.
5. **Log deletion:** maintenance clears nuisance faults before investigation. Expected: deletion/clear must itself be visible where architecture supports it; missing history weakens evidence.
6. **Configuration drift:** validation PASS belongs to safety signature A, machine now runs signature B. Expected: prior PASS cannot be blindly transferred.
7. **FPGA rebuild:** ordinary gateware changes but filename stays the same. Expected: immutable revision/hash required for strong linkage.
8. **Physical wiring change without software change:** signatures match, but EDM wiring was altered. Expected: software identity does not prove field wiring identity.
9. **Safety event logged, physical energy remains:** E-stop trip is recorded while stored hydraulic/mechanical energy persists. Expected: log does not prove hazardous-energy isolation.
10. **Reset and start collapse:** one event is labeled `RESET/START`. Expected: architecture/evidence fails to preserve distinct reset and production-rearm semantics.
11. **Buffered reorder:** guard trip generated before reset but arrives afterward. Expected: generation sequence/freshness used; receipt order alone insufficient.
12. **Remote audit server unavailable:** machine loses logging destination. Expected: personnel-safety function remains independent; diagnostic gap is recorded/reconciled if possible.
13. **Forged HMI annotation:** operator note says `space clear` without independent whole-body-access evidence. Expected: annotation is not physical proof.
14. **Inspection record without test identity:** checklist says PASS but machine/config/test method are missing. Expected: evidence strength insufficient for configuration-specific validation claim.
15. **Repeated nuisance bypasses:** logs show frequent exceptional override. Expected: trend triggers architecture/process review rather than normalizing defeat.

## Learner/evaluator rules

A strong answer must distinguish:

`physical event` → `sensor/witness` → `recording authority` → `transport/storage` → `display/export` → `human conclusion`.

Automatic failure patterns:

- treating an HMI log as personnel-safety authority;
- treating a command record as actuator-position proof;
- treating a safety signature as proof of field wiring or physical energy state;
- treating a timestamp as unquestionable causal ordering;
- filling an outage with last-known-safe state;
- merging safety reset and production start into one event;
- claiming tamper-proof logging without implemented evidence;
- inventing retention periods, stopping performance, hydraulic states, PL/SIL or diagnostic coverage.

## OpenPressBrake-specific UNKNOWNs

Remain UNKNOWN until actual machine/controller evidence is traced:

- selected independent safety controller and its native event/audit capabilities;
- which safety devices expose diagnostic timestamps or sequence information;
- exact E-stop/guard/EDM/hydraulic safety architecture;
- authoritative clock source and clock-retention behavior;
- actual logger/storage design and retention requirements;
- whether safety configuration signatures/checksums are available;
- physical stopping time and residual-energy behavior;
- which events must be retained under site/company/legal policy.

## Next independent branch

Develop a **safety evidence provenance and chain-of-custody worksheet** for commissioning/incident reconstruction: bind each physical claim to source authority, configuration identity, witness, raw artifact, transformation/export steps, integrity gaps and final conclusion. Keep it separate from the primary lane's maintenance-bypass proof-of-restoration work.

## Sources

- Rockwell Automation, GuardLogix 5580 / Compact GuardLogix 5580 Safety Applications — Safety Signature: https://www.rockwellautomation.com/en-no/docs/technical/logix5000/_online/1756-rm012/guardlogix-5580-and-compact-guardlogix-5580-safety/safety-signature.html
- Rockwell Automation, Download/Upload a Safety Application Program: https://www.rockwellautomation.com/en-no/docs/technical/logix5000/_online/1756-rm012/guardlogix-5580-and-compact-guardlogix-5580-safety/safety-applications/download-upload-a-safety-application-program.html
- Rockwell Automation, ControlLogix/GuardLogix 5580 Change Detection: https://www.rockwellautomation.com/en-us/docs/technical/logix5000/_online/1756-um543/controllogix-5580-and-guardlogix-5580-controllers-/develop-secure-applications/change-detection.html
- Rockwell Automation, Safety I/O Device Signature: https://www.rockwellautomation.com/en-us/docs/technical/logix5000/_online/1756-um543/controllogix-5580-and-guardlogix-5580-controllers-/safety-i-o-devices/safety-i-o-device-signature.html
- Rockwell Automation, Generate Safety Signature Report: https://www.rockwellautomation.com/en-us/docs/studio-5000-logix-designer/37-00/contents-ditamap/studio-5000-logix-designer/generate-signature-report-command.html
- OSHA Machine Guarding eTool — Point of Operation / inspection records: https://www.osha.gov/etools/woodworking/machine-hazards/point-of-operation
