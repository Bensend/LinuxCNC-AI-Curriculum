# Safety Curriculum Lane B Checkpoint — Safety Input Test-Pulse Boundary

UTC checkpoint: 2026-09-19T18:50:00Z

## Parallel-lane selection

Before selection, current main was re-read. The primary safety lane had just committed `safety-course/SERIES_GUARD_DIAGNOSTIC_ARCHITECTURE_COMPARISON_2026-09-19.md`, overlapping Lane B's preceding series-guard fault-masking subject. Lane B therefore switched modules rather than extending or overwriting that work.

Primary `PROGRESS.md` remains focused on press-brake hydraulic holding/safety-valve service, individual retention proof, physical ram/load witness, and stopping-performance revalidation. Lane B did not modify those files or claims.

## Completed

Added `safety-course/SAFETY_INPUT_TEST_PULSE_CROSS_SHORT_DIAGNOSTIC_BOUNDARY_STUDY_2026-09-19.md`.

The study establishes from current Rockwell and Pilz manufacturer documentation that safety-input test pulses are an active field-wiring diagnostic whose coverage depends on the approved topology and test-source assignment. Rockwell explicitly documents that a cross-short between two safety inputs fed from the same test-output point is not detectable by that arrangement.

Durable freeze:

**INPUT LOGIC HIGH != FIELD CIRCUIT HEALTHY.**

**TWO INPUTS AGREE != CROSS-SHORT EXCLUDED.**

**TEST PULSE PRESENT != CORRECT TEST SOURCE ASSIGNED != EXPECTED PULSE OBSERVED AT EACH INPUT != FIELD WIRING FAULT-FREE.**

**FIELD WIRING DIAGNOSTIC PASS != SENSOR MECHANICALLY CORRECT != SAFETY LOGIC VALID != FINAL ELEMENT SAFE != PHYSICAL HAZARD CEASED != RESTART AUTHORITY.**

Evidence labels are preserved as SOURCE-CONFIRMED, DOC-CONFIRMED, TEST-CONFIRMED, COMMUNITY-REPORTED, INFERENCE, and UNKNOWN. No machine-specific OpenPressBrake safety-input topology, pulse timing, PL/SIL/category/DC/CCF, sensor compatibility, final-element response, or stopping performance was invented.

No executable verification was justified; no runner compute was used.

## Exact next Lane-B work

Seek a professional commissioning artifact tracing:

`dual-channel protective device -> distinct pulse sources -> normal demand -> short-to-24-V fault -> cross-channel short -> module Fault/Uncertain -> safety evaluator inhibition -> actual final element -> physical hazardous-state witness -> correction -> reset/rearm -> fresh ordinary START`.

Prefer evidence showing the diagnostic consequence of shared/misassigned test sources. If no complete public artifact exists, preserve the final-element portion as UNKNOWN and rotate to another independent safety evidence gap rather than manufacturing a synthetic machine result.