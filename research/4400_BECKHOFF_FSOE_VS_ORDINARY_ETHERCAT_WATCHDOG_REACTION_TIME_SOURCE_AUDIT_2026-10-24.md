# 4400-NET-01 source audit — Safety-over-EtherCAT versus ordinary EtherCAT watchdogs and end-to-end stop latency
**Date:** 2026-10-24. **Status:** documentary investigation, NON-GRADUATED; no selected-machine or laboratory verification. **Scope:** Beckhoff documented product/revision and PROFIBUS & PROFINET International (PI) public technology description, not an assertion that OpenPressBrake uses EtherCAT/TwinSAFE/PROFIsafe.

## Evidence reviewed and precise provenance
1. **Beckhoff, TwinCAT Safety PLC documentation, version 1.2.0, 2017-06-29, original 115-page manufacturer PDF**, pp. 26–27 (connection parameters), pp. 45–47 (group/connection states and diagnostics): https://download.beckhoff.com/download/document/automation/twinsafe/TcSafetyPLC_en.pdf . Directly inspected original text. The connection-specific **FSoE Watchdog** generates ComError when a valid response is absent; an optional **ComErrAck** requires separate connection acknowledgement in addition to group **ErrAck**. Group **Safe** means at least one connection not in Data state; group **Run** requires involved safe connections non-faulted and configured Run/Stop input true. Connection states **Reset→Session→Connection→Parameter→Data**; documented errors include invalid CRC, expired watchdog, invalid FSoE address, and failsafe value active. **DOC-CONFIRMED for this edition only**.
2. **Beckhoff, TwinSAFE reaction times, manufacturer InfoSys, copyright 2024**, https://infosys.beckhoff.com/content/1033/el72x1-901x/2155898763.html . Directly inspected page. Defines sensor, input, communication, logic, output, actuator and safety communication watchdog contributors. In a **worst-case double communication failure**, the safety input update may wait one communication watchdog at logic and a second at output; normal successful-cycle reaction time is not a worst-case bound. Equations are presented as images on the webpage; **the exact printed algebra was not transcribed or independently verified**. **DOC-CONFIRMED mechanism; UNKNOWN exact selected worst-case value**.
3. **Beckhoff, General notes for setting the watchdog, manufacturer InfoSys, copyright 2024**, https://infosys.beckhoff.com/content/1033/el2409/1036979339.html . Directly inspected page. EtherCAT ESC has **SM watchdog** (bus process data) and **PDI watchdog** (ESC–local processor); configuration only downloads at startup when enabled; displayed UI values are not proof of downloaded register values. On documented applicable revisions, **SM watchdog=0 disables the ordinary watchdog**; older revisions have an undefined-state caution. Device output may retain its set state after communication loss. **DOC-CONFIRMED ordinary EtherCAT watchdog behavior for documented terminals, NOT a safety-rated FSoE guarantee**.
4. **PI, official PROFIsafe technology description**, https://www.profibus.com/technologies/profinet/profiles/profisafe . Directly inspected official technology page. Safety payload is conveyed over a **black channel** independent of the ordinary network's own integrity mechanisms; safety communication suitability does **not** turn a standard device into a certified safety device by merely adding a protocol. **DOC-CONFIRMED public PI overview, not the full normative specification**.
5. **Existing curriculum**: [25E0 safety-network reintegration](../safety-course/25E0_SAFETY_NETWORK_REINTEGRATION_COMMON_CAUSE_AND_CELL_TRANSFER_2026-09-22.md) documents Rockwell/Siemens faulted safety data, acknowledgement and reintegration. This audit adds the *separate ordinary watchdog vs safety watchdog* and *two-link worst-case latency* mechanisms without changing prior evidence.

## Mechanism and failure discrimination
```text
Guard/sensor -> qualified safe input -> FSoE telegram over ordinary EtherCAT fabric
              -> qualified safety logic -> FSoE telegram -> qualified safe output
              -> independent final element(s) -> physical stop / load hold
LinuxCNC / ordinary EtherCAT master -> motion commands and status (NO safety credit)
ESC SM/PDI watchdog -> ordinary terminal communications health (NO FSoE safety credit)
FSoE connection watchdog + protocol validation -> safety channel integrity (bounded product claim)
```

| Observed condition | Supported conclusion | Forbidden inference / required discriminator |
|---|---|---|
| EtherCAT OP state, normal motion telemetry fresh | Standard bus exchanges data | Does not prove FSoE in Data state, safe output terminals or physical stop. Inspect FSoE state/diag and final elements. |
| Ordinary SM watchdog set to 0 on documented applicable terminal | Ordinary watchdog is disabled, output may not go safe on bus loss | Not evidence FSoE watchdog disabled; independently inspect both actual configurations. |
| TwinSAFE FSoE connection in Data state | Safety connection data exchanges per the documented state machine | Not proof guard coverage, safe output physical contact, hydraulic holding, or permission to start. |
| FSoE CRC/address/watchdog error | Documented diagnostic / safe-state pathway | Need exact safety logic, output response, acknowledgement and physical result; no assumption that normal LinuxCNC E-stop or motion command is sufficient. |
| Cable break coincident with input transition, then second link break | Beckhoff worst-case path can traverse **two** watchdog intervals | Never calculate safeguard distance using only ordinary EtherCAT cycle or one FSoE watchdog. Obtain OEM worst-case equations/parameters and measured selected stop. |
| Communication recovered | Connection can reinitialize and diagnostics may clear | Does not establish zone empty, no retained motion command, no trapped person, or deliberate new start. |
| Safe output reports FALSE | Logic/terminal command state only unless physically verified | Independent contactor/valve/axis witness required, particularly Y1/Y2 gravity load. |

