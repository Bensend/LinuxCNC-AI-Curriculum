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



### SISTEMA migration: the green status trap (IFA original PDF and 2025 release note)
A **2.x → 3.x** project conversion is **not backwards compatible**; preserve the old project and libraries. A migrated project can gain new red/yellow messages because the **2023 standard and IFA checks changed**. Inspect DC/CCF, fault exclusions, software/EMI, and alternative calculation method rather than forcing the old color. In SISTEMA 3.x a **yellow** note can be documented and then shown **green**; **red** cannot be downgraded this way. The documented note remains in the report: *green does not mean the physical assumption was proven*. The original IFA 3.0 guide also discusses fault exclusion and the limitation on relying solely on exclusion for PL e; this is not a selected-machine PL claim. [IFA original 3.0 migration guide](https://www.dguv.de/medien/ifa/en/pra/softwa/sistema/innovations_sistema_3-0.pdf).

IFA's [02-Nov-2025 release notice](https://dguv.de/ifa/;/praxishilfen/practical-solutions-machine-safety/software-sistema/newsletter/2025/quartal_4/index.jsp) says 3.0.4 build 5 fixed earlier v3 issues including documentation edits not being saved. **Reviewer action:** record exact tool build, preserve original and converted model, inspect all messages, save/reopen and verify the report/documentation; then separately require actual hydraulic stop/hold and guard/restart evidence. No tool execution or PL credit claimed.
