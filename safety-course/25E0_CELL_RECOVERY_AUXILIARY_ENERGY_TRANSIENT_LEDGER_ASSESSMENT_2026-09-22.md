# 25E0 — Cell Recovery, Auxiliary Energy, and Transient Evidence Ledger

Date: 2026-09-22
Status: learner-facing 4000 safety-course material

## Purpose

Turn the accumulated recovery/reintegration notes into one worked cell-level adversarial exercise. The exercise deliberately separates communication recovery, device diagnostics, personnel-clear evidence, auxiliary pneumatic/tooling energy, final-element/process evidence, reset/rearm, and fresh ordinary start.

This is a reasoning/architecture lesson, not a machine-specific pneumatic design. No pressure threshold, stopping distance, PL/SIL target, proof interval, valve truth table, or robot-specific safe state is invented here.

## Evidence labels

- **DOC-CONFIRMED — ABB, HMI reset/start guidance:** manual reset is a separate deliberate action, is accepted only when safeguards/safety functions are operative, does not itself initiate hazardous motion, and enables acceptance of a separate start command.
  - https://new.abb.com/low-voltage/products/safety-products/using-an-hmi-for-reset-and-start
- **DOC-CONFIRMED — ABB OmniVance Collaborative Machine Tending operating manual:** the cell E-stop affects the unit and external equipment; pneumatic grippers/equipment may retain stored pneumatic energy; E-stop reset requires checking external equipment readiness; protective-stop reset requires the area to be clear; a standard cycle start is separate from reset.
  - ABB document 4GAA135009912-001, Revision B, 2025, section 5.4.
- **DOC-CONFIRMED — Festo safe pneumatics:** Festo distinguishes safe de-energization (SDE), safe energization (SEZ), prevention of unexpected start-up (PUS), STO-like pneumatic drive de-energization, stopping/blocking functions, and explicitly says application safety must be evaluated at system level.
  - https://www.festo.com/us/en/e/solutions/safety-and-sustainability/machine-safety/safe-pneumatics-id_4562
- **DOC-CONFIRMED — Festo Safety Engineering Guidelines:** a double-channel exhausting example uses a pressure switch to diagnose exhausted status and explicitly states the soft-start valve alone is not a complete safety solution.
  - Festo `Safety engineering guidelines. Pneumatic and electric solutions`, page 40.
- **DOC-CONFIRMED — Festo pneumatic actuator safety manual:** proof of a valve/actuator safe position can require final-position feedback and physical parameters such as angular position, transition time, or chamber pressure depending on the safety proposition being proved.
  - Safety Manual SMA202101, v1.0, 24 May 2021.

## Adversarial cell scenario

A robot/machine-tending cell has these intentionally generic elements:

- robot motion authority;
- guarded/perimeter access and a personnel-clear/reset station;
- a pneumatic gripper or tooling circuit capable of retaining energy;
- a safety communication path between safety controller and remote safety I/O/device;
- ordinary LinuxCNC/robot/HMI production control;
- a durable safety/maintenance evidence ledger.

Initial accepted state: the cell was previously validated for its actual design. During production the safety connection to remote I/O is lost. Safety action occurs according to the actual validated design. The communication path later returns. Device diagnostics become healthy. The ordinary controller also reports READY.

At that moment two propositions are unresolved:

1. whether the protected cell is personnel-clear for reset/rearm;
2. whether the auxiliary pneumatic/tooling hazard is in the physical state required by this cell's accepted safety design.

A physically held Cycle Start remains present from before the communication fault.

### Wrong conclusion

> The safety connection is back, the robot/controller is READY, and all I/O diagnostics are green, therefore reset the safety and resume the held cycle.

This conclusion improperly collapses transport, device, cell, physical-energy, personnel-clear, reset, and start authorities.

## Required proposition ledger

| ID | Proposition / dependency | Evidence during connection loss | Evidence after communication returns | Required disposition |
|---|---|---|---|---|
| DEP-NET-01 | safety communication transport | lost | restored | restoration only proves transport availability |
| EVID-NET-01 | current safety-connection/device data | `UNAVAILABLE` | `AVAILABLE-NOT-YET-ACCEPTED` until connection/device semantics are valid | may become `FRESH` for the proposition it actually witnesses |
| PROP-PERSONNEL-01 | protected cell is clear under the accepted reset procedure | historical evidence does not prove current occupancy | `UNKNOWN` until the required current personnel-clear action/witness occurs | blocks reset/rearm where the accepted design requires current clear confirmation |
| DEP-PNEU-01 | auxiliary pneumatic/tooling physical system | communication loss does not itself prove it changed | communication restoration does not prove its physical state | trace actual final element/process witnesses |
| EVID-PNEU-01 | valve/pressure/position evidence defined by the accepted design | may be `UNAVAILABLE`; may also become `STALE` if a physical event/change invalidated its baseline | reacquire the specific required witness; do not infer from network health | `FRESH`, `STALE`, or `UNKNOWN` must be explicit |
| PROP-PNEU-01 | auxiliary hazard is in the physical condition required for personnel-safe recovery | not proved merely by safety output/command | not proved merely by restored I/O | requires proposition-specific evidence from the real design |
| PROP-START-01 | ordinary production demand is fresh after recovery | pre-fault demand invalid for restart authority | held demand remains stale | require fresh post-recovery demand |

### `UNAVAILABLE` versus `STALE`

Connection loss normally makes a remote witness **unavailable**: the system cannot currently observe it. That does **not** prove the underlying physical proposition changed.

Evidence becomes **stale** when a physical/configuration event, contrary observation, maintenance action, elapsed proof obligation, or other declared invalidator makes the old accepted evidence non-representative. Therefore:

