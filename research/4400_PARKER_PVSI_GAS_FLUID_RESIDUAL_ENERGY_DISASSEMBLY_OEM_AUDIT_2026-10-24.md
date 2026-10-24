# 4400 — Parker PVSI-01: hydraulic zero, retained gas energy, and disassembly stop signs
**2026-10-24 | Original manufacturer PDF directly inspected | documentary, NOT a selected-machine test**

## Why this is a new question
Earlier accumulator lessons correctly distinguish protective-cycle energy from maintenance isolation. This follow-on examines a more specific **service failure**: the hydraulic circuit may have been drained while the accumulator's nitrogen side remains pressurized; even attempted gas release can leave a physically trapped-pressure condition. A single fluid gauge cannot adjudicate gas-side condition or safe opening of the pressure vessel.

## Primary source and exact scope
Parker Hannifin, *Servicing Instructions — Standard Bladder Accumulator (forged shell repairable)*, **PVSI-01, catalogue HY10-4014-M1/UK**, document footer **2013-06-04**, eight-page original:
https://www.parker.com/content/dam/Parker-com/Divisions-2011/Accumulator-and-Cooler-Division---Europe/SupportAssets/Parker_PVSI-01_Accumulator_Servicing_Instructions_Manual.pdf

Original PDF **page 3 (PDF index 2)**: "Isolation & Draining" separates closing the safety-block isolation valve, opening the relief/drain valve until its gauge reads zero, and subsequent removal. It also describes a separate bleed-facility option *if fitted*. **DOC-CONFIRMED for the illustrated Parker equipment**, not universal valve order for another machine.

Original PDF **page 4 (PDF index 3)**: the accumulator may be removed from system pipework only after its hydraulic pressure has been removed; **removal of gas precharge is a distinct procedure**. This is direct evidence that a hydraulic gauge at zero does not prove that the gas precharge is zero. **DOC-CONFIRMED**.

Original PDF **page 5 (PDF index 4)**: during internal disassembly, the manufacturer warns that resistance at the fluid port can mean trapped pressure; it says to stop and consult Parker. Its poppet illustration treats a closed poppet as a possible trapped-pressure sign. **DOC-CONFIRMED**, *not* an instruction for an unqualified person to probe the port or disassemble a vessel to check pressure.

The PDF's opening warning restricts the work to competent personnel; it also refers to companion product information. We did **not** establish that all companion instructions, selected certification requirements or every accumulator variant were inspected.

## Authority and physical proposition ledger
| Proposition | What a witness may support | What it cannot support alone |
|---|---|---|
| Pump supply OFF | Normal pump drive disabled | Fluid discharged, gas discharged, ram supported |
| Selected fluid-side gauge zero | Pressure at its connected tap under current valve topology | Every isolated chamber zero; gas precharge absent |
| Fluid-side drain operated | Drain action requested or performed | Drain path open, no blocked tap, no reaccumulation |
| Nitrogen charging valve cap present | Physical cap present | Gas charge absent or gas valve safe to open |
| Gas precharge released under OEM procedure | A specific qualified gas-side step completed | Fluid side, trapped pockets, gravity load and full disassembly readiness |
| Unexpected resistance / closed poppet | Potential trapped pressure warning in exact Parker procedure | Safe condition; permission to force hardware apart |

**No generic service procedure is authorized here.** The actual Parker manual is the controlling source for qualified technicians servicing its covered model. This curriculum document deliberately omits executable vessel-opening instructions.

## Failure-path analysis — why the old green lamp is inadequate
1. **Fluid gauge low, gas side charged.** Pressurized gas remains stored energy in a closed vessel. If service scope includes opening the vessel, a fluid-side reading is not enough.
2. **Wrong isolation zone.** A valve or check valve separates the gauge from the volume a technician is about to open. The gauge's reading can be truthful while the work zone remains pressurized.
3. **Bleed path obstructed.** A commanded discharge or valve-position indication cannot establish that the actual volume has emptied; a blocked return or failed seat may defeat it.
4. **Reaccumulation.** Temperature, leakage across isolation, cross-port supply, pilot circuits or gravity load can change the pressure after an initial reading; these are **INFERENCE** until the exact system is known.
5. **Misread disassembly symptom.** Mechanical resistance is not permission to apply greater force. The manufacturer explicitly treats it as a stop sign.

## Human factors and safer defaults
Make the **zone identity** visible at each accessible, guarded service test point: accumulator fluid side, nitrogen side (qualified service only), cylinder A/B, pilot and manifold return. A single undifferentiated 'hydraulic zero' HMI lamp is an unsafe interface simplification. Service guards and ports should be reachable without defeating protective devices; if they are not, redesign the access rather than normalize bypass. Keep ordinary LinuxCNC/FPGA displays informational, not personnel-safety authority.

## Applicability, claims and gaps
- **DOC-CONFIRMED:** exact Parker PVSI-01 statements above, PDF pages 2–4.
- **INFERENCE:** fault-tree and service-interface implications for other machines.
- **UNKNOWN:** selected OpenPressBrake accumulator presence/type, gas charge, fluid volumes, isolation/bleed topology, gravity restraint, instrument validity, qualified service process and actual physical state.
- **SOURCE-CONFIRMED / TEST-CONFIRMED:** none newly established. No live pressure test, gas release, or physical disassembly.
- **Counterfactual:** if the selected machine has no gas accumulator, device-specific gas steps become N/A only after inventory; trapped fluid, gravity and stop/hold still require independent proof.

Related earlier work: [dual-role study](4400_ACCUMULATOR_DUAL_ROLE_SAFE_CYCLE_VS_ISOLATION_2026-10-22.md), [reaccumulation contract](4400_ACCUMULATOR_PROTECTIVE_CYCLE_REACCUMULATION_WITNESS_CONTRACT_2026-10-23.md). This audit adds original direct **service-vessel** evidence; it does not repeat their generic transaction model.
