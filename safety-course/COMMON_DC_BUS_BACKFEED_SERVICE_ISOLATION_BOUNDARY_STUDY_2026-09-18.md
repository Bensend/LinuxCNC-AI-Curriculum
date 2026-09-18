# Common DC Bus, Backfeed, and Service-Isolation Boundary Study — 2026-09-18

## Scope and lane separation

This is independent Lane-B work. Immediately before selection, `main` ended at primary-lane checkpoint `6828b49a`, whose durable work is HAWE ePRAX hydraulic valve-path and Y1/Y2 discrepancy tracing. This study intentionally does not edit those files or advance hydraulic truth tables. It extends Lane B's earlier STO/stored-energy boundary into multi-drive/common-bus and regeneration/backfeed failure paths.

No executable verification was justified. No GitHub-hosted runner or self-hosted runner was used.

## Evidence vocabulary

- **SOURCE-CONFIRMED** — directly stated in an authoritative manufacturer source cited below.
- **DOC-CONFIRMED** — confirmed by repository documentation or a source-derived durable artifact.
- **TEST-CONFIRMED** — demonstrated by controlled test. None in this study.
- **COMMUNITY-REPORTED** — community observation not independently confirmed. None relied on here.
- **INFERENCE** — engineering consequence derived from confirmed evidence; not claimed as an OpenPressBrake implementation fact.
- **UNKNOWN** — requires the selected hardware, schematic, installation, or measurement.

## Source set

1. Schneider Electric, Lexium 32 safety requirements, current Machine Expert help: STO does not remove power from the DC bus; DC-bus and mains voltage remain present; mains disconnection requires an appropriate switch outside the STO circuit.  
   https://product-help.schneider-electric.com/Machine%20Expert/V2.0/zh/Lx32seSM/Lx32seSM/D-SE-0077581.html
2. Schneider Electric, Lexium 32 commissioning: external driving forces acting on the motor can regenerate current back to the drive.  
   https://product-help.schneider-electric.com/Machine%20Expert/V1.1/en/Lx32sDr/Lx32sDr/Commissioning/Commissioning-3.htm
3. Schneider Electric, Lexium 32 Common DC Bus: multiple drive DC buses can be interconnected; energy generated while one drive decelerates can be used by another drive on the common DC bus.  
   https://product-help.schneider-electric.com/Machine%20Expert/V2.1/en/Lx32sDr/Lx32sDr/CommonDCBus-CDCA5292.html
4. Schneider Electric, eSM installation/service precautions: disconnect all power including connected devices, lock out, allow capacitor discharge, then measure DC-bus voltage; an extinguished DC-bus LED is not proof of absence of voltage.  
   https://product-help.schneider-electric.com/Machine%20Expert/V2.2/en/Lx32seSM/Lx32seSM/D-SE-0077603.html
5. Rockwell Automation, *Drives in Common Bus Configurations Application Technique*, publication DRIVES-AT002H-EN-P, October 2024: common-bus drives contain DC-bus capacitance and some DC-input configurations require external precharge; uncontrolled connection to an energized DC bus can damage equipment.  
   https://literature.rockwellautomation.com/idc/groups/literature/documents/at/drives-at002_-en-p.pdf
6. Rockwell Automation, *Drives in Common Bus Configurations with PowerFlex 755TM Bus Application Technique*: the regenerative bus supply precharges connected external DC-bus capacitance, making the connected bus a system-level energy domain rather than an isolated per-drive capacitor.  
   https://literature.rockwellautomation.com/idc/groups/literature/documents/at/drives-at005_-en-p.pdf

## SOURCE-CONFIRMED findings

### 1. STO and service isolation are different functions

Schneider explicitly states that STO removes torque-producing motor power but leaves the drive DC bus and mains voltage present. A separate mains-disconnecting device is required for electrical isolation. Therefore an STO indication is not evidence that the drive is safe to service electrically.

### 2. A motor/load can be an energy source

Schneider explicitly warns that external forces acting on a motor can regenerate current back into the drive. The electrical energy map therefore cannot assume the mains input is the only source capable of energizing the DC link.

### 3. A common DC bus couples drive energy domains

Schneider explicitly describes a common DC bus in which braking energy from one drive can be consumed by another. Rockwell likewise treats connected drive capacitance and regenerative bus supplies as a common system that must be precharged and sized as a whole.

### 4. Absence of an indicator is not absence-of-voltage proof

Schneider's service procedure requires physical DC-bus voltage measurement after isolation/discharge and explicitly rejects an extinguished DC-bus LED as sufficient proof.

## Frozen architecture distinctions

These distinctions are now curriculum rules:

**STO ACTIVE != MAINS DISCONNECTED != COMMON DC BUS ISOLATED != DC BUS DISCHARGED != ABSENCE OF VOLTAGE VERIFIED != MECHANICAL/GRAVITY ENERGY CONTROLLED**

**ONE DRIVE INPUT CONTACTOR OPEN != THAT DRIVE'S DC LINK NECESSARILY DEAD** when another documented energy path can feed a common DC bus.

