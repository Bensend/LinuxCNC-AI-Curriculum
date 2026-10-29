# 4400-EVAL-INTEGRITY-01 — public 25E0 challenge versus genuinely blind commissioning transfer

**Audit date:** 2026-10-29. **Type:** source-level repository/evaluation-governance audit; not a scored evaluation, physical validation or safety certification.

## Exact question

The safety course has 14 prepared independent 2520–25F0 handoffs and zero new scored attempts. Is each dispatch route capable of evaluating a *novel* commissioning/validation problem without accidentally presenting a previously published learner-readable question as a blind test? If not, what is the smallest correction that preserves historical evidence and avoids creating another unscored question bank?

## Directly inspected evidence and novelty

- [Existing 14-module dispatch map](../evaluation/2500_INDEPENDENT_EVALUATOR_DISPATCH_MAP_2026-10-28.md) correctly warned that 25E0 differed from the other 13 handoffs. This audit is **not** discovery of an unreported risk; its **incremental contribution** is a corrected current evaluator contract, direct historical-file warning and executable dispatch selection route.
- [Original 25E0 public handoff](../evaluation/25E0_EXTERNAL_EVALUATOR_HANDOFF_2026-09-23.md), inspected full Git blob `ff3e93d8c676b2156861727000a83bf56c31b9a6` before the warning edit, includes an explicit fixed `## Challenge` about a guard, E-stop, STO, pneumatic trapped energy and reset, followed by a higher-inertia tooling change. It has no hidden solution key. **SOURCE-CONFIRMED:** question is publicly visible; **UNKNOWN:** whether any specific future learner has seen/rehearsed it. Public exposure *risk* is not proof of contamination for a named learner.
- Directly fetched all 14 evaluator handoffs, original blob prefixes: `2520 09d27aae5c96`, `2530 4f4c1592ba81`, `2540 af137ef0a829`, `2550 459664f7ccad`, `2560 39630c9d5829`, `2570 cff3ebcde1e8`, `2580 9135f916d265`, `2590 01bf32b440f7`, `25A0 2a298d6246c4`, `25B0 72f4dbe6872a`, `25C0 25a0160e26dc`, `25D0 06787cbadc48`, `25E0 ff3e93d8c676`, `25F0 d4d4db5edc7f`. The 13 others are evaluator selection/competency protocols, not this same fixed public question. This inventory is a **repository snapshot**, not an assertion that every contract is psychometrically validated.
- A naive keyword check flagged 25A0 as lacking the literal word `UNKNOWN`; direct reading instead showed explicit rejection of unsupported stopping/pressure/PL/SIL/diagnostic claims. **Corrected interpretation:** no substantive omission established; do not create a redundant 25A0 patch based on a keyword false positive.
- [Global blind protocol](../evaluation/BLIND_FEEDBACK_PROTOCOL.md) requires immutable precommitment, separate evaluator oracle, contamination checks and independent score /10. [Safety sandbox scorecard](../safety-course/SAFETY_SANDBOX_EVALUATOR_RUBRIC_SCORECARD.md) independently defines seven /4 dimensions and automatic safety-fail gates (/28). Mixing the scales or self-scoring public worksheets would invalidate evidence.

## Implemented narrow repair

1. Added [current 25E0 protocol-only information-separated handoff](../evaluation/25E0_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md). It instructs the evaluator to construct a genuinely different machine/change, freeze the hidden oracle separately, demand SRS-derived independent physical witnesses and failure-path coverage, require an immutable response/confidence/falsifiers, and score after commitment.
2. Labeled the original 2026-09-23 25E0 file as **historical public practice / not presumptively blind**, without deleting or rewriting its original scenario.
3. Redirected the [14-handoff dispatch map](../evaluation/2500_INDEPENDENT_EVALUATOR_DISPATCH_MAP_2026-10-28.md) to the new protocol while retaining a direct historical link and explicit contamination warning.
4. Prohibited opportunistic live machine fault injection for paper competency scoring. A hypothetical fault may be evaluated by safe documentary reasoning or disconnected fixtures; physical validation on a real machine is a different qualified commissioning activity.

