# Safety Fieldbus Black-Channel, Identity, Freshness, and Authority Study

Date: 2026-09-18
Lane: independent safety curriculum Lane B

## Why this branch

The primary safety lane is currently advancing accessible-cell power-loss / escape / restart authority. This study deliberately uses different evidence and files. It addresses a separate architecture question that matters directly to LinuxCNC/OpenPressBrake: when ordinary Ethernet/fieldbus infrastructure transports safety data, what makes that data safety communication rather than ordinary network I/O?

## Evidence labels

- **SOURCE-CONFIRMED** — directly supported by authoritative manufacturer / protocol-organization documentation cited below.
- **DOC-CONFIRMED** — confirmed by repository documentation or a project-specific controlled document.
- **TEST-CONFIRMED** — demonstrated by an applicable controlled test.
- **COMMUNITY-REPORTED** — reported by practitioners but not independently established here.
- **INFERENCE** — engineering conclusion drawn from confirmed evidence; not itself a quoted manufacturer requirement.
- **UNKNOWN** — not established for OpenPressBrake and must not be invented.

## Architecture freeze

**ETHERNET LINK UP != SAFETY CONNECTION VALID != SAFETY PEER IDENTITY VALID != SAFETY TELEGRAM FRESH != SAFETY DATA VALID != SAFETY APPLICATION PERMISSIVE != FINAL ELEMENT PROVEN IN SAFE/EXPECTED STATE.**

**ORDINARY NETWORK TRANSPORT HEALTH != PERSONNEL-SAFETY AUTHORITY.**

A standard switch, cable, Linux network stack, ordinary FPGA Ethernet MAC, or LinuxCNC/HAL data path may transport or observe information, but that does not make it the safety endpoint or the authority that decides a personnel-safety function.

## Source trace

### 1. PROFIsafe: the transport is intentionally a black channel

**SOURCE-CONFIRMED.** PROFIBUS & PROFINET International describes PROFIsafe as covering the safety communication path from sensor through controller to actuator while integrating standard and safety communication on the same bus. The underlying communication path is treated as a black channel; its own transmission rate/error-detection mechanism is not the safety mechanism relied upon by PROFIsafe.

PI's PROFIsafe concept material identifies additional safety measures in the F-message: consecutive numbering/sign-of-life, time expectation/watchdog, sender/receiver identity via F-address, and F-CRC data-integrity checking.

**INFERENCE.** Therefore a successful ordinary PROFINET/Ethernet exchange is not sufficient evidence that a safety message is authentic, fresh, timely, or intact. Those properties belong to the safety protocol/endpoints.

### 2. CIP Safety: standard network infrastructure may sit between safety endpoints

**SOURCE-CONFIRMED.** Rockwell's GuardLogix safety documentation states that CIP Safety systems can include bridges, switches, routers, adapters, and redundancy modules that are not SIL 2/3 certified. CIP Safety is an end-node-to-end-node safety protocol intended to protect safety data from network delivery errors through that standard infrastructure.

**SOURCE-CONFIRMED.** Rockwell also documents the Unique Node Reference / UNID concept and requires unique identity within the scope of devices that can communicate. A Safety Network Number plus node address participates in identifying a CIP Safety port. Modules retain assigned identity and may require reset before reuse under another value.

**INFERENCE.** Replacement, cloning, subnet reuse, copied configurations, and service work create an identity/configuration hazard even when ordinary Ethernet addressing appears correct. 'It pings' or 'the I/O tree is online' is not equivalent to proving that the intended safety peer/configuration is bound correctly.

### 3. Safety over EtherCAT: black channel does not mean no safety protocol

**SOURCE-CONFIRMED.** Beckhoff describes FSoE / Safety over EtherCAT as treating the transport medium as a black channel and permitting safety and standard information over the same communication infrastructure. Beckhoff device documentation exposes safety communication parameters including Safety Address, Connection ID, Watchdog Time, and Unique Device ID.

**INFERENCE.** Shared physical transport can be acceptable in a certified architecture precisely because safety communication has its own endpoint identity, connection state, timing/freshness and integrity mechanisms. Merely putting an ordinary command on EtherCAT/Ethernet is not an equivalent design.

## OpenPressBrake boundary

The following are **UNKNOWN** for OpenPressBrake unless and until a specific certified architecture and its safety manual establish them:

- whether any networked safety protocol will be used at all;
- protocol (PROFIsafe, CIP Safety, FSoE, another certified mechanism, or hardwired safety only);
- safety-controller and safety-I/O endpoint models;
- required safety addresses / identities / connection IDs;
- watchdog or safety communication timing;
- safe substitute values on communication fault;
- commissioning ownership and password/signature controls;
- achieved PL, SIL, category, PFHd, DC or CCF claim;
- whether any particular switch, FPGA, NIC, Linux host, cable topology or redundant network is acceptable in the safety path.

Do not derive any of those from generic black-channel capability.

## Separation rule for LinuxCNC / FPGA

**INFERENCE.** A useful OpenPressBrake architecture may allow ordinary LinuxCNC/FPGA networking to coexist with a safety communication system, but the following must remain explicit:

1. LinuxCNC may request ordinary motion or consume safety status for diagnostics.
2. An ordinary FPGA may expose machine-control state and may independently watchdog normal outputs for fault containment.
3. Neither ordinary HAL logic nor an uncertified FPGA/network stack becomes personnel-safety authority merely because it transports the same semantic signal.
4. The safety endpoint must independently decide whether its safety connection/data are valid and what state follows loss, corruption, wrong identity, stale sequence, or timeout.
5. Restoration of ordinary communications must not silently become restoration of hazardous-motion authority; safety rearm/restart behavior remains a separate design question.

