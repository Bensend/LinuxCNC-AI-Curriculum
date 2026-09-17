# PCSS-A modern press-brake safety application — 2026-09-17

## Scope

Apply the curriculum commissioning, common-cause, mode-integrity and feedback-integrity methods to a current professional press-brake safety/control architecture. This is a **reference-architecture application**, not certification of a particular OEM machine. The public PCSS-A manual exposes safeguarding, safety logic interfaces, monitored final-element patterns and mode behavior, but it does **not** expose the complete hydraulic power schematic or the OEM wiring showing exactly what the emergency-stop contactor power poles interrupt. Those physical-energy items remain `UNKNOWN` and are deliberately not inferred.

Primary source: Lazer Safe, *PCSS-A Series Technical Manual*, LS-CS-M-046, Original Language Version 1.25, released 2024-09-12, accessed 2026-09-17: https://support.lazersafe.com/assets/files/Manuals-and-Guides/Registered-users/LS-CS-M-046-PCSS-A-Series-Technical-Manual-1.25.pdf

## Evidence classification

### DOC-CONFIRMED — dual-channel emergency-stop disagreement fails to E-stop

Section 12.1 documents two emergency-stop channels. Closed/closed is normal; open/open is a valid E-stop; either mismatched state is treated as a switch-state fault and causes an emergency-stop condition. This is concrete channel-discrepancy behavior rather than an assumption that two inputs are automatically redundant.

### DOC-CONFIRMED — safety output plus monitored external contactor

Section 12.1.4 shows an auxiliary-axis/emergency-stop contactor driven from a PCSS safety output. A normally closed contact from that contactor returns to a PCSS safety input so the controller can monitor whether contactor changeover occurs correctly and within the required time. Some E-stop options require an error-reset action after the demand is resolved; other documented options can automatically reactivate the output. Therefore restart behavior is **configuration-specific** and must be verified for the actual selected option rather than generalized from the product family.

### DOC-CONFIRMED — valve monitoring can include both Y1/Y2 safety valves

Valve Monitoring Option 32 monitors down/high-speed, MB2, prefill and safety valves, with normally closed monitor contacts for each valve. The documented truth tables distinguish commanded and monitored states and flag switch-on/switch-off disagreement. Option 33 similarly monitors down, prefill and safety valves. The reference therefore demonstrates physical final-element feedback beyond merely observing a CNC command.

### DOC-CONFIRMED — speed monitoring can be independent for Y1 and Y2

The manual describes crawl/pressing/deceleration speed checks independently for Y1 and Y2 when configured, with overspeed conditions causing a PCSS emergency-stop action. Exact applicability and limits depend on guarding/configuration and are not copied into a generic OpenPressBrake requirement.

### DOC-CONFIRMED — special modes require more than a CNC request

Robot mode requires field-muted mode, a physical special-mode-selection input and a CNC/kernel request. A mismatch prevents down movement and produces a condition code. Setup mode likewise requires the physical special-mode-selection input plus the kernel setup request; mismatch prevents down movement. This is strong evidence for the curriculum's MODE INTEGRITY rule: ordinary CNC software alone is not the only mode-selection authority.

### DOC-CONFIRMED — some special modes deliberately remove protections

The manual explicitly states that robot mode can disable guarding and lists monitoring functions that are disabled in that mode, including valve, movement, stopping-performance and speed monitoring unless selectively re-enabled as documented. Setup mode is for commissioning/service and can force field-muted operation while permitting CNC-regulated movement. The manufacturer warns these modes can leave the operator unprotected. Therefore a special/service mode is not intrinsically a safe reduced-risk access mode merely because a safety controller implements it.

## Full-package application

