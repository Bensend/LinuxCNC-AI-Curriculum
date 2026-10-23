# 4400 — Pilz PSEN ml mounting/escape evidence is configuration-specific

**Source:** Pilz PSEN ml s 1.1/2.1/2.2 original operating manual **1004710-EN-10**, official PDF: https://www.pilz.com/download/open/PSEN_ml_s_1_12_12_2_Op_Man__1004710-EN-10.pdf . Inspected 2026-10-23; 94-page manual, printed pp.42, 79, 83–85. **DOC-CONFIRMED** exact manual statements; no installed-machine validation.

## Source-specific numerical scope (not acceptance values for a machine)

| Configuration in manual | Manufacturer-listed property | Interpretation |
|---|---|---|
| Safety switch, fixing screws parallel to actuator, specified direct mounting | Holding force `FZh=7,500 N` | Narrow **component/configuration** property |
| Same device, screws side-on to actuator | `FZh=5,000 N` | Different orientation, different property |
| Mounting bracket **with handle unit** in supplementary data | `FZh=3,000 N` | A bracket/handle is not automatically covered by direct-mount 7,500 N |
| Escape release accessories 570460, 570462, 570470 and other listed variants | Listed release force 80 N | An accessory characteristic, **not** proof a jammed/obstructed gate can be opened |

Manual printed p.42 explicitly directs the reader to the mounting-bracket technical-details table for holding forces with a bracket. Printed pp.43–46 specify different bracket/actuator installation arrangements. The manual warns that plant/machine safety-function integrity is not identical to a product's published safety characteristics.

**DOC-CONFIRMED physical routing consideration:** Pilz order 570467 product page states bending the push/pull cable can reduce function and service life: https://www.pilz.com/en-CO/eshop/product/570467 . The exact cable, routing, length, accessible inside release, mechanical jam conditions and required functional test must be selected and verified.

## Adversarial change path (INFERENCE)

A technician replaces a direct-mount gate frame with a bracket-and-handle assembly and bends the escape cable around a corner. The old `FZh=7,500 N` sheet and green OSSD indicator are reused. This is not a valid transfer: the selected bracket's mechanical holding evidence and the escape cable's installed actuation are changed, while OSSD status cannot establish that a person can escape a jammed gate or that hazardous motion has physically stopped.

Create `CHG` for the bracket/cable change, mark `SRS/PHY/ARC/DEP/VAL/PT` evidence STALE, identify the exact selected Pilz order numbers and edition, and require qualified isolated-machine verification of mounting, inside escape and independent stopping/holding. Provide access that is easy to use and restore so operators do not defeat the guard. A component's published PL/SIL data cannot be promoted to the whole machine.

**UNKNOWN/NOT RUN:** installed force path, selected mounting kit, actual gate jam loads, trapped-person escape, stop/access timing, load holding, occupancy, hydraulic energy, physical tests. No personnel-exposed hazardous operation is authorized by these documentary findings.

**Related learner exercise:** `safety-course/4400_GUARD_MOUNTING_ESCAPE_FIELD_QUALIFICATION_2026-10-22.md`.