## Failure-path worksheet

| Challenge | Ordinary system may show | Safety question that must be answered | Evidence state |
|---|---|---|---|
| Ethernet cable unplugged | link down / timeout | Does safety endpoint enter defined safe communication state? | generic behavior SOURCE-CONFIRMED; OpenPressBrake UNKNOWN |
| Switch reboots | packets stop/reorder/delay | Which safety-endpoint watchdog/freshness rule catches it? | generic principle SOURCE-CONFIRMED; timing UNKNOWN |
| Ordinary packet duplicated | network may still look healthy | Is duplicate/repeated safety data rejected by sequence/freshness mechanism? | PROFIsafe mechanism SOURCE-CONFIRMED; OpenPressBrake UNKNOWN |
| Stale safety telegram replayed | payload values may look plausible | What proves telegram freshness rather than value plausibility? | protocol principle SOURCE-CONFIRMED |
| Wrong safety device installed | IP/network may be valid | What endpoint identity/configuration binding rejects the wrong peer? | CIP Safety identity principle SOURCE-CONFIRMED |
| Copied machine/project | same logical config may boot | Are safety identities/network numbers unique and commissioned correctly? | CIP Safety concern SOURCE-CONFIRMED |
| CRC/integrity failure | transport may deliver frame | Does safety endpoint reject data and substitute safe state? | PROFIsafe principle SOURCE-CONFIRMED |
| LinuxCNC crashes while safety network remains alive | safety transport may remain healthy | Does safety system independently remove/withhold hazardous-motion authority as required by the safety function? | architecture requirement INFERENCE; implementation UNKNOWN |
| Safety endpoint faults while LinuxCNC remains alive | HMI/network may look normal | Can ordinary control bypass or recreate final-element authority? | must not be assumed; UNKNOWN until architecture traced |
| Network recovers | link/data resume | Is explicit safety acknowledgement/rearm required, and is fresh ordinary START separately required? | implementation UNKNOWN |
| Maintenance replaces safety I/O | ordinary address can be restored | What identity/signature/ownership procedure proves the intended replacement? | generic concern SOURCE-CONFIRMED; procedure UNKNOWN |

## Commissioning questions

A professional implementation trace should answer, with evidence:

- Which devices are the actual safety endpoints?
- Which parts of the physical network are deliberately treated as black channel?
- What detects corruption, repetition, deletion, insertion, wrong sequence, excessive delay, wrong peer, and wrong configuration?
- What is the safety-side state when communication is invalid?
- Can ordinary control continue to command an actuator through any alternate path after the safety communication is invalid?
- What happens if standard control is healthy but safety communication is lost?
- What happens if safety communication is healthy but standard control is lost?
- What exact action is needed after safety communication recovers?
- Does restoring the safety connection merely permit rearm, or can it itself restart hazardous motion?
- What configuration/signature/address checks are required after device replacement, project copy, network readdressing, firmware update, or switch/topology service?
- Is HMI 'Safety OK' derived from a safety endpoint's validated state, or merely from ordinary packet/link health?

## Minimum teaching takeaway

The phrase **black channel** does not mean 'the network does not matter' and does not license arbitrary safety traffic over ordinary Ethernet. It means a qualified safety protocol/endpoints provide the safety defenses needed so the underlying transport need not itself perform the safety function.

For OpenPressBrake, this reinforces the existing boundary: **ordinary LinuxCNC/FPGA control may request and observe; personnel-safety authority must remain independently established.**

## No-compute decision

No simulation, synthesis, benchmark, or executable test is justified by this evidence question. The unresolved items are architecture/protocol selection and manufacturer-specific commissioning requirements, not a numerical behavior that local compute could establish. No GitHub-hosted or self-hosted compute was consumed.

## Sources

- PROFIBUS & PROFINET International, PROFIsafe profile overview: https://www.profibus.com/technologies/profinet/profiles/profisafe
- PI, PROFIsafe concept / black-channel presentation: https://www.profibus.com/index.php?eID=dumpFile&f=53290&t=f&token=6c8f55bcf01604eb71efb19902a1209c5274b84e
- Rockwell Automation, GuardLogix / CIP Safety Systems and Safety Network Numbers: https://www.rockwellautomation.com/en-no/docs/technical/logix5000/_online/1756-rm012/guardlogix-5580-and-compact-guardlogix-5580-safety/cip-safety-systems-and-safety-network-numbers.html
- Rockwell Automation, Safety Network Number: https://www.rockwellautomation.com/en-us/docs/technical/logix5000/_online/1756-um543/controllogix-5580-and-guardlogix-5580-controllers-/guardlogix-functional-safety/safety-network-number.html
- Beckhoff, Safe automation with TwinSAFE: https://download.beckhoff.com/download/document/Catalog/Beckhoff_TwinSAFE_e.pdf
- Beckhoff, FSoE communication parameters example: https://infosys.beckhoff.com/content/1033/amp8000_object/18771155211.html

## Precise next-work checkpoint

Find one authoritative complete implementation in which standard and safety traffic share physical network infrastructure and trace:

`safety sensor -> safety endpoint -> safety protocol identity/freshness/integrity -> black-channel infrastructure -> receiving safety endpoint -> safety output/final element -> communication fault -> safe reaction -> recovery/rearm -> separate ordinary motion/start authority`.

Prefer documentation that also shows replacement/recommissioning or wrong-identity behavior. Do not infer OpenPressBrake protocol choice or safety performance from the example.