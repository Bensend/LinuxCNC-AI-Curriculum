# Active Curriculum Session State

Session start UTC: `2026-09-12T16:10:24Z`
Session end UTC: `2026-09-12T16:11:43Z`
Actual elapsed: **1.3 minutes**
Status: **CLOSED — F02 external gate preserved; 3600 tandem field topology and custom-firmware/amp authority layering advanced.**

## Critical path

`handoffs/F02-fresh-ai-compound-fault-transfer.md` remains **PREPARED / UNSCORED**. Repository issue search found no correctly routed information-separated F02 evaluator response. F02 remains the sole known 2000-series graduation gate and was not self-scored.

## Work completed

New durable artifacts:

- `research/3600-pwmgen-firmware-amp-enable-layering-2026-09-12.md`
- `research/3600-tandem-y1-y2-field-architecture-update-2026-09-12.md`
- `checkpoints/3600-tandem-field-topology-next-2026-09-12.md`

Continuing through the later Ursviken/Pullmax retrofit chronology produced genuinely new field evidence. In February 2026 the builder reported initial closed-loop left/right ram synchronization using per-side cascaded position/velocity control, though with hydraulic groaning and tuning uncertainty. By July 2026 the builder reported an actual 90-degree steel bend and disclosed the higher-level final topology: two position PIDs, one per side, plus a synchronization PID with command 0 and feedback from Y1−Y2; the synchronization correction was described as slowing whichever side is ahead. This is now classified **COMMUNITY-REPORTED FIELD SUCCESS WITH DISCLOSED HIGH-LEVEL TOPOLOGY**, not source-confirmed final implementation.

The same chronology also exposed a useful electrical authority boundary. PCW reported that this machine's custom firmware used PWMGEN 0 to enable all 7i54 PWMgens, while stock LinuxCNC `pwmgen.c` at `f325d51f52da7d5e0e227ac35e3672ee6f873b4f` creates per-instance HAL enable pins and constructs the enable register as a per-instance bitmask. The reconciliation is that custom FPGA physical routing can couple outputs differently from generic HostMot2 software semantics. The builder separately planned a discrete R-axis Cybelec amplifier enable while leaving shared PWM availability tied to machine-on.

The ordinary-control authority chain is therefore explicitly layered: HAL command/enable → HostMot2 registers → FPGA firmware routing → physical output stage → external amplifier readiness → mechanical brake state → actuator motion/feedback. No earlier layer proves a later one.

Adversarial checks passed 5/5 for the enable-layering trace and 6/6 for the tandem topology boundary. No new synthetic lab was launched because prose-only field disclosures cannot establish the missing final realtime wiring or physical authority semantics. Laboratory compute is unchanged.

## Next checkpoint

1. Re-check F02 first and preserve evaluator identity/header plus the full response before changing F02 status.
2. Correctly routed F02 PASS/no corrections closes F02 and the 2000 series; do not self-certify it.
3. If F02 remains blocked, the tandem branch should reopen only if the promised final config or equivalent inspectable HAL/component source appears.
4. Required missing tandem details remain exact correction insertion/sign, realtime ordering, output/saturation limits, process-state gating, feedback freshness/disagreement, fault ownership and recovery.
5. Preserve custom-firmware authority layering; never infer physical output independence from stock HostMot2 per-instance enables when custom firmware is used.
6. PB-PREP-001 remains **INCONCLUSIVE / NO ARCHITECTURE RECOMMENDATION**.

Overlap: **No overlap.** Previous completed canonical lesson ended `2026-09-12T15:17:51Z`; this session began `2026-09-12T16:10:24Z`, **52m33s later**.

Short-session continuation check: rather than stopping after the initial source-gated recheck, the session continued through the remaining public retrofit thread pages and found materially new July 2026 field topology evidence. Further work is now gated by the promised but not-yet-inspectable final configuration rather than lack of another synthetic experiment.
