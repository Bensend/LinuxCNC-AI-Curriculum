# Maintenance Emergency Safety Substitution Decision Tree

## Purpose

Use this decision tree when a safety-relevant component has failed and the approved ready spare is unavailable. The objective is to make the controlled path faster and clearer than an improvised bypass while preserving the distinction between maintenance energy control, component equivalence, and physical validation of the restored safety function.

This artifact complements `SAFETY_REPLACEMENT_PART_EQUIVALENCE_SUBSTITUTION_WORKSHEET.md`, `SAFETY_SPARE_PARTS_OBSOLESCENCE_LIFECYCLE_WORKSHEET.md`, `SAFETY_SPARE_READINESS_EVIDENCE_CARD.md`, and `SAFETY_SPARE_INVENTORY_RECONCILIATION_QUARANTINE_AUDIT.md`.

Evidence labels: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, `UNKNOWN`.

## Frozen rule

**Production urgency does not change the safety function's required behavior. If the approved spare is unavailable, the default is controlled out-of-service state until an exact/manufacturer-approved replacement or documented engineered-equivalence path is established and the affected physical safety function is revalidated. Bypassing a personnel-safety function is not an emergency substitution.**

A safety-relevant `UNKNOWN` that could defeat the function blocks a claim of equivalence or return to normal production.

## Authoritative maintenance boundary

OSHA 29 CFR 1910.147 covers servicing/maintenance where unexpected energization, startup, or release of stored energy could injure workers. It requires hazardous stored/residual energy to be relieved, disconnected, restrained, or otherwise rendered safe and requires verification of isolation before work. OSHA also states that control circuitry such as pushbuttons, selector switches, and interlocked gates is not an energy-isolating device.

Source: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147
Classification: `SOURCE-CONFIRMED`.

OSHA enforcement guidance specifically distinguishes replacement of machine/process components such as valves, gauges, linkages, and support structure from routine production-mode maintenance and states that such replacement requires energy isolation. It also calls for safeguards to be replaced before release from lockout/tagout.

Source: https://www.osha.gov/enforcement/directives/std-01-05-019
Classification: `SOURCE-CONFIRMED`.

OSHA's 2024 interpretation of temporary re-energization for testing/positioning limits that exception to the time needed for testing/repositioning and requires de-energization and renewed energy-control measures when energized testing is no longer required.

Source: https://www.osha.gov/laws-regs/standardinterpretations/2024-10-21
Classification: `SOURCE-CONFIRMED`.

These sources establish maintenance energy-control boundaries; they do **not** prove that any proposed replacement is safety-equivalent or establish machine-specific hydraulic, electrical, mechanical, stopping, or safe-motion behavior.

## Decision tree

```text
SAFETY-RELEVANT COMPONENT FAILED / APPROVED READY SPARE UNAVAILABLE
|
+-- 1. Is the affected personnel-safety function still required for any intended operation?
|      |
|      +-- YES --> Place/keep machine OUT OF SERVICE for that operation.
|      |           Control hazardous energy for maintenance.
|      |           Do not bridge, force, jumper, mask, or downgrade the safety function.
|      |
|      +-- NO / maintenance-only state --> Define the physically controlled maintenance state.
|                  Isolation/blocking/restraint must match the actual hazards.
|                  Tag/status communicates the state; it does not replace physical control.
|
+-- 2. Can the exact approved MPN/revision/configuration be obtained?
|      |
|      +-- YES --> Verify provenance/condition/configuration dependencies.
|      |           Install under energy control.
|      |           Move to INSTALLED-PENDING-VALIDATION, not directly to validated service.
|      |
|      +-- NO --> Continue.
|
+-- 3. Does the manufacturer identify a specific approved/direct successor for this use?
|      |
|      +-- YES --> Preserve manufacturer's exact terminology and conditions.
|      |           Run change-impact/equivalence review for wiring, configuration,
|      |           diagnostics, mechanics, final-element behavior and affected safety functions.
|      |
|      +-- NO / only 'functional replacement' / UNKNOWN --> Continue.
|
+-- 4. Is there enough authoritative evidence for an engineered-equivalence review?
|      |
|      +-- YES --> Use SAFETY_REPLACEMENT_PART_EQUIVALENCE_SUBSTITUTION_WORKSHEET.md.
|      |           Every safety-relevant dependency must be confirmed or bounded.
|      |           UNKNOWN capable of defeating function = NOT APPROVED.
|      |
|      +-- NO --> Keep machine OUT OF SERVICE; escalate/procure/repair through controlled path.
|
+-- 5. After approved replacement/substitution is installed:
|      |
|      +-- Verify exact installed identity/configuration/wiring/mechanical installation.
|      +-- Remove temporary maintenance/test devices and restore safeguards.
|      +-- Re-challenge the affected physical safety function and relevant fault paths.
|      +-- Verify reset/restart/rearm behavior and independent final-element evidence as applicable.
|      +-- Record unresolved UNKNOWNs and evidence provenance.
|      +-- Only then consider IN-SERVICE-VALIDATED within the proven scope.
|
+-- 6. If any required evidence or physical challenge fails:
       |
       +-- Return/remain OUT OF SERVICE or controlled maintenance state.
       +-- Do not convert a failed validation into an operator warning or software inhibit.
```

