# ACC-GAS-01 — Accumulator gas-side stored energy is not erased by a hydraulic gauge reading zero
**4400 safety research; 2026-10-26; NON-GRADUATED.** Scope: generic hydraulic machinery including press brakes **only if an accumulator is confirmed installed**. No claim about the selected OpenPressBrake circuit, its gas precharge, pressure, stop or holding function.

## Question and source boundary
Can an operator infer a safe-to-open accumulator vessel from a hydraulic-side gauge at zero, an idle pump, a dark HMI, or an unfilled precharge field? **No.** This is a documentary source audit, not a physical verification. Original manufacturer documents:
1. **HYDAC**, *Accumulators Operating and Installation Instructions*, PN 02068196, ACU1107-1367, **09/2011**, pp. 1–4. Directly inspected original PDF: https://betterfit-us.hydac.com/wp-content/uploads/Operating%20and%20Installation%20Instructions%20for%20HYDAC%20Accumulators.pdf . Sections 1, 3.2, 4.1; figures distinguish accumulator, shut-off, gauge, manual/optional solenoid bleed and relief.
2. **Parker Hannifin**, *BA Series Bladder Accumulators Maintenance and Installation Manual*, **HY10-2300-M1, copyright 2026**, pp. 3, 6, 16, 24, 30. Directly inspected original 40-page manufacturer PDF: https://www.parker.com/content/dam/Parker-com/Literature/Accumulator---Cooler-Division---Americas/Catalogs---Bulletins/HY10-2300-M1_Bladder_Accumulators_Maintenance_and_Installation_Manual.pdf .
3. **OSHA**, 29 CFR 1910.147(d)(5)–(6) and (e), authoritative indexed text https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147 ; direct page fetch returned 403 in this session, so label its detailed provisions **DOC-CONFIRMED from indexed official text**, not direct page inspection. Applicability depends on workplace/task.
4. Existing course: [HYDAC SAF exact catalog selected-block gate](4400_HYDAC_SAF_EXACT_CATALOG_SELECTED_BLOCK_GATE.md), [gauge-zero technician exercise](../safety-course/4400_HYDAC_SAF_GAUGE_ZERO_TECHNICIAN_ADVERSARIAL_EXERCISE.md). **Novel contribution:** independently examine **gas-side vessel/transport/precharge evidence** and false confidence from a blank nameplate precharge, not just hydraulic-side trapped zones.

## Evidence ledger
| Claim | Evidence | Status | Limitation |
|---|---|---|---|
| Accumulator is a pressure vessel; only qualified technicians repair; dry nitrogen only; no welding/brazing/mechanical work on shell | HYDAC PN 02068196 p.1, §§1–2 | DOC-CONFIRMED | HYDAC family instructions, not proof of installed vessel |
| Fluid-side precharge measurement involves an accumulator-connected SAF gauge; during slow discharge the gauge **suddenly falls to zero**; the value immediately before the fall represents gas precharge | HYDAC p.3 §3.2 | DOC-CONFIRMED | Diagnostic procedure only; **zero hydraulic indication is not gas-side zero** |
| Parker BA Series label's customer-specified precharge field can be blank yet vessel can have a **holding charge up to 29 psig (2 bar)** | Parker HY10-2300-M1 p.6 item 16; p.16 transport | DOC-CONFIRMED | Exact Parker BA family; **not** a generic accumulator shipping charge or proof of any particular vessel's current pressure |
| Parker BA removal instructions explicitly require hydraulic pressure zero **and separately gas discharge** with model-specific gas valve procedure | Parker p.24 | DOC-CONFIRMED | Do not turn this course into a hands-on venting recipe; qualified OEM-trained personnel only |
| Parker warns no oxygen/shop air, no gas-valve loosening or disassembly under pressure; assume pressurized until confirmed otherwise | Parker p.3 | DOC-CONFIRMED | Specific manual; safety principle applies generically, verification method remains product-specific |
| Gas pressure and fluid pressure can differ in physical state and observation; gauge isolation, failed indicator, bladder/piston failure and multiple vessels may mask energy | Manufacturer separate-port diagrams plus engineering reasoning | INFERENCE | Actual topology and fault detectability UNKNOWN |
| Installed OpenPressBrake accumulator type, presence, precharge, zone isolation and physical proof | No qualified Stage A packet | UNKNOWN | G0/G1 HOLD |

## Adversarial failure paths
**A — Blank precharge field.** Technician sees blank label, infers empty, loosens vessel component. Parker BA manual says the field can be blank with a nonzero holding charge. **Stop:** preserve pressure-vessel boundary, do not disturb; obtain exact product/manual and qualified confirmation.

**B — Pump off / hydraulic gauge at zero.** The fluid gauge's connection, bleed, isolation and dynamic precharge transition do not directly measure retained nitrogen. **Stop:** do not remove valve, cap, flange or vessel; distinguish independent hydraulic and gas verification under OEM instructions.

**C — Loss of bladder integrity.** A gas-side measurement may encounter fluid or unexpected state. Parker documents fluid at gas valve as a bladder-failure indication (p.22). **Stop:** no improvised refill or opening; qualified inspection.

**D — Replaced accumulator.** A replacement with different label, gas-valve version, orientation, pressure rating or precharge can invalidate previous worksheets. **Stop:** change-control and new manufacturer-specific validation before service/return.

**E — Transport.** Parker's BA holding charge and pressure-vessel handling warnings persist off-machine. **Stop:** no lifting by gas valve, no informal shipping classification; qualified handling per current instructions.

## Architecture and human factors
- **Normal control:** LinuxCNC/HAL/FPGA may show pump off, pressure status, maintenance prompt; cannot certify pressure vessel safe.
- **Diagnostics:** gauge/transducer reading only represents its **actual port and isolation state**; flag unknown or stale measurements, never equate absence of data with zero.
- **Safety-related control:** separately defined functions for preventing hazardous motion/reaccumulation; selected performance targets UNKNOWN.
- **Physical mechanisms:** qualified energy-isolating devices, bleed/relief, independently restrained gravity load, and OEM-specific gas-side handling. A hydraulic SAF block is **not** by itself gas-side disassembly permission.
- **Safer easiest path:** visible durable two-sided GAS / FLUID labels, accumulator count/locations on accessible schematic, readable gas-valve protection, accessible safe service clearances, captive guards, simple service prohibition when unknown. Avoid making technicians defeat guards just to read a nameplate.
- **Minimum operating threshold:** absent qualified independent Y1/Y2 stop/hold, isolation and guard proof, no personnel-exposed hazardous operation. Remote isolated experiments still require a separately controlled plan.

## Required selected-machine evidence (private)
Accumulator presence/count/IDs; exact OEM manual/revision; gas and fluid connection diagrams; nameplate and actual qualified precharge record; hydraulic zone/gauge/bleed/isolation mapping; effect on Y1/Y2 stop/hold and gravity loads; trained personnel/service method; documented independent physical witness and rearm. Mark all **UNKNOWN** until qualified. Do not publish personal or sensitive plant diagrams publicly.

**SOURCE-CONFIRMED LinuxCNC:** none new. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none relied on. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.**
