# Safety fault diagnostic annunciation and troubleshooting boundary

Date: 2026-09-17
Lane: independent safety curriculum lane B

## Purpose

Define a practical architecture for presenting and troubleshooting safety-related faults without allowing an HMI, LinuxCNC, HAL, FPGA, maintenance screen, alarm acknowledgement, or diagnostic network to become personnel-safety authority by convenience.

This artifact is deliberately independent of the primary lane's commissioning/fault-injection package. It does not define machine-specific validation values, stopping distances, hydraulic truth tables, PL/SIL/DC, or acceptance times.

## Frozen rule

**A diagnostic channel may explain a safety state; it must not be allowed to manufacture, suppress, reset, or bypass the independent safety state merely because it has a convenient user interface.**

A useful diagnostic system answers four different questions separately:

1. **What demanded the safety function?** — E-stop, guard, protective field, mode fault, channel discrepancy, EDM disagreement, device fault, etc.
2. **What safety state exists now?** — demand active, fault latched, reset permitted/not permitted, final element not proved, safety ready, etc.
3. **What physical evidence is still missing?** — guard closure, contactor/valve feedback, released E-stop, restored device, cleared discrepancy, verified wiring, revalidation after repair.
4. **What operator/maintenance action is permitted next?** — inspect, isolate energy, repair, perform controlled reset, perform separate normal start, or keep OUT OF SERVICE.

Collapsing these into one generic `FAULT`, `SAFE`, `READY`, or `RESET` indication creates troubleshooting ambiguity and encourages bypass behavior.

## Evidence provenance

### DOC-CONFIRMED — safety-controller diagnostics are not permission to continue operating with an unidentified fault

SICK Flexi Soft operating instructions, diagnostics chapter, instruct users to cease operation if the cause of a malfunction cannot be clearly identified or safely remedied, and require a complete functional test after remedying a malfunction. The same documentation distinguishes configuration errors, recoverable errors, and critical faults, with different effects on safe outputs/process data.

Source: SICK, *Flexi Soft Hardware*, operating instructions 8012478, Chapter 10 Diagnostics: https://www.sick.com/media/content/h13/h46/9693001941022.pdf

### DOC-CONFIRMED — local device diagnostics and connected-device diagnostics both matter

SICK HS80 instructions state that Flexi Soft diagnostic information can come from controller LEDs and Flexi Soft Designer, and that when errors occur connected devices should also be checked for their own displayed errors.

Source: SICK, *HS80 Operating Instructions*, fault diagnosis / Flexi Soft diagnostics: https://www.sick.com/media/docs/3/53/953/operating_instructions_hs80_en_im0076953.pdf

### DOC-CONFIRMED — a safety relay can refuse reactivation after a physically relevant fault

Pilz PNOZ s2 documentation states that welded contacts prevent reactivation after the input circuit has opened and provides distinct diagnostic/remedy paths for supply, configuration/selector, terminator, and internal faults.

Source: Pilz, *PNOZ s2 Operating Manual*, 21394-EN-08: https://www.pilz.com/download/open/PNOZ_s2_Operat_Man_21394-EN-08.pdf

### DOC-CONFIRMED — diagnostic-history suppression is not necessarily suppression of the safety response

Current SICK Flexi Soft Designer documentation describes an `Inhibit error indication` function for a motion cross-check: it can inhibit a diagnostics-history entry while the error response/status behavior remains effective. This is useful evidence for keeping **fault response** and **fault reporting/history** as separate architectural concepts.

Source: SICK, *Flexi Soft in Flexi Soft Designer*, 8012480/T157/2025-07-30, motion-control cross-check diagnostics.

## Required architectural separation

