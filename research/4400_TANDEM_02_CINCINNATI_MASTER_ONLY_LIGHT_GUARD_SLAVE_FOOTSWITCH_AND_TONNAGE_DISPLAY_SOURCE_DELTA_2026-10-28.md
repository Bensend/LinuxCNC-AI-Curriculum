# 4400-TANDEM-02 — A slave light guard can be inactive in tandem mode; programmed tonnage can be a proxy
**2026-10-28 | Original manufacturer source-depth addendum to TANDEM-01 | NON-GRADUATED**

## Predecessor and precise new evidence

[TANDEM-01](4400_TANDEM_01_TRUMPF_ACCURPRESS_MODE_DEPENDENT_GUARD_AND_DUAL_RAM_STOP_AUDIT_2026-10-26.md) already established that a real tandem press-brake installation has mode-dependent physical guards and shared workpiece hazards, using TRUMPF and Accurpress product material. This is **not** a second generic tandem module. The new source provides an unusually explicit **control ownership trap** in an actual manufacturer operating manual: in its tandem mode, a **light guard connected to the slave is inactive**; the master must own the whole-length guard. It also documents that **slave pedal/palm commands become inactive** and that a **programmed/diagnostic tonnage display can differ from actual tonnage** on short bends. These are exact product/version claims, not universal architecture.

## Original directly inspected manufacturer manual

**Cincinnati Incorporated**, [EM-519 (N-08-19), _400–2000 PROFORM Hydraulic Press Brake Operation, Safety, and Maintenance Manual_](https://wwwassets.e-ci.com/PDF/Manuals/em-519_n-08-19_proform__400-2000_hydraulic_press_brake_osmm.pdf), ©2019, for machines built after 2018-01-01. Inspected original searchable PDF and printed pp. **8-6 through 8-10**, including the rendered p. **8-9** safety/tonnage chart (PDF zero-based p. 74). **DOC-CONFIRMED for this OEM family only**.

- **Light-guard authority (p. 8-9):** If a light guard safeguards tandem operation, the manual requires it to be connected to the **master**, covering the entire two-machine workspace. It explicitly says a guard connected to the **slave will not be active during tandem operation**. A physically present/illuminated slave guard is therefore not proof of protection in this OEM mode.
- **Station command ownership (p. 8-7):** The master has the SINGLE/DUAL selector. In tandem, the slave's palm-button and footswitch stations are **inactive**, while its **E-stop, RAM UP, OPERATOR switch and MAIN DRIVE START/STOP** remain among active controls. **Do not misquote this as 'slave E-stop disabled'.** The manual's list of active controls is not a tested safety circuit.
- **Short shared-workpiece loading (pp. 8-6, 8-8):** A shorter bend can place both presses in off-center loading; too-short bends with no outer-cylinder loading can cause rams to go out of level, and the manual directs these to be performed on one machine independently. Actual tandem capacity varies with **bend length, location, machine length and extensions**, using a supplied machine-specific chart.
- **Diagnostic tonnage semantics (p. 8-9):** In the cited OEM control, programmed and DIAGNOSTIC displayed tonnage only indicate actual tonnage for a bend spanning the full combined length. For shorter bends, actual tonnage is less than programmed/displayed; the manual specifies a **machine-specific** adjustment chart. Its example force multiplier is **not** a transferable safety algorithm.
- **Communications check (p. 8-10):** The manual describes master/slave serial message checksum and parameter-count checking for a communications error. That does **not** establish a safety-rated fieldbus, a fail-safe stop reaction, or independent physical Y1/Y2 holding.

## Exact failure path and required evidence

| Observed condition | False conclusion | Required discriminator | Evidence |
|---|---|---|---|
| Slave light guard visually present, shows a normal status | Entire tandem zone is protected | Mode-specific master/slave input mapping, whole-span coverage, safety-related authority, physical stop/hold from both machines | OEM **DOC-CONFIRMED** inactive-slave guard example; selected installation **UNKNOWN** |
| Slave foot pedal does not command a tandem stroke | All slave protective devices are disabled, or master alone is enough | Distinguish **normal cycle command** from slave **E-stop** and guard, independently verify relevant stop-demand propagation | OEM **DOC-CONFIRMED** control ownership, safety response **UNKNOWN** |
| Both rams move together, tonnage diagnostic looks acceptable | Actual loading and structural integrity are proven | Job location/length, machine-specific capacity chart, both rams/bed/tool load, independent stop/hold and guard | OEM **DOC-CONFIRMED** tonnage proxy; selected force **UNKNOWN** |
| Master/slave serial checksum valid | Safety functions remain available under lost communication | Selected safety architecture, actual final elements and fault-stop/rearm witness; do not use ordinary CRC as safety proof | **INFERENCE** from OEM ordinary comm description |
| Switch changes from SINGLE to DUAL | Guarding and ownership automatically safe | Verified mode-specific protective geometry, actual authorized safety program, deliberate fresh start and independent physical witness | **UNKNOWN** selected machine |

## Safety architecture and practical human factors

- **Normal CNC/FPGA:** handles tandem commands, master/slave synchronization, tonnage display and ordinary diagnostics. A software mode indicator or serial checksum is not a safety function.
- **Independent safety:** selected safety-related control must establish actual mode-dependent guard mapping and safe physical stop/hold for both machines. **No generic circuit truth table** is invented from the Cincinnati manual.
- **Physical:** a bridging workpiece creates shared pinch/whip/fracture zones; a shorter load can change mechanical limits even while rams track. Integrate [STRUCT-01](4400_STRUCT_01_CINCINNATI_PRESS_BRAKE_ECCENTRIC_OFFCENTER_STRIPPING_LOAD_SOURCE_AUDIT_2026-10-28.md) and existing TOOL-LOAD-03 for structural and tool limits.
- **Easy safe operation:** label which station commands motion and which protective devices cover **both** machines in each mode. Make safe changeover, guard alignment and mode proof easier than temporary bypass. Never assume an illuminated slave sensor is an active protective input.

## Evidence boundary and next work

**DOC-CONFIRMED:** exact Cincinnati 2019 mode-dependent master/slave command/guard behavior and diagnostic tonnage caveat, original manual directly inspected. **INFERENCE:** potential false confidence from visible but inactive slave sensor, common-cause or link failure. **UNKNOWN:** any OpenPressBrake tandem hardware, active safety program, actual E-stop/guard wiring, load distribution, stopping/holding and reset. **TEST-CONFIRMED:** none. Existing TANDEM-01 conditional evidence route applies **only if qualified Stage A shows a tandem machine**; otherwise this is cross-machine teaching, not an owner request. No new exam bank, physical test, simulation, workflow, hosted/local compute or independent score. **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.**
