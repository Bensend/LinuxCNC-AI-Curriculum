# Power-Recovery Transition Worksheet

Use this worksheet after whole-machine, partial-domain, field-power, safety-I/O, controller, drive, or ordinary-control power interruption. It is an evidence worksheet, not a universal circuit prescription.

## Event identity

- Event / FIND ID:
- UTC detected:
- Power domain(s) lost:
- Power domain(s) that remained alive:
- Recovery order observed:
- Machine mode at interruption:
- Hazardous energy present / potentially present:
- Containment currently in force:

## Transition record

Complete one row for every recovery transition. Do not skip directly from `POWER PRESENT` to `READY`.

| From -> To | Authority permitting transition | Required evidence / witness | Evidence status (`FRESH`, `STALE`, `UNKNOWN`, `N/A`) | Held/retained ordinary demand disposition | Open FIND/PROP/VAL blockers | What remains UNKNOWN? | Allowed result |
|---|---|---|---|---|---|---|---|
| outage -> safe-inhibited | independent safety architecture | | | neutralize / irrelevant | | | no production motion |
| safe-inhibited -> diagnostic-valid | safety controller/I/O | | | stale | | | diagnostics only |
| diagnostic-valid -> obligation-reviewed | durable safety ledger / authorized review | | | stale | | | no implicit clearance |
| obligation-reviewed -> reset-eligible | validated safety architecture | | | stale | | | reset may become eligible |
| reset-eligible -> rearmed | independent safety authority | | | stale | | | safety permission only |
| rearmed -> production-demand-required | ordinary control after safety permission | | | must remain neutral | | | await fresh demand |
| production-demand-required -> ordinary run | ordinary machine control, while safety conditions remain satisfied | fresh post-recovery demand | | must be demonstrably fresh | none that block service | | ordinary run permitted |

## Field-device / safety-I/O power-loss review

A controller remaining alive does not make a de-energized field witness valid. For each affected input/output record:

| Device / channel | Lost field power? | Module/controller diagnostic | Physical witness reacquired? | Prior state allowed to bridge outage? | Proposition(s) depending on it | Disposition |
|---|---:|---|---:|---:|---|---|
| | | | | | | |

Rules:
- **CONTROLLER LOGIC SURVIVED != FIELD WITNESS SURVIVED.**
- **COMMUNICATION RESTORED != PHYSICAL WITNESS REACQUIRED.**
- **FIELD-POWER FAULT CLEARED != MACHINE-LEVEL SAFETY PROPOSITION REVALIDATED.**
- If the architecture cannot establish whether a required witness remained valid, mark it `UNKNOWN`; do not infer its pre-outage state.

## Brownout / recovery-order adversarial check

For each domain, record whether it can return before the others and whether that return can assert an output, reconstruct a command, clear a fault, or make a stale signal appear valid.

| Domain | Can recover first? | Retains state? | Can independently energize/permit anything? | Required inhibit until | Fresh evidence required |
|---|---:|---:|---|---|---|
| independent safety controller | | | | | |
| safety I/O / field-device supply | | | | | |
| ordinary FPGA / remote I/O | | | | | |
| LinuxCNC / HMI | | | | | |
| drive / actuator control supply | | | | | |
| process power / hydraulic / pneumatic energy | | | | | |

Recovery should be monotonic toward **inhibition** when evidence is absent: an earlier-restored domain must not borrow stale readiness from a later or still-dead domain.

## Machine-physics proposition check

Name the actual proposition rather than copying a generic device status.

- Press brake / gravity axis example proposition: __________________________________
- Spindle machine example proposition: ___________________________________________
- Plasma/router example proposition: _____________________________________________
- Witness proving this machine-specific proposition: ______________________________
- Acceptance criterion/source: ___________________________________________________

Do not invent stop distance, pressure, brake capacity, safe speed, PL/SIL, proof interval, or hydraulic truth table here. Record `UNKNOWN` until the machine-specific design/source/measurement establishes it.

## Final release questions

1. Did every affected safety authority recover according to its validated design?
2. Were durable open findings and stale evidence reconciled rather than erased by restart?
3. Were affected physical witnesses reacquired after their power returned?
4. Is any required proposition still `STALE` or `UNKNOWN`?
5. Was reset/rearm kept distinct from ordinary start?
6. Were pre-outage, held, queued, retained, or reconstructed demands neutralized?
7. Is the production demand demonstrably fresh after recovery?
8. Is a human exposed to a hazard whose safe condition has not been proved? If yes, do not operate with personnel exposed; isolate/remote experimental operation only under an appropriate controlled plan.
