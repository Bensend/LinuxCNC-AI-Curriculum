# 2560 — Entry map and release gate

## Canonical learner route

1. `2560_IEC_62061_SIL_CONCEPTS_SOURCE_PREP_2026-09-23.md`
   - current IEC 62061:2021 orientation;
   - SIL/PFHd meaning;
   - HFT/SFF/diagnostic architectural constraints;
   - random versus systematic integrity;
   - subsystem composition and PL/SIL method boundary.
2. `2560_DUAL_METHOD_PL_SIL_COMPARISON_2026-09-23.md`
   - one symbolic guarded-motion function analyzed through both ISO 13849-style and IEC 62061-style reasoning;
   - shared versus method-specific evidence;
   - invalid direct conversions;
   - attractive arithmetic defeated by architecture/application evidence;
   - qualitative correction before low-value numerical optimization.
3. `2560_ADVERSARIAL_ASSESSMENT_SIL_WITHOUT_LABEL_TRANSFER_2026-09-23.md`
   - novel mixed evidence scenario requiring method separation, unknown preservation, physical-proof reasoning and LinuxCNC authority-boundary reasoning.

## Syllabus coverage audit

The governing safety-course syllabus requires:

- SIL as a risk-reduction/probability framework — covered in source prep.
- PFHd and high-demand machinery operation — covered in source prep and adversarial assessment.
- subsystems, architecture, diagnostics and systematic capability — covered in source prep and dual-method exercise.
- relationship/differences between machinery SIL and PL methods — directly covered by the dual-method exercise.
- when math is useful versus when qualitative fault analysis already exposes the higher-value correction — directly covered by Cases A/B and the assessment.
- output comparing one example with both PL-style and SIL-style reasoning without pretending formal certification — completed by the symbolic guarded-motion comparison.

No material syllabus gap was found after the dual-method exercise.

## Release boundary

2560 learner-facing methodology is **READY FOR EXTERNAL/FRESH EVALUATION**. This is not self-graduation and is not evidence that any real machine safety function has achieved a SIL or PL.

The external evaluator must use an information-separated scenario not disclosed in these learner artifacts. It should require the learner to distinguish shared physical evidence from method-specific evidence and to reject at least one plausible but invalid integrity shortcut.

## Durable freezes

- SIL TARGET != COMPONENT SIL LABEL.
- PFHd IN RANGE != COMPLETE SAFETY FUNCTION VALIDATED.
- SMALL PFHd NUMBER != PERMISSION TO IGNORE ARCHITECTURAL CONSTRAINTS.
- RANDOM-HARDWARE CALCULATION != SYSTEMATIC-CORRECTNESS EVIDENCE.
- METHOD CHOICE DOES NOT REMOVE THE NEED TO PROVE THE PHYSICAL SAFETY FUNCTION.
- CORRECT ARITHMETIC OVER AN INCOMPLETE ARCHITECTURE IS STILL THE WRONG MODEL.
- FIX AN OBVIOUS SINGLE-POINT/COMMON-CAUSE WEAKNESS BEFORE OPTIMIZING THE RELIABILITY MODEL AROUND IT.
- A VALID METHOD CANNOT RESCUE INVALID INPUT PROVENANCE.
- ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY.

## Next branch

Create the information-separated 2560 evaluator handoff without a hidden solution, then advance to 2570 — drives, STO, braking and hazardous motion — because the evaluator gate is branch-local.
