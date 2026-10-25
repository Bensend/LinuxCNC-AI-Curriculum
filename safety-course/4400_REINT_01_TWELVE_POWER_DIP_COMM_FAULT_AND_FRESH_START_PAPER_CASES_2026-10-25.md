# 4400-REINT-01 — Twelve power-dip, communication-fault and restart cases
**2026-10-25 | PAPER ONLY / UNSCORED / no machine experiment.** Use [original Siemens V20/V21 source audit](../research/4400_SIEMENS_V20_FIO_SHORT_POWER_LOSS_AUTO_REINTEGRATION_VS_COMM_FAULT_ACK_AUDIT_2026-10-25.md) and [CONFIG-01 boundary](4400_CONFIG_01_SIGNATURE_SCOPE_CHANGE_CONTROL_AND_FRESH_REARM_MODULE_2026-10-25.md). For each case identify fault class, OEM behavior, physical unknown, and whether a *new* motion command is separately required.

| # | Scenario | Question |
|---|---|---|
| 01 | Siemens F-I/O loses supply for less than configured F-monitoring time, ACK_NEC=1. | Can it reintegrate without new ACK_REI? |
| 02 | Supply interruption exceeds F-monitoring time and communication error detected. | Which passivation/acknowledgment route applies? |
| 03 | Channel fault clears with ACK_NEC=0. | Is automatic reintegration possible, and is that permission to stroke? |
| 04 | Channel fault clears with ACK_NEC=1 and ACK_REQ=0. | Is an acknowledgment edge alone sufficient under the described ordinary path? |
| 05 | Channel fault clears with ACK_NEC=1 and ACK_REQ=1. | Which edge and which control level are involved? |
| 06 | Module supports channel-granular passivation. | May healthy channels remain active while one channel faults? |
| 07 | Output process image shows fail-safe 0, but valve spool is contaminated. | What independent physical proof remains? |
| 08 | Safety network reconnects, ordinary LinuxCNC retained last motion command. | What prevents automatic stroke on reconnection? |
| 09 | F-I/O supply flickers during maintenance with helper inside enclosure. | What occupancy/LOTO/hold boundary must persist? |
| 10 | HMI labels ACK_REI “Start.” | Why is this a dangerous human-factor design? |
| 11 | Team copies Siemens V20 short-dip behavior to unrelated Rockwell controller. | What provenance and revision check is missing? |
| 12 | Technician proposes a bench short-dip test without physical hydraulic restraints. | Why must this be rejected and what evidence comes first? |

**Unscored reasoning rubric (not hidden answers):** Distinguish detected communication faults from short supply dip S012; distinguish module reintegration from personnel-safety physical state and deliberate fresh ordinary motion; never assert a measured F-monitoring time or hydraulic response; keep all selected-machine gates HOLD. Twelve scenarios are not external blind evaluation. No controller output or physical test has been performed.
