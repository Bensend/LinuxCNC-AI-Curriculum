# Safety worked-chain qualification checkpoint — 2026-09-24T10:49Z

Status: first worked application of `SELECTED_SAFETY_BLOCK_QUALIFICATION_WORKSHEET.md` complete. Generic safety schematics remain NOT FROZEN. External/fresh 2520–25F0 competency gates remain open and uncontaminated.

Durable work:
- `research/WORKED_SELECTED_SAFETY_CHAIN_QUALIFICATION_2026-09-24.md`
- strengthened `hardware/SELECTED_SAFETY_BLOCK_QUALIFICATION_WORKSHEET.md`
- updated `PROGRESS.md`

Worked reference uses SICK deTec4 Core for the protective-device/OSSD and external-EDM semantics. Pilz PNOZ s4 is deliberately treated only as a separate architecture reference for external safety logic/output behavior; exact SICK-to-Pilz compatibility is UNKNOWN and schematic-blocking until exact current interface evidence is reconciled.

New freezes:
- `PROTECTIVE FIELD CLEAR != RESTART AUTHORIZED`;
- `EDM SATISFIED != HAZARDOUS ENERGY ABSENT`.

Generic evidence improvements:
1. Cross-product compatibility is now a first-class schematic gate. Nominal voltage or signal-name matching is insufficient.
2. Feedback evidence must name the actual physical/electrical target and its relationship to the signal; plausible feedback alone is not independent physical proof.

No executable question survived authoritative documentation/engineering reasoning. No simulation/build/test compute was run; no GitHub-hosted minutes were consumed.

Exact next work:
1. Prefer one coherent manufacturer-supported chain/application example with explicit OSSD/input compatibility, restart behavior, output/final-element wiring and EDM.
2. Trace one selected final element and its positively guided/mechanically linked feedback proposition to the exact boundary of what EDM proves.
3. Attack common 24 V/0 V, feedback supply/target, suppression, power restoration and ordinary-control override assumptions.
4. Only freeze a bounded bench lab if an interface question remains unresolved after exact product documentation; target `[self-hosted, openpressbrake]` only.
5. Do not freeze a generic schematic or invent machine-specific integrity/stopping/energy values.
