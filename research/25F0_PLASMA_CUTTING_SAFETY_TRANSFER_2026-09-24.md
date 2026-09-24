# 25F0 — plasma/cutting-machine safety transfer delta

Session start UTC: 2026-09-24T03:37Z

## Why this delta exists

The 25F0 capstone contract explicitly names plasma/laser tables, but the current capstone package had no learner-facing process-energy transfer case. That is a real safety-method gap, not a reason to reopen the graduated 3300 Plasma/Laser/Waterjet manufacturing specialization. This artifact adds only the safety-specific transfer needed to prove that the learner can extend the capstone method beyond rotating/hydraulic machinery.

## Evidence boundary

`DOC-CONFIRMED` — OSHA welding/cutting guidance identifies metal fumes, ultraviolet radiation, burns/eye injury and electrical shock among cutting hazards. OSHA hot-work guidance also identifies fire hazards and requires hazard-specific controls/PPE.

`DOC-CONFIRMED` — Hypertherm plasma-system safety material identifies electric shock, fire/explosion, toxic fumes, plasma-arc injury/burns, arc radiation, grounding, compressed-gas/cylinder and noise hazards. Current XPR installation guidance requires line disconnect/LOTO for installation and warns that dangerous voltage can remain relevant when the plasma system is connected to its electrical source; process gases can also introduce fire/explosion hazards requiring product/application-specific controls.

These sources establish hazard classes, not a universal machine safety circuit, fume threshold, fire-watch interval, arc-safe distance, electrical discharge time, gas truth table or stopping distance.

## Transfer from the common capstone method

The same mandatory chain still applies:

`machine/lifecycle boundary -> hazardous event -> hierarchy -> SRS -> physical proposition -> authority allocation -> dependencies/CCF -> validation -> maintenance/change control`

What changes is the physical proposition. A plasma table can have ordinary gantry motion safely stopped while hazardous process energy, hot material, fumes, fire, electrical energy or compressed/process gas remains.

### Hazard / energy boundary

Include at minimum, where actually present:

- X/Y/Z or gantry mechanical motion and pinch/crush exposure;
- plasma arc/process electrical energy and shock exposure;
- hot workpiece, sparks, molten material and fire propagation;
- fumes/gases whose composition depends on material, coatings and process;
- ultraviolet/infrared radiation and eye/skin exposure;
- compressed air and other process gases, cylinders/regulators/hoses and gas-specific fire/explosion effects;
- stored electrical energy and line-connected maintenance exposure;
- water-table or extraction-system hazards where present;
- workpiece/support/drop hazards and slag/debris handling;
- maintenance access to torch, power supply, extraction, gas and motion systems.

Laser-specific optical/enclosure/interlock requirements are **not** inferred from plasma evidence. A laser machine requires its own product/process evidence.

## SRS transfer skeleton

| ID | Safety demand | Physical proposition to establish | LinuxCNC boundary | Evidence state |
|---|---|---|---|---|
| SRS-PC-MOTION | access/E-stop requires hazardous table motion to cease/prevent restart | named axes/gantry reach the machine-specific safe motion state | LinuxCNC may request/indicate stop; independent safety authority remains separately justified | architecture-specific |
| SRS-PC-ARC | protective demand requires prevention/termination of hazardous arc initiation | torch/process energy cannot initiate or persist in the prohibited condition | `torch-enable=0` or GUI status alone is not physical proof | machine/product-specific |
| SRS-PC-ELEC | servicing requires electrical hazardous-energy control | relevant sources are isolated/dissipated/verified according to product and procedure | LinuxCNC power-off is not electrical isolation | product-specific |
| SRS-PC-FIRE | process operation must control ignition/fire exposure | combustible exposure and hot-work/fire-control conditions remain within the justified operating method | CNC motion/process completion does not prove fire hazard ended | site/process-specific |
| SRS-PC-FUME | cutting must not expose people to uncontrolled hazardous fumes/gases | extraction/ventilation/protection appropriate to material/process is established | software fan command/status alone is not air-quality proof | material/process/site-specific |
| SRS-PC-RADIATION | exposed people must be protected from arc radiation | required screening/PPE/access control is physically in place | ordinary HMI warning is informational only | process/site-specific |
| SRS-PC-GAS | gas-system faults/maintenance must not create uncontrolled stored/fire/explosion hazards | applicable gas isolation, regulation, hose/cylinder integrity and product-required safeguards are established | LinuxCNC valve command is not gas-safe-state proof | product/gas-specific |
| SRS-PC-RESTART | power/process restoration must not unexpectedly initiate motion or arc | restoration requires the justified rearm/start sequence and no hazardous automatic restart | normal program state does not grant safety authority | architecture-specific |
| SRS-PC-MAINT | torch/power/gas/extraction service requires hazardous-energy control | relevant electrical, pneumatic/gas, thermal and mechanical sources are isolated/verified before exposure | production interlock is not maintenance isolation | machine-specific |

