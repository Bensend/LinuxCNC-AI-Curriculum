# 4400-SCAN-03 — Eight park/standby technician cases
**PAPER ONLY | UNSCORED | not a blind evaluation | no machine test**

For each case, identify the unsupported assumption, exact manufacturer/configuration evidence, safety-related authority, physical safe-state requirement and operator-facing design correction.

1. Two S300 scanners share common OSSDs; only one enters standby for mobile charging.
2. Two S300 scanners use separate OSSDs; one enters standby and the operator assumes all zones are disabled.
3. The S300 display says park/standby is 'not an error'; an HMI shows overall green.
4. Ordinary LinuxCNC sets a bit labeled 'scanner standby' during tool changes.
5. A single-channel STBY input is confused with a dual-channel protective stop.
6. A parked scanner resumes scanning, and a previously retained CNC cycle command is still present.
7. Maintenance personnel use standby instead of lockout and physical ram restraint.
8. A scanner replacement preserves a familiar project name but changes common/separate OSSD wiring.

**Source-grounded principles:** original S300 2025 §7.13.6 distinguishes common and separate OSSD effects, laser OFF and non-fault standby. It does **not** prove OpenPressBrake has any S300 or that hazardous motion automatically restarts. Any exposed operation remains prohibited without selected-machine independent stop/hold, hydraulic isolation, guarding and restart validation. **G0/G1 HOLD; all cases UNSCORED.**
