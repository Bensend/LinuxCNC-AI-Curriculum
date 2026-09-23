# 25C0 — Coverage audit and canonical learner route

## Syllabus audit

Compared with `SAFETY_COURSE_RESEARCH.md` 25C0 requirements:

| Required topic/output | Durable coverage | Status |
|---|---|---|
| bypass incentives | `25C0_HUMAN_FACTORS_ENTRY_2026-09-23.md` defeat-pressure model | COVERED |
| nuisance trips | entry model + machine-playbook checklist adversarial case | COVERED |
| poor diagnostics | checklist + generic-safety-fault adversarial case | COVERED |
| maintenance access | entry model/checklist; restoration usability | COVERED |
| guard removal/reinstallation effort | checklist; hinged/captive/keyed patterns | COVERED |
| reset placement | `25C0_RESET_RESTART_SETUP_EVIDENCE_2026-09-23.md` | COVERED |
| visibility | entry/checklist + reset/restart evidence | COVERED |
| setup and recovery modes | reset/restart/setup evidence + checklist | COVERED |
| fragility of procedure-only controls | entry model + adversarial cases | COVERED |
| safer defaults without unusable machine | anti-defeat sequence + low-cost patterns | COVERED |
| machine-playbook human-factors checklist | `25C0_MACHINE_PLAYBOOK_CHECKLIST_AND_ADVERSARIALS_2026-09-23.md` | COVERED |

No material learner-facing syllabus gap remains. Machine-specific stopping times, speeds, pressure limits, integrity targets and physical truth tables remain deliberately UNKNOWN until supported by the relevant machine evidence.

## Canonical learner route

A fresh learner should use this order:

1. `research/25C0_HUMAN_FACTORS_ENTRY_2026-09-23.md` — learn defeat pressure, lifecycle friction, and why defeat resistance and defeat incentive are separate design dimensions.
2. `research/25C0_RESET_RESTART_SETUP_EVIDENCE_2026-09-23.md` — separate reset, restart, occupancy knowledge, setup-mode selection, enabling, restricted performance, and maintenance isolation.
3. `research/25C0_MACHINE_PLAYBOOK_CHECKLIST_AND_ADVERSARIALS_2026-09-23.md` — apply the method across production, setup, recovery, cleaning, inspection, maintenance, diagnostics and nuisance-trip response.
4. Apply the checklist to a novel machine scenario without consulting evaluator material. Preserve UNKNOWN physical parameters instead of inventing them.

## Competency release gate

A learner is ready for fresh evaluation when it can:

- identify the legitimate task and incentive behind a foreseeable bypass rather than blaming the operator;
- propose a lower-friction engineering response before merely escalating anti-tamper hardware;
- distinguish safeguard reset from motion-start authorization;
- recognize that guard closed / field clear does not necessarily establish protected-space occupancy state;
- design bounded setup/recovery reasoning without promoting ordinary LinuxCNC/HMI/FPGA logic to personnel-safety authority;
- keep maintenance energy isolation/restraint distinct from production safeguarding;
- diagnose nuisance trips without weakening timing/thresholds absent revalidation;
- use diagnostics to shorten recovery without granting diagnostic software safety authority;
- state when machine-specific facts are UNKNOWN and require measurement/design evidence.

## Release decision

25C0 is **READY FOR EXTERNAL/FRESH EVALUATION**, not self-graduated. External information-separated execution is branch-local and must not be contaminated by learner-readable expected answers.

No executable compute is justified by the remaining question. Do not run simulation merely to produce activity.