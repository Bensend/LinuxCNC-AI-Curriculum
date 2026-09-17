# Safety incident evidence preservation — first-response card

Date: 2026-09-17  
Lane: independent safety curriculum lane B

## Purpose

Provide a practical first-response sequence after a safety-related event, near miss, unexpected motion/energization, protective-device demand, or unexplained safety fault. The card preserves useful evidence **only after personnel protection and physical hazard control are established**.

This artifact is independent of the primary lane's commissioning/minimum-operate, PCSS-A application, mode-integrity and EDM/common-cause work. It complements `SAFETY_INCIDENT_RECONSTRUCTION_EVIDENCE_CONFIDENCE_WORKSHEET.md` by improving the evidence available to a later reconstruction.

## Frozen rule

**People and hazard control outrank evidence preservation. Never delay emergency response, rescue, E-stop action, electrical/hydraulic/mechanical isolation, stored-energy control, blocking, restraint, evacuation, fire response, or other required protective action merely to preserve logs or machine state.**

Once the area is protected, preserve evidence without turning observation into a new exposure.

## Provenance labels

Apply these labels to preserved claims and records: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, `UNKNOWN`.

A photograph or log is not automatically `TEST-CONFIRMED`; record what it actually observed. A LinuxCNC/HAL/FPGA command remains ordinary-control evidence unless the independent safety architecture explicitly assigns it a safety role.

## First-response sequence

### 1 — Protect people / summon emergency response

- Address injury, fire, entrapment, uncontrolled motion/energy or other immediate hazards first.
- Use the machine's intended emergency/protective means when required; do not preserve an energized state at the expense of protection.
- Keep unneeded personnel outside the hazard area.
- Record only afterward which protective action was taken and by whom if known.

### 2 — Establish physical hazard control before investigation access

Identify every relevant energy path rather than assuming `power off` means safe:

- electrical mains/control/drive-bus energy;
- hydraulic pressure/accumulators;
- pneumatic pressure;
- gravity/elevated members such as a press-brake ram;
- springs/flywheels/mechanical stored energy;
- thermal/process/other machine-specific energy.

Use the applicable documented energy-control procedure. Isolate, relieve/disconnect, block/restrain, and verify as required before exposed servicing/investigation. OSHA 29 CFR 1910.147 requires physical energy isolation for covered servicing, control of stored/residual energy and verification of isolation; control-circuit devices are not energy-isolating devices.

**Do not:** treat LinuxCNC Machine-Off, FPGA watchdog, safety-PLC output OFF, an HMI LED, zero proportional command, or an E-stop indication as a substitute for required physical energy control.

### 3 — Freeze unnecessary changes

After the machine/area is protected, avoid unnecessary actions that destroy volatile evidence:

- do not clear diagnostic history merely to remove alarms;
- do not reset/rearm/start merely to see whether the fault returns;
- do not power-cycle a protected controller solely for convenience;
- do not download configuration/firmware or restore backups before recording current identity;
- do not remove temporary jumpers, forces, test plugs, external supplies or fixtures until their presence and location are recorded **unless leaving them presents a hazard**;
- do not reposition valves, contactors, selector switches or mechanical components solely to make the machine look normal.

Safety overrides this freeze: change anything necessary to protect people or control hazardous energy, then record the change and reason.

### 4 — Preserve volatile evidence when safe

Capture without defeating isolation/blocking/restraint:

- independent safety-controller/device diagnostic history;
- fault/event codes and whether each is current or historical;
- source-native sequence/cycle counters and timestamps;
- boot/session identity and uptime where available;
- safety configuration signature/checksum/version;
- drive safe-function diagnostics;
- EDM/final-element feedback state **as a witness of its actual monitored point only**;
- LinuxCNC/HAL/FPGA logs, state and build/config identity as ordinary-control context;
- historian/collector status, sequence gaps, buffer-overflow flags and clock-sync state;
- relevant network/power discontinuity indications.

For every capture record: source, collector/person, collection time, whether time is source-native or collector-added, and whether the source was live/fresh/stale/unknown.

### 5 — Preserve physical/configuration evidence

When safe and authorized, record before repair:

- overall machine/cell and hazard-area condition;
- guard/interlock/protective-device physical condition;
- E-stop and mode-selector physical positions where meaningful;
- contactor/relay/valve/drive identifiers and relevant auxiliary/monitor wiring;
- disconnected, damaged, loose, altered or temporary wiring;
- jumper/force/override/test-fixture locations;
- replacement-part identity/revision and maintenance tags;
- hydraulic/pneumatic gauge or sensor indication only with its location/state context;
- blocking/restraint/isolation devices applied during response;
- software/firmware/configuration identifiers actually present.

Do not move into a hazard zone or reenergize merely to obtain a photograph or reading.

### 6 — Start an evidence custody/index record

