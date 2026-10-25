# 4400-CELL-02 — Reset location, safety permission, and 2025 robot-cell standard scope
**2026-10-25 | direct ABB and ISO publisher pages | OSHA historical indexed-only | DOC-CONFIRMED with explicit limits**

## Question
Does resetting a safety controller, closing a cell gate, or pressing a browser HMI button establish absence of personnel and authorize restart? The evidence separates these propositions.

## Primary source evidence
1. ABB Safety Products, "Using an HMI for reset and start?", https://new.abb.com/low-voltage/products/safety-products/using-an-hmi-for-reset-and-start (direct OEM interpretation; date/edition of quoted EN ISO 13849 text **not established**). ABB recommends a **separate manual reset pushbutton**, outside the danger zone, with good visibility. Reset should permit a **separate start**, not initiate movement. ABB discusses release-edge and pulse-length checks in its Pluto safety PLC, and a narrowly conditioned HMI exception. **Do not reproduce the manufacturer's quotation as an independently inspected current normative clause.**
2. ISO publisher, **ISO 10218-2:2025**, edition 2 published **2025-02-05**, "Industrial robot applications and robot cells": https://committee.iso.org/standard/73934.html . Publisher confirms integration, commissioning, maintenance, decommissioning and foreseeable misuse are within scope, superseding the 2011 edition. **Full 223-page normative text was not inspected**; no invented clause numbers or required distances.
3. OSHA, "Guidelines for Robotics Safety", directive **STD 01-12-002 (1987)**, https://www.osha.gov/enforcement/directives/std-01-12-002 . Official search-index excerpt describes interlocked perimeter gates stopping automatic operations and restart from a switch outside the barrier; original page fetch returned **403**, so this is **indexed agency text only**, historical guidance rather than proof of a 2025 standard clause.
4. Universal Robots, 2020 application note (CB/e-Series), https://www.universal-robots.com/articles/ur/application-installation/connecting-an-emergency-stop-device-vs-a-safeguard-protective-device/ . Manufacturer explicitly requires manual reset for whole-body entry where a protective device cannot continuously detect the person. Exact hardware/function qualification must use the current selected manual.

## Separate propositions (engineering model; INFERENCE from sources)
1. **P1 access**: gate physically closed and interlock functioning.
2. **P2 occupancy**: nobody remains in any accessible hazard zone; assess blind spots, fixtures, under/behind equipment and a person trapped inside.
3. **P3 safety function**: independent safety controller accepts protective-device signals and inhibits relevant hazardous actuators.
4. **P4 physical stop/hold**: robot, spindle, feeder, hydraulic ram, pneumatic/vacuum load and any gravity axis actually reach and retain their validated safe states.
5. **P5 reset eligibility**: required safeguards operative, faults resolved, qualified outside-zone view/verification and correct manual reset behavior.
6. **P6 fresh start**: separate deliberate new command, with old held/queued commands and power-return restart blocked.
7. **P7 service isolation**: energy isolation and stored-energy verification for maintenance; a stop or reset function is not lockout/tagout.

**Counterexample:** a correctly working guard interlock can report closed after an operator has walked behind a robot. The interlock has not failed; the architecture has failed to account for whole-body access and occupancy.

## Human-factors and practical design review
A separate reset button at a useful sightline is often cheaper and less error-prone than a complicated HMI permission screen. However, a button with an obstructed view is not enough. Prefer visible zone markers, mirrors or independently validated presence detection where necessary, an accessible escape/release from inside, clearly separated reset/start and a no-automatic-restart default. Keep interlocks easy to align and reinstall; log why operators might bypass them (jam frequency, blocked sightlines, hard-to-reach access). Avoid claiming that a mirror alone satisfies a safety standard without the selected assessment.

**Cross-machine transfer:** a press-brake rear access gate may not see a helper behind Y1/Y2; a mill toolchanger enclosure may hide a technician; a lathe has spindle run-down; a plasma cell adds torch/high-voltage and fume hazards; a robot cell may retain a gripped suspended workpiece. All require machine-specific final-element proof.

## Evidence classification
- **DOC-CONFIRMED:** ABB manufacturer's guidance, UR manufacturer's whole-body warning, ISO publisher's 2025 edition/scope.
- **DOC-CONFIRMED (INDEXED ONLY):** OSHA 1987 historical guidance; direct page inaccessible.
- **INFERENCE:** P1–P7 decomposition, preferred usability architecture.
- **UNKNOWN:** full ISO 10218-2:2025 clauses, exact current EN ISO 13849 clause text, actual selected-machine reset/visibility/occupancy, physical validation.
- **SOURCE/TEST-CONFIRMED:** none.

**No normative certification or machine release** is implied. Selected OpenPressBrake Y1/Y2 stop/hold, hydraulics and rear access remain unverified. No hosted/local compute or exposed-person tests justified.
