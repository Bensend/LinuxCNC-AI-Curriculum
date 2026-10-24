# 4400 — Safety-network timeout, fault acknowledgment and misleading SIL UI: CIP Safety versus FSoE

**Status:** two original manufacturer manuals inspected on 2026-10-24; **DOC-CONFIRMED** for the specific product/version statements below, **INFERENCE** for architecture transfer, **UNKNOWN** for OpenPressBrake. No network-fault injection, simulation, live motion or `TEST-CONFIRMED` safety behavior.

## New question

A CNC retrofit keeps a safety controller but changes switches, Ethernet topology or ordinary PLC/FPGA networking. If an operator sees a green `CONNECTED` bit or changes a watchdog to suppress nuisance trips, what does that establish about a **safety-related** connection, its safe output, deliberate rearm and the actual stopped/held machine?

**Answer from OEM documents:** safety connections have *their own* packet-age/watchdog, identity, fault and acknowledgment semantics. A healthy ordinary network or displayed safety rating is not sufficient evidence. A connection entering the manufacturer's electrical safe state (OFF) is not a physical gravity/hydraulic load-holding witness.

## Original manufacturer sources

1. **Rockwell Automation**, *Logix SIS — GuardLogix 5580 Controllers Safety Reference Manual*, **1756-RM015C-EN-P, December 2025**, Appendix B printed pp.91–97 and Ch.2 printed pp.16–18. Original PDF: https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/1756-rm015_-en-p.pdf . This is **Logix SIS**, not every GuardLogix or generic CIP Safety device.
2. **Beckhoff**, *TwinSAFE Logic FB — TwinCAT function blocks for TwinSAFE logic components*, **Version 4.3.0, 2025-12-03**, §3.1.2 and §3.2 printed pp.21–23. Original PDF: https://download.beckhoff.com/download/Document/automation/twinsafe/twinsafe-logic-fb_en.pdf . Describes TwinSAFE/FSoE configuration, not every EtherCAT drive's physical stopping.
3. **Rockwell**, *GuardLogix Controller Systems Safety Reference Manual* **1756-RM093J-EN-P, April 2018**, Appendix C printed pp.85 onward, historical corroboration of safety connection reaction-time parameters. https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/1756-rm093_-en-p.pdf . Different product generation; **do not merge** its numeric timing with the 2025 Logix SIS model.

## Rockwell CRTL: exact narrow manufacturer claims

- **DOC-CONFIRMED:** The **Connection Reaction Time Limit (CRTL)** is the maximum age of safety packets consumed on the associated connection. If exceeded, a connection fault occurs and input/output data go to the **safe state OFF** (1756-RM015C Appendix B p.91). This is a *communication/data-output* state, not a physical stop/hold proof.
- The original manual's default example: **input RPI 10 ms**, **timeout multiplier 2**, **network delay multiplier 200%**, yielding **input CRTL 40 ms**. Rockwell warns that some installations may need larger values to avoid connection loss and that the changed CRTL **must** be included in the system reaction-time calculation.
- In this exact Logix SIS edition: `Input CRTL = input RPI × [timeout multiplier + network delay multiplier]`; `Output CRTL = safety task period × [timeout multiplier + network delay multiplier − 1]` (Appendix B pp.91–92). These equations are **manufacturer product-specific**, not universal formulas for any safety bus.
- The same appendix defines the safety task reaction time as `(safety task period + safety task watchdog) × 1.01` for its own controller. The total system path also includes sensor, input and output connection delays, logic, output device and **actuator** reaction. A 40 ms connection value is not a complete stop time.
- **Important edition-specific nuance:** Logix SIS high-demand system reaction time must include certain safety-function muting times for loss of redundancy/qualification/lock for update (Ch.2 pp.16–18). Do not transfer this redundant Logix SIS feature to a generic standalone safety PLC.

## Beckhoff FSoE: identity, watchdog and two distinct acknowledgments

- **DOC-CONFIRMED §3.1.2 p.21:** Each TwinSAFE connection has an FSoE address and watchdog. FSoE addresses must be unique within the control system. Beckhoff states the verifier for each logic terminal checks only that terminal; **with several TwinSAFE logic terminals, the user must ensure there are no duplicate addresses across them**.
- **DOC-CONFIRMED §3.1.2 p.21:** For EL6910/EJ6910, a connection may have `ComErrAck`; when configured, the connection requires this acknowledgment **in addition to** the TwinSAFE group's `ErrAck` after communication error. Clearing an HMI error, resetting a group, or recovering network traffic alone does not establish that all required acknowledgment conditions are satisfied.
- **DOC-CONFIRMED §3.1.2 p.21:** The TwinCAT 2 configuration interface offers a **SIL level** selection, but Beckhoff explicitly says this setting is unsupported at that time and has **no effect on system safety behavior**. A displayed SIL choice is **not** a verified safety capability.
- **DOC-CONFIRMED §3.2 pp.21–23:** Connection/group diagnostics can be mapped into cyclic process data; group states include RUN, STOP, SAFE, ERROR and RESET. These are **diagnostic states** with defined local meanings, not machine-level proof that an actual press-brake ram is held, rear zone empty or maintenance energy isolated.

