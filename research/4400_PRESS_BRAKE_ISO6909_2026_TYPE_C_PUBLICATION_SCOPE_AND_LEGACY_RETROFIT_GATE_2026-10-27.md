# 4400-STD-6909-01 — 2026 press-brake-specific ISO 6909, legacy EN 12622 and hydraulic-press scope trap

**2026-10-27 | Original standards-publisher edition/scope research | NON-GRADUATED | Publisher abstracts and public EU decision only; paid normative clauses NOT INSPECTED**

## Why this correction is needed

The prior [2026-10-25 RESCUE-01 Type-C standards audit](4400_PRESS_BRAKE_TYPE_C_SCOPE_AND_TRUBEND_ESTOP_RESCUE_CONFLICT_AUDIT_2026-10-25.md) correctly rejected using ISO 16092-1/-3 hydraulic-press requirements as though they were press-brake Type-C requirements and identified ANSI B11.3-2022 and legacy EN 12622. **It did not mention a genuinely new, already-published press-brake-specific international standard: ISO 6909:2026.** This is a concrete edition/currentness correction, not another generic safety standard lecture.

The engineering question is **which published standard actually covers the machine family and edition as of 2026-10-27, and what may be concluded without access to paid clauses or the installed machine identity?**

## Direct publisher/official evidence

