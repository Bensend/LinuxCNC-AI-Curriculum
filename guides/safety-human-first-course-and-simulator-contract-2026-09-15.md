# Human-First Safety Course + Fault-Injection Simulator Contract — 2026-09-15

## Purpose

The Practical Machine Safety Engineering course has a stronger human-audience requirement than the AI-first LinuxCNC curriculum. The evidence layer remains rigorous, but the learner-facing layer must teach a DIY builder, technician, maintainer, electrician, or engineer to *see the hazard, understand the failure, choose an affordable protection, and prove that it worked*.

Owner principle: **there is always an inexpensive way to be safe.** This does not claim every machine can cheaply retain every desired capability while people remain exposed. The inexpensive safe answer may be isolation, guarding, energy removal, remote testing, or refusing attended operation until the hazard is controlled.

## Presentation policy

Standards and exact manufacturer documentation remain important evidence sources, but standards citations are intentionally kept mostly under the hood in the human-facing lessons. Do not lead a DIY lesson with compliance language or standards numbers when a physical explanation will teach the mechanism better. Surface standards explicitly when the learner is doing formal validation/compliance work or when a precise requirement materially matters.

Human lesson order:

**See the hazard -> predict what could hurt someone -> choose a simple protection -> see the authority/energy path -> inject a fault -> observe the physical consequence -> repair it -> verify reset/restart behavior -> state residual risk.**

A technically correct lesson that a normal machine builder is unlikely to understand or follow is not ready to graduate.

## Three-layer artifact model

1. **Human lesson:** plain language, diagrams, machine scenarios, inexpensive choices, visible failure consequences, troubleshooting and commissioning checks.
2. **Engineering reference:** circuits, architecture, failure analysis, calculations, validation method, assumptions and physical safe-state definition.
3. **AI/evidence layer:** provenance, source traces, claim labels, contradictions, UNKNOWNs, exact manual/source revision and adversarial evaluation.

Do not make the human learner traverse the AI evidence ledger to learn the lesson.

## External teaching-pattern evidence

- `DOC-CONFIRMED` — Pilz's public PNOZ Maintenance Workshop explicitly teaches E-stop wiring, positive-guided versus standard relays, status indicators, fault simulation/troubleshooting, and external contactors. This validates deliberate fault injection as a real industrial teaching pattern, not a synthetic curriculum gimmick. Source: https://www.pilz.com/en-US/trainings/articles/198434 (accessed 2026-09-15).
- `DOC-CONFIRMED` — Pilz PNOZmulti training uses practical exercises for E-stop, guards, light curtains, speed monitoring, diagnostics and troubleshooting. Source: https://www.pilz.com/en-US/trainings/articles/196872 (accessed 2026-09-15).
- `DOC-CONFIRMED` — Rockwell SAF-COM101 uses hands-on exercises for monitoring relays, E-stops, enabling switches, interlocks, non-contact switches, light curtains/sensors, safety mats, wiring faults and safety outputs, and provides a troubleshooting flowchart. Source: https://www.rockwellautomation.com/en-pr/support/workforce-development-training/instructor-led/safety-relays-devices-maint-trblsht-saf-com101.html (accessed 2026-09-15).

Borrow the *teaching pattern and publicly documented behavior*, not proprietary course text/slides.

# Safety Logic Simulator

## Scope

Build a browser-capable, deterministic **logic-level safety training simulator**, not a physics simulator and not a safety design/certification tool. It should be cheap to run, easy to inspect, and usable without real hazardous machinery.

The first version needs no LinuxCNC VM, SPICE, hydraulic model, or realtime compute. A small event/state engine is sufficient for discrete safety logic. Physics-dependent facts such as stopping time, hydraulic pressure decay, gravity load holding, contactor opening time and actual PL/SIL remain explicit scenario inputs or UNKNOWNs; the simulator must never invent them.

## Core objects

- E-stop NC channel(s)
- guard/interlock switch channel(s)
- reset pushbutton
- ordinary relay
- monitoring safety relay
- force/positive-guided feedback contact model
- external contactor K1/K2
- EDM/feedback loop
- drive STO A/B channels
- ordinary LinuxCNC request/status witness
- FPGA/Mesa ordinary I/O witness
- hazardous-energy/actuator authorization node
- guard/access state
- optional process-energy source (spindle, plasma/laser, hydraulic valve authority, robot/cell motion)

Every object has an actual physical/logical state distinct from commanded state.

