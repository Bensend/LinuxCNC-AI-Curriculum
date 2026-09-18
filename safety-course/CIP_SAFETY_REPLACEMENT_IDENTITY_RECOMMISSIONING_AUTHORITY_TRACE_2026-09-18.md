# CIP Safety Replacement, Identity, Recommissioning, and Authority Trace

Date: 2026-09-18

## Purpose

Extend the black-channel study into a concrete professional service/replacement path. This card uses Rockwell GuardLogix/CIP Safety documentation because it exposes the safety endpoint identity, configuration ownership, replacement procedure, safe communication reaction, and post-replacement functional-test boundary. It is an implementation example, not an OpenPressBrake protocol selection.

## Evidence labels

- **SOURCE-CONFIRMED** — directly stated by Rockwell manufacturer documentation.
- **DOC-CONFIRMED** — repository-controlled documentation.
- **TEST-CONFIRMED** — controlled execution evidence.
- **COMMUNITY-REPORTED** — practitioner report not independently established here.
- **INFERENCE** — engineering conclusion from confirmed evidence.
- **UNKNOWN** — not established and must not be invented.

## Freeze

**IP/NODE ADDRESS CORRECT != CIP SAFETY DEVICE IDENTITY CORRECT != CONFIGURATION OWNERSHIP CORRECT != SAFETY CONFIGURATION VERIFIED != SAFETY CONNECTION RESTORED != FUNCTIONAL SAFETY REVALIDATED != HAZARDOUS-MOTION AUTHORITY != FRESH ORDINARY START.**

**REPLACEMENT DEVICE COMMUNICATING != REPLACEMENT DEVICE AUTHORIZED FOR PRODUCTION.**

## Concrete Rockwell trace

### 1. Black-channel transport and endpoint identity

**SOURCE-CONFIRMED.** CIP Safety is end-node to end-node and can route through ordinary bridges, switches and routers. A Safety Network Number (SNN) plus node address forms the unique node reference used to identify a safety port. Rockwell explicitly warns that copied projects within the same routable CIP Safety system require SNN handling and that duplicate SNN/node-reference combinations must be prevented.

**INFERENCE.** A replacement that responds at the expected IP address has established ordinary reachability only. It has not yet proved the intended safety identity or configuration.

### 2. Ownership and configuration are separate evidence

**SOURCE-CONFIRMED.** One controller owns each safety I/O device configuration. Rockwell describes ownership using the safety module number/network number, controller node/slot and SNN, path, and configuration signature. If these differ, the owner-controller safety connection is lost. Rockwell states that a configuration signature is only considered verified after user testing.

**INFERENCE.** `device online`, `owner local`, and `configuration signature present` are not interchangeable claims. A commissioning record must distinguish them.

### 3. Communication loss has a defined safety-I/O state

**SOURCE-CONFIRMED.** Rockwell's current safety-I/O guidance says safety outputs use OFF as the safe state and safety input data presented to the controller use OFF as the safe state. It warns that if an application inhibits a safety module from transitioning to safe state on I/O-connection loss, responsibility shifts to the application to maintain the safe state by other means.

**BOUNDARY.** This is Rockwell safety-I/O behavior, not a universal hydraulic/mechanical safe-state definition. OFF cannot be promoted into 'press beam physically retained' or 'all hazardous energy absent'.

### 4. Replacement with a mismatched SNN is a deliberate recommissioning action

**SOURCE-CONFIRMED.** When a replacement safety device has a different SNN and a safety signature exists, Rockwell requires reset of ownership, manual setting of the SNN, and verification that the Network Status indication is alternating red/green on the *correct physical device* before accepting the SNN. The procedure then requires the organization's prescribed functional test of the replacement device and system before authorizing use.

**SOURCE-CONFIRMED.** A previously used Guard I/O device must be reset to out-of-box condition before installation on another safety network. Ownership reset can be restricted by pending edits, safety locking, or a safety signature.

**INFERENCE.** Correct replacement identity is intentionally made a physical commissioning act. A project download or ordinary network discovery is not sufficient.

### 5. Automatic replacement is conditional, not a blanket shortcut

**SOURCE-CONFIRMED.** Rockwell's `Always Allow Automatic Configuration` option is permitted only when the entire routable CIP Safety control system is not being relied upon to maintain SIL behavior during replacement and functional testing. Rockwell gives energy isolation or other application-specific safeguards as examples of how the system may be made safe during that service condition.

**INFERENCE.** Replacement convenience must not erase the service hazard boundary. If a safety function is temporarily unavailable or being recommissioned, some independent means must carry the relevant hazard-control obligation where personnel could otherwise be exposed.

## End-to-end authority chain

A professional commissioning record should be able to show each transition independently:

