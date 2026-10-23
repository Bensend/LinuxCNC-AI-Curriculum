# 4400 — Lockable energy isolation, tagout equivalence, and retrofit maintenance access

**Session:** 2026-10-22T12:39:03Z start. **Scope:** US OSHA 29 CFR 1910.147 general-industry servicing/maintenance, subject to actual jurisdiction and exclusions. **Status:** DOCUMENTARY RESEARCH / NOT FROZEN / NO MACHINE VALIDATION. **Provenance:** DOC-CONFIRMED for exact regulatory/manufacturer statements; INFERENCE for the proposed engineering gate; UNKNOWN for selected machine conditions. No physical testing or computation was justified.

## Engineering question

A retrofit has a reliable independent E-stop chain and an ordinary LinuxCNC/FPGA stop request. The main isolator cannot accept a padlock, so the builder hangs a warning tag on the E-stop. Is the machine protected for maintenance?

**No.** OSHA 1910.147(b) distinguishes a physical energy-isolating device from a control-circuit device. A tag warns; it does not physically restrain the isolator. Whether an actual tagout system is permissible depends on the exact isolator and applicable requirements; a tag attached to a control E-stop is not an energy-isolating device.

## Primary-source claim ledger

| ID | Claim | Evidence | Scope and non-claim |
|---|---|---|---|
| L01 | An energy-isolating device physically prevents transmission/release of energy; disconnect switches, manually operated breakers, line valves and blocks are examples. Pushbuttons, selector switches and other control-circuit devices are excluded. | **DOC-CONFIRMED**, OSHA 1910.147(b), https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147 | No assertion that a specific installed switch or valve is suitable. |
| L02 | Non-lockable isolators require a tagout system; lockable isolators require lockout unless equivalent full protection is demonstrated under (c)(3). | **DOC-CONFIRMED**, 1910.147(c)(2)(i–ii), same source. | Does not say a generic paper tag or software lock is adequate. |
| L03 | Replacement, major repair, renovation, modification and new installation after 1990-01-02 trigger the rule that energy isolators be designed to accept lockout. | **DOC-CONFIRMED**, 1910.147(c)(2)(iii), same source. | Which specific retrofit qualifies is **UNKNOWN** until scope/task assessment; no blanket legal ruling. |
| L04 | Tagout on a lockable isolator requires equivalent full employee protection; additional measures may include extra disconnect, isolating-element removal, switch blocking or valve-handle removal. | **DOC-CONFIRMED**, 1910.147(c)(3)(i–ii), same source and OSHA tutorial https://www.osha.gov/etools/lockout-tagout/tutorial/full-employee-protection | Examples are not standalone approval; the complete protection must be demonstrated. |
| L05 | Tagout devices warn and do not physically restrain as locks do; devices must be durable, standardized and identifiable, and tagout training must address limitations. | **DOC-CONFIRMED**, 1910.147(c)(5), (c)(7)(ii), same source. | A bright tag alone is not a substitute for actual isolation. |
| L06 | Stored energy must be relieved/disconnected/restrained, with continued verification when reaccumulation is possible, and isolation verified before servicing. | **DOC-CONFIRMED**, 1910.147(d)(5–6), same source. | A locked mains switch does not prove hydraulic accumulator, trapped line, gravity or thermal energy safe. |
| L07 | A lockable switch in an E-stop control circuit is not an energy-isolating device. | **DOC-CONFIRMED**, OSHA interpretation 2003-07-15, https://www.osha.gov/laws-regs/standardinterpretations/2003-07-15 | OSHA marks this interpretation ARCHIVED; use current regulatory text as primary authority. |
| L08 | Siemens 3KD9201-1 is a lockable-OFF direct operating *accessory* for the 3KD family; Schneider TeSys Vario VCCF01 is a switch-disconnector family with padlockable handle options. | **DOC-CONFIRMED manufacturer catalog**, https://mall.industry.siemens.com/mall/en/WW/Catalog/Product/3KD92011 and https://www.se.com/us/en/product/VCCF01/switch-disconnector-tesys-control-for-on-emergency-stop-20av01-4-screws-fixing-for-mounting-at-back-of-an-enclosure/ | Product examples only; verify exact base switch, accessory pairing, ratings, OFF interlock, installed wiring, isolation category and available lock positions. A padlockable accessory alone is NOT an isolator. |

**Important scope guard:** OSHA 1910.147(a)(1)(ii) excludes certain activities, including electrical-utilization conductor work covered by subpart S. Do not treat this note as a complete electrical safe-work procedure or a cross-jurisdiction compliance determination.