## Hard-stop branches

The following are **not** acceptable substitutes for the decision tree:

- jumpering a failed guard/interlock/light-curtain channel so production can continue;
- suppressing discrepancy/EDM feedback to accept a different contactor or final element;
- forcing a safety input/output in ordinary LinuxCNC, HAL, FPGA, PLC/HMI diagnostics, or service software and treating the force as restored physical protection;
- replacing a monitored valve with a merely similar valve while its safety-related spool/feedback/fail-state behavior is `UNKNOWN`;
- using matching voltage, current, pinout, connector, footprint, thread, flow rating, or physical dimensions as the sole equivalence basis;
- changing reset from monitored/manual to automatic merely to accommodate a substitute;
- treating STO or a normal software disable as maintenance electrical isolation;
- leaving a safeguard unavailable while relying on a sign, HMI message, training reminder, or production procedure as the sole replacement;
- returning to production because the machine 'seems to work' after the replacement without re-challenging the affected safety function.

## Temporary safe-state branch

Sometimes the correct emergency response is not immediate repair but a stable maintenance state until the correct component arrives.

Record:

| Question | Evidence / answer |
|---|---|
| What hazardous energy sources exist? | |
| Which sources are isolated? | |
| What stored/residual energy is relieved, disconnected, restrained, blocked, or otherwise controlled? | |
| Could energy reaccumulate? How is that controlled/verified? | |
| What mechanical/gravity hazards require blocking/restraint? | |
| What remains energized and why? | |
| Are guards/safety devices removed or defeated for maintenance? | |
| How is OUT OF SERVICE / DO NOT OPERATE state made unmistakable? | |
| Who controls the maintenance energy-isolation state? | |
| What exact condition permits transition to installation/testing? | |

Do not infer a machine-specific safe hydraulic state, pressure threshold, blocking method, or gravity restraint without machine evidence and physical assessment.

## Energized testing / positioning branch

If a replacement cannot be verified without temporary energization, treat that as a bounded maintenance transition rather than normal operation:

1. define the question that requires energization;
2. clear personnel/tools as required and restore only what is necessary for the test;
3. energize only for the bounded testing/positioning step under the applicable controlled procedure;
4. collect the observation needed to answer the question;
5. de-energize and reapply energy-control measures before continuing maintenance;
6. never use temporary test energization as permission for production with an incomplete safety function.

OSHA 1910.147(f)(1) is the source-confirmed basis for the deenergize/remove controls/energize-test/deenergize-reapply-controls sequence where testing or positioning requires energization. Exact site procedures remain site-specific.

## Equivalence evidence gate

Before approving a non-exact substitute, answer at minimum:

