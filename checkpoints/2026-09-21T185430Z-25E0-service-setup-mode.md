# 25E0 checkpoint — service/setup operating-mode authority separation

Date: 2026-09-21

## Durable progress

- Added `safety-course/25E0_SERVICE_SETUP_MODE_AUTHORIZATION_AND_ENABLING_BOUNDARY_2026-09-21.md`.
- Siemens evidence freezes that a mode selector must not itself trigger machine operation; setup with exposed personnel uses an enabling mechanism and separate deliberate motion command, with machine-specific reduced/controlled motion according to risk assessment.
- Pilz PITmode provides an independent professional architecture separating user permission from functionally safe mode selection, with explicit configurable behavior when the authorization transponder is removed.
- This reinforces the reusable authority chain: `identity/permission -> safe mode selection -> enabling/protective condition -> separate ordinary motion demand -> production re-entry`.
- Public evidence inspected does not justify a universal held-demand behavior across service-to-automatic transition; demand freshness remains an explicit state-machine/validation requirement.
- No executable compute was justified. No GitHub-hosted runner was used.

## New freezes

- `AUTHORIZED USER != SAFE MODE SELECTED`.
- `SAFE MODE SELECTED != HAZARDOUS MOTION AUTHORIZED`.
- `ENABLING DEVICE VALID != MOTION COMMAND`.
- `MODE SELECTOR != START DEVICE`.
- `SERVICE MODE EXIT != PRODUCTION START`.
- `ACCESS PERMISSION != PERSONNEL-SAFETY RELEASE`.

## Exact next work

Trace **service/setup exit and automatic re-entry** in one or more professional machine/application implementations far enough to determine whether ordinary motion demand must be newly asserted, and how guard/protective-function restoration, enabling-device release, reset/rearm and automatic-mode selection interact. Prefer actual machine-tool/robot application manuals over generic product catalogs.

If exact held-demand semantics remain undocumented, record the information-gain stop and rotate to another open safety branch such as maintenance-bypass validation records, safe reduced-speed commissioning, or safeguard-defeat human factors. Do not invent the transition algorithm.
