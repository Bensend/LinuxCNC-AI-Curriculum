# 4400 technician card — Which stop/overrun evidence is actually current?

**Educational documentary exercise only. Do not use as a machine operating procedure.** Manufacturer example: Fiessler AKAS-5M document 1581 (2024-02-15), printed pp. 5, 14, 23, 25, 26; https://www.fiessler.de/default-wAssets/docs/download/AKAS/bdh-akas-5-original-engl-doc1581-v1.0.pdf . Not transferable to another model without source review.

## Four separate questions

1. **Identity and selected setting:** What exact device/revision is installed? What are the actual DIP settings, selected manual, geometry and approved criterion? Is the selected threshold still disputed? Record `UNKNOWN` rather than filling a guessed value.
2. **Initial evidence:** Where are the raw measurements, their sequence and independent instrument/physical witness? Does the acceptance criterion actually apply to this machine, setting, tool and mode? Does the 13/11 source conflict affect the result?
3. **Current automatic check:** What event triggered a new check after power restoration or elapsed time? Which controller actually owns the test? Where is proof that the *new* check executed, and what prevents a stale PASS or failed check from releasing hazardous motion?
4. **Machine safety:** Does an independent physical witness establish the hazard actually stopped/was held? What remains hazardous outside the active optical field (gravity, pressure, workpiece sweep, helper, other access paths)? Is maintenance energy isolation separate?

## Evidence matrix (fill; do not assume)

| Record | Source or measurement | Timestamp/config identity | Safety-related owner | Physical proposition proved | Non-claims / UNKNOWN | Status |
|---|---|---|---|---|---|---|
| Selected catalog, serial, manual, DIP | | | | | | UNKNOWN |
| Ten initial readings / approved quantifier | | | | | | NOT RUN |
| First-stroke / voltage-reset test event | | | | | | NOT RUN |
| Periodic retest event and basis | | | | | | NOT RUN |
| Independent ram stop/hold witness | | | | | | NOT RUN |
| Optical mode/blanking coverage | | | | | | NOT RUN |
| Workpiece/helper and stored-energy hazard closure | | | | | | NOT RUN |
| Maintenance isolation and blocking | | | | | | NOT RUN |

## Counterexample quiz (learner must state missing evidence)

**A.** After a receiver swap, HMI displays green, but the DIP record is from the removed receiver. Can the old stop limit be reused? **No;** current selected-setting provenance and change revalidation are missing.

**B.** A test ran last week. Today power was cycled, and the operator sees the same stored PASS. Is the first-stroke monitor obligation evidenced? **No;** a current execution/result witness is missing.

**C.** A safety PLC shows dual OSSD OFF, but a gravity-loaded ram continues to descend. Does OSSD OFF prove a safe physical state? **No;** final-element stopping/holding and physical motion evidence contradict the intended proposition.

**D.** The test sheet says 11 mm and the other manual page says 13 mm. Is choosing the smaller number automatically an approved engineering solution? **No;** selected DIP, model, manufacturer intent and actual machine validation still require reconciliation.

**E.** The laser field is healthy, but a large sheet lifts and strikes a helper. Which safety proposition was missing? **Workpiece/helper sweep and physical exposure**, not merely beam interruption.

## Stop/hold rule

If the basic safe-to-operate proposition is not evidenced, do not operate with people exposed. Any experimental operation must be isolated/remote, with people outside the danger zone and residual risk explicitly assessed. A worksheet PASS is never a substitute for a selected-machine safety validation.

**F. Setup-to-normal transition:** after tool setup, the overrun monitor has a current PASS but there is no independently evidenced cancellation of the documented temporary optical muting arrangement. **Disposition:** the automatic overrun test and the protective-field restoration are different transactions. Both must have their own safety-related authority and evidence. A normal HMI mode indicator alone is not proof of restored protective coverage. See Fiessler doc 1581 printed pp.25–26.
