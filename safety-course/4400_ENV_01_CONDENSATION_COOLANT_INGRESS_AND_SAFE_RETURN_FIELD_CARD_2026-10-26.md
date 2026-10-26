# 4400 ENV-01 — cabinet condensation, coolant ingress and safe return to service

**Status:** NON-GRADUATED, practical no-energy lesson. **Eight public PAPER cases UNSCORED**, **eight documentary gates NOT RUN**; no physical tests or independent evaluation.

**Prerequisite source:** [nVent HOFFMAN / Rittal / Rockwell original manufacturer audit](../research/4400_ENV_01_NVENT_RITTAL_ROCKWELL_CONDENSATION_ENCLOSURE_SAFETY_BOUNDARY_AUDIT_2026-10-26.md). Prior electrical isolation, PWR-01, IMD-01, reset/rearm, LOTO and machine-specific physical stop/hold lessons remain authoritative.

## Core teaching

A cabinet may be apparently well sealed yet experience **condensation during thermal cycling**. nVent HOFFMAN warns that rapid internal cooling can create suction at gaskets; water can also condense on interior surfaces. A heater/vent may reduce risk but is not a substitute for qualified safety devices and mechanical energy control. **Do not assume wet circuits fail safe, or that a dry-looking cabinet is safe.** Actual fault polarity is circuit-specific.

### Boundary checklist

| What is being observed? | What it can establish | What it cannot establish |
|---|---|---|
| IP label on an empty enclosure | Rated ingress performance of specified enclosure/test configuration | Absence of internal condensation; retained rating after added holes/glands/vents |
| Humidity or cabinet-temperature telemetry | Conditions at that sensor and time | Insulation integrity at every safety terminal |
| Heater on/thermostat green | Ordinary climate-control state | Safety relay operation or safe machine stop |
| Safety relay LED | A specific electronic/control status | Physical Y1/Y2 hold, pressure isolation, conveyor stop or guard coverage |
| Independent physical stop/hold validation | Selected physical proposition under recorded conditions | Other untested modes, maintenance exposure or stale configuration |

### Eight public technician scenarios — UNSCORED

| ID | Situation | Required decision and evidence |
|---|---|---|
| ENV-P01 | Overnight temperature drop; droplets inside high-IP panel. | Explain condensation/suction mechanism; isolate equipment; do not energize to “dry it out.” |
| ENV-P02 | HMI green after cabinet washdown; relay terminal has residue. | Reject HMI as insulation/safety proof; qualified inspection and independent stop/hold review. |
| ENV-P03 | Technician proposes drilling an unprotected drain hole. | Require enclosure/gland/vent assembly rating and change control, not an improvised opening. |
| ENV-P04 | New heater is connected to the safety output circuit for convenience. | Separate ordinary climate power/control from independently justified safety function. |
| ENV-P05 | Relay catalog says 90% RH, so owner claims visible water droplets are allowed. | Distinguish humidity rating from uninspected condensation tolerance and selected installation. |
| ENV-P06 | Cabinet door left propped open after service to prevent fogging. | Restore seals and practical access/thermal management; prevent normal operation with compromised protection. |
| ENV-P07 | Same moisture affects safety input and normal DAQ input. | Trace common cause, avoid “two sensors = independence” assumption, require exact circuit evidence. |
| ENV-P08 | Repaired gasket and dry cabinet; automatic restart resumes old motion. | Enforce independent reset, fresh start, physical safe state and change-triggered revalidation. |

### Eight documentary gates — NOT RUN

| Gate | Evidence required before selected-machine release |
|---|---|
| ENV-G01 | Machine/environment exposure and exact enclosure model, IP/IK/corrosion rating, edition and installed modifications |
| ENV-G02 | Exact safety-device environment limits, mounting enclosure and wiring/terminal requirements |
| ENV-G03 | Glands, drains, vents, heaters, thermostat, filters, gaskets and power/earth protections documented as installed |
| ENV-G04 | Moisture/coolant/dust entry and condensation/common-cause hazard analysis; unknown fault polarity explicit |
| ENV-G05 | Practical no-energy inspection, qualified isolation/LOTO and remediation procedure |
| ENV-G06 | Independent safety-function and physical stop/hold witness plan after contamination/repair |
| ENV-G07 | Deliberate restart, fresh-command gating, guard restoration and change invalidation |
| ENV-G08 | Independent evaluator's unseen precommitment and scored transfer, no hidden answers leaked |

**Do not run moisture-injection or energized fault tests on production machinery.** A qualified machine-specific validation may be considered only after hazards and isolation are established. If basic safe-to-operate requirements are not met, no people may be exposed to hazardous operation; any experimental work must be isolated/remote with residual risk documented.

## Source, uncertainty and change control

**DOC-CONFIRMED:** nVent *Technical information* p. 9 cooling suction, condensation and corrosion; Rittal manufacturer enclosure-heater/dew-point statement; Rockwell exact 440R-N23114 catalog IP40 relay / IP20 terminals / minimum IP54 mounting enclosure and 90% RH rating. **INFERENCE:** particular moisture-induced electrical faults and ergonomic mitigation. **UNKNOWN:** actual OpenPressBrake cabinet, safety relay, humidity, terminal state, electrical fault response, PL/SIL and Y1/Y2 physical stop/hold. **SOURCE-CONFIRMED new LinuxCNC none; TEST-CONFIRMED none; COMMUNITY-REPORTED none relied on.**

In the cumulative Safety Design Package, link selected-machine `BND/ENE/HAZ/SF/PHY/SRS/AUTH/DEP/HF/ARC/VAL/PT/CHG/RR/UNK` only after qualified evidence. New cabinet opening, cooling fan, heater, seal, washdown or sensor replacement is a `CHG` candidate. **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.**
