# Safety diagnostic event record minimum schema

Date: 2026-09-17
Lane: independent safety curriculum lane B

## Purpose

Define the minimum diagnostic/event record needed to reconstruct a safety-related event without allowing a historian, HMI, LinuxCNC, HAL, FPGA, or network mirror to be mistaken for the personnel-safety function or for physical proof of hazardous-energy control.

This artifact is deliberately independent of the primary lane's current common-cause/minimum-operate work. It does not define machine-specific stopping distances, hydraulic truth tables, pressure thresholds, PL/SIL/DC, fault-reaction times, or acceptance values.

## Frozen rule

**Record what each source actually knew, when it knew it, and how fresh that knowledge was. Never rewrite command history into physical proof after the fact.**

A useful incident record must preserve distinctions among:

1. safety demand / protective-device state;
2. safety-controller decision/output state;
3. downstream final-element feedback or EDM;
4. energy-path observations;
5. physical hazardous-effect observations;
6. ordinary LinuxCNC/FPGA commands and watchdog state as diagnostic context only;
7. reset, normal-control rearm, and START as separate transitions;
8. missing, stale, rebooted, or discontinuous evidence.

## Evidence provenance

### DOC-CONFIRMED — professional safety diagnostics preserve current and historical event detail

SICK HS80 operating instructions describe Flexi Soft Designer diagnostics showing current and past events/history, including timestamp, local time, source, category, description and detailed fields such as code, occurrence counter, power-on hour, operating hours, block/register and CPU channel.

Source: SICK, *HS80 Operating Instructions*, 8013518/YZ94/2017-12-15, Chapter 10.4.2 Extended diagnostics.

### DOC-CONFIRMED — not every device-originated diagnostic record contains its own timestamp

SICK Flexi Soft Gateway operating instructions document an EtherCAT diagnostic-history object with incoming/outgoing event markers and explicitly state that the FX0-GETC does not support a timestamp for that diagnostic-history object; if one is required, the reading device can add it when reading the diagnostic message. The same history is a bounded ring buffer and can report overflow.

Source: SICK, *Flexi Soft Gateways in Flexi Soft Designer*, 8014526/1KOF/2023-09-08.

This is important: a collector-added timestamp is evidence of **collection time**, not necessarily exact physical event time.

### DOC-CONFIRMED — diagnostic history can be a separate presentation/transport layer

Pilz PNOZmulti OPC Server documentation describes event-list entries being emitted as OPC UA events to subscribed clients, which can evaluate the diagnostic information. This supports treating exported event transport as a diagnostic channel distinct from the safety controller's actual safety authority.

Source: Pilz, *PNOZmulti OPC Server Operating Manual*, 1007149-EN-01, event log section.

## Minimum record envelope

Every event record should carry, where the source can actually provide it:

| Field | Minimum meaning | Why it matters |
|---|---|---|
| `record_id` | Unique collector record identity | Prevents ambiguity/duplicate handling |
| `machine_id` | Controlled machine/cell identity | Prevents logs from two machines being merged |
| `source_id` | Exact device/subsystem producing the observation | Separates safety controller, device, FPGA, LinuxCNC, drive, pressure witness, etc. |
| `source_type` | Safety device/controller, final-element witness, ordinary controller, HMI/collector, physical test witness | Makes evidence authority visible |
| `source_firmware_or_revision` | Version/revision if known | Incident reconstruction must be tied to the actual implementation |
| `configuration_identity` | Safety signature/checksum/project/revision or controlled config reference if available | Prevents analysis against the wrong configuration |
| `event_code` | Native event/fault/state code | Preserves source-native evidence |
| `event_text` | Human-readable rendering | Helps troubleshooting but does not replace native code |
| `event_class` | demand, fault, state transition, feedback, reset, rearm, start, power, network, configuration, maintenance/test | Supports chronology without flattening unlike events |
| `transition` | asserted/cleared/entered/exited/changed, when meaningful | A historical fault and a currently active fault are not the same thing |
| `value` | Source-native state/value | Avoids reconstructing values from prose later |
| `validity` | valid / stale / unavailable / invalid / unknown | Missing data must never silently become a safe state |
| `source_time` | Device-originated event time, only if actually supplied | Best available source chronology |
| `collector_time` | Time collector received/read event | Distinguishes collection from occurrence |
| `time_basis` | UTC/local/monotonic/device-cycle/unknown | Prevents false precision across clocks |
| `time_quality` | synchronized / unsynchronized / collector-added / discontinuity / unknown | Makes ordering confidence explicit |
| `sequence_or_cycle` | Device sequence, scan, monotonic counter or boot-relative cycle when available | Often more trustworthy than wall clock for local ordering |
| `boot_session_id` | Boot/power-cycle identity | Prevents ordering events across clock resets as one continuous session |
| `freshness_age` | Age or last-update witness where available | Exposes stale mirrors |
| `provenance_label` | SOURCE-CONFIRMED / DOC-CONFIRMED / TEST-CONFIRMED / COMMUNITY-REPORTED / INFERENCE / UNKNOWN | Keeps claim strength explicit |
| `operator_or_test_context` | production/setup/service/validation/test if known | Explains deliberate test transitions without declaring them safe |

