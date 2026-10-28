# 4400-GUARD-FAST-01 — Captive guard fixings, false-closed panels and maintenance-driven safeguard defeat

**2026-10-28 | Original EU/OSHA/manufacturer source-depth | 4400 safety / NON-GRADUATED / no machine test**

## Concrete new question and predecessor reconciliation

Can a fixed guard look installed after maintenance even though its fasteners are missing, and can inconvenient access make a theoretically good guard routinely disappear? **Yes as a credible mechanical/human-factor failure path (INFERENCE), not an observed OpenPressBrake incident.** Existing [GUARD-01](../safety-course/4400_GUARD_01_PRESS_BRAKE_JOB_SHOP_SAFEGUARD_FEASIBILITY_AND_ANTI_BYPASS_MODULE_2026-10-25.md) teaches anti-bypass design; [AUTODOOR-01](4400_AUTODOOR_01_HAAS_CNC_POWERED_DOOR_EDGE_CURRENT_FENCE_REMOVAL_SOURCE_AUDIT_2026-10-27.md) teaches moving-guard edge protection. **New increment:** exact **EU Machinery Regulation Annex III 1.4.1 / 1.4.2.1 / 1.4.2.2** mechanical guard retention and service-access language, direct OSHA fixed-vs-interlocked maintenance tradeoff, and actual captive-fastener manufacturer design options. This adds a **physical retention witness**, not a new safety-PLC function or another paper exam.

Direct full canonical index/progress/research novelty scan: generic captive-fastener convenience was already mentioned in the design package, but no source-depth record of Annex III's **tool-required / captive fixing / cannot appear installed without fixing** distinction or an actual manufacturer example existed. This audit extends those predecessors rather than replacing them.

## Primary sources and provenance

