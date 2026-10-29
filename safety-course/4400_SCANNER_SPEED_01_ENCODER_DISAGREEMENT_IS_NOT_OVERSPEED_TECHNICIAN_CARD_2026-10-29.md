# 4400-SCANNER-SPEED-01 — Encoder disagreement is not the same as overspeed

**2026-10-29 | technician field card | DOCUMENTARY ONLY.** Source: [SICK nanoScan3 I/O 2025 OEM-mode audit](../research/4400_SCANNER_SPEED_01_SICK_NANOSCAN3_2025_RANGE_LIMIT_ENCODER_DISCREPANCY_GRACE_SOURCE_AUDIT_2026-10-29.md). Do not apply nanoScan3 values to an unidentified machine or another scanner family.

**Ask three separate questions:** Which protective **case** is selected? Does the selected safety function **trip on speed outside its limit**? When does **encoder disagreement** cause a diagnostic fault? One green indicator or one alarm does not answer all three.

The SICK 2025 indexed manual distinguishes `Range` (speed selects a case) from `Limit` (static inputs select a case and out-of-range speed drives safety outputs OFF). Its `Limit` passage allows **60 seconds of two-encoder speed disagreement**; this is **not** a statement that overspeed is permitted for 60 seconds. Another Speed subsection lists discrepancy allowances depending on travel speed, including a low-speed band without disagreement-triggered shutdown. Exact threshold-boundary precedence and mode interaction require the complete selected-product manual.

**Before acceptance (no machine motion):** identify the exact scanner/firmware and chosen mode, encoder scale and physical coupling, both signal paths, discrepancy tolerance, speed-limit setting, active field/cut-off mapping, safety-controller response, and independently verified final-element stopping. Review the low-speed crushing hazard, stuck/missing encoder and startup/mode-change cases. Document how an operator safely recovers from a mismatch without defeating a safeguard.

**Practical design rule:** prefer an easy-to-understand fixed protective field or independently verified speed/field scheme over unexplained nuisance trips and bypassable modes. Make fault messages and guard reinstatement easier than bypass. Ordinary LinuxCNC/FPGA status is monitoring, not personnel-safety authority.

**OpenPressBrake:** scanner, speed sensors, Pilz/AKAS configuration and physical Y1/Y2 stopping/holding are UNKNOWN. [Stage A A–G](4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md) unchanged. **G0/G1 HOLD; no personnel-exposed operation.** No machine test, lab compute or independent evaluation.
