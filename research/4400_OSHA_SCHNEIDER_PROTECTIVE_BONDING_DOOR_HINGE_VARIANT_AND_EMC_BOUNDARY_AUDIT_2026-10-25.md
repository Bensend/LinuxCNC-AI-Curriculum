# 4400-BOND-01 — Protective bonding, door hinges and the false EMC-ground shortcut
**2026-10-25 | original OSHA + exact Schneider product source | NON-GRADUATED**

## New question after PANEL-01
If a retrofit adds a door-mounted HMI, moving cable carrier, VFD, shield drain or panel-PC ground, what evidence shows the *exposed conductive parts* remain protected from a fault? Does a visible braid, hinge, continuity beep or Ethernet shield prove a protective fault-current path?

## Original-source evidence
1. **DOC-CONFIRMED (OSHA official indexed regulation):** 29 CFR 1910.304(g)(5) requires the path to ground from circuits, equipment and enclosures to be **permanent, continuous and effective**. Section (g)(6) addresses metal enclosures and exposed noncurrent-carrying metal parts; (g)(8) addresses the equipment grounding conductor for fixed equipment. Source: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.304 (original page search-indexed; direct open blocked 403).
2. **DOC-CONFIRMED (OSHA official indexed interpretation):** 2011-12-05 OSHA overhead-crane interpretation discusses a separate bonding conductor and cautions against relying on trolley wheels/tracks as the grounding path for that crane context. Source: https://www.osha.gov/laws-regs/standardinterpretations/2011-12-05. This is **not** a general statement that every hinge is unacceptable.
3. **DOC-CONFIRMED (direct manufacturer page):** Schneider Electric USA FAQ FA126108, published 2009-01-13, updated 2026-04-20, says its **specific Square D switchgear** door/panel hinge path was tested under its ANSI C37 context without separate bonding jumpers. Source: https://www.se.com/us/en/faqs/FA126108/. **Do not transfer** that specific product/standard/test to an arbitrary sheet-metal CNC control cabinet or door-mounted HMI.
4. **DOC-CONFIRMED (OSHA):** 1910.304(a)(1) differentiates grounded conductors from equipment grounding conductors. 1910.304(g)(5) addresses protective grounding path; ordinary control 0 V or a signal shield is not an assumed replacement.
5. **SOURCE-CONFIRMED:** none new; no LinuxCNC HAL/FPGA signal can prove physical fault-current continuity. **TEST-CONFIRMED:** none; no resistance/fault-injection experiment.

## Engineering propositions and adversarial transfer
| Proposed proposition | Common wrong shortcut | Better evidence (selected installation) |
|---|---|---|
| PE fault path is effective at the exposed HMI door | “The hinge is metal, therefore grounded.” | Actual enclosure product approval or designed bonding conductor, exact hinge/paint/fastener condition, qualified verification method and acceptance basis. |
| PE remains intact during routine maintenance | “It worked with the door closed.” | Door open/closed range, flex/strain, removable plate, repeated service and reinstallation effects reviewed by qualified designer. |
| PE survives a component change | “Replacement door is identical size.” | Approved variant, coatings/paint, continuity interface, new HMI cable/PE requirements and change review. |
| PE is independent of functional noise grounding | “Ethernet shield or VFD shield drains to earth.” | Manufacturer-approved protective bonding and separate EMC/functional grounding map; do not repurpose a signal drain as PE. |
| Protective bonding is adequate under a fault | “A handheld continuity beep passed.” | Qualified method and installation-specific fault-clearing/impedance/connection evaluation; no invented resistance limit. |
| CNC controller knows PE is good | “HAL diagnostics are green.” | Independent physical inspection/verification; normal software status cannot certify PE. |

## Variant trap
The **Schneider exception is a positive example of an OEM-tested hinge**, not permission to omit a jumper on a generic enclosure. Equally, the slogan “hinges can never serve as bonding” is too broad. The selected product's applicable standard, approved construction, tested conditions, maintenance changes and actual mounted devices decide. If documentation is absent, mark the bonding proposition UNKNOWN/HOLD and select a proven, inspectable bonding method after qualified design.

## Human factors and safety boundary
Prefer easy-to-inspect captive flexible bonding paths and door-mounted HMI routing that survives repeated opening, without making maintenance difficult. Separate PE, neutral, control 0 V and functional EMC bonds in documentation. The qualified electrician owns electrical protection and test; the independent safety designer owns machine stop/hold/restart. No electrical continuity result substitutes for physical Y1/Y2 gravity restraint. No live fault tests, deliberate PE disconnection or numeric continuity thresholds are authorized.

**UNKNOWN:** actual OpenPressBrake door/HMI, PE routing, hinge product approval, power feeds, fault-current basis, door cycles, tests and reviewers. **INFERENCE:** proposed inspection and change-control pattern. **COMMUNITY-REPORTED:** none. Branch documentary information-gain stop pending selected enclosure and manufacturer approval.


## 2026-10-28 exact original CNC OEM indicator caveat (source-depth, not new competency)
**Cincinnati Incorporated, EM-519 (N-08-19) 2019**, [original manufacturer PDF](https://wwwassets.e-ci.com/PDF/Manuals/em-519_n-08-19_proform__400-2000_hydraulic_press_brake_osmm.pdf), printed p. **6-5** (PDF zero-based page 62), directly inspected: its `GROUND CONNECTED` light indicates **an internal chassis ground**, and the manual explicitly says this **does not indicate the machine is grounded**. This is a concrete OEM **DOC-CONFIRMED** counterexample to interpreting a green/illuminated grounding lamp as a verified protective-earth fault path. Existing BOND-01 physical PE topology, continuity/fault-path and change-control gates remain required. **Do not** infer the lamp's electrical circuit, installed OpenPressBrake lamp, actual PE resistance, test result or acceptable protective bonding from the manual. No new public case or physical test; G0/G1 HOLD.