| Dependency | Required evidence | Status |
|---|---|---|
| Manufacturer identity / lifecycle classification | current manufacturer documentation | |
| Intended safety-function suitability | manufacturer/engineering documentation | |
| Contact/output architecture | datasheet/manual + circuit comparison | |
| EDM/feedback behavior | documentation + physical validation where applicable | |
| Reset/restart semantics | documentation + validation | |
| OSSD/test-pulse/input compatibility | documentation + wiring/config review | |
| Electrical ratings and fault behavior | documentation + engineering review | |
| Firmware/configuration/toolchain identity | controlled records | |
| Safety-network/device identity | controlled records + commissioning evidence | |
| Mechanical mounting/actuation/alignment | drawing/manual + physical inspection/test | |
| Hydraulic/pneumatic function if applicable | exact manufacturer/machine evidence; otherwise `UNKNOWN` | |
| Final-element fail/de-energized state | exact evidence + physical challenge as applicable | |
| Environmental/application limits | manufacturer documentation | |
| Affected safety-function validation | physical test record | |

Use `SAFETY_REPLACEMENT_PART_EQUIVALENCE_SUBSTITUTION_WORKSHEET.md` for the full review. This table is only the emergency gate.

## Failure-path challenges

Before closing an emergency replacement, challenge these scenarios:

1. Exact catalog number found from unknown/cannibalized provenance.
2. Manufacturer calls successor 'functional replacement', but maintenance assumes 'drop-in'.
3. Replacement safety relay fits socket but has different reset/monitoring behavior.
4. Contactor coil and poles match but positively guided/feedback architecture does not.
5. Safety I/O module matches hardware but firmware/device identity/configuration does not.
6. Light curtain powers up but resolution/range/muting/restart configuration is different.
7. Drive replacement runs normally but safe-motion/STO parameters were not restored and validated.
8. Hydraulic valve physically fits but monitored spool/fail-state behavior is undocumented.
9. Temporary jumper used during troubleshooting remains installed after replacement.
10. Ordinary LinuxCNC/FPGA/HMI inhibit is used to compensate for unavailable independent safety hardware.
11. Correct replacement is installed but guard alignment, wiring, EDM, or final-element response changed during repair.
12. Pressure to resume production causes an unresolved `UNKNOWN` to be relabeled 'acceptable'.

Any applicable unresolved case remains visible in the closeout.

## Human-factors / escalation rule

Emergency procedures should make the safe branch easy:

- one known place to find approved spare/equivalence records;
- clear quarantine and approved-stock labeling;
- a short escalation path to engineering/maintenance authority;
- an obvious OUT OF SERVICE state that survives shift changes;
- pre-reviewed manufacturer successors where practical;
- ready access to controlled configuration/backup packages;
- validation instructions tied to the affected safety function rather than tribal knowledge.

A long, ambiguous approval path while a bypass takes thirty seconds is a foreseeable human-factors defect. Improve the approved path rather than normalizing the bypass.

## LinuxCNC / FPGA boundary

Ordinary LinuxCNC/HAL/FPGA/HMI may display the failed component, block normal machine enable, preserve diagnostic evidence, and guide maintenance to the approved replacement record. It must not gain personnel-safety authority merely because the independent component is unavailable. A software inhibit can be useful defense-in-depth, but it does not make a defeated guard, missing safety relay, unproven valve, or bypassed final element acceptable for production.

## Emergency substitution record

| Field | Record |
|---|---|
| Failed component / safety role | |
| Failure evidence | |
| Machine state after failure | |
| Hazardous-energy control reference | |
| Approved spare unavailable evidence | |
| Exact replacement search result | |
| Manufacturer successor classification | |
| Proposed substitute identity | |
| Equivalence worksheet reference | |
| Safety-relevant UNKNOWNs | |
| Installation/change-impact record | |
| Physical validation record | |
| Reset/restart/rearm validation | |
| Final disposition | OUT OF SERVICE / APPROVED INSTALLATION / INSTALLED-PENDING-VALIDATION / IN-SERVICE-VALIDATED |
| Reviewer/date | |

## Next-work checkpoint

Build a **safety maintenance handoff / shift-change continuity worksheet** for incomplete repairs and emergency substitutions. It should preserve hazardous-energy control, machine OUT-OF-SERVICE state, removed guards, temporary jumpers/test fixtures, installed-but-unvalidated parts, unresolved `UNKNOWN`s, exact next validation step, and responsibility transfer across technicians/shifts. Keep the handoff record separate from physical energy isolation and never allow a verbal handoff or CMMS status to substitute for locks, blocking, restraint, or other required physical hazard control.