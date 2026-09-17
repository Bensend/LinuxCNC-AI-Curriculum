# Safety Lane B checkpoint — diagnostic event record schema — 2026-09-17

- Lane: independent safety curriculum lane B
- Primary-lane baseline at selection: `b59c508c54e4e8eda0231838e8487083f8fcab69`
- Lane-B artifact commit: `f0e2fcd2e4ffec2f5cf454006d2fd29cbcd2f498`
- Parallel-work check: PASS. Primary lane is advancing professional implementation application of commissioning/common-cause/minimum-operate gates and mode/feedback CCF analysis. Lane B used a separate diagnostic-record artifact and evidence package.
- Pre-checkpoint main re-read: latest main after artifact creation was the Lane-B artifact itself; no newer competing primary commit or overlapping file appeared.
- Compute: NONE. Documentation/architecture question did not justify executable verification. No GitHub-hosted Actions minutes consumed.
- Status: CHECKPOINTED; safety curriculum remains active.

## Durable work completed

Added `safety-course/SAFETY_DIAGNOSTIC_EVENT_RECORD_MINIMUM_SCHEMA.md`.

Frozen rule: **record what each source actually knew, when it knew it, and how fresh that knowledge was; never rewrite command history into physical proof after the fact.**

The schema now preserves source/configuration identity, native event codes, live/history state, validity/freshness, source versus collector timestamps, time quality, monotonic/sequence evidence, boot sessions, power/network/logging discontinuities, safety demand, safety outputs, final-element feedback, physical observations, ordinary LinuxCNC/FPGA context, and separate reset/rearm/START transitions.

It explicitly handles devices whose diagnostic history lacks native timestamps, collector-added timestamps, bounded/ring-buffer histories and overflow/sequence gaps. Missing data becomes `UNKNOWN/UNAVAILABLE`, never inferred safe state.

## Evidence gained

1. SICK HS80/Flexi Soft diagnostics preserve current and historical events with timestamp/local time, source, category, description and detailed diagnostic metadata.
2. SICK Flexi Soft Gateway documentation gives a concrete counterexample to assuming all event histories contain native time: FX0-GETC diagnostic history has no timestamp; a reader may add one at collection time. Its history is bounded and can overflow.
3. Pilz PNOZmulti OPC Server demonstrates event-list diagnostic information exported to subscribed OPC UA clients, reinforcing the separation between diagnostic transport and actual safety authority.

## Exact next independent work

Build `safety-course/SAFETY_INCIDENT_RECONSTRUCTION_EVIDENCE_CONFIDENCE_WORKSHEET.md`.

For a mixed chronology of safety-controller events, ordinary-control logs, EDM/final-element feedback, power/network gaps and physical observations, classify each claimed transition as directly observed, bounded inference, conflicting, stale, or unknown. Preserve source/time/configuration confidence and explicitly allow the reconstruction to remain partially unresolved rather than forcing one narrative. Avoid the primary lane's professional implementation CCF/minimum-operate files and switch branches if that lane enters incident-reconstruction work first.