| Layer | May do | Must not be assumed to do |
|---|---|---|
| Safety device / safety controller | Detect safety demand/fault; enforce specified safety response; determine safety reset permissibility | Provide all maintenance root-cause detail or prove physical hazardous-energy removal by an HMI message alone |
| Final-element feedback / EDM | Provide evidence about downstream commanded/feedback agreement | Prove every physical energy path is harmless |
| LinuxCNC / HAL / normal FPGA | Display states, log events, inhibit normal commands, guide troubleshooting | Override independent safety demand, synthesize safety permission, clear a physical fault, or replace safety reset authority |
| HMI / alarm system | Present cause, affected function, state, next allowed action, evidence links | Turn `ACKNOWLEDGED` into `SAFE`, `RESET`, or `START` |
| Historian / log | Preserve chronology and diagnostic context | Be treated as the live safety function or sole proof that a fault is absent |

## State vocabulary

Prefer explicit states over a single red lamp:

- `SAFETY DEMAND ACTIVE` — a protective function is presently demanded.
- `SAFETY FAULT ACTIVE` — a diagnosed safety-related fault/discrepancy is active.
- `FINAL ELEMENT NOT PROVED` — commanded safe state and required feedback do not establish the expected downstream state.
- `RESET NOT PERMITTED` — prerequisites for safety reset are not met.
- `RESET PERMITTED` — prerequisites are met; this is **not** motion permission.
- `SAFETY READY` — independent safety system is in its specified ready state; normal-control start permission remains separate.
- `OUT OF SERVICE` — maintenance/revalidation status prevents normal production operation.
- `UNKNOWN — EVIDENCE REQUIRED` — the system or maintainer lacks evidence needed for a stronger claim.

The exact state names may differ by implementation; the separation is the important part.

## Alarm acknowledgement boundary

Alarm acknowledgement should mean only **the diagnostic message was seen/accepted for workflow purposes** unless a specific safety architecture explicitly defines otherwise.

Do not map a generic HMI `ACK`, `CLEAR ALL`, `RESET ALARMS`, LinuxCNC state transition, or FPGA reboot to an independent safety reset merely to reduce operator steps.

A safety reset, when required, must obey the safety-system architecture. A subsequent normal machine start remains separate where the safety requirements require it.

## Troubleshooting ladder

When a safety-related diagnostic appears:

1. **Preserve the safe state.** Do not defeat the protective function to make the message disappear.
2. **Identify the demanding function and affected hazard zone.** If the cause cannot be clearly identified or safely remedied, keep the machine stopped/out of service.
3. **Read the safety device/controller diagnostics at their source.** Do not rely solely on a LinuxCNC mirror bit or HMI summary.
4. **Check connected-device diagnostics.** A controller may only report that an input/device is invalid while the device provides the useful root cause.
5. **Trace final-element feedback separately.** A safety output changing state does not prove a contactor, drive safety function, valve, brake, or other physical element responded.
6. **Before exposed servicing, apply the required hazardous-energy isolation/control.** Diagnostic mode is not energy isolation.
7. **Repair the cause, not the indication.** Do not suppress discrepancy monitoring, bridge a guard, force feedback, or rewrite alarm logic to obtain green status.
8. **Revalidate the affected function after repair/change to the extent required by the change.** A cleared alarm alone is not validation.
9. **Perform safety reset/rearm according to the independent safety architecture.**
10. **Use a separate deliberate normal start where required.**

## Failure paths to teach explicitly

### F1 — green HMI, unsafe physical condition

The HMI receives a stale, copied, inverted, or incomplete status and displays `SAFE` while the independent safety system or physical final element disagrees.

**Rule:** safety status displays should expose freshness/source and disagreement where practical; they are diagnostic aids, not safety permission.

### F2 — `CLEAR ALL` becomes a bypass

A convenience button clears alarms, resets safety logic, rearms normal control, and starts/re-enables outputs in one action.

**Rule:** acknowledgement, safety reset, normal rearm and start remain distinguishable actions/states.

### F3 — nuisance fault pressure

A recurring guard/EDM/discrepancy alarm is treated as a productivity problem, so someone suppresses the alarm or forces the input.

**Rule:** recurring nuisance trips trigger root-cause investigation. Making the diagnostic disappear without preserving the protective function is not a repair.

