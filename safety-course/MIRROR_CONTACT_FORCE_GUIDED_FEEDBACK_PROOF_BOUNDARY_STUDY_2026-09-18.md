# Mirror Contact / Force-Guided Feedback Proof Boundary Study — 2026-09-18

## Purpose

Independent Lane-B study. The primary lane is currently advancing hydraulic safety-objective / monitored-valve / fall-protection evidence, so this artifact deliberately stays on the electrical final-element feedback boundary.

Question: **what does an auxiliary feedback contact actually prove about a contactor or relay, and what does it not prove?**

This matters because an ordinary LinuxCNC/HAL/FPGA status bit, coil command, generic auxiliary contact, certified mirror contact, force-guided relay contact, and actual hazardous-energy interruption are not interchangeable evidence.

## Provenance labels

- **SOURCE-CONFIRMED** — directly supported by cited manufacturer/standard-derived material.
- **DOC-CONFIRMED** — confirmed by project documentation, not physical test.
- **TEST-CONFIRMED** — established by controlled test on the actual implementation.
- **COMMUNITY-REPORTED** — practitioner/community report without equivalent authoritative proof.
- **INFERENCE** — engineering conclusion drawn from confirmed evidence; requires application validation.
- **UNKNOWN** — not established by available evidence.

## Authoritative evidence trace

### Schneider Electric — mirror contact is a specific contactor relationship

**SOURCE-CONFIRMED:** Schneider Electric's FAQ on machine-safety contactors explains that IEC 60947-4-1 mirror contacts concern an N/C auxiliary contact on a contactor: the N/C mirror contact will not close while one of the contactor's power contacts remains closed. Schneider identifies TeSys D and TeSys U examples with N/C mirror contacts and describes connection to a safety monitoring relay.

Source: Schneider Electric UK, `Does Schneider Electric offer 'safety contactors'?`, FAQ FA136111, last modified 2025-08-08: https://www.se.com/uk/en/faqs/FA136111/

**SOURCE-CONFIRMED:** Schneider explicitly warns that older terms such as mechanically linked/guided contacts can be misleading when casually applied to contactors. The mirror-contact requirement is about the power-contact state constraining the N/C auxiliary indication; it does not mean a tiny auxiliary contact physically forces a large welded power pole open.

### WEG — mirror contact and mechanically linked auxiliary contacts are related but distinct definitions

**SOURCE-CONFIRMED:** WEG's Safety Solutions material separates:

- mechanically linked contacts under IEC/EN 60947-5-1 Annex L, where linked N/O and N/C auxiliary contacts cannot simultaneously assume contradictory closed states after welding; and
- mirror contacts under IEC/EN 60947-4-1 Annex F, where the auxiliary contact is mechanically linked to the contactor power contacts and provides the defined inverse-state evidence.

Source: WEG, `Safety Solutions - Safety Line`, section `Mechanically Linked Contacts` / `Mirror Contact`: https://static.weg.net/medias/downloadcenter/h05/h0d/WEG-safety-solutions-50093493-brochure-en.pdf

## Frozen evidence ladder

The curriculum shall keep these states separate:

`SAFETY OUTPUT COMMAND OFF`

`!= CONTACTOR COIL PROVEN DE-ENERGIZED`

`!= ARMATURE / SWITCHING MECHANISM PROVEN RELEASED`

`!= ORDINARY AUXILIARY CONTACT INDICATES OFF`

`!= CERTIFIED MIRROR / FORCE-GUIDED FEEDBACK SATISFIED`

`!= EVERY HAZARDOUS POWER POLE / ENERGY PATH PHYSICALLY OPEN`

`!= STORED / GRAVITY / HYDRAULIC / PNEUMATIC ENERGY ABSENT`

`!= MACHINE SAFE FOR ENTRY OR MAINTENANCE`

A mirror contact is stronger evidence than a generic auxiliary indication because its specified mechanical relationship is part of the device contract. It is still **feedback evidence**, not an independent energy-isolation device and not proof of every hazardous-energy path.

## Why ordinary auxiliary indication is insufficient by default

**INFERENCE:** A generic PLC/HAL `K1_OFF` bit can mean only that software requested K1 off. A generic auxiliary contact can show the state of that auxiliary mechanism without an established safety-related mechanical relationship to the power poles. Therefore neither may be promoted to `MAIN POWER OPEN` unless the actual device documentation and application establish that relationship.

This prevents a dangerous curriculum shortcut:

`LinuxCNC output false -> PLC sees aux NC -> HMI says SAFE`

That chain may be useful diagnostics, but it is not automatically physical proof of hazardous-energy removal.

## Mirror-contact failure-path matrix

