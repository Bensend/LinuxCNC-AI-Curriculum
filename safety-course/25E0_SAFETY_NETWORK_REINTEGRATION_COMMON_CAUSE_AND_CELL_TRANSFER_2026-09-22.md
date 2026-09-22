# 25E0 — Safety-Network Reintegration, Shared-Supply Common Cause, and Cell Transfer

Date: 2026-09-22
Status: learner-facing 4000 safety-course method

## Learning objective

Extend the power-recovery method through safety-network connection loss and restoration. Distinguish a valid communication connection from reintegration of a safety channel/function, distinguish reintegration from return-to-service and ordinary start authority, trace one shared field-power source into multiple nominally separate safety functions, and transfer the method to a robot/automated cell without inventing machine physics.

## Evidence ledger

### DOC-CONFIRMED — lost safety connection forces consumed safety data to the safe representation

Rockwell Automation, *Monitor GuardLogix Safety Status*, documents `ConnectionFaulted` and `RunMode` for safety I/O/produced-consumed safety data. If a safety connection faults, consumed safety data is reset to zero and the producing device state is unknown. Rockwell also warns that safety I/O/produced-consumed connection loss does not automatically fault the controller; where required for the safety integrity of the application, connection status must be monitored and acted on by safety logic.

Source: https://www.rockwellautomation.com/en-ca/docs/technical/logix5000/_online/1756-rm012/guardlogix-5580-and-compact-guardlogix-5580-safety/monitor-safety-status-and-handle-faults/monitor-guardlogix-safety-status.html

Claim class: `DOC-CONFIRMED`.

Boundary: a `Valid/Run` safety connection establishes the documented communication state. It does not by itself prove a machine-level physical proposition such as personnel clear, guard geometry correct, hazardous motion stopped, pressure removed, or a final element physically safe.

### DOC-CONFIRMED — communication/supply errors can require deliberate reintegration after the fault clears

Siemens fail-safe I/O documentation distinguishes fault clearing from reintegration. It instructs maintainers to diagnose/repair the fault, revalidate the safety function, and record the work. Reintegration can be automatic or manual for configured channel faults, while module-wide errors such as PROFIsafe communication or supply-voltage errors are manually reintegrated; fatal errors can require a power cycle.

Source: https://docs.tia.siemens.cloud/r/fail_safe_modules_manual_collection_enus_21/device-specific-information/s7-1200-fail-safe-modules/s7-1200-g2-f-io/sm-1226-f-di-4x/f-dq-2x-2a-ppm/di-2x-24vdc/fail-safe-io/interrupts/diagnostic-alarms/reactions-to-faults

Claim class: `DOC-CONFIRMED`.

Siemens SINAMICS Safety Integrated documentation independently states that user acknowledgement is always required after a communication error and that automatic reintegration is permissible only where the process safety assessment permits it.

Source: https://cache.industry.siemens.com/dl/files/782/109783782/att_1038582/v1/S210_MC_SI_commiss_man_1020_en-US.pdf

Claim class: `DOC-CONFIRMED`.

### DOC-CONFIRMED — restored communication can still leave fail-safe values active pending acknowledgement

ABB AC500-S safety-I/O documentation describes PROFIsafe module passivation on communication failure, watchdog timeout, or supply fault. After the error is gone, communication can be running while the module still waits for reintegration acknowledgement; fail-safe values remain in use until the acknowledgement transition is accepted.

Source: https://help.plc.abb.com/safety_io_module_states_description.html

Claim class: `DOC-CONFIRMED`.

This is a useful professional counterexample to the bad assumption `network healthy -> safety function automatically re-enabled`.

## Core recovery distinction

A safety-network recovery can contain at least five distinct events:

1. transport/physical communication becomes possible;
2. the safety protocol connection becomes valid;
3. device/channel diagnostics establish that the fault cause is gone;
4. required reintegration/acknowledgement occurs;
5. the machine-level safety proposition and return-to-service obligations are satisfied.

These events are not interchangeable.

Therefore:

