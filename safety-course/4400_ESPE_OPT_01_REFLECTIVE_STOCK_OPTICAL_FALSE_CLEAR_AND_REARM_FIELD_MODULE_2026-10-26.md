# 4400 ESPE-OPT-01 — A green light curtain can miss a hand

**2026-10-26 | 4400 safety curriculum field module | PAPER ONLY / NOT A MACHINE TEST**

## Start with the failure, not the device catalog

A safety light curtain is a **presence detector**, not a mechanical barrier and not a ram-holding device. If shiny stock, a second transmitter, an improperly mounted emitter/receiver or a mirror creates an unintended optical path, the receiver can indicate 'clear' while the protected path is obstructed. A perfectly functional safety relay cannot respond to a hazard the detector fails to report.

**Primary reading:** [exact manufacturer-source audit](../research/4400_ESPE_OPTICAL_FALSE_CLEAR_REFLECTION_CROSSTALK_VARIANT_OEM_AUDIT_2026-10-26.md). Previous lessons on [intentional C4000 blanking](../research/4400_SICK_C4000_BLANKING_OBJECT_MONITORING_EFFECTIVE_RESOLUTION_AUDIT_2026-10-24.md), [laser-scanner shadows](../research/4400_SICK_S3000_OPTICAL_SHADOW_FRONT_SCREEN_REPLACEMENT_CALIBRATION_AUDIT_2026-10-24.md), and [press-brake late detection](../research/4400_OSHA_PRESS_BRAKE_VS_MECHANICAL_PRESS_LIGHT_CURTAIN_SCOPE_AND_LATE_DETECTION_AUDIT_2026-10-24.md) remain separate mechanisms.

## Four authorities that must not be collapsed

| Layer | What it can establish | What it cannot establish alone |
|---|---|---|
| **Optical coverage / sensing** | Exact field geometry, test-piece detection, correct model, clearance from reflections, optical interference control | Machine has actually stopped; ram is held; pressure is isolated |
| **Safety-related controller** | Correct independent evaluation of protective-device OSSDs, diagnostic/restart policy, commanded final-element reaction | Obstruction is detected if optical path is bypassed; mechanical energy is gone |
| **Physical stopping / holding / isolation** | Selected-machine independently witnessed Y1/Y2 stop, gravity-load retention, electrical/hydraulic energy state | No person can reach a hazard before the stop or enter undetected |
| **Ordinary LinuxCNC/FPGA/HMI** | Operator display, diagnostics, normal motion control and recording | Sole personnel-safety authority, sensing coverage proof or safe physical state |

## The job-shop scenario

A press brake originally has a dull work surface and one correctly mounted light curtain. A shiny stainless sheet, polished die or material rack is introduced near the protective field. A green receiver indicator persists. The correct engineering response is **not** 'green means good'. Preserve the machine in a non-hazardous state; identify the exact optical device and manufacturer clearance rules; review whether the new object creates a beam path around the intended obstruction; use the OEM's qualified, controlled optical-coverage validation procedure before any return to service. If physical coverage cannot be demonstrated, change the layout or provide another appropriate guard. A person must not be exposed to the hazard while evidence is missing.

For the **SICK C4000 Select 2016** manual, the manufacturer prints 131 mm minimum reflective clearance at D ≤ 3 m; for **SICK senSe2 2022**, it prints 262 mm at D ≤ 3 m. The different formulas are **teaching evidence of product dependence**, not numbers to apply to an unidentified machine.

## Practical no-energy design review

1. **Identity:** exact sender, receiver, revision, configuration, resolution, mirror models and manufacturer manual.
2. **Geometry:** as-built field boundaries, sender/receiver orientation, cable ends, under/over/around access, mirrors and adjacent systems.
3. **Foreseeable changes:** reflective workpieces/dies, glossy paint, material racks, nearby second light curtains, smoke/dust/fog and cleaning/maintenance modifications.
4. **Detector validity:** qualified OEM-specific test-piece coverage plan (near sender, center, receiver; all legs where mirrors used); no live test authorized by this paper exercise.
5. **Safety reaction:** independent receiver/controller and final-element safety function; actual physical stop and gravity-load hold need separate machine-specific validation.
6. **Return to service:** fail/unknown holds machine out of personnel-exposed service; record changed evidence revision and independent review. Clearing an alarm or pressing reset is not fresh motion authorization.

## Twelve PUBLIC paper-only technician cases — UNSCORED

Each case requires: **(a)** affected safety proposition, **(b)** whether a clear/green indication is sufficient, **(c)** next no-energy evidence, **(d)** physical-release state, and **(e)** practical design improvement. Do not publish hidden answer keys or self-grade.

