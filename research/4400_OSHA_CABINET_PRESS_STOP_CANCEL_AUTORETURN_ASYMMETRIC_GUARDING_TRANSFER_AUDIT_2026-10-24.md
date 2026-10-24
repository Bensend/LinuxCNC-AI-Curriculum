# 4400 — Stop/cancel may cause a different hazardous movement: OSHA cabinet-press transfer case

**2026-10-24 | Original official agency bulletin located; manufacturer-independent real accident case | NOT a press-brake incident | No physical test**

## Primary source and provenance

OSHA, **Safety and Health Information Bulletin SHIB 03-07-16**, *Cabinet Press Pinch Point Hazard*, July 16, 2003. Official source: https://www.osha.gov/publications/shib071603 ; official PDF: https://www.osha.gov/sites/default/files/publications/SHIB071603.pdf ; OSHA index: https://www.osha.gov/shib/ . Search-indexed official OSHA page and PDF contain the complete narrative, but direct web-reader access to both returned **403** in this session. **Classification: DOC-CONFIRMED via official indexed content; original PDF not directly opened.** The bulletin explicitly says it is advisory and creates no new legal obligations. Do not represent it as a regulation or generalize laundry-machine ANSI Z8.1 criteria to press brakes.

## Actual case (official OSHA account, exact machine class)

A semiautomatic **shirt cabinet press** transferred a garment mannequin/buck from a loading/dressing table into a heated press and automatically returned it. A protective bar and CANCEL operation were intended to stop the pressing cycle, but the return movement toward the loading table was not arrested by the same protective arrangement. The returning buck and frame created a second pinch hazard at the loading-table opening. OSHA documents a fatal incident involving this return path.

The important **engineering failure** is *direction/phase asymmetry*: safeguarding of **inbound transfer and closing** did not cover **outbound return**. A command described as CANCEL or STOP of the process could initiate or allow another motion. OSHA describes a later machine model that stops before return and requires a separate operator-held command for the return. This is an observed industrial design alternative, **not** a universal prescription for all CNC machines.

## Explicit boundaries

| Proposition | Classification | Correct conclusion |
|---|---|---|
| Cabinet press returned automatically and lacked equivalent return-path safeguarding | DOC-CONFIRMED official OSHA indexed narrative | A real machine can be protected in one direction but hazardous in another. |
| CANCEL could lead to return motion on that machine | DOC-CONFIRMED official OSHA indexed narrative | Normal-control semantics do not imply a machine-wide physical safe state. |
| Later cabinet press required deliberate held controls for return | DOC-CONFIRMED official OSHA indexed narrative | Requiring new operator authority can be a practical risk-reduction design. |
| OpenPressBrake backgauge automatically returns on stop | **UNKNOWN** | **Do not claim it.** Inspect selected control and safety wiring. |
| A press-brake backgauge can have delayed programmed motion | DOC-CONFIRMED TRUMPF B35 2023 OEM (separate audit) | Review step-change and access hazard independently of ram motion. |
| A safe return can be guaranteed by ordinary LinuxCNC G-code alone | **NOT ESTABLISHED** | Requires selected hazard analysis, independent safety-related control where needed and physical validation. |

## Machine-neutral state-space challenge

For **each moving mechanism** (ram Y1/Y2, backgauge X/R/Z/L, toolchanger, conveyor, robot, loader), separately inspect:

1. **Movement directions and phases:** approach, process, withdraw, return, home, fault recovery and power-return re-reference.
2. **Trigger:** operator hold-to-run, cycle transition, automatic timer, queued next step, CANCEL, RESET, E-stop, watchdog, remote command.
3. **Person/exposure:** which side/volume becomes accessible during that phase, including helpers and maintenance personnel.
4. **Safety demand:** whether the independent safety function covers that axis **in that direction**, with correct guard state and mode.
5. **Physical consequence:** verified stop/hold/energy removal versus a merely stopped task timer or canceled program.
6. **Rearm:** no unexpected motion when protective device recovers or old commands are retained.

**Adversarial example (INFERENCE):** a cell's front light curtain stops inward conveyor travel, while a CANCEL action sends the conveyor outward through an unguarded opening. Do not claim the cell exists; this is a paper diagnostic to test whether both directions were assessed. The real OSHA case is the evidence that this category is plausible.

## Practical design rule and human factors

Make the safe recovery route obvious and short: tell the operator *which axis will move next*, require a deliberate fresh command for movement into any newly exposed space, preserve independent protective coverage for both directions, and avoid a recovery procedure that encourages guard defeat. A red light or buzzer can help but does not replace a safety function. Do not use an operator's body to prove stopping.

## Transfer to LinuxCNC/OpenPressBrake

This is a **cross-machine failure mechanism**, not proof of an OpenPressBrake defect. Map ordinary LinuxCNC/FPGA command and queued recovery behavior separately from independent safety controller/final-element authority, then physically validate gauge stop and Y1/Y2 gravity hold. Any selected machine lacking basic safe-to-operate protection must **not** operate with people exposed; isolated/remote experiments only with exclusion and documented residual risk.

**SOURCE-CONFIRMED LinuxCNC:** none new. **DOC-CONFIRMED:** official indexed OSHA 2003 case (reader access limitation); separate original TRUMPF source audit. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none. **INFERENCE:** cross-machine diagnostic state-space. **UNKNOWN:** selected return behavior, safety integrity, stop distance/time and machine validation. G0/G1 HOLD; G3/G4 NOT AUTHORIZED; external evaluator OPEN; no compute.
