# 4400 — AKAS-5M serial diagnostics: delayed evidence is not safety authority

**2026-10-23 | original source investigation | learner-visible, not a hidden evaluation answer**

## Question and version boundary

Can an ordinary LinuxCNC/HMI application treat a serial diagnostic message from a Fiessler AKAS-5M as a fresh, complete, safety-authoritative indication that a press-brake closing stroke is permitted?

**Conclusion: no.** The serial output is useful for operator explanation and fault localization, but it must not substitute for the selected independent safety circuit, selected machine's physical stopping/holding evidence, or a fresh restart decision. This is a boundary statement, **not** a finding that a specific installation is unsafe.

**Manufacturer source (DOC-CONFIRMED):** Fiessler AKAS-5M operating instructions, English translation, document 1581, revision 2024-02-15, especially printed pp. 3–5, 25–26, 29–34. Official original: https://www.fiessler.de/default-wAssets/docs/download/AKAS/bdh-akas-5-original-engl-doc1581-v1.0.pdf . Check the actual selected variant and firmware before transferring these statements.

## What the original manual actually specifies

1. **Serial reporting is a diagnostic channel.** Printed p. 32 describes an RS-232 serial interface with 9600 baud, one start bit, eight data bits, one stop bit and even parity. The sender repeats messages at least three times with at least 100 ms between messages; the described receiver accepts only a valid message received three consecutive times and matching a listed message pattern. **DOC-CONFIRMED.**
2. **Messages have different semantics.** The same section distinguishes status/handling-direction messages, warnings, and interlock/error reports using bit-pattern categories. A message telling an operator what to check is not a measured safe-state proposition. **DOC-CONFIRMED.**
3. **Front-panel indicators describe device signals, not all machine hazards.** Printed p. 3 describes OSSD indicators, muting and box-bending indications. Printed p. 4 says the protective function is cancelled while the muting lamp is on and that the front receiver elements facing the operator do not protect when box bending was activated. **DOC-CONFIRMED.**
4. **An additional safety controller is part of the documented integration.** The manual's p. 26 section is explicitly headed as operation with an additional safety PLC. Its pp. 25 and 29–30 describe safety-related speed/position/blanking supervision and require further strokes to be prevented when specified comparisons fail. **DOC-CONFIRMED.**
5. **Tool and mode changes are safety-relevant.** Printed p. 30 says tool or sheet-thickness changes alter the position value; it describes a parameter-change notification and independent comparison in the safety controller. Printed pp. 4–5 require inspection after tool changes and distinguish protection limits. **DOC-CONFIRMED.**

## Visually checked manufacturer diagnostic examples (printed pp. 33–34)

The printed tables were inspected **as page images**, because flattened PDF text can misassociate a numeric code with an adjacent column. These are **DOC-CONFIRMED for document 1581**, not a tested decoder for another firmware:

| Decimal byte | Manufacturer table's meaning | Appropriate ordinary-HMI interpretation |
|---:|---|---|
| 195 | Box-bending function selected | Selected mode; **not** proof that front protective elements remain active |
| 215 | Muting; indirect protection by slow closing | Explicit `MUTING / DIRECT FIELD PROTECTION NOT ACTIVE`, never generic green `LASER SAFE` |
| 231 | Protective field interrupted during closing | Historical diagnostic event; actual stop/hold still separately witnessed |
| 146 warning / 145 interlock error | Safety-point sequence error: SP controlled before SSP | Record warning versus latched error distinctly; verify selected controller and wiring |
| 106 warning / 105 interlock error | Fast/slow signals faulty in stop state; SGS and SGO not equivalent | Distinguish ordinary speed command from independently monitored switching |
| 201 interlock error | Unequal slow-speed connections without prior warning | Do not assume every interlock has a preceding warning event |

Printed p. 34 explicitly permits some interlock errors **without prior warning**, and describes voltage reset as the way to cancel an interlocked status. That reset instruction is **not** a machine-level permission to restart motion; independent reset, cleared hazards and fresh ordinary start remain separate. The tables also contain a foot-pedal input short-circuit example, demonstrating why a readable code can aid maintenance without taking safety authority. **DOC-CONFIRMED source, INFERENCE HMI policy.**

## Diagnostic pipeline and the missing timing proof