**SAFETY CONNECTION VALID != SAFETY FUNCTION REINTEGRATED.**

**SAFETY FUNCTION REINTEGRATED != MACHINE-LEVEL PHYSICAL PROPOSITION FRESH.**

**REINTEGRATION ACKNOWLEDGED != RESET/REARM AUTHORIZED != ORDINARY START AUTHORIZED.**

## Monotonic recovery rule — strengthened

During asynchronous recovery, each transition must carry named evidence. A transition may remove only the blockers whose acceptance criteria that evidence actually satisfies.

Example:

`connection faulted -> transport restored -> safety connection valid -> device fault cleared -> reintegration eligible -> acknowledgement accepted -> field witness reacquired -> affected PROP-* fresh -> open FIND/VAL obligations closed -> reset/rearm eligible -> fresh ordinary demand`

A later state must not be inferred merely because the preceding state became healthy. Device-specific automatic reintegration is allowed only where the device/application design explicitly permits it; it is not a generic curriculum default.

## Learner exercise A — shared field-power supply common cause

### Scenario

A machine has three nominally separate safety inputs:

- `SF-GUARD-A` — front guard interlock;
- `SF-GUARD-B` — rear guard interlock;
- `SF-ESTOP-REMOTE` — remote E-stop station.

Each has separate field wiring and separate safety-input channels, but all three devices receive their 24 V field power from `DEP-PS24-SAFETY-A`. The safety controller itself remains powered. `DEP-PS24-SAFETY-A` drops out and later returns.

### Required dependency records

- `DEP-PS24-SAFETY-A -> EVID-GUARD-A-INPUT`
- `DEP-PS24-SAFETY-A -> EVID-GUARD-B-INPUT`
- `DEP-PS24-SAFETY-A -> EVID-ESTOP-REMOTE-INPUT`
- each `EVID-* -> PROP-*` that it supports
- each `PROP-* -> SF-*` that consumes that proposition

### Reverse show-where-used task

Starting only from `DEP-PS24-SAFETY-A`, enumerate every affected evidence record and proposition. Do **not** stop at the first channel that reports a diagnostic.

Expected reasoning:

- separate channels do not create independent evidence sources when their common field-power dependency is lost;
- pre-outage values cannot bridge the outage unless the evidence contract explicitly proves that behavior;
- restored supply voltage is evidence about the supply, not automatically fresh evidence about every powered physical device;
- each field witness is reacquired according to its own device/function contract;
- a shared supply can therefore invalidate several safety propositions simultaneously even though no individual sensor has failed.

Freeze:

**SEPARATE SAFETY CHANNELS != INDEPENDENT SAFETY EVIDENCE WHEN THEY SHARE A LOST DEPENDENCY.**

## Learner exercise B — power returns, guard geometry changed

### Scenario

A guard switch and actuator lose field power during maintenance. While de-energized, the guard door is struck and its hinge/bracket shifts. Power returns and the safety input electronics communicate normally.

SICK STR1 operating instructions require stable sensor/actuator mounting, prohibit using the sensor/actuator as a mechanical stop, require the closed guard to place sensor and actuator within the assured switch-on distance, and require checking effects on safe sensing distances where mounting conditions can affect them.

Source: https://www.sick.com/media/docs/5/45/245/Operating_instructions_STR1_en_IM0068245.PDF

Claim class: `DOC-CONFIRMED`.

### Required reasoning

Power/network recovery proves neither mounting integrity nor unchanged guard geometry. The recovered input is interpreted only within its validated installation envelope. If a post-outage mechanical event could have changed that envelope, the installation/geometry proposition becomes stale or `UNKNOWN` until inspected/revalidated according to the design and manufacturer requirements.

Do not invent a millimeter tolerance for the machine. Use the actual device specification and installation acceptance criteria.

Freeze:

**ELECTRONICS RECOVERED != MECHANICAL INSTALLATION UNCHANGED.**

**OSSD/INPUT HEALTHY != GUARD GEOMETRY VALIDATED.**

