# 3600 checkpoint — tandem field topology

Date: 2026-09-12

1. Re-check F02 first. Preserve information separation; do not self-score.
2. If F02 remains blocked, the tandem branch now has COMMUNITY-REPORTED FIELD SUCCESS with a disclosed high-level topology: two per-side position PIDs plus a differential sync PID with command 0, feedback Y1−Y2, reported to slow the leading side.
3. Do not turn that prose into a source-confirmed architecture. The promised final config is still the highest-value missing artifact.
4. Reopen tandem implementation work only if inspectable final HAL/component/config source appears showing correction insertion, ordering, limits/saturation, process-state gating, feedback/fault handling and recovery.
5. Preserve the newly documented electrical authority layering: HAL PWMgen enable/value → HostMot2 registers → custom FPGA routing → physical output stage → external amplifier readiness → brake state → motion. Custom firmware can alter physical coupling even though stock `pwmgen.c` exposes per-instance enable bits.
6. PB-PREP-001 remains INCONCLUSIVE / NO ARCHITECTURE RECOMMENDATION until the missing implementation semantics are resolved.
7. No new synthetic lab is justified by these prose-only field disclosures.
