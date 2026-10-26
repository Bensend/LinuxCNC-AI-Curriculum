# 4400 KEY-01 — Personnel key, electronic restart inhibit, and personal energy isolation

**Status:** practical safety curriculum; NON-GRADUATED, no external score, no machine-specific validation. Prerequisites: 2520 safety function, 2530 E-stop/rearm, 2590 guard/egress, 25D0 maintenance/change control, 25F0 machine capstone.

## Three separate promises
1. **Sequence enforcement:** a mechanical trapped-key system can enforce ordering between selected isolators, key exchange and access locks, if the installed device/keys match the design.
2. **Restart prevention while someone is inside:** mechanical personnel keys or digital RFID safe-list schemes can inhibit return to production while designated people retain keys or remain signed in.
3. **Personal hazardous-energy control:** qualified personal isolation, verification of absence/management of stored energy and positive mechanical support are separate tasks. Neither a sequence nor a login record automatically establishes pressure zero, gravity-load retention, no residual voltage or personal LOTO compliance.

## Manufacturer evidence and uncertainty
**DOC-CONFIRMED Fortress:** mGard key-exchange and personnel-key options, mechanical control/access interlocks and optional valve/circuit-breaker interlocks; exact design dependent. **DOC-CONFIRMED Pilz:** PITreader/PSS 4000 or PNOZmulti 2 electronic personal IDs and safe list, with described sign-out restart prevention. **INFERENCE:** both are useful design patterns but neither automatically certifies all energy isolation. **UNKNOWN:** selected OpenPressBrake hardware, Y1/Y2 load support, pressure zones, egress, jurisdiction/task LOTO requirements and actual PL/SIL.

## Practical human factors
Make it easy to keep the personal key: accessible and clearly labeled lock locations, sufficient keys for all workers, simple group/shift handoff, non-frustrating gate access and rescue procedure, visible who remains inside, protected spare/master-key governance. Digital systems require reliable offline/power-loss behavior and safe recovery for lost tokens. A worker who must choose between completing work and following a cumbersome sequence will predictably bypass it; fix the workflow and architecture, not just signage.

## Machine examples
- **Robot cell:** multiple access doors and two workers; independent personal-key accountability and no blind restart.
- **Press brake:** key-controlled access cannot replace positive ram support, verified hydraulic pressure-zone isolation, Y1/Y2 stop and physical guarding.
- **Mill/lathe:** spindle run-down and retained workpiece/tool energy persist after control power off.
- **Plasma table:** fume/extraction, hot material and stored electrical energy require separate hazard boundaries.

## No-energy desk review
Identify each hazardous energy source, exact isolator, mechanical/digital key function, every person's key, multiple-gate logic, trapped-person escape, emergency rescue, power-loss/reader failure, deliberate reset/start, proof of actual physical isolation and the applicable personal-LOTO standard/task scope. **Do not simulate or demonstrate a bypass or energize a machine to answer these questions.** G0/G1 HOLD.

## Original-source audits
[Fortress trapped-key mechanism](../research/4400_FORTRESS_MGARD_PERSONNEL_KEY_SEQUENCE_AND_ENERGY_BOUNDARY_AUDIT_2026-10-26.md) and [Pilz digital key-in-pocket scope](../research/4400_PILZ_KEY_IN_POCKET_DIGITAL_RESTART_VS_LOTO_SCOPE_AUDIT_2026-10-26.md). Manufacturer marketing is not a substitute for exact installed design or OSHA 1910.147 applicability. No physical tests, external scores or machine release.
