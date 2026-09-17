# Session Checkpoint — Safety Release / STO / Diagnostic-Pulse Receiver Contract

Session start UTC: 2026-09-17T23:35:18Z
Session end UTC: 2026-09-17T23:36:33Z
Elapsed: 1.25 minutes
Overlap status: Lane B committed output-pulse compatibility immediately before this session. Main was re-read first; this session deliberately consumed that checkpoint and extended it rather than duplicating it. No same-file write overlap was introduced.

## Governance state honored

- `START_HERE.md` read first.
- 1000/2000/3000 remain GRADUATED/CLOSED.
- Active work remained 4000 safety course.
- No GitHub-hosted compute was used. No simulation/build/test was justified.

## Durable work

1. `safety-course/PROFESSIONAL_SAFETY_RELEASE_TO_STO_TO_START_TRACE_2026-09-18.md`
   - Festo application note 100245 closes the generic electrical chain from safety acknowledgement through safety outputs to dual-channel drive STO, then functional-control permission and a separate ordinary START.
   - Frozen: `SAFETY RELEASE != STO RELEASE != FUNCTIONAL ENABLE != FRESH START != MOTION`.
   - Pilz personnel-retention output to any specific Festo/OpenPressBrake final element remains INFERENCE, not source-confirmed.

2. `safety-course/SAFETY_OUTPUT_PULSE_TO_STO_RECEIVER_CONTRACT_2026-09-18.md`
   - Reconciles Lane B output-pulse work against a real Festo CMMT-ST STO receiver.
   - Manufacturer-specific receiver evidence includes explicit pulse-width/spacing and two-channel relationship restrictions plus STA diagnostic feedback.
   - Frozen: `SOURCE PULSE SPEC + RECEIVER PULSE TOLERANCE + CHANNEL RELATIONSHIP + FEEDBACK CONTRACT` are one safety interface.
   - Festo timing values remain manufacturer-specific and are NOT imported into OpenPressBrake.

## Evidence boundary

The electrical drive example now closes `safety output -> STO receiver -> STO diagnostic feedback -> separate ordinary START`, but does not prove personnel clearance, shaft standstill, brake/load holding, hydraulic energy state or maintenance isolation. OpenPressBrake selected safety outputs, STO/contactors/hydraulic interfaces, pulse timing, PL/SIL/category and acceptance thresholds remain UNKNOWN.

## Compute

No simulation/build/test compute. No Actions minutes consumed. Standard engineering and authoritative manufacturer evidence resolved the questions.

## LESSON_LOG safe-append payload

`LESSON_LOG.md` fetch remains truncated and the available GitHub connector exposes whole-file replacement rather than an atomic append primitive. Do not reconstruct/overwrite it from an incomplete fetch. Safe append this exact row when the repository's append-capable path is available:

| 2026-09-17 | 4000 safety — release/STO/separate START + diagnostic-pulse receiver contract | 2026-09-17T23:35:18Z | 2026-09-17T23:36:33Z | 1.25 | SAFETY SOURCE TRACE ADVANCED | Continue hydraulic monitored-valve/fall-protection final-element trace, or another complete professional chain that exposes retained-person state through physical final elements. | No destructive log write: connector view truncated. Lane B overlap was consumed/reconciled rather than duplicated. No lab compute. |

## Precise next work

Primary independent branch: professional monitored hydraulic safety-valve/fall-protection implementation exposing `safety demand -> valve state/feedback -> hydraulic objective -> physical load result -> remaining energy`.

If that branch is source-limited, seek a single professional machine/cell implementation that combines retained-person/presence authority with explicit contactor/STO/valve final elements and a separate ordinary START. Preserve UNKNOWN wherever public evidence stops.
