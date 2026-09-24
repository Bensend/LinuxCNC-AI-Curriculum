# Reusable Independent-Safety Block Interface Contracts

Status: curriculum engineering contract; not a machine-specific certified design.

## Purpose and governing boundary

These contracts convert the safety-course architecture into reusable implementation units without moving personnel-safety authority into ordinary LinuxCNC, HAL, the normal FPGA, HMI, or convenience software.

Every instantiated block SHALL declare the Safety Design Package IDs it implements or observes: `SRS-*`, `PHY-*`, `AUTH-*`, `DEP-*`, `ARC-*`, and `VAL-*`. A block may report a proposition only at the layer it actually observes. Electrical state, valve/contact state, commanded state, and physical safe state are not interchangeable evidence.

A material change to an interface assumption, safety function, architecture, dependency, diagnostic mechanism, or physical witness SHALL create the applicable package `CHG-*` record and trigger downstream stale-evidence review.

Integrity targets, PL/SIL claims, diagnostic coverage, proof-test intervals, stopping limits, hydraulic truth tables, safe-speed values, and machine-specific acceptance thresholds remain `UNKNOWN` until justified for the actual application.

## Common authority model

Use four deliberately separate planes:

1. **Normal control** — LinuxCNC/HAL/normal FPGA requests machine behavior.
2. **Monitoring/diagnostics** — normal control may observe safety state and explain why motion is unavailable, but observation grants no safety authority.
3. **Independent safety-related control** — evaluates qualified safety inputs, dependencies, reset/rearm conditions, and safety-function logic.
4. **Physical final elements / guards / restraints** — remove, inhibit, contain, exhaust, block, restrain, or otherwise control hazardous energy according to the machine SRS.

A normal-control request can be an input to a safety architecture, but it SHALL NOT be the sole condition whose loss, corruption, stale value, or software defect defeats a required personnel-safety function.

## Contract SI — safety-input family

Supported family members are intentionally interface-compatible at the logical boundary while retaining device-specific electrical implementations:

- `SI-DRY2`: dual-channel dry-contact protective device;
- `SI-OSSD2`: dual OSSD protective device;
- `SI-PNP-TP`: PNP/test-pulse capable safety input where justified by the selected device/controller architecture.

### Required declarations

Each instance SHALL declare:
- protected `SRS-*` and observed `PHY-*` proposition;
- input-device type and manufacturer interface assumptions;
- `AUTH-*` owner of the safety decision;
- `DEP-*` dependencies including shared supply/reference, cable, connector, test-pulse source, and environmental assumptions;
- `ARC-*` architecture role;
- corresponding `VAL-*` tests.

### Logical outputs

The family interface SHALL distinguish at minimum:
- channel A observed state and validity;
- channel B observed state and validity;
- pair agreement/discrepancy state;
- input diagnostic/fault state;
- qualified protective-device state;
- reset/rearm eligibility as a separate result, never implicit in channel restoration.

### Fail-safe defaults

Loss of required input power, invalid signal levels, stale qualification where freshness is required, detected cross-short/discrepancy where applicable, controller reset, or broken required diagnostic mechanism SHALL resolve to the non-permissive safety result unless the machine SRS explicitly establishes another safe response.

### Prohibited inference

`INPUT CHANNELS HEALTHY != PHYSICAL SAFE STATE PROVED`.

The input family may establish the state/health of its protective-device interface. It does not prove that final elements opened, a spindle stopped, a hydraulic volume exhausted, a gravity load is restrained, or a safeguarded space is empty.

### Human factors

Use keyed/polarized connectors where practical, clear channel/device labels, diagnostic test points that do not require defeating the safeguard, and replacement wiring that makes correct restoration easier than bypass. Temporary jumpers SHALL not be the normal troubleshooting path.

## Contract SC — independent core safety controller

### Authority

`SC-CORE` owns only the safety-related decisions allocated to it by `AUTH-*`. It SHALL remain logically and electrically separable from ordinary LinuxCNC/FPGA control to the extent required by the selected architecture.

### Inputs

- qualified safety-input-family states;
- final-element feedback/EDM or other independent witnesses where required;
- reset/rearm request;
- mode/setup/service inputs that are explicitly included in the SRS;
- normal-control requests only where the SRS permits them as non-authoritative requests;
- supply/watchdog/internal diagnostic state.

### Outputs

- explicit safety-function demand/permissive outputs to safety-output interfaces;
- diagnostic state to normal control/HMI through a non-authority path;
- reset/rearm state and fault reason.

### Mandatory behavioral rules

- Power-up SHALL default non-permissive until required inputs, dependencies, feedback and rearm conditions are established.
- Restoration of a guard/input or communications path SHALL NOT by itself restart hazardous motion.
- Reset SHALL be deliberate where required by the SRS and SHALL NOT itself initiate hazardous motion.
- A detected internal fault SHALL not be cleared merely because ordinary LinuxCNC toggles machine enable.
- Bypass/muting/setup behavior, if present, SHALL have explicit entry eligibility, bounded authority, alternate protection, indication, exit behavior, power-cycle behavior and validation IDs. Absence of these requirements means the feature is not permitted.
- The controller SHALL expose enough diagnostics to identify why a safety function is non-permissive without requiring operators to defeat safeguards for troubleshooting.

