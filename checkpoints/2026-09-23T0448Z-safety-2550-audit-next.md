# Safety curriculum checkpoint — 2550 coverage audit next

## Durable state

- 1000/2000/3000 remain GRADUATED/CLOSED; 4000 safety remains primary.
- 2520, 2530 and 2540 information-separated external evaluation gates remain OPEN and uncontaminated.
- 2550 source framing now has concrete architecture/assumption exercises and a mixed-technology adversarial assessment.

## New 2550 evidence

`safety-course/2550_EXAMPLE_ARCHITECTURES_AND_ASSUMPTION_TRAPS_2026-09-23.md` demonstrates independent evidence dimensions rather than treating PL as a property of a drawing. It includes:

- same topology with changed reliability evidence;
- same reliability with changed diagnostic evidence;
- nominal upstream redundancy defeated by one common final element;
- two-channel architecture with unanalyzed CCF dependency;
- stale use-profile evidence invalidating an otherwise plausible numerical model;
- B10d/nop symbolic sensitivity with sourced equations;
- certified-subsystem versus complete-function boundary.

`safety-course/2550_ADVERSARIAL_ASSESSMENT_INTEGRITY_VS_REAL_MACHINE_2026-09-23.md` tests those ideas in a guarded machining cell containing electromechanical guard input, safety controller, STO drive, contactor, pneumatic tooling and LinuxCNC diagnostics.

## Exact next work

1. Audit 2550 against the governing syllabus/module plan, especially whether Categories B/1/2/3/4 are taught sufficiently without collapsing them into PL labels.
2. Check whether PLr, MTTFd, DCavg, CCF, B10d/use profile, subsystem decomposition, systematic correctness and validation limits all have a clear learner-owned artifact.
3. Fill only genuine missing concepts from authoritative evidence.
4. If coherent, create `2550_ENTRY_MAP_AND_RELEASE_GATE...` and a no-solution `evaluation/2550_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md`.
5. Then move to the next named safety-course module rather than producing duplicate ISO 13849 notes.

## Compute

No executable compute was justified or consumed. The work was source/provenance/architecture reasoning. No GitHub-hosted runner was used. Any later justified compute must target only `[self-hosted, openpressbrake]`.
