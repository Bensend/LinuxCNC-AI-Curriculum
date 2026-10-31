# 2026-10-31T14:46:01.131Z — LinuxCNC-first EtherCAT/CiA402 configuration continuation

**4000 ACTIVE, NON-GRADUATED.** 1000/2000/F02/3000 CLOSED. Independent safety and blind-evaluator gates, OpenPressBrake physical G0/G1 HOLD, and hourly curriculum unchanged.

## Durable findings

[ETHERCAT-51](../research/4400_LINUXCNC_ETHERCAT_51_CNC3_VS_2026_CSP_CONFIG_HOMING_DC_SOURCE_AUDIT_2026-10-31.md) compares public CNC3 2024 machine-shaped HAL/INI/XML with a 2026 generated XYZ CSP template: same read→motion→write order; R2M clock settings `5` versus `1`; template omits HOME_SEQUENCE for all three absolute-encoder joints, requires separately installed `cia402_homecomp`, and uses FERROR=1000. [ETHERCAT-52](../research/4400_LINUXCNC_ETHERCAT_52_CIA402_FAULT_HOMED_FEEDBACK_SOURCE_AUDIT_2026-10-31.md) traces maintained `cia402.c` fault masking for nominal 100 ms after auto-reset on enable edge, `stat-homed` retained outside homing mode, fresh completion edge requirement, actual 0x6064 feedback and improved signed-rollover handling versus original 2021 `.comp`. [Nine-case disconnected acceptance guide](../guides/4000-linuxcnc-ethercat-cia402-config-bringup-acceptance-2026-10-31.md) freezes oracles. All are SOURCE/DOC-CONFIRMED conditional mechanisms or INFERENCE; TEST-CONFIRMED none.

## Next highest-value unblocked work

If a **verified disconnected** `[self-hosted, openpressbrake]` runner is available, run one bounded CiA402 fault/homed-latch fixture (EC52-1/2), retaining raw traces and authoritative job timestamps; no actual bus or drive power. Otherwise inspect LinuxCNC's version-specific custom homemod interface and reconcile pin ownership, `HOME_ABSOLUTE_ENCODER=2` and Home All behavior against the installed/selected `cia402_homecomp`. If source yield is low, rotate to distinct router/spindle or Mesa HostMot2 implementation. Never manufacture tests or assume generated config equals commissioned machine.

## Evidence and compute

No builds, simulation, live HAL, EtherCAT bus, physical operation, independent evaluation or Actions compute. Hosted/self-hosted Actions 0/0 min; LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged. Prior ETHERCAT-50 Sync Unit and HOMING-27 Home All findings remain distinct; do not repeat without new evidence. Hourly task stays enabled.
