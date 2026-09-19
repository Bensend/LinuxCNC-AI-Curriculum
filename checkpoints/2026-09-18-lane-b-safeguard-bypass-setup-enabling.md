# Lane B checkpoint — safeguard bypass / setup enabling — 2026-09-18

## Completed

Created `safety-course/SAFEGUARD_BYPASS_SETUP_MODE_ENABLING_AUTHORITY_STUDY_2026-09-18.md` at commit `172548be1989f0adf09fb37258103c2622973d36`.

This lane intentionally stayed independent of the primary lane's monitored hydraulic final-element disagreement / physical stop-performance work and of Lane B's preceding test-pulse/cross-fault diagnostic work.

## Durable freeze

`MODE SELECTED != BYPASS REQUESTED != BYPASS SAFETY CONDITIONS VALID != NORMAL SAFEGUARD SUSPENDED != SUBSTITUTE SAFETY FUNCTION VALID != ENABLING DEVICE IN VALID MID POSITION != HAZARDOUS MOTION AUTHORIZED != PHYSICAL MOTION SAFE`.

Return-to-production remains separately gated through normal-safeguard restoration/proof, deliberate safety rearm, and fresh ordinary production intent.

## Evidence added

- SICK: temporary manual disabling of protective functions requires a distinct mode, disables automatic/linked sequences, uses sustained-action controls, and applies reduced-risk conditions; mode changes require a new manual start in the documented example.
- SICK UE440/UE470: bypass suspends the normal OSSD response and therefore requires other protective measures such as safe setup mode.
- Pilz PITenable and SICK E100: three-position Off-On-Off enabling devices provide both release and panic/overtravel protective behavior.
- Rockwell GuardLogix MMVC: maintenance-only manual press-valve authority is conditioned by a distinct permissive set and is explicitly not for press production.

No OpenPressBrake mode, bypass, safe speed, force, stopping performance, hydraulic truth table, pressure, PL/SIL/category/DC/CCF, or physical fact was invented.

No executable verification was justified; no GitHub-hosted or self-hosted compute was consumed.

## Parallel-work reconciliation

Immediately before the substantive commit, main HEAD was `c1d09f54bc7487225759aafe5c41daca2eb9a0ae`. Immediately after it, main HEAD was the Lane-B commit `172548be1989f0adf09fb37258103c2622973d36`; no intervening overlapping primary-lane write appeared. Shared `PROGRESS.md` was not edited, avoiding collision with the primary task.

## Precise next work

Find a complete professional implementation exposing:

`mode selector -> safeguard bypass/suspension -> substitute SLS/SDI/SOS or equivalent reduced-risk function -> three-position enabling device -> sustained manual motion -> safety final element -> enabling release/overtravel fault -> direct physical motion stop witness -> bypass removal -> normal safeguard proof -> reset/rearm -> separate fresh production START`.

Prefer a press/press brake/robot cell with wiring or function diagrams and a documented stuck enabling contact, invalid mode, loss of safe-motion feedback, bypass-stuck-active, or power-restoration commissioning case. Do not duplicate the primary hydraulic disagreement evidence package.