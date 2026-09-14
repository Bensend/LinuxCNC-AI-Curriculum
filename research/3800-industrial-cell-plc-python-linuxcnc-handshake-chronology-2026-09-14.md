# 3800 — Industrial automation cell: PLC / Python / LinuxCNC responsibility split

Date: 2026-09-14
Status: COMMUNITY-REPORTED / LONG-RUN FIELD EVIDENCE

## Source

LinuxCNC forum chronology:

- `Industrial Automation Project` (2023): https://forum.linuxcnc.org/38-general-linuxcnc-questions/49796-industrial-automation-project
- later follow-up in `PLC + LinuxCNC for industrial machine with simple HMI (non-G-code operators)` (2026): https://forum.linuxcnc.org/38-general-linuxcnc-questions/58288-plc-linuxcnc-for-industrial-machine-with-simple-hmi-non-g-code-operators

This is field/community evidence rather than an inspectable source/config repository, but the later post reports the system has run daily for more than four years producing thousands of parts.

## Physical cell

The reported production system contains:

- circulating pallets;
- raw-material loading aided by a projected image;
- a heat-press laminator;
- four servo-driven custom conveyors;
- pneumatic cylinders;
- a PID-controlled 10 kW heated platen;
- a LinuxCNC CNC cutting station;
- automatic material infeed/outfeed.

The operator does not interact directly with LinuxCNC or G-code. Product code is selected at the HMI.

## Responsibility split

### PLC / industrial-controls layer

Reported responsibilities include the broader machine/cell process and material flow:

- conveyors/pallet routing;
- heat press and auxiliary mechanisms;
- product flow between stations;
- PLC tags indicating when a pallet/product has arrived at the CNC station;
- receiving completion state from the LinuxCNC bridge before advancing the pallet.

### Python supervisory bridge

Python is the translation/orchestration layer between the plant-style PLC/HMI and LinuxCNC.

Reported mechanisms:

- Modbus/TCP to the PLC;
- Python `linuxcnc` module / NML-facing API to LinuxCNC;
- read selected product code from PLC;
- map product code to the correct G-code file;
- load that G-code into LinuxCNC;
- home LinuxCNC at startup and check ready state;
- command program execution when the PLC reports the pallet at the cutting station;
- observe LinuxCNC completion;
- set a PLC completion bit authorizing material transfer onward;
- rehome after E-stop events.

### LinuxCNC machine layer

LinuxCNC owns the local CNC function:

- homing/reference;
- CNC toolpath execution;
- completion/status exposed to the supervisory bridge;
- local machine I/O as configured.

## Evidence-backed handshake

The field description supports this transaction:

`PLC product code`
→ `Python reads recipe request`
→ `Python maps/loads G-code into LinuxCNC`
→ `PLC pallet-at-CNC bit`
→ `Python commands LinuxCNC run`
→ `LinuxCNC executes CNC cycle`
→ `Python observes complete`
→ `Python sets PLC complete/transfer bit`
→ `PLC advances pallet`

This is strong evidence for **responsibility partitioning**, but the public posts do not expose the exact bit-generation protocol, timeouts, sequence numbers, heartbeat or stale-message rejection.

Therefore do not generalize a specific ready/request/busy/done electrical protocol from this example.

## Important 3800 lessons

### 1. External supervisory control can be the correct architecture

LinuxCNC need not own the entire automation cell. It can be the CNC-motion/process node inside a broader PLC-controlled machine.

This is particularly attractive when the cell already contains:

- conventional industrial I/O;
- conveyors;
- heaters;
- pneumatic mechanisms;
- non-CNC stations;
- operators who should see a product-oriented HMI rather than a CNC UI.

### 2. Product identity and G-code identity are separate state

The bridge owns a real provenance mapping:

`product code -> selected G-code file`.

A production playbook should preserve the selected product/recipe identity, loaded program identity, and current pallet/part identity so a restart cannot silently run a stale program against a new pallet.

The forum description proves the mapping exists but does not publish its validation logic.

### 3. Cell transfer requires machine completion, not merely program command acceptance

The PLC does not move the pallet merely because Python asked LinuxCNC to run. The reported bridge waits for LinuxCNC completion and only then writes the PLC bit that allows the next transfer.

This is the same transaction principle emerging from saw/feed research:

`fresh request -> active work -> actual completion witness -> transfer authorization`.

### 4. E-stop recovery changes state provenance

The reported system rehomes LinuxCNC after E-stop. That is significant because geometric reference is explicitly re-established rather than assumed retained.

However the public account does not say that rehoming alone resolves:

- pallet identity;
- product count;
- partially completed heat/cut state;
- material currently between stations;
- whether the current CNC part was fully cut.

Those remain cell-supervisor recovery responsibilities unless stronger evidence says otherwise.

## Failure questions the public description leaves open

A stronger production handoff should answer:

- What if Python dies while PLC and LinuxCNC remain healthy?
- What if Modbus communications become stale?
- Is PLC `run CNC` edge- or level-triggered?
- Is there a request generation/sequence number?
- Can a stale `complete` bit authorize the next pallet?
- How does Python prove that the loaded G-code corresponds to the current product code?
- What does PLC do if LinuxCNC faults after accepting the run request?
- Who owns timeout and retry?
- How are partial products/counts reconciled after E-stop or power loss?

These are **UNKNOWN** from the public evidence, not defects asserted against the actual machine.

## Adversarial review

1. Does LinuxCNC need to own every cell mechanism? **No; this field example deliberately uses PLC + Python + LinuxCNC.**
2. Does `program loaded` mean the correct current product is proven? **Not by itself; product/program provenance remains a supervisory responsibility.**
3. Does a PLC start bit equal CNC completion? **No. The reported bridge waits for completion before authorizing transfer.**
4. Does rehoming after E-stop automatically restore material-flow state? **No evidence supports that.**
5. Does Modbus/TCP make the handshake deterministic or safety-rated? **No such claim is supported.**
6. Does a four-year field history prove every failure path is robust? **No; it is useful reliability evidence, not a published fault-injection record.**
7. Is a Python bridge inherently wrong because it is userspace? **No. It is appropriate for supervisory orchestration when realtime/safety responsibilities remain elsewhere.**

Result: **7/7 boundaries preserved.**

## 3800 transfer rule

A reusable automation-cell architecture should explicitly assign:

- **PLC/realtime mechanism layer:** local sequence/interlocks and physical I/O where appropriate;
- **LinuxCNC layer:** CNC geometry, homing/reference and local machining cycle;
- **supervisory layer:** product/job identity, recipe/program selection, high-level request/completion orchestration and operator workflow;
- **safety layer:** independent safety-rated functions as required by the real machine.

The interfaces between these layers should use fresh request/acknowledgement semantics rather than relying on unversioned sticky bits when stale state could cause the wrong physical action.