| Requirement | Classification | Evidence / required closure |
|---|---|---|
| Protective demand has independent safety path | CLOSED FROM EVIDENCE at reference-controller level | Dual-channel E-stop disagreement is detected; guarding and door interfaces are safety-controller inputs. |
| Ordinary CNC is not sole personnel-safety authority | CLOSED FROM EVIDENCE at reference-controller level | Special-mode acceptance requires physical selection plus CNC/kernel request; safety controller can prevent down motion on mismatch. |
| External E-stop final element is commanded by safety logic | CLOSED FROM EVIDENCE | PCSS safety output drives external auxiliary-axis/E-stop contactor. |
| External E-stop final element is monitored | CLOSED FROM EVIDENCE | NC auxiliary contact returns to safety input and changeover timing is monitored. |
| Hydraulic final elements can be monitored | CLOSED FROM EVIDENCE for the documented reference options | Options 32/33 monitor commanded-vs-contact states including safety valves on Y1/Y2. |
| Actual OEM valve option and wiring | UNKNOWN | Must be read from machine configuration and released electrical drawings. |
| Actual hydraulic energy path from pump/accumulator through valves to cylinders | UNKNOWN | Requires the OEM hydraulic schematic and component data. Do not infer from PCSS option names. |
| What the E-stop contactor power poles physically interrupt | UNKNOWN | Requires OEM electrical power schematic. A monitored coil/auxiliary contact does not prove which hazardous-energy sources are removed. |
| Gravity/ram retention after hydraulic/electrical stop | UNKNOWN | Requires machine hydraulic/mechanical architecture and validation. |
| Restart after E-stop | CONFIGURATION-SPECIFIC / UNKNOWN for a machine | Manual contains options with different reactivation behavior. Verify selected option, reset device and separate normal START behavior. |
| Power-loss/cold-start behavior | UNKNOWN for a machine | Must be traced through selected PCSS option, OEM power architecture and CNC recovery behavior. |
| Mode integrity | PARTIALLY CLOSED | Physical + software agreement is documented for robot/setup modes; actual selector hardware, wiring, key control and risk-control concept remain OEM-specific. |
| Feedback integrity / CCF | PARTIALLY CLOSED | Separate monitored contacts are shown, but cable routing, shared supplies/returns/connectors and hydraulic common causes are machine-specific. |
| Stopping performance | UNKNOWN for a machine | Product family supports monitoring, but machine-specific stopping requirements and validation results are not public evidence for a target machine. |
| PL/SIL/diagnostic coverage | UNKNOWN for a machine | Never infer achieved machine-level performance from controller/product-family documentation alone. |

## Common-cause / latent-failure review

1. **Selector common cause:** physical special-mode selection plus CNC/kernel request is better than a CNC-only mode bit, but a complete machine review must still inspect shared supply, connector, wiring and configuration paths that could make both indications agree falsely.
2. **EDM common cause:** a monitored NC contact proves a relationship between command and auxiliary feedback; it does not prove the contactor power poles interrupt the intended energy path. The OEM power drawing remains mandatory.
3. **Valve-feedback common cause:** multiple valve monitor contacts improve observability, but shared 24-V supply/return, harness/connector faults, contamination and hydraulic manifold common causes remain outside the controller manual.
4. **Special-mode latent hazard:** robot/setup modes can intentionally disable protections. Commissioning must prove that mode entry is deliberate, conspicuous, bounded, and cannot remain silently active for ordinary exposed production.
5. **Configuration common cause:** selecting the wrong E-stop/down-enable/valve-monitoring option can alter multiple safety behaviors simultaneously. Released configuration identity is therefore part of the safety evidence, not merely software housekeeping.

## Minimum-safe-to-operate result

**REFERENCE ARCHITECTURE: PARTIALLY CLOSED. SPECIFIC MACHINE: NOT CLEARED FROM THIS EVIDENCE.**

The reference architecture demonstrates professional patterns worth teaching: independent safety logic, dual-channel discrepancy detection, monitored external contactor, monitored hydraulic final elements, physical-plus-software special-mode agreement and controller-level movement inhibition. It does **not** close the actual machine hazardous-energy boundary. A specific machine remains `NOT CLEARED` until its electrical/hydraulic drawings, selected PCSS configuration, physical final elements, gravity/stored-energy behavior, restart behavior and measured/required stopping performance are established and validated.

## OpenPressBrake transfer

- LinuxCNC may request modes and display status; it must not be sole safety-mode authority where mode changes personnel protection.
- A safety MCU/PLC output is not enough. Monitor the physical final element where the safety architecture requires it, then separately trace what hazardous energy that element actually controls.
- If a future OpenPressBrake setup mode weakens normal guarding, its access conditions and compensating safety measures must be engineered explicitly. Do not copy PCSS setup/robot behavior without the complete machine safety concept.
- Keep normal FPGA watchdog/current-loop trips as fault containment, separate from personnel-safety authority.

## Compute decision

No compute used. The unresolved items are machine drawing/configuration/physical-validation questions; simulation would not close them.
