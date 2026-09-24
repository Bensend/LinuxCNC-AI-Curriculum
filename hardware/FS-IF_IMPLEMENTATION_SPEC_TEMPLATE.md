# FS-IF — FPGA-to-Safety Interface Implementation Spec Template

Status: reusable curriculum engineering template; not a machine-specific certified design.

Purpose: specify an exact safety-originated hard-inhibit boundary into ordinary FPGA/controller hardware without assigning personnel-safety authority to LinuxCNC, HAL, normal FPGA firmware, host communications or their diagnostics.

## 1. Traceability and exact inhibited resource

- Instance ID:
- Hazardous event / `SRS-*`:
- Required physical proposition / `PHY-*`:
- `AUTH-*` allocation:
- `ARC-*`:
- `DEP-*`:
- `VAL-*`:
- `CHG-*`:
- Exact FPGA/controller resource inhibited (for example PWM gate, step-enable gate, process-enable gate):
- Independent physical final element controlling hazardous energy:
- Safety credit assigned to FS-IF, if any:
- Current UNKNOWNs:

**Freeze:** `FPGA INHIBIT ASSERTED != PHYSICAL SAFE STATE PROVED`.

## 2. Authority chain

Document the complete chain without collapsing layers:

`safety demand -> FS-IF electrical input -> local hardware dominance -> ordinary command suppressed -> independent final-element action -> final-element witness -> physical hazard proposition -> qualified rearm`

For each arrow state what evidence proves it. Missing stages remain UNKNOWN; LinuxCNC/HMI status cannot synthesize them.

## 3. Hardware dominance proof

Provide schematic/logic evidence that an asserted safety inhibit dominates the exact command-enable boundary independent of:
- host packets or HAL pins;
- ordinary firmware registers;
- normal FPGA state machines;
- communications recovery;
- boot defaults;
- stale/replayed/corrupted normal requests.

State the electrical polarity and de-energized behavior only from selected component/circuit evidence.

- Inhibit source and electrical interface:
- Local dominance element/path:
- Resource suppressed:
- Can ordinary firmware mask it? MUST be NO for credited hard-inhibit behavior.
- Can a normal register/packet force around it? MUST be NO.
- Diagnostic copy path:

The diagnostic copy is observation only and does not prove the final energy path opened.

## 4. Reset, configuration and unconfigured behavior

Analyze separately:

| State | Required analysis |
|---|---|
| FPGA power off | hazardous-energy consequence and independent final-element response |
| FPGA reset asserted | inhibit/resource behavior |
| FPGA unconfigured | pin/default/resource behavior |
| configuration loading | transient output/inhibit behavior |
| firmware update | authority maintained by independent path |
| configuration failure | fail behavior / UNKNOWN |
| normal host reconnect | must not rearm safety or restart motion |
| safety-side power loss | electrical result and machine consequence |
| normal-side power loss | electrical result and machine consequence |
| power restoration | explicit rearm/restart sequence |

If configuration can remove the FPGA-side inhibit function, FS-IF cannot be the sole personnel-safety layer; the independent final-element path must maintain the SRS response.

## 5. Service/programming dependency inventory

Treat each capable path as `DEP-*`:
- JTAG/programming header;
- boot straps/configuration pins;
- service jumpers;
- manufacturing fixtures;
- boundary-scan/test modes;
- debug commands/registers;
- force/test points;
- removable links/adapters;
- field firmware update mechanism.

For each record accessibility, possible defeat mechanism, production disposition, labeling, restoration verification and commissioning test. Convenience is not a reason to exclude a bypass-capable path from safety dependency analysis.

## 6. Electrical/common-cause dependencies

Trace shared 24 V/5 V/3.3 V rails, 0 V/reference, level shifters, optocouplers/digital isolators if used, connector pins, protection/filter parts, reset supervisors, clocks/configuration memories and any shared component whose fault can both corrupt the inhibit and defeat its diagnostic.

Also trace whether a common supply/pilot-energy failure can simultaneously affect sensing, FS-IF and the final element. Apparent logical redundancy sharing one physical dependency is not credited as independent.

## 7. Normal-control request/status boundary

List every normal-to-safety request and safety-to-normal diagnostic. For each state explicitly that stale, stuck, missing, replayed or corrupted ordinary-control data cannot override an active safety demand. Normal-controller heartbeat is operational only unless separately engineered and justified as a safety function.

## 8. Validation matrix

At minimum test/inspect:
- inhibit asserted during every normal command state;
- attempted software/register/packet override;
- host disconnect/reconnect;
- FPGA reset and unconfigured state;
- configuration/firmware update path;
- open/short faults at the inhibit connector appropriate to the selected circuit;
- safety-side and normal-side supply loss/restoration;
- each service/programming bypass-capable mechanism;
- diagnostic disagreement between commanded inhibit and observed local state;
- independent final-element response and its physical witness.

A passing FPGA observation is not sufficient where the `VAL-*` proposition concerns energy removal, standstill, pressure, gravity restraint or another physical state.

## 9. Schematic-freeze decision

Block schematic freeze until the exact inhibited resource, hardware-dominance path, reset/unconfigured behavior, service/programming dependencies, CCF inventory, independent final-element authority chain and validation witnesses are explicit. If the final-element architecture is not yet selected, FS-IF may be specified as an interface but SHALL NOT be credited as proving machine safety.