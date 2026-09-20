# Safety curriculum primary checkpoint — component replacement revalidation

Date: 2026-09-20
Primary durable work: `safety-course/SINAMICS_COMPONENT_REPLACEMENT_REVALIDATION_SCOPE_AND_PHYSICAL_WITNESS_MATRIX_2026-09-20.md`

## Parallel-work disposition

Read the latest Lane-B modification-impact/revalidation checkpoint before writing. This primary-lane work complements it with concrete Siemens replacement procedures rather than duplicating Lane B's generic impact-analysis rules.

## Durable result

Siemens replacement procedures establish that post-change acceptance scope is dependency-specific. Relevant replacement can require affected-drive function testing before danger-zone reentry/resumed operation, bidirectional physical movement to prove actual-value/direction sensing, safety motion monitoring during that movement, or deliberate short-circuit/wire-break challenge for a replaced safety option. Configuration identity/checksums and acceptance records remain tied to the tested state but do not replace physical witness.

Freeze:

- **COMPONENT REPLACED != SAFE STATE PROVED != DANGER-ZONE REENTRY AUTHORIZED != OPERATION RESUMED.**
- **CONFIGURATION RESTORED != ACTUAL-VALUE SENSING CORRECT != DIRECTION MAPPING PHYSICALLY PROVED != SAFETY MOTION MONITORING REVALIDATED.**
- **NORMAL FUNCTION PASSED != REQUIRED WIRING/FAULT DIAGNOSTICS REVALIDATED.**
- **REDUCED DRIVE ACCEPTANCE COMPLETE != EVERY MACHINE SAFEGUARD/HYDRAULIC/MECHANICAL HAZARD PATH REQUALIFIED.**

No OpenPressBrake-specific PL/SIL, speed, stop time/distance, hydraulic threshold, diagnostic coverage or proof-test interval was inferred.

No executable verification was justified. No GitHub-hosted runner was used.

## Exact next primary work

Seek one authoritative machine/OEM post-maintenance or post-repair procedure that adds a downstream physical-performance and safeguard layer to this chain:

`named change -> impact scope -> affected function/final-element tests -> representative fault challenge where applicable -> quantitative physical machine performance where affected -> safeguard requalification/repositioning if required -> explicit production release`

Prefer a press/press-brake or another high-energy machine. Generic drive component-replacement searching is now information-gain limited. If Lane B lands the same machine/OEM package first, rotate to a distinct open safety branch before writing.