| Fault / condition | What a properly applied mirror-feedback path may reveal | What remains unproved |
|---|---|---|
| One main N/O pole welds closed | N/C mirror contact should be prevented from returning to its normal closed feedback state; EDM can inhibit reset/restart | Whether a redundant shutdown path actually interrupted all hazardous energy |
| Coil command is OFF but coil is backfed | Feedback may remain in the energized/not-reset state | Root cause, voltage at coil, and state of every energy path |
| Ordinary auxiliary contact falsely appears normal | A certified mirror-contact path avoids relying on an unspecified ordinary auxiliary relationship | Other common-cause wiring faults in the EDM loop |
| Mirror/EDM loop shorted or bypassed closed | Mirror contact itself cannot necessarily reveal the external bypass | Need independent wiring/fault analysis and validation |
| One pole opens, another pole welds | Mirror function is intended to prevent false normal feedback if a main power contact remains closed | Actual downstream energy at every load unless separately witnessed |
| Contactor opens correctly but another feed/backfeed remains | Mirror feedback can truthfully say this contactor released | Hazardous energy may still remain from another path |
| Mechanical contactor opens but rotating/gravity/stored energy persists | Mirror feedback can establish switching-device state | Motion/load/pressure/energy result remains separate |
| HMI says contactor OFF from command state only | Nothing physical is proven | Need safety feedback and/or physical witness appropriate to hazard |

## EDM interpretation rule

**INFERENCE:** External-device monitoring should be taught as a consistency check between demanded final-element state and qualified returned evidence. It is not a universal `SAFE` sensor.

A useful evidence chain is:

`safety demand -> safety output state -> contactor coil/mechanism -> qualified mirror feedback -> EDM decision -> restart inhibition/release`

The physical hazard chain continues separately:

`main power contacts -> downstream electrical energy -> drive/motor/actuator state -> residual mechanical/hydraulic/gravity energy`

Both chains must be reconciled when the safety objective depends on physical energy removal.

## Relay terminology boundary

**SOURCE-CONFIRMED:** WEG distinguishes mechanically linked auxiliary contacts from contactor mirror contacts. Schneider likewise warns against treating older `guided/linked` terminology as though it means the same thing in every device class.

**Curriculum rule:** do not write `force-guided`, `positively guided`, `mechanically linked`, or `mirror` as interchangeable marketing synonyms. Record the exact device claim and the standard/function the manufacturer assigns to that contact set.

## OpenPressBrake application boundary

The following remain **UNKNOWN** until actual hardware is selected and documented:

- which electrical final elements, if any, use contactors;
- exact contactor/relay part numbers;
- whether their feedback contacts are certified mirror/mechanically linked contacts;
- which poles interrupt which hazardous energy paths;
- whether redundant contactors are required by the machine risk assessment;
- EDM wiring topology, discrepancy timing, diagnostics and recovery behavior;
- short/backfeed/common-cause behavior of the field wiring;
- whether drive STO is used instead of or in addition to power contactors;
- achieved PL/SIL/category/DC;
- actual stopping time/distance;
- hydraulic, gravity, pneumatic or stored-energy state after electrical interruption.

Do not infer any of those from this study.

## Practical validation questions

For each safety-related external relay/contactor on a real machine, validation should answer with evidence:

1. What hazardous-energy path does each main pole interrupt?
2. What exact auxiliary contact is returned to the safety logic?
3. Does the manufacturer identify that contact as mirror / mechanically linked / force-guided under the applicable device specification, or is it merely ordinary indication?
4. What happens to returned feedback if a main pole is physically prevented from opening?
5. Can a short or backfeed make the feedback loop appear reset while hazardous power remains?
6. Does the safety controller inhibit reset/restart on feedback disagreement?
7. Is the feedback loop itself covered for relevant wiring faults?
8. What separate witness establishes the physical hazard result when contactor state alone is insufficient?
9. After repair, what deliberate reset/rearm/new-start sequence is required?
10. Is ordinary LinuxCNC/HAL/FPGA state diagnostic-only, with personnel-safety authority remaining independent?

## No-compute decision

No simulation or executable verification is justified for this source-definition study. No GitHub-hosted runner or self-hosted runner was used.

## Precise next independent work

Find a complete manufacturer/OEM application exposing:

`dual safety outputs -> two contactors -> certified mirror contacts -> EDM -> welded-pole fault -> restart inhibition -> downstream hazardous-energy interruption`

Prefer an application that also identifies what remains energized after the contactors open. Build a physical proof matrix rather than assuming `EDM OK = machine safe`.

If the primary lane reaches that exact package first, rotate to a different electrical final-element branch: **mirror/EDM loop short-to-24-V and bypass/common-cause fault injection worksheet**, preserving manufacturer-specific timing and diagnostic claims rather than inventing them.
