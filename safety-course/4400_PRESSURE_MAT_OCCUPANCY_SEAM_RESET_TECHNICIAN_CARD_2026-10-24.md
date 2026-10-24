# 4400 technician field card — safety mat occupancy, seams, reset and physical stop
**2026-10-24 | Paper exercise only / NOT a blind evaluation / NOT a commissioning authorization.** Read the [original OEM source audit](../research/4400_PRESSURE_MAT_OCCUPANCY_DEAD_ZONE_RESET_AND_OEM_SCOPE_AUDIT_2026-10-24.md). The scenario facts are hypothetical; no actual OpenPressBrake mat is asserted.

For **each** case, write (a) what safety proposition is and is not established, (b) what device/controller/final-element evidence discriminates the hypotheses, (c) an anti-defeat design improvement, (d) what physical test is still needed, and (e) whether exposed operation must remain prohibited. Label every claim DOC-CONFIRMED, INFERENCE or UNKNOWN; do not assign invented PL, response time, stopping distance or hydraulic behavior.

| Case | Field observation / misleading claim | What must be investigated |
|---|---|---|
| PM-T01 | Two mats illuminate a common green 'machine enabled' LED, but their joining trim has been removed to route a cable. | Effective joint sensing and access path; safe repair rather than bypass. |
| PM-T02 | A floor mat is covered with a sheet of plywood to move material carts. | OEM prohibition on added coverings; alternative protected logistics route. |
| PM-T03 | An adult weighing 35 kg actuates the selected Rockwell mat. Technician concludes every 20 kg child will be detected because ISO 13856-1 mentions 20 kg designs. | Product-specific detection population versus general standard scope. |
| PM-T04 | A perimeter mat trips as someone enters, but they can step onto a fixed machine base beyond the mat and remain there. | Difference between approach trip and continuous presence detection; independent rearm prevention. |
| PM-T05 | A rear gate opens and the mat remains clear, yet a technician is on a maintenance platform above the mat. | Alternative occupancy/escape protection, raised standing surfaces. |
| PM-T06 | A safety mat controller in auto-reset re-enables when the worker steps off; an old LinuxCNC cycle demand is still asserted. | Separate machine safety rearm, new start command and retained-demand invalidation. |
| PM-T07 | A Rockwell manual-reset unit stays OFF after a power outage until reset; integrator claims the reset button may start the press cycle. | Reset versus start authority and physical motion inhibition. |
| PM-T08 | A 35 ms MatGuard response time is used as the entire ram stopping time in a protective-distance calculation. | Worst-case final-element response, mechanical/hydraulic motion and applicable current standard. |
| PM-T09 | An OEM single-contactor wiring example is copied to a press with gravity-loaded Y1/Y2 axes. | Welded-contact path, independent final elements and mechanical load restraint. |
| PM-T10 | A Schmersal SMS5 replacement is connected by color to a former SMS4 installation. | Exact conductor mapping, compatible monitor, end-to-end diagnostic/fault proof. |
| PM-T11 | Five SMS mats work, so a sixth is added because a different Rockwell brochure permits 100 m². | Exact Schmersal five-mat/loop-impedance limits; product family non-transfer. |
| PM-T12 | A controller auxiliary status says 'clear' while the machine safety output has failed and hydraulic pressure is trapped. | Non-safety status versus independent output and physical stop/hold/energy. |
| PM-T13 | Floor trim lifts after repeated pallet traffic, causing nuisance trips. The team proposes disabling the mat during setup. | Fix mechanical usability and task design, not defeat safety function. |
| PM-T14 | A service team tests mat continuity by standing on it while the machine can still cycle. | Manufacturer commissioning first disconnects prime mover; require qualified isolated test plan. |

**Cross-machine transfer:** For a press brake, explicitly separate rear-area occupancy from point-of-operation safeguarding, ram Y1/Y2 load holding and hydraulic isolation. For a robot cell, account for platforms, fixtures, ladders and escape. For a plasma/laser table, floor occupancy does not eliminate fumes, hot material or laser hazards. For a mill/lathe, the mat does not replace enclosure/door interlocks or spindle stopping.

**Stop rule:** If coverage, safety output, physical stopping/holding or restart cannot be established, classify **HOLD / NOT AUTHORIZED**. No person should be exposed to the hazard in experimental operation. The card is learner-visible and **cannot** be counted as an independent fresh-AI blind score.