### F4 — diagnostic network loss hides a live demand

LinuxCNC/HMI loses the safety diagnostic network or mirrored I/O while the independent safety controller continues enforcing a safe state.

**Rule:** diagnostic communication loss must not create safety permission. The HMI should represent the state as unavailable/unknown rather than infer `SAFE` from missing data.

### F5 — fault history is mistaken for current state

A historical event remains displayed after the physical fault is gone, or a suppressed history entry is mistaken to mean no fault response occurred.

**Rule:** distinguish current live state, latched diagnostic history, acknowledgement state and safety response.

### F6 — technician clears symptom before collecting evidence

Power cycling or resetting immediately erases the chronology needed to find intermittent wiring, channel discrepancy or final-element faults.

**Rule:** where practical, capture source-device diagnostic code/state and relevant independent observations before reset, without delaying urgent hazard control.

### F7 — ordinary controller reports the command it sent as proof of response

LinuxCNC/FPGA reports `ENABLE=0` or `VALVE=0` and the HMI says `SAFE` without independent final-element/energy-path evidence.

**Rule:** command, safety output, feedback, energy state and hazardous physical effect remain separate evidence layers.

## OpenPressBrake application

For an OpenPressBrake HMI, ordinary LinuxCNC/HAL/FPGA should be useful diagnostically without becoming the safety controller. A practical screen may show, separately:

- safety-system communication healthy/unknown;
- E-stop/protective-device demand identity;
- safety-controller fault/discrepancy identity;
- reset permitted/not permitted;
- safety outputs as reported by the safety system;
- independent downstream feedback/EDM where available;
- normal FPGA watchdog/current-loop status;
- normal hydraulic command state;
- machine OUT-OF-SERVICE/revalidation status.

Do **not** combine these into one `Machine Safe` bit. In particular, zero proportional-current command is not proof of hydraulic safe state; an HMI safety-ready indication is not proof of gravity restraint; and a normal FPGA watchdog trip is fault containment rather than personnel-safety authority unless future evidence establishes otherwise.

## Human-factors design rule

A useful safety diagnostic should tell the operator or maintainer **what happened, what remains unsafe or unknown, and what legitimate next action exists**. It should not merely flash an opaque code that pressures users to bypass the system.

Provide accessible source-device diagnostics, plain-language mapping, wiring/device references, and a clear escalation path. If normal troubleshooting routinely requires defeating a safeguard, treat that workflow as a design defect and redesign the diagnostic/service access where feasible.

## Evidence labels and unknowns

- `DOC-CONFIRMED`: the cited SICK/Pilz documents establish concrete diagnostic/fault behaviors for their products.
- `INFERENCE`: the layered HMI/troubleshooting architecture is engineering synthesis from those documented behaviors and the curriculum's already-frozen independent-safety boundary.
- `UNKNOWN`: exact diagnostic codes, reset prerequisites, EDM semantics, safe-output behavior, hydraulic final-element state and fault-recovery sequence for any specific OpenPressBrake implementation until the selected safety hardware and machine architecture are fixed and validated.
- `TEST-CONFIRMED`: none in this artifact.
- `COMMUNITY-REPORTED`: none used.
- `SOURCE-CONFIRMED`: none required beyond manufacturer documentation for this study.

## Compute decision

No executable verification is justified. This is documentation/architecture work; synthetic software tests would not establish physical safety authority or machine-specific fault behavior. No GitHub-hosted Actions minutes are to be consumed.

## Precise next independent work

Build `SAFETY_DIAGNOSTIC_EVENT_RECORD_MINIMUM_SCHEMA.md`: define the minimum event record needed to reconstruct a safety fault without confusing command state with physical proof. Include monotonic/UTC time handling, source identity, configuration identity, live-vs-history state, demand/fault transitions, final-element feedback, normal-controller state as diagnostic-only context, reset/rearm/start transitions, power/network discontinuities, evidence provenance, and explicit handling of unavailable/stale signals. Keep it independent of the primary commissioning/fault-injection package.