### Adversarial counterexample: three green indicators
A PC shows LinuxCNC **enabled**, an EtherCAT master shows **OP**, and a TwinSAFE link reports **Data**. A welded contactor, leaking valve, miswired output or unsupported load holding can still leave a hazardous actuator active. The three indicators represent **different boundaries**; none establishes physical absence of hazardous motion or stored energy. This is an **INFERENCE** failure-path model; not a demonstrated installed failure.

### Adversarial counterexample: a fast network but slow safety reaction
A fast normal EtherCAT cycle and an apparently modest FSoE watchdog do not by themselves bound end-to-end reaction. Sensor detection, safe input filtering, task cycles, communication watchdog on **both links**, output switching, actuator response and physical stop/hold all contribute. Do not transfer example values from the manufacturer page to OpenPressBrake.

## Practical architecture decision
- **Simplest low-cost default:** local independent hardwired safety relay/PLC and qualified final elements; ordinary LinuxCNC/FPGA/EtherCAT telemetry may *observe* safety status but must not decide personnel-safe stop. Do not add a safety network unless distributed safe I/O genuinely warrants its configuration, testing and maintenance burden.
- **If a certified safety network is justified:** use matched safety-capable input/logic/output products, exact certified configuration, unique connection identities, both-link worst-case reaction budget, appropriate safe-state behavior, physical proof and change-control. Never implement a homemade safety layer on a normal LinuxCNC controller merely because the packet format is documented.
- **Human factors:** clearly label **BUS OK / SAFETY LINK OK / PHYSICAL SAFE** separately. Provide a one-page recovery instruction: identify fault, preserve exclusion, correct hardware, qualified acknowledge, independently verify physical safe state, clear zone, deliberate fresh start. Make troubleshooting easy enough that a technician need not defeat watchdogs to keep production moving.

## Claim ledger
| Claim | Class | Evidence / scope | What remains UNKNOWN |
|---|---|---|---|
| FSoE ComError and optional separate ComErrAck | DOC-CONFIRMED | Beckhoff TwinCAT Safety PLC v1.2.0 pp.26–27 | Selected safety logic and configured acknowledgement |
| FSoE Reset/Session/Connection/Parameter/Data and diagnostics | DOC-CONFIRMED | Beckhoff v1.2.0 pp.46–47 | Installed firmware behavior |
| Two communications faults can incur two watchdog delays | DOC-CONFIRMED | Beckhoff 2024 reaction-time page | Exact algebra as image, installed timings and machine stopping distance |
| Ordinary SM/PDI watchdogs differ; zero can disable SM | DOC-CONFIRMED | Beckhoff 2024 ordinary terminal page | Which exact terminal revisions, registers and fail output state installed |
| PROFIsafe black channel cannot certify a normal device by itself | DOC-CONFIRMED | PI official overview | Complete normative requirements; no selected PROFIsafe system |
| Green link + false safe output need not mean gravity load held | INFERENCE | Physical chain/final element reasoning | Physical witness and failure injection, NOT RUN |
| OpenPressBrake uses FSoE/TwinSAFE/PROFIsafe | UNKNOWN | No selected inventory supplied | As-built inventory; no device asserted |

## Information-gain decision
**No simulation/lab frozen.** Source and manufacturer documentation answer the generic communication mechanism; an ordinary software simulation cannot establish qualified safe outputs, load holding, or selected-machine stopping distance. Reopen for **exact device/firmware/configuration + qualified isolated terminal witness + protected machine physical stop/hold measurements**, or an independent blind competency challenge. No arbitrary timing numbers, SIL/PL or hydraulic truth table adopted.

## Same-session cross-vendor and security-boundary review (additional evidence gain)
The official PI PROFIsafe page (https://www.profibus.com/technologies/profinet/profiles/profisafe), section **Security Aspects of PROFIsafe**, explicitly discusses operation within secure networks under IEC 62443 and separately calls out **availability/reliability** considerations and network responsibility boundaries. PI also says conformity is established through certified products and the safety manual for each F-device. **DOC-CONFIRMED:** the public PI description treats cybersecurity/network management as a distinct integration concern; it does not claim that a CRC or F-address alone replaces security controls. **INFERENCE:** a malicious/unauthorized configuration change, denial of service or remote rearm command is not rendered harmless merely by a safety telegram CRC. **UNKNOWN:** exact cryptographic protection of a given PROFIsafe/FSoE edition, threat model, certified installation, and any selected network exposure; do not assert these without the actual normative/OEM security manual.

**Second independent OEM cross-check:** Siemens' official SIMATIC Safety Integrated product description (https://www.siemens.com/en-gb/content/safety-integrated/) documents PROFIsafe fail-safe communication on standard infrastructure and integration with safety-rated controllers, drives and I/O. This corroborates the **black-channel plus certified endpoints** architecture but **does not verify Beckhoff's FSoE timeout arithmetic**, nor any OpenPressBrake implementation. A plain LinuxCNC/EtherCAT interface is not converted into a safety controller by sharing a network with certified devices.

**Design consequence:** separate (1) accidental communication faults handled by certified safety communication, (2) unauthorized changes addressed by asset inventory, access control, network isolation, approved firmware/configuration and security incident procedures, and (3) loss of network availability requiring a validated physical safe state and an independent fresh-start process. An operator must not be offered 'disable watchdog to clear nuisance alarm' as the fastest path to resume production. No cyber penetration test, packet injection or machine fault injection was performed.
