# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative. Detailed history remains in Git and referenced research/results/evaluation artifacts.

## Closed prerequisite levels

- **1000 series:** GRADUATED / CLOSED.
- **2000 series:** GRADUATED / CLOSED as of 2026-09-14. F02 GRADUATED.
- **3000 series:** GRADUATED / CLOSED as of 2026-09-15.

Do not routinely reopen closed levels without a genuinely new material defect.

## Active curriculum level

**4000 — hardware and AI-assisted implementation.**

### Primary active priority — safety course / professional machine implementation

Routine controller-board development remains a separate automation concern and must not displace safety work here.

The repeatable safety-design methodology covers:

`machine/lifecycle boundary -> hazardous event -> risk-reduction hierarchy -> physical safe-state proposition -> safety-function/SRS derivation -> composition/allocation -> fault analysis/diagnostic design -> architecture/dependency/CCF allocation -> integrity-method selection/target allocation -> verification/validation/physical proof -> commissioning/release -> maintenance/change control/revalidation`

2520 through 25E0 external information-separated competency execution remain OPEN and branch-local; do not self-score or contaminate them.

**2540–25E0** retain their existing READY FOR EXTERNAL/FRESH EVALUATION state and information-separated handoffs. Do not contaminate those gates.

**25F0 — Machine safety capstones** is the active branch. `research/25F0_MACHINE_SAFETY_CAPSTONE_CONTRACT_2026-09-23.md` defines the cross-machine package. The mill/VMC baseline and lathe/turning-center delta remain durable. `research/25F0_ROBOT_AUTOMATED_CELL_DELTA_2026-09-24.md` now completes the first robot/cell transfer: whole-body access/occupancy, perimeter guarding, reset visibility, manual/teach enabling, restart, peripheral energy paths and cell-level authority are separated explicitly, with transferred/modified/new SRS clauses. `research/25F0_PRESS_BRAKE_CAPSTONE_BOUNDARY_2026-09-24.md` opens the press-brake capstone with point-of-operation, workpiece, gravity, fluid-power, rear/side access, tool-change and maintenance hazards. Do not invent hydraulic truth tables, stopping distances, pressure thresholds or integrity targets.

Core freezes remain in force, especially: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **FAULT DETECTED != PHYSICAL SAFE STATE ACHIEVED**, **LOW COST != LOW RIGOR**, **MORE COMPONENTS != MORE SAFETY**, **EDM HEALTHY != PHYSICAL SAFE STATE PROVED**, **SAFETY RELAY OUTPUT OFF != FINAL ENERGY PATH OPEN PROVED**, **DUAL CHANNEL INPUT != REDUNDANT FINAL ELEMENT**, **STO ACTIVE != MOTOR STANDSTILL PROVED**, **STO ACTIVE != ELECTRICAL ISOLATION**, **SUPPLY ISOLATED != DOWNSTREAM PRESSURE EXHAUSTED**, **DUMP COMMANDED != PRESSURE SAFE PROVED**, **GUARD CLOSED != DANGEROUS STATE ENDED**, **COMPONENT PL/SIL CLAIM != MACHINE SAFETY FUNCTION PL/SIL CLAIM**, **UNCHANGED SAFETY PROGRAM != UNCHANGED VALIDATED SAFETY FUNCTION**, **STOPPING TIME ON COMMISSIONING DAY != STOPPING TIME PROVED FOR ALL FUTURE MACHINE STATES**, **STATUS BIT TIMING != PHYSICAL CESSATION TIMING**, **RETURN TO NORMAL SOFTWARE STATE != PRODUCTION SAFEGUARDS PHYSICALLY RESTORED**, **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**, **SPINDLE COMMAND OFF != PHYSICAL STANDSTILL PROVED**, **PRODUCTION INTERLOCK != MAINTENANCE ENERGY ISOLATION**, **DOOR INTERLOCK HEALTHY != WORKPIECE RETENTION PROVED**, **ENCLOSURE CLOSED != CONTAINMENT CAPABILITY PROVED**, **FLUID POWER REMOVED != WORKPIECE RETAINED**, **CHUCK CLAMP COMMAND != WORKPIECE RETENTION PROVED**, **PRESSURE SETPOINT != GRIPPING FORCE PROVED**, **SPINDLE ENCLOSURE CLOSED != REAR BAR-STOCK HAZARD CONTROLLED**, **TORQUE/MOTION REMOVED != WORKPIECE SUPPORT PRESERVED**, **PERIMETER GATE CLOSED != SAFEGUARDED SPACE KNOWN EMPTY**, **SAFETY RESET COMPLETE != CELL OCCUPANCY CLEARED**, **ROBOT STOPPED != CELL SAFE STATE PROVED**, **ROBOT CONTROLLER SAFE STATE != PERIPHERAL MACHINE SAFE STATE**, **SOFTWARE JOG LIMIT != SAFE MANUAL OPERATION PROVED**, **PUMP OFF != RAM/BEAM SAFE STATE PROVED**, **VALVE COMMAND OFF != HAZARDOUS DESCENT PREVENTED PROVED**, **LIGHT CURTAIN INTERRUPTED != RAM PHYSICALLY STOPPED PROVED**, and **NORMAL PRODUCTION SAFEGUARD != TOOL-CHANGE/MAINTENANCE RESTRAINT**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Preserve the 2520–25E0 information-separated competency gates; do not contaminate them.
2. Continue the press-brake capstone from `research/25F0_PRESS_BRAKE_CAPSTONE_BOUNDARY_2026-09-24.md`.
3. Trace at least two inspectable professional hydraulic press-brake safety implementations end-to-end: protective device/E-stop -> independent safety logic -> physical valves/contactors/holding or restraint elements -> feedback/diagnostics -> physical safe-state proposition.
4. Compare architectures before generalizing. Explicitly distinguish supply isolation, dump/decompression, load holding/gravity restraint, controlled stopping and maintenance restraint.
5. Preserve the boundary between ordinary LinuxCNC/FPGA/proportional-valve control and independent safety-related control/final elements.
6. Keep hydraulic truth tables, valve fail states, stopping limits/distances, pressure thresholds, safe-speed values, proof-test intervals and PL/SIL/integrity targets UNKNOWN until justified by machine/product evidence.
7. Build a press-brake fault matrix only after the physical architecture is source-grounded; include stuck valve, false feedback, broken channel, common supply, power restoration and gravity/stored-energy paths.
8. Freeze executable compute only if a concrete unresolved implementation question survives authoritative evidence; use `[self-hosted, openpressbrake]` only.

Newest precise checkpoint: `checkpoints/2026-09-24T0055Z-safety-25F0-press-brake-architecture-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.