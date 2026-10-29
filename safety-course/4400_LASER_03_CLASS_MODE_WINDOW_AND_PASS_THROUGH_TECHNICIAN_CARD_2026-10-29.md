# 4400-LASER-03 — Accessible radiation is mode- and wavelength-dependent (technician card)

**2026-10-29 | PAPER ONLY / NOT SCORED / NOT MACHINE VALIDATED.** Read [original safety investigation](../research/4400_LASER_03_ACCESSIBLE_RADIATION_MODE_WINDOW_AND_ACTIVE_GUARD_OEM_AUDIT_2026-10-29.md) and the 2590 guard/access material. These questions do not reopen the completed 3300 specialization or replace independent 2520–25F0 evaluation.

## Practical cases — write the physical proposition and required evidence, not a green-bit answer

1. A CNC laser is labeled Class 2 when its enclosure is closed. A keyed long-stock pass-through option is installed. Is the old accessible-radiation claim automatically valid? What exact model/option/manual and mode evidence is needed?
2. An operator removes a transparent panel to improve camera visibility. LinuxCNC reports laser OFF. Which independent emission-inhibit and maintenance-isolation questions remain unanswered?
3. A replacement window has OD7 at **one** wavelength range. The installed laser has a different wavelength. What must be checked before considering the replacement acceptable? Why is clear appearance not evidence?
4. A manufacturer advertises an active-window safety-input reaction of <25 ms. May that value be used as the machine's complete beam-extinction time or barrier burn-through time? Identify the separate physical witness.
5. A direct beam strike damages the active window; the alarm is reset. Is operation permitted without qualified investigation/replacement/revalidation?
6. A long-stock job requires the operator to hold open an access door every cycle. Identify the human-factors design defect and a practical engineered workflow alternative that preserves independent personnel protection.
7. A power outage occurs while a laser job is running. On power restoration, which **fresh deliberate action** and independent conditions must be established before laser emission? Which additional fire, fume, axis-motion and stored-energy hazards remain separate?
8. A builder proposes relying on M62/M63, a LinuxCNC HAL pin and a controller FPGA output as the only guard-to-laser shutoff path. Classify each as normal process control, monitoring or personnel-safety authority, and name the missing independent final-element proof.

## No-energy reviewer worksheet

| Required field | Record without inventing |
|---|---|
| Exact machine/source and options | model/revision/firmware, authorized modes |
| Accessible-radiation boundary | enclosure/openings/pass-through, reflection, wavelength and emission class per mode |
| Guard/window | manufacturer part, rated wavelength/OD, damage and replacement rules |
| Independent safety | guard/mode logic, emission inhibit or shutter path, physical witness and fault reaction |
| Restart/service | fresh start, restricted access, isolation, residual energy and qualified review |
| Evidence status | DOC / SOURCE / TEST / INFERENCE / UNKNOWN; date and responsible role |

**Minimum operating threshold:** if the machine's hazardous laser radiation cannot be demonstrably contained or otherwise independently controlled for the intended mode, **do not operate with people exposed**. Experimental work is not authorized by this card; a separately approved isolated/remote arrangement must keep people outside the hazard zone and identify residual risk. Do not use generic goggles, software interlocks, taped switches or unqualified replacement windows as substitutes for the engineered boundary.
