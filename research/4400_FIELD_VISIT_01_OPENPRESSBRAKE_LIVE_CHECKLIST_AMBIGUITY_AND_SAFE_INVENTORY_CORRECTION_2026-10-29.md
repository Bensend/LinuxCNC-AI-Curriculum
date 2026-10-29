# 4400-FIELD-VISIT-01 — OpenPressBrake machine-survey instructions versus independent safety gates

**2026-10-29 | Original cross-repository source audit and implemented safety-document correction | NON-GRADUATED.** This is a *source/documentary and human-factors* investigation, not a physical machine inspection, acceptance test, measured stop, or permission to energize.

## Concrete unresolved question

Can an ordinary replacement-board survey checklist accidentally become an implicit instruction to perform electrical measurements, hydraulic/axis motion, or cabinet access before the installed safety architecture is qualified? **Yes, as a documentation ambiguity (SOURCE-CONFIRMED); whether a person has acted on it is UNKNOWN.**

## Exact repository evidence

- Inspected `Bensend/OpenPressBrake` `main` `docs/VERIFY_AT_MACHINE.md`, **prior Git blob `c9eb8874161aedfe9335e38862cdb3a07198f72e`**. The introduction directed recording measurements on the next visit without distinguishing passive inventory from intrusive/live tests.
- In its **Y1/Y2 linear position feedback** section, the prior checklist invited oscilloscope capture while moving slowly using an unspecified safe method. That wording did not establish an independently safe hydraulic ram state, machine isolation, competent test authority, or personnel exclusion.
- The same prior file asked for nominal voltage measurements, pressure-transducer zero output where safe, cabinet/board photos before disconnection, and, under nice-to-have captures, video of the machine sequence if controls still operated. Those are different activities with different exposure pathways; a single checklist did not clearly separate them.
- The `docs/HYDRAULIC_PHASE_STATE_TABLE_REV0.md` at blob `4ddffefa16c31bab3d58411fc9e4de7d1698678a` explicitly says its phase table is **not a release mapping**, retains unresolved chart-to-coil assignments, and sizes proportional field power conservatively. It is not a safety-valve truth table, a proof of Y1/Y2 holding, or authority to exercise a phase.
- The `hardware/REV1_MACHINE_CONFIG.yaml` at blob `deecc689a7d2b2cdad2061456583601a36b09337` describes a **provisional** replacement and an intended retained Pilz safety system; it does not establish the installed active program or physical stop/hold.
- The curriculum's [Stage A A–G request](../safety-course/4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md) and [one-screen status board](../safety-course/4400_G0_BOARD_01_ONE_SCREEN_RESTRICTED_EVIDENCE_STATUS_TEMPLATE_2026-10-26.md) already hold all installed-machine evidence UNKNOWN. This audit adds a *specific cross-repository workflow defect and implemented source correction*, not another first-contact questionnaire.

