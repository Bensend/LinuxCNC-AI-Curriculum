# 3600 — Press-brake `bend sensor` semantic source audit

Date: 2026-09-12

## Scope and reason for reopening the branch

F02 remains externally gated, so generic 3600 work is at the documented information-gain stop. This branch was reopened only because a fresh source search exposed inspectable press-brake code using the phrase **bend sensor**. The purpose was to determine whether that phrase represented active bend-angle sensing/correction or a different process signal.

## Source identity

Repository: `aleadvea/press-brake-cnc-upgrade`
Pinned revision: `95cf12f639b036f80541b00128e0a31c5dcc9050`

Relevant source:

- `motor_brain/src/motor_ctrl.cpp`
- `motor_brain/src/main.cpp`
- `motor_brain/src/espnow_motor.h/.cpp`
- `motor_test/src/espnow_hmi.h/.cpp`
- `motor_test/src/ui_auto.cpp`
- `docs/WIRING_GUIDE.md`

This is non-LinuxCNC embedded firmware, used here only as public machine-domain implementation evidence.

## Source-confirmed finding: this `bend sensor` is not an angle sensor

`PIN_BEND` is read as a digital input. The status protocol carries one byte/boolean `bend_sensor`; there is no measured angle, confidence, sample generation, left/right measurement, target angle or correction magnitude in this path.

The firmware comments and packet definitions describe the input as an NC contact where HIGH means the contacts are open. The HMI stores that bit as `g_machine.bend_sensor`.

Therefore the phrase **bend sensor** in this implementation means a binary press-cycle/process-contact witness, not active angle measurement.

Classification: **SOURCE-CONFIRMED** at the pinned revision.

## Call / data flow

Motor side:

`PIN_BEND electrical state`
→ `digitalRead(PIN_BEND)`
→ `motor_ctrl_bend_tick()` local edge detector
→ optional local backgauge retract when motor-side retract ownership is enabled

and independently:

`digitalRead(PIN_BEND)`
→ `motor_get_bend()`
→ `StatusPacket.bend_sensor`
→ ESP-NOW status transmission.

`motor_brain/src/main.cpp` calls limit handling, driver-alarm handling, `motor_ctrl_bend_tick()`, and `espnow_motor_send_status()` in a status task with a nominal 30 ms delay.

HMI side:

`StatusPacket.bend_sensor`
→ `g_machine.bend_sensor`
→ `ui_auto.cpp:auto_timer_cb()`

The AUTO UI timer is created at 50 ms. In `AS_WAIT_BEND`, a LOW→HIGH transition sends the retract move and changes to `AS_RETRACTING`. In `AS_RETRACTING`, a later HIGH→LOW transition changes to `AS_PAUSE`, after which the program can advance.

This is process sequencing based on a binary phase signal. It is not closed-loop correction of bend angle.

## Important comment/behavior inconsistency

`motor_ctrl_bend_tick()` contains a comment describing LOW→HIGH as "bending finished -> retract". However:

- packet/header comments describe HIGH/open contacts as bending active;
- HMI AUTO logic treats LOW→HIGH as the event that starts retract while displaying that it is waiting for bend end;
- HMI then treats HIGH→LOW as the transition to the post-bend pause.

The executable HMI state machine therefore supports the interpretation **rising edge = bend-active/start witness; falling edge = bend-end witness** for AUTO sequencing. The motor-side prose comment is inconsistent with that behavior and must not be elevated over executable logic.

Classification: **SOURCE-CONFIRMED conflict in comments/semantics**. Physical switch mechanics and exact press linkage remain unverified here.

## Ownership boundary exposed by the source

The project contains two potential retract owners:

1. motor-side `motor_ctrl_bend_tick()` can issue automatic retract directly when `s_retract_enabled` is true;
2. AUTO HMI state logic can issue its own retract move after observing the transmitted bend bit.

`ui_auto.cpp` explicitly takes retract ownership by saving the prior setting, disabling motor-side automatic retract through a sync command, and later restoring it. That is a concrete implementation of an ownership-transfer pattern rather than assuming two layers may safely react to the same edge.

This supports a reusable 3600 rule:

> A process sensor can be observed by multiple layers, but motion authority responding to that sensor needs an explicit owner. Observation and authority are separate.

It also reinforces that a machine-domain term such as `bend sensor` is insufficient to infer sensor dimensionality or control authority.

## Freshness and timing boundary

The inspected path has nominal motor-side 30 ms polling/status cadence and HMI AUTO evaluation at 50 ms. The packet carries the current boolean value but no sample generation, source timestamp, edge sequence number or explicit age.

Consequences:

- a HMI transition is based on the most recently received boolean state, not a source-identified measurement episode;
- an edge may be observed later than the physical transition;
- packet freshness/generation is not encoded in the semantic payload;
- this implementation cannot establish the stronger freshness contract needed for active angle feedback merely because it transmits a sensor bit.

These are source-level observations about the data model, not a claim that the observed latency is unsafe or unacceptable for this machine.

## Relation to current 3600 measured-angle model

This source does **not** resolve the open active sensor-bending question. Instead it sharpens the vocabulary boundary:

- **binary bend/process sensor:** phase/contact witness suitable for sequencing/retract ownership;
- **measured-angle sensor:** quantitative process measurement requiring value, validity/freshness, phase qualification, correction provenance and bounded correction authority.

Do not treat the first as evidence for the second.

## Adversarial boundary check — 6/6 PASS

1. Does the variable name `bend_sensor` prove angle measurement? **No.** The payload and reads are boolean.
2. Does HIGH by itself prove "bend complete"? **No.** Executable HMI transitions contradict the motor-side prose comment; physical semantics require the full state-machine/context trace.
3. Can both motor firmware and HMI independently retract from the same edge in AUTO? **They are capable of it in principle, but AUTO deliberately disables motor-side retract and assumes ownership.**
4. Does a 30 ms status producer plus 50 ms HMI timer create a freshness identity? **No.** Cadence is not generation/timestamp provenance.
5. Does this source supply an active springback/angle-correction algorithm? **No.** No quantitative angle/correction path exists in the inspected flow.
6. May this source be used as a LinuxCNC implementation claim? **No.** It is machine-domain source evidence only; LinuxCNC integration semantics remain separate.

## Evidence classification

- Binary bend input and edge handling: **SOURCE-CONFIRMED**.
- Motor-side vs HMI retract ownership transfer: **SOURCE-CONFIRMED**.
- 30 ms motor status task / 50 ms HMI AUTO timer: **SOURCE-CONFIRMED nominal software cadence**.
- Physical sensor linkage, bounce characteristics and machine timing: **UNKNOWN**.
- Active bend-angle acquisition/correction: **SOURCE UNAVAILABLE in this project**.

## Information-gain decision

This was useful because it prevents a false-positive source match: public code mentioning a `bend sensor` does not automatically satisfy the curriculum's active sensor-bending evidence requirement.

No synthetic laboratory experiment is justified. A toy boolean edge fixture would only reproduce code already visible in source and would not establish physical sensor behavior or quantitative angle-control semantics.
