# LinuxCNC / OpenPressBrake Safety Curriculum — Independent Lane B checkpoint

Date: 2026-09-16
Status: ACTIVE

## Completed this lane

- `safety-course/SAFETY_EVENT_LOGGING_AUDIT_TRAIL_EVIDENCE_INTEGRITY.md`
- Durable commit: `ceddd8100d1836063219a1d737adbc0538c29baa`

## Parallel-work check

At selection time, current main was `2c00697065fe4727272bfa15ac10df0d5a2f40f4`, whose primary-lane checkpoint advanced the safety course to the maintenance-bypass lifecycle. The primary durable artifact was `safety-course/MAINTENANCE_BYPASS_TEMPORARY_OVERRIDE_LIFECYCLE.md`, with its next branch a safety-function proof-of-restoration matrix.

Lane B deliberately selected event logging/audit-trail evidence integrity instead. It did not modify the primary maintenance-bypass artifact or its planned proof-of-restoration matrix.

Immediately after the Lane-B durable commit, main was re-read and the Lane-B commit was head; no overlapping primary-lane write had appeared during the write window.

## Frozen findings

- `event_logged` is not `physical_event_proven`.
- Safety signatures/configuration signatures identify configuration; they do not prove field wiring, physical guard state, hydraulic energy state, stopping performance, or personnel clearance.
- Wall-clock timestamps alone are insufficient for causal reconstruction when clocks can step/reset or buffered events can arrive late; use session/sequence witnesses where practical, otherwise preserve ordering as UNKNOWN.
- Reboot, communications loss, logger outage, log clearing and configuration changes are themselves evidence-integrity events.
- LinuxCNC/HMI/ordinary FPGA logging remains diagnostic/audit infrastructure and must not become personnel-safety authority merely because it records safety-related signals.
- Validation evidence must remain bound to the configuration actually tested.

## Compute

No executable verification was needed. No GitHub-hosted or self-hosted runner compute was consumed.

## Precise next independent work

Develop `safety-course/SAFETY_EVIDENCE_PROVENANCE_CHAIN_OF_CUSTODY_WORKSHEET.md`.

It should bind each safety claim to:

1. physical claim being made;
2. originating source/authority;
3. raw observation/artifact;
4. configuration identity;
5. timestamp plus session/sequence quality;
6. independent witness where required;
7. transformations, exports, screenshots or summaries applied to the raw evidence;
8. gaps/tamper/clock/configuration uncertainty;
9. evidence provenance label;
10. final bounded conclusion and explicit UNKNOWNs.

Include adversarial examples where an HMI screenshot, command echo, copied CSV, stale log, mismatched safety signature, edited screenshot, missing raw trace, or undocumented wiring change weakens or invalidates a conclusion.

Before starting, re-read current main and the primary safety lane's newest durable work. If the primary lane has moved into evidence provenance/chain-of-custody, switch to another independent open branch rather than duplicate it.