### Dependency/CCF record

Every implementation SHALL identify shared supplies, references, clock/reset resources, communications, PCB zones/connectors, environmental stresses, and any single component or wiring fault capable of defeating multiple channels or final elements. Redundant-looking channels sharing an unexamined dependency SHALL not be credited as independent.

## Contract SO — safety-output / final-element interface family

This family bridges the independent safety controller to physical energy-control elements. Family members may include relay/contactor interfaces, drive STO interfaces, monitored valve interfaces, dump/exhaust interfaces, brake/load-holding interfaces, or other machine-specific final elements.

### Required declarations

Each instance SHALL declare:
- commanded safety action;
- physical energy path affected;
- de-energized/fault behavior supported by evidence;
- independent feedback available;
- what the feedback proves and explicitly does not prove;
- shared supply/pilot/common-return/common-mechanical dependencies;
- required rearm condition;
- machine-specific `VAL-*` physical witness.

### Authority chain

Record separately:

`SC safety demand -> output interface state -> final-element actuation -> final-element witness -> physical hazard proposition -> qualified rearm`

Unavailable stages remain unavailable/UNKNOWN. Do not bridge missing evidence with a status bit.

### Fail-safe and fault rules

- Loss of normal-control command SHALL not defeat an active safety demand.
- Loss of safety-controller authority or required output power SHALL produce the SRS-defined safe response or be explicitly classified as an unresolved hazard if physics prevents that assumption.
- Welded/stuck output devices, failed feedback, cross-channel faults, common supplies, common pilot pressure and common mechanical actuation paths SHALL be considered in `DEP-*`/CCF analysis.
- Feedback such as EDM or valve-position switches may establish final-element state only to the extent supported by the device evidence.

Durable freezes:
- `EDM HEALTHY != PHYSICAL SAFE STATE PROVED`.
- `SAFETY OUTPUT OFF != FINAL ENERGY PATH OPEN PROVED`.
- `VALVE POSITION EXPECTED != RAM SAFE STATE PROVED`.
- `STO ACTIVE != MOTOR STANDSTILL PROVED`.
- `STO ACTIVE != ELECTRICAL ISOLATION`.
- `DUMP COMMANDED != PRESSURE SAFE PROVED`.

## Contract FS — FPGA-to-safety interface

`FS-IF` exists so the normal FPGA/LinuxCNC system can request modes/actions and receive safety diagnostics without becoming the personnel-safety authority by convenience.

### Normal-to-safety direction

Allowed signals are requests only unless a separately justified SRS/architecture says otherwise, for example:
- normal machine-enable request;
- requested operating mode;
- requested motion/process enable;
- service/setup request;
- normal-controller heartbeat for operational diagnostics.

A stuck-high, stale, replayed, corrupted, or absent normal-control request SHALL not override a safety demand.

### Safety-to-normal direction

Expose diagnostic/status information such as:
- safety permissive available;
- active safety demand;
- reset required;
- fault/diagnostic reason;
- mode accepted/rejected;
- final-element feedback summary where useful.

These signals allow LinuxCNC to stop issuing commands, explain state, and coordinate orderly operation. They SHALL NOT be represented as proof of physical safe state beyond the actual witness chain.

### Hard inhibit

Where the architecture uses a safety-originated hard inhibit into ordinary controller hardware, the inhibit SHALL dominate normal command generation locally. Normal FPGA firmware SHALL not be able to mask an asserted external safety inhibit through an ordinary software register or communications command.

### Service/programming boundary

Programming/debug access, service jumpers, firmware-update mode and manufacturing test SHALL be explicitly considered in `DEP-*`, `ARC-*`, human-factor and commissioning records. A service mechanism capable of bypassing the hard inhibit is a safety-architecture dependency, not a harmless maintenance feature.

### Freshness and restart

Normal-control communications recovery SHALL not itself rearm the safety system or restart hazardous motion. Any freshness/heartbeat signal used only for operational coordination SHALL be labeled non-safety unless independently engineered and justified as part of the safety function.

## Minimum composition checklist

Before schematic implementation, each machine composition SHALL answer:

| Question | Required package linkage |
|---|---|
| What hazardous event is being controlled? | `SRS-*` |
| What physical proposition must become true? | `PHY-*` |
| Which block has which authority, and which does not? | `AUTH-*` |
| What shared dependencies/CCFs can defeat the function? | `DEP-*` |
| What architecture connects input, logic and final elements? | `ARC-*` |
| What physical witness validates the proposition? | `VAL-*` |
| What remains unknown? | package UNKNOWN register |
| What change invalidates existing evidence? | `CHG-*` / stale review |

## Schematic-freeze gate

Do not freeze a safety-block schematic until the interface contract has, at minimum:
- explicit SRS/PHY/AUTH/DEP/ARC/VAL linkage;
- fail-safe default and power/reset behavior;
- channel/device electrical assumptions;
- authority and non-authority declarations;
- dependency/CCF inventory;
- physical-witness plan;
- service/bypass/programming behavior;
- unresolved machine-specific facts marked UNKNOWN.

Passing this gate means the block is specified well enough to implement and review. It does **not** mean the machine safety function is validated, certified, or safe to operate.