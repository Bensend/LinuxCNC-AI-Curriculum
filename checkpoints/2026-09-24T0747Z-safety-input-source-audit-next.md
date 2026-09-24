# Safety input / FPGA interface checkpoint — 2026-09-24T07:47Z

Status: authoritative source audit completed for `SI-DRY2`, `SI-OSSD2`, and the `FS-IF` hard-inhibit/service boundary. External/fresh safety-course competency gates remain open and uncontaminated.

Durable result:
- `research/SAFETY_INPUT_AND_FPGA_INTERFACE_SOURCE_AUDIT_2026-09-24.md`

New freezes:
- `DUAL DRY CONTACT != CROSS-SHORT DETECTION`.
- `OSSD TEST PULSE != PROTECTIVE-DEVICE DEMAND` only where the selected manufacturer interface defines the pulse as diagnostic and the receiver is qualified/configured to tolerate it.
- OSSD electrical thresholds, leakage/current behavior, test-pulse timing/filtering and loading are device-pair specific; no universal values are frozen.
- Every dual-channel instance declares where discrepancy evaluation lives and which layer owns fault/reset behavior.
- `FPGA INHIBIT ASSERTED != PHYSICAL SAFE STATE PROVED`.
- Debug/programming/service paths capable of bypassing a hard inhibit are safety dependencies, not harmless convenience features.

No PL/SIL target, diagnostic coverage, discrepancy time, proof-test interval, stopping value, hydraulic behavior or universal OSSD/test-pulse circuit was invented.

No executable question survived source/engineering reasoning; no compute was run and no GitHub-hosted minutes were consumed.

Exact next work:
1. Add per-family implementation-spec templates for `SI-DRY2` and `SI-OSSD2` that require device-pair electrical compatibility evidence rather than fixed generic thresholds.
2. Add an `FS-IF` implementation-spec template that requires an exact inhibited resource, hardware dominance proof, reset/configuration behavior, service/programming dependency analysis and independent final-element authority chain.
3. Perform an adversarial dependency/CCF review across common 24 V/0 V, protection parts, connectors/cable, pulse sources, controller supplies, FPGA reset/configuration, service headers and final-element/pilot supplies.
4. Do not freeze schematics until those gates are satisfied.
5. Preserve the 2520–25F0 information-separated evaluation gates and do not self-score them.