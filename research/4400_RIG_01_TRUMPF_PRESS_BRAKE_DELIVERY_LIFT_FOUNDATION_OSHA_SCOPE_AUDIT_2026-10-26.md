# 4400 RIG-01 — press-brake delivery, unusual center of gravity and installation safety: original source audit

**Study date:** 2026-10-26. **Status:** documentary research; no lift, rigging calculation, foundation design, installation approval or machine test. **Novelty:** safety-course index had no machine transport/tip-over/floor-anchor branch; earlier WILA tool-rigging work concerns *tooling*, not the entire press brake.

## Why this matters

A press brake can injure people **before the first LinuxCNC command**: delivery, lifting, temporary rollers, leveling, utility hookup, and removal of shipping restraints are different hazard states from guarded production. Ordinary LinuxCNC, FPGA and even a complete machine E-stop cannot prevent a crane/forklift tip-over or falling suspended machine.

## Original source record

1. **TRUMPF**, *TruBend 2100 Quick Start Guide*, original manufacturer one-page PDF, https://www.trumpf.com/filestorage/TRUMPF_MX/TruBend2100/pdfs/TruBend2100-quick_start_guide_V1.pdf . Directly inspected PDF text and **visually inspected the full page**. The guide explicitly states it is a summary and directs installers to the **complete machine Installation Manual** for additional details.
2. **OSHA**, *Forklifts: free rigging requires manufacturer approval*, original 1999-10-22 interpretation, https://www.osha.gov/laws-regs/standardinterpretations/1999-10-22-0 . Manufacturer's interpretation excerpt directly examined via indexed official text: attaching slings/shackles/rings directly to forklift tines for below-tine lifting can affect capacity and safe operation; **1910.178(a)(4)** requires prior written manufacturer approval for modifications/additions affecting capacity/safe operation; **1910.178(o)(1)** addresses stable loads and off-center loads. **This interpretation is not permission to free-rig.**
3. **OSHA 1926.1404(g)**, official https://www.osha.gov/laws-regs/regulations/standardnumber/1926/1926.1404 : construction-crane assembly/disassembly scope includes capacity limits on lifting lugs/rigging/accessories; **not** a universal press-brake installation or floor design standard.
4. **OSHA 1910.303(b)(8)(i)**, official https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.303 : electrical equipment must be firmly secured where that provision applies. It does not establish a press-brake foundation design or machine anchor load.

## DOC-CONFIRMED exact TruBend 2100 facts — not transferable to OpenPressBrake

- TRUMPF describes **integrated eyelets at the top of the frame** for crane lifting and an alternative of **armored rollers** where overhead crane is unavailable.
- It warns that press brakes have an **unusual center of gravity**, strongly recommends **experienced professional riggers**, and explicitly refers to the **complete Installation Manual** for further transport instructions.
- The one-page guide lists **16,534 lb** and envelope **139 in L × 82 in W × 93.3 in H** for the **TruBend 2100 only**. These values are **NOT** OpenPressBrake weights, dimensions, lifting point loads, forklift capacities or center-of-gravity coordinates.
- The guide specifies **8-inch concrete thickness** for direct installation of that **TruBend 2100**, with a manufacturer-supplied **mounting-plate drawing solution** if thinner. **Not** a generic press-brake slab requirement or anchor design. The one-page guide does **not** provide bearing capacity, rebar, slab condition, soil, floor joint location, anchor bolt force or a proof of existing foundation adequacy.
- The guide says that machine should already be in final location when the manufacturer technician arrives. This is a **delivery responsibility sequence** for that product, not a substitute for professional rigging planning.

## Adversarial engineering distinctions

| Hazard | False shortcut | Required independent evidence |
|---|---|---|
| Off-center press-brake mass and crane hook geometry | Assume hook centered on visible frame is over center of gravity | Exact machine lifting/CG data and professional lift plan; no inferred coordinates |
| Unapproved forklift below-tine sling | “Forklift can lift more than machine weighs” | Manufacturer written approval/approved attachment, capacity at actual load center and rigging plan |
| Temporary rollers or jacks | “It moved on rollers once, so it is stable” | Exact machine OEM permitted support/contact points, route/floor slope, restraint and exclusion zone |
| Floor slab/anchor | Copy **8 in** from TRUMPF to an unrelated press brake | Selected OEM foundation and site structural engineering, floor condition/loads |
| Machine arrives before safety commissioning | Power normal control to “check it” while guards/ram supports incomplete | Independent safe-energy/physical-hold commissioning sequence and no personnel exposure |
| Rigging straps removed before stability confirmed | “Machine is upright, so safe” | Independent support/level/anchor proof, qualified signoff before releasing restraints |
| Service relocation later | Reuse original commissioning signoff | Reassess machine mass/tooling/attachments, new floor, utilities, anchors, guarding and stop/hold |

**No lift geometry, sling angle, anchor size, slab thickness, load center, center-of-gravity position, tipping moment or machine-specific structural safety factor is invented here.**

## Boundary and human factors

**Physical safety during transport:** rated lifting gear, manufacturer lifting points, professional riggers, exclusion zones and stable floor support; **not** LinuxCNC/FPGA. **Machine commissioning:** energy isolation, gravity load retention, guards and independent stop/rearm before hazardous operation. **Normal control:** only after qualified physical and safety commissioning. Make rated lifting points accessible/clearly labeled, store exact transport instructions and support hardware with the machine, prevent removal of restraints before signoff, and avoid confusing tooling lifting points with whole-machine points.

**Evidence:** DOC-CONFIRMED exact TRUMPF guide and scoped OSHA excerpts; INFERENCE adversarial failure paths and handoff architecture; SOURCE-CONFIRMED new LinuxCNC none; TEST-CONFIRMED none; COMMUNITY-REPORTED none; UNKNOWN actual OpenPressBrake machine mass/CG, lift points, foundation, anchoring, hydraulic restraint, stop/hold, guarding and commissioning evidence.

**Gate:** G0/G1 HOLD. Do not attempt physical lifting/rigging or personnel-exposed operation based on this educational audit. No simulation, rigging calculation, physical test, hosted Actions or local compute.
