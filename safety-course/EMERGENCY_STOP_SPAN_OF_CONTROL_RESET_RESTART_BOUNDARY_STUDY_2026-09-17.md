# Emergency-stop span-of-control, reset, and restart boundary study

Date: 2026-09-17
Lane: independent safety lane B

## Question

How should a modular machine or cell reason about an emergency-stop demand when not every hazard necessarily needs the same final response, while preventing reset/restart logic from silently turning an E-stop release into hazardous motion?

This is an architecture/evidence study, not an OpenPressBrake machine-specific design. No stopping distance/time, PL/SIL/DC, hydraulic truth table, pressure threshold, or machine-zone assignment is claimed.

## Evidence vocabulary

- **SOURCE-CONFIRMED** — directly supported by a public manufacturer/standards-oriented source.
- **DOC-CONFIRMED** — supported by an identified machine/device document applicable to the installed configuration.
- **TEST-CONFIRMED** — demonstrated on the actual machine/configuration by a bounded test.
- **COMMUNITY-REPORTED** — useful implementation experience, not authoritative proof.
- **INFERENCE** — engineering conclusion derived from evidence but not itself directly stated by the source.
- **UNKNOWN** — requires machine-specific evidence.

## Source trace

### 1. Emergency stop is a complementary protective measure, not ordinary process control

**SOURCE-CONFIRMED.** Pilz's machinery-safety guidance states that an emergency-stop command is manually initiated to stop hazardous movement, remains latched until manually released, and is a complementary protective measure rather than the primary means of risk reduction.

Source: Pilz, "Emergency stop is operated on a machine" FAQ and emergency-stop guidance:
- https://www.pilz.com/en-IE/support/faq/standards/articles/180045
- https://www.pilz.com/en-US/support/lexicon/articles/072716

**Architecture consequence — INFERENCE:** LinuxCNC feed hold, motion pause, HAL state, FPGA command zero, HMI cycle stop, or a normal PLC MCR-like software zone must not be promoted into personnel-safety E-stop authority merely because it can stop production motion.

### 2. Reset belongs to the actuated E-stop device; reset is not restart

**SOURCE-CONFIRMED.** Pilz's FAQ, explicitly citing DIN EN ISO 13850, says the emergency-stop device that initiated the command is reset directly at that device by intentional human action. It also states that reset must not itself restart the machine; it only prepares the machine to restart. If the hazard area cannot be fully checked from that location, additional restart/reset-related controls may be needed and must be addressed by the machine risk assessment.

Source: https://www.pilz.com/en-IE/support/faq/standards/articles/180045

**Frozen curriculum rule:**

`E-STOP DEVICE RELEASED` != `SAFETY FUNCTION RESET` != `ORDINARY CONTROL REARMED` != `START COMMAND` != `HAZARDOUS MOTION`

These transitions may be combined only where the applicable safety design explicitly permits it and the physical machine evidence validates the result. In the generic curriculum they remain separate states.

### 3. Emergency stop need not mean all machine energy is removed

**SOURCE-CONFIRMED.** Pilz distinguishes emergency stop from emergency switching-off and states that an emergency stop need not disconnect the complete machine energy supply.

Source: https://www.pilz.com/fr-CA/support/law-standards-norms/iso-standards/choosing-guards/emergency-stop

**Architecture consequence — INFERENCE:** an E-stop result must be described hazard-by-hazard and final-element-by-final-element. Examples of distinct claims include drive STO, controlled stop followed by STO, contactor opening, hydraulic pump removal, safe valve state, pneumatic exhaust, load holding, brake application, and mechanical restraint. `E_STOP_ACTIVE = true` is not physical proof that all hazardous energy is absent.

### 4. Different safety functions can legitimately have different enabling-path behavior

**SOURCE-CONFIRMED.** Schmersal's SRB400CS documentation describes a two-function safety monitoring module with two enabling-path levels having different shutdown behavior; its example says emergency exit opens both enabling paths while guard-door monitoring opens only the second enabling path.

Source: https://products.schmersal.com/en_IO/srb400cs-24vdc-101176209

This is useful evidence that safety architecture can intentionally produce different final responses for different protective demands. It does **not** establish any particular OpenPressBrake zone or span of control.

## Span-of-control reasoning model

For each emergency-stop actuator, record the following without collapsing rows:

