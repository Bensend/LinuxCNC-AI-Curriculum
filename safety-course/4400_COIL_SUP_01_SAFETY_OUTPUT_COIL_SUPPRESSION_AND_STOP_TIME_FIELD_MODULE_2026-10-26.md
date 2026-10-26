# COIL-SUP-01 field module — The relay is OFF; when does the hazard stop?
**PUBLIC PAPER ONLY / NON-GRADUATED. 10 scenarios UNSCORED, 10 documentary gates NOT RUN.** [Original Rockwell/OMRON source audit](../research/4400_COIL_SUP_01_ROCKWELL_OMRON_DC_COIL_SUPPRESSION_DROPOUT_STOP_TIME_SOURCE_AUDIT_2026-10-26.md).

## Learner objective
Trace protective demand -> independent safety controller -> output -> suppressor/coil current -> armature/valve -> actual energy path -> hazardous motion stopped -> gravity load held. Distinguish **safety logic OFF**, **coil no longer energized**, **contact/valve physically changed**, **motion stopped**, and **load supported**. Do not invent stopping time, distance, coil resistance, PL/SIL, pressure or valve state.

## Ten adversarial technician scenarios — all UNSCORED
1. An E-stop safety output drops, but a DC contactor opens later than the previous revision. Which exact coil/suppressor replacement evidence is needed before reusing old stop-time proof?
2. An electrician proposes a plain flyback diode across a hydraulic valve coil as the cheapest output protection. What can improve and what can become worse?
3. A colleague removes the diode to make the valve release faster. What new electronic-output and EMC risks arise, and who must approve the design?
4. The contactor's mirror auxiliary reports OFF. Which physical proposition does this support and which Y1/Y2 gravity-hold propositions remain UNKNOWN?
5. A manufacturer specifies a Zener-plus-diode option. Does its presence prove an acceptable press-brake stop time?
6. The valve coil has lost supply, but an elevated ram moves. Separate valve actuation, trapped pressure, load support and normal LinuxCNC status.
7. A replacement DIN plug contains an LED and suppression element. What must be checked before restoring hazardous motion?
8. A technician transfers a time number from a different AC-coil product. Explain why this cannot qualify a selected DC safety chain.
9. A guard is frequently removed to reach a hidden plug. Design a practical accessible, captive, correctly labeled replacement without weakening protection.
10. A source says suppression changes dropout, but no exact selected hardware exists. Decide whether to run a generic simulation, freeze a machine-specific lab, or continue documentary design and why.

For each: state hazard, failure path, source label, normal LinuxCNC/FPGA role, independent safety role, physical witness, UNKNOWN and HOLD condition.

## Ten documentary verification gates — NOT RUN
| ID | Required qualified evidence | Status |
|---|---|---|
| COIL-SUP-V01 | Selected machine, safety function and physical stop/hold requirement | NOT RUN |
| V02 | Exact safety output/driver identity and ratings | NOT RUN |
| V03 | Exact coil/contactor/valve model, rated supply and polarity | NOT RUN |
| V04 | OEM-approved suppression type, part number, wiring location | NOT RUN |
| V05 | Selected worst-case dropout/release evidence and variation | NOT RUN |
| V06 | Final-element physical feedback/witness and EDM scope | NOT RUN |
| V07 | Full physical stop-time/distance and gravity-hold qualification plan | NOT RUN |
| V08 | Common supply/return, cable and suppression fault review | NOT RUN |
| V09 | Replacement, labeling, guard usability and change-control record | NOT RUN |
| V10 | Independent restart/rearm, commissioning and physical validation authorization | NOT RUN |

**Gate decision:** No selected as-built evidence -> G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD. No personnel-exposed hazardous operation; any future experimental operation must be separately approved, isolated/remote, and account for residual gravity/hydraulic risk.
