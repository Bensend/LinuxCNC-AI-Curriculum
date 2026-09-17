# Safety checkpoint — Lane B input test-pulse/cross-fault diagnostics — 2026-09-17

## Parallel-lane check

At selection time primary `main` ended at `0a950c7f`, whose newest work covered presence sensing, reset/restart, stand-behind and trapped-person prevention. Lane B therefore avoided those files/evidence packages and selected the independent safety-input field-wiring diagnostic boundary.

Immediately before the durable artifact write, `main` was re-read and still ended at `0a950c7f`. Immediately after artifact commit `0a8b1f71`, main showed no intervening overlapping commit.

## Durable work

- `safety-course/SAFETY_INPUT_TEST_PULSE_CROSS_FAULT_DIAGNOSTIC_BOUNDARY_STUDY_2026-09-17.md`
- Commit: `0a8b1f71babb7ded4d873b2e271521cfb11acf4a`

## Key frozen distinctions

- `TWO CHANNELS != TWO INDEPENDENT CHANNELS`
- `INPUTS AGREE != FIELD WIRING HEALTHY`
- `TEST PULSE PRESENT != EVERY CROSS-FAULT DETECTABLE`
- `FAULT DIAGNOSTIC != PHYSICAL HAZARD REMOVED`
- `DIAGNOSTIC RESET != SAFETY RESET != ORDINARY START`
- ordinary LinuxCNC/HAL/FPGA observation is not personnel-safety diagnostic authority.

## Evidence classes

- DOC-CONFIRMED: Rockwell safety pulse-test inputs can detect specified shorts/cross-channel faults, but a short between channels sharing the same test source can be undetectable by that mechanism.
- DOC-CONFIRMED: Rockwell two-hand Category-4 example independently pulse-tests the diverse input channels.
- DOC-CONFIRMED: SICK warns that shorts on single-channel test-pulsed reset/restart/press/override/valve-monitor inputs can create interpreted pulses or delayed edges and require particular attention.
- DOC-CONFIRMED: Pilz separates input cross-contact test pulses, internal self-monitoring/output tests and external-contactor feedback.
- TEST-CONFIRMED: NONE for OpenPressBrake.
- COMMUNITY-REPORTED: NONE used.
- INFERENCE: OpenPressBrake safety-input design must explicitly document detectable and non-detectable field faults and keep ordinary FPGA/LinuxCNC out of sole personnel-safety authority.
- UNKNOWN: exact OpenPressBrake safety I/O, test-source mapping, reset topology, cable routing, PL/SIL/category, diagnostic times and validation thresholds.

## Compute

NONE. The question was answered by manufacturer documentation; no simulation/test/synthesis was justified. No GitHub-hosted runner and no self-hosted runner were consumed.

## Precise next work

Find a complete manufacturer/OEM safety-input wiring implementation exposing dual-channel E-stop/guard inputs, test-pulse allocation, discrepancy/cross-fault diagnostics, safety outputs, EDM/final-element feedback and reset together. Produce a single-fault injection table: fault -> detected/not detected -> detection mechanism/time boundary -> safety-output action -> required recovery. If the primary lane takes that package first, rotate to safety-output off-test/pulse compatibility with drive STO/contactors or electronic OSSD pulse-filter compatibility.
