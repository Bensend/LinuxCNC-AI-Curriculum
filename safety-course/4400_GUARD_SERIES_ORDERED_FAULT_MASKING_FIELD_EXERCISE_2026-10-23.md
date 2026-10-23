# 4400 / 2590 — Technician exercise: which guard opened first?

**Open-book training; not a blind benchmark or a machine commissioning authorization.** Intended for a fresh engineer or technician. Read the source note `../research/4400_ISO14119_2024_SERIES_FAULT_MASKING_EDITION_AND_LOGIC_2026-10-23.md` and the selected product manuals before scoring a real installation. Do not create evaluator-only hidden solutions in this learner-facing artifact.

## The machine

A generic two-gate automated cell uses two normally-closed contacts per guard. Channel 1 is `A1 AND B1`; channel 2 is `A2 AND B2`. A contact in gate A's first channel has shorted permanently closed. The operator routinely opens B to remove scrap, then A to clean the fixture, then closes A before B. No per-guard sensing is available at the receiver. The machine also has a separate safety-related output and downstream final elements; their exact models and stopping performance are **UNKNOWN**.

## Tasks (record answers and evidence)

1. Draw the four receiver input transitions for B-open -> A-open -> A-close -> B-close. State whether a simple channel-discrepancy monitor necessarily sees the A1 fault. Show the Boolean values, not only a narrative.
2. Repeat for A-open -> B-open -> B-close -> A-close. Identify the first moment a discrepancy becomes observable, and distinguish observability from the selected receiver's **actual** fault latching.
3. The HMI says `Last trip = Gate B` and `Safety chain restored`. What *exact* propositions could these fields support? What physical or safety-function propositions do they **not** support?
4. Propose two cost-conscious architectures that improve diagnostics. For each, list the selected device/receiver manuals, compatibility and common-cause checks still needed. Do not assume a device PL label equals the achieved machine PL.
5. A mechanic reports that the interlock is hard to align, so they routinely bypass it while servicing. Identify the motivating inconvenience, a design correction that makes correct restoration easier, and the separate maintenance-isolation proof required before entry.
6. A robot-cell technician remains inside after the gates close; a press-brake beam may descend despite the gate status; a lathe spindle may coast. For each, write a distinct `PHY-*` proposition and appropriate **independent** physical witness, leaving machine-specific limits UNKNOWN.
7. Which of these changes makes the existing `VAL-*` evidence STALE: adding gate C in series, changing firmware, switching to an electronic cascade, changing the HMI first-trip field label, or moving the reset station? Explain the affected dependency for each.

## Manufacturer-tag transfer case (432ES-IG3, documentary only)

The Rockwell 432ES manual documents a **broken GuardLink link during topology modification**. The example can show `Ch0.Status=0`, `Ch0.Fault=1`, `Ch0.UnverifiedDevice=1`, `Ch0.DeviceTripAddress=-2`, and `DeviceCount` temporarily retaining the earlier count. A `TerminatorFault=0` is not proof that the terminator is present. The manual identifies `Ch0.Status` as a SIL3/PLe safety bit for its channel, while the **different** 440R-ENETR is a non-safety-rated monitoring interface.

8. Write a technician-facing diagnosis that **does not** translate `-2` into a specific gate number, treat the stable count as topology proof, or infer that the beam/spindle/robot is physically safe from `Status=0` alone.
9. An HMI shows four fault-history rows. The Rockwell Safety Device Library example uses the first row for the active fault if present, with the other rows historical. Explain how the display should distinguish current, historical, unknown and stale data.
10. After a same-type device replacement, list the evidence required to prove the physical guard-to-device mapping and selected safety function before rearm. Do not use a successful software identity check as sole physical evidence.

These questions use published manufacturer examples, not live selected-firmware behavior. Do not operate a hazardous machine to reproduce them.

## Evidence/qualification worksheet

| ID | Required entry | Your evidence and classification | Status/UNKNOWN |
|---|---|---|---|
| `BND/HAZ` | who accesses which hazard, when and why | | |
| `SF/PHY` | what must stop/hold/isolate; what does not prove it | | |
| `SRS` | required response, deliberate reset, independent start, acceptance | | |
| `AUTH` | ordinary control / diagnostics / independent safety / physical final element | | |
| `DEP` | shared NC series path, common supply, fault masking, receiver fault memory | | |
| `HF` | fault-localization burden, guard alignment, bypass motivation | | |
| `ARC` | exact candidate chain and compatible selected products | | |
| `VAL/PT` | input-level observation and separately witnessed final-element/physical response | | |
| `CHG/UNK/RR` | stale evidence, missing machine facts, restrictions | | |

## Decision gates

- [ ] The contact-order counterexample is traced without claiming a particular receiver's hidden logic.
- [ ] Current guard state is not inferred from a *first-trip event* alone.
- [ ] The HMI is not assigned personnel-safety authority.
- [ ] Stopping, holding, access, occupancy, and maintenance isolation are separate physical propositions.
- [ ] No DCavg, PL/SIL, stopping distance, pressure or test interval is invented.
- [ ] Any unresolved minimum protection blocks personnel-exposed hazardous operation.

**Do not perform live guard-defeat tests on operating machinery.** A selected-product bench test, if ever justified, requires an independently safe low-energy arrangement and predeclared observable result.
