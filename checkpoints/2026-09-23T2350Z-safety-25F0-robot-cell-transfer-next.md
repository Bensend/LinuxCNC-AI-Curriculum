# Safety curriculum checkpoint — 25F0 robot/cell transfer next

UTC checkpoint: 2026-09-23T23:50Z

## Durable state

- Mill/VMC baseline remains durable.
- Lathe/turning-center delta is now durable in `research/25F0_LATHE_TURNING_CENTER_DELTA_2026-09-23.md`.
- The lathe delta explicitly separates transferred, modified and new SRS requirements.
- Authoritative anchors include OSHA lathe-chuck guarding guidance and current Haas lathe documentation for workholding/ejection, projecting bar stock, chuck pressure behavior, turret/tailstock mechanisms and power-loss/reference caveats.
- New freezes include `DOOR INTERLOCK HEALTHY != WORKPIECE RETENTION PROVED`, `ENCLOSURE CLOSED != CONTAINMENT CAPABILITY PROVED`, `FLUID POWER REMOVED != WORKPIECE RETAINED`, `CHUCK CLAMP COMMAND != WORKPIECE RETENTION PROVED`, `PRESSURE SETPOINT != GRIPPING FORCE PROVED`, `SPINDLE ENCLOSURE CLOSED != REAR BAR-STOCK HAZARD CONTROLLED`, and `TORQUE/MOTION REMOVED != WORKPIECE SUPPORT PRESERVED`.
- No executable compute was justified; no GitHub-hosted compute was used.

## Exact next work

1. Transfer the 25F0 capstone contract to robot/automated cells rather than duplicating mill/lathe generic material.
2. Trace whole-body access/occupancy, perimeter guarding, gate locking where required, reset visibility, enabling-device/setup behavior, restart after safeguard restoration, multiple robot/peripheral energy sources and cell-level authority using authoritative sources.
3. Distinguish robot controller safe-motion/safety functions from ordinary robot/LinuxCNC/PLC status and from physical energy-removal/isolation.
4. Treat conveyors, positioners, tooling, pneumatic/hydraulic grippers, weld/process equipment and upstream/downstream machines as independent hazardous-energy paths where applicable.
5. Explicitly identify transferred, modified and new SRS clauses.
6. Keep stop times/distances, separation distances, PL/SIL targets, safe-speed values, proof-test intervals and machine-specific physical thresholds UNKNOWN until justified.
7. After robot/cell transfer, begin the press-brake capstone with distinct gravity/fluid-power/point-of-operation hazards.
8. Compute remains question-driven and self-hosted-only `[self-hosted, openpressbrake]`.