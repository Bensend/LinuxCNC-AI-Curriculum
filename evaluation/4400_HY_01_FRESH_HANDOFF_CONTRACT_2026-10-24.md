# 4400-HY-01 — fresh-AI hydraulic source-transfer handoff contract

**Created 2026-10-24 UTC. Status: PREPARED / NOT RUN / NOT SCORED.** This is a learner-visible independent handoff assignment, **not** a hidden answer key and **not** a substitute for 2520–25F0 external evaluation or selected-machine physical safety validation.

## Source pack for fresh evaluator

- [4400-HY-01 learner module](../safety-course/4400_HY_01_HYDRAULIC_PRESS_BRAKE_SAFETY_ARCHITECTURE_TRANSFER_MODULE_2026-10-24.md).
- Original OEM manuals: Bosch RE 63124-B (08.2021) https://www.kraemer24.shop/media/c6/6b/c7/1754488661/RE%2063124-B_2021-08.pdf ; Bosch IH04E RE 63129-MON (09.2022) https://www.manualslib.com/manual/2958602/Bosch-Rexroth-Ih04e.html ; HAWE ePRAX B 6340 (04-2026) https://productfinder.hawe.com/downloads/B6340-en.pdf and D 6340 (07-2026) https://productfinder.hawe.com/downloads/D6340-en.pdf ; HAWE SAKB D 6335 (08-2025) https://productfinder.hawe.com/downloads/D6335-en.pdf and NSV D 6368 (06-2026) https://productfinder.hawe.com/downloads/D6368-en.pdf .
- Canonical [selected-machine intake](../safety-course/4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md) and [Safety Design Package](../safety-course/SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md).

**Information separation:** fresh evaluator must not be given prior private solutions, previous scoring, unpublished expected hydraulic truth tables or a prompt that declares the correct answer. Public source-reading materials are allowed. If evaluator has seen a solution, mark `CONTAMINATED` and do not count it as a fresh result.

## Novel hypothetical case: conflicting retrofit packet

A small shop presents **two competing hydraulic press-brake retrofit concepts**, neither verified as installed:

- **Concept A:** a vendor describes `SAKB S` as a complete monitored system, lists separate `NSV060BA03L` anti-cavitation devices, and supplies a service drawing whose pressure gauge symbol is connected to port **A** on a **different `NSV050...` example**. A maintenance technician proposes swapping one NSV for a similar-looking `NSV050BE...` part to make access easier. A five-valve `OK` display is the only supplied feedback evidence.
- **Concept B:** a vendor proposes an ePRAX modular system with a partially legible cylinder-module order code (only `CM...` visible), a generic product brochure showing an accumulator, and a screenshot of the CNC reading normal drive speed and valve status. The vendor claims a safety-related stop can be implemented by LinuxCNC alone because the drive supports zero-speed commands.
- For both concepts, the machine's actual Y1/Y2 hydraulic schematic, cylinder dimensions, gravity load, safety controller, independent linear-scale coupling, guard/occupancy map, mechanical restraint, pressure zones, exact part codes, validated stopping criteria and local restart procedure are **not supplied**.

This is an **invented assessment packet**. No claim is made that these configurations coexist, are physically compatible, or are present on OpenPressBrake.

## Tasks for the fresh learner

1. Create a two-column **source-provenance/variant matrix** with OEM document number, edition, product family, actual part/option identity and the narrow proposition each source supports. Explicitly distinguish a manufacturer **catalog statement** from an **installed-machine fact**.
2. For each concept, list **at least five independent assumptions that must be rejected or left UNKNOWN**. Include pressure/suction port identity, valve feedback coverage, seal/leakage characteristics, gravity/drive-active loss, stored energy, ordinary software authority and maintenance/restart.
3. Construct one **normal control → safety demand → physical final element → independent beam/energy witness** chain for a proposed press-brake hazard, labeling every unproven link. Do not invent a machine-specific valve truth table, pressure, safe speed, stop time/distance or PL/SIL.
4. Prepare `IN-03a/IN-04a/IN-10a` evidence requests for both Y axes and a `PHY-STOP/HOLD/ENERGY/RESTART` verification-plan outline that remains **non-executable** until the intake and isolation/remote test gate are resolved.
5. Give a **human-factors design improvement** that makes correct valve/port identification, guard restoration and rated ram restraint easier than bypass or improvisation. Name the `CHG/VAL/PT` evidence that would become stale after the redesign.
6. State the **operation restriction** for personnel exposure and how experimental research could proceed only if a qualified isolated/remote plan keeps everyone outside the danger zone.

## Precommitment, independent feedback and contamination controls

If a **fresh** learner/evaluator pair is available, create an immutable learner submission **before** revealing any evaluator outcome. The learner response must include (a) primary diagnosis/prediction, (b) causal mechanism, (c) expected externally checkable observation, (d) source path/page and diagnostic sequence, (e) plausible alternatives, (f) falsifier, (g) confidence **0–100%**, (h) actual solution time, and (i) consulted resources. Preserve the original response; write corrections separately.

The evaluator must independently inspect the cited original OEM edition and distinguish source-confirmed facts from inferences; **do not** use the module authoring assistant's self-assessment as an oracle. For a development-bank attempt, score the five `BLIND_FEEDBACK_PROTOCOL.md` dimensions (prediction, mechanism, efficiency, uncertainty/safety boundary, confidence calibration) **0–2 each**, total **/10**, and record error class. If the learner saw a near-verbatim answer, mark `CONTAMINATED`; if source conflict or invalid oracle prevents fair scoring, mark `EVALUATION_INVALID`. This handoff is **not** a sealed benchmark. A miss requires a distinct novel transfer retest, not the same question repeated with an answer pasted into the module.

No physical machine result is available as an oracle. A paper score can support documentary reasoning competence **only**, never personnel-exposed release, hydraulic design acceptance or a `TEST-CONFIRMED` machine claim.

## Evidence and scoring record (blank until independent run)

| Gate | Fresh evaluator observation | Evidence URL/artifact | Status |
|---|---|---|---|
| Exact OEM source and edition selection | | | NOT RUN |
| Correct scope transfer / variant distinctions | | | NOT RUN |
| Ordinary vs independent safety authority | | | NOT RUN |
| Physical stop/holding/energy witness and uncertainty | | | NOT RUN |
| Human-factors and change-control reasoning | | | NOT RUN |
| No fabricated machine-specific physical criteria | | | NOT RUN |
| Freshness / no answer-key exposure | | | NOT RUN |
| Novel case result / correction needed | | | NOT RUN |

**Evaluation rule:** any missing critical physical proof must remain `UNKNOWN/HOLD`, not a guessed pass. Do not self-score, silently grade with the authoring model, or count a completed paper response as physical validation. If a fresh evaluator is unavailable, retain `NOT RUN` and continue independent documentary safety research.

**Safety boundary:** no person-exposed hazardous operation authorized; no live hydraulic valve tests or connection changes are requested.