1. **DOC-CONFIRMED official indexed EU law:** [Regulation (EU) 2023/1230 consolidated 2026-07-27, Annex III §1.4.1, §1.4.2.1, §1.4.2.2](https://eur-lex.europa.eu/eli/reg/2023/1230/2026-07-27/eng). Fixed guards: tool-required removal, fixing systems retained with guard/machine on removal, and, where possible, a guard should not be capable of staying in position without its fixings. Movable interlocked guards should, as far as possible, remain attached when open; interlock should prevent hazardous start until closed and give stop when opened, with locking if reaching the hazard before cessation is possible. General guards should not be easily defeated, should obstruct visibility minimally, and should permit necessary tool/maintenance work with minimal protective-device removal. **Official EUR-Lex search-indexed text inspected; direct full-text fetch challenged by robot/JavaScript.** Applicability is EU/date/jurisdiction-specific; not asserted as a U.S. legal mandate.
2. **DOC-CONFIRMED directly inspected OSHA education:** [OSHA Machine Guarding eTool — Guards](https://www.osha.gov/etools/machine-guarding/introduction/guards). Fixed guards are mechanically simple but may obstruct adjustment/repair and require removal; interlocked guards allow jam clearance without fixed-guard removal but need adjustment/maintenance and may be defeated. OSHA explicitly says guard replacement should **not automatically restart** machinery. OSHA's descriptions are general training, **not a product-specific safe stopping distance or a complete machine risk assessment**.
3. **DOC-CONFIRMED manufacturer design evidence:** [Clarendon Specialty Fasteners — Captive Screws](https://www.clarendonsf.com/products/captive-screws), current product page. Captive screws retain hardware to a panel/guard, reducing loss during maintenance. The manufacturer lists snap-in rings, retainer nuts, swaged retention, reduced shank and various drive styles; it explicitly includes machine guarding and conveyor access panels as application areas. **No selected part, load rating, guard impact performance, vibration retention or safety certification has been verified**. A product's general compliance marketing claim is not a machine safety validation.
4. **DOC-CONFIRMED alternate manufacturer mechanism:** [MW Components — Captive Screws and Assemblies](https://www.mwcomponents.com/captive-screws-assemblies) describes reduced/unthreaded shank retained by a washer, and lead-point alignment and anti-vibration options. This is physical design evidence only, not interchangeability or a certified guard system.

No community anecdote was needed to establish the source proposition; **COMMUNITY-REPORTED** claims not used. No source-confirmed installed OpenPressBrake guard. **TEST-CONFIRMED** none.

## Five different physical propositions — don't merge them

| Proposition | What it actually establishes | What it does **not** establish |
|---|---|---|
| Guard panel visually in place | The panel occupies an apparent position | Required fasteners installed/torqued, retained load path, impact containment, access exclusion |
| Captive fasteners present | Fasteners remain attached when loosened | They are tightened, correct grade, structurally adequate, thread engagement/retention proven |
| Interlock says closed | A switch/OSSD/logic input sees the intended state | Actual guard strength, geometry, no defeat, stop completed, safe rearm |
| Hazardous-motion OFF | An ordinary or independent stop command is asserted | Motion ceased before access, gravity load held, hydraulic energy exhausted |
| Guard correctly reinstalled and validated | Correct physical barrier, fastening, access and selected safety function reviewed | Maintenance energy isolation automatically performed; later change/restart proven |

**INFERENCE — false-closed panel:** A lift-off panel resting on a locating lip or magnet can look present with missing screws. If the barrier is relied upon for fragment containment or reach prevention, its physical retention path may be absent. A position switch may also be actuated by geometry that does not load the actual fasteners. This is a conditional fault hypothesis, **not** an observed failure on the selected machine.

**INFERENCE — predictable defeat:** A guard requiring many loose bolts for frequent chip clearing, die adjustment or lubrication creates incentives to leave bolts out or the guard off. The first remedy is **design of the access task**, not another warning label: service ports from outside the hazard zone, hinged/interlocked access with a safe stop and deliberate restart where required, or an infrequently removed fixed panel with captive tool-operated fasteners and repeatable alignment.

## Low-cost, practical architecture options (not a BOM approval)

**Option F — infrequently removed fixed guard.** Tool-operated captive screws on a retained panel, stable locating geometry, easy tool access, clear fastener inspection, documented retention/load path and a guard design that cannot simply hang in place unfastened where practicable. No unverified magnetic latch or unqualified quarter-turn release substituted for tool-required fixing in a jurisdiction where that requirement applies. Include a simple physical installation check in maintenance signoff.

**Option M — frequently accessed movable guard.** Properly supported hinge/slide, a **selected and validated independent interlock/guard locking function** based on access time vs hazard cessation, robust anti-defeat mounting, clear sightline, and a separate deliberate restart after closure. The ordinary LinuxCNC door status may display condition but does not own personnel-safety authority. Easy access reduces temptation to remove it.

**Option S — infrequent service access requiring removal.** Qualified LOTO, pressure/energy isolation and physical ram support as appropriate, panel hardware retained/captive, clear reassembly witness, guard restoration and fresh start. A door interlock is not LOTO; fasteners are not load-holding devices for a press-brake beam.

**Cost/human factors:** inexpensive captive fasteners and simple hinged guards can reduce missing parts and lost time; however price, ergonomics, number of access cycles, vibration, corrosion, projectile energy and mechanical load must be selected/verified for the machine. No numeric fastening torque, guard strength, safety PL/SIL or stop distance invented.

## Adversarial review — documentary only, NOT RUN

- **A — guard present, bolts missing:** reject visual/limit-switch PASS as a retention witness; require actual hardware/geometry inspection and the selected guard load/impact case.
- **B — all screws captive, panel loose:** captive hardware avoids loss, not improper installation; a positive mechanical securement check still required.
- **C — service guard opened frequently:** if the fixed guard is regularly removed for routine production, evaluate an engineered interlocked movable guard and accessible service tasks rather than accepting predictable bypass.
- **D — interlock closes and starts machine:** reject automatic restart; independent safety reset and ordinary deliberate cycle start are separate decisions.
- **E — maintenance complete but hydraulic pressure/beam load remains:** reject machine access from guard closure alone; independent energy isolation/physical restraint and rescue plan required.

All five are **unscored thought reviews**, not new evaluation cases, not physical tests.

## OpenPressBrake boundary, release and next evidence

Do **not** assert an installed fixed, hinged or removable guard on OpenPressBrake from this cross-machine teaching example. Use existing [Stage A E/F/G](../safety-course/4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md): selected front/rear/side/under-ram barrier geometry, removal frequency, actual fastener/hinge retention, guard switch and anti-defeat, stopping/holding and deliberate rearm. Use existing restricted Stage B only after qualified applicability. **Do not create a new owner questionnaire.** If a barrier can be left in place without securement, or must be routinely bypassed to work, redesign the barrier/access task before release. No people-exposed hazardous operation when the minimum safe-to-operate threshold is unproven; experimental work only isolated/remote under separate qualified plan.

**G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD; external 2520–25F0 evaluation OPEN.** No as-built machine, licensed ISO clause, PL/SIL, impact/stopping number, physical validation, simulation, workflow or hosted/local compute. LAB_COMPUTE_LOG unchanged. **Next:** qualified actual guard installation/maintenance evidence and physical final-element witness; otherwise rotate to a genuinely new safety mechanism.
