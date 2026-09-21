# 4000 Safety Checkpoint — Exceptional-State Manifest

UTC checkpoint: 2026-09-21T04:52Z

## Durable result

Created `safety-course/EXCEPTIONAL_STATE_MANIFEST_PRODUCTION_HANDOFF_PATTERN_2026-09-21.md`.

The study establishes a typed exceptional-state manifest covering controller-readable forces, edits, simulation/bypass/mode state and inspection-only temporary physical aids. It explicitly keeps ordinary `PRODUCTION_CONFIGURATION_CLEAN` authority separate from personnel-safety readiness.

Authoritative evidence added:
- Rockwell Studio 5000 Online Bar aggregates controller, force, online-edit and safety status while preserving them as distinct states.
- Rockwell controller RUN/Remote Run mode does not imply absence of online edits or forces.
- Rockwell PlantPAx exposes explicit bypass status and documented clearing semantics.
- Pilz key-in-pocket is a contrasting safety-related pattern in which retained personnel identity directly inhibits restart until validated sign-out.

## Exact next work

1. Seek a real controller/machine implementation exposing multiple exceptional-state classes programmatically to the running application, not merely in an engineering UI.
2. Prefer evidence that ties this aggregate state to a production handoff/enable while preserving independent safety authority.
3. Investigate documented test-edit/simulation persistence across reboot/download/redundancy transitions only where it changes return-to-production reasoning; do not invent cross-platform persistence semantics.
4. If this source path reaches information-gain stop, rotate to the highest-value open 25C0/25E0 safety branch rather than expanding the manifest synthetically.

No executable compute was justified or consumed. No GitHub-hosted runner was used.
