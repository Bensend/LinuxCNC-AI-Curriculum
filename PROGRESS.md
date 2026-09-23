# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative. Detailed history remains in Git and referenced research/results/evaluation artifacts.

## Closed prerequisite levels

- **1000 series:** GRADUATED / CLOSED.
- **2000 series:** GRADUATED / CLOSED as of 2026-09-14. F02 GRADUATED.
- **3000 series:** GRADUATED / CLOSED as of 2026-09-15.

Do not routinely reopen closed levels without a genuinely new material defect.

## Active curriculum level

**4000 — hardware and AI-assisted implementation.**

### Primary active priority — safety course / professional machine implementation

Routine controller-board development remains a separate automation concern and must not displace safety work here.

The repeatable safety-design methodology covers:

`machine/lifecycle boundary -> hazardous event -> risk-reduction hierarchy -> physical safe-state proposition -> safety-function/SRS derivation -> composition/allocation -> fault analysis/diagnostic design -> architecture/dependency/CCF allocation -> integrity-method selection/target allocation -> verification/validation/physical proof -> commissioning/release -> maintenance/change control/revalidation`

2520, 2530 and 2540 external information-separated competency execution remain OPEN and branch-local; do not self-score or contaminate them.

**2540 — Relays, contactors, and the real meaning of a “safety relay”** has a coherent learner route in `safety-course/2540_ENTRY_MAP_AND_RELEASE_GATE_2026-09-23.md` and a no-solution external evaluator handoff. It is READY FOR EXTERNAL/FRESH EVALUATION, not self-graduated.

2540 freezes remain: **FORCE-GUIDED CONTACTS != COMPLETE SAFETY FUNCTION**, **CONTACT CARRY CURRENT != SWITCHING SUITABILITY**, **FINAL-ELEMENT COMMAND != FINAL-ELEMENT STATE**, **FINAL-ELEMENT STATE != HAZARDOUS-ENERGY STATE**, **MIRROR/EDM FEEDBACK != SHAFT STANDSTILL OR COMPLETE ENERGY REMOVAL**, **STO ACTIVE != ELECTRICAL ISOLATION, STANDSTILL, OR GRAVITY-LOAD RESTRAINT**, **VALVE POSITION FEEDBACK != DOWNSTREAM SAFE PRESSURE**, **OUTPUT CURRENT RATING != PERMISSION TO SWITCH AN ARBITRARY LOAD**, and **COMPONENT PL/SIL/PFH != COMPLETE SAFETY-FUNCTION PL/SIL/PFH**.

**2550 — ISO 13849 without the mystique** is the active branch. Source framing is `safety-course/2550_ISO_13849_WITHOUT_MYSTIQUE_SOURCE_PREP_2026-09-23.md`. `safety-course/2550_EXAMPLE_ARCHITECTURES_AND_ASSUMPTION_TRAPS_2026-09-23.md` now independently varies topology/Category evidence, MTTFd evidence, diagnostic evidence and CCF/dependency evidence without inventing machine values. It includes nominal upstream redundancy defeated by a common final element, two-channel architecture undermined by a common-cause dependency, a stale use-profile/SISTEMA trap, B10d/nop symbolic sensitivity, and certified-subsystem decomposition boundaries.

`2550_ADVERSARIAL_ASSESSMENT_INTEGRITY_VS_REAL_MACHINE_2026-09-23.md` now tests a mixed electromechanical/safety-controller/STO/contactor/pneumatic machine function. It requires the learner to repair the SRS, decompose SRP/CS, audit stale calculation assumptions, identify CCF and final-element dependencies, separate diagnostic propositions from physical safe-state proof, preserve LinuxCNC's non-safety authority boundary, and refuse unsupported personnel-exposed operation.

2550 freezes now include: **ARCHITECTURE DOES NOT CREATE PLr**, **CATEGORY 4 != PL e BY DEFINITION**, **DC CLAIM != PHYSICAL SAFE-STATE PROOF**, **SISTEMA PASS != MACHINE VALIDATION PASS**, **CHANNEL COUNT != CCF CONTROL**, **NUMERICALLY CORRECT MODEL + FALSE APPLICATION ASSUMPTION = UNDEFENSIBLE SAFETY CLAIM**, and **CERTIFIED SUBSYSTEM CAPABILITY != COMPLETE SAFETY-FUNCTION ACHIEVED INTEGRITY**.

Core 2520/2530 freezes remain in force, especially: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **CATEGORY / ARCHITECTURE != ACHIEVED PL OR SIL**, **CERTIFIED COMPONENT CAPABILITY != COMPLETE SAFETY-FUNCTION INTEGRITY**, **DIAGNOSTIC COVERAGE CLAIM != PHYSICAL SAFE-STATE PROOF**, **DEVICE RELEASED != SAFETY FUNCTION RESET/REARMED != MACHINE START AUTHORIZED**, and **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Preserve the 2520, 2530 and 2540 information-separated competency gates; do not contaminate them with learner-readable hidden solutions.
2. Audit 2550 coverage against the governing syllabus: PLr, Categories B/1/2/3/4, MTTFd, DCavg, CCF, subsystem decomposition, B10d/cycle reasoning, and the limits of calculation versus validation.
3. If the coverage is coherent, create a concise 2550 learner entry map/release gate and a no-solution information-separated evaluator handoff rather than manufacturing duplicate ISO 13849 notes.
4. If the audit exposes a real gap, fill only that gap from authoritative evidence first.
5. After 2550 reaches external-evaluation readiness, recover the next named safety-course module from the syllabus and begin its authoritative source preparation.
6. Keep ordinary LinuxCNC/FPGA control, safety-related control, diagnostics/monitoring and physical energy-removal mechanisms explicitly separated.

Newest precise checkpoint: `checkpoints/2026-09-23T0448Z-safety-2550-audit-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