`AKAS physical/receiver state -> serial message creation -> repeated RS-232 frames -> host serial receive/validation -> ordinary HMI tag -> operator display`

The manual describes *minimum spacing and repetition conditions*, not an end-to-end maximum freshness guarantee for the host UI. A three-frame acceptance rule does **not** imply that a cached tag remains valid forever or that all device transitions appear in the HMI with bounded delay. Neither the serial interface nor a green indicator supplies an independent measurement of actual ram stopping or sustained holding. **INFERENCE from DOC-CONFIRMED interface scope.**

Do not infer an exact worst-case display delay from the 100 ms minimum inter-message gap. Frame scheduling, reception loss, buffering, host polling, timeout behavior and device-version behavior are not established here. **UNKNOWN.** No bench serial trace or physical machine test has been performed.

## Proposed *ordinary diagnostic* contract (INFERENCE; not a safety design)

A LinuxCNC-facing diagnostics adapter should expose separately:

| Field | Intended meaning | Fail-closed display behavior |
|---|---|---|
| `device_model / firmware / configuration_id` | Identifies the documented source and applicable decoder | Unknown identity -> `UNVERIFIED` |
| `frame_received_utc / accepted_utc` | Distinguishes transport observation from application acceptance | Never synthesize timestamps |
| `raw_frame / decoder_revision` | Preserves provenance for offline analysis | Decode failure -> `UNKNOWN` |
| `message_category / message_code` | Status, warning, interlock, or unrecognized | Unrecognized -> `UNKNOWN` |
| `transport_health / age / host_session_epoch` | Host-assigned session epoch and age reveal disconnected, late or replayed observations; the manual does not specify a device sequence counter | Stale -> `STALE`, not `OK` |
| `machine_protection_status` | **Not derivable from serial alone** | Always requires separate safety/physical qualification |

An ordinary HMI may say `AKAS diagnostic message received` or `AKAS diagnostic stale`. It must not turn that into `hands protected`, `ram held`, `maintenance isolated`, or `safe to restart`.

## Failure-path and adversarial desk review

- **Lost serial connection, unchanged last code:** show `STALE/UNKNOWN`; do not retain a green `Laser OK` merely because no new error arrived. The independent safety circuit must not depend on the HMI connection.
- **Valid three-frame diagnostic but muting active:** distinguish valid transport from a currently disabled protective field. A valid code cannot restore muted coverage.
- **Tool height changed, old recipe retained:** mark geometry, safe-point/blanking, dependent `SRS/PHY/VAL/PT` and change record `CHG` stale. Requalification is required before exposure.
- **OSSD healthy but ram still drifts:** stop/hold proposition unresolved or failed; investigate actual hydraulic/gravity path. The serial decoder cannot overrule independent physical evidence.
- **Reset or power cycle with a held ordinary start command:** require independent safety rearm and a fresh intentional ordinary start. Serial `ready` is not a motion authorization.
- **Operator disables noisy diagnostics to avoid nuisance alarms:** redesign display, fault localization and maintenance workflow to make correct safeguarding easier, without silencing the independent protective function.

## Traceability and verification plan

Create separate `BND` (mode/tool/exposure), `AUTH` (independent safety versus normal UI), `DEP` (serial transport/decoder and actual final element), `CHG` (firmware/decoder/tool), `HF` (nuisance-alarm/defeat pressure), `UNK` (maximum serial age and machine topology), `PHY` (actual stop/hold), `VAL/PT` (selected-machine proof). Treat serial receipt as a *diagnostic observation*, never a `PHY` witness.

**Bounded future evidence only if needed:** With an identified device and safe, non-hazardous diagnostic setup, capture raw serial frames and monotonic receive timestamps across status changes, disconnect/reconnect, repeated identical frames and decoder upgrades. This would establish selected interface behavior, **not** certify a machine. There is no reason to dispatch a simulator or runner for this documentary distinction.

**Evidence:** `DOC-CONFIRMED` manufacturer manual claims above; `INFERENCE` proposed HMI contract and failure dispositions; `UNKNOWN` host timing, selected variant and actual machine; `TEST-CONFIRMED` none. External 2520–25F0 competency gates remain open. No hazardous operation with people exposed is authorized by this note.
