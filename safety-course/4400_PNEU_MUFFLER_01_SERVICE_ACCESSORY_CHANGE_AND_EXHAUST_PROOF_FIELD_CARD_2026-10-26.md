# 4400 PNEU-MUFFLER-01 — a quiet exhaust is not a proved safe exhaust
Date: 2026-10-26. **Practical non-blind field card; documentary gates NOT RUN; no personnel-exposed test authorization.**

Prerequisites: [2026-10-24 pneumatic exhaust audit](../research/4400_PNEUMATIC_SAFE_EXHAUST_VARIANT_RESET_TRAPPED_VOLUME_SCOPE_AUDIT_2026-10-24.md) and [2026-10-26 manufacturer reconciliation](../research/4400_PNEUMATIC_EXHAUST_SILENCER_CLOG_MAINTENANCE_DRIFT_OEM_RECONCILIATION_2026-10-26.md). The earlier PA-03 already addressed replacement restriction. This card teaches **how to keep that safety function correct after routine maintenance**, not a new valve invention.

## Learning objective

A technician or fresh AI must distinguish (1) a deenergized valve, (2) an unrestricted exhaust path, (3) all relevant pressure zones actually safe, (4) a gravity/spring/vacuum load remaining controlled, and (5) deliberate restart. An electrical 'safe' light proves none of (2)–(5) without separate evidence.

## Five paper-only change scenarios (unscored)

1. **Quieter replacement:** A maintenance technician fits a compact aftermarket silencer with matching threads. Identify why threads and noise reduction do not establish equal exhaust capacity; mark safety validation STALE until exact part/flow and physical consequences are reviewed.
2. **Gradual contamination:** Over months the machine's valve feedback remains green, but a clamp retracts more slowly after E-stop. Do not blame LinuxCNC latency without evidence; inspect exhaust accessory, trapped chambers, pressure, and mechanical loads through qualified no-energy maintenance and subsequent approved validation.
3. **Cleaned but not qualified:** A silencer is cleaned and visually clear. Explain why visual cleanliness does not establish its original flow characteristics, selected safety response, or safe exposure.
4. **Fast vent, falling workpiece:** A vacuum or pneumatic gripper drops a suspended part when the valve vents faster. Explain why 'maximum exhaust speed' is not a universal safe-state requirement; require independent part retention.
5. **False all-clear:** A PLC pressure switch at the valve outlet reads low while an actuator remains loaded behind a check valve. Identify missing pressure-zone witness and hold access.

These are public learner prompts, **not blind external evaluations** and not scored. Do not include hidden answer keys or fabricated outcomes.

## Eight no-energy documentary gates — ALL NOT RUN

| Gate | Qualified reviewer must establish | Initial status |
|---|---|---|
| M1 | Actual machine, task, exposed person and all relevant pneumatic/vacuum energy zones identified | NOT RUN |
| M2 | Exact safety valve, exhaust accessory, remote vent, part numbers and OEM revision matched to as-built | NOT RUN |
| M3 | Exhaust accessory's manufacturer-required flow capacity and service/contamination instructions met | NOT RUN |
| M4 | Downstream check valves, accumulators, branch isolation, cylinders and bypasses traced | NOT RUN |
| M5 | Loss of pressure **and** retained pressure load consequences separately documented | NOT RUN |
| M6 | Independent safety controller/final element and normal LinuxCNC/FPGA boundary verified | NOT RUN |
| M7 | Physically independent pressure/load/stopping witness and acceptance criteria selected by qualified designer, no guessed values | NOT RUN |
| M8 | Maintenance LOTO, guard restoration, change control, revalidation and fresh deliberate START specified | NOT RUN |

## Practical architecture to teach

`Ordinary LinuxCNC/FPGA -> normal actuator commands and diagnostics`

`Independent safety demand -> qualified safety controller -> selected final exhaust/hold elements -> actual pressure/load state`

`Accessible lockable isolation + independent mechanical retention + zone-specific safe-energy verification -> maintenance permission`

Use labelled, replaceable, approved silencer assemblies in reachable locations and keep the correct spare; a hard-to-access exhaust fitting that invites improvised replacement is a design flaw. Use guarded, visible pressure-test points selected for the relevant pressure zones; never assume a single gauge or valve status proves every branch. No safety authority moves to LinuxCNC, HAL, the ordinary FPGA, a PC watchdog, or an HMI green light.

## Machine transfer and release

- **Pneumatic feeder/robot cell:** potentially relevant, pending actual valve/zone/load documentation.
- **Press-brake pneumatic accessories:** potentially relevant only if installed; not evidence for hydraulic ram Y1/Y2.
- **Hydraulic press brake:** hydraulic return restriction may also matter but **cannot** inherit pneumatic manufacturer performance claims.
- **OpenPressBrake selected machine:** UNKNOWN; G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.

**No physical test, lab, benchmark, simulation or evaluator score occurred.** Escalate to a qualified reviewer before any personnel exposure. If basic stop/hold/guard/isolation is unproven, the machine must not be operated with people exposed; experimental operation, if justified, must be isolated/remote with everyone outside the danger zone and residual risk recorded.