**Implemented correction:** Updated `Bensend/OpenPressBrake/docs/VERIFY_AT_MACHINE.md` on `main`, commit [`bb1b7886503e8a69107fec432b3d95208dbde0fa`](https://github.com/Bensend/OpenPressBrake/commit/bb1b7886503e8a69107fec432b3d95208dbde0fa), new blob `db059d9dbbddff50a7bfc61e6d705fb7f4722cdb`. A prominent SAFETY HOLD now separates existing documentary/passive observations from cabinet access, electrical/pressure probes, scope connections, motion and live video; it replaces the ambiguous scope instruction with a DEFER classification and prohibits new machine motion for a nice-to-have video. The correction is **SOURCE-CONFIRMED as a committed documentation change**, not TEST-CONFIRMED as improved technician behavior.

## Applicable authoritative source boundaries

1. [OSHA 29 CFR 1910.147](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147): servicing/maintenance with unexpected startup or stored energy requires an energy-control program, isolation, control of stored energy, and verification. A temporary test/positioning step has a separate ordered re-energize/re-isolate process; a checklist checkbox does not authorize it. Applicability and exceptions are task-specific, not presumed for every observation.
2. [OSHA 29 CFR 1910.333](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.333): exposed electrical work normally requires deenergization, appropriate lockout/tagout, and qualified absence-of-voltage verification including possible backfeed; a control interlock is not the energy-isolating device. Work on exposed energized parts is limited to qualified persons using appropriate protective practices when permitted.
3. [OSHA 29 CFR 1910.212](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.212): guarding must address exposed points of operation and other machine hazards. This general rule is not a press-brake-specific measured stopping-distance criterion.

**Evidence class:** DOC-CONFIRMED official regulatory text for the stated general propositions; SOURCE-CONFIRMED exact repository versions; INFERENCE that ambiguous wording can create an unsafe shortcut and that a shorter explicit hold reduces that incentive; UNKNOWN actual as-built machine safety, who visited it, legal applicability of any particular servicing step, whether the revised wording changes behavior; TEST-CONFIRMED none.

## Activity gate — what the checklist may and may not do

| Activity | Gate | Acceptable documentary product | Unsafe inference to reject |
|---|---|---|---|
| Read drawings, OEM manuals, pre-existing dated photos and nameplates | A0 — desk-only | source ID/revision and contradiction list | A diagram equals installed hardware |
| Observe an accessible external nameplate or take an exterior photo without opening/operating machinery | A1 — passive only after location/access safety review | timestamp, perspective, unknowns | Exterior observation proves stored energy absent |
| Open cabinet, remove board, unplug harness, attach probes, check pressure or zero-energy | A2 — qualified task-specific energy control and physical verification | restricted evidence and instrument provenance | E-stop, PLC green or a dark LED is isolation |
| Move Y1/Y2 or X, scope encoder during motion, run a phase, film a new cycle | A3 — separately approved isolated/remote qualified commissioning plan, with independent stop/hold, personnel exclusion, secondary restraint and abort arrangements established first | bounded approved test result with exact machine/config/witness | “Slow” or “safe method” makes exposed motion safe |

A0/A1 are not unconditional permission to enter a danger zone. A2/A3 are **DEFERRED**; this audit does not design or approve those tests. Do not treat remote control alone as proof of physical isolation. Never operate with personnel exposed while minimum safety protections remain unestablished.

## Adversarial failure-path analysis (paper only)

- **Scope trap:** Technician reads “move slowly by a safe method,” uses LinuxCNC jog or E-stop as a substitute for independent hydraulic holding. A command or software feed limit is not a physical stop/hold witness. **Reject A3.**
- **Cabinet trap:** Technician sees a dark HMI or Pilz healthy output and opens a cabinet to measure 24 V; another feed/backfeed remains. Qualified isolation and absence-of-voltage are not evidenced. **Reject A2.**
- **Pressure trap:** A transducer shows zero at one port; trapped cylinder/accumulator volumes or gravity remain. The instrument does not prove all pressure zones or load restraint. **Reject A2/A3.**
- **Video trap:** An engineer requests a fresh machine-cycle video to complete a nice-to-have field record before Stage A evidence. A recording is not necessary to close documentary inventory and may create personnel exposure. **Use historical video only; otherwise UNKNOWN.**
- **Phase trap:** The HOERBIGER chart describes RAPID APPROACH, MUTE PASSAGE, PRESSING, HOLDING, DECOMPRESSION and RETURN; a source-derived normal sequence is not a safety-rated function or an authorization to test each phase.

## Verification and falsifiers

The correction is verifiable by comparing old/new Git blobs and confirming the live-testing instructions are now deferred. It would be **falsified as an effective human-factors fix** if field personnel still interpret the revised checklist as permission to energize, if a downstream checklist overrides the hold, or if the safe inventory is so cumbersome that staff routinely bypass it. No such usability test was conducted.

**Next:** A qualified owner should retain Stage A A–G artifacts in a restricted machine workspace, resolve actual active Pilz/AKAS and Y1/Y2 hold/guard/isolation/restart paths, and only then consider a separate hazard-reviewed physical validation plan. Do not publish confidential wiring or invent pressure, stopping time, PL/SIL, valve truth table or diagnostic coverage. The independent 2520–25F0 evaluator remains unrun. **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.**

## Point-of-use human-factors follow-through (same session)

A second direct review found that a reader might skip the new header and still follow hazardous checkbox text. Therefore eight individual entries in `Bensend/OpenPressBrake/docs/VERIFY_AT_MACHINE.md` were additionally annotated **DEFERRED** at their point of use: installed-board photos requiring intrusive access, both-side board photos, wire-by-pin investigation, live voltage, coil-resistance measurement, zero-pressure sensor output, nominal supply measurement and safety-enable contact reuse. Source commit [`50fd51523f190736d87a45a1f93c97cfccbf8d2b`](https://github.com/Bensend/OpenPressBrake/commit/50fd51523f190736d87a45a1f93c97cfccbf8d2b), new Git blob `42be7527795f2fbd7a3bb7cd9c710f699235546b`. This does not eliminate the later need for qualified measurements; it removes the implication that ordinary survey staff should perform them now. **SOURCE-CONFIRMED** committed text, **INFERENCE** reduced skimming/bypass risk, **TEST-CONFIRMED** no human usability result.