## Fault/adversarial transfer cases

1. **Gantry stopped, arc path still enabled.** Motion status is healthy but process energy can still initiate. Result: machine safe state is not proved.
2. **Torch-enable output is OFF, electrical source remains hazardous.** Result: command inhibition is not electrical isolation.
3. **Extraction command ON, airflow ineffective.** A broken duct, clogged filter or failed fan can make controller status misleading. Result: `EXTRACTION COMMANDED != FUME CONTROL PROVED`.
4. **Cut complete, hidden smoldering/fire remains.** Program completion is not a fire-safe-state witness.
5. **Power restored with cycle/torch request retained.** No hazardous arc or motion may start merely because controller state returned.
6. **Compressed/process gas command OFF, upstream stored gas remains.** Valve command does not establish isolation, depressurization or gas-specific safe state.
7. **Maintenance performed with CNC disabled but plasma power still line-connected.** Result: ordinary controller disable is not hazardous electrical-energy isolation.

## Durable freezes

- **GANTRY STOPPED != PROCESS ENERGY SAFE STATE PROVED**.
- **TORCH ENABLE OFF != ELECTRICAL ISOLATION PROVED**.
- **EXTRACTION COMMANDED != FUME CONTROL PROVED**.
- **CUT PROGRAM COMPLETE != FIRE HAZARD ENDED PROVED**.
- **GAS VALVE COMMAND OFF != GAS ENERGY ISOLATED PROVED**.
- **LINUXCNC DISABLED != PLASMA POWER MAINTENANCE ISOLATION**.

## Human-factors gate

The learner must inspect what routine loading, plate alignment, consumable change, slag clearing, fume-system maintenance and recovery actions tempt a person to enter the hazard zone or bypass extraction/guards. Design access and restoration so the safe route is practical. A nuisance-prone extraction interlock or difficult torch-isolation procedure is a defeat-pressure problem to engineer, not an excuse to silently weaken the safeguard.

## Safe-to-operate threshold

If the actual machine cannot establish the minimum attended-operation safeguards for hazardous motion, process electrical/arc exposure, fire/hot-work exposure, fumes/radiation and applicable gas hazards, it should not be operated with people exposed. Experimental operation must remain isolated/remote with people outside the danger zone and residual risk explicit.

## UNKNOWN register

Remain UNKNOWN until machine/product/site evidence exists: plasma power-supply internal discharge behavior; exact safe isolation points; material-specific fume concentration/control; extraction airflow acceptance values; gas-specific pressures/valve fail states; fire-watch or cooling duration; machine stopping time/distance; required integrity target; proof-test interval; any laser-specific optical/enclosure safety function.

## Audit conclusion

This closes the process-energy machine-class gap identified by the 25F0 contract without reopening 3300 manufacturing instruction. No executable compute is justified: the unresolved items are machine/product/site facts requiring authoritative evidence or physical validation, not generic simulation.