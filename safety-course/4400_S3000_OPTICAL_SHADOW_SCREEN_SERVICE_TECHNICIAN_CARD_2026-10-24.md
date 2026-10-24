# 4400 technician card — S3000 scanner optical coverage and maintenance calibration
**2026-10-24 | Paper-only, not blind or physical validation.** Study [the exact 2026 SICK manufacturer audit](../research/4400_SICK_S3000_OPTICAL_SHADOW_FRONT_SCREEN_REPLACEMENT_CALIBRATION_AUDIT_2026-10-24.md) and existing [EFI signal audit](../research/4400_SICK_S3000_EFI_UNALLOCATED_FIELD_CLEAR_AND_OSSD_BIT_INTEGRATION_TRAPS_2026-10-24.md).

For each hypothetical case, distinguish **optical detection**, **safe signal semantics**, **independent safety logic**, **physical final element**, **rearm/start**, and **service/validation**. State what is DOC-CONFIRMED and what remains UNKNOWN. No physical test on an exposed machine.

| ID | Observation | Discriminator / required next evidence |
|---|---|---|
| OP-T01 | An operator adds a clear acrylic shield to protect a dusty scanner lens. | OEM transparent-cover warning; remove workaround and engineer serviceable environmental protection without obscuring optics. |
| OP-T02 | A pallet stack is placed between scanner and rear gate; field status is clear. | Shadow geometry; alternative guard/occupancy route, not a software threshold. |
| OP-T03 | Highly polished stock reflects scanner beam; occasional nuisance trips occur. | OEM specular-reflection warning, actual field validation and task/stock change control. |
| OP-T04 | Scanner is replaced with same model, same system plug; crew says no checks required. | OEM distinction: saved config auto-load versus still-required periodic check and machine-level change control. |
| OP-T05 | Scratched front screen replaced; saved configuration loads; technician skips optical calibration. | Required front-screen optical-reference calibration after replacement. |
| OP-T06 | Front-screen calibration was performed on a dirty screen in a hot enclosure. | OEM new clean screen and 10–30 °C product-specific calibration conditions; qualified redo before service. |
| OP-T07 | A Professional I/O module is swapped for an Expert; later someone proposes reverse swap. | OEM asymmetric variant compatibility; exact system plug/config and commissioning. |
| OP-T08 | Universal I/O 'contamination OK' tag is wired through normal LinuxCNC to enable hydraulic motion. | Non-safe diagnostic signal, independent safety-rated output and final elements. |
| OP-T09 | A scanner field is clear but an EFI protective field was unallocated, or local OSSD was unused. | Earlier EFI/OSSD source audit: field-status semantics and safety controller mapping. |
| OP-T10 | Monthly check tests one object point near scanner; raised fixture shadows remain unexamined. | Multi-point field/marked-floor gap inspection and qualified physical proof. |
| OP-T11 | Scanner optics are repaired while the machine remains powered and could move. | OEM unexpected-start/isolation warnings and proper energy control. |
| OP-T12 | The scanner detects entry and safety output drops, but the press brake beam can still fall. | Separate Y1/Y2 physical stop/hold, hydraulic isolation and gravity restraint. |

**Cross-device synthesis:** A floor mat may detect occupancy on its effective surface where scanner shadows exist, but mats have seams, 35 kg/20 kg variant scope, elevated-platform gaps and reset limitations of their own. A mat does not 'repair' a bad scanner, and a scanner does not make mat coverage irrelevant. Fix the hazard boundary and make correct maintenance easy rather than rewarding bypass.

**Pass threshold for learner practice:** correctly identify all six boundaries in at least ten cases, preserve unknown physical data and refuse unsafe exposed-person testing. This is a practice rubric, **not** independent external competency scoring. If the machine lacks a qualified minimum safety function, hold operation with people exposed; experimental testing only remote/isolated with people outside the danger zone.
