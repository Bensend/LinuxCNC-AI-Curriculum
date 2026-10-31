# 4000 — HostMot2 encoder filter-rate disconnected acceptance (seven bounded cases)

**2026-10-31 | NOT RUN | no physical I/O.** Companion [HM2-FILTER-75](../research/4400_LINUXCNC_HM2_FILTER_75_ENCODER_SAMPLE_FREQUENCY_DIVIDER_READBACK_SOURCE_AUDIT_2026-10-31.md). Revisions: LinuxCNC v2.9.10 `encoder.c` blob `9719d41419da9220761637e002024cdc9d17a8ba`; development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`, blob `4ed8ad05e22405c8221d31d624d56e637dfefe19`; firmware `src/regmap` blob `b3a2a77c27de0c71278dc910992efeddd7deb577`.

Archived firmware RTL cross-check: [`qcounterate.vhd`](https://github.com/LinuxCNC/hostmot2-firmware/blob/c15c0c3c0af826fd2996aa1eddb8669f154bb2a5/src/qcounterate.vhd) blob `c20d46f33bd2912bd3f8c8cb3273a142a34e65a6` and [`qcounteratesk.vhd`](https://github.com/LinuxCNC/hostmot2-firmware/blob/c15c0c3c0af826fd2996aa1eddb8669f154bb2a5/src/qcounteratesk.vhd) blob `af1adfa5647ea591775c803ca172318d2a2df80c`. Both show the MSb-driven reload/pulse generator; F3/F4 full-clock expectation is now supported by **archived HDL source**, but is still NOT an executed FPGA test or installed-firmware observation.

## Isolation and oracle
Only execute when a **positively verified disconnected** software fixture or FPGA-register mock exists on an authorized `[self-hosted, openpressbrake]` runner. Do not dispatch to a panel PC without independent physical isolation. Do not invoke LinuxCNC with live Mesa cards, drives, axes or hydraulic I/O. No GitHub-hosted Actions. A C arithmetic model can establish arithmetic; it cannot establish the FPGA implementation. Record separately: (a) requested HAL input, (b) computed quotient/register, (c) mutated HAL input/shadow, (d) low-level write call/result, (e) simulated FPGA interpretation, (f) process exit/fault. Keep exact compiler/architecture, FPGA image and clock provenance. Do not treat a mock result as physical validation.

## Frozen cases (33 MHz illustrative module clock)
| ID | Stimulus | Predicted source result / oracle | Acceptance question |
|---|---|---|---|
| F1 | request 1,000,000 | q=33, register=31, HAL readback=1,000,000 | ordinary divisor works |
| F2 | request 16,500,000 | q=2, register=0, HAL readback=16,500,000 | high normal divisor works |
| F3 | request 25,000,000 | q=1, register=0xFFF, HAL readback=8,054; regmap says full 33 MHz | software readback differs from hardware semantics |
| F4 | request 8,054 | q=4097, register=0xFFF, HAL readback=8,054; regmap says full 33 MHz | low-frequency discontinuity |
| F5 | request 0 | division by zero at `clock/request`; do **not** execute on physical controller | invalid zero rejected safely in candidate fix; current path has no guard |
| F6 | request 33,000,001 | q=0, unsigned register underflows to 0xFFFFFFFE, `+2` wraps to 0, then division by zero | invalid above-clock request rejected safely in candidate fix |
| F7 | inject low-level write failure in mock | `hm2_encoder_set_filter_rate_and_skew` does not check `llio->write` return, but updates shadow | distinguish software shadow from accepted hardware write |

## Reproducibility / recording
1. Pin exact LinuxCNC source and firmware regmap hashes above. Preserve exact `clock_frequency` rather than assuming every Mesa card runs at 33 MHz.
2. For F1–F4, instrument the helper or implement a **pure isolated arithmetic model** that preserves unsigned 32-bit operations and truncating division. Verify output register, published HAL input and regmap interpretation independently.
3. For F5–F6, prefer source review or a subprocess test of a separately compiled pure arithmetic extraction with controlled signal/exit capture; **do not load the driver on a machine**. A compiler-optimized divide-by-zero test may exhibit undefined behavior; capture actual compiler, sanitizer, exit and stderr rather than inventing a universal crash result.
4. For F7, use a mock low-level interface returning failure, not a live bus fault. Observe whether the shadow is updated, and whether a second unchanged input triggers a retry.
5. For a candidate hardening patch, rerun F1–F7 plus a boundary sweep around q=1, q=2, q=2049, q=2050 and register 0xFFF; ensure documented divide-by-one behavior and low-frequency representability are explicit. Validate that muxed-skew high bits remain unchanged.
6. Record PASS/FAIL/INVALID/NOT RUN per case, source and runtime evidence separately. All cases **NOT RUN** at publication.

## Engineering takeaway
An input pin is not necessarily a truthful hardware readback when a driver writes its normalized value back into it. An FPGA special register code must be handled symmetrically in both encoding and reporting. This applies to future custom HostMot2-compatible FPGA modules as well as existing Mesa integration.

**Gates unchanged:** independent personnel safety and physical G0/G1 HOLD; no learner-visible blind answer or external evaluator result; no lab compute charged.
