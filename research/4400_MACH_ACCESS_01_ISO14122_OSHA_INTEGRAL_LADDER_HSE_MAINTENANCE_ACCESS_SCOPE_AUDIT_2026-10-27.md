# 4400 MACH-ACCESS-01 — machine-integrated access and maintenance openings: original-source audit

**Status:** Original source study, NON-GRADUATED. Examined 2026-10-27 UTC. No physical machine evidence.

## Question and novelty
Does a CNC stop or a ladder that resembles a code-compliant fixed ladder establish safe maintenance access? No. Direct full 971-line canonical safety index scan found no ISO 14122, integral-machine ladder, removable platform grating or maintenance-fall branch. Prior RIG-01 lifting/foundation and BLACKOUT-01 exit lighting address different hazards. This is a distinct fall/exposure mechanism, not a controller feature.

## Source ledger
| Source and access | DOC-CONFIRMED finding | Limit |
|---|---|---|
| [US eCFR 29 CFR 1910.23(a)(2)](https://www.ecfr.gov/current/title-29/subtitle-B/chapter-XVII/part-1910/subpart-D/section-1910.23), directly read, displayed 2026-10-23 | The ladder-specific section excludes ladders designed into or integral to machines/equipment. | Do not transfer this section's fixed-ladder dimensions indiscriminately to an integral machine ladder; the exclusion is NOT an exemption from safe access. |
| [US eCFR 29 CFR 1910.22](https://www.ecfr.gov/current/title-29/subtitle-B/chapter-XVII/part-1910/subpart-D/section-1910.22), directly read, displayed 2026-10-23 | Workplace walking surfaces require control of spills/leaks/corrosion, adequate load support, safe access/egress, inspection, correction/guarding of hazards and qualified structural repair. | Apply only after identifying jurisdiction and facts; not a universal ladder-design table. |
| [ISO 14122-1:2016](https://www.iso.org/standard/61279.html), [Part 2](https://www.iso.org/standard/61281.html), [Part 3](https://www.iso.org/standard/61282.html) | Official publisher **edition/status/scope metadata only**: non-powered machinery-integrated access selection, platforms/walkways, and stairs/guardrails are separately addressed. Published 2016, revision work underway. | Normative text, dimensions, strength factors and retrofit applicability NOT inspected. Do not infer exact measurements or mandatory requirements from catalogue metadata. |
| [UK HSE Maintenance of work equipment](https://www.hse.gov.uk/work-equipment-machinery/maintenance.htm), directly read | Maintenance needs safe access separately from isolation; HSE recounts a worker falling through removed walkway grating when the opening was not protected. | UK guidance and example, not OpenPressBrake physical evidence or a universal US rule. |
| [UK HSE machinery slips/trips/falls](https://www.hse.gov.uk/agriculture/topics/machinery/slips.htm), directly read | Ground-level service points, adequate handholds, slip-resistant steps and convenient storage for extra access are practical risk controls. | Agricultural-sector examples; do not transfer machine dimensions. |

## Three independent hazard propositions
1. **Fall during access:** unstable, contaminated, damaged or improvised route. Even with power OFF, a fall is possible.
2. **Temporary floor opening:** removal of grating/hatch creates a fall hazard to someone other than the maintainer. HSE documented a real event; any OpenPressBrake occurrence is UNKNOWN.
3. **Concurrent machinery energy:** person on platform can reach Y1/Y2 ram, tooling, electrical or hydraulic hazards. LinuxCNC E-stop bit or FPGA disable cannot prove physical ram retention or pressure isolation.

## Two opposite regulatory traps
- Wrong: OSHA 1910.23 specifies a fixed-ladder number, so every integral-machine ladder must use it.
- Also wrong: the integral-machine exception means improvised access is safe or exempt from other duties.
- Correct: classify building vs integral vs portable/mobile access, jurisdiction, manufacturer instructions, selected design standards, loading, structural attachment and safe operating task before choosing design criteria.

## Human factors and engineering
Prefer service from floor level where practical. Where elevation is needed, use suitably designed stable access, reach, handholds, anti-slip footing, lighting and tool handling. Place a physical barrier and alternate route **before** removing any floor panel. Use appropriate captive fasteners or convenient engineered access so reinstallation is easier than leaving a hole or loose cover. Require qualified independent restoration inspection before route reopening; separate that handback from machine rearm.

**Evidence classes:** DOC-CONFIRMED for exact eCFR and HSE text and ISO edition/scope metadata; INFERENCE for architecture transfer; UNKNOWN for installed machine, structural ratings, selected jurisdiction, stop/hold and guards. No new LinuxCNC SOURCE-CONFIRMED, TEST-CONFIRMED or COMMUNITY-REPORTED evidence. No compute or physical test justified. **G0/G1 HOLD.**
