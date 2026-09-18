# 4000 Safety Lane-B Checkpoint — 2026-09-18T00:47Z

## Parallel-work check

Primary lane newest durable work at selection time:
- `safety-course/HYDRAULIC_SAFETY_FUNCTION_OBJECTIVE_AND_FEEDBACK_TRACE_2026-09-18.md`
- checkpoint commit `2edf4b88` (`checkpoint: hydraulic safety objective trace`)
- primary next work: monitored hydraulic blocking/fall-protection through pressure/load proof and reset/re-enable.

Lane B deliberately selected a different artifact/evidence package: electrical final-element feedback semantics, specifically certified mirror/mechanically-linked contacts versus ordinary auxiliary indication.

Immediately before the Lane-B durable write, current `main` was still `2edf4b88`; no intervening primary commit or overlapping file appeared. After the study write, current `main` was `71f1de9b`, directly above `2edf4b88`.

## Durable work

Created:

`safety-course/MIRROR_CONTACT_FORCE_GUIDED_FEEDBACK_PROOF_BOUNDARY_STUDY_2026-09-18.md`

Commit:

`71f1de9b0c73ca877f5e09abf9804f6b7ab22848`

## New freeze

**SAFETY OUTPUT COMMAND OFF != CONTACTOR COIL PROVEN DE-ENERGIZED != ORDINARY AUXILIARY CONTACT OFF != CERTIFIED MIRROR/MECHANICALLY-LINKED FEEDBACK SATISFIED != EVERY HAZARDOUS POWER POLE/ENERGY PATH PHYSICALLY OPEN != RESIDUAL/STORED ENERGY ABSENT.**

Manufacturer evidence from Schneider Electric and WEG establishes that mirror contacts and mechanically linked contacts are defined device relationships, not generic names for any auxiliary indication. Mirror/EDM evidence is stronger than a software status or ordinary auxiliary contact, but it remains evidence about the switching device; it does not prove every hazardous-energy path or safe maintenance/entry state.

The study adds a failure-path matrix for welded poles, coil backfeed, EDM-loop bypass/short, alternate energy feeds, residual energy, and HMI overclaim.

OpenPressBrake exact contactors/relays, mirror-contact claims, EDM topology/timing, power-pole mapping, STO relationship, achieved PL/SIL/category/DC, stopping performance, and hydraulic/gravity state remain UNKNOWN pending actual design/machine evidence.

No compute was justified or consumed. No GitHub-hosted or self-hosted runner was used.

## Precise next independent work

Find a complete professional manufacturer/OEM chain exposing:

`dual safety outputs -> two contactors -> certified mirror contacts -> EDM -> welded-pole fault -> restart inhibition -> downstream hazardous-energy interruption`

Prefer evidence that identifies what remains energized after the contactors open. Build a physical-proof matrix rather than assuming `EDM OK = machine safe`.

If the primary lane reaches that exact package first, rotate Lane B to a mirror/EDM-loop short-to-24-V, bypass, and common-cause fault-injection worksheet rather than duplicating it.