## Four different propositions

1. **Normal stop:** LinuxCNC, HAL, GUI or ordinary FPGA has inhibited a command. This is useful production control, not a maintenance lockout.
2. **Independent production safety:** an approved safety relay/controller demands protective stopping through selected final elements. This is a different safety function, not automatically an isolator.
3. **Maintenance energy isolation:** authorized worker locks an actual energy-isolating device in a verified safe position; the worker/group lock protection remains in force for the servicing exposure.
4. **Physical residual-energy safe state:** task-specific independent evidence establishes discharge, restraint, blocking and absence of credible reaccumulation. A zero on one pressure gauge is not automatically proof of every trapped pocket or ram holding.

## Practical retrofit architecture (INFERENCE, not a machine design)

- Inventory every energy source and accessible servicing task. Identify whether electrical mains, DC bus, accumulators, line pressure, pneumatics, gravity, rotating inertia, thermal/cutting energy and auxiliary supplies cross the chosen isolation boundary.
- Prefer physically accessible, clearly labeled, lockable-OFF isolation points and practical personal/group-lock arrangements. Put them where technicians do not need to remove a guard or reach into a danger zone to lock out.
- When a retrofit changes the machine substantially enough to implicate (c)(2)(iii), assess the exact scope; do not preserve a non-lockable isolator merely because it is cheap. Do not infer that the legal trigger has or has not been met without a project-specific review.
- Design independent E-stop and guard functions for production exposure; separately provide maintenance isolation, residual-energy control and physical verification. Use the selected manufacturer's instructions for switch/valve selection and installation.
- Make the safe workflow easy: reachable isolation handles, padlock clearance, unambiguous energy maps, appropriate group lockbox, safe pressure-test access and mechanical restraint provision. Repeated guard removal, improvised padlock locations or tagging a pushbutton are design problems to fix, not worker habits to normalize.
- Preserve 1910.147(f)(1) temporary test/positioning sequence: clear tools and personnel, remove locks per procedure, perform limited test, deenergize, reapply energy control and reverify before exposure resumes. Preserve (f)(3) individual worker lock control and (f)(4) shift continuity.

## Failure-path adjudication (conceptual, NOT RUN)

| Adversarial condition | Tempting but invalid shortcut | Required engineering response |
|---|---|---|
| Red/yellow padlockable E-stop *pushbutton* | 'It is locked, so the machine is isolated' | Trace actual power contacts. A control-circuit E-stop is not a physical isolator. |
| Red/yellow *switch-disconnector* with padlockable handle | 'The red handle proves the whole machine safe' | Check actual isolating switch, poles, load, wiring, backfeeds, other sources and stored energy. |
| Lockable mains isolator but press-brake accumulator/ram remains hazardous | 'Electrical power is off' | Separately control trapped pressure and gravity; obtain physical witnesses and restraint. |
| Tag on lockable disconnect with no extra safeguards | 'Tag is equivalent to a lock' | Reject until full-equivalence demonstration; normally use lockout. |
| One supervisor lock with a crew roster | 'Crew is protected' | Preserve each worker's personal control and verified personnel clearance. |
| Powered repositioning completed after earlier pressure verification | 'The previous zero-pressure reading still counts' | Prior proof is stale. Re-isolate and perform fresh verification before re-entry. |
| Technician must defeat guard to reach lockout | 'Train them not to bypass' | Redesign access/guard/isolation location to remove the predictable bypass incentive. |

## Traceability and release

Record `BND/ENE/HAZ` for task/energy; `SF/PHY/SRS` for independent protection and physical propositions; `AUTH` for normal/safety/isolator owners; `DEP/ARC` for shared supplies, backfeeds and trapped pockets; `VAL/PT` for task-specific verification; `HF` for defeat incentives; `CHG/UNK/RR` for retrofit scope and unresolved facts. Do not collapse these into one 'E-stop OK' flag.

**Freeze:** LOCKABLE CONTROL STOP != ENERGY ISOLATOR; TAGOUT != AUTOMATIC LOCKOUT EQUIVALENCE; PADLOCKABLE PRODUCT CATALOG != INSTALLED ISOLATION PROOF; SUPPLY LOCKED != STORED ENERGY SAFE; SOFTWARE SAFE != MAINTENANCE SAFE.

**UNKNOWN:** selected machine isolator, electrical and hydraulic drawings, installed padlock accommodation, trapped-energy paths, approved group-lock procedure, pressure/position witnesses, physical restraint and jurisdictional applicability. **No personnel-exposed hazardous operation is authorized by this documentary research.**
