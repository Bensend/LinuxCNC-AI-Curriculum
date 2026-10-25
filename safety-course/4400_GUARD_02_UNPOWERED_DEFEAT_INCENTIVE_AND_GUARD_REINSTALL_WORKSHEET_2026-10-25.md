# 4400-GUARD-02 — Unpowered guard-use and reinstall observation worksheet
**2026-10-25 | PAPER/NO-ENERGY preparation | no selected observations, no physical safety test**

## Purpose
Evaluate whether a **proposed guard design is likely to be used correctly** during the tasks that encourage bypass. Grounded in [original Schmersal ISO 14119 interpretation audit](../research/4400_SCHMERSAL_ISO14119_2024_DEFEAT_INCENTIVE_TASK_MATRIX_OEM_AUDIT_2026-10-25.md) and OSHA guard usability guidance. **This is not a substitute for functional safety validation.**

**Preconditions:** only a qualified person may determine that a real machine is fully isolated and mechanically secured for any physical observation; no ram motion, pressure work, energized controls or people inside an unqualified hazard zone. Prefer tabletop/cardboard mock-ups and paper walk-throughs when machine isolation is unproven. Do not perform an interlock-defeat demonstration.

## Blank task/mode incentive matrix
| Task | Mode | Allowed with protection intact? | Why bypass seems easier (speed/view/force/travel) | Design change that removes incentive | New risk/required independent safety witness | Evidence/status |
|---|---|---|---|---|---|---|
| Change die | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | Gravity restraint, access | NOT OBSERVED |
| Load short sheet | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | Front field, sheet whip | NOT OBSERVED |
| Rear backgauge setup | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | Rear occupancy, both motion sources | NOT OBSERVED |
| Clean/remove scrap | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | Isolation, stored pressure | NOT OBSERVED |
| Diagnose fault | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | Reset and retained command | NOT OBSERVED |

## Usability evidence — no invented targets
For each **mock-up** task, record participant role (no PII), selected mock-up revision, start/end observation time, steps/tool changes, whether the guard was correctly reinstalled, visibility, required force/travel, confusion/errors, the user's *own* preferred workaround, and whether the revised design reduces that incentive. Do not predeclare a universal acceptable number of seconds or a “bypass score.” Require reviewer to justify selected usability criteria and **separately** validate all actual protective functions.

## Adversarial design review
1. Does the convenient guard allow reach **over/under/around** it in a new part setup?
2. Is the new cleaning access safe for stored energy and falling loads?
3. Can the guard appear closed while its actual interlock target is misaligned?
4. Is an easily reopened guard adequate when motion can continue after stop demand? Is selected guard locking needed?
5. Does a simpler reset inadvertently become a **start** or hide a person in the rear zone?
6. Is any nuisance-trip reduction achieved by disabling safety diagnostics or muting coverage?
7. Does a replacement part/fixture invalidate prior proof?
8. Are production convenience, setup access, maintenance isolation and emergency rescue treated as **different** safety states?

**Disposition:** a good usability mock-up earns **HF DESIGN EVIDENCE ONLY**. It does not change PHY-STOP/HOLD/ACCESS/ENERGY/RESTART, independent fresh evaluation, or G0/G1 HOLD / G3/G4 NOT AUTHORIZED until qualified as-built and physical proof exist. No TEST-CONFIRMED machine-safety result.