`communication lost -> EVID unavailable`

is not automatically:

`communication lost -> physical baseline stale`.

But if, during the outage, a gripper/tool is mechanically disturbed, pneumatic plumbing is serviced, a valve is replaced, pressure behavior is found abnormal, or another declared invalidator occurs, the relevant historical evidence can become `STALE` even after communications return.

## Reverse `show where used`

Worked dependency chain:

`DEP-PNEU-01 auxiliary pneumatic/tooling system`

→ `EVID-PNEU-01 accepted physical-state witness`

→ `PROP-PNEU-01 auxiliary hazard physically safe for the relevant recovery step`

→ `SF-CELL-ACCESS-01 / SF-CELL-RESTART-01` as applicable to the actual design

→ `VAL-CELL-RETURN-01 return-to-service acceptance`

A finding such as `FIND-PNEU-01 abnormal residual-energy/position evidence` must reverse-trace through this graph. It is not closed by restoring Ethernet, clearing a safety-I/O diagnostic, or observing a safe output command.

## Recovery state progression

1. **Transport recovered** — packets/connection can flow again.
2. **Safety connection valid** — protocol/device semantics satisfy the product's requirements.
3. **Device diagnostics valid** — the device reports the states it is qualified to report.
4. **Cell evidence reconciled** — `PROP-PERSONNEL-01`, `PROP-PNEU-01`, and every other affected proposition are explicitly `FRESH`, blocked, or `UNKNOWN`.
5. **Reintegration/return-to-service eligible** — only if the actual safety design permits it and blocking findings/validation obligations are dispositioned.
6. **Reset/rearm** — deliberate safety action; it is not production start.
7. **Fresh ordinary demand** — stale/held pre-fault start cannot bridge the recovery boundary.

## Why the pneumatic branch matters

Festo's material makes the physical boundary concrete without supplying a machine-specific answer. Safe de-energization, prevention of unexpected startup, safe stopping/blocking, and safe energization are distinct functions. Its example also adds a pressure switch specifically to diagnose exhausted status and warns that the valve alone is not a complete safety solution. Therefore the curriculum must not teach:

`safe electrical command -> no pneumatic hazard`.

The defensible form is:

`defined safety function -> defined final element -> defined physical/process proposition -> appropriate witness/proof -> acceptance`.

Exactly which pressure, position, force, exhaust state, blocking state, or combination is required remains **UNKNOWN until established by the actual machine risk assessment and validated design**.

## Human-factors attack

A tempting production shortcut is to let the HMI automatically re-enable the cell when network diagnostics return. That makes recovery convenient precisely by deleting the distinction between communication health and cell readiness.

Design the normal workflow so the safe path is easier:

- show *why* reset is blocked (`personnel clear unknown`, `tooling energy proof unavailable`, `open FIND-*`, etc.);
- guide the operator to the required witness/action instead of presenting a generic fault;
- preserve the blocking obligation across HMI/LinuxCNC restart;
- do not require obscure maintenance menus for ordinary legitimate recovery;
- make reset physically/logically distinct from production start;
- reject held pre-fault demand at the recovery boundary.

If the cell cannot establish the minimum personnel-clear and hazardous-energy propositions required by its design, it is not safe to resume exposed operation. Experimental operation must remain isolated/remote with people outside the danger zone and residual risk stated.

## Learner assessment

For the scenario above, the learner must:

1. classify each `EVID-*` item as `UNAVAILABLE`, `AVAILABLE-NOT-YET-ACCEPTED`, `FRESH`, `STALE`, or `UNKNOWN` at each transition;
2. identify which authority may declare transport healthy, device diagnostics valid, personnel clear, auxiliary-energy proposition accepted, reset/rearm complete, and production start authorized;
3. produce the `DEP -> EVID -> PROP -> SF -> VAL` reverse trace for one pneumatic finding;
4. explain why restored communication cannot close `FIND-PNEU-01`;
5. explain why a held Cycle Start cannot become effective at reintegration/reset;
6. name at least three machine-specific facts that must remain `UNKNOWN` rather than guessed.

### Passing criteria

A passing answer must preserve all of these boundaries:

- communication validity != physical energy proof;
- device diagnostic != cell-level acceptance;
- access/personnel clear != auxiliary-energy proof;
- reset/rearm != start;
- unavailable evidence != stale evidence;
- generic safety method != machine-specific physical truth.

## New freezes

- **SAFETY COMMUNICATION RECOVERED != CELL HAZARDOUS ENERGY PROVED SAFE.**
- **REMOTE I/O HEALTHY != AUXILIARY PNEUMATIC/TOOLING PHYSICAL STATE PROVED.**
- **PERSONNEL CLEAR != AUXILIARY ENERGY SAFE != RESET AUTHORIZED != START AUTHORIZED.**
- **UNAVAILABLE EVIDENCE != STALE EVIDENCE; STALE EVIDENCE != UNKNOWN EVIDENCE.**
- **SAFE EXHAUST/DE-ENERGIZATION COMMAND != REQUIRED PHYSICAL EXHAUST/ENERGY PROPOSITION PROVED.**
- **NETWORK RECOVERY MUST NOT REVIVE A HELD PRE-FAULT PRODUCTION DEMAND.**

## Consolidation decision

The recovery branch now has enough repeated material that further narrow notes have diminishing value. This artifact therefore acts as a consolidation/adversarial assessment for network loss, reintegration, evidence freshness, physical final-element proof, personnel-clear authority, and fresh start demand. Future work should extend the safety course into a different high-value safety-design branch unless a new recovery source exposes a material contradiction or missing dependency.