Do not invent fields a source cannot supply. Use `UNKNOWN` or `UNAVAILABLE` and preserve the limitation.

## Safety chronology record groups

### A. Protective demand

Record the actual source identity and transition for E-stop, guard/interlock, protective field, enabling-device/mode demand, discrepancy, or other protective input. A LinuxCNC mirror of that state is secondary diagnostic context, not the primary event if the independent safety source is available.

### B. Safety logic / output

Record safety-controller state and relevant safety-output transitions separately from the input demand. Do not infer that an output transition proves the final element moved.

### C. Final-element witness

Record EDM/auxiliary contact, drive safety-function feedback, valve/brake witness, or other downstream feedback with its own source identity and validity. State exactly what the witness observes. An auxiliary contact does not prove every hazardous energy path is harmless.

### D. Energy-path / physical witness

Where commissioning or incident investigation has real measurements or physical observations, record them as separate events/observations. Examples may include verified isolation, measured voltage/pressure state, mechanical blocking/restraint, or observed hazardous motion response. Exact machine values remain measurement-bound.

### E. Ordinary control context

LinuxCNC/HAL/FPGA commands, proportional-current request, watchdog state, motion enable, commanded valve state and HMI actions are useful for chronology. Mark them as ordinary-control context. `COMMAND=0` is not transformed into `PHYSICAL SAFE STATE` in the log schema.

### F. Recovery transitions

Record separately:

- safety demand cleared;
- fault cleared/latched fault remains;
- reset permitted;
- safety reset action;
- safety-ready transition;
- ordinary-controller rearm/enable;
- deliberate normal START;
- first resulting motion/actuation observation where relevant.

This preserves the curriculum rule that reset/rearm/start are not synonyms.

## Time handling

### Do not require false global precision

A multi-device machine may contain unsynchronized clocks, devices with only cycle counters, collectors that timestamp on receipt, and networks that buffer/reorder messages. Therefore:

- preserve device-native sequence/cycle counters where available;
- preserve both source and collector time rather than replacing one with the other;
- identify time synchronization method/status when known;
- mark collector-added timestamps explicitly;
- record clock jumps, reboot/reset, daylight/local-time ambiguity, and synchronization loss;
- never claim sub-millisecond cross-device event order solely because formatted timestamps contain many digits.

For a safety incident, `A definitely preceded B according to one monotonic source` can be stronger evidence than two nominal UTC timestamps whose synchronization is unknown.

## Power and network discontinuity records

The record must positively represent discontinuity rather than simply leave a blank interval.

Useful events include:

- collector started/stopped/restarted;
- safety controller boot/restart if observable;
- LinuxCNC/FPGA boot/restart;
- safety diagnostic link lost/restored;
- ordinary fieldbus/network lost/restored;
- source timestamp/counter reset;
- sequence gap or diagnostic-buffer overflow;
- logging storage full/write failure;
- configuration identity changed.

A gap means `UNKNOWN DURING GAP`, not `no safety event occurred`.

## Live state versus history

Every display/export should distinguish:

- `LIVE ACTIVE` — source presently reports the condition;
- `LIVE CLEARED` — source presently reports it cleared;
- `HISTORICAL` — retained event, not a current-state claim;
- `ACKNOWLEDGED` — workflow state only;
- `STALE` — last known state exceeds its freshness contract;
- `UNAVAILABLE` — source cannot presently be read;
- `UNKNOWN` — evidence does not support a stronger statement.

Clearing a diagnostic-history list must not be represented as clearing the underlying safety condition.

## Configuration identity

Incident evidence is incomplete if investigators cannot establish which safety configuration and relevant normal-control configuration were active.

Where supported, preserve references to:

- safety project/signature/checksum/version;
- safety-controller hardware/firmware identity;
- relevant safety-device parameter/configuration identity;
- ordinary LinuxCNC config/HAL/FPGA build identity as diagnostic context;
- maintenance/test overrides, forces or temporary configuration active during the event.

