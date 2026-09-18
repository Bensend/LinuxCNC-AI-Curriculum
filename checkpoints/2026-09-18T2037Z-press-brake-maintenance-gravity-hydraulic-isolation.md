# Safety checkpoint — press-brake maintenance gravity/hydraulic isolation authority

Date: 2026-09-18
UTC session start: 2026-09-18T20:35:09Z

## Completed

Created `safety-course/PRESS_BRAKE_MAINTENANCE_GRAVITY_HYDRAULIC_ISOLATION_AUTHORITY_TRACE_2026-09-18.md`; substantive commit `ec677f76abccecd93b499e638fb9347018cbf505`.

## Reconciled repository state / overlap

The latest durable checkpoint observed before selection was `d20d35cca89cf2b997f583e77f51b31efdaa6f6f`, a parallel Lane-B maintenance energy-isolation study. Rather than overwrite its generic OSHA-derived boundary or shared `PROGRESS.md`, this session closed a distinct evidence gap with same-machine press-brake OEM evidence from TRUMPF TruBend Series 2000 (B35).

## Frozen result

`ORDINARY STOP != MAIN ISOLATOR OFF != MAIN ISOLATOR PADLOCKED != PRESSURIZED COMPONENTS RELIEVED != GRAVITY LOAD LOWERED/SECURED/SUPPORTED != HYDRAULIC COMPONENT SAFE TO REMOVE != SERVICE COMPLETE != MACHINE PHYSICALLY REASSEMBLED != ENERGY RESTORED != FUNCTIONAL TEST COMPLETE != SAFETY AUTHORITY RESTORED != FRESH PRODUCTION START`.

`PUMP OFF / STO / SAFETY OUTPUT SAFE != PRESS BEAM PHYSICALLY RETAINED FOR HYDRAULIC SERVICE`.

TRUMPF explicitly states that the press beam falls if hydraulic components are removed first; its disassembly guidance requires moving/suspended loads to be lowered or secured/supported and pressurized assemblies to be relieved. Its maintenance guidance requires main-switch shutdown secured with a padlock unless expressly directed otherwise. Commissioning is performed by Technical Service and includes a functional test.

## Evidence limit

The public TRUMPF operator/installation manual does not expose the post-repair hydraulic/safety functional-test sequence, exact physical beam-support device, pressure criteria, redundant-retaining-element disagreement handling, or fresh production-start sequence. Those remain UNKNOWN.

A second source search surfaced an MVD hydraulic press-brake user guide, but the public PDF was too large for reliable retrieval in this environment; do not claim its unseen maintenance content.

## Compute

No executable verification was justified. No self-hosted or GitHub-hosted compute was consumed.

## Precise next work

Find a professional press-brake service/commissioning procedure exposing `reassembly -> physical load-support/restraint restored -> pressure/energy restoration -> hydraulic/final-element proof -> safeguarding functional test -> safety reset/rearm -> separate fresh production START`, preferably with an explicit failed redundant retaining valve / disagreement disposition. If public service documentation remains inaccessible, rotate to another open safety module rather than infer the sequence.