| Evidence item | Required question | Generic status |
|---|---|---|
| Actuator identity | Which physical E-stop was operated? | UNKNOWN per machine |
| Hazard span | Which hazards can the person reasonably expect this actuator to stop? | UNKNOWN per machine |
| Safety input path | What independent safety input/logic receives the demand? | UNKNOWN per machine |
| Final elements | Which contactors/STO/valves/brakes/etc. are commanded? | UNKNOWN per machine |
| Physical result | Which hazardous motions/energy states actually become controlled? | TEST-CONFIRMED required for installed claims |
| Unaffected equipment | What remains energized or capable of motion, and why is that acceptable? | UNKNOWN per machine |
| Indication | Can operators tell what span was stopped and what remains live? | UNKNOWN per machine |
| Reset location | Where is the actuated device physically released? | machine-specific |
| Visibility / personnel check | Can the affected hazard area be checked before restart? | UNKNOWN per machine |
| Safety reset | What intentional action restores safety readiness? | UNKNOWN per machine |
| Ordinary-control rearm | How are stale LinuxCNC/HAL/FPGA commands prevented from regaining authority? | UNKNOWN per machine |
| Start | What separate deliberate command initiates operation? | UNKNOWN per machine |

## Failure-path challenges

1. **Ambiguous span:** operator presses the nearest E-stop believing it stops the whole machine, but a neighboring hazardous zone remains active.
2. **Overbroad span:** one local demand unnecessarily removes unrelated energy, creating a secondary hazard or defeating availability enough that operators seek bypasses.
3. **Reset-as-start:** twisting out the mushroom causes safety outputs and ordinary commands to recover together and motion resumes.
4. **Stale ordinary command:** E-stop removes safety authority while LinuxCNC/HAL/FPGA retains a nonzero command; after reset the command is immediately effective.
5. **Remote reset misconception:** HMI clears an `E-stop active` diagnostic while the physical actuated device remains latched, or software acknowledgement is mistaken for physical reset.
6. **Invisible affected area:** restart is possible from a station that cannot establish whether a person remains in the hazard area.
7. **Energy-state overclaim:** E-stop opens a drive STO path but hydraulic/gravity/stored-energy hazards remain; HMI reports simply `SAFE`.
8. **Cross-zone common cause:** shared safety I/O power, common wiring, shared configuration, or one final element can make two apparently independent zones fail together.
9. **Unclear indication:** personnel cannot determine whether a local E-stop is local, cell-wide, or machine-wide.
10. **Maintenance misuse:** E-stop is treated as servicing isolation even though stored or non-motion energy remains.

## LinuxCNC/OpenPressBrake boundary

The ordinary controller may receive safety status for diagnostics and may be required to drop/clear its own command state on a safety demand. That is valuable defense in depth. However:

- LinuxCNC/HAL/FPGA status is not the sole authority for a personnel-safety E-stop function.
- A software `machine off`, feed hold, motion inhibit, watchdog, or command-zero is not automatically equivalent to the independent safety final-element chain.
- Safety reset should not silently restore stale ordinary command authority.
- The safety system may tell ordinary control that rearm is permitted; ordinary control still needs an explicit, fresh transition before hazardous commands become effective.
- Maintenance isolation remains a separate claim from emergency stop.

## Verification package for a real machine

A machine-specific validation should trace each physical E-stop from actuator through safety logic to every credited final element, then observe the actual hazardous result. Challenge every actuator individually, including loss/fault cases where practical and justified. Record which equipment remains energized. Verify that releasing the actuator does not restart motion, that any required personnel/area check is possible, and that stale ordinary-control commands cannot become effective without the intended rearm/start sequence.

Evidence should be recorded separately as DOC-CONFIRMED and TEST-CONFIRMED. A successful HMI indication alone cannot promote a physical final-element claim to TEST-CONFIRMED.

## Deliberate UNKNOWNs

OpenPressBrake E-stop count/location, span of control, safety relay/PLC logic, final contactors, STO channels, hydraulic valve response, pump response, ram behavior, gravity/load-retention behavior, reset station, visibility, restart sequence, stopping time/distance, pressure, PL/SIL/DC and acceptance thresholds remain UNKNOWN until installed machine evidence exists.

## Next independent evidence branch

Trace **protective-device demand versus E-stop demand** in one complete professional machine/cell implementation: identify where guard/light-curtain response legitimately differs from E-stop, what final elements differ, and how reset/restart remains separated. Prefer an OEM/manufacturer schematic or application package exposing the complete chain. If the primary lane moves onto that topic first, rotate to safety-function status/diagnostic annunciation and prevention of `SAFE` state overclaim.