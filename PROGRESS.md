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

**25F0 — Machine safety capstones** is the active branch. `research/25F0_MACHINE_SAFETY_CAPSTONE_CONTRACT_2026-09-23.md` defines the cross-machine package. The mill/VMC baseline remains the transferable foundation, and `research/25F0_LATHE_TURNING_CENTER_DELTA_2026-09-23.md` now demonstrates the first explicit machine-class delta. The lathe work separates requirements that transfer unchanged from requirements modified by workholding/containment and newly required chuck, bar-stock, turret and tailstock/subspindle safety propositions. Press-brake depth still follows cross-machine transfer; do not invent hydraulic truth tables, stopping distances, pressure thresholds or integrity targets.

Core freezes remain in force, especially: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **FAULT DETECTED != PHYSICAL SAFE STATE ACHIEVED**, **LOW COST != LOW RIGOR**, **MORE COMPONENTS != MORE SAFETY**, **EDM HEALTHY != PHYSICAL SAFE STATE PROVED**, **SAFETY RELAY OUTPUT OFF != FINAL ENERGY PATH OPEN PROVED**, **DUAL CHANNEL INPUT != REDUNDANT FINAL ELEMENT**, **STO ACTIVE != MOTOR STANDSTILL PROVED**, **STO ACTIVE != ELECTRICAL ISOLATION**, **SUPPLY ISOLATED != DOWNSTREAM PRESSURE EXHAUSTED**, **DUMP COMMANDED != PRESSURE SAFE PROVED**, **GUARD CLOSED != DANGEROUS STATE ENDED**, **COMPONENT PL/SIL CLAIM != MACHINE SAFETY FUNCTION PL/SIL CLAIM**, **UNCHANGED SAFETY PROGRAM != UNCHANGED VALIDATED SAFETY FUNCTION**, **STOPPING TIME ON COMMISSIONING DAY != STOPPING TIME PROVED FOR ALL FUTURE MACHINE STATES**, **STATUS BIT TIMING != PHYSICAL CESSATION TIMING**, **RETURN TO NORMAL SOFTWARE STATE != PRODUCTION SAFEGUARDS PHYSICALLY RESTORED**, **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**, **SPINDLE COMMAND OFF != PHYSICAL STANDSTILL PROVED**, **PRODUCTION INTERLOCK != MAINTENANCE ENERGY ISOLATION**, **DOOR INTERLOCK HEALTHY != WORKPIECE RETENTION PROVED**, **ENCLOSURE CLOSED != CONTAINMENT CAPABILITY PROVED**, **FLUID POWER REMOVED != WORKPIECE RETAINED**, **CHUCK CLAMP COMMAND != WORKPIECE RETENTION PROVED**, **PRESSURE SETPOINT != GRIPPING FORCE PROVED**, **SPINDLE ENCLOSURE CLOSED != REAR BAR-STOCK HAZARD CONTROLLED**, and **TORQUE/MOTION REMOVED != WORKPIECE SUPPORT PRESERVED**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Preserve the 2520–25E0 information-separated competency gates; do not contaminate them.
2. Transfer the proven 25F0 template to robot/automated cells rather than rewriting generic mill/lathe material.
3. Trace whole-body access/occupancy, perimeter guarding, reset visibility, enabling-device/setup behavior, restart, multiple robot/peripheral energy sources and cell-level authority using authoritative evidence.
4. Explicitly identify which existing SRS requirements transfer unchanged, which require modification, and which new robot/cell requirements appear.
5. Preserve ordinary LinuxCNC/PLC/robot-controller diagnostics versus independent safety-related control versus physical final-element authority boundaries.
6. Keep stopping limits/distances, safe-speed values, proof-test intervals, quantitative integrity claims and machine-specific physical values UNKNOWN until justified evidence exists.
7. After robot/cell transfer, begin the press-brake capstone with distinct gravity/fluid-power/point-of-operation hazards.
8. Freeze executable compute only if a concrete unresolved implementation question survives authoritative evidence; use `[self-hosted, openpressbrake]` only.

Newest precise checkpoint: `checkpoints/2026-09-23T2350Z-safety-25F0-robot-cell-transfer-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.