If exact identity cannot be recovered, label it `UNKNOWN`; do not silently analyze the incident against today's configuration.

## Failure paths to teach explicitly

### F1 — collector timestamp presented as event timestamp

A gateway has no native event timestamp; the HMI timestamps it when read and later reports that time as exact physical occurrence.

**Control:** retain `collector_time` and `time_quality=collector-added`; do not manufacture source time.

### F2 — stale green mirror

Safety diagnostic communication stops after the last `READY` state. HMI continues displaying the cached value.

**Control:** freshness/validity is mandatory; communication loss yields unavailable/unknown, never inferred safe permission.

### F3 — command history promoted to proof

FPGA log shows valve/current command went to zero and incident report concludes hydraulic hazardous energy was controlled.

**Control:** command, final-element feedback, energy-path witness and physical effect remain different record classes.

### F4 — power cycle destroys chronology

A technician reboots before collecting native fault state; wall clock resets and the reboot is omitted from the exported log.

**Control:** boot-session identity and power discontinuity are first-class events. Preserve source diagnostics before reset where safe/practical.

### F5 — ring-buffer overwrite hides precursor

High event volume overwrites older diagnostic records or produces an overflow indication.

**Control:** record buffer-overflow/sequence-gap evidence and downgrade chronology completeness. Never interpret missing overwritten events as absence.

### F6 — acknowledgement/clear-history mistaken for reset

Operator acknowledges or clears a diagnostic list and later analysis says the safety fault was reset at that instant.

**Control:** diagnostic acknowledgement/history operations and safety reset are different event classes.

### F7 — clock synchronization creates false order

Two devices disagree in time; sorting by formatted UTC makes a final-element response appear to precede the safety demand.

**Control:** preserve time quality, source sequence and uncertainty; state order as `UNKNOWN` where evidence cannot resolve it.

## OpenPressBrake application

A future OpenPressBrake diagnostic recorder should be useful even though ordinary LinuxCNC/FPGA remains outside personnel-safety authority. At minimum, architect for independent capture or import of:

- safety-system demand/fault/readiness and source identity;
- downstream EDM/final-element feedback actually available from the chosen safety architecture;
- LinuxCNC machine/control state as context;
- FPGA watchdog and command-generation state as context;
- proportional-current request and measured current as normal-control/electrical evidence, not hydraulic-safe proof;
- hydraulic/pressure/mechanical observations only when real sensors/tests establish them;
- reset, rearm and START transitions separately;
- configuration/build identities;
- network/power/logging discontinuities.

Do not create a single `SAFE=true` historian field that erases these layers.

## Minimum incident export

An incident export should include:

1. machine and configuration identity;
2. source inventory and clock/time-quality notes;
3. raw/native event codes where available;
4. normalized event chronology without deleting source-native values;
5. validity/freshness and discontinuity markers;
6. explicit separation of command, safety output, feedback and physical observations;
7. operator/maintenance/test actions;
8. unresolved `UNKNOWN`s;
9. provenance labels for analytical conclusions;
10. immutable/reference copy of the relevant configuration evidence where policy permits.

## Evidence labels

- `DOC-CONFIRMED`: SICK and Pilz documentation establish concrete professional diagnostic-history/event transport behaviors used here.
- `INFERENCE`: the minimum cross-vendor schema and OpenPressBrake mapping are engineering synthesis.
- `SOURCE-CONFIRMED`: none required beyond manufacturer documentation in this artifact.
- `TEST-CONFIRMED`: none; no physical machine test was performed.
- `COMMUNITY-REPORTED`: none used.
- `UNKNOWN`: exact event fields, clock quality, diagnostic transport, buffer depth, EDM semantics and physical witnesses of the future selected OpenPressBrake safety hardware remain hardware/configuration dependent.

## Compute decision

No executable verification is justified. A synthetic logger test cannot establish physical safety authority or machine-specific event timing. No GitHub-hosted Actions minutes are to be consumed; the self-hosted `[self-hosted, openpressbrake]` runner remains reserved for a concrete question-driven verification need.

## Precise next independent work

Build `SAFETY_INCIDENT_RECONSTRUCTION_EVIDENCE_CONFIDENCE_WORKSHEET.md`: given mixed safety-controller events, ordinary-control logs, EDM/final-element feedback, power/network gaps and physical observations, classify each claimed transition as directly observed, bounded inference, conflicting, stale, or unknown. Include a rule that the reconstruction may remain partially unresolved rather than forcing a single narrative. Keep it independent of the primary lane's professional-implementation CCF/minimum-operate application work.