1. ordinary network path available;
2. intended physical replacement installed;
3. correct node/IP address established;
4. correct SNN/unique safety identity established;
5. correct controller owns the device;
6. intended configuration/signature established;
7. safety connection valid;
8. required safety I/O safe/expected state physically checked;
9. replacement device and affected safety function functionally tested;
10. affected safety system authorized for use;
11. safety reset/rearm performed if required by the application;
12. separate ordinary machine START/motion command freshly issued.

No earlier state should be collapsed into a later authority claim.

## Adversarial commissioning challenges

| Injection | Dangerous shortcut | Required evidence/question |
|---|---|---|
| correct IP, wrong SNN | `it is online, so use it` | safety identity must match commissioned system |
| correct SNN, wrong physical device selected | accept configuration remotely | verify action occurs on intended physical device |
| previously owned replacement | assume configuration download overwrites safely | establish/reset ownership per procedure |
| copied project/machine | reuse generated identity blindly | prove unique SNN/node references in routable system |
| connection recovers after switch/cable fault | resume motion immediately | distinguish connection recovery, safety rearm and fresh ordinary START |
| replacement auto-configures | skip functional test | functional test and authorization remain required |
| safety I/O output OFF | declare press mechanically safe | prove application-specific physical hazard state separately |
| safety I/O inhibited during service | assume controller still protects personnel | identify independent means maintaining safe state |
| LinuxCNC START remains TRUE during replacement | allow motion when safety authority returns | require stale ordinary command rejection / fresh intent |
| HMI says Safety OK | accept HMI bit as proof | trace bit to validated safety endpoint/configuration and physical final element |

## OpenPressBrake separation

**INFERENCE.** If OpenPressBrake later uses a networked certified safety architecture, ordinary LinuxCNC and the normal FPGA may display identity/connection diagnostics and consume permissive status. They must not create or bypass safety identity, silently accept a replacement endpoint, or turn safety-connection restoration into hazardous-motion authority.

**UNKNOWN:** OpenPressBrake safety protocol, safety PLC/I/O models, SNN/addressing equivalent, safe substitute values, network topology, reset policy, test procedure, PL/SIL/category/DC/CCF, and any press-specific physical safe state.

## Human-factors lesson

A safe replacement workflow should make the intended physical device obvious and the verified commissioning path easier than bypassing it. Clear physical labels tying device location to safety identity, an explicit replacement checklist, and a visible `FUNCTIONAL TEST REQUIRED / NOT AUTHORIZED FOR PRODUCTION` state reduce the temptation to treat `network online` as completion.

If the safety function required to protect exposed personnel is unavailable during replacement, the machine must not be operated with people exposed to that hazard. Service/testing must use appropriate isolation, blocking/restraint, or other application-specific safeguards; experimental operation, where unavoidable, must keep people outside the danger zone and state residual risk plainly.

## No-compute decision

No executable test is justified. This question is resolved by authoritative commissioning/identity documentation. No GitHub-hosted or self-hosted compute was consumed.

## Sources

- Rockwell Automation, Safety Network Number: https://www.rockwellautomation.com/en-us/docs/technical/logix5000/_online/1756-um543/controllogix-5580-and-guardlogix-5580-controllers-/guardlogix-functional-safety/safety-network-number.html
- Rockwell Automation, Connect to Safety I/O: https://www.rockwellautomation.com/en-fi/docs/technical/logix5000/_online/1756-um900/controllogix-5590-controller-user-manual-ditamap/manage-controller-i-o-connections/connect-to-safety-i-o.html
- Rockwell Automation, Scenario 2 — replacement SNN differs and safety signature exists: https://www.rockwellautomation.com/en-us/docs/technical/logix5000/_online/1756-um543/controllogix-5580-and-guardlogix-5580-controllers-/safety-i-o-devices/safety-i-o-replacement-options/scenario-2---replacement-device-snn-is-different-f.html
- Rockwell Automation, Reset Safety I/O Devices to Out-of-box Condition: https://www.rockwellautomation.com/en-us/docs/technical/logix5000/_online/1756-um543/controllogix-5580-and-guardlogix-5580-controllers-/safety-i-o-devices/safety-i-o-device-signature/reset-safety-i-o-devices-to-the-out-of-box-conditi.html
- Rockwell Automation, Always Allow Automatic Configuration: https://www.rockwellautomation.com/en-us/docs/technical/logix5000/_online/1756-um543/controllogix-5580-and-guardlogix-5580-controllers-/safety-i-o-devices/safety-i-o-replacement-options/always-allow-automatic-configuration.html

## Next evidence target

Find an authoritative implementation that continues beyond safety-network recommissioning into the actual final element and machine restart sequence:

`replacement/communication fault -> safety output safe reaction -> physical final-element witness -> identity/configuration recommission -> functional test -> safety rearm -> separate ordinary START`.

Prefer a drive/STO, safety contactor, or guard-locking example where the final element and restart interlock are visible. Do not infer an OpenPressBrake hydraulic safe state from generic network behavior.
