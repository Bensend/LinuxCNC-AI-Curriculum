# 4400-WELD-RETURN-02 — the work clamp is not the safety ground

**2026-10-27 | Practical technician card | PUBLIC PAPER ONLY / UNSCORED / NOT RUN**

An automated weld fixture is mounted on a positioner; a crane holds a large workpiece. The work clamp is loose. The machine frame has a green/yellow grounding conductor, and the HMI says ARC OFF. **None of those facts establishes a safe welding-current return or electrical isolation.**

The original [US eCFR 29 CFR 1910.254(c)(2)](https://www.ecfr.gov/current/title-29/subtitle-B/chapter-XVII/part-1910/subpart-Q/section-1910.254) explicitly separates welding-machine grounding from the work-lead circuit, prohibits welding current through **chains, wire ropes, cranes, hoists and elevators**, and addresses bonding/current collection where fixtures or structures are deliberately used as a return. [Miller manufacturer guidance](https://www.millerwelds.com/resources/knowledge-hub/industrial-welding/safety-and-scheduled-maintenance-protect-your-welding-assets) also says the work lead and grounding lead have different functions.

**A useful four-question review:** Is the intended high-current work return mechanically sound? Are unintended crane/hoist/guard/fixture paths excluded? Is protective grounding independently correct? Is the welding power source actually electrically isolated for the proposed maintenance task? These are different physical questions; ordinary LinuxCNC/robot arc commands are not independent witnesses.

**Practical anti-bypass design:** give the operator a dedicated accessible, inspectable and rated work-clamp point, protected routing, clear labeling and a straightforward maintenance-isolation method. If the fixture design forces operators to clamp to a crane, guard or dirty inaccessible surface, redesign the fixture rather than normalizing the workaround. Do not perform energized fault injection or deliberately send current through a crane to “test” the idea.

**Combined hazard:** after the arc stops, [shielding/purge gas can still create an oxygen-deficient entry hazard](4400_WELD_GAS_01_SHIELD_PURGE_GAS_OXYGEN_DEFICIENCY_AND_SAFE_ACCESS_FIELD_CARD_2026-10-27.md). Electrical isolation, atmosphere, fire watch, robot stopping and safe restart must not be compressed into one READY bit. See the [original exact-source audit](../research/4400_WELD_RETURN_02_OSHA_MILLER_WORK_LEAD_PROTECTIVE_GROUND_CRANE_RETURN_AND_ELECTRICAL_ISOLATION_AUDIT_2026-10-27.md).

**Status:** selected machine, weld return, power source, grounding, gas, independent physical validation and evaluator UNKNOWN/NOT RUN. No new public exercise bank, machine test or compute. OpenPressBrake G0/G1 HOLD; no personnel-exposed hazardous operation.
