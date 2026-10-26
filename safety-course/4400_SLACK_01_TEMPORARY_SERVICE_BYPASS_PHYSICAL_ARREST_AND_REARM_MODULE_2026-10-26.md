# 4400-SLACK-01 — When a safety sensor prevents recovery, do not normalize bypass

**4000 practical safety curriculum | 2026-10-26 | PAPER ONLY / NON-GRADUATED.** Read [original Autoquip FLM/FLMC Rev.1 and FL4M v3.4 source audit](../research/4400_AUTOQUIP_SLACK_CHAIN_TEMPORARY_BYPASS_AND_FL4M_MECHANICAL_CAM_SOURCE_AUDIT_2026-10-26.md). Different OEM product families are deliberately kept separate.

## Learning objective
Explain why a properly tripped slack-chain sensor may inhibit the motor action needed to restore normal chain tension; why a manufacturer-described **temporary service exception** is not permission for unattended bypass; and why independent **mechanical load arrest**, guarding, maintenance isolation and deliberate restart must remain separate.

## Source-grounded mechanism
Autoquip's **FLM/FLMC Rev.1** service instructions describe a temporary qualified-electrician bypass for a specific commissioning/recovery deadlock, followed by explicit removal. Autoquip's **different FL4M v3.4** manual describes physical serrated locking cams, electrical slack-chain sensors, counterweight switches and guards as distinct safety layers. Do not assume FLM/FLMC has FL4M cams or that any device is installed on OpenPressBrake.

## Five independent questions before restoring operation
1. **What failed?** Chain tension, jam, sensor adjustment, mechanical load support, or structural cam/guide damage?
2. **What physical load remains suspended?** A normal sensor input does not establish that a carriage/ram/tool is mechanically held.
3. **Who can authorize the exception?** Qualified service with OEM-approved method and independent safeguards, not LinuxCNC/FPGA/HMI convenience.
4. **How is the temporary exception made unmistakable and short-lived?** Conspicuous status, restricted access, clear return-to-normal check and independent verification. An invisible forgotten jumper is a dangerous process defect.
5. **What restores normal operation?** Physical inspection, all guards/interlocks/sensors restored, personnel outside hazard zone, documented reset then **fresh deliberate start**. Restoring a sensor is not motion authorization.

## Adversarial paper exercises — unscored
- A slack-chain input is open and prevents motor motion needed for recovery. Explain why simply bridging it for ordinary use is unacceptable.
- A technician sees both inputs return to normal after recovery but does not check the panel. What hidden bypass might remain?
- A service technician has an OEM procedure for FLM/FLMC. Why must the FL4M cam specification not be assumed present?
- A carriage sensor works, but the cam reinforcement bar is missing. Which safety function is still unproven?
- A cam has arrested a loaded carriage repeatedly. Why is its condition and OEM replacement policy important?
- An operator uses the motor contactor manually to move a jammed load. Which boundaries could be bypassed?
- A machine has no counterweight but has a vertical hydraulic ram. Which conditional evidence is N/A, and which essential hydraulic safety remains open?
- A service mode permits low-speed motion but the operator stands beneath the load. Why does reduced speed not solve the falling-load hazard?

## Low-friction design pattern
Use physically captive supports and guards, safe access to service controls, a clearly visible temporary-recovery state, a short reviewer-verified return-to-normal process, and independent load restraint. Design out a workflow that *requires* defeating a safeguard merely to finish ordinary maintenance. Never rely on normal LinuxCNC/FPGA software as sole personnel-safety authority. No live bypass, jam, drop or motor test is authorized by this module.

## Evidence and completion
**DOC-CONFIRMED:** exact OEM statements, including the unusual temporary-jumper instruction. **INFERENCE:** safer human-factor workflow and residual risk. **SOURCE-CONFIRMED new LinuxCNC none; TEST-CONFIRMED none; COMMUNITY-REPORTED none.** Exact selected equipment, PL/SIL, mechanical holding, physical validation and independent evaluator **UNKNOWN/NOT RUN**. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.
