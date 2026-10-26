# 4400-HYD-HOLD-01 — Parker HAS: load-holding order code, manual release, trapped pressure and runaway load
**Original manufacturer-source audit | 2026-10-26 | DOCUMENTARY ONLY / NON-GRADUATED.**

## Question and source scope
Can a hydraulic actuator described as having "load-holding valves" be assumed to restrain a vertical machine when powered off, with a line broken, or while maintained? **No.** The exact hydraulic circuit, valve option, pilot/override state, mounting location and load path must be established. This audit examines **Parker Hybrid Actuation System (HAS 500 / HAS-ST)**, not an installed OpenPressBrake assembly.

Primary original source: Parker Hannifin, *Hybrid Actuation System Cylinders — Installation Manual*, **Catalog HY08-4005-M11**, PDF pages 10, 32, 35–36, 61–65 (PDF page numbering may differ from printed page). https://www.parker.com/content/dam/Parker-com/Literature/Industrial-Cylinder/cylinder/Serv/HY08-4005-M11_HAS_Installation_Manual.pdf (read 2026-10-26).
Independent manufacturer context: Parker, *Load and Motor Control Valves*, Catalog HY15-3502/US, Technical Tips LM1–LM2, https://www.parker.com/content/dam/Parker-com/Literature/Hydraulic-Cartridge-Systems-Division---Europe/HCSE-Websphere-literature/HCSE_LoadControlValves/Parker_HCSE_LoadControlValve_datasheets_HY15-3502-US-EU_English.pdf.

## Direct manufacturer findings (DOC-CONFIRMED for the cited Parker products)
1. **A code that looks like a check-valve assembly can intentionally provide NO load holding.** HAS model code **N** is described as *Open, no load holding* (printed p.10). The manual explains on printed p.36 that circuit code N uses a pilot-operated check with its **manual override engaged**, allowing free flow both ways. Codes **P** and **R** instead denote pilot-to-open check variants; **R** includes manual release. The no-load-holding **NN** circuit is expressly listed on pp.62/64. A valve physically present in the manifold is therefore not proof that it is acting as a holding valve.
2. **Pilot-to-open check is non-modulating, not a controlled load-lowering valve.** Printed p.35 states that a pilot check holds against reverse flow until pilot pressure opens it; using it for overrunning load lowering can cause severe ratcheting. Parker's application guidance (printed p.61) warns that PO checks chatter with runaway loads and recommends their use on horizontal applications or with counterbalance on the other load direction. The catalog's broad note that PO checks may substitute for counterbalance under fixed loads/speeds must not be read as permission to use them alone on an overrunning vertical ram.
3. **Counterbalance is a modulating load-control device with pressure-dependent release.** Printed p.32 describes load-pressure and pilot-pressure interaction, reverse-flow check and thermal relief. The separate HY15-3502 technical tips LM1–LM2 describe load control during overrunning motion and hose-failure mitigation. Those are product mechanisms, not a universal guarantee for any broken line or any valve placement.
4. **Holding also means retaining hazardous pressure.** Printed p.32 explicitly warns that HAS load-holding valves trap pressure inside the cylinder and must not be removed before all internal pressure is relieved. The manual's introductory warning requires LOTO and cautions that an actuator can remain locked with contained pressurized fluid.
5. **Circuit choice is machine-specific and non-interchangeable.** HAS 500 and HAS-ST list NN (no holding), PP (pilot checks), RR (manual load release) and multiple CC/DD/other counterbalance configurations. The printed p.37 valve-location table depends on actuator orientation. No universal assignment of push/pull valve to the actual press-brake Y1/Y2 cylinder can be made without as-built evidence.
6. **Leakage and thermal release matter.** Parker HY15-3502 catalog includes model-specific leakage specifications (e.g. 5 drops/min for an MHB-015 variant under specified conditions). HAS manual states counterbalance thermal overpressure relief can unseat the valve. A component described as low-leakage does not certify indefinite immobility, no creep or zero stored energy.

## Failure-path comparison (engineering inference, not selected-machine truth)
| Fault / change | Potential failure path | Evidence required |
|---|---|---|
| Wrong model code / N option | Actuator can lack hydraulic holding despite visible valve hardware | Exact model code, OEM schematic, valve cartridge and override configuration |
| Manual release left engaged | A nominally installed check cannot block return flow | Qualified inspection, tamper-resistant restoration evidence |
| Pilot pressure persists or cross-feeds | Pilot valve opens despite ordinary stop request | Actual pilot-line and accumulator pressure-zone drawing |
| Hose rupture on wrong side of valve | Valve may not retain cylinder load | Valve-to-cylinder mounting geometry, both sides of line break, independent hold |
| Counterbalance used as plain PO check | Unstable or uncontrolled lowering under overrunning load | OEM suitability analysis and bounded isolated validation |
| Holding valve closed during service | Trapped pressure remains even with pump off | Physical support, qualified zone-specific isolation/depressurization verification |
| Slow internal leakage or thermal relief | Position drift despite stopped pump | Component data, load/temperature envelope, independent positive support |
| Two Y cylinders share common pilot/return | Common-cause release or unequal descent possible | Independent Y1/Y2 plumbing and failure analysis |

## What this does NOT prove
No Parker HAS device is known installed on OpenPressBrake. No specific Y1/Y2 hydraulic circuit, stop response, leakage, relief threshold, pressure, load, PL/SIL, stopping distance, diagnostic coverage or hose-break behavior was measured. **SOURCE-CONFIRMED new LinuxCNC: none. TEST-CONFIRMED: none. COMMUNITY-REPORTED: none. DOC-CONFIRMED: manufacturer manual scope only. INFERENCE: failure-path table. UNKNOWN: selected machine.**

## Practical consequence
For a gravity-loaded axis, a normally closed electrical output, stopped pump, zero servo command, E-stop indication, and even a present check cartridge do **not** independently establish load retention. Prefer proven, appropriately specified actuator-adjacent holding arrangements plus independent positive physical restraint for personnel access. A qualified hydraulic engineer must map every retained pressure volume and verify that a protective stop does not accidentally defeat the holding function. Never use this audit to select valve settings or perform energized tests.

## Next evidence and no-go
G0 qualified private intake: as-built Y1/Y2 cylinder/valve model codes, valve physical locations, pilot/drain connections, manual release positions, mechanical supports, maintenance isolation and independent stop/hold witnesses. If missing, mark **UNKNOWN** and retain **G0/G1 HOLD**; do not permit people in the hazard zone. No hosted or local compute used.