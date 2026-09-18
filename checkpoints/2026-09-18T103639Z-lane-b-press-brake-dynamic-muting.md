# Safety-course checkpoint — press-brake dynamic muting state/authority

Date: 2026-09-18
Session start UTC: 2026-09-18T10:35:38Z
Session end UTC: 2026-09-18T10:36:39Z
Actual elapsed: 1.0 minute
Overlap status: no intervening repository commit observed during the substantive write; this session's `9be5f373` remained main tip at final overlap check.

## Governance/current state

Read `START_HERE.md` first, then current mission/level/work-selection/progress state. Active curriculum remains 4000 safety priority; 1000/2000/3000 remain closed. Newest prior durable checkpoint was Lane-B ESPE muting/blanking at `1c366f2c`, whose precise next target was a professional press/press-brake protective-field/muting implementation.

## Durable work

Added `safety-course/PRESS_BRAKE_DYNAMIC_MUTING_STATE_AUTHORITY_TRACE_2026-09-18.md` in commit `9be5f373`.

The study moves from generic ESPE muting into Pilz's professional PSENvip 2 + PSS 4000 / Fast Analysis Unit press-brake architecture. It records DOC-CONFIRMED coupling among tool class, muting endpoint, protected-field mode, monitored position/speed/braking ramp/overrun/protected field and the decision to initiate dynamic muting. It independently uses SICK restart-interlock documentation to preserve reset/OSSD restoration versus separate ordinary START authority without claiming the SICK circuit is part of the Pilz system.

## Frozen lesson

`TOOL/PROTECTED-FIELD CONFIG VALID != POSITION/SPEED/BRAKING/OVERRUN CONDITIONS VALID != DYNAMIC MUTING PERMITTED != DYNAMIC MUTING ACTIVE != PROTECTIVE FIELD EFFECTIVELY RESTORED != RESTART INTERLOCK SATISFIED != SAFETY MOTION AUTHORITY AVAILABLE != FRESH ORDINARY PRESS START COMMAND.`

A muting-active bit/lamp is diagnostic evidence, not proof of correct physical tool geometry, safe speed/position state, effective protective geometry, stopping performance or personnel exclusion.

## Evidence discipline

Exact PSENvip/PSS 4000 dynamic-mut­ing internal state machine, voting/discrepancy timing, fault codes and reset prerequisites remain UNKNOWN from the public material found in this session. No OpenPressBrake protective geometry, stopping time/distance, hydraulic stop behavior, PL/SIL/category/DC or muting endpoint was invented.

No simulation/build/synthesis/benchmark/test-suite compute was justified. No GitHub-hosted Actions minutes were consumed.

## Short-session continuation check

A second targeted search was performed for the actual PSENvip/PSS 4000 dynamic-mut­ing block/application manual. Public search results repeated Pilz's press release/product material but did not expose the block state machine. Continuing to restate the same source would have low information gain. The branch therefore has a precise evidence-reopening target and should rotate if the manual remains unavailable.

## Precise next work

1. Seek an authoritative Pilz PSENvip 2/PSS 4000 application or commissioning manual exposing dynamic-mut­ing inputs/outputs, invalid tool/protected-field/position/speed handling, reset prerequisites and post-reset behavior.
2. If unavailable, rotate to another unblocked safety branch: preferably a professional dual-retaining-element or hydraulic/mechanical disagreement implementation, or a complete perimeter/personnel-retention commissioning sequence.
3. Preserve `RESET != START`, independent safety authority, and physical final-element proof across either branch.

## LESSON_LOG safe-append state

The available GitHub connector exposes replacement writes but no safe append primitive, and the large shared `LESSON_LOG.md` has historically returned truncated content. Per repository rule, it was not reconstructed or overwritten. Append-ready row/data are preserved here exactly:

- start: `2026-09-18T10:35:38Z`
- end: `2026-09-18T10:36:39Z`
- elapsed: `1.0 min`
- overlap: `none observed`
- work: `4000 safety — Pilz PSENvip 2 press-brake dynamic-mut­ing state/authority trace; commit 9be5f373; no compute`
