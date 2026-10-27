# 4400-FIRE-SUP-01 — CNC suppression discharged: keep the fire, machine and personnel boundaries separate

**2026-10-27 | One-pass practical technician/AI learner review | PUBLIC, UNSCORED, NON-GRADUATED.** Read the [original Firetrace/OSHA/HSE source audit](../research/4400_FIRE_SUP_01_CNC_AUTOMATIC_SUPPRESSION_PRESSURE_SWITCH_BYPASS_AGENT_REENTRY_SCOPE_AUDIT_2026-10-27.md), the [safety course index](SAFETY_COURSE_INDEX.md) and [cumulative Safety Design Package](SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md). No selected machine, test, or personnel-safety release is established.

## Recognize the six independent facts

| Question | What must be established | What is **not** proof |
|---|---|---|
| Did the detector sense fire? | Correct selected tubing/sensor and hazard-zone coverage | CNC running or a normal HMI status. |
| Did agent reach the hazard? | Cylinder/valve/tube/nozzle/enclosure evidence and qualified service | Pressure switch toggled or a cylinder was present. |
| Did the machine stop feeding ignition/fuel? | Actual spindle, coolant/oil pump, collector and process response under the selected fire plan | An optional pressure switch is called "E-stop" in a brochure. |
| Is independent machine motion safety intact? | Selected guard/E-stop/safety-controller/final-element proof | Suppression discharge or an ordinary LinuxCNC stop bit. |
| Is it safe to open/enter? | Agent-specific fire/atmosphere/ventilation/entry assessment and emergency response | Flames no longer visible or a fixed waiting time. |
| May the machine restart? | Fire root cause corrected, approved suppressant restored, interfaces not bypassed, independent safety healthy and **fresh deliberate start** | Jumper across discharged pressure switch or reset of CNC alarm. |

**Field story with direct provenance:** The manufacturer [Firetrace Tsugami case](https://www.firetrace.com/swiss-lathe-save) reports a shop disabling a pressure switch to resume production after discharge; the separate [Firetrace Citizen case](https://www.firetrace.com/swiss-turning-machine) reports a shop refusing to bypass and waiting four days for recharge. These are **COMMUNITY-REPORTED manufacturer-published customer accounts**, not independently verified machine safety assessments. The important design lesson is to make replacement cylinders, qualified service and an alternate production plan readily available, so restoring protection is easier than bypassing it.

## One-pass review for a qualified machine team (not a live test procedure)

1. **Identify:** record exact fire system, agent, model, installation revision, fire hazards, enclosure and whether this is local application or total flooding. OSHA [1910.160](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.160) distinguishes systems required by OSHA from optional systems with employee exposure; do **not** apply all subsections automatically.
2. **Map independent authority:** pneumatic detector/discharge; accessory pressure switch; ordinary CNC/HAL/FPGA stop request; independently qualified machine safety chain; physical spindle/pump/collector shutdown. A pressure switch may be useful but has **no assumed safety rating**.
3. **Treat discharge as IMPAIRED:** mark suppressor unavailable until selected approved service/recharge, inspection, correction of ignition cause and interface restoration. An HMI can display impairment but cannot certify fire extinguishment or safe atmosphere.
4. **Control access:** keep people out of the hazard; CO2 and some agent/decomposition products can be dangerous after flames disappear, including adjacent low areas. Use qualified atmosphere/re-entry process, not a universal purge time. Avoid opening the enclosure to hand-fight an active fire.
5. **Make the safe workflow convenient:** clear "FIRE SYSTEM DISCHARGED—NO AUTOMATIC RESTART" state, visible non-defeatable notice, local recharge plan, stocked correct spare, accessible service and a documented alternative production route.
6. **Document change/revalidation:** new coolant, metal, enclosure, mist collector, agent, nozzle, sensor tube, pressure switch, PLC input or restart logic invalidates affected fire/physical witness until qualified review.

## Conditional witness and release boundary

Reuse selected-machine Stage A and conditional FS-1..6 in the [research audit](../research/4400_FIRE_SUP_01_CNC_AUTOMATIC_SUPPRESSION_PRESSURE_SWITCH_BYPASS_AGENT_REENTRY_SCOPE_AUDIT_2026-10-27.md); all **UNKNOWN/NOT RUN**. No fire, gas release, live bypass or personnel-exposed machine experiment is authorized. A local application system is not automatically a covered occupied-room total-flooding system; manufacturer product scope and regulatory applicability must be determined before applying pre-discharge alarm or agent-concentration rules. The [HSE CO2 hazard guidance](https://www.hse.gov.uk/coshh/basics/carbondioxide.htm) concerns CO2 specifically, not every clean agent.

**Status:** 1000/2000/F02/3000 CLOSED; 4400 documentary transfer NON-GRADUATED; 2520–25F0 independent evaluator NOT RUN; OpenPressBrake applicability UNKNOWN, **G0/G1 HOLD**. No simulation, test or compute.

## OEM keyed-service bypass variant — important correction (direct manual)

The [Firetrace DIOM 800095-A Rev A (2022-07-22) original manual](https://www.firetrace.com/hubfs/instruction-manual/PressureSwitchModule_InsallationGuide.pdf?hsLang=en) documents **both keyed-bypass and no-bypass dual-pressure-switch modules**. Its Table 2 has configurations that bypass activation and service together, bypass activation while **forcing a service indication**, bypass activation only, or permit no bypass; Table 3 covers the standard no-key module. A keyed service feature is therefore **not automatically an illicit jumper**, but its *selected configuration, downstream monitoring, task and authorization* determine the actual hazard. Do not assume a bypassed pressure switch means a machine may run production unprotected.

**Reviewer question:** during a qualified, isolated documentary inspection, can the team show the installed module part/configuration, key-control and who receives the distinct **activation** and **service/IMPAIRED** signals? A keyed activation bypass with a conspicuous service state is a candidate for maintenance usability, **not** a certified safety function or permission for automatic production. Manufacturer §4.2 requires authorized distributor consultation after discharge and recharge under the exact system manual. Do not treat the older [2020 TB041 solenoid wiring bulletin](https://www.firetrace.com/hubfs/Dual_Switch_Wiring_Diagram.pdf?hsLang=en) as the 2022 module's wiring contract. All selected-machine proof remains UNKNOWN.
