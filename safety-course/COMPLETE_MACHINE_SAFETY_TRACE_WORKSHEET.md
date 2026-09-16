# Complete Machine Safety Trace Worksheet

Purpose: force a safety study to reach the **physical hazardous-energy boundary** instead of stopping at E-stop, safety relay, PLC, LinuxCNC or an output bit.

Use one worksheet per machine and per materially different safety demand (E-stop, guard open, light curtain, enabling-device release, safe setup mode, etc.). Do not merge different demands unless the source proves their response is identical.

## A. Machine and evidence identity

- Machine / model:
- Revision / year:
- Hazardous motion/process:
- Source documents and exact drawing/page identifiers:
- Applicable source revision/date:
- Evidence labels used: SOURCE-CONFIRMED / DOC-CONFIRMED / TEST-CONFIRMED / COMMUNITY-REPORTED / INFERENCE / UNKNOWN

## B. Safety demand

- Initiating protective device:
- Device type and channels:
- Normal operating state:
- Demand/fault state:
- Cross-short/discrepancy monitoring shown?:
- Reset/restart requirement:

## C. Trace 1 — safety-control chain

Fill every row; use UNKNOWN rather than guessing.

| Stage | Device / signal | Channels / redundancy | What changes on demand? | Fault monitoring | Evidence |
|---|---|---|---|---|---|
| Protective device | | | | | |
| Safety input | | | | | |
| Safety logic | | | | | |
| Reset/restart logic | | | | | |
| Safety output 1 | | | | | |
| Safety output 2 | | | | | |
| Final element A | | | | | |
| Final element B | | | | | |
| EDM / valve / brake feedback | | | | | |
| Ordinary PLC/CNC notification | | | | | |

## D. Trace 2 — physical energy chain

Trace independently from the energy source toward the person-exposed hazard.

| Energy source | Normal path to hazardous motion | Physical interruption/control element | State after demand | Residual/stored energy | Evidence |
|---|---|---|---|---|---|
| Incoming electrical mains | | | | | |
| Drive DC bus / motor torque | | | | | |
| Hydraulic pump / pressure | | | | | |
| Pneumatic supply | | | | | |
| Gravity / suspended mass | | | | | |
| Spring / accumulator / stored mechanical | | | | | |
| Thermal / process energy | | | | | |
| Other | | | | | |

## E. What remains energized?

Explicitly mark YES / NO / UNKNOWN and cite the drawing.

- Main disconnect input side:
- Main disconnect output side:
- Control transformer / 24 V supply:
- Safety controller:
- Ordinary PLC/CNC/LinuxCNC computer:
- Servo/VFD mains:
- Servo/VFD DC bus:
- Motor phases:
- Hydraulic pump motor:
- Hydraulic pressure source:
- Valve coils:
- Diagnostics/HMI:
- Auxiliary mechanisms:

## F. Hazard state, not just signal state

Answer separately:

- Can the actuator still produce commanded force/torque?
- Can it move from stored energy?
- Can gravity move it?
- Can another axis/process still create the hazard?
- Does a brake/holding valve merely hold, or is energy physically isolated?
- Is the protective state suitable for operational access only, or also maintenance?
- What source proves each answer?

## G. Feedback and proof

- What proves each contactor opened?
- What proves STO channels responded?
- What proves each safety/holding valve reached the required state?
- What proves a mechanical brake/lock engaged?
- What faults prevent reset/rearm?
- Can an ordinary PLC/HMI display the status without owning the safety decision?

## H. Reset / restart / rearm

- Does clearing the protective device automatically restore safety outputs?
- Is a deliberate reset required?
- Is a separate normal-cycle start required after reset?
- Does reset location provide adequate view of the hazard zone?
- What final-element feedback must be healthy before reset?
- What stale ordinary-control commands are cleared before rearm?

## I. Maintenance state

Operational E-stop/guard/STO is not automatically maintenance isolation.

- Lockable electrical isolation point:
- Hydraulic isolation / pressure-release method:
- Pneumatic isolation / dump method:
- Gravity blocking/restraint:
- Stored-energy discharge verification:
- Out-of-service/tag state if work is left incomplete/unattended:
- What must be restored before the machine can be returned to service?

## J. Human-factors / bypass pressure

- What normal task is most likely to tempt bypass?
- Is there an engineered safe setup/jog mode?
- Are guards/interlocks easy to reinstall correctly?
- Are bypasses obvious, controlled and temporary where legitimately required for commissioning?
- Does the machine make the safe action easier than defeating the safeguard?
- If not, record the inconvenience as a design defect to address.

## K. LinuxCNC / ordinary-controller boundary

- What normal requests may LinuxCNC make?
- What safety state may LinuxCNC monitor for diagnostics?
- Which outputs are independently removed from LinuxCNC authority on a safety demand?
- Can a crashed/frozen/misconfigured LinuxCNC or FPGA process defeat the personnel-safety function? If YES or UNKNOWN, the architecture is not yet acceptable as an independent safety boundary.

## L. Validation questions

Do not invent numerical values.

- Required stopping-time/distance measurement:
- Safety-function response tests:
- Single-fault tests required by the selected architecture:
- Contactor/valve/brake feedback fault tests:
- Restart/rearm fault tests:
- Guard/protective-device defeat tests:
- Power-loss/restoration tests:
- Maintenance-isolation verification:
- Machine-specific measurements/calculations still UNKNOWN:

## M. Minimum safe-to-operate gate

If the evidence cannot establish a basic safe-to-operate state, state that clearly. Do not operate with people exposed to the hazard. Any experimental operation before the minimum safety threshold is established must be isolated/remote with people outside the danger zone and residual risk explicitly recorded.

## N. One-sentence physical boundary

Complete this only after both traces are supported:

> When **[safety demand]** occurs, **[safety logic]** causes **[physical final elements]** to **[physical state]**, which controls/removes **[hazardous energy path]**; **[energy that remains]** remains present, and **[feedback]** is used to prove the required final-element state before rearm.
