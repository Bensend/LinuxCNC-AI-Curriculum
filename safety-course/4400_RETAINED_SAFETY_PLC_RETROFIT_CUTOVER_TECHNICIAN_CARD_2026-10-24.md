# 4400 technician field card — Retained safety PLC during a LinuxCNC CNC retrofit

**Status:** learner-facing **PAPER ONLY**; **NOT** a blind assessment, machine validation, physical test authorization or achieved PL/SIL claim.  
**Prerequisite:** [original 4400 brownfield cutover source audit](../research/4400_BROWNFIELD_CNC_RETROFIT_SAFETY_PLC_CUTOVER_AND_LOCKABLE_ISOLATION_AUDIT_2026-10-24.md), [2530 LinuxCNC software E-stop trace](2530_LINUXCNC_ESTOP_LATCH_BOUNDARY_TRACE_2026-09-22.md), 2520–25F0 safety route.  
**Equipment:** none. **Machine:** entirely fictional press-brake retrofit. Do not assume any scenario describes an actual OpenPressBrake installation.

## One-minute source retrieval

LinuxCNC 2.9 [`iocontrol` manual](https://linuxcnc.org/docs/2.9/html/man/man1/io.1.html) says `emc-enable-in` is a non-realtime software input and `user-request-enable` is an ordinary user request. Pinned [`estop_latch.comp`](https://github.com/LinuxCNC/linuxcnc/blob/514be4f657b2f1c432ebaaebd117ef112e3e7565/src/hal/components/estop_latch.comp) requires a software reset rising edge, with non-faulting defaults for unconnected `ok_in`/`fault_in`. OSHA [1910.147(c)(2)(iii)](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147) adds a lockout-capability design requirement when its replacement/major-repair/renovation/modification trigger applies. These do **not** establish any particular machine's safe response.

## 12 adversarial paper scenarios

For each case: (a) identify the claimed safe-state proposition, (b) name the actual physical final element and independent witness that would be needed, (c) classify evidence, (d) state HOLD/NOT APPLICABLE/REVIEW, and (e) propose a low-friction safer implementation. No energized trials.

| Case | Situation | Required reasoning discriminator |
|---|---|---|
| RC-01 | Old CNC removed; old safety PLC still shows green. New HMI says READY. | PLC power/status is **not** continuity of each safety function or proof of independent physical stop/hold. Require before/after per-hazard path and final-element witnesses. |
| RC-02 | Old safety PLC output is rewired only to a general FPGA input; FPGA drives all valve coils. | A safety *status* input is not a safety-rated output withdrawal. Trace who independently removes hazardous energy when FPGA freezes high. HOLD. |
| RC-03 | Old controller sent a changing acknowledge signal; retrofit hard-wires it high to avoid startup faults. | Determine whether old acknowledgement was safety-related and what fault/timeouts it covered. Do not spoof unknown handshake. HOLD. |
| RC-04 | E-stop pushes `iocontrol.0.emc-enable-in` false, but no one can identify what physically disables the drive/valves. | Software E-stop coordination is not a machine safety function. Independent final element/physical reaction UNKNOWN; no exposed operation. |
| RC-05 | `estop_latch` has no external fault connected and returns OK after reset. | SOURCE-CONFIRMED defaults are non-fault-causing; inspect actual HAL nets. No proof of external E-stop coverage. |
| RC-06 | Safety PLC reset is pressed while a foot switch is held and LinuxCNC retains a cycle request. | Distinguish reset accepted, rearm eligible, separate **new** start; invalidate stale requests. No automatic motion on reset. |
| RC-07 | Power returns after a brownout. PLC READY and HMI READY are both true. | Prove independent power-restoration inhibit, final-element state, actual occupancy/visibility and deliberate local start. |
| RC-08 | New cabinet disconnect is a non-lockable toggle; service team uses the HMI OFF button. | OSHA 1910.147(c)(2)(iii) applicability must be reviewed for major modification; control button is not energy isolation. Lockable physical isolator and verified stored-energy control. |
| RC-09 | Hydraulic pump power is isolated but an accumulator, cylinder chamber and unsupported ram remain. | Electrical lockout alone cannot prove pressure or gravity safe; identify zones, independent restraint and verification. |
| RC-10 | The old safety PLC program is copied with matching checksum but a terminal has been moved. | Program identity is not wiring identity. Trace as-built terminal-to-final-element and mark affected `VAL/PT` STALE. |
| RC-11 | Guards are so hard to refit that technicians routinely jumper the interlock to debug. | Foreseeable bypass is an engineering/usability defect; improve hinged/keyed mounting, visibility and fault diagnostics without defeating the safeguard. |
| RC-12 | A retrofit is declared complete because a bench test shows the FPGA output falls on a simulated E-stop. | Bench logic is narrow ordinary-control evidence; no independent safety output, real valve/contactor, physical stopping, holding, guard/occupancy or isolation proved. HOLD. |

## Exercise deliverable: four independent drawings, one release disposition

Draw these separately on paper:

1. **Normal command:** HMI/LinuxCNC → FPGA → normal motion/valve/VFD.
2. **Independent safety:** actual guard/E-stop → safety controller → safety final element → physical stop/hold.
3. **Diagnostic:** safety status → ordinary HMI/logger (no safety authority granted).
4. **Service:** lockable isolation → stored-energy handling → physical verification → restoration.

Then fill the [blank cutover acceptance worksheet](4400_CNC_RETROFIT_SAFETY_FUNCTION_CONTINUITY_AND_ISOLATION_WORKSHEET_2026-10-24.md). The learner must explicitly identify one unsafe **common dependency** between normal and safety paths, one **physical witness** not reducible to a controller bit, and one **guard-defeat incentive** with a practical redesign.

## Teaching notes, not a hidden grading key

A good response rejects any single READY/green/PLC-alive/FPGA-inhibit observation as proof of a whole safety function. It identifies the missing machine-specific drawing, physical final element and witness; avoids inventing hydraulic port truth, timing or PL/SIL; and distinguishes production protective stopping from service LOTO. A fresh external evaluator must use a **novel** scenario and preserve information separation. These 12 scenarios are **not scored** and do not graduate a module.

## Current status

`RC-01..12 PAPER ONLY`; `VAL/PT NOT RUN`; `G0/G1 HOLD`; `G2 NOT RUN`; `G3/G4 NOT AUTHORIZED`; `G5 HOLD`. The selected-machine old/new control wiring, lockable isolators, safety program, final elements, physical stop/hold and rearm behavior are **UNKNOWN**. No simulation is needed to establish these documentary distinctions; any eventual machine test must be designed and supervised independently, with people excluded from the danger zone.