## Required authority model

Never collapse these into one Boolean:

**ordinary-control request -> safety input state -> safety authorization -> energy-removal device state -> physical hazardous-energy state -> diagnostic witness**

LinuxCNC may request reset/stop and display diagnostics. It must not be silently promoted to sole personnel-safety authority.

## Fault injection library — first release

- broken input wire
- shorted/bypassed guard channel
- channels tied together/common-cause short
- E-stop contact stuck closed/open
- ordinary relay contact welded
- K1 welded
- K2 welded
- EDM/feedback contact stuck or miswired
- reset button held/stuck
- automatic-reset jumper substituted for deliberate reset
- STO channel A stuck asserted
- STO channel B stuck asserted
- LinuxCNC frozen
- Ethernet/control link lost
- FPGA ordinary output stuck/request stale
- diagnostic/status wire failed while physical safety path still works
- physical energy-removal device fails even though its command says OFF

Each scenario defines whether the fault is detectable, what inhibits reset/restart, what remains energized, what LinuxCNC can observe, and what must be physically validated.

## Component swapping / cost challenge

The learner may swap architectures/components, including a cheap ordinary relay, redundant ordinary relays, a monitoring safety relay, redundant contactors with feedback, and drive STO where applicable.

The simulator must **not** encode `cheap = unsafe` or `expensive = safe`. It scores the architecture against the scenario's hazard/failure requirements. An inexpensive architecture can win when it controls the actual hazard; an expensive architecture can fail when it leaves a physical failure path uncontrolled.

Working challenge format:

> Make this scenario safe for the lowest practical cost while preserving the stated operating needs.

Score dimensions:
- hazard actually controlled;
- single-fault behavior for faults declared in the exercise;
- detectable mismatch/fault diagnostics;
- deliberate reset and restart behavior;
- resistance to easy/incentivized bypass;
- clarity/maintainability;
- cost.

Do not assign PL/SIL/category scores from the simulator unless a separate evidence/calculation/validation workflow actually supports them.

## Human interaction loop

1. Show a simple machine and highlight the hazard zone/energy source.
2. Ask the learner to predict what E-stop/guard action should physically accomplish.
3. Let the learner build/select the protection path.
4. Run normal behavior.
5. Inject one visible or hidden fault.
6. Ask the learner whether the machine is safe to reset/restart.
7. Reveal signal/physical-state witnesses progressively rather than dumping a truth table.
8. Let the learner troubleshoot and change the architecture.
9. Run the same fault again.
10. Explain the mechanism in plain language, then expose the engineering/evidence layer on demand.

## First five scenarios

### SIM-SAFE-01 — Mill spindle / welded contactor
Learns command OFF != physical energy removed; K1/K2 feedback; reset inhibition; LinuxCNC diagnostic witness.

### SIM-SAFE-02 — Router guard / bypassed switch
Learns guard usability, defeat incentive, dual-channel/common-cause limits, deliberate restart.

### SIM-SAFE-03 — VFD STO / LinuxCNC freeze
Learns ordinary control versus independent torque-removal authority and why software E-stop alone is insufficient. Also teaches that STO is not a mechanical brake and must not be generalized to gravity/load retention.

### SIM-SAFE-04 — Plasma source / process energy
Learns motion-safe does not necessarily mean process-source-safe; separate motion and process energy authorities.

### SIM-SAFE-05 — Hydraulic/gravity actuator
Learns electrical command removal does not prove stored hydraulic/gravitational energy is controlled. No machine-specific valve truth table or stopping claim may be invented. If the scenario cannot establish a safe physical state, attended exposure is prohibited; remote/isolation mode is the inexpensive safe path.

## Simulator graduation test

The simulator is successful only if a learner can transfer the mental model to a novel machine and answer:

- What can hurt me?
- What physically prevents it?
- What happens when one thing fails?
- How do I know the machine actually reached the intended safe state?
- Why can/can't it reset?
- What could someone easily bypass, and why would they be tempted to?
- What is the cheapest practical change that removes unacceptable exposure?

A learner who merely memorizes that a named safety relay is 'good' has failed the lesson.

## Compute decision

No compute/lab is justified for this design pass. The unresolved work is curriculum/interface design and evidence acquisition. A future prototype can be static HTML/JS or a small deterministic state engine and can be tested locally; it must not consume GitHub-hosted runner minutes. If CI-style execution is later useful, target only `[self-hosted, openpressbrake]`.
