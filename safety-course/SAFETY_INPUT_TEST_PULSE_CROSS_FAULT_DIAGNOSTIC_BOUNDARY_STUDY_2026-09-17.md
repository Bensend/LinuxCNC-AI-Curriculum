# Safety input test-pulse / cross-fault diagnostic boundary study — 2026-09-17

## Purpose

Independent Lane-B study of a narrow but high-value safety-I/O failure path: when dual-channel E-stop, guard, two-hand, reset, or other contact circuits are assumed to be independent, what does the safety input architecture actually prove about shorts, cross-circuits, wiring faults, and reset/restart behavior?

This is not an OpenPressBrake circuit specification. Exact I/O hardware, wiring topology, pulse timing, required PL/SIL/category, discrepancy timing and acceptance thresholds remain UNKNOWN until the machine safety architecture is selected and validated.

## Frozen architecture distinctions

- TWO CHANNELS != TWO INDEPENDENT CHANNELS.
- INPUTS AGREE != FIELD WIRING HEALTHY.
- TEST PULSE PRESENT != EVERY CROSS-FAULT DETECTABLE.
- FAULT DIAGNOSTIC != PHYSICAL HAZARD REMOVED.
- DIAGNOSTIC RESET != SAFETY RESET != ORDINARY START.
- STANDARD FPGA/LINUXCNC INPUT OBSERVATION != SAFETY-RATED FIELD-WIRING DIAGNOSTIC AUTHORITY.

## Evidence trace

### Rockwell PointMax safety I/O

Evidence class: DOC-CONFIRMED.

Rockwell documents that safety inputs can be paired with pulse-test outputs for external wiring short-circuit and cross-channel fault detection. The safety input must be configured for Safety Pulse Test and associated with a test source. Critically, Rockwell also documents a blind spot: a short between two input channels assigned to the SAME test output is not detectable by that mechanism. Current wiring guidance therefore says two safety inputs that must detect mutual cross-circuits should use different test-output sources.

Sources:
- https://www.rockwellautomation.com/en-us/docs/technical/i-o/current/5034-pointmax/_online/pointmax-i-o-modules-details-ditamap/safety-input-cip-safety-systems.html
- https://www.rockwellautomation.com/en-tr/docs/technical/i-o/current/5034-pointmax/_online/5034-um002-ditamap/5034-ib8s-ib8sxt-details/safety-application-suitability-levels-input/5034-ib8s-ib8sxt-wiring-diagrams.html

Practical lesson: channel count alone does not establish diagnostic independence. Test-source assignment and physical wiring are part of the safety claim.

### Rockwell two-hand example

Evidence class: DOC-CONFIRMED.

Rockwell's Two Hand Run Station example uses diverse channels and independently pulse-tested inputs for the cited Category 4 example. This is useful curriculum evidence because the safety claim depends on wiring AND I/O configuration, not merely on the application logic seeing four Boolean inputs.

Source:
- https://www.rockwellautomation.com/en-us/docs/studio-5000-logix-designer/37-00/contents-ditamap/instruction-set/safety-instructions/two-hand-run-station--thrs-.html

### SICK Flexi Soft

Evidence class: DOC-CONFIRMED.

SICK explicitly distinguishes inputs protected against short/cross-circuits by installation measures from inputs using test-output referencing. Its manual also warns that a short to High on a single-channel input using test pulses can create an interpreted pulse or delayed falling edge. SICK specifically calls out reset, restart, press restart, muting override and valve-monitor reset inputs as cases requiring particular attention.

Source:
- SICK Flexi Soft modular safety controller hardware operating instructions, 8012478: https://www.sick.com/media/docs/0/60/660/operating_instructions_flexi_soft_modular_safety_controller_hardware_en_im0031660.pdf

Practical lesson: diagnostic pulse behavior can itself interact with edge-sensitive safety functions. A reset input is not just another static Boolean input.

### Pilz PNOZ/test pulses

Evidence class: DOC-CONFIRMED.

