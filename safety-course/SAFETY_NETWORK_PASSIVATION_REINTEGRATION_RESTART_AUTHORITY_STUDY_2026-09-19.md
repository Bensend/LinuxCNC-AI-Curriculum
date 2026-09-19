# Safety-Network Passivation, Reintegration, and Restart Authority Study — 2026-09-19

## Purpose and lane separation

This Lane-B study is intentionally independent of the primary lane's current press-brake hydraulic valve-fault / stopping-performance re-proof work. It does not modify hydraulic artifacts or claim anything about OpenPressBrake valve truth tables, pressures, stopping distances, or retaining behavior.

The question is narrower and reusable: when a safety network or remote fail-safe I/O connection fails and later returns, what exactly has been proved, what remains unproved, and which layer owns restoration of hazardous-motion authority?

## Evidence provenance

### Siemens SIMATIC Safety / PROFIsafe

**SOURCE-CONFIRMED / DOC-CONFIRMED.** Siemens, *S7-1200 Functional Safety Manual*, V4.6 (11/2022), states that PROFIsafe communication errors are detected safety faults. If a valid, current safety message frame with a valid monitoring number is not received within the configured F-monitoring time, the fail-safe system passivates the F-I/O; the affected fail-safe inputs/outputs use safe/substitute values. After successful diagnostics show the fault has cleared, reintegration returns process data. Reintegration may be automatic or may require acknowledgement by the safety program.

Source: https://support.industry.siemens.com/cs/attachments/104547552/s71200_f_user_manual_en-US_en-US.pdf

Siemens' current passivation/reintegration application example likewise describes communication faults, F-I/O/channel faults, and startup as causes of passivation/substitute values.

Source: https://support.industry.siemens.com/cs/attachments/22304119/22304119_Passivation_Reintegration_1200F_1500F_ET200SP_V2_1_en.pdf

This supports:

`valid/current safety telegram absent -> safety communication fault -> F-I/O passivated -> substitute/safe values`

and separately:

`fault cleared + diagnostics successful -> reintegration permitted according to validated safety application (automatic or acknowledged)`.

It does **not** support treating ordinary Ethernet link-up, ping, fieldbus RUN, or LinuxCNC connectivity as safety reintegration proof.

### Rockwell CIP Safety / GuardLogix

**SOURCE-CONFIRMED / DOC-CONFIRMED.** Current ControlLogix 5590 safety documentation says that when a safety input connection fails, input data is placed in the safe state and status is faulted; when a safety output connection fails, the output device de-energizes its outputs. Rockwell explicitly places responsibility on the application to latch I/O failures and verify proper restart.

Source: https://www.rockwellautomation.com/en-us/docs/technical/logix5000/_online/1756-um900/controllogix-5590-controller-user-manual-ditamap/monitor-safety-status-and-handle-faults/monitor-system-status.html

Rockwell's GuardPLC safety reference gives an especially useful recovery rule: safety network connections can recover automatically, so the application should keep safety outputs in their safe state after a connection fault/idle condition until a manual reset, preventing an unexpected OFF-to-ON output transition merely because communication recovered.

Source: https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/1753-rm002_-en-p.pdf

Current GuardLogix documentation also distinguishes `ConnectionFaulted` from `RunMode`; faulted safety data is reset to zero and RunMode becomes idle. This is safety-connection state, not physical-hazard proof.

Source: https://www.rockwellautomation.com/en-ca/docs/technical/logix5000/_online/1756-rm012/guardlogix-5580-and-compact-guardlogix-5580-safety/monitor-safety-status-and-handle-faults/monitor-guardlogix-safety-status.html

## Architecture freeze

Teach the following distinctions explicitly:

**ETHERNET LINK UP != SAFETY CONNECTION VALID != CURRENT SAFETY DATA VALID != F-I/O REINTEGRATED != SAFETY FUNCTION REARMED != FINAL ELEMENT PROVED != PHYSICAL HAZARD SAFE != ORDINARY MOTION AUTHORIZED.**

**COMMUNICATION RECOVERED != FAULT ACKNOWLEDGED/RESET != PRODUCTION RESTART AUTHORITY.**

**PASSIVATION IS A SAFETY REACTION, NOT PROOF THAT EVERY PHYSICAL HAZARD HAS REACHED A SAFE CONDITION.** A networked output being commanded/de-energized safe is still upstream of contactor state, drive torque state, valve position, ram/load disposition, pressure, gravity restraint, and other machine-specific physical witnesses.

## LinuxCNC / FPGA boundary

