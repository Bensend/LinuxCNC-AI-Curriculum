# 2550 — learner entry map and release gate

## Purpose

Give a fresh learner one non-duplicative route through ISO 13849 reasoning without turning SISTEMA, Category, or a PL letter into a substitute for engineering.

## Canonical route

1. `2550_ISO_13849_WITHOUT_MYSTIQUE_SOURCE_PREP_2026-09-23.md`
   - PLr versus achieved PL
   - Category, MTTFd, DC/DCavg and CCF as distinct evidence dimensions
   - calculation versus validation boundary
2. `2550_CATEGORY_B_TO_4_COVERAGE_AUDIT_AND_GAP_FILL_2026-09-23.md`
   - explicit B/1/2/3/4 fault-behavior distinctions
   - Category 2 test-path trap
   - Category 3 accumulated-fault/dependency reasoning
   - Category 4 is not automatically PL e
3. `2550_EXAMPLE_ARCHITECTURES_AND_ASSUMPTION_TRAPS_2026-09-23.md`
   - independently vary topology, reliability, diagnostics and CCF
   - B10d/nop use-profile sensitivity
   - common-final-element and stale-model traps
4. `2550_ADVERSARIAL_ASSESSMENT_INTEGRITY_VS_REAL_MACHINE_2026-09-23.md`
   - mixed electromechanical/STO/contactor/pneumatic transfer
   - SRS repair, subsystem decomposition, physical-proof boundary and LinuxCNC authority boundary

## Required learner capability

A learner ready for external evaluation must be able to:

- derive/recognize PLr as a safety-function requirement rather than an architectural property;
- explain Categories B, 1, 2, 3 and 4 in terms of fault behavior rather than memorized PL letters;
- keep MTTFd, DCavg and CCF conceptually separate;
- identify when B10d/use-profile evidence has gone stale;
- decompose a complete safety function into defensible subsystems without losing common dependencies;
- reject a nominally redundant architecture defeated by a common final element or CCF;
- explain why a plausible SISTEMA result can still be invalid;
- distinguish calculation evidence, diagnostic evidence and physical machine validation;
- keep ordinary LinuxCNC/FPGA monitoring outside personnel-safety authority unless independently justified.

## Release gate

Learner-readable methodology status: **READY FOR EXTERNAL/FRESH EVALUATION**.

This is not graduation. External information-separated competency evidence remains required. Do not self-score the learner against a hidden answer and do not publish a solution key into learner-readable course material.

## Critical fail conditions for the external gate

Treat any of these as a material miss:

- assigning PLr from channel count or Category;
- claiming Category 4 automatically means PL e;
- treating a Category-2 test channel as an independent redundant safety-function path without evidence;
- ignoring a common final element/CCF that defeats nominal redundancy;
- accepting B10d/MTTFd numbers without validating the applicable use profile;
- treating diagnostic coverage as proof of the physical safe state;
- treating SISTEMA/model success as machine validation;
- inventing machine-specific PL, stopping time, diagnostic coverage, reliability or physical behavior;
- moving personnel-safety authority into ordinary LinuxCNC or the normal FPGA merely for convenience.

## Next branch

Create the no-solution information-separated evaluator handoff, then move to 2560 IEC 62061/SIL source preparation. 2520–2540 external gates remain branch-local and uncontaminated.
