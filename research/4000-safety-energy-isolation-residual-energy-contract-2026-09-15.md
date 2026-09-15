# 4000 Safety — Hazardous Energy Isolation and Residual-Energy Contract

Date: 2026-09-15
Status: SOURCE / architecture contract
Lane: independent safety-curriculum work; deliberately separate from the active Safety Sandbox simulator-reuse lane.

## Purpose

Teach and test the distinction between **stopping a machine**, **removing normal motion authority**, **emergency stopping**, and **establishing a verified hazardous-energy-isolated maintenance state**. These are not interchangeable states.

This artifact intentionally does **not** claim a machine-specific press-brake hydraulic truth table, accumulator pressure, bleed-down time, ram support method, stopping distance, or required safety performance level. Those remain design/machine evidence items.

## Evidence basis

### SOURCE-CONFIRMED — OSHA 29 CFR 1910.147

Authoritative source: OSHA, 29 CFR 1910.147, Control of Hazardous Energy (Lockout/Tagout):
https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147

Source-confirmed points used by this contract:

- The standard covers servicing/maintenance where unexpected energization/startup **or release of stored energy** can injure employees.
- An energy source includes electrical, mechanical, hydraulic, pneumatic, chemical, thermal, or other energy.
- An energy-isolating device is a mechanical device that physically prevents transmission/release of energy. Pushbuttons, selector switches, and other control-circuit devices are explicitly **not** energy-isolating devices.
- After lockout/tagout is applied, potentially hazardous stored/residual energy must be relieved, disconnected, restrained, or otherwise rendered safe.
- If hazardous stored energy can reaccumulate, isolation verification must continue until servicing is complete or reaccumulation is no longer possible.
- Before work begins, an authorized employee must verify isolation and deenergization.
- The required sequence distinguishes orderly machine shutdown, physical energy isolation, lock/tag application, stored-energy control, and verification.

Relevant clauses: 1910.147(a)(1)(i), (b), (c)(4), (d)(2)-(6), (e), and (f).

### SOURCE-CONFIRMED — OSHA Appendix A

Authoritative source: OSHA 1910.147 Appendix A, Typical minimal lockout procedures:
https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147AppA

Appendix A explicitly lists stored/residual energy examples including capacitors, springs, elevated machine members, rotating flywheels, hydraulic systems, and fluid/gas pressure. It gives dissipation/restraint examples including grounding, repositioning, blocking, and bleeding down. It also calls for verification that the equipment is disconnected from its energy sources before the locked-out condition is accepted.

### SOURCE-CONFIRMED — OSHA interpretive guidance

Authoritative source: OSHA STD 01-05-019:
https://www.osha.gov/enforcement/directives/std-01-05-019

The guidance reinforces that mechanical, hydraulic, pneumatic, chemical, thermal, and other energy are within scope; stored/residual energy must be rendered safe; reaccumulation can require continued monitoring; and authorized employees verify effective isolation before servicing.

## State model for curriculum and simulator

The simulator/curriculum should expose separate state dimensions rather than one misleading `safe=true` bit.

| Dimension | Example state | Meaning |
|---|---|---|
| normal control authority | enabled / inhibited | LinuxCNC/FPGA may or may not command ordinary motion |
| safety-related stop state | healthy / demanded / faulted | safety system status; does not by itself prove hazardous-energy isolation |
| electrical supply isolation | connected / isolated / unknown | physical source isolation state |
| hydraulic source isolation | connected / isolated / unknown | physical hydraulic energy-source isolation state |
| stored hydraulic energy | present / rendered-safe / unknown | accumulator/trapped-pressure state; exact machine method is TBD |
| gravity/mechanical stored energy | hazardous / restrained-rendered-safe / unknown | elevated ram, springs, suspended members, etc.; exact machine method is TBD |
| other stored energy | hazardous / rendered-safe / unknown | capacitors, pneumatic pressure, thermal energy, etc. as applicable |
| isolation verification | not-verified / verified / expired-or-invalid | independent confirmation that required isolation measures are effective |
| maintenance access authority | denied / permitted | derived procedural state, never inferred solely from software stop state |

### Required derivation

`maintenance_access_permitted` may become true only when the machine-specific energy-control procedure's required sources are isolated, hazardous stored/residual energy is rendered safe or restrained, and required isolation verification is current.

A LinuxCNC ESTOP state, FPGA watchdog trip, safety relay trip, safety PLC stop, servo disable, STO request, hydraulic directional-valve neutral command, HMI stop, or loss of communications **must not by itself assert maintenance access permitted**.

This is a curriculum architecture rule, not a claim that every listed mechanism exists on the target press brake.

## Four states learners must not confuse

1. **Normal stop** — production motion has stopped under normal controls. Energy may remain fully available.
2. **Safety-related stop / E-stop response** — hazardous motion is commanded to stop according to the machine's validated safety architecture. Energy may remain present where the safety design requires it.
3. **Control disabled / watchdog inhibited** — ordinary controller authority is removed. This is useful fault containment but is not physical energy isolation.
4. **Verified hazardous-energy isolation for servicing** — applicable energy sources are physically isolated, stored/residual energy is controlled, and isolation is verified under the machine's energy-control procedure.

