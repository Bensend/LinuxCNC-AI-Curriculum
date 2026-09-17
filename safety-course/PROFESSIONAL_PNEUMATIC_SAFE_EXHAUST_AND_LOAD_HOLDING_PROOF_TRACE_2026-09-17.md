# Professional pneumatic safety trace — safe exhaust, monitoring, and load holding

Date: 2026-09-17
Session start UTC: 2026-09-17T15:36:00Z

## Purpose

Continue the robot/cell zone lesson into fluid power. The key question is not merely whether a safety controller de-energizes a valve coil, but what **physical pneumatic state** results and what evidence can prove it.

## Reference A — ROSS RSe redundant safe-exhaust valve

Manufacturer source:
- ROSS Controls RSe Series safe-exhaust double valve: https://www.rosscontrols.com/en/series/1297-rse-series-double-valve

### DOC-CONFIRMED

For the documented 3/2 safe-exhaust use:

- the valve is intended to supply air to a zone/machine in the run state and, on safety demand, shut off supply and exhaust downstream pneumatic energy;
- the construction uses redundant valve elements/solenoids;
- each valve element has a PNP proximity sensor for external position monitoring;
- the manufacturer requires the monitoring system to observe both sensors during actuation and de-actuation for the stated diagnostic architecture;
- the safety function does **not** guarantee removal of pneumatic energy trapped downstream of obstructions such as check valves or closed-center valves.

That last point is a critical physical-boundary rule.

### End-to-end safe-exhaust trace

A properly integrated application has the conceptual chain:

`protective demand`

`-> safety logic removes valve-run authority`

`-> redundant valve elements move toward safe/exhaust state`

`-> valve-element position feedback is evaluated`

`-> supply is blocked and the connected exhaustable downstream volume vents`

`-> physical pressure/motion result is verified as required by the machine safety function`

The proximity sensors prove valve-element position within their documented role. They do **not** inherently prove that every downstream trapped volume reached zero pressure.

## Reference B — ROSS monitored load-holding/check valve

Manufacturer source:
- ROSS SV27 pilot-operated check valves for external monitoring: https://www.rosscontrols.com/en/series/1306-sv27-series-pilot-operated-check-valves-for-external-monitoring

### DOC-CONFIRMED

ROSS documents the SV27 sensing pilot-operated check-valve family for load-holding functions. The integrated safety switch monitors the valve's internal operating position and provides feedback to an external safety controller.

This establishes a different safety objective from safe exhaust:

- **safe exhaust** seeks to remove downstream pneumatic energy where the circuit permits it;
- **load holding** intentionally traps/controls pressure to prevent a hazardous load from moving.

Therefore `pressure remains` is not automatically a fault, and `pressure = 0` is not automatically the desired safe state. The safe physical state depends on the credited safety subfunction and the load mechanics.

## Reference C — Festo pneumatic safety-subfunction guidance

Manufacturer source:
- Festo Application Note `Safety-Subfunctions Pneumatics - Definition`, document 100422: https://media.festo.com/assets/attachment-files/af6c6e169ddb716233039e8a686ddc8aae20469960f809abd4c1c48d435b84b68a33861c1f8a598536673bd244b01d5a4797c4ccb2e5438a19498c46bf1d2059/100422%20Application%20Note%20-%20EN.pdf

### DOC-CONFIRMED principle

Festo's safety-subfunction guidance distinguishes monitoring the control element from monitoring the **effect on which the safety subfunction is based**. In its clamping/load-holding discussion, direct proof of the actual frictional holding effect is stronger than merely observing a valve, while actuator position or other indirect observations can support bounded diagnostic claims depending on the architecture.

Curriculum consequence:

> Final-element feedback is evidence about the final element. It is not automatically evidence about the complete physical safety effect.

## Four different claims that must not be collapsed

1. **Coil command:** safety output told the solenoid OFF.
2. **Valve state:** monitored spool/poppet/check element reached its expected state.
3. **Fluid state:** the relevant pressure/flow/trapped volume reached the state required by the safety function.
4. **Mechanical hazard state:** the cylinder/load/clamp/gravity member is actually restrained, stopped, returned, or otherwise safe as required.

A design may need evidence at more than one layer.

## Safe-exhaust adversarial cases

### Closed-center valve downstream

A safe-exhaust valve can correctly reach exhaust state while a downstream closed-center directional valve traps pressure in an actuator branch.