| Evidence ID | Item/source | Captured by | Capture time + basis | Original/copy | Configuration/session identity | Altered by safety response? | Provenance | Storage/reference |
|---|---|---|---|---|---|---|---|---|
| | | | | | | | | |

If the original must be altered to make the machine safe, preserve the pre-change observation if available and record the protective action. Never prioritize chain-of-custody formality over emergency response.

### 7 — Record unavoidable state changes

| Change ID | Action | Time basis | Person/system | Safety reason or purpose | State/evidence changed or lost | Evidence captured before change? |
|---|---|---|---|---|---|---|
| | | | | | | |

Examples: E-stop pressed, disconnect opened, accumulator relieved, ram blocked, controller power removed, cable disconnected, damaged component removed for rescue, temporary jumper removed because it was hazardous.

### 8 — Establish the investigation boundary

Before repair/restart, identify:

- incident time window or bounds;
- machine configuration at event time (`UNKNOWN` if not established);
- maintenance/test work active;
- known temporary changes;
- known power/network/logging gaps;
- evidence overwritten or unavailable;
- physical safety functions affected;
- ordinary-control systems involved but not safety authority;
- evidence that still requires controlled testing later.

Use `SAFETY_INCIDENT_RECONSTRUCTION_EVIDENCE_CONFIDENCE_WORKSHEET.md` for chronology and confidence classification. Do not force a single narrative when evidence conflicts.

## OpenPressBrake-specific boundary reminders

Keep these separate during preservation and later reconstruction:

1. LinuxCNC command/state;
2. FPGA command/watchdog state;
3. proportional-current request and measured coil current;
4. independent safety demand/output;
5. final-element/EDM or valve-monitor witness;
6. hydraulic energy state;
7. gravity/ram restraint;
8. actual hazardous motion/effect.

A zero current request does not prove hydraulic safety. A safety output OFF does not prove the final element changed. EDM does not prove every hazardous-energy path is absent. Exact pressure behavior, stopping distance, valve truth table and gravity-retention behavior remain `UNKNOWN` until machine evidence establishes them.

## Restart prohibition during preservation

Do not restore production merely to reproduce the incident. Any later energized diagnostic test must be separately planned, bounded, justified by a specific unanswered question, and performed with people outside the uncontrolled hazard or with the independently validated protective measures required by the actual test.

Reset, safety reset, ordinary-controller rearm and START remain distinct actions. Evidence preservation is not authorization to perform any of them.

## Evidence quality traps

- Photographing an HMI green state proves the display state, not the physical energy state.
- A collector timestamp may be collection time rather than event time.
- An empty diagnostic history after a clear/power cycle is not evidence that no fault occurred.
- A precise LinuxCNC timestamp does not synchronize an independent safety controller unless synchronization evidence exists.
- A removed jumper found on a bench does not establish where/when it was installed without supporting evidence.
- A component's present position may have been changed by emergency response or deenergization; record that possibility.

## Minimum handoff to investigator/maintenance lead

- personnel/emergency status;
- present physical energy-control/blocking/restraint state;
- OUT OF SERVICE / DO NOT OPERATE status if applicable;
- evidence index and storage location;
- unavoidable changes already made;
- configuration identity captured/not captured;
- volatile records captured/not captured and why;
- safety-relevant `UNKNOWN`s;
- prohibited restart/rearm actions pending review;
- person responsible for controlled next step.

## Source basis

- `DOC-CONFIRMED` — OSHA 29 CFR 1910.147: covered servicing/maintenance must control unexpected energization/startup and stored-energy release; energy-isolating devices physically prevent transmission/release, while push buttons/selectors/control-circuit devices are not energy-isolating devices; stored/residual energy must be rendered safe; isolation/deenergization must be verified before work; restoration requires area/personnel checks.
- `DOC-CONFIRMED` — OSHA Appendix A explicitly lists capacitors, springs, elevated members, flywheels, hydraulic systems and pressure as stored/residual-energy examples and describes dissipation/restraint plus verification.
- `INFERENCE` — preserving volatile diagnostics/configuration identity after hazard control materially improves later reconstruction, but the exact evidence-preservation procedure is machine/site dependent and must not conflict with emergency response or energy-control obligations.

## Completion criterion

This first-response card is complete when it leaves the machine in a physically controlled state appropriate to the work, preserves safely obtainable evidence with source/time/configuration context, records evidence lost or altered by necessary protective actions, and hands off explicit `UNKNOWN`s without implying that preservation itself validates the machine for restart.

## Precise next independent work

Create `SAFETY_POST_INCIDENT_CHANGE_REVALIDATION_MATRIX.md`: map incident findings and repairs (wiring, safety configuration, sensor/final element, hydraulic component, drive parameters, LinuxCNC/FPGA changes, guard/mechanical changes) to the safety claims invalidated and the bounded physical/document/configuration evidence required before return to service. Do not invent universal proof-test intervals, PL/SIL/DC, pressure, stopping or timing values.