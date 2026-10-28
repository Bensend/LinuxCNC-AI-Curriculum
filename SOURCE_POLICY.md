# Source and Evidence Policy

## Purpose

This project is intended to create source-level knowledge that another AI engineer can trust and independently verify. Fluent prose is not evidence.

## Authority Model

For implementation behavior, prefer the actual LinuxCNC source at the revision being studied. Use official documentation to establish intended/public behavior and terminology. Use official examples/tests as executable evidence. Use developer/integrator discussions and forum posts to discover edge cases, historical context, debugging techniques, and questions that should be verified.

## Claim Classes

Every nontrivial technical conclusion should be distinguishable as one of:

- **SOURCE-CONFIRMED** — directly supported by inspected source at a recorded revision.
- **DOC-CONFIRMED** — explicitly supported by current official documentation.
- **TEST-CONFIRMED** — reproduced in a recorded experiment.
- **COMMUNITY-REPORTED** — reported by a credible community source but not yet independently verified here.
- **INFERENCE** — reasoned from evidence but not directly established.
- **UNKNOWN** — unresolved or conflicting evidence.

Multiple labels may apply.

## Required Provenance

Source findings record repository path, symbol/function, LinuxCNC commit SHA, and useful line/range or nearby symbol. Documentation findings retain page/title and URL. Community findings retain thread/post URL, author when useful, date, and the precise claim being investigated. Experiments retain commands/configuration and resulting artifacts.

## Conflict Rule

Do not silently reconcile conflicts. Record the conflicting evidence, version context, likely explanation if one exists, and an experiment or source-reading task that could resolve it.

## Version Rule

Never generalize behavior found on one revision to all LinuxCNC versions without evidence. Stable and development branches may differ.

## Research Workflow

For each subsystem:

1. Establish vocabulary and intended behavior from official material.
2. Search community material for real failure modes and implementation clues.
3. Inventory relevant source directories/files/symbols.
4. Trace behaviorally significant call chains.
5. Produce the developer guide.
6. Convert important claims into experiments where practical.
7. Run experiments and reconcile results.
8. Create an adversarial comprehension test.
9. Correct the guide from failures before graduation.

## Public Repository Boundary

This repository contains generic/public LinuxCNC research. Do not copy proprietary machine drawings, private OpenPressBrake design material, credentials, private infrastructure details, or other confidential material into this public repository.

## 2026-10-28 — PDF edition/provenance conflict in rendered original-OEM sources

A manufacturer URL and search-result edition string are not a guarantee that every retrieved/rendered PDF page belongs to a single immutable revision. During [SAFE-RESTORE-01 SICK source inspection](research/4400_SAFE_RESTORE_01_SICK_ACR_PILZ_FACTORY_RESET_FORENSIC_AND_POSITION_RETEACH_SOURCE_AUDIT_2026-10-28.md), the original SICK Flexi Soft PDF web-rendered printed page footers displayed **different edition/date strings** (8012478/1T57/2025-07-30 and 8012478/1WLY/2026-05-05). The cause (source assembly, viewer cache or retrieval variation) is **UNKNOWN**. For edition-sensitive safety conclusions, record the exact manufacturer URL, document number, printed page/section, page-image observation, retrieval date, and a byte hash when a stable complete file can actually be retained. Do not silently assign a single edition or claim a firmware/functional delta from inconsistent page metadata. The cited functional sentences may remain **DOC-CONFIRMED at the observed page**, but the whole-document edition is unresolved until checked against one immutable file. This is a provenance method correction, not evidence of an installed-machine fault.

## 2026-10-28 — no-motion G-code documentation requires modal-path countercheck
The [G43.2 axis-word investigation](research/4400_TLO_AXIS_01_LINUXCNC_2910_G432_AXIS_WORD_MODAL_MOTION_DOC_SOURCE_CONFLICT_2026-10-28.md) found a **same-tag DOC/SOURCE discrepancy**: v2.9.10 documentation says G43.2 causes no motion, but the interpreter can inherit modal G0/G1 for G43.2 axis words. A previous [G92 source/documentation conflict](research/4400_G92_PERSIST_01_LINUXCNC_2910_UNSPECIFIED_AXIS_OFFSET_AND_RESTART_SOURCE_AUDIT_2026-10-28.md) likewise shows why prose must not override inspected state updates. For any high-consequence “does not move,” “clears,” “holds,” “resets,” or “cannot restart” claim, trace **parse/enhance → validation → conversion order → Task/motion consumer**, including *inherited versus explicit* modes, state carried from earlier lines and program-end/reset behavior. Record exact tagged source/docs and a counterexample that would falsify the conclusion. A static command path is **SOURCE-CONFIRMED**, not a **TEST-CONFIRMED physical displacement**; freeze a lab only if runtime outcome is genuinely unresolved and consequential, and never test on a personnel-exposed machine. This is a study-method refinement, not a new machine safety authorization.
