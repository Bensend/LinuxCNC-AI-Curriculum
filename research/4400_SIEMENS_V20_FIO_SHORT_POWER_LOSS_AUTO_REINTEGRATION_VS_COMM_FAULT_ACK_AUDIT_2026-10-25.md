# 4400-REINT-01 — A short F-I/O power dip can reintegrate without the expected manual acknowledgment
**2026-10-25 | Original Siemens V20 source audit | NON-GRADUATED / documentary only**

## Precise unresolved question and prediction
Does setting manual channel-fault acknowledgment guarantee a new human acknowledgment after *every* brief power interruption? **Prediction before direct source inspection:** no; communication-error handling, channel-fault reintegration, and power dips shorter than the configured monitoring time may be distinct states. A safe application must not infer a new deliberate motion command from network reintegration.

## Direct original Siemens evidence
- Siemens, *SIMATIC Safety — Configuring and Programming*, **V20, October 2024**, “After F-I/O or channel faults”, section text after navigation at lines 298–325: https://docs.tia.siemens.cloud/r/en-us/v20/simatic-safety-configuring-and-programming/f-i/o-access/passivation-and-reintegration-of-f-i/o/after-f-i/o-or-channel-faults . **DOC-CONFIRMED:** a detected F-I/O fault can passivate the entire module; with channel-granular configuration, only affected channels may be passivated. Automatic reintegration can occur with ACK_NEC=0; manual reintegration with ACK_NEC=1 requires positive ACK_REI/ACK_REI_GLOB edge after fault clears and ACK_REQ=1. **Critical OEM warning S012:** after a supply failure shorter than assigned F-monitoring time, **automatic reintegration can occur regardless of ACK_NEC/channel-acknowledge configuration**. If prohibited by process, OEM instructs startup protection evaluating quality/passivation state (QBAD, per-channel status, value status, PASS_OUT). A longer loss is detected as communication error.
- Siemens, *SIMATIC Safety V20*, “After communication errors”, lines 298–324: https://docs.tia.siemens.cloud/r/en-us/v20/simatic-safety-configuring-and-programming/f-i/o-access/passivation-and-reintegration-of-f-i/o/after-communication-errors . **DOC-CONFIRMED:** detected F-CPU/F-I/O communication error passivates entire F-I/O with fail-safe zero values for described profiles; reintegration after errors cleared and ACK_REQ=1 requires positive edge on ACK_REI or global ACK_GL input in described configuration. This does **not** override the separate short-supply-dip S012 exception.
- Version cross-check: Siemens V21 “After F-I/O or channel faults”, **November 2025**, repeats S012 warning: https://docs.tia.siemens.cloud/r/en-us/v21/simatic-safety-configuring-and-programming/f-i/o-access/passivation-and-reintegration-of-f-i/o/after-f-i/o-or-channel-faults . Do not assume all future or other-vendor F-I/O behave identically.

## Why it matters
| Condition | OEM-supported logical response | Still unproven |
|---|---|---|
| Detected communication fault | Module passivation and fail-safe values, then explicit acknowledgment for described reintegration | Physical valve isolation, ram hold, guard condition |
| Channel fault, ACK_NEC=0 | Automatic reintegration on fault clearance | Fresh human motion authorization |
| Channel fault, ACK_NEC=1 | Positive acknowledgment after ACK_REQ under described ordinary fault | Guarantee of human acknowledgment after **short** supply dip (OEM explicitly warns exception) |
| Supply interruption shorter than F-monitoring time | Automatic reintegration **may** occur regardless manual channel ack setting | Whether an actual selected machine moves or has independent restart inhibit |
| Output values set to 0 | Controller's logical fail-safe values | Actual external load OFF and gravity load held; cf. 4400-OUT-01 |

**False equivalences:** ACK_REI is not a fresh ordinary cycle start; fail-safe zero is not measured physical zero energy; F-I/O communication recovered is not proof that an operator has left the danger zone. A safety controller must implement its own validated safety functions; LinuxCNC/HAL/FPGA ordinary state must not supply personnel-safety authority.

## Human factors and design
Do not make a short power dip trigger an unexplained “READY” green lamp that invites immediate reset. Make loss-of-validity/recovery visible, preserve the distinction between acknowledged safety re-integration and new motion command, and give operators a short safe recovery path. Physical final-element and guard usability must be proven. Do not prescribe an unmeasured monitoring-time value, a safety PL/SIL, or a generic state machine for another manufacturer's hardware.

## Status and future evidence
**DOC-CONFIRMED** Siemens V20 and V21 exact statements. **INFERENCE** cross-machine restart-inhibit and diagnostic presentation design. **UNKNOWN** OpenPressBrake uses Siemens, selected firmware, ACK_NEC, F-monitoring time, Y1/Y2 stop/hold, physical response and independent evaluator. **SOURCE-CONFIRMED LinuxCNC** none; **TEST-CONFIRMED** none; **COMMUNITY-REPORTED** none. No simulated/energized short-power injection; such an experiment would require qualified isolated/remote plan, people excluded, independently proven containment and a concrete remaining question not answered by OEM docs. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED.
