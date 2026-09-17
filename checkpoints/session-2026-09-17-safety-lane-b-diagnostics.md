# Safety curriculum lane B checkpoint — diagnostic annunciation — 2026-09-17

- Lane: second independent LinuxCNC/OpenPressBrake safety curriculum lane.
- Status: CHECKPOINTED; safety curriculum remains active.
- Primary-lane newest durable work at selection time: `safety-course/COMMISSIONING_VALIDATION_FAULT_INJECTION_PACKAGE_2026-09-17.md`, commit `7687928`, with checkpoint `2b24368b`.
- Parallel-work decision: did **not** advance the previously proposed witness/common-cause review because the primary checkpoint explicitly selected common-cause/latent-failure analysis as its next branch. Did **not** take the minimum-safe-to-operate gate because that is also explicitly primary next work.
- Independent artifact: `safety-course/SAFETY_FAULT_DIAGNOSTIC_ANNUNCIATION_TROUBLESHOOTING_BOUNDARY.md`, commit `839ae306`.
- Main re-read immediately after artifact commit: newest commit was the Lane-B artifact itself; no competing primary-lane commit or overlapping file appeared during the write.
- Compute: NONE. Documentation/architecture work only; no GitHub-hosted Actions minutes consumed and self-hosted execution was not justified.

## Durable result

Established the rule that diagnostic systems may explain safety state but must not manufacture, suppress, reset, or bypass independent personnel-safety authority merely because the HMI/normal controller is convenient. Separated demand identity, current safety state, missing physical evidence, and next permitted action. Separated alarm acknowledgement, safety reset, normal rearm, and normal start.

Added failure paths for stale/incorrect green HMI state, `CLEAR ALL` becoming a bypass, nuisance-fault pressure, diagnostic-network loss, live-vs-history confusion, evidence destruction by premature reset/power cycle, and ordinary command state being misreported as proof of physical response.

## Evidence provenance

- `DOC-CONFIRMED`: SICK Flexi Soft diagnostics require stopping if a malfunction cannot be clearly identified/safely remedied and a full functional test after remedy; documented error classes have distinct safe-output/process-data behavior.
- `DOC-CONFIRMED`: SICK HS80 diagnostics direct troubleshooting to both controller diagnostics and connected-device diagnostics.
- `DOC-CONFIRMED`: Pilz PNOZ s2 documents fault-specific remedies and refusal to reactivate after welded contacts.
- `DOC-CONFIRMED`: current SICK Flexi Soft Designer material provides an example where diagnostic-history inhibition does not suppress the underlying error response, supporting architectural separation of response from reporting/history.
- `INFERENCE`: the proposed layered HMI/troubleshooting vocabulary and workflow are engineering synthesis.
- `TEST-CONFIRMED`: none.
- `COMMUNITY-REPORTED`: none used.
- `SOURCE-CONFIRMED`: none separately required for this manufacturer-document study.
- `UNKNOWN`: exact OpenPressBrake safety-controller diagnostics, reset prerequisites, EDM/final-element semantics, hydraulic state and fault recovery until hardware/architecture and physical evidence exist.

## Precise next independent work

Create `safety-course/SAFETY_DIAGNOSTIC_EVENT_RECORD_MINIMUM_SCHEMA.md` unless the primary lane has entered that subject by the next run. Define the minimum event record needed to reconstruct a safety fault without confusing command state with physical proof: monotonic and UTC time treatment, event source identity, configuration identity, live-vs-history state, demand/fault transitions, final-element feedback, normal-controller context explicitly marked diagnostic-only, reset/rearm/start transitions, power/network discontinuities, stale/unavailable signals and evidence provenance.

Before taking that branch, re-read current main and the primary safety checkpoint. If the primary lane has begun diagnostic/event-history work, switch to another independent safety artifact rather than duplicating it.