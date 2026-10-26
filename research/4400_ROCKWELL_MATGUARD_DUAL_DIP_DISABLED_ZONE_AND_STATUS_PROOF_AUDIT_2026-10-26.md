# 4400 MAT-CFG-01 — Disabled pressure-mat input is not an electrical fault

**Status:** original OEM documentary source audit, 2026-10-26; no physical test. **Scope:** Rockwell MatGuard Mat Manager 440F-C28011/12/13/23/24/25/26 families as explicitly covered by publication 440F-UM001C-EN-P, December 2024. Not an OpenPressBrake installed-part claim.

## Evidence and exact source
- Original manufacturer PDF: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/440f-um001_-en-p.pdf
- PDF pp. 38–39, "Safety Mat Selection" and Figure 31: factory configuration enables all inputs; unused inputs may be disabled with **two rows of internal DIP switches**; settings take effect on power-up. A discrepancy between rows produces Internal Error. **DOC-CONFIRMED.**
- PDF pp. 52–53, "Electrical Functions Check": an individual mat status indicator is **green for connected/clear** and **off for input disabled via DIP**, distinct from red for actuated. **DOC-CONFIRMED.**
- PDF pp. 59–61, "Status Indicators and Troubleshooting": green = run, red = stop, off = unused/disabled; internal error deenergizes relays; mismatched switch rows and changing switches during operation are cited fault causes. **DOC-CONFIRMED.**
- PDF p. 13 and pp. 19–22: intended adult detection 35 kg or more; full floor coverage and bypass-resistant geometry required. **DOC-CONFIRMED.**

## Critical distinction: internal redundancy versus wrong coverage configuration
A matched two-row DIP setting that intentionally disables a particular input is a **valid configured state**, not the mismatch fault that generates Internal Error. Thus **INFERENCE:** redundant configuration comparison cannot establish that the configured active mat count matches the as-built protected floor. A disabled input may show an off indicator while the machine-side safety outputs can otherwise be enabled after proper reset, subject to other inputs and circuitry. The OEM does **not** state that disabling an installed mat is a valid protective configuration.

### Change-control failure path (hypothetical, NOT TEST-CONFIRMED)
1. As-built guarded perimeter relies on eight active floor zones. 
2. During replacement or commissioning a technician changes both switch banks to seven active zones; the redundant switch banks now agree.
3. An eighth zone remains physically in place or a space becomes uncovered, but its input is intentionally disabled.
4. A dashboard reads only aggregate 'Machine Enabled'; the unprotected floor position is not apparent to an operator.
5. A person reaches the hazardous area via that position. A normally functioning Mat Manager cannot detect occupancy through a channel intentionally removed from its configured coverage.

This is a **hazard-analysis counterexample**, not an assertion that the controller has failed, a specific output is ON, or any selected machine has this topology. If no such mat is installed, this case is a transfer exercise only.

## Engineering controls and verification propositions
- Preserve a signed **zone-to-input map** (floor coordinates, mat part/serial, mat number, channel, fixed guards and bypass geometry).
- Require configuration baseline (both DIP banks and reset mode), accessible individual-zone indicators and physical inspection; do not credit an aggregate green light as floor-coverage proof.
- Treat every channel disable, floor trim repair, mat removal, guarding relocation and reset-mode edit as **CHG** invalidating the affected **BND/HAZ/SF/PHY/SRS/ARC/VAL/PT** evidence until reverified.
- Make removal/reinstallation of trims easy and alignment repeatable; avoid nuisance trips and inaccessible reset locations that reward bypass.
- **Do not energize a hazardous machine to validate this lesson.** Selected-machine documentary gates remain NOT RUN; qualified physical proof only after independent risk controls, and no personnel-exposed operation before G0/G1 clearance.
- A mat's internal monitoring does not prove gravity-loaded Y1/Y2 stop/hold, hydraulic isolation, or the PL/SIL of the assembled machine.

## Claim ledger
| Claim | Label | Scope |
|---|---|---|
| Both DIP banks select active inputs; mismatch causes Internal Error | DOC-CONFIRMED | 440F-UM001C Dec 2024 pp.38–39, 60–61 |
| Off mat indicator can mean intentionally disabled input | DOC-CONFIRMED | pp.52–53, 59 |
| A matched but incorrect as-built coverage setting may escape internal mismatch diagnostic | INFERENCE | Configuration/geometry counterexample; NOT TEST-CONFIRMED |
| Installed OpenPressBrake mats, zone map, DIP settings, safe stop, PL/SIL | UNKNOWN | No as-built evidence |
| New LinuxCNC source or runtime observation | UNKNOWN / NOT PERFORMED | No source claim or lab |

**Promotion:** exact selected-machine zone map and measured physical stop are CRITICAL G0/G1 blockers; cannot be promoted away. Manufacturer component behavior is teachable now but not machine validation. No simulated laboratory question remains that would close those physical facts.