**Result:** valve-position feedback PASS does not prove actuator chamber depressurization.

### Pilot-operated check valve downstream

The exhaust valve can remove supply while a check valve intentionally retains cylinder pressure/load position.

**Result:** `downstream pressure remains` may be expected, but the load-holding element and mechanical result must then be the credited safety path.

### Blocked exhaust / silencer restriction

The final element can command exhaust yet physical pressure decay can be slower or incomplete because the exhaust path is restricted.

**Result:** command/state evidence alone is not physical depressurization evidence.

### One redundant element fails

The monitoring architecture must detect the discrepancy required by the selected valve/integration rather than allowing repeated operation with lost redundancy.

**Result:** a machine that still appears to stop normally can have a latent loss of fault tolerance.

### Common supply/return/configuration fault

Two solenoids or two monitored elements can still share wiring, supply, connector, reference, or safety-logic dependencies.

**Result:** count channels physically and functionally; do not infer independence from two software tags.

## Reset/restart boundary

Safe valve state, cleared protective demand, and healthy valve feedback are not themselves ordinary machine START.

The complete recovery path should distinguish:

`protective demand clears`

`-> safety inputs valid`

`-> valve/final-element fault state resolved`

`-> required safety reset/restart interlock satisfied`

`-> pneumatic run authority restored`

`-> ordinary controller freshly rearmed`

`-> deliberate production START / motion condition`

A LinuxCNC/HAL/FPGA reboot or stale output value must not silently stand in for the safety reset or deliberate production restart.

## Maintenance boundary

A safe-exhaust function is not automatically maintenance isolation. Before servicing, identify all sources and stored energy, including trapped volumes beyond check/closed-center valves, accumulators/reservoirs, gravity loads supported by air pressure, spring return forces, and external mechanical loads.

Where a load must remain supported, depressurizing it may create rather than remove a hazard. Physical blocking/restraint or a validated load-holding architecture may be required before personnel exposure. Machine-specific requirements remain dependent on the installed design.

## Zone-transfer rule

For a robot/automation cell that keeps an adjacent zone productive, document each pneumatic branch separately:

`zone protective demand -> safety logic -> exact valve(s) -> monitored valve state -> actual zone pressure/flow state -> actuator/load result`

Then ask whether the supposedly unaffected productive zone shares any supply, dump valve, pilot pressure, exhaust restriction, common manifold, electrical output power, feedback reference, or controller dependency with the entered zone.

A single shared machine-level dump valve may be intentionally global; a zone-local valve may permit productivity elsewhere. Neither architecture is inherently correct without the machine risk assessment and validation.

## Minimum evidence before crediting pneumatic safety

- exact pneumatic schematic and normal/safe flow paths;
- valve type and fail state;
- safety-control output path;
- monitoring/feedback path required by the selected architecture;
- identification of check valves, closed-center valves and trapped volumes;
- gravity/external-load consequence if pressure changes;
- physical observation proving the required actuator/load state;
- restart/repressurization behavior;
- fault behavior and loss-of-redundancy response;
- maintenance isolation distinct from operational safeguarding.

## Evidence classifications

- `DOC-CONFIRMED`: ROSS RSe safe-exhaust architecture uses redundant valve elements with per-element external position monitoring and explicitly warns that downstream obstructions can prevent complete exhaust.
- `DOC-CONFIRMED`: ROSS SV27 sensing check valves are intended for monitored load-holding applications and provide internal-position feedback to external safety control.
- `DOC-CONFIRMED`: Festo safety-subfunction guidance distinguishes direct monitoring of the safety effect from indirect component/actuator observations.
- `INFERENCE`: the four-claim model and zone-transfer worksheet are conservative engineering abstractions from manufacturer evidence.
- `UNKNOWN`: any OpenPressBrake pneumatic/hydraulic valve topology, pressure threshold, safe state, proof-test interval, stopping time, PL/SIL/DC, or load-holding requirement not established by installed-machine evidence.

## Next evidence target

Trace **hydraulic load-holding / blocking-valve proof** in a professional vertical-axis or press application where manufacturer/OEM evidence exposes the valve arrangement and the physical load-retention claim. Compare it directly against pneumatic safe exhaust: `remove pressure` and `retain pressure/load` are different safety objectives, and neither can be inferred from a command bit.