Pilz describes test-pulse outputs as a mechanism that, when wired appropriately, permits detection of shorts across contacts. PNOZ e1vp documentation also separates test-pulse cross-contact detection, feedback-loop monitoring of external contactors, redundant/self-monitored relay logic, and periodic safety-output testing.

Sources:
- https://www.pilz.com/en-US/support/lexicon/articles/072903
- https://www.pilz.com/download/open/PNOZ_e1vp_Operat_Man_21236-EN-08.pdf

Practical lesson: input cross-fault diagnostics, internal safety-logic diagnostics, safety-output diagnostics, and final-contactor feedback are different evidence layers.

## Failure-path challenge matrix

| Challenge | False-safe assumption | Required evidence |
|---|---|---|
| Both E-stop channels read healthy | two channels prove independence | pulse-source assignment, wiring topology, device architecture, fault-detection behavior |
| Channels share one pulse source | any channel-to-channel short will be detected | manufacturer-specific detectable-fault table; Rockwell example shows this can be false |
| Reset input uses test pulses | a wiring short can only block reset | manufacturer edge/fault behavior; SICK warns of unexpected/delayed edges |
| Standard FPGA sees channel mismatch | FPGA diagnostic is personnel-safety authority | selected safety architecture must independently own required fault detection/action |
| Safety controller reports input fault | hazard is physically safe | trace fault reaction through safety outputs and final elements |
| Fault clears | machine may resume | fault latch/diagnostic reset, safety reset, rearm and separate start requirements |
| Two conductors routed together | two wires equal independent channels | common-cause/cross-circuit exposure and diagnostic coverage must be evaluated |
| Electronic OSSD device connected | external pulse test should always be enabled | compatibility with device's own OSSD pulses and input filtering must be manufacturer-confirmed |
| EDM healthy | input field wiring is healthy | EDM proves a different layer; do not collapse evidence |
| Input test passes at commissioning | future wiring faults are covered | prove online diagnostic behavior, maintenance inspection and periodic validation requirements |

## OpenPressBrake transfer rules

Evidence class: INFERENCE unless later machine evidence confirms it.

1. Personnel-safety inputs should not be routed through ordinary LinuxCNC/HAL or the normal machine-control FPGA as their sole diagnostic/safety authority.
2. If a safety controller/relay uses test outputs, each safety function must document which field faults are detected, which are NOT detected, and how pulse-source allocation affects that coverage.
3. Reset/restart inputs deserve explicit fault-path analysis because an electrical fault that fabricates an edge can be more dangerous than a simple stuck-low failure.
4. The safety design record should preserve four separate proofs: field-input integrity; safety-logic integrity; safety-output/final-element integrity; physical hazard result.
5. A diagnostic fault must fail toward the defined safe state and must not silently become a permissive ordinary-control state after communications or power recovery.
6. Do not copy manufacturer pulse widths, pulse intervals, discrepancy times, PL/SIL/category claims, or wiring topology into OpenPressBrake until the exact selected safety hardware and application are known.

## Evidence provenance

- SOURCE-CONFIRMED: manufacturer URLs above are public manufacturer documentation/support pages.
- DOC-CONFIRMED: the specific behaviors summarized above are stated by Rockwell, SICK, and Pilz documentation.
- TEST-CONFIRMED: NONE for OpenPressBrake.
- COMMUNITY-REPORTED: NONE used for the frozen rules.
- INFERENCE: OpenPressBrake transfer rules above.
- UNKNOWN: selected OpenPressBrake safety I/O, test-output topology, required performance level/integrity level, exact fault-reaction time, reset wiring, cable routing, final-element behavior and machine validation thresholds.

## Next independent work

Prefer a complete manufacturer/OEM safety-input wiring example where E-stop/guard dual channels, test-pulse allocation, discrepancy/cross-fault diagnostics, safety outputs, EDM/final-element feedback and reset are all visible together. Build a fault-injection table that states exactly which single wiring faults are detected, when they are detected, what output action follows, and what manual recovery is required. If the primary lane reaches that package first, rotate to safety-output pulse/off-test compatibility with contactors/drive STO inputs or to OSSD pulse-filter compatibility rather than duplicate it.
