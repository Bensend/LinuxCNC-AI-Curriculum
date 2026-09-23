# Safety curriculum checkpoint — 2540 source preparation

## Durable state

- 1000/2000/3000 remain GRADUATED/CLOSED.
- 4000 safety course remains the primary active priority.
- 2520 external information-separated competency execution remains OPEN and branch-local.
- 2530 learner methodology is ready for external/fresh evaluation; `evaluation/2530_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md` now provides a no-solution evaluator protocol. External execution remains OPEN and branch-local.
- The governing `SAFETY_COURSE_RESEARCH.md` names **2540 — Relays, contactors, and the real meaning of a “safety relay”** as the next module.
- Initial 2540 source preparation is durable in `safety-course/2540_SAFETY_RELAY_MEANING_SOURCE_PREP_2026-09-23.md`.

## Initial 2540 evidence

Current manufacturer material establishes:

- Siemens: force-guided/mechanically linked contacts support reliable detection of covered failure-to-open conditions; B10d is a reliability input and not by itself PL/SIL.
- Rockwell Automation: current product data gives a concrete forced-guided vs ordinary relay distinction (`700-HPSXZ24` forced-guided true vs `700-HP32Z24` false).
- Pilz: PNOZ is a safety-function monitoring relay family, reinforcing that a safety relay module is more than a colored ordinary power relay.

Do not overgeneralize family-level material to a specific model or complete machine function.

## Exact next work

1. Execute the 2540 research-lab comparison across **at least five current commercial safety-relay families**. Prefer Pilz, Siemens, Rockwell, Phoenix Contact, Omron/Schneider/ABB-Jokab where accessible.
2. For each selected exact family/model, capture only documented: claimed Category/PL/SIL/PFH where published, response time, safety output/contact rating, reset/start modes, cross-fault behavior, EDM/external feedback behavior, reliability/mission-life assumptions, and relevant environmental/application constraints. Use UNKNOWN for missing data.
3. Reverse-map each feature to the specific dangerous fault or diagnostic proposition it can address.
4. Continue the physics bridge: contact welding, inductive interruption/suppression, switching utilization/use profile, B10d cycle dependence, force-guided feedback, and the boundary between safety-logic relay and hazardous-energy contactor/final element.
5. Build a learner exercise that attacks the false inference `commercial safety relay installed -> complete safety function rated/proved`.
6. Do not run compute unless a concrete unresolved question cannot be answered from authoritative evidence. If compute later becomes justified, use `[self-hosted, openpressbrake]` only.

## Session compute

No simulation/build/synthesis/benchmark/test compute was justified or consumed. No GitHub-hosted runner was used.