**Post-edit provenance check:** Re-fetched the historical 25E0 file at commit `78212929aa289d3f501d7ef8396473727c515348` and current main. The old blob is `ff3e93d8c676b2156861727000a83bf56c31b9a6`, new blob `2203ab56d0d07b7dc382e4baa33f60187940e1bb`; removing exactly the 453-character warning reproduces the original **byte-for-byte**. The original public question and evaluator notes were not silently rewritten. This is a SOURCE-CONFIRMED document-preservation check, not an executable safety test.\n\n## Failure-path / adversarial review

| Tempting shortcut | Why it fails | Correct evaluator witness |
|---|---|---|
| Reuse the published 25E0 generic-machine prompt and call it blind | Learner may already have seen it; no exposure/novelty proof | Independently chosen unseen machine/change, exposure check, frozen hidden oracle |
| Treat unchanged safety code and healthy PLC/EDM/STO as physical validation | Logic/configuration/diagnostics do not prove load stopping, guard reach, stored energy or final-element performance | Explicit physical safe-state proposition, independent witness and configuration identity for each SRS function |
| Award a high /28 and silently write it as /10 | Different rubrics and automatic-fail gates; destroys metric meaning | Two separate score records with original dimensions, confidence and critical-fail result |
| Run a fault test on the self-hosted OpenPressBrake panel PC merely to validate the lesson | Runner access and software attestation do not establish physical machine isolation | No execution needed for this documentary evaluator; qualified isolation required before any later justified runtime |
| Publish hidden challenge facts or keys to main for convenience | Contaminates future blind transfer | Evaluator-held sealed oracle until immutable learner commitment |
| Declare 25E0 graduated because the protocol is improved | Preparation is not independent competency evidence | Actual information-separated execution, scoring, correction, novel transfer and retention |

**Evidence classes:** SOURCE-CONFIRMED = file contents, existing 14 handoffs, public fixed challenge and changed dispatch; DOC-CONFIRMED = the repository's blind and safety scoring rules; INFERENCE = a fixed public challenge creates avoidable contamination risk and the revised protocol reduces that *selection* risk; UNKNOWN = independent evaluator identity/availability, learner exposure, hidden oracle and actual score; TEST-CONFIRMED = none. No laboratory, build, workflow or physical test was executed.

## Same-session OpenPressBrake Stage A source-gate recheck (not physical evidence)

Directly re-fetched current `Bensend/OpenPressBrake` main source: `hardware/REV1_MACHINE_CONFIG.yaml` blob `deecc689a7d2b2cdad2061456583601a36b09337`, `docs/REV1_DNC_PVR_ENDPOINT_AUDIT.md` blob `717e7a07ab2d170b7727bb19c06734f5b31f83aa`, `hardware/blocks/safety_interface/manifest.yaml` blob `f5b483ca9b4244192131337f81f7c9ec834925ac`, `hardware/blocks/safety_interface/engineering.yaml` blob `905d19e0cf3e70d08e15ece4a93538bfd52162eb`, and `hardware/blocks/safety_interface/STATUS_CHECKLIST.md` blob `2f12be48e4b82523dbb62f11894283f49b765679`. These files continue to document a **behavioral-only** ordinary DNC/Pilz interface, six controller requests (wires 42–47), seven Pilz status indications (58/59/60/61/76/192/62), 11K2-switched L7/L07, Pilz-origin wire 75 and direct Pilz wire 63, with installed verification outstanding. **SOURCE-CONFIRMED:** published design intent and unresolved checklist. **UNKNOWN:** actual active Pilz program, K1/K2/EDM, machine wiring, Y1/Y2 hydraulic final elements and physical stop/hold, guards and fresh restart. These re-fetched current-main blobs are **not** a newly published revision or qualified as-built witness. This branch remains physically blocked; no live test, source-to-machine equivalence or G0/G1 promotion.

## Unchanged safety release and next evidence

**2520–25F0 independent competency gates remain OPEN/NOT RUN.** The actual OpenPressBrake selected Pilz/AKAS active project, K1/K2/EDM, Y1/Y2 hydraulic stop/hold, guarding, isolation, reset/restart and qualified physical witnesses remain UNKNOWN. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** No personnel-exposed hazardous operation. Next useful evaluator action requires a genuinely independent evaluator; next machine action requires qualified Stage A A–G as-built evidence. Do not expand the short owner request or assign personnel-safety authority to LinuxCNC/FPGA.
