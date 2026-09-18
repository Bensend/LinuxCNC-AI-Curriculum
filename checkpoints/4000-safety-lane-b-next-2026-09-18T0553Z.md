# 4000 safety Lane-B checkpoint — 2026-09-18T05:53Z

## Parallel-state check

Before selection, `main` ended at primary checkpoint `465fe293` (`checkpoint: press final-element authority composition`). Its active work is the press hydraulic/final-element authority branch: same-machine Y1/Y2 discrepancy -> safety latch -> reset -> monitored hydraulic re-enable -> pressure/load witness.

Lane B did not modify or duplicate that evidence package. Immediately after the substantive Lane-B commit, current main was re-read and showed `79eb5636` directly above `465fe293`; no intervening primary or overlapping file change appeared.

## Durable result

Added `safety-course/SAFETY_OUTPUT_SHORT_TO_24V_REVERSE_CURRENT_DIAGNOSTIC_BOUNDARY_2026-09-18.md` in commit `79eb5636`.

Manufacturer evidence from SICK Flexi Soft freezes a narrower electrical safety-output issue than the prior generic 24-V supply/backfeed study:

- short-to-24-V behavior is an output diagnostic concern;
- single-channel semiconductor outputs may lack another means to switch off the device;
- disabling output test pulses changes short-to-24-V diagnostic assumptions;
- SICK explicitly warns reverse currents can impair other safety outputs' ability to switch off under an internal hardware error;
- pulse-free safety outputs carry a manufacturer periodic diagnostic requirement.

Freeze:

**SAFETY LOGIC COMMAND OFF != OUTPUT TERMINAL PROVEN LOW != LOAD PROVEN DE-ENERGIZED.**

**OUTPUT TEST PULSES DISABLED != DIAGNOSTIC BEHAVIOR UNCHANGED.**

**ONE OUTPUT CAN SWITCH OFF != A DIFFERENT OUTPUT CANNOT ELECTRICALLY INTERFERE WITH THAT SHUTDOWN.**

Evidence provenance remains separated as SOURCE-CONFIRMED / DOC-CONFIRMED / TEST-CONFIRMED / COMMUNITY-REPORTED / INFERENCE / UNKNOWN.

## OpenPressBrake boundary

No selected safety controller, output technology, pulse timing, wiring topology, reverse-current path, proof-test interval, PL/SIL/category/DC, stopping behavior, hydraulic truth table or physical response was invented. These remain UNKNOWN until actual device/design/measurement evidence exists.

No simulation/build/synthesis/benchmark/test compute was justified. No GitHub-hosted runner was used. Future executable verification, if a concrete question justifies it, is self-hosted `[self-hosted, openpressbrake]` only.

## Precise next independent work

Find an authoritative worked implementation/manual set exposing:

**safety semiconductor output -> diagnostic pulse configuration -> short-to-24-V/reverse-current fault -> second shutdown path or protected wiring -> final element -> feedback/EDM -> restart inhibition/proof test.**

Prefer a worked wiring example rather than another generic feature page. If the primary safety lane reaches this exact package first, rotate to gravity-axis mechanical brake/load-retention sequencing or safety-network communication-loss/reintegration authority rather than overlap.
