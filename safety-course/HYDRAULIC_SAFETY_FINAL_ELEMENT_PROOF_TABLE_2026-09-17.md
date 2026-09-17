# Hydraulic Safety Final-Element Proof Table

Companion to `PROFESSIONAL_PRESS_HYDRAULIC_SCHEMATIC_TRACE_2026-09-17.md`.

This table prevents one observed state from being promoted into a stronger physical claim than it supports.

| Evidence / observation | Bounded claim it can support | Claim it cannot establish by itself |
|---|---|---|
| LinuxCNC/HAL valve command = 0 | ordinary controller requests zero command | coil de-energized; valve safe; pressure absent; ram restrained |
| FPGA output inhibited/watchdog tripped | ordinary FPGA output authority removed | independent safety action; valve state; physical isolation |
| Coil voltage/current = 0 | electrical actuator is not presently energized | spool/seat position; absence of trapped pressure; gravity load held |
| Safety output OFF | safety logic commanded its output inactive | external wiring healthy; valve moved; hydraulic objective achieved |
| Valve-position/seat feedback safe | documented monitored valve member reached its feedback state | every parallel path closed; all pressure absent; maintenance restraint installed |
| Pump stopped | active pump is not generating commanded flow | accumulator discharged; trapped volume discharged; gravity motion impossible |
| Pressure = 0 at one test point | pressure at that measurement node is within the instrument's zero boundary | all chambers/branches are zero pressure |
| Pressure retained in a load-holding chamber | local hydraulic load-support condition may exist if architecture proves it | mechanical maintenance blocking; indefinite leak-free retention |
| Ram position stationary | no observed movement during observation interval | safe holding force; future motion impossible; hazardous energy absent |
| Mechanical block/restraint installed and verified | load has a physical restraint path within its documented use | electrical isolation; pressure absent; unrelated axes safe |
| EDM/aux contact correct | monitored external final element reports its documented state | hydraulic valve state unless it is that monitored element; stored energy absent |
| HMI `SAFE` / green indicator | displayed diagnostic state was received if freshness/source are valid | universal safe state; maintenance isolation; START authority |

## Review rule

For each hazardous motion, write the required physical result first. Then select enough independent observations to prove that result. Do not begin with available controller bits and infer a convenient safety claim from them.

## Press/vertical-axis minimum questions

1. Which volume or mechanical load can create hazardous motion?
2. What prevents new energy from entering it?
3. What prevents unintended flow from leaving/entering the actuator?
4. If pressure is intentionally retained, what proves the load-holding function?
5. If pressure must be removed, where is the credited witness relative to the trapped volume?
6. What happens after hose rupture, stuck valve, broken wire, loss of control power and restoration of power?
7. What physical final-element feedback exists, and what common failures can falsely satisfy it?
8. What separately rated physical restraint is required for maintenance access?
9. What reset/rearm sequence follows a safety demand?
10. What fresh physical challenge validates the complete demand-to-motion chain?

## Human-factors requirement

The correct verification points, labels and maintenance restraint must be easier to use correctly than to bypass. If a technician must improvise a pressure check, reach through a hazard to inspect a witness, defeat a guard to install the restraint, or repeatedly bypass the safety function to diagnose ordinary faults, redesign the verification/maintenance interface rather than normalizing the shortcut.
