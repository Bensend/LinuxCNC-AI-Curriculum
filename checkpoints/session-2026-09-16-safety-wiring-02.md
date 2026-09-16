# Safety wiring research session 02 — 2026-09-16

- Session start UTC: `2026-09-16T16:38:10Z`
- Session end UTC: `2026-09-16T16:46:02Z`
- Actual elapsed: `7.87 min`
- Overlap status: `UNKNOWN` — no authoritative concurrent-session marker was available in inspected repository state.
- Compute: `NONE`; documentation/source research only. No GitHub-hosted Actions minutes consumed.
- Status: CHECKPOINTED — continue next invocation.

## Durable work completed

- Added `safety-course/PROFESSIONAL_PRESS_BRAKE_SAFETY_TRACE_02_LAZERSAFE.md`.
- Traced Lazer Safe PCSS-F/L professional press-brake safety architecture through dual E-stop channels, monitored emergency-stop/auxiliary contactor, direct hydraulic safety outputs, Y1/Y2 valve monitoring, ordinary proportional-control outputs and reset/re-enable variants.
- Cross-checked the older PCSS-F/L architecture against the current PCSS-A Series Technical Manual rev 1.25 (released 2024-09-12). The newer manual retains the monitored auxiliary E-stop contactor architecture and extensive monitored hydraulic valve personalities, including separate Y1/Y2 safety-valve feedback and holding-valve monitoring options.

## Key evidence gained

1. `DOC-CONFIRMED`: dual E-stop channel disagreement is itself treated as a fault/E-stop condition.
2. `DOC-CONFIRMED`: a PCSS safety output drives the auxiliary-axis/E-stop contactor and an NC contact returns to a safety input so contactor changeover can be timing-monitored.
3. `DOC-CONFIRMED`: professional press-brake safety authority can extend directly to hydraulic final elements. PCSS personalities provide safety outputs for high-speed, filler/prefill, holding, decompression, safety and Y1/Y2-related solenoids.
4. `DOC-CONFIRMED`: some proportional-enable/proportional-pressure outputs are ordinary outputs while separate hydraulic valve permissions are safety outputs. This is a concrete professional separation between normal motion command and safety permission.
5. `DOC-CONFIRMED`: PCSS valve-monitoring options compare commanded solenoid state with valve monitor contacts and flag switch-on/switch-off disagreement faults. The current PCSS-A manual still provides separate Y1/Y2 safety-valve monitoring and a holding+Y1/Y2 safety-valve monitoring personality.
6. `DOC-CONFIRMED + machine mapping UNKNOWN`: the manuals explicitly treat `hydraulic pump running` as a state separate from hydraulic safety permission. Therefore `E-stop = pump must be off` is not a valid generic assumption. Whether a particular OEM drops its pump contactor remains machine-specific.
7. `UNKNOWN`: the PCSS manual does not tell us which physical power conductors an OEM routes through the auxiliary contactor or the actual hydraulic fail-state/pressure path. A complete OEM electrical + hydraulic drawing pair is still required before claiming where ram-producing energy is physically interrupted on a particular brake.

## Exact next work

1. Continue searching for a publicly inspectable OEM press-brake electrical + hydraulic schematic pair. Prioritize machines using Lazer Safe/PCSS because the controller-side safety architecture is now well mapped and can be joined to an OEM final-element drawing.
2. Trace the OEM auxiliary E-stop contactor contacts: pump motor starter, valve supply, drive enables, backgauge drives, or other loads. Mark every circuit that remains powered.
3. Trace the corresponding hydraulic safe state: Y1/Y2 safety/holding/prefill valves, pump/pressure source, trapped pressure, gravity load and return paths.
4. If complete OEM drawings remain unavailable after a bounded search, checkpoint that source limitation and rotate to the professional servo-machine or robotic-cell comparison branch rather than inventing a press-brake truth table.
5. No lab is justified yet; the unresolved questions are documentary and machine-specific.

## LESSON_LOG append status

Timing is preserved here. The available GitHub connector still exposes whole-file replacement rather than an atomic append operation, and `LESSON_LOG.md` is a large ledger. It was not overwritten from incomplete/truncated content. Append this timing row only through the repository's safe append path when that path is available.
