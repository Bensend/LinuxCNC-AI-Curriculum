# 4400 HYD-INT-01 — A blocked return can multiply local pressure
**Public technician field module / NON-GRADUATED.** Evidence: [original ROSS + Aggressive Hydraulics audit](../research/4400_HYD_INT_01_ROSS_AGGRESSIVE_HYDRAULICS_TRAPPED_ROD_SIDE_PRESSURE_INTENSIFICATION_AUDIT_2026-10-27.md). 2026-10-27. All paper exercises **UNSCORED**; all gates **NOT RUN**.

## What the learner must do
Distinguish **normal controller stop**, **hydraulic isolation**, **physical load retention**, **local overpressure protection**, and **safe maintenance**. Given a schematic, identify which *actual volume* is trapped, what forces act on the piston, which sensor/relief can reach that volume, and whether both Y1/Y2 axes remain restrained. Do not guess a valve truth table or safe pressure.

### Paper scenarios — eight UNSCORED, not machine tests
1. A pump relief is set below a hose's nameplate rating. The rod chamber is blocked during extension. Explain why the pump relief alone is not a proof of safe rod-side pressure; identify required missing geometry and paths.
2. A pressure sensor is mounted on the pump manifold, upstream of a shutoff. Identify which trapped chamber it **cannot** observe and why a zero pump gauge is not a service permit.
3. A dual-axis press ram stops when a safety output opens. One Y cylinder is restrained; the other has an unverified external load path. Explain why an output state and a single-axis pressure switch do not prove parallel ram stop/hold.
4. A designer proposes `block rod port + bleed cap port` after reading ROSS. Explain how the correct safe state depends on load direction, hydraulic circuit and gravity retention, and why the manufacturer's example is not a press-brake schematic.
5. A service technician replaces a single-rod cylinder with a different rod diameter but the same bore and stroke. Derive qualitatively what happens to `A_ann` and the intensification ratio, and identify all stale design evidence.
6. A disconnected quick coupler blocks the return. Classify the hazards without connecting/disconnecting any energized coupling, and identify the correct qualified isolation boundary.
7. A new directional valve has an unexpected de-energized spool path. Identify the safety SRS/DEP/PHY/VAL items that must be reopened before commissioning.
8. A HMI shows STOP and `pressure normal` while an internal rod-side volume is isolated. Explain the distinction between a controller proposition and physical safety; propose evidence that could falsify a claimed safe state.

### Documentary gates — eight NOT RUN
| Gate | Evidence requested | Fail / hold if |
|---|---|---|
| INT-G1 | As-built Y1/Y2 port and chamber map, signed by qualified reviewer | Any chamber/valve path UNKNOWN |
| INT-G2 | Bore/rod/area and external-load directions for every actuator | Ratio or force basis absent |
| INT-G3 | Selected cylinder/seal/head and hose/fitting/manifold ratings | Local pressure rating assumed from pump |
| INT-G4 | Every isolating valve, check, pilot and relief path, including de-energized state | Trapped volume cannot be traced |
| INT-G5 | Physical stop/hold/gravity restraint for both Y axes independent of LinuxCNC | CNC status used as proof |
| INT-G6 | Service isolation, stored-pressure verification, accessible guarding | Single gauge or pump OFF accepted |
| INT-G7 | Fault/common-cause analysis for blocked return, leakage, reversed port and change | No credible fault witness |
| INT-G8 | Qualified validation and deliberate restart/rearm plan | Hazardous test or unverified auto-restart proposed |

## Practical safe-by-default design review
Choose accessible, labeled, inspectable valve blocks; use keyed/documented connections where feasible; avoid inaccessible adjusters and improvised plugged lines. Make pressure-zone diagrams and mechanical support easy to find at the machine. A safeguard that requires nuisance-prone troubleshooting invites bypass; redesign the workflow **without bypassing** independent safety functions. When stop/hold cannot be independently established, no personnel-exposed hazardous operation; experimental work requires isolated/remote operation and explicit residual-risk control.

## Handoff / uncertainty
No physical tests, no LinuxCNC runtime, no safety score. Actual OpenPressBrake Y1/Y2 cylinders, valve paths, pressures, pressure ratings and safe states **UNKNOWN**. A fresh evaluator must present a new circuit and withhold its independent solution until immutable learner precommitment. [Crosscut design review](4400_HYD_INT_CUSH_01_02_STOP_HOLD_LOCAL_PRESSURE_CHANGE_REVIEW_2026-10-27.md). **G0/G1 HOLD.**
