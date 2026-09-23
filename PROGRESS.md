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

Fresh-AI navigation is durable in `safety-course/2520_ENTRY_MAP_AND_FRESH_AI_HANDOFF_2026-09-22.md`; concise course navigation is `safety-course/SAFETY_COURSE_INDEX.md`. 2520 external information-separated competency execution remains OPEN and branch-local; do not self-score or contaminate it.

**2530 — E-stop systems from first principles** has a coherent learner-facing route in `safety-course/2530_ENTRY_MAP_AND_RELEASE_GATE_2026-09-22.md`. `evaluation/2530_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md` provides a no-solution evaluator protocol. External/fresh execution remains OPEN and branch-local; 2530 is not self-graduated.

**2540 — Relays, contactors, and the real meaning of a “safety relay”** is the active source branch. Initial source framing is `safety-course/2540_SAFETY_RELAY_MEANING_SOURCE_PREP_2026-09-23.md`.

The required five-family commercial comparison is now durable in `safety-course/2540_FIVE_FAMILY_SAFETY_RELAY_COMPARISON_AND_PHYSICS_BRIDGE_2026-09-23.md`, covering Pilz PNOZ X3, Allen-Bradley Guardmaster SI 440R-S12R2, Phoenix Contact PSRclassic 2963912, Omron G9SE-201, and ABB Sentry SSR10. Missing fields remain explicitly `UNKNOWN`; published component capability is not transferred to a complete machine safety function.

2540 now also has the relay/contactor physics bridge: force-guided contacts are a diagnosability mechanism rather than immunity from failure; carry-current ratings are separated from switching/utilization ratings; AC/DC and resistive/inductive interruption are separated; suppression is treated as part of release-time/lifetime validation; B10d/use profile remains an input to reliability reasoning; and EDM is bounded to the particular feedback proposition it observes.

2540 freezes include: **FORCE-GUIDED CONTACTS != COMPLETE SAFETY FUNCTION**, **FORCE-GUIDED CONTACTS ENABLE COVERED DIAGNOSTICS; THEY DO NOT MAKE A RELAY INFALLIBLE**, **B10d DATA PRESENT != ACHIEVED PL/SIL**, **CONTACT CARRY CURRENT != SWITCHING SUITABILITY**, **RESISTIVE RATING != INDUCTIVE AC/DC INTERRUPTION RATING**, **ARC SUPPRESSION MAY CHANGE RELEASE BEHAVIOR; IT BELONGS IN VALIDATION**, **EDM AUXILIARY STATE != HAZARDOUS ENERGY REMOVED**, **RELAY RESPONSE TIME != MACHINE STOPPING TIME**, **SAFETY RELAY MODULE PRESENT != FINAL-ELEMENT PHYSICAL STATE PROVED**, and **COMPONENT PL/SIL/PFH != COMPLETE SAFETY-FUNCTION PL/SIL/PFH**.

Core 2520/2530 freezes remain in force, especially: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **CATEGORY / ARCHITECTURE != ACHIEVED PL OR SIL**, **CERTIFIED COMPONENT CAPABILITY != COMPLETE SAFETY-FUNCTION INTEGRITY**, **DIAGNOSTIC COVERAGE CLAIM != PHYSICAL SAFE-STATE PROOF**, **DEVICE RELEASED != SAFETY FUNCTION RESET/REARMED != MACHINE START AUTHORIZED**, and **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Preserve the 2520 and 2530 information-separated competency gates; do not contaminate them with learner-readable hidden solutions.
2. Continue 2540 at the machine final-element boundary: compare a contactor path, drive STO path, and fluid-power valve path without pretending they are interchangeable.
3. Derive when a safety relay may directly switch a documented load versus when it is only safety logic feeding a separately engineered final element. Include utilization category, DC/AC interruption, suppression, duty/use profile, feedback/EDM and physical proof.
4. Trace adversarial welded-main-contact, misleading/stale auxiliary-contact, common-power/common-actuator and maintenance/replacement cases. Map each to the proposition actually observed and to the 2520 validation matrix.
5. Build the 2540 learner-facing route only after the final-element lesson closes the current evidence gap; do not infer universal Category/PL/SIL or stopping performance from example topology.
6. Keep ordinary LinuxCNC/FPGA control, safety-related control, diagnostics/monitoring and physical energy-removal mechanisms explicitly separated.

Newest precise checkpoint: `checkpoints/2026-09-23T0152Z-safety-2540-final-elements-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
