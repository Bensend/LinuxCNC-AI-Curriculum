# Safety validation evidence-class and return-to-service matrix

Date: 2026-09-20
Course: 4000 safety / professional machine implementation

## Purpose

Convert the safety course's accumulated manufacturer evidence into a reusable commissioning/maintenance reasoning tool. The central lesson is that "tested" is too vague. A machine can pass one evidence class while still having an untested dangerous failure in another.

## Four validation evidence classes

### A — Normal-demand functional test

Question: when the protective device is deliberately demanded under normal wiring/configuration, does the safety chain perform its intended basic function?

Examples already supported by course evidence:
- E-stop / guard / protective-field demand produces the intended stop or inhibit.
- enabling device middle position permits the bounded function; release/full squeeze removes permission.
- scanner intrusion at required physical points stops dangerous motion.

Does **not** prove representative fault handling, quantitative stopping performance, or long-term proof-test obligations.

### B — Deliberate abnormal-operation / fault-injection test

Question: when a representative fault that the architecture claims to detect/tolerate is deliberately introduced, does the assembled system reach the required disposition and inhibit inappropriate restart?

Authoritative example: Rockwell SAFETY-AT055 shorts an enabling-switch safety channel to its test source while jogging and separately removes the safety-I/O network connection. The expected physical result includes external contactor de-energization; diagnostics and inability to reset/restart with the fault are checked.

Other course examples include deliberate safety-input short/cross-fault procedures and manufacturer validation checklists that explicitly call for potential fault injection.

Does **not** prove quantitative stop distance, brake holding torque, hydraulic pressure removal, or every possible fault.

### C — Quantitative physical performance test

Question: did the actual machine meet a measured physical acceptance criterion rather than merely report the right state?

Existing course examples:
- measured press-brake stopping time used to establish/re-evaluate safeguard distance;
- ABB reduced-speed test measures travel/time rather than trusting mode status;
- Siemens Safe Brake Test applies defined torque and measures movement against tolerance;
- Siemens SLS acceptance challenges actual speed limit/stop response.

Does **not** by itself prove fault diagnostics or recurring test interval compliance.

### D — Periodic functional/proof test

Question: after commissioning, what hidden failures can accumulate and what written recurring test is required to reveal them within the assumptions of the safety design?

Rockwell GuardLogix/PowerFlex documentation establishes that functional/proof-test intervals are application-dependent and that sensors, safety I/O and actuators can have requirements different from the controller. PointMax documentation provides architecture-specific examples where output safe-state functional testing is required at stated intervals.

A periodic proof test is not merely "press E-stop once a year." Its scope must come from the actual safety-function/component assumptions.

## Cross-function matrix

| Safety function / evidence family | A normal demand | B fault injection | C quantitative physical proof | D periodic proof-test basis | What remains unproved |
|---|---|---|---|---|---|
| Enabling device + jog + contactors | Manufacturer position/jog behavior exists | Rockwell channel short + network-loss checklist physically de-energizes contactors and checks restart inhibition | Stop/coast performance remains machine-specific | Component/application dependent | stopping distance/time, machine-specific acceptable coast, all wiring faults |
| Protective field / scanner | Physical boundary intrusion and machine reaction procedures exist | Some device/system fault diagnostics exist; do not infer complete fault set from boundary test | safeguard distance depends on actual stop performance | device/application dependent | retained-person coverage unless architecture/tests explicitly prove it |
| Safety contactors / EDM | command and feedback chain documented | welded/mismatch behavior can be challenged where manufacturer procedure permits | contact feedback does not measure machine stop | component/application dependent | all hazardous energy removed |
| Drive STO/SLS | STO/SLS activation tests exist | safety fault/status paths documented; use only manufacturer-supported injection methods | SLS overspeed/stop-response tests; STO still does not prove standstill | drive/module documentation governs | electrical isolation, gravity/load retention unless separately proved |
| Mechanical holding brake | command/feedback can be tested | feedback mismatch is not equivalent to mechanical fault proof | Siemens SBT torque/movement test physically challenges holding ability | brake/drive/application dependent | OpenPressBrake-specific torque/tolerance/interval |
| Hydraulic final element | command/position evidence can be checked | generic fault injection is insufficient without actual valve architecture | pressure/motion/retention acceptance remains machine-specific | component/application dependent | safe pressure threshold, ram retention, quantitative stop behavior |
| Reset/restart | reset and fresh-start sequencing can be tested | stale/pending command challenge is valuable where procedure permits | normally no standalone quantitative metric | architecture/application dependent | personnel-clear state unless separately sensed/procedurally established |

## Return-to-service gate

The curriculum should teach return-to-service as a *claim supported by applicable evidence classes*, not a single green status.

For each maintenance/change event:

`identify affected safety functions -> determine which evidence classes the change can invalidate -> perform the applicable tests -> repair any discrepancy -> repeat affected tests -> restore safeguards -> requalify safety state -> require separate fresh ordinary start`

**INFERENCE**, synthesized from manufacturer evidence and existing course studies. The actual required tests remain machine/component specific.

## Human-factors rule

The worksheet/checklist should make the correct validation path easier than skipping it. Pre-fill the affected safety functions and test classes from the machine design; provide obvious physical test points and status indications; avoid procedures that require defeating unrelated safeguards just to obtain a measurement. If a required energized test cannot be performed with a bounded task-specific safety mode, isolate/remote the test or redesign the test method.

## Anti-shortcut rules to freeze

- **TESTED != VALIDATED** unless the evidence class and acceptance criterion are named.
- **HAPPY-PATH PASS != FAULT RESPONSE VALIDATED.**
- **FAULT-INJECTION PASS != PHYSICAL PERFORMANCE ACCEPTED.**
- **PHYSICAL PERFORMANCE PASS != PERIODIC PROOF-TEST PROGRAM DEFINED.**
- **DIAGNOSTIC BIT CORRECT != FINAL ELEMENT PHYSICALLY PROVED.**
- **REPLACEMENT COMPLETE != RETURN TO SERVICE AUTHORIZED.**
- **ALL APPLICABLE SAFETY TESTS PASS != ORDINARY START COMMAND IMPLIED.**

## OpenPressBrake use

This matrix is a curriculum/design scaffold, not a completed OpenPressBrake validation plan. Values and required test sets that depend on the actual machine remain **UNKNOWN** until supported by design-specific evidence or measurement. Ordinary LinuxCNC/FPGA control may assist logging and guided test sequencing, but it must not become the personnel-safety authority merely because it hosts the checklist UI.

## Next evidence target

Apply this matrix to one complete professional machine return-to-service example after a safety-related change, looking specifically for a manufacturer/OEM procedure that traverses multiple evidence classes and ends with explicit production reauthorization. If unavailable, rotate to another high-value safety branch rather than manufacturing a synthetic OEM procedure.
