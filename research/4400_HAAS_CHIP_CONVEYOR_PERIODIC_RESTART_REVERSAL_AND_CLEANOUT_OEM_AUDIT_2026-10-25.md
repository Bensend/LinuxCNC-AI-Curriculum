# 4400-CHIP-01 — CNC chip-conveyor periodic restart, automatic reversal and maintenance source audit
**2026-10-25 | Original OEM + OSHA/HSE | NON-GRADUATED | NO TEST**

## Question
Does a stationary chip conveyor at the moment a technician reaches into a chip chute establish that it cannot restart or reverse? **No.** The documented controls explicitly support interval-based restart and jam reversal on specified models. Do not mistake ordinary CNC/pendant commands or a closed main machining enclosure for the complete conveyor safeguarding system.

## Original source set and exact boundaries
1. Haas, *Chip Conveyor* official product/technical page, accessed 2026-10-25: https://haascnc.com/reference-container/Technical-Details/Options/Chip-and-Coolant_Management/conveyor.html . Documents M31/M33 for the Haas conveyor option, Settings 114 (cycle interval), 115 (run duration), 196 (idle shutdown), automatic jam reversal, pendant FWD/REV/STOP and operator-door-closed condition.
2. Haas, *Chip Lift Conveyor* technical page, accessed 2026-10-25: https://haascnc.com/reference-container/Technical-Details/Options/Chip-and-Coolant_Management/haas-chip-lift.html . Documents that lift conveyor and auger share pendant controls and manual reverse on specified equipment. **Exact option family only.**
3. Haas, *Belt-Type Chip Conveyor UMC*, accessed 2026-10-25: https://www.haascnc.com/productivity/chip-and-coolant-management/conveyor-h.html . Advertises smart sensing with automatic reversal on torque overload. This is product documentation, not a measured stopping/reversal limit.
4. OSHA, *Control of hazardous energy (lockout/tagout)*, 29 CFR 1910.147(c)(1): https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147 . Applicable scope and exceptions must be determined for the selected workplace; ordinary STOP does not substitute for energy isolation during hazardous service.
5. OSHA, *LOTO eTool — Hazardous Energy from Interconnected or Nearby Machines or Equipment*: https://www.osha.gov/etools/lockout-tagout/hot-topics/multiple-energy-sources/hazardous-energy . Describes a stopped but separately energized conveyor that exposes a worker servicing adjacent equipment.
6. HSE, *Guarding* (quarry guidance), accessed 2026-10-25: https://www.hse.gov.uk/quarries/hardtarget/guarding.htm . Documents a real unexpected conveyor-start incident after workers relied on an isolated panel while a bypassed feed existed; illustrates why the **actual** isolation path must be verified. Quarry application is not a CNC design standard.
7. OSHA, *1926.555 Conveyors*: https://www.osha.gov/laws-regs/regulations/standardnumber/1926/1926.555 . Construction-specific requirements include guarding screw conveyor flights, warning before start, and repair lockout. **Not automatically the governing rule for a manufacturing shop**; useful documented hazard taxonomy only.
8. HSE, *Shearing hazards*, accessed 2026-10-25: https://www.hse.gov.uk/agriculture/topics/machinery/shearing.htm . Agriculture context; practical captive fastener/guard/interlock/blocked-machine design principles, not a CNC-specific acceptance criterion.

## Claim ledger
| Claim | Class | Exact limit |
|---|---|---|
| Haas M31 enables periodic conveyor operation while machining cycle continues; Setting 114 governs restart interval, 115 on-time, 196 idle shutoff. | DOC-CONFIRMED Haas conveyor page | Exact Haas option/configuration. It does **not** prove a given LinuxCNC M31 mapping or that a conveyor is safe between cycles. |
| M33 and CHIP STOP stop *ordinary automatic conveyor operation* while in cycle. | DOC-CONFIRMED Haas conveyor page | No OEM assertion here that M33 is a safety-rated isolation or maintenance lock. |
| Haas lists automatic reversal for jams and manual REV control; specific Chip Lift reverse remains active only while button held. | DOC-CONFIRMED Haas conveyor + Chip Lift | Automatic vs manual reversal depend on model/options; do not merge behavior into a universal truth table. |
| Certain Haas conveyor pages say operator doors must be closed to operate. | DOC-CONFIRMED OEM | Does not establish that an external discharge opening/chute or rear cleaning position is inaccessible or separately interlocked. |
| OSHA LOTO eTool warns that isolating one motor while a nearby connected conveyor remains energized is inadequate. | DOC-CONFIRMED OSHA example | Illustrative scope; actual isolation sources must be identified on the selected machine. |
| HSE quarry incident found a bypassed feed to a conveyor despite a locked panel. | DOC-CONFIRMED HSE case | No assumption that a CNC chip conveyor has this wiring defect. |
| A safety-rated guard/isolator and fresh-start design should address chute, auger, reverse and scheduled start. | INFERENCE from hazards and OEM behavior | Requires machine-specific SRS, hazard geometry, actual final elements and physical validation. |

