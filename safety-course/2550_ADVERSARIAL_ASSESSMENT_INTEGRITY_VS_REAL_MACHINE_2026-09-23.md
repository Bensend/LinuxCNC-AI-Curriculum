# 2550 — Adversarial assessment: integrity calculation vs real machine

## Assessment contract

This assessment tests method reasoning, not memorization of a PL chart. Do not invent PLr, achieved PL, MTTFd, DCavg, CCF points, PFHd, B10d, stopping time, pressure, or diagnostic coverage when the scenario does not supply defensible evidence.

For every claim label the basis `DOC-CONFIRMED`, `SOURCE-CONFIRMED`, `TEST-CONFIRMED`, `INFERENCE`, or `UNKNOWN`.

## Scenario

A guarded automated machining cell contains:

- an electromechanical guard switch with two electrical channels;
- a commercial safety controller;
- a variable-speed spindle drive with a documented STO safety subsystem;
- a separate spindle mains contactor with an auxiliary contact;
- a pneumatic workholding circuit;
- LinuxCNC for ordinary sequencing, HMI, status display and production control;
- a safety-controller status link visible to LinuxCNC.

The intended personnel-protection function is described informally as: opening the access guard during automatic operation must prevent hazardous machine motion/energy from exposing the entrant.

Available evidence:

- the guard switch manufacturer publishes applicable safety/reliability data, but the actual machine actuation frequency has not yet been measured;
- the safety controller has manufacturer subsystem data;
- the drive has manufacturer STO subsystem data;
- the contactor auxiliary contact is documented only as an ordinary auxiliary contact; no evidence has been supplied that it is a mirror/force-guided diagnostic witness;
- pneumatic valve position can be monitored, but no measured downstream pressure decay or trapped-volume analysis is supplied;
- both guard channels run through one multi-pin connector and the same physical cable route;
- the existing SISTEMA file reports a satisfactory result, but it was created before production-rate and pneumatic-tooling changes;
- LinuxCNC displays `SAFETY OK` when the safety controller exposes its healthy status.

No other physical data is supplied.

## Tasks

### 1 — Repair the safety-function statement

Rewrite the informal function into propositions that can actually be specified and validated. Separate at minimum:

- initiation condition;
- required control response;
- spindle hazardous-motion/energy proposition;
- pneumatic hazardous-energy proposition;
- restart/rearm behavior;
- any physical quantity that remains `UNKNOWN` and requires measurement or design evidence.

Do not turn `STO active`, `contactor off`, `valve commanded exhaust`, or `SAFETY OK` into a physical-safe-state claim without evidence.

### 2 — Decompose the SRP/CS

Produce a block/subsystem decomposition from guard input through logic and each relevant final element. Mark manufacturer-certified subsystems separately from machine-builder-created integration.

Explain why the drive STO subsystem's published capability cannot simply be copied into the achieved PL field for the complete guard function.

### 3 — Audit the old calculation

List every assumption in the existing SISTEMA model that must be revalidated after the production-rate and pneumatic-tooling changes.

At minimum inspect:

- component identity/revision;
- electromechanical use profile and cycle frequency;
- Category/architecture representation;
- MTTFd/B10d applicability;
- DC/DCavg evidence;
- CCF measures/dependencies;
- subsystem data/mission assumptions;
- final-element representation;
- validation evidence.

State why an internally consistent old result may now be invalid.

### 4 — Find the attractive false claims

Reject or qualify each statement:

1. `Two guard channels means Category 4.`
2. `The STO block is PL e, therefore the guard function is PL e.`
3. `The contactor auxiliary contact proves the contactor opened.`
4. `The valve-position sensor proves pneumatic pressure is safe.`
5. `LinuxCNC says SAFETY OK, therefore personnel entry is safe.`
6. `SISTEMA still opens green, therefore no revalidation is needed.`
7. `The schematic has redundancy, therefore CCF is handled.`

### 5 — CCF/dependency analysis

Analyze the shared connector and cable route. Do not automatically declare them unacceptable; instead identify the failure mechanisms that could defeat both channels and what evidence/measures would be needed to judge the dependency.

Then search the rest of the safety function for additional common dependencies, especially common final elements, shared power, shared environment, shared software/configuration and maintenance/replacement mechanisms.

### 6 — B10d/use-profile reasoning

Using only the sourced symbolic relationships:

`nop = (dop * hop * 3600) / tcycle`

`MTTFd = B10d / (0.1 * nop)`

explain why the guard-switch contribution cannot be finalized until the actual/defensible machine use profile is known. Show the direction of change if demand frequency rises, but do not invent a numeric MTTFd.

### 7 — Diagnostics vs physical proof

Create two columns:

`diagnostic proposition` | `physical safe-state proposition`

Place each available signal/evidence in the correct scope: guard-channel state, controller health, STO status, contactor auxiliary state, valve position, spindle standstill evidence if any, downstream pneumatic pressure evidence if any, and personnel-clear/restart evidence.

Identify missing physical proof.

### 8 — Cheapest useful correction

Choose the single cheapest *defensible* improvement that gives the greatest information/risk-control gain for this scenario. The answer must identify the current limiting failure/proposition first. A generic `add another channel` answer receives no credit.

### 9 — LinuxCNC authority boundary

Define what LinuxCNC may legitimately do with the safety-controller status and what it must not be relied upon to do for this personnel-protection function.

### 10 — Release decision

Choose one:

- `adequate evidence for personnel-exposed operation`, or
- `not yet adequate for personnel-exposed operation`.

Defend the decision from the supplied evidence only. If not adequate, state what can be done safely while evidence is incomplete. Experimental operation requiring hazardous motion must keep people outside the danger zone and use isolation/remote methods appropriate to the unresolved hazard.

## Critical-failure conditions

The assessment fails if the learner:

- invents a PLr or achieved PL;
- assigns Category solely from channel count;
- copies a certified subsystem's PL to the complete safety function;
- treats DC/EDM/status as physical safe-state proof;
- ignores a common final element or CCF dependency;
- uses stale B10d/use-profile assumptions without qualification;
- grants ordinary LinuxCNC/FPGA control personnel-safety authority;
- declares the machine safe for exposed operation while required physical propositions remain unsupported.

## Assessment intent

A strong response should demonstrate that ISO 13849 numerical evaluation is one bounded layer in a larger safety-engineering argument. The learner should be able to say both `this calculation is not yet defensible` and `this calculation may be defensible but the physical machine is not yet validated` when the evidence requires those conclusions.
