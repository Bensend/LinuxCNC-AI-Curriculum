# 4400-ACC-SAF-01 — Exact SAF bleed variant and the two accumulator energy domains

**Status:** original-manufacturer documentary source audit, 2026-10-25; **NON-GRADUATED**. Distinct question from historical HYDAC DSV10 changeover-overlap and earlier generic accumulator fault trees: **does the actual SAF order code preserve the expected deenergized discharge behavior, and what does fluid-side zero fail to prove?**

## Source provenance and editions

1. **HYDAC, Accumulator Accessories, SAF Series, PN 02068195 / 4.21 / ACU1808-2025, printed H4–H5 (PDF pp. 3–4):** directly opened original manufacturer PDF, https://betterfit-us.hydac.com/wp-content/uploads/Accumulator-Accessories.pdf . H4 explicitly distinguishes main shutoff, manual bleed, optional solenoid bleed, optional gauge, relief valve, and S/P/T/M1 ports; H5 gives model-code semantics. **DOC-CONFIRMED**, exact brochure edition.
2. **HYDAC manufacturer catalog for exact part 2075950, SAF20M16-N350A S13:** directly opened https://catalog.hydac.com/en-us/item/safety-and-shut-off-blocks/type-saf-safety---shut-off-blocks/2075950 . Exact **M = manual discharge**, even though the generic catalog metadata also displays “Valve Type: Solenoid.” That generic field is **not** evidence of an installed solenoid bleed. **DOC-CONFIRMED** catalog record; model-specific circuit still requires installed drawing.
3. **Parker Hannifin, Bladder Accumulators Maintenance and Installation Manual HY10-2300-M1, printed pp. 17, 22, 24 (PDF pp. 17, 22, 24):** directly inspected original PDF, https://www.parker.com/content/dam/Parker-com/Literature/Accumulator---Cooler-Division---Americas/Catalogs---Bulletins/HY10-2300-M1_Bladder_Accumulators_Maintenance_and_Installation_Manual.pdf . The installation section calls for hydraulic-side automatic discharge on shutdown; the precharge and removal sections treat gas pressure separately, with qualified personnel and model-specific procedures. **DOC-CONFIRMED** for Parker BA series, not a HYDAC SAF instruction.
4. HYDAC 2024/2025 full accumulator catalog indexed at https://www.hydac.com/download/accumulator-technology-product-catalogue-1000443492-en.pdf includes Y normally-open and Z normally-closed variants plus further locking/position-monitoring options, but **direct opening returned 403**. It is an edition-comparison lead only; do not claim its full clauses were directly checked. Use directly opened 4.21 source for this audit's exact claims.

## Direct manufacturer discriminators

| Question | Exact source finding | What it does **not** establish |
|---|---|---|
| Is “SAF” one uniform bleed design? | HYDAC H4: **M** has manual discharge; **E** adds optional solenoid-operated discharge. | A product-family label, catalog “Valve Type,” or HMI bit does not prove automatic bleed is installed. |
| What does power removal do? | HYDAC H5: E-series **Y** WSM06020Y is **normally open (standard)**; **Z** WSM06020Z is **normally closed**. | Neither proves the tank path is unobstructed, the valve is not stuck, a check valve does not isolate another pocket, or the gravity load is held. |
| Is the pressure gauge universal? | HYDAC H4 calls pressure gauge **optional**, gives M1 gauge connection. | “Gauge zero” cannot cover an uninstrumented downstream zone, the gas side, or ram restraint. |
| Does relief equal isolation? | H4 distinguishes **pressure relief**, **main shutoff**, **manual bleed**, **optional solenoid bleed**. | Relief opening at overpressure is not routine deenergized exhaust, maintenance LOTO, or proof of zero stored energy. |
| Can shutoff be locked? | HYDAC H5 code **L = locking device**; not all combinations available. | An ordinary hand valve without a verified lockable provision is not automatically a compliant personnel energy-isolating device. |
| What remains after fluid discharge? | Parker HY10-2300-M1 separates discharge of hydraulic fluid for precharge checks from **gas pressure** and gives distinct gas-depressurization requirements for removal. | A hydraulic zero reading is not proof that the gas vessel is depressurized or safe to open. |

**Version/variant warning:** A replacement SAF20E...Y -> SAF20E...Z, or SAF...E -> SAF...M, changes power-loss behavior or removes automatic discharge. Treat as an **SRS/ARC/CHG** event, not an equivalent spare-part substitution. An “E” alone does not establish whether the actual solenoid is Y or Z.

