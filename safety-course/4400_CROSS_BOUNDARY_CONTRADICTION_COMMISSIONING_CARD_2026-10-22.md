# 4400 technician card — Cross-boundary contradiction and safe-access proof

**Status:** educational commissioning/qualification worksheet, **NOT RUN**. No machine safety function is validated by completing the paper exercise. Use alongside `SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md`, `SO_FINAL_ELEMENT_IMPLEMENTATION_SPEC_TEMPLATE.md` and `SELECTED_SAFETY_BLOCK_QUALIFICATION_WORKSHEET.md`.

## Scenario

A generic hydraulic press brake uses LinuxCNC for normal positioning, an independent safety controller for guard/protective demands, a monitored valve assembly, a guarded work area and a hydraulic accumulator. The HMI reports `ESTOP OK`, `VALVES OK`, `GUARD OK` and `PRESSURE LOW`. A maintenance technician reports slow beam movement after stop and difficulty operating the inside escape release. The exact hydraulic schematic, sensor targets, load restraint and guard hardware are **UNKNOWN**. These statements are a fictional exercise, **not a report about any installed machine**.

### Assignment 1 — Identify what is actually observed

Fill the table without treating the HMI labels as physical facts.

| Indication or observation | Who generated it? | Exact observed target and dependencies | Narrowest legitimate claim | Broader claim NOT established | Required independent witness |
|---|---|---|---|---|---|
| `ESTOP OK` | | | | | |
| `VALVES OK` | | | | | |
| `GUARD OK` | | | | | |
| `PRESSURE LOW` | | | | | |
| Reported beam movement | | | | | |
| Inside escape release difficult | | | | | |

**Decision checkpoint:** If the beam-safe or escape proposition is unproved, mark `PHY-*` **NOT ESTABLISHED** and `VAL-*` **BLOCKED / NOT RUN** as appropriate. Do not authorize personnel-exposed operation or entry based on green indicators. A disputed physical observation needs a safe independent check, not an automatic presumption that either signal is correct.

### Assignment 2 — Separate the four physical functions

For the selected machine, supply evidence for each function **individually**; enter `UNKNOWN` where not available:

| Function | Physical element and energy path | Feedback target | Credible single fault/common dependency | Machine-level witness | Evidence status |
|---|---|---|---|---|---|
| Protective stop / motion cessation | | | | | UNKNOWN |
| Load holding / gravity restraint | | | | | UNKNOWN |
| Hydraulic pressure isolation/discharge | | | | | UNKNOWN |
| Maintenance isolation and personnel protection | | | | | UNKNOWN |

A valve being closed does not necessarily discharge a trapped volume; discharge does not necessarily hold a gravity-loaded beam; a stopped beam is not proof that stored hydraulic or electrical energy is isolated for servicing.

### Assignment 3 — Access and reset transaction

Record separate evidence for (a) protective stop demanded, (b) final element acted, (c) physical hazard state achieved, (d) guard unlocked, (e) person can escape physically, (f) no person remains exposed for restart, (g) independent deliberate safety reset accepted, and (h) ordinary start requested. For each transition, identify the **safety-related authority owner** and the **physical witness**. The normal LinuxCNC software latch may display a state or request a stop but must not become the sole authority for (c), (d), (f) or (g).

Challenge the proposed system with these **design-review stimuli** (do not inject faults on an unsafe real machine): held-high reset during startup; wrong-but-plausible valve-position feedback; a pressure gauge on the wrong side of a shut-off; guard closed but not locked; escape release under credible door load; person inside after the entry field clears; power loss while a protective cycle needs accumulator energy; restored power with a retained ordinary cycle-start; changed CTP-I/CTP-L part; a blocked bleed return; incoming crew member with no personal lock. For each, record the SRS/PHY/DEP/VAL/CHG status and whether rearm/entry remains prohibited pending proof.

### Assignment 4 — Human-factors redesign

Choose at least two changes that make the **safe path easier** without weakening protection. Evaluate a labeled, accessible pressure-test point; clear independent diagnostic messages distinguishing `VALVE POSITION` from `BEAM HELD`; captive/hinged guard hardware; escape release that is physically accessible from inside; remote observation that avoids unnecessary entry; and a lockbox/crew handoff procedure with visible individual-lock state. For each, identify a foreseeable shortcut it reduces and a new failure mode it introduces. A camera does not by itself prove occupancy, and a convenience feature is not a safety rating.

## Acceptance and evidence rules

This is a **qualification design review**, not a substitute for actual commissioning. A completed paper table may be marked `DOCUMENT REVIEW COMPLETE`, but `VAL` physical cases remain `NOT RUN` until a selected-machine safe test plan, instruments, limits, personnel exclusion and independent evidence exist. Do not write `PASS` because a PLC flag changed. Actual stopping time/distance, pressure thresholds, drift tolerance, escape forces, load ratings, diagnostic coverage and PL/SIL are `UNKNOWN` until justified for the selected design.

**Critical fail** in a learner answer: treating software E-stop as personnel-safety authority; treating one pressure tap as all-zone depressurization; treating valve-position feedback as ram restraint; assuming closed guard means locked/escapable; allowing maintenance based on a production interlock; accepting reset/power restoration as ordinary cycle start; or inventing hydraulic/physical limits.

## Cross-machine transfer

- **Mill/lathe:** substitute spindle coast, chuck/workpiece inertia, stored drive energy and enclosure guard locking for the hydraulic beam. STO is not proof of standstill or electrical isolation.
- **Plasma/laser:** substitute torch energy, fumes/fire/extraction and external power sources; LinuxCNC stop is not maintenance isolation of process power.
- **Robot/automated cell:** substitute whole-body access, blind zones, gravity/external-force axes and reset station visibility; a clear scanner field does not prove the cell is empty.
- **Press brake:** preserve separate front/rear/side exposure, beam holding, sheet-sweep/helper hazards, stored fluid energy and physical escape.

**Reviewer handoff:** record `BND/ENE/HAZ/SF/PHY/SRS/AUTH/DEP/HF/ARC/VAL/PT/CHG/UNK/RR` IDs, current source revisions, UNKNOWNs, stale downstream dependencies and the next specific physical witness needed. External 2520–25F0 blind/fresh evaluation remains open; do not self-score hidden challenges.

**Minimum threshold:** If a required personnel-protection proposition is not established, the machine must not operate with people exposed to that hazard. Experimental work must be isolated/remote with people outside the danger zone and residual risk documented.