## Robot / automated-cell transfer

The method transfers to cells, but robot-specific safe-motion truth must come from the actual safety design and robot documentation.

Possible proposition families include:

- access safeguard/interlock state;
- personnel-clear / trapped-person prevention where the architecture requires it;
- safety-controller and safety-network validity;
- robot/axis safe-state or safe-motion status where explicitly provided by the safety system;
- hazardous auxiliary energy states (pneumatic tooling, conveyors, positioners, weld/process energy, etc.);
- cell reset/rearm eligibility;
- fresh production demand after safety recovery.

A robot controller reporting READY, AUTO, program loaded, or ordinary network healthy is ordinary-control evidence. It is not a substitute for the cell's independent personnel-safety propositions.

A safety network becoming valid can make fresh safety data available; it does not prove a person left the cell, a trapped key was returned, a gate is mechanically aligned, an auxiliary hazard is de-energized, or a production-start demand is fresh.

Freeze:

**ROBOT/CONTROLLER READY != CELL PERSONNEL-SAFETY READY.**

**CELL SAFETY RESET != ROBOT PRODUCTION START.**

## Failure-path review

- Safety Ethernet cable unplugged/replugged: require documented connection/reintegration semantics; do not infer start permission from link-up.
- PROFIsafe/CIP Safety connection valid but field device remains faulted: keep the affected proposition blocked.
- Connection and field device recover but an open `FIND-*` requires physical inspection/re-proof: keep return-to-service blocked.
- Shared field supply returns: reverse-trace all dependent evidence; reacquire each required witness.
- Guard electronics recover after mechanical impact: installation proposition is stale/unknown until appropriate inspection/revalidation.
- Cell safety recovers while robot controller retained AUTO and a cycle request: discard stale ordinary demand according to the machine's demand-freshness contract; require a fresh post-recovery production demand.

## Human-factors rule

Do not collapse `NETWORK OK`, `SAFETY DEVICE OK`, `SAFETY RESET REQUIRED`, `PHYSICAL VALIDATION REQUIRED`, and `READY — NEW START REQUIRED` into one generic green/red indicator. Operators and maintainers should be able to see what evidence is missing and what action is legitimate. Ambiguous recovery indications encourage repeated reset attempts and bypass behavior.

## New freezes

- **SAFETY CONNECTION VALID != SAFETY FUNCTION REINTEGRATED.**
- **SAFETY FUNCTION REINTEGRATED != MACHINE-LEVEL PHYSICAL PROPOSITION FRESH.**
- **REINTEGRATION ACKNOWLEDGED != RESET/REARM AUTHORIZED != ORDINARY START AUTHORIZED.**
- **SEPARATE SAFETY CHANNELS != INDEPENDENT SAFETY EVIDENCE WHEN THEY SHARE A LOST DEPENDENCY.**
- **ELECTRONICS RECOVERED != MECHANICAL INSTALLATION UNCHANGED.**
- **OSSD/INPUT HEALTHY != GUARD GEOMETRY VALIDATED.**
- **ROBOT/CONTROLLER READY != CELL PERSONNEL-SAFETY READY.**
- **CELL SAFETY RESET != ROBOT PRODUCTION START.**

## Evidence classifications and unknowns

Manufacturer-specific connection/passivation/reintegration behavior above is `DOC-CONFIRMED` only for the cited products/families. The generalized evidence-state method and reverse-dependency method are `INFERENCE` grounded in those professional patterns and the existing course evidence model. Exact machine PL/SIL targets, safety reaction times, reset topology, sensing distances, stopping distances, hydraulic/pneumatic truth tables, robot safe-motion functions, and proof intervals remain `UNKNOWN` until machine-specific evidence establishes them.

## Compute decision

No executable compute is justified. The unresolved questions in this branch are design/evidence-composition questions answered by authoritative manufacturer documentation. No GitHub-hosted runner was used. A future executable lab is justified only for a concrete device/configuration behavior not adequately resolved by source/documentation; it must target `[self-hosted, openpressbrake]`.
