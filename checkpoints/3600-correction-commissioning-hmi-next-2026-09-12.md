# 3600 Press Brake checkpoint — correction, commissioning, and HMI evidence

Date: 2026-09-12

## Critical path

- F02 remains **PREPARED / UNSCORED** at `handoffs/F02-fresh-ai-compound-fault-transfer.md` and is still the sole 2000-series graduation gate.
- Do not self-score it. Consume only a genuinely information-separated evaluator response.

## Work closed this session

1. `research/press-brake-public-run-ui-state-source-audit-2026-09-12.md`
   - bounded public Run-UI search closed;
   - a real Accurpress field implementation had manual, semi-auto-repeat, and G-code-auto modes;
   - its intended bend-sequence/wizard workflow was never finished;
   - exact GUI row/state source was unavailable in this bounded pass, so row-persistence/advance/restart code remains SOURCE UNAVAILABLE.

2. `research/press-brake-calibration-correction-ownership-2026-09-12.md`
   - separated machine calibration, nominal product calculation, empirical correction, effective TargetSet, runtime ExecutionEpisode, and LinuxCNC machine compensation;
   - pinned source confirms ordinary screw/backlash/motor-offset handling and the homed extra-joint `posthome-cmd + motor_offset` boundary.

3. `research/press-brake-first-piece-correction-acceptance-workflow-2026-09-12.md`
   - reconciled Cybelec/Delem first-piece correction workflows;
   - trial bend -> measure -> correct -> repeat same bend -> accept/advance;
   - accepted correction always creates a new TargetSet generation/fresh episode.

4. `research/press-brake-correction-diagnosis-matrix-2026-09-12.md`
   - classified constant-offset, proportional/scale, direction/backlash, nonlinear-map, product/process, material/springback, and Y1/Y2 differential signatures;
   - prevents treating one bad part as proof of machine calibration error.

5. `research/press-brake-correction-scope-review-policy-2026-09-12.md`
   - bend-specific is the conservative default;
   - program-wide and reusable material/tool-class promotion require progressively stronger evidence and provenance;
   - systematic machine-coordinate evidence routes to calibration review instead of propagating product offsets.

6. `research/press-brake-commissioning-recovery-checklist-2026-09-12.md`
   - generic commissioning/recovery evidence checklist for reference, scale, backlash, extra-joint authority, tandem truth, following behavior, correction routing, process witnesses, diagnostics, and recovery;
   - retains machine-specific hydraulics/pressure/safety numbers as machine/physical evidence gaps.

7. `research/press-brake-hmi-state-provenance-contract-2026-09-12.md`
   - separates LinuxCNC controller state, press-program state, target provenance, runtime episode/authorization, physical diagnostics, and external safety-chain observation;
   - stale values remain visible only with explicit stale/invalid reason; selected row never implies active motion authority.

## Experiment decision

No new laboratory experiment was justified this session. The active questions were source/documentation/community/data-ownership questions, and executable synthetic fixtures would mostly restate already established contracts. Future experiments become high-information when executable press-brake HMI/correction code exists or a new LinuxCNC-specific ambiguity appears.

## Exact next work

1. Re-check `handoffs/F02-fresh-ai-compound-fault-transfer.md` first. If an externally separated PASS exists, preserve it, graduate F02, and close 2000.
2. If F02 is still externally blocked, do **not** continue iterating correction/ownership abstractions. The correction/commissioning/HMI generic pass is now sufficiently documented.
3. Resume 3600 from genuinely new real-machine evidence. Highest-value candidates:
   - a newly available public tandem Y1/Y2 final configuration or executable hydraulic/decompression decoder;
   - press-specific pressure/tonnage/crowning field source that exposes ownership without encouraging copied numeric limits;
   - executable press-brake HMI/correction source suitable for direct stale-generation/abort/reconciliation testing.
4. Preserve PB-PREP-001 as INCONCLUSIVE; do not retune its frozen discriminator or run additional architectures merely to seek a preferred result.
5. Continue to treat machine numeric limits, hydraulic truth tables, safeguarding, and stopping performance as machine-specific/physical evidence, not gaps to fill with generic simulation.
