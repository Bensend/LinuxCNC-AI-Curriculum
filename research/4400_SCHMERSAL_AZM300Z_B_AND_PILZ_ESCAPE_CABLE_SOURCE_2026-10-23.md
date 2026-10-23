# 4400 manufacturer source note — AZM300Z/B output semantics and Pilz escape-cable routing

**Status:** DOC-CONFIRMED manufacturer manuals/product records; INFERENCE change-control implications; machine validation NOT RUN. Study date 2026-10-23 UTC.

## Source A: Schmersal AZM300 Z versus B

Manufacturer original operating instructions, AZM300 short, Section 6.1/6.3, official PDF: https://products.schmersal.com/upload/orig/10/01/06/94/DOC_MAN_MECS_AZM300-Short_SEN_AIN_V4.pdf .

The manual states:

- **AZM300Z:** unlocking the solenoid interlock disables safety outputs. If the actuator remains inserted, relocking can re-enable the outputs without opening the guard. **DOC-CONFIRMED for the stated variant and documented behavior.**
- **AZM300B:** opening the guard disables safety outputs; unlocking alone is not the same signal behavior. **DOC-CONFIRMED.**
- The conventional diagnostic output `OUT` is for visualization/control tasks and is **not safety-related**. **DOC-CONFIRMED.**
- The manual's condition table distinguishes guard open, closed/unlocked, closed/locking impossible, and closed/locked; a generic `guard OK` Boolean erases important distinctions. **DOC-CONFIRMED.**

**Failure path (INFERENCE):** A technician replaces a Z variant with B, or vice versa, and reuses a safety-controller input assumption that equates safety outputs with *lock confirmed*. A controller/HMI may then display a permissive condition for a different physical proposition than intended. The installed safety controller program, catalog suffix, guard geometry and downstream physical hazard remain UNKNOWN; this is not an assertion that the specific machine will restart.

## Source B: Pilz PSEN ml escape-release cable

Manufacturer PSEN ml accessory product record for order 570467: https://www.pilz.com/en-CO/eshop/product/570467 . The manufacturer warns that bending the push/pull cable for the identified escape-release versions can reduce functionality and service life. The product record also links a revised PSEN ml s 1.1/2.1/2.2 operating manual (1004710-10, March 2025). **DOC-CONFIRMED for this accessory/edition.**

**Failure path (INFERENCE):** A machine retrofit moves the guard to a new bracket and routes the escape cable sharply around a frame member. Electrical lock diagnostics can remain plausible while the physical release becomes harder to operate. Neither a manufacturer release-force figure for an accessory nor a prior direct-mount holding-force figure proves escape or retention with the new installation.

## Authority and change-control contract

| Package IDs | Source-driven requirement | Evidence status |
|---|---|---|
| `SRS/PHY` | State whether the required proposition is guard position, guard lock, safe unlock, inside escape, or machine stopped/held | Machine-specific UNKNOWN |
| `ARC/DEP` | Exact Z/B suffix, wiring, controller logic, mounting, actuator, cable path and release device | Machine-specific UNKNOWN |
| `CHG` | Any variant, bracket or cable-route change invalidates affected downstream proof; preserve prior evidence as STALE | OPEN |
| `VAL/PT` | With hazards safely isolated and qualified personnel, independently witness mechanical release and physical stopping/holding; no live trapped-person trial | NOT RUN |
| `HF` | Make access, release, alignment, fault localization and guard restoration easy; reduce predictable defeat incentives | Needs observed task review |
| `AUTH` | Ordinary LinuxCNC/FPGA/HMI may display or request; independent safety controller and actual final elements own personnel-safety function | Architecture must be selected |

**Nontransferable:** Manufacturer component statements are not installed-machine PL/SIL, stopping distance, occupancy proof, gravity restraint, hydraulic truth table, safe-release acceptance, or authorization to expose people to hazards. If basic safe operation cannot be demonstrated, withhold exposed-person operation; any experimental work must be isolated/remote with people outside the danger zone and residual risks controlled.

Related exercises: `safety-course/4400_GUARD_LOCK_ESCAPE_RELEASE_TECHNICIAN_CARD_2026-10-22.md` and `safety-course/4400_GUARD_MOUNTING_ESCAPE_FIELD_QUALIFICATION_2026-10-22.md`.