The learner should be able to explain why state 4 cannot be inferred from states 1-3.

## Press-brake hazard decomposition — INFERENCE pending machine evidence

For a hydraulic press brake, a useful **hazard inventory prompt**, not a machine-specific conclusion, is:

- incoming electrical energy;
- motor/pump electrical energy;
- hydraulic pressure from pump/source;
- trapped hydraulic pressure;
- accumulator energy if an accumulator is present;
- gravity/elevated ram or beam energy;
- spring/mechanical stored energy where present;
- backgauge/servo stored electrical and mechanical energy;
- capacitive DC-bus energy in drives;
- pneumatic energy if present;
- workpiece/tooling stored mechanical energy.

Each item must be classified from actual machine drawings, manuals, inspection, measurement, or component documentation before a machine-specific procedure is written. Absence must not be assumed from a simulator model.

## Human-factors contract

The teaching UI should make the safer path obvious:

- Show **STOPPED** and **ENERGY ISOLATED + VERIFIED** as visibly different conditions.
- Never use a green `SAFE` lamp for ordinary LinuxCNC/FPGA stopped state.
- If isolation status is unknown, display `UNKNOWN / NOT VERIFIED`, not a reassuring default.
- A reset/rearm action must not silently convert an isolation state into production-ready motion authority.
- Re-energization after maintenance is a deliberate sequence with personnel/work-area checks and normal controls in a neutral/non-commanding state; it is not an automatic consequence of removing a fault.
- Where stored energy can reaccumulate, the simulator must support loss/expiry of the verified state or continued monitoring rather than permanently latching `verified=true`.

## Safety Sandbox acceptance tests

These tests are behavioral teaching tests. They do not certify a real machine.

### EISO-01 — Stop is not isolation
Given LinuxCNC reaches stopped/ESTOP and all normal output commands are zero, while physical energy-source isolation remains false/unknown, the UI must deny maintenance-access state and explain that stopping controls are not energy-isolating devices.

### EISO-02 — Watchdog is not isolation
Trip the FPGA/communications watchdog. Normal actuator authority must be removed according to its control contract, but `maintenance_access_permitted` must remain false unless the independent energy-isolation conditions are satisfied.

### EISO-03 — Electrical-only isolation is incomplete
Mark electrical supply isolated but leave a modeled hazardous stored-energy source present. Maintenance access remains denied and the residual-energy source is identified.

### EISO-04 — Hydraulic source off with trapped energy
Mark hydraulic source isolated while modeled trapped/stored hydraulic energy remains hazardous. The simulator must not equate pump-off/source-off with zero hazardous hydraulic energy.

### EISO-05 — Gravity/mechanical energy
Remove electrical and hydraulic source energy while a modeled elevated member remains unrestrained. Maintenance access remains denied until the modeled hazard is restrained/rendered safe.

### EISO-06 — Reaccumulation invalidates verification
Begin from a verified isolation state, then inject a modeled reaccumulation path. Verification must become invalid/unsafe or the monitoring function must alarm; maintenance access must not remain silently permitted.

### EISO-07 — Verification required
Satisfy modeled isolation and stored-energy conditions but omit the verification action/evidence. Maintenance access remains denied.

### EISO-08 — Restore-energy sequence does not auto-start
Transition out of maintenance isolation and restore energy. LinuxCNC/FPGA command state must remain neutral/inhibited until a separate deliberate production rearm/start sequence succeeds. No stale motion/current command may replay.

### EISO-09 — Unknown is not safe
Set one required machine-specific energy source to UNKNOWN. The simulator must fail closed for maintenance-access indication and tell the learner what evidence is missing.

### EISO-10 — Software cannot forge physical isolation
Force an HMI/LinuxCNC/FPGA software variable that claims `isolated=true` while the independent simulated physical-isolator state is connected. Maintenance access remains denied. The teaching point is that a control-circuit assertion is not the physical energy-isolating device.

## Boundary with the reset/restart/rearm lesson

This contract complements, but must remain distinct from, reset/restart/rearm teaching:

- safety reset acknowledges/restores a safety function only under its validated conditions;
- controller rearm restores ordinary control authority only under its control contract;
- production start is a separate deliberate command;
- hazardous-energy isolation is a servicing/maintenance state based on physical isolation, stored-energy control, and verification.

No one of these operations substitutes for another.

## What remains UNKNOWN / machine-specific

Do not promote the following without target-machine evidence:

- exact electrical disconnect topology and lockable points;
- exact hydraulic isolation/bleed/blocking method;
- whether accumulators exist and their stored-energy behavior;
- ram/beam gravity restraint method and proof of adequacy;
- residual pressure threshold that is safe for a particular maintenance task;
- bleed-down/reaccumulation timing;
- drive DC-bus discharge time;
- which maintenance tasks require which isolation boundary;
- any claimed PL/SIL/category for isolation-related safety functions.

## Next independent work

Build a machine-agnostic **energy-source inventory and verification worksheet** for the Safety Sandbox/course. It should force learners to identify each source, isolation device, stored-energy mechanism, dissipation/restraint method, verification method, reaccumulation possibility, and evidence status before a maintenance-isolated state can be declared. Then map that worksheet to the real OpenPressBrake drawings only where source evidence exists.