**INFERENCE, bounded by the manufacturer evidence above.** Ordinary LinuxCNC, HAL, a normal Ethernet stack, and the non-safety FPGA may expose diagnostics such as link state, remote-I/O health, machine mode, and process readiness. They must not be allowed to convert `communications restored` into personnel-safety authority when the safety architecture relies on a safety protocol's validity, passivation/reintegration state, reset policy, and final-element response.

A particularly dangerous integration is:

`network reconnect -> ordinary READY becomes true -> stale START/JOG/CYCLE remains asserted -> hazardous motion resumes`.

The curriculum should instead force the learner to trace safety communication recovery and ordinary process-command recovery as separate state machines.

## Failure-path / commissioning worksheet

For each real implementation, trace and record evidence class for all of these cases:

1. Break only the safety-network path while ordinary Ethernet remains physically linked. Verify the safety-side reaction; do not accept ping/link LEDs as proof.
2. Restore the cable/switch path. Determine whether safety connection validity and fresh/current safety data return automatically, and whether the application intentionally remains inhibited.
3. Force a safety telegram freshness/sequence/monitoring failure where the platform permits a documented test. Verify passivation/substitute-value behavior.
4. Recover communication while an ordinary START/JOG/CYCLE request remains asserted. Verify that recovery semantics cannot accidentally manufacture fresh process intent where the machine requires a fresh command.
5. Recover communication while the external final element is failed or feedback disagrees. Verify that network recovery does not erase EDM/drive/valve/final-element diagnostics.
6. Power-cycle the remote safety I/O while the controller remains powered; separately power-cycle the controller while the remote I/O remains powered. Record identity/configuration/reintegration behavior rather than assuming symmetry.
7. Test automatic versus acknowledged reintegration only as documented for the actual safety application. Do not universalize a manual-reset rule where the validated design permits automatic reintegration.
8. If the safety network returns but a person may remain in an accessible hazard area, retain the separate personnel-clear/restart-prevention function.
9. Confirm that HMI diagnostics distinguish at least: ordinary network reachable, safety connection valid/faulted, safety data current/passivated, reintegration/rearm state, and machine-level production authority.
10. After any safety-network/configuration/device replacement, follow the separate identity/configuration/recommissioning study rather than treating successful reconnection as validation.

## Evidence labels and unresolved items

- **SOURCE-CONFIRMED / DOC-CONFIRMED:** Siemens PROFIsafe monitoring-number/freshness failure can passivate F-I/O to safe/substitute values; reintegration may be automatic or acknowledgement-driven according to the safety application.
- **SOURCE-CONFIRMED / DOC-CONFIRMED:** Rockwell safety connection faults drive safety data/output behavior toward the safe state and require application-level restart handling; older GuardPLC guidance explicitly warns against automatic recovered connections causing unsafe OFF-to-ON transitions.
- **INFERENCE:** LinuxCNC/ordinary FPGA diagnostics must remain informational/permissive consumers rather than sole safety-network reintegration authority.
- **UNKNOWN:** OpenPressBrake's eventual safety protocol, F-I/O family, monitoring times, reintegration policy, reset policy, final-element topology, and physical safe-state witnesses.
- **UNKNOWN:** Any OpenPressBrake-specific rule requiring manual versus automatic safety-network reintegration. This must come from the validated safety architecture and risk analysis.
- **TEST-CONFIRMED:** none in this study; no executable test was justified without a selected real safety-network implementation.
- **COMMUNITY-REPORTED:** none relied upon.

## Local-compute decision

No simulation, synthesis, benchmarking, or executable verification is justified for this source-tracing step. No GitHub-hosted compute was used. A later implementation lab, if justified, must run only on `[self-hosted, openpressbrake]` and should answer a concrete question such as whether a real selected safety I/O path remains passivated/restart-inhibited through a reproducible connection-loss/recovery sequence.

## Precise next-work checkpoint

Find a professional implementation that exposes the complete chain:

`safety-network communication healthy -> protective function active -> deliberate safety communication interruption -> passivation/safe values -> physical final element reaches expected safe state -> safety connection recovers -> stale ordinary motion request remains inhibited -> documented reintegration/reset policy executes -> final-element/physical-state feedback is valid -> separate machine-specific process restart authority`.

Prefer an implementation with a CIP Safety drive/STO or PROFIsafe drive/remote-I/O device because it can expose both protocol recovery and a physical actuator-side safety state. Preserve manufacturer-specific automatic/manual reintegration semantics; do not force a universal reset rule.