1. A polished stainless workpiece is moved closer to a previously validated curtain, with no electrical changes.
2. A second curtain is installed on a neighboring station; both appear normal when tested separately.
3. A technician reverses the orientation of one SLC4 sensor so cable ends oppose but some zone LEDs remain green.
4. A corner mirror is added to cover a second side; the only checkout was at the original direct path.
5. A guard panel is repainted glossy white next to the beam path.
6. The OEM SICK C4000 Select reflective-clearance number is copied into a senSe2 drawing.
7. A reflective material bin is placed diagonally beyond the end of a senSe2 protective field.
8. The operator says the LinuxCNC 'Safety Ready' lamp proves nobody can enter undetected.
9. A technician proposes slowing a PLC input filter to suppress nuisance optical trips.
10. The field passes a midpoint test but fails near the receiver; maintenance wants to leave it in service until next week.
11. A sensor bracket is loosened for die changes and tightened by eye without an as-built alignment witness.
12. The curtain reliably detects an OEM test piece but the gravity-loaded ram is not independently proven to hold when protective stop is demanded.

**No score, pass, graduation, or physical validation is implied.** Independent evaluator must use unseen cases and separate answer access under `evaluation/BLIND_FEEDBACK_PROTOCOL.md`.

## Twelve documentary gates — all NOT RUN

| Gate | No-energy reviewer question | Status |
|---|---|---|
| OPT-G01 | Is the selected optical product/revision verified? | NOT RUN |
| OPT-G02 | Is the as-built sender/receiver orientation and field mapped? | NOT RUN |
| OPT-G03 | Are all reflective workpiece, fixture, floor and rack envelopes considered? | NOT RUN |
| OPT-G04 | Is the exact-product reflective clearance rule documented without cross-model transfer? | NOT RUN |
| OPT-G05 | Are adjacent optical emitters/interference and mitigation documented? | NOT RUN |
| OPT-G06 | Are all corner-mirror legs and manufacturer restrictions mapped? | NOT RUN |
| OPT-G07 | Is the OEM test-piece coverage plan qualified, without claiming execution? | NOT RUN |
| OPT-G08 | Are over/under/around/behind access paths closed? | NOT RUN |
| OPT-G09 | Is independent safety controller/OSSD evaluation traced? | NOT RUN |
| OPT-G10 | Are physical Y1/Y2 stopping, holding and isolation witnesses independently planned? | NOT RUN |
| OPT-G11 | Do material, tooling, paint and optical-layout changes reopen dependent evidence? | NOT RUN |
| OPT-G12 | Are failed coverage, reset/rearm and maintenance bypass consequences unambiguous? | NOT RUN |

## Human-factors redesign target

The safe solution should be **easy to keep safe**: clearly marked stock-storage envelope, rigid repeatable keyed mounts, permanently available correct test piece, accessible alignment/inspection route, sensible fixed guards for blind access, and an explicit HOLD signoff. If operators repeatedly remove a guard to load parts, the guard/handling layout needs redesign. Do not teach 'just be more careful' as a substitute for practical safeguarding.

## Machine transfer

- **Press brake:** reflective dies/sheet metal and changing tooling are normal; physical ram hold and late point-of-operation detection are distinct.
- **Mill/lathe:** reflective fixtures or swarf can affect an access-protection concept, but rotating hazards and coastdown require different stopping analysis.
- **Robot/cell:** multiple curtains, mirrors, material bins and whole-body entry make crosstalk and trapped-person restart especially important.
- **Plasma/laser:** bright workpieces, smoke and reflections are plausible optical-environment concerns, but applicability depends on the *actual selected protective device*, not a universal assumption.

**Evidence state:** OEM findings DOC-CONFIRMED; machine effects INFERENCE; LinuxCNC source trace not new; TEST-CONFIRMED none; COMMUNITY-REPORTED none relied on; OpenPressBrake as-built/stop/hold/PL/SIL UNKNOWN. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No machine test, Actions job or compute justified.


## Integration trap discovered during source extension (no extra scored cases)

The Banner SLC4 manual §4.5.4 **prohibits paralleling the OSSDs from separate light-curtain pairs into one input device**. A cost-saving splice is not a valid way to aggregate multiple protected openings. Use separate compatible safety-rated inputs and an independently reviewed safety function, with clear source and wiring provenance. This rule is **exact SLC4 OEM guidance**; do not pretend it proves every possible controller's input topology.

A safety controller may legitimately filter *specified diagnostic test pulses* when its own OEM documentation and safety assessment support it. Rockwell's Studio 5000 safety LC instruction documents such filtering **and explicitly adds filter delay to safety reaction time**. The distinction is between **documented safety-rated pulse compatibility** and **improvised masking of a failed detection/stop demand**. A normal LinuxCNC/HAL input filter does not become personnel-safety-rated because it produces a convenient green HMI. No pulse width, filter duration or stopping-distance number is selected for OpenPressBrake.

**No-energy follow-up:** qualified reviewer separately records (1) each OSSD pair and safety input owner, (2) any optical beam coding/neighbor mitigation, (3) configured safety-rated filter and total response-time evidence, (4) selected final elements and physical stop/hold witnesses, (5) any `CHG` invalidation after modification. Public paper cases and documentary gates above remain **UNSCORED / NOT RUN**.