## Three different propositions and a fourth hazard

1. **Accumulator fluid discharge:** selected hydraulic port/accumulator pressure is reduced via a documented path, witnessed in the correct zone.
2. **Gas vessel energy:** precharge may remain even when fluid side is empty. Qualified maintenance requires the exact manufacturer's gas-side procedures; do not direct an untrained builder to vent or open a pressure vessel.
3. **Gravity load / other trapped cavities:** Y1/Y2 or another vertical load may still move if a discharge path changes pilot pressure or holding. Prove physical restraint independently, not by a gauge or valve-coil LED.
4. **Protective-cycle dependence:** an accumulator might be deliberately used for a controlled stop or rescue movement; dumping it at the wrong stage can defeat that function. The actual machine's role is **UNKNOWN**. Do not specify a universal fail-safe valve polarity.

## Fault-path / common-cause audit (INFERENCE, not a selected hydraulic truth table)

| Adversarial change | Invalid inference | Required independent question |
|---|---|---|
| Y replaced by Z | “Power OFF means discharge” | Does actual deenergized path open to tank? |
| E replaced by M | “Emergency stop dumps accumulator” | Is automatic bleed physically present? |
| Pressure gauge omitted or on wrong side of shutoff | “HMI says zero, all pressure zero” | Which pressure pocket does the tap witness? |
| Blocked tank return / stuck spool | “Coil OFF means fluid exhausted” | What separate physical pressure witness and fault reaction exist? |
| Accumulator drained while ram elevated | “Zero accumulator pressure makes press safe” | What prevents gravity motion independent of hydraulics? |
| Fluid zero while gas precharged | “Safe to disassemble vessel” | Has the qualified gas-side procedure been performed? |
| HMI green/normal LinuxCNC E-stop | “Safety valve and energy state proved” | What independent safety final element, pressure and hold witnesses exist? |
| Power restored / reset accepted | “Ready means safe to move” | Have physical state, guarding and a **fresh motion command** been validated? |

## Practical low-friction design direction (INFERENCE)

Prefer an **exact-part, legibly labeled** block with clearly mapped S/P/T/M1 ports, a **lockable isolation mechanism** where required, a **clearly accessible manual bleed** with safe discharge routing, a gauge/test point for each hazard-relevant trapped zone, and a visible service card distinguishing fluid-side versus gas-side service. This can reduce the temptation to crack a fitting or defeat a guard. It is a selection *method*, not a prescribed bill of materials or assurance that a compact block is safe for every press.

## Explicit evidence limits

- **SOURCE-CONFIRMED (new LinuxCNC):** none; LinuxCNC/HAL/FPGA ordinary command/monitoring cannot acquire personnel-safety authority from this manufacturer audit.
- **DOC-CONFIRMED:** exact HYDAC 4.21 SAF brochure and exact Parker HY10-2300-M1 manual statements above; HYDAC 2024/2025 catalog **indexed only**.
- **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none relied upon.
- **INFERENCE:** fault propagation, preferred human-factor architecture and change-control consequences.
- **UNKNOWN:** whether OpenPressBrake even has an accumulator; selected SAF/other block variant, Y1/Y2 circuit, relief/discharge port topology, gauge placement, actual pressures, pilot/holding behavior, PL/SIL, stopping distances, external evaluation, machine safe-state.

**G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** No energized test, physical operation, safety approval, or compute justified by this documentary discriminator. Preserve historical DSV10 work without transferring its negative-overlap fact to SAF.

## Direct visual circuit-diagram check (H4/H5, original PDF pages 3–4)

The HYDAC **H4 schematic was visually inspected**, not merely keyword-searched. It places S on the accumulator connection, P on the system, T on tank, and M1 on the gauge connection; the E circuit shows a **flow-restricting symbol** in the solenoid discharge branch. **DOC-CONFIRMED diagram content**, but neither a selected restriction size nor a guaranteed discharge time is published by that drawing. Consequently **“bleed commanded” != “immediately at zero pressure”**. H5's visually inspected complete example code confirms the **Y/Z operating-function character** and the **L locking-device suffix** are distinct selections. H5 also separates N adjustable relief settings from T factory-set/wire-sealed relief options; neither is a substitute for an independent physical discharge witness. Do not transpose this generic family drawing into an uninspected selected hydraulic circuit.
