# 4400 VAL-STD-01 — A PL report is not a physical stop/hold test
**2026-10-28; one-page technician review; NON-GRADUATED.** See [original ISO/IFA source audit](../research/4400_VAL_STD_01_ISO13849_PART2_2012_DIS2026_SISTEMA_SOFTEMA_VALIDATION_BOUNDARY_AUDIT_2026-10-28.md) and [selected-machine Stage A](4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md). This is not a live fault-injection procedure or external competency score.

**SISTEMA** evaluates a *declared reliability architecture* and attained PL; it cannot inspect whether the specified contactor/valve is installed, whether a ram holds or whether the guard covers the actual hazard. IFA revision mapping: **3.x ↔ ISO 13849-1:2023; 2.x ↔ 2015; 1.x ↔ 2008**. Old model migration requires reviewing assumptions and source data.

**SOFTEMA** assists the *safety-related application-software* lifecycle and test records. It does not turn normal LinuxCNC/FPGA motion logic into independent personnel-safety authority. A correct application program cannot prove a hydraulic final element physically holds the ram.

**Physical validation** is a third separate record: installed Pilz/AKAS program and wiring, independent Y1/Y2 final elements, physical stop/hold, guarding, trapped energy and fresh intentional restart. No personnel-exposed operation while the basic safe-to-operate threshold is unproven.

**Edition gate (2026-10-28):** ISO 13849-1:2023 published; ISO 13849-2:2012 still current published; ISO/DIS Part 2 reached **draft stage 40.99 on 2026-10-20**, not final publication. IFA says Part 1:2023 incorporated validation requirements from Part 2. Select actual machine/retrofit/jurisdiction edition through qualified review; do not treat a draft or tool version as legal applicability.

| Apparent green | Adversarial desk question | Disposition |
|---|---|---|
| SISTEMA target PL met | Exact selected SKUs, tool/edition, CCF, fault exclusions and as-built topology? | Model evidence only |
| Safety-PLC signature matches | Which physical final elements and safety outputs does that program actually control? | Map independent authority |
| EDM NC looks correct | Is the exact base/auxiliary/mount manufacturer-qualified mirror? | Validate replacement/CHG |
| Valve feedback says closed | Could pilot, relief, trapped pressure or gravity still move the ram? | Independent PHY-STOP/HOLD |
| E-stop/reset says ready | Can a held foot or stale ordinary command start motion? | Deliberate fresh start |
| Draft standard cited | Has a final edition been published/adopted and selected for this machine? | Draft research only |

Reuse existing Stage A IN-01..10 and cumulative BND/SRS/ARC/DEP/VAL/PHY/CHG. Do not invent PLr, stop times, valve truth tables or conduct hazardous tests. **G0/G1 HOLD** until qualified installed-machine and independent evaluator evidence exists.
