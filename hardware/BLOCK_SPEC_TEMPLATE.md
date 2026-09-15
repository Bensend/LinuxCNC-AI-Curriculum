# 4000 Hardware Block Specification Template

Use this template for every reusable controller hardware block. The goal is an engineering contract that a fresh AI, human engineer, or EDA agent can implement without inventing machine authority, failure behavior, or safety semantics.

## Identity
- Block ID / name:
- Revision / status:
- Primary LinuxCNC / HAL / HostMot2 interface:
- Physical authority commanded:
- Known-good reference topology/source:
- Baseline method: COPY/ADAPT | INDEPENDENT ENGINEERING | MIXED

## Functional contract
- Inputs from LinuxCNC/FPGA/MCU:
- Outputs to machine/interface:
- Independent feedback/witness inputs:
- Required continuation/permissive result:
- What this block explicitly does **not** prove:

## Electrical envelope
- Supply rails:
- Input/output voltage range:
- Continuous/peak current:
- Frequency/bandwidth/update rate:
- Source/sink/polarity conventions:
- Connector/pin constraints:
- Isolation requirement:
- Ground/reference strategy:

## Authority chain
Document separately:

`request -> local actuation -> electrical/interface witness -> physical witness -> qualified completion -> continuation acknowledgement`

Mark unavailable stages as unavailable; do not synthesize proof that hardware cannot observe.

## Validity and freshness
- Signal validity mechanism:
- Freshness/age/generation mechanism:
- Stale-command behavior:
- Stale-feedback behavior:
- Transaction rearm/edge requirements:

## Reset / loss-of-control behavior
For each event state the commanded and physical output expectation:

| Event | Output state | Fault/latch state | Recovery/rearm |
|---|---|---|---|
| FPGA reset | | | |
| MCU reset | | | |
| host/LinuxCNC loss | | | |
| Ethernet/communications loss | | | |
| watchdog expiry | | | |
| brownout/undervoltage | | | |
| machine enable removed | | | |
| external safety inhibit | | | |

## Enable / inhibit / fault structure
- Numeric command path:
- Independent hardware enable/inhibit:
- Local fault detection:
- Latched faults:
- Report-only diagnostics:
- Fault-clear/rearm requirements:

## Timing
- Realtime-critical signals:
- Maximum command latency/jitter:
- Feedback sample/update requirements:
- Timeout/watchdog requirements:
- Supervisory-only signals:

## Protection / robustness
- ESD:
- EFT/transient/surge:
- Reverse polarity/miswire:
- Overvoltage:
- Overcurrent/short circuit:
- Thermal:
- Inductive energy/flyback:
- EMC/filtering:
- Creepage/clearance where relevant:

## Diagnostics
Expose enough state to distinguish:
- requested action;
- active owner/mode;
- command value;
- actual electrical/interface state;
- physical witness state;
- validity/freshness;
- active inhibit/interlock;
- timeout/fault reason;
- reset/rearm state.

## Parameterization envelope
- Parameters allowed without topology change:
- Parameters requiring component-value change:
- Parameters requiring topology change:
- Absolute supported envelope:
- Combinations explicitly unsupported:

Parameterization must not erase authority, protection, reset, or safety-boundary semantics.

## Safety boundary
- Normal-control function:
- Software/realtime fault-containment role:
- External safety-rated authority required:
- Explicit non-safety claims:

Do not call a LinuxCNC/HAL/FPGA watchdog, normal enable, communications check, or diagnostic input safety-rated without evidence and a suitable safety architecture.

## Proven-topology adaptation record
If copying/adapting an existing circuit:
- source project and exact schematic/revision;
- copied topology boundary;
- changes made;
- reason for each change;
- assumptions introduced;
- datasheet checks performed;
- behavior that must remain invariant.

## Engineering calculations
Record only calculations that determine component rating, accuracy, stability, thermal margin, bandwidth, protection or timing. Keep units and worst-case assumptions explicit.

## Verification plan
Classify each item:
- `REFERENCE-PROVEN` — topology/function already established by inspected design;
- `CALCULATION` — standard engineering calculation sufficient;
- `BENCH` — physical measurement required;
- `SIMULATION` — simulation materially reduces uncertainty;
- `INTEGRATION` — must be tested with FPGA/LinuxCNC/real interface.

Do not simulate ordinary known-good circuitry merely to satisfy a checklist.

## AI / EDA handoff
A schematic/PCB AI should receive:
- this completed contract;
- interface/pin/net names;
- reference schematic excerpts/links and revision;
- selected components and datasheets;
- electrical/placement/routing constraints;
- isolation/ground domains;
- critical loops/traces;
- test points;
- DNP/options/parameter variants;
- verification checklist.

The EDA agent may optimize implementation, but may not silently change authority, reset/fault, isolation, or protection semantics.

## Evidence / open questions
| Claim / decision | Evidence | Classification | Confidence | Open action |
|---|---|---|---|---|

## Promotion / unresolved items
Record unknowns that require another block, physical hardware, later PCB work, or a specialized test. State whether they block schematic freeze, PCB freeze, or neither.
