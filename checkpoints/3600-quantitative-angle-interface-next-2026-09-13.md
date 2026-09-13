# Checkpoint — 3600 quantitative angle interface — 2026-09-13

Re-check F02 first. If still blocked, continue 3600 only with high-information source evidence.

Current best lead is `machinepilot/FANUC_dev` pinned at `23392889558240370cc0755ce5be4c72b181387f`. `LDJ/Kvara/PLC/Ioleng.inc` exposes phase-specific realtime angle values, explicit sensor/calculation state, and separate dynamic Y1/Y2 BDC correction channels. Repository search has not yet exposed the producer/calculation implementation.

Next trace: find actual readers/writers/producers/consumers for C7/C11/C12/C13, C8/C9, C2.7, C2.14, SER/LC floating/calculation states. Highest-value evidence would reveal freshness/generation, correction formula, correction insertion/limiting, Y1/Y2 interaction, sensor-error recovery, or tandem coordination.

Do not infer LinuxCNC behavior from this comparative artifact, do not treat public repository provenance as verified vendor behavior, and do not substitute a toy angle-control lab if only interface declarations remain.

PB-PREP-001 remains INCONCLUSIVE / NO ARCHITECTURE RECOMMENDATION.
