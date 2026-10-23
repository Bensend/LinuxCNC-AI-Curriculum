# 4400 — Pilz PNOZ s30 configuration CRC is transfer evidence, not functional proof

**Study UTC:** 2026-10-23. **Source:** Pilz *PNOZ s30 Operating Manual* **1001715-EN-24**, published 2025-04-29, official PDF https://www.pilz.com/download/open/PNOZ_s30_Operat_Man_1001715-EN-24.pdf. **Status:** DOC-CONFIRMED for specified manual/sections; INFERENCE for engineering gate; UNKNOWN for selected device, wiring, firmware, parameter sets, installed motion and physical validation. No test executed.

## Frozen question

A replacement standstill monitor receives a configuration copied from the old device. The displayed CRC matches the engineering project's CRC. Can the maintainer now assume that the replacement provides the required guard-unlock and restart behavior?

**No.** The manufacturer's CRC comparison supports a narrow configuration-transfer proposition. It does not replace checking that the chosen configuration is appropriate for the application or that the safety devices actually operate correctly after a configuration change/download.

## Exact manufacturer evidence

| Manual location | DOC-CONFIRMED proposition | What is *not* established |
|---|---|---|
| §8.5.4, printed p.61 | On chip-card transfer, note and compare the configuration CRC after loading. | Physical wiring, correct sensors, threshold, mechanical coupling or stop/hold. |
| §8.5.5–8.5.6, printed pp.62–64 | Older device-version compatibility/upgrade can produce a **new CRC**; some changes are incompatible with older versions. | A changed CRC alone is not proof of a dangerous behavioral change, nor proof of equivalence. |
| §8.6, printed pp.65–66 | The manufacturer cautions that the **appropriate configuration** must be transferred to the device and the CRC checked after transfer. | Correct project choice cannot be inferred solely from matching an accidentally selected project's CRC. |
| §9.1, printed pp.86–87 | A cable download **overwrites existing device data**; compare device CRC with configurator CRC after transfer. | Old settings survive a download, or successful download establishes application safety. |
| §9.2, printed pp.88–89 | Changing a project name also changes its CRC; identical project configurations have the same checksum **when the name is unchanged**. | CRC is a universal semantic-equivalence proof across renamed projects. |
| §10, printed p.89 | The manufacturer requires checking correct safety-device operation **after configuration changes and project downloads**. | CRC match alone discharges commissioning validation. |

These statements are product/edition-specific. They do not justify generic assumptions about other controllers' CRC algorithms, firmware compatibility or safety performance.

## Two separate verification gates (INFERENCE)

**Gate 1 — identity/transfer:** record full product order and hardware/software version, selected project name and controlled file, intended parameter-set selection, original and installed CRC, download route, device display evidence and operator/engineer review. A mismatch or unexpected new CRC requires investigation; a match is not a functional test.

**Gate 2 — application/physical function:** check the *selected* sensor and mechanical coupling, actual input-to-output response, fault/diagnostic behavior, response-time dependencies, reset/automatic-start mode, guard release, final-element stop/hold and safe access. Use a machine-specific risk assessment and independent physical witnesses. Every `VAL/PT` is **NOT RUN** until performed; do not infer PL/SIL, speed threshold or stopping distance.

## Failure-path review

1. **Wrong project, matching CRC:** a technician downloads the wrong but internally consistent project. The transfer CRC matches that project's CRC. Only independent review of selected machine functions/parameters catches the error.
2. **Version upgrade/new CRC:** a chip-card transfer to a different version changes the CRC. The manual documents compatibility mechanisms; do not blindly reject or accept without parameter comparison and function test.
3. **Project renamed:** the CRC changes even when the logical settings appear unchanged. Do not infer functional change from CRC alone.
4. **Sensor shaft decouples:** the monitor reports standstill for the shaft while the hazardous load moves. Neither a correct CRC nor a safety relay output proves actual load restraint.
5. **Retained start:** monitor outputs re-enable under the configured start mode while an ordinary LinuxCNC cycle request remains asserted. Separate independent safety rearm and deliberate production start are required.

## Practical technician/change-control worksheet

Record `CHG` (old/new device, firmware, project name, CRC, transfer mechanism); `SRS/AUTH/ARC/DEP` (selected safety-related function, parameter-set selection, sensor dependencies and actual final elements); `VAL/PT` (separate identity/transfer evidence and function/physical tests); `HF` (clear device labels, protected backups, obvious post-download checklist); `UNK/RR` (unmeasured machine behavior and operational restrictions). Mark dependent evidence **STALE** on relevant configuration changes and preserve the old proof for history.

This is **not** a machine commissioning authorization. Personnel-exposed hazardous operation is prohibited until the selected-machine minimum safe-to-operate propositions are demonstrated. Isolated/remote experiments require people outside the hazard zone and residual-risk controls.

**Related open practice:** `safety-course/4400_STANDSTILL_GATE_ADVERSARIAL_QUALIFICATION_2026-10-22.md`. External 2520–25F0 competency gates remain information-separated and OPEN.
