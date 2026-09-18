# 4000 Safety Lane B Checkpoint — 2026-09-18T01:51Z

## Governance / overlap check

Read START_HERE.md, LEVEL_ORDER.md, CURRICULUM.md, WORK_SELECTION_POLICY.md, PROGRESS.md, current safety-course inventory, recent commits, newest primary durable work, and the latest active primary checkpoint before selecting work.

Primary lane is advancing the HAWE ePRAX hydraulic/fall-protection branch (`068cc618`, checkpoint `80591e93`) and next intends deeper QM2-QM5 hydraulic function tracing/reset integration. Lane B therefore stayed on the independent electrical final-element feedback branch and did not modify primary files.

Immediately after the Lane-B durable commit, `main` was re-read. `655e0689` remained directly above primary checkpoint `80591e93`; no intervening overlapping change appeared.

## Durable result

Created `safety-course/DUAL_CONTACTOR_MIRROR_EDM_WELDED_POLE_RESTART_INHIBIT_TRACE_2026-09-18.md` in commit `655e0689c0cd78bbb951aa09343ea2cd6a93db01`.

Manufacturer evidence from Siemens and ABB closes the bounded mirror-contact failure path:

**MAIN NO WELDED/CANNOT OPEN -> MIRROR NC MUST NOT FALSELY CLOSE -> FEEDBACK LOOP DOES NOT RETURN HEALTHY -> SAFETY LOGIC CAN INHIBIT RESTART.**

The study keeps the complete proof chain separated:

**SAFETY DEMAND -> SAFETY OUTPUT(S) OFF -> CONTACTOR COIL(S) DE-ENERGIZED -> MAIN POWER CONTACT(S) PHYSICALLY OPEN -> MIRROR CONTACT(S) IN EXPECTED STATE -> EDM/FEEDBACK ACCEPTED -> RESTART PERMISSION -> NEW ORDINARY START -> HAZARDOUS OUTPUT.**

New freeze:

**COMMAND OFF != COIL OFF != MAIN CONTACTS OPEN != MIRROR FEEDBACK HEALTHY != EDM ACCEPTED != ALL HAZARDOUS ENERGY ABSENT.**

It also distinguishes IEC 60947-4-1 mirror contacts for power contactors from positive-guidance terminology used for auxiliary contactors/coupling relays, and explicitly challenges feedback-loop shorts/bypass, coil backfeed, shared/common-cause faults, single welded poles, stored DC energy, and non-electrical residual hazards.

No OpenPressBrake contactor topology, EDM timing, category/PL/SIL/DC, stopping performance, hydraulic truth table, pressure value, or physical response was invented. Those remain UNKNOWN until machine/product evidence exists.

## Compute

No simulation/build/test was justified. No GitHub-hosted Actions and no self-hosted runner compute were used.

## Precise next independent work

Prefer a complete professional wiring/application package exposing **dual safety outputs -> K1/K2 coils -> main power poles -> separate certified mirror contacts -> EDM/feedback -> welded-pole fault -> restart inhibition -> actual downstream hazardous-energy interruption** in one trace.

If the primary lane reaches that package first, rotate Lane B to either:

1. feedback-loop short/bypass plus coil-backfeed common-cause fault-injection planning; or
2. stored electrical energy / drive DC-bus hazard after upstream contactor opening.

Do not rotate into the primary HAWE hydraulic/fall-protection evidence package.
