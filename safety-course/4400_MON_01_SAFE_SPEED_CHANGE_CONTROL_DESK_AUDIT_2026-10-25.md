# 4400-MON-01 — Low-cost, no-energy safety-speed change-control desk audit
**2026-10-25 | Practical engineering procedure | PAPER/DOCUMENTARY ONLY | NOT A MACHINE ACCEPTANCE OR TEST AUTHORIZATION**

## Purpose
Make the safe configuration easier to maintain than a defeated guard or improvised speed bypass. This review is for a qualified integrator before any selected-machine energization. Use exact OEM manuals, selected SRS and the existing [MON-01 module](4400_MON_01_SAFE_SPEED_MODE_SELECTION_ENCODER_CCF_AND_PHYSICAL_STOP_MODULE_2026-10-25.md); do not invent thresholds or rely on CNC/FPGA diagnostics as personnel safety.

## Inputs and evidence ownership
Record current installed model, hardware/firmware, complete configuration export/hash, approved previous revision, as-built selector truth table, actual terminal-level wiring, encoder/coupling/connector drawing, risk assessment, safety function/SRS, output/final-element chain, operator modes, maintenance instructions and actual qualified validation records. Use a **restricted machine repository** for private as-built files; public curriculum gets only de-identified method and status.

## Desk gates — each requires VERIFIED / UNKNOWN / NOT APPLICABLE WITH EVIDENCE
| Gate | Documentary question | If missing |
|---|---|---|
| D01 | What hazard/exposure and physical safe state is this function intended to control? | HOLD |
| D02 | Is the selected OEM model/manual revision correct? | HOLD |
| D03 | Are mode selector bits, including every open/short/intermediate state, enumerated? | HOLD |
| D04 | Does parameter-set selection preserve the required integrity claim? | HOLD |
| D05 | Are special diagnostic bypass, auto-acknowledgment, restart options inventoried? | HOLD |
| D06 | Is each output's **safety versus ordinary diagnostic** role verified terminal-by-terminal? | HOLD |
| D07 | Are both sensor mechanical load paths and CCF independently reviewed? | HOLD |
| D08 | Are common 24V/0V, cable, connector, supply, EMI and sensor scaling documented? | HOLD |
| D09 | Are speed transition, monitor, output and final-element delays separately budgeted? | HOLD |
| D10 | Does a normal CNC `at-speed` or `ready` bit appear anywhere in the personnel-safety claim? | HOLD / redesign |
| D11 | Does SLS reset during a transition restore normal-speed permission? Exact OEM state table? | HOLD |
| D12 | Does a guard-clear or reset event resume an old motion command? Fresh deliberate start defined? | HOLD |
| D13 | Are gravity loads, hydraulics, brakes, pressure and stored energy separately controlled? | HOLD |
| D14 | Can guards be restored, jams cleared and modes switched without routine nuisance bypass? | Redesign task |
| D15 | Are change records, independent reviewer, validation plan and rollback identity complete? | HOLD |

## No-energy source-only inspection sequence
1. Compare **previous vs proposed** configuration line by line. List each changed bit, special function, output assignment, reset mode, threshold, delay and sensor map.
2. Build an input/parameter/output **truth table** from the exact manufacturer manual. Mark unsupported states UNKNOWN; never assume an open wire yields safe-off across all variants.
3. Draw separate **normal-control** and **independent safety** dataflow. Trace ordinary `spindle.N.at-speed` (possibly unwired true) only as normal sequencing.
4. Draw the **physical energy** path for every dangerous axis, including hydraulic/gravity load, brakes, pneumatic/tool release, process energy and stored pressure.
5. Produce a fault matrix: selector broken wire, encoder shared coupling break, 0V loss, output substitution, SLS reset during transition, delayed overspeed response, guard defeat, power return and retained command.
6. Get independent qualified review and risk-based physical-validation plan **before** authorizing any energized work. Desk pass is not physical proof.

## Easy-safe human-factors patterns
- Provide labeled mode positions, keyed/managed configuration, clear external fault messages, accessible diagnostic **read-only** status and an operator recovery procedure that does not require opening a safety cabinet.
- Favor robust sensor mounts, physically separated wiring, low-cost independent final elements where validated, clear guard alignment/reinstallation, and accessible reset with line of sight.
- Track nuisance stops and maintenance workarounds; repeated bypass pressure triggers an engineering redesign, not weaker thresholds or disabling diagnostics.
- Require explicit **new** start after safeguard restoration; reset alone should not execute queued LinuxCNC commands.
- Provide a simple no-people-exposed **hold** rule when any basic safe-state proposition lacks independent proof.

## Exit state
Desk review COMPLETE means only that **documentation and change hazards are identified**. G0/G1 may remain HOLD; G2 physical plan not run; G3/G4 not authorized without qualified independent as-built physical validation. No new PL/SIL, speed, stop distance, pressure, leakage or safe-to-operate approval can be inferred. External fresh competency evaluation still open.

## Provenance
[Original Pilz parameter-mode audit](../research/4400_PILZ_PNOZS30_PARAMETER_SET_SELECTION_DIAGNOSTIC_BYPASS_AND_OUTPUT_SCOPE_AUDIT_2026-10-25.md); [original SICK example dual encoder audit](../research/4400_SICK_STATIONARY_MACHINE_TWO_ENCODER_CCF_SPEED_RAMP_AND_RESTART_OEM_AUDIT_2026-10-25.md); [pinned LinuxCNC at-speed source](../research/4400_LINUXCNC_PINNED_SPINDLE_AT_SPEED_DEFAULT_TRUE_RAMPED_COMMAND_VS_SAFETY_MONITOR_SOURCE_TRACE_2026-10-25.md); [Rockwell manufacturer-indexed during-delay SLS reset lead](../research/4400_ROCKWELL_MSR57P_SLS_RESET_DURING_DELAY_INDEXED_SOURCE_LIMIT_2026-10-25.md) **full original unavailable**. Claim classes: DOC-CONFIRMED for directly inspected Pilz/SICK, SOURCE-CONFIRMED for pinned LinuxCNC, indexed-only DOC evidence for Rockwell, INFERENCE for desk gates, UNKNOWN for selected machine.