## A cross-family comparison — do not pretend the two are interchangeable

| Question | Rockwell Logix SIS (CIP Safety) | Beckhoff TwinSAFE (FSoE) | Generic safety lesson |
|---|---|---|---|
| How is loss of safety data detected? | Packet age exceeds configured **CRTL** | Per-connection **watchdog** and FSoE identity/error mechanisms | Ordinary TCP/UDP link-up does not substitute for a qualified safety connection |
| What happens to safety data on timeout? | Manual explicitly states safety input/output data set **OFF** | Exact selected TwinSAFE logic/terminal/drive reaction requires device and project review; this source identifies error/ack architecture | Do not assume a universal physical final-element action |
| How does recovery work? | Review actual safety connection, task and reset/start requirements | May need `ComErrAck` **and** group `ErrAck` | Error acknowledgment ≠ fresh hazardous-motion start |
| What changes timing? | RPI, timeout multiplier, network delay, task period/watchdog, sensor/actuator | Watchdog, device configuration and specific logic | A nuisance-trip 'fix' can invalidate stopping-time assumptions |
| What can be trusted on HMI? | Correctly identified connection status/diagnostics in scope | Correctly identified group/connection state in scope | HMI is not the physical safe-state witness |

## Failure-path matrix for a retrofit (INFERENCE)

1. **Network congestion → nuisance trips → increase CRTL:** output may remain electrically enabled longer before a communication fault is declared. The OEM requires new system reaction-time calculation; actual protective distance and physical stop remain **UNKNOWN**. No generic 40 ms acceptance criterion.
2. **Network reconnected → ordinary LinuxCNC `READY`:** neither a recovered CIP/FSoE connection nor HMI bit proves the safety chain is independently armed or that queued CNC motion has been invalidated. Deliberate safety reset and separate new start are required where the selected SRS calls for them.
3. **Two TwinSAFE groups / terminals reuse an FSoE address:** per-terminal verifier may not detect the system-wide duplicate; actual address inventory and independent project validation needed.
4. **FSoE group `ErrAck` asserted but `ComErrAck` omitted:** the affected configured connection may remain in communication error; do not bypass the condition by making ordinary PLC status authoritative.
5. **Operator selects 'SIL 3' in an unsupported UI field:** Beckhoff explicitly says the TwinCAT 2 SIL setting in this source does not affect safety behavior. A label cannot substitute for hardware architecture, validation or PFHd/PL evidence.
6. **Safety network goes OFF but ram drifts:** electrical safe state and physical gravity load holding are separate propositions; machine G3 remains HOLD until qualified physical proof.

## Practical low-friction architecture

- Maintain a **safety-network connection contract**: exact safety controller/firmware/project, module address, safety-network identity, RPI/watchdog/CRTL, connection ownership, reset/ack source, safe output, physical final element and independent witness.
- Keep a clear, read-only ordinary LinuxCNC/HMI diagnostic view with **connection freshness, revision and fault/ack pending**. Do not provide a generic HMI `ACK ALL AND START` button.
- When a network nuisance trip occurs, investigate EMI, cable, load, grounding, switches and actual timing first. If an OEM-permitted timeout change is justified, mark affected `CHG/SRS/DEP/VAL/PT` stale until revalidated; do not simply widen the window.
- Put device addresses and connection identifiers in a version-controlled, serviceable diagram. Make correct replacement/reinstallation easier than bypass; avoid duplicated address/hidden jumper defaults.
- A safety fieldbus is not maintenance LOTO. Lockable energy isolation, stored pressure, gravity restraint and independent physical witnesses remain separate.

## Evidence disposition

**DOC-CONFIRMED**: exact manufacturer statements for Logix SIS 2025 and TwinSAFE Logic FB 2025; 2018 Rockwell edition corroboration only. **SOURCE-CONFIRMED**: no new LinuxCNC source trace; earlier pinned LinuxCNC normal NML/hm2_eth status remains ordinary control. **TEST-CONFIRMED** none; **COMMUNITY-REPORTED** none relied upon. **INFERENCE** transfer and practical design. **UNKNOWN** selected OpenPressBrake safety-network existence, identity, firmware, watchdog, network wiring, final element, physical stop/hold, reset, PL/SIL and stopping distance.

**Selected conditional intake `IN-04m`:** only if safety-network communication is actually present. `VAL/PT NOT RUN`, `G0/G1 HOLD`, `G3/G4 NOT AUTHORIZED`. Do not perform live network interruption with people exposed; isolated/remote qualified testing requires a separate approved physical test plan.