**SOURCE-CONFIRMED:** no new LinuxCNC source trace. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none. **UNKNOWN:** selected conveyor model, chip-bin/chute geometry, external access, wiring, torque reversal threshold, actual stop time, PL/SIL, guards, final-element state, restart behavior, and actual physical proof.

## Mechanism and failure paths
- **Ordinary timing:** M31/pendant initiates a mode in which the conveyor can stop for an interval and restart without a new technician-visible command. A stopped belt is not a zero-energy witness.
- **Reverse on jam:** a jam is a plausible trigger for *more* movement; a person who reaches in because the belt stopped can be exposed to a reverse motion. Manual REV can also move the mechanism from a different operator position.
- **Guard coverage gap:** closed machining doors may protect the cutter and internal chip trough while the external conveyor discharge and nip remain accessible. A guard-status bit is not a geometry study.
- **Interconnected machine:** the main CNC power/drive state and a conveyor auxiliary supply may have different isolators. Isolation must cover every hazardous source and downstream motion.
- **Defeat pressure:** nuisance clogging, difficult chip-bin removal, poor sightlines, and slow guard replacement encourage defeating an interlock. Fix the cleanout architecture with guarded accessible service and captive hardware.

## Practical low-friction design inference
Use a fixed enclosed screw trough and nip guards where normal chip flow allows; use a hinged/captive interlocked cleanout cover where frequent service is genuinely required; label a reachable lockable isolator and provide a safe chip-bin swap route that does not expose moving parts. A dedicated service state must require independent isolation for hand entry, not a CNC M-code. Do not encourage 'jog reverse to free jam while reaching in'.

## Why no lab
The source answers whether an ordinary CNC-driven conveyor may restart or reverse without a fresh human start: **yes, for the documented Haas options**. A LinuxCNC software simulation cannot prove guarding, stored mechanical energy, lockout wiring, real nip geometry, or selected stopping behavior. Freeze any future test only after a concrete unresolved source question and self-hosted runner access; no hosted compute.

## Cross-machine transfer
Lathe/VMC chip conveyor, saw scrap conveyor, press-brake part-handling conveyor and robot-cell scrap removal all have distinct auxiliary-motion ownership. No chip conveyor is asserted installed on OpenPressBrake. Closed 3000 track evidence is preserved; this is a 4400 safety-function transfer.

## 2026-10-27 exact OEM firmware/control-family correction (CHIP-03)
The original Haas [Chip Auger Service Manual](https://haascnc.com/service/online-manuals/chip-and-coolant---service-manual/chip-auger) and [Conveyor TG0053](https://haascnc.com/service/troubleshooting-and-how-to/troubleshooting/conveyor-system---troubleshooting-guide.alarm%3Dngc_000-0000) document a **version-specific unexpected start with doors open** for software **100.17.000.1016** and recommend **100.17.000.2030+**. They separately document an older **M31 re-triggered off-interval timer** defect. Classic Haas Control manual door-open restart differs from the OEM's NGC-after-2018-10-10 door rule. Do **not** read the OEM's context-specific “never restarts automatically” correction as abolition of intentional Settings 114/115 timed cycling. This exact control-family/version/door rule was **not** established by the original CHIP-01 product page. See [CHIP-03 original source and physical-witness audit](4400_CHIP_03_HAAS_CONVEYOR_DOOR_OPEN_AUTO_START_SOFTWARE_REVISION_OEM_SOURCE_DELTA_2026-10-27.md). **DOC-CONFIRMED manufacturer text**, not installed-machine TEST-CONFIRMED; no new machine proof, no compute, G0/G1 HOLD.