**MOTOR NOT COMMANDED != MOTOR CANNOT REGENERATE.** External mechanical forces can make a motor/load an electrical source.

**DC-BUS LED OFF != ABSENCE OF VOLTAGE PROVED.** Service isolation requires the manufacturer-defined isolation/discharge/measurement process for the actual equipment.

## Failure-path matrix

| Challenge | Unsafe shortcut | Required evidence question | Status |
|---|---|---|---|
| STO asserted while mains remains present | Treat STO as electrical isolation | What conductive energy remains accessible downstream/upstream? | SOURCE-CONFIRMED generic distinction; OpenPressBrake topology UNKNOWN |
| One drive disconnected on a common bus | Assume local input OFF means local DC link dead | Can another drive/bus supply energize the shared link? Where is the isolating boundary? | SOURCE-CONFIRMED common-bus coupling; installation UNKNOWN |
| Gravity/external load turns motor | Assume no RUN command means no source | Can the axis regenerate into its drive/common bus while mechanically driven? | SOURCE-CONFIRMED possibility; machine behavior UNKNOWN |
| Bus LED extinguished | Declare safe to service | What rated measurement points and verification procedure prove absence of voltage? | SOURCE-CONFIRMED that LED alone is insufficient; points/threshold UNKNOWN |
| Discharge path failed/open | Rely only on elapsed time | Is discharge actually verified before access? | INFERENCE from required voltage verification; failure behavior UNKNOWN |
| Auxiliary/control supply remains energized | Assume main contactor removes every hazardous electrical path | Which 24-V/control/external supplies cross the isolation boundary? | INFERENCE; topology UNKNOWN |
| Regenerative supply or another axis remains enabled | Assume local drive isolation contains energy locally | What bus ties, precharge paths, braking modules, regeneration paths, or external DC feeds remain? | SOURCE-CONFIRMED as possible architectures; OpenPressBrake UNKNOWN |
| Return to service after bus work | Restore ordinary control immediately | Are covers/grounds restored, isolation removed deliberately, bus precharge normal, safety authority healthy, and ordinary START separate? | SOURCE-CONFIRMED service prerequisites + INFERENCE for integration |

## Practical OpenPressBrake architecture consequence — INFERENCE

The future machine documentation should maintain at least three separate state/evidence concepts:

1. **Personnel-safety motion authority** — e.g. independent safety functions such as STO or other final-element actions.
2. **Operational electrical power state** — whether drives, buses, auxiliaries, pumps, etc. are powered for normal machine use.
3. **Maintenance/service isolation proof** — the task-specific lockout/isolation/discharge/restraint and measured absence-of-energy evidence needed before exposure.

LinuxCNC/HAL/ordinary FPGA may display diagnostics for these concepts but must not collapse them into one `SAFE`, `DRIVE OFF`, or `ESTOP` Boolean. In particular, an ordinary controller status bit is not physical absence-of-voltage evidence.

## What remains UNKNOWN

Do not infer any of the following for OpenPressBrake until the actual drive and machine architecture are selected/inspected:

- whether a common DC bus will exist at all;
- drive family, bus capacitance, precharge/discharge topology, discharge time, measurement points, or manufacturer service threshold;
- whether any motor/load can regenerate materially in the actual machine;
- external 24-V/control supplies and their isolation boundaries;
- line/regenerative supply, braking resistor/module, DC contactor, fusing, or disconnect topology;
- whether opening any particular contactor creates galvanic isolation from every source;
- required lockout/tagout procedure or machine-specific stored-energy waiting time;
- hydraulic/gravity load state after electrical isolation.

## Verification/commissioning questions

When actual hardware exists, validation should be question-driven rather than simulation-driven:

- With each intended service disconnect open, identify every remaining source that can energize the exposed circuit.
- For a common bus, challenge isolation with the other connected drives/supplies in all permitted power states.
- Determine from manufacturer documentation whether external mechanical motion can regenerate into the bus and how that is controlled for service.
- Verify the manufacturer's specified DC-bus measurement points/procedure with appropriately rated equipment; do not substitute HMI/LED status.
- Challenge loss/failure of any automatic discharge mechanism if the design relies on it.
- Confirm ordinary LinuxCNC/FPGA restart cannot substitute for the independent safety reset/rearm and physical return-to-service procedure.

No voltage, time, stopping distance, pressure, PL/SIL/DC, or machine response acceptance number is assigned here.

## Precise next independent work

Trace a professional multi-drive/common-DC-bus implementation far enough to expose **mains disconnect(s) -> line/regenerative supply -> precharge -> shared DC link -> individual inverter(s) -> STO -> braking/regeneration path -> discharge/voltage-measurement points -> maintenance isolation -> return to service**. Prefer an authoritative schematic/application manual showing which components remain energized when one drive is locally disabled.

If the primary lane reaches that evidence package first, Lane B should rotate to **separate 24-V/control-supply backfeed across an otherwise-open isolation boundary** or **gravity-axis brake/load-retention sequencing**, rather than duplicate files or sources.
