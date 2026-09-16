# 4000 Safety Lane B Checkpoint — 2026-09-16

Status: ACTIVE

## Durable state

Independent lane added `safety-course/SAFETY_EVIDENCE_ACCEPTANCE_REJECTION_GATE_MATRIX.md` at commit `f89ec0f07722c3d31ab4acdb8dfd4d7a814e10f6`.

The matrix turns the existing evidence chain-of-custody discipline into claim-relative gates: `REJECT`, `REVIEW`, and `ACCEPT-AS-BOUNDED`. There is intentionally no unqualified ACCEPT state. It separates command, logic, final-element, physical-hazard and personnel/space evidence; grades independence, raw retention, configuration binding, transformations, freshness/order, actual test challenge, recovery and bypass/restoration state; and forbids converting test count into diagnostic coverage or safety performance.

## Parallel-work reconciliation

Immediately before selection, current `main` showed the primary safety lane at commit `871635ebf89ed682f963f8f99e5d2b28eedda3dd`, after `safety-course/POST_MAINTENANCE_RESTORATION_VALIDATION.md`. Its exact next work is a cross-machine configuration/change invalidation worksheet spanning press brake, mill, lathe, plasma, robot and automated cell.

Lane B therefore did not create or modify that worksheet, the primary checkpoint, the post-maintenance module, or machine-family change matrices. Lane B stayed on evidence adjudication infrastructure and used a new independent file.

Before committing the artifact, `main` was re-read and remained at the same primary-lane head; no overlapping file had changed. The Lane-B checkpoint was re-fetched after the artifact commit before this update.

## Evidence frozen

- `event_logged` is not `physical_event_proven`.
- `configuration_identity_matches` is not `physical_installation_validated`.
- `command_removed` is not `final_element_safe` and not `hazard_absent`.
- A rejected artifact may still be accepted for a narrower claim that its observer actually supports.
- Rockwell GuardLogix documentation: changed safety-signature elements require revalidation; safety-I/O configuration signatures identify configuration and are considered verified only after user testing.
- OSHA machine-guarding guidance: return to service after servicing includes guards/safety devices being in place and functional and checking the area before startup.
- Ordinary LinuxCNC/HAL/FPGA evidence remains useful for normal-control containment and diagnostics but does not become personnel-safety authority.

Evidence classes remain `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, and `UNKNOWN`.

No compute was consumed; no executable verification question survived source/engineering reasoning.

## Precise next independent work

Build an **evidence-conflict adjudication worksheet** for cases where two apparently valid artifacts disagree, without duplicating the primary lane's configuration/change invalidation matrix.

Priority cases:
1. command/logic says OFF while independent final-element feedback says ON;
2. final-element feedback says safe while physical motion/energy observation disagrees;
3. two independent sensors disagree or one becomes stale;
4. HMI/log ordering conflicts with monotonic/raw acquisition ordering;
5. matching configuration signature conflicts with documented physical wiring/guard change;
6. current test conflicts with an older validated baseline;
7. one artifact is transformed/cropped while another retains raw context.

The worksheet must default to preserving the conflict, bounding conclusions, and inhibiting unsupported promotion rather than selecting the more convenient artifact. It should define when to mark the claim `UNKNOWN`, when a fault itself is established, what independent retest would resolve the conflict, and how to retain both artifacts in chain of custody.

If the primary lane occupies evidence-conflict adjudication before the next Lane-B run, switch to an independent source trace on diagnostic independence/common-cause evidence rather than editing overlapping files.