| Evidence | Direct published statement | Scope and limits |
|---|---|---|
| **ISO**, [ISO 6909:2026 official record](https://www.iso.org/standard/83403.html), first edition **2026-05**, published **2026-05-29**, 90 pages | **Machine tools — Safety — Press brakes.** Explicitly covers hydraulic, hydraulic servo-drive, screw servo-drive and belt-spring servo-drive press brakes; presumes access from all directions; addresses foreseeable misuse and life-cycle hazards. | **DOC-CONFIRMED official publisher abstract**. The 90-page normative text, clause tables and acceptance methods were not purchased/read. |
| **ISO 6909:2026** official abstract, exclusions | Excludes beam motion driven pneumatically or by mechanical clutch, combinations of listed technologies, rotary sheet folding, tube/pipe bending, roll bending, explosive-atmosphere hazards, and **automatic workpiece loading/unloading safety aspects**. Explicitly states **not applicable to press brakes manufactured before its publication date**. | These are *published scope statements*, not permission to ignore hazards on older or automated machines. ISO 11161:2007 is named as guidance for additional loading/unloading integration; exact provisions not read. |
| **National standards body EVS**, [EVS-EN ISO 6909:2026](https://www.evs.ee/en/evs-en-iso-6909-2026), valid **2026-07-01** | EN adoption exists, and the national history lists the older EN 12622:2010+A1:2013 edition. | **DOC-CONFIRMED national publisher record**. Do not infer automatic legal applicability outside that jurisdiction or a specific retrofit. |
| **European Commission**, [Implementing Decision (EU) 2026/2015, 4 September 2026](https://eur-lex.europa.eu/legal-content/EN/TXT/PDF/?uri=CELEX%3A32026D2015) | Official decision's published list names **EN ISO 6909:2026** among machinery harmonised standards. | **DOC-CONFIRMED published decision reference**; precise harmonisation date/transition/withdrawal provisions for a specific jurisdiction, machine or placing-on-market event require qualified legal/standards review of the full official tables. No unverified transition deadline is asserted here. |
| **ISO**, [ISO 16092-1:2017 official abstract](https://www.iso.org/standard/55667.html), exclusion (c) | Explicitly excludes machines whose principal designed purpose is bending/folding by press brakes or folding machines. | **DOC-CONFIRMED**; hydraulic power alone does not make ISO 16092-3 the press-brake-specific standard. |
| **ISO**, [ISO 16092-3:2017 official record](https://www.iso.org/standard/63390.html) | Part 3 is the hydraulic-press part **in addition to ISO 16092-1**. | Scope relationship only, not proof that a press brake meets hydraulic-press provisions. |
| **ANSI B11**, [B11 scopes](https://www.b11standards.org/b11scopes) and [B11.3-2022](https://www.b11standards.org/storeitems/b113-2022) | B11.3-2022 specifically addresses power press brakes; B11.2 excludes them. | Prior RESCUE-01 audit established the exact U.S. publisher scope; not replaced by the ISO publication or automatically applicable to every existing machine. |

**Provenance:** all edition and scope claims above are **DOC-CONFIRMED publisher/official-publication metadata**, not paid normative-clause interpretation, safety-function performance requirements, or measured machine proof. The EU decision is an EU publication, not a U.S. legal adoption. Exact jurisdiction, commissioning date, retrofit classification and installed equipment remain **UNKNOWN**.

## Five errors a practical safety reviewer must reject

1. **“Hydraulic = ISO 16092-3.”** The ISO 16092-1 scope expressly excludes press brakes, and Part 3 supplements Part 1. Use the machine-specific press-brake standards review, not a hydraulic-power keyword.
2. **“EN 12622 is the only European press-brake edition.”** The older standard remains important for historical design/legacy records, but the publisher now has **EN ISO 6909:2026**. A 2026 review that cites only EN 12622 is edition-incomplete.
3. **“A 2026 ISO publication retroactively certifies a 2000s machine.”** The new ISO abstract explicitly excludes pre-publication manufactured machines from its formal applicability. A retrofit may use its current risk concepts as engineering reference, but exact regulatory obligations require machine/jurisdiction/date/change analysis.
4. **“A Type-C standard covers the attached robot/load system automatically.”** ISO 6909 explicitly excludes automatic loading/unloading equipment safety aspects. Independently assess interface hazards, cell occupancy, protective stopping, unexpected restart and any applicable integration guidance.
5. **“A publisher abstract gives the stopping-distance/PL/valve truth table.”** The paid normative clauses and selected machine were not examined. No numerical acceptance, muting, overtravel, ram hold or PL/SIL can be inferred from the title, edition or harmonisation listing.

## OpenPressBrake application without inventing an as-built machine

The public OpenPressBrake repository describes a retained Pilz/AKAS hydraulic press-brake retrofit, but its **actual manufacturing/commissioning date, jurisdiction, exact machine revision, active modes, original certification and extent of modifications** are not established by this standards audit. The qualified Stage A [A–G documentary request](../safety-course/4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md) already requests the as-built identity and applicable press-brake standard/edition. **Refine that existing request, do not create a new questionnaire:** identify why the reviewer selected **ANSI B11.3-2022**, **ISO/EN ISO 6909:2026**, **EN 12622 legacy**, or another applicable edition for each claimed function, with date/jurisdiction/machine-scope rationale. If automatic loading or mixed technology exists, record the separate interface safety assessment rather than claiming ISO 6909 covers it.

A legacy retrofit can be made safer by using modern design principles, but **a document edition cannot substitute for** the installed Pilz program, independent Y1/Y2 stop/hold, hydraulic pressure isolation, guards/AKAS, physical energy control, restart behavior and qualified validation. Do not give ordinary LinuxCNC/FPGA outputs safety authority to satisfy a paper standard. Avoid user-hostile guard layouts and unsafe maintenance shortcuts; require physical protection that is practical to reinstall and operate.

## What is still unresolved

- **UNKNOWN:** exact regulatory adoption and transition for the selected machine, old/new machine classification, machine date, modifications, independent reviewer, applicable clauses, purchased standard text, normative verification matrix and physical tests.
- **TEST-CONFIRMED:** none. **SOURCE-CONFIRMED:** no new machine code or wiring claims. **COMMUNITY-REPORTED:** none relied on. **INFERENCE:** the five scope/review consequences above.
- **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.** No personnel-exposed hazardous operation; no simulation, build, local runner or GitHub-hosted compute. Independent 2520–25F0 evaluator remains NOT RUN.

**Next information gain:** qualified standards owner/reviewer obtains the selected *applicable edition and actual clauses* under restricted licensing and ties them to Stage A F (hazard-specific STOP/HOLD/ACCESS/ENERGY/RESTART), rather than inventing numeric limits from a public abstract.
