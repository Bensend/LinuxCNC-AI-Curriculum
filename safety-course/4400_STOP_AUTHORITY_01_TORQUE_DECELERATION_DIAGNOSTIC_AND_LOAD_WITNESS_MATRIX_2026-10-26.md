# 4400-STOP-AUTHORITY-01 — Who brakes, who monitors, who removes torque, who holds the load?

**Status:** cross-function safety design teaching matrix, PAPER ONLY / NON-GRADUATED / not a machine wiring diagram. Based on directly inspected [Siemens S210 FDI-01](../research/4400_SIEMENS_S210_FDI_ASYMMETRIC_DISCREPANCY_FAULT_TO_STO_SOURCE_AUDIT_2026-10-26.md), [SS1E-01](../research/4400_SIEMENS_S210_SS1_EXTERNAL_STOP_NO_RAMP_MONITORING_AND_TIMER_SOURCE_AUDIT_2026-10-26.md), and [SS2E-01](../research/4400_SIEMENS_S210_SS2E_EXTERNAL_DECELERATION_SOS_TORQUE_RETENTION_SOURCE_AUDIT_2026-10-26.md). The exact OEM document is Siemens SINUMERIK MC/S210 Safety Integrated Commissioning Manual 07/2021 A5E47011139B AC, [original PDF](https://cache.industry.siemens.com/dl/files/295/109801295/att_1077953/v1/S210_MC_SI_commiss_man_0721_en-US.pdf).

## Engineering state matrix (do not read as an installed-machine truth table)

| State/function | Who generates deceleration? | What is actually monitored? | Torque / energy after transition | Physical load-side proposition still unproven |
| --- | --- | --- | --- | --- |
| Ordinary LinuxCNC HAL/NC halt | Normal motion controller/drive | Normal diagnostics only unless a separate qualified safety function is installed | Usually remains under ordinary control; variant-specific | Machine-safe stop, personnel exclusion and hydraulic holding |
| Siemens **SS1-t OFF3** | Drive's OFF3 ramp | **OFF3 ramp not monitored** in cited time-controlled variant | **STO after timer**, regardless of actual speed | Coasting, gravity and disconnected load |
| Siemens **SS1E external stop** | Higher-level speed setpoint | No SBR/SAM/standstill monitoring in cited extended external-stop variant | **STO/SBC after timer**, not guaranteed zero speed | Loss/staleness of normal setpoint and load holding |
| Siemens **SS2-r with SBR** | Drive OFF3 ramp | SBR while active, then SOS standstill monitoring in cited configuration | Drive torque **remains available** during SOS | Shaft-to-load coupling, gravity/hydraulics and access |
| Siemens **SS2E external stop** | Higher-level speed setpoint | **No SBR/SAM/standstill during p9553**; SOS monitoring begins after delay | Torque **remains available** in SOS | Stopping before delay, response to failed SOS, load-side holding |
| Siemens **SOS** | Holds commanded motor position in control mode | Motor standstill window, configured | Torque **retained** | Maintenance isolation, mechanical disconnection and independent load restraint |
| Siemens **STO** | Does **not** brake a coasting load | Safe suppression of torque-generating capability | Motor torque removed, **no galvanic isolation** | Shaft still rotating, gravity fall, trapped fluid and electrical LOTO |
| Siemens **SBC** | Safety-controlled motor holding brake, used with STO in examined variant | Brake actuation path; **not mechanical wear/holding capacity** | Brake command, not physical load proof | Actual brake friction, coupling and independent gravity restraint |
| Siemens **SBT** | **Deliberately applies test torque** against engaged brake | Encoder-observed motion against configured tolerance | Energized diagnostic test, not a stop | Load-side holding under all hazards, personnel-safe maintenance |
| Independent physical isolation/LOTO | Qualified service plan, lockable isolators and restraint | Zone-specific energy verification and supports | Selected hazardous energies physically controlled | Must still establish complete electrical/hydraulic/gas/gravity boundary |

**Evidence classifications:** the Siemens function behaviors above are **DOC-CONFIRMED** for the exact 07/2021 family; LinuxCNC normal-control versus independent safety allocation is an **INFERENCE/design boundary** supported by existing curriculum source evidence, not a new SOURCE-CONFIRMED LinuxCNC trace. Selected OpenPressBrake architecture, firmware, hydraulic Y1/Y2, pressure zones, PL/SIL and actual stop/hold are **UNKNOWN**. No TEST-CONFIRMED claim or blind score.

## Five adversarial failures that a green HMI can hide

1. **Detected fault before final safe state:** F01611 appears but p9658 transition has not produced effective STO, or STO can be deselected on second HIGH during the OEM-described window.
2. **Safety timer without deceleration:** SS1E/SS2E is selected, but the normal setpoint generator has frozen; after delay STO or SOS becomes active regardless of whether normal deceleration happened.
3. **Motor standstill with disconnected load:** a motor encoder and SOS status look correct while a belt/coupling/hydraulic load path has failed.
4. **Brake commanded but mechanically incapable:** SBC outputs the safe command, yet a worn brake cannot hold a gravity load. SBT is an energized diagnostic, not permission to test while exposed.
5. **Service access during torque-retaining state:** SOS is active, the motor holds position, and a worker enters; electrical/hydraulic/gravity energy is not independently isolated.

## Minimum viable safe architecture for a resource-constrained builder

- First identify **what can crush, cut, throw, fall or trap a person**, including gravity, pressure and stored energy. Draw the physical load path.
- Use proven independent protective-device/safety-controller/final-element patterns for personnel safety. LinuxCNC and FPGA may request normal motion and display diagnostic state, **not** be the sole authority.
- Require **separate witnesses** for demand received, stop action initiated, final energy path state, actual load stopped/held, personnel excluded, and fresh motion authorized.
- Make safety practical: reachable maintained guards, readable fault explanation, quick but deliberate reset with good visibility, labeled service isolators, and straightforward recovery without bypassing. Fix nuisance-fault causes rather than bridging safety contacts.
- Do not select a PL/SIL, timer, speed, stopping distance, pressure threshold or hydraulic truth table without machine-specific design and evidence.

## Physical release/evaluator status

This matrix is a teaching and design-review artifact. [FDI-01 12-gate selected documentary review](4400_FDI_01_TWELVE_GATE_INPUT_TO_PHYSICAL_STOP_DOCUMENTARY_REVIEW_2026-10-26.md) **NOT RUN**. Public FDI/SS1E/SS2E cases **UNSCORED**. Independent evaluation **NOT RUN**. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** No personnel-exposed operation or fault injection authorized; any qualified experimental testing must be isolated/remote with people outside the danger zone. **0 GitHub-hosted and 0 self-hosted lab minutes.**
