# 4400 technician field card — “Power OFF, valve present, load safe?”
Date: 2026-10-23 UTC | Open-book, learner-visible exercise; **not** a blind benchmark or a physical test authorization.

## Purpose

Train technicians and designers to distinguish **normal motion stopped**, **pilot pressure removed**, **valve mechanically holding**, **actual load restrained**, and **maintenance energy isolated**. Read [the primary-source mechanism audit](../research/4400_COUNTERBALANCE_PILOT_THERMAL_RELIEF_AND_MOTOR_BRAKE_BOUNDARY_2026-10-23.md) and the [selected-machine witness intake gate](4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md). This card deliberately gives no pressure setpoints, stopping times, leak tolerances or installation wiring.

## Field scenarios (paper only; no deliberate fault injection)

**1. Pump is off; the counterbalance valve's electrical status is green.** A mechanic wants to loosen a hose between a cylinder and the valve. Is the hose proven depressurized? Which physical volume is exposed? What would a competent energy-control plan require before loosening anything?

**2. Power is lost during a commanded descent.** The pilot circuit includes a check valve and a possible shared supply. Which as-built facts must be established before claiming that pilot pressure vanished? What if a green diagnostic is from before power loss?

**3. A load-holding cartridge is present but a service override was previously used.** Which exact order code, override position, tamper resistance and return-to-service records matter? Why does the presence of a cartridge fail to establish `PHY-HOLD`?

**4. A counterbalance-equipped hydraulic motor supports a suspended load.** Does the valve by itself establish long-term standstill? What mechanical brake/load-position evidence would you request, and why might a shaft sensor miss a disconnected load?

**5. A cylinder is warm after shutdown.** What does thermal relief mean for a trapped pressure zone? Why is it unsafe to eliminate a relief path merely to obtain a “perfect hydraulic lock”? Which safe mechanical restraint should be considered by the qualified designer?

**6. An apparent hose-burst protection valve is installed remotely.** What unprotected volume exists between the cylinder and valve? Which load direction and hose-failure location does the claimed protection actually cover?

**7. Production restarts after service.** The HMI still shows an old cycle-start command, and the valve/guard state has not been freshly observed. Which independent safety prerequisites and fresh operator actions must precede any hazardous motion?

## Required answer format

For each scenario produce a five-column record:

| Physical proposition | Legitimate evidence | Misleading proxy | Unknown selected-machine fact | Decision |
|---|---|---|---|---|
| e.g. `PHY-ENERGY` | As-built mapped volume + qualified isolation/verification | “Pump off” lamp | Which hose and which isolated zone? | **HOLD** until verified |

Tag each technical claim **SOURCE-CONFIRMED**, **DOC-CONFIRMED**, **TEST-CONFIRMED**, **COMMUNITY-REPORTED**, **INFERENCE**, or **UNKNOWN**. Do not mark TEST-CONFIRMED from reading a PDF. A decision of HOLD is correct when the physical proposition cannot be established; it is not evidence that a particular machine is defective.

## Minimum expected reasoning / instructor review guide (open book)

- A counterbalance/PO-check can trap load-side pressure while pump-side pressure is zero; a pressure indicator measures only its connected zone.
- A powered-off pump does not independently measure pilot pressure, nor does it prove that a cross-connected or isolated pilot volume has vented.
- Sun's June 2023 technical tip separates **non-modulating PO-checks** from **modulating counterbalance valves**, and describes pilot-piston leakage in certain PO-check variants; exact model matters.
- Parker's catalog describes thermal relief and distinguishes hydraulic motor internal leakage from cylinder holding; the motor case requires separate mechanical brake consideration.
- A remotely located valve cannot automatically protect the segment between it and the cylinder; this is a **topology inference** requiring installed verification, not a universal product rating.
- A release or recovery command is not proof of stopped/held motion; ordinary LinuxCNC and FPGA indicators cannot independently authorize personnel access.
- The safe default is to leave the hazard unexposed, make correct lockout/support/guard restoration easy, and require independent fresh rearm plus deliberate new start.

## Human-factor adversarial review

Ask an operator and maintainer: *What step would you be tempted to skip because the safe process is inconvenient?* For every answer, identify a redesign (accessible qualified test points, unambiguous physical labels, protected/visible override indication, tool-free guard return where compatible with the qualified design, service-friendly support provision). **Never** propose defeating a guard or loosening a pressure connection to discover its state.

## Qualification and release

This exercise earns no external graduation credit until an information-separated evaluator scores a valid challenge. It is not a selected-machine acceptance procedure. No personnel-exposed operation is authorized without independent physical stopping, holding, access, escape, isolation and restart proof. Keep `IN-01..10` UNKNOWN and `VAL/PT` NOT RUN until real evidence exists.

Sources: [Sun 2023 technical tip](https://www.sunhydraulics.com/sites/default/files/media_library/tech_resources/TT_US_Ctrbal_POCk_Jun2023_Final_0.pdf), [Parker HY15-3502/US](https://www.parker.com/content/dam/Parker-com/Literature/Hydraulic-Cartridge-Systems-Division---Europe/HCSE-Websphere-literature/HCSE_LoadControlValves/Parker_HCSE_LoadControlValve_datasheets_HY15-3502-US-EU_English.pdf), [Parker HY08-4005-M11](https://www.parker.com/content/dam/Parker-com/Literature/Industrial-Cylinder/cylinder/Serv/HY08-4005-M11_HAS_Installation_Manual.pdf), [OSHA 29 CFR 1910.147](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147).
