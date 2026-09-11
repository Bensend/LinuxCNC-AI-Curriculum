# PB-PREP-001 — 077 independent raw-evidence audit freeze

Status: **FROZEN WHILE 077 IS STILL EXECUTING; BEFORE ANY 077 BEHAVIORAL RESULT WAS OBSERVED**

UTC freeze session: 2026-09-11T03:39:09Z session.

Candidate workflow: `34557828294`, job `103134175120`, source commit `8d01d2dab5823ed0fcf43ef944b98f266343cb8a`.

Executed behavioral script is digest-bound by `lab-jobs/077-pb-prep-001-execute-retained-render.sh` to the retained 076 render SHA-256 `7c185fb0af4b056d7e9406de164a79ae6eb30d06510a6b3ce77ed12d46c4a0e6`.

This audit does **not** change any controller gain, plant parameter, disturbance, P2-P7 timing, metric threshold, Gate A-J requirement, or outcome rule. It exists because the generated analyzer is evidence-producing code, not an independent scorer. The authoritative verdict must be obtained from raw retained traces plus provenance, not accepted merely because `analysis.txt` says PASS.

## Required validity checks before any behavioral interpretation

For each architecture A/B/C independently:

1. Source/binary provenance resolves to LinuxCNC `8bf4605ae81042248add031e94c77300406e0413`.
2. Retained fixture topology shows separate `y1fb` and `y2fb` signals, each produced by the corresponding synthetic plant state and each feeding the corresponding motion joint `motor-pos-fb`; neither may be tied to the other or replaced by Cartesian Y.
3. Servo-thread topology is identical across architectures except the frozen architecture selector and has, in order, motion command handling/control, `pb-prep.0.prepare`, both stock PID calculations, `pb-prep.0.finish`, then `sampler.0`.
4. Every raw realtime file contains exactly 12,000 rows; each row has stream tag plus 21 configured sampler elements; deterministic payload `cycle` increments by exactly one between every adjacent row; producer overrun counters are 0 before and after.
5. First active P2 sample begins from equal clean plant state within `1e-9`, phase ordering is P2→P3→P4→P5→P6→P7, and a sampled P7 true→false run transition exists.
6. Decode `disturbance_word` and `ferror_limit_word` directly from raw rows; verify frozen B-side `(gain,alpha)` schedule P2 `(1,.05)`, P3 `(.75,.05)`, P4 `(1,.025)`, P5 `(1,.05)`, P6/P7 `(.20,.05)` and positive retained effective ferror limits.
7. Recompute every final-side clamp and final-saturation bit from retained `prelimitN`, `finalN`, `state_word`, and `U_MAX=2.0`; mismatch is HARNESS INVALID.

## Independent Gate A-J scoring rules

### Gate A — provenance

PASS only if the pinned LinuxCNC SHA, fixture HAL/INI/component source, architecture identity, frozen constants, and final limits are retained. The digest-bound 076 render is part of provenance but does not substitute for runtime binary provenance.

### Gate B — independent side truth

PASS only if topology plus raw rows prove two distinct signals/states: sampled `y1fb` drives joint 1 feedback and sampled `y2fb` drives joint 3 feedback. Equal numeric values during symmetric operation are not evidence of aliasing; topology is the aliasing discriminator.

### Gate C — common nominal request

Across all active P2-P6 raw rows, independently compute `max(abs(r1-r2)) <= 1e-9`. P2 must span at least 0.10 command units. Do not infer equality from the G-code command alone.

### Gate D — recorder integrity

Use producer overrun counters plus deterministic payload-cycle continuity. Stream tag continuity is supplemental only, consistent with X01.

### Gate E — disturbance isolation

Use the single retained rendered source plus per-row packed disturbance witness. Confirm A-side plant code/constants and controller/limit constants are invariant in source; confirm only the declared B-side gain/alpha values change by phase in raw data. The architecture selector is the only A/B/C structural selector.

### Gate F — saturation observability

For A/B, recompute stock-PID saturation from decoded stock saturation bits separately from final saturation. For all architectures, prove pre-limit effort, final effort, and final-saturation state are retained. Do not treat stock PID saturation as a final-actuator witness.

### Gate G — motion-ferror observability

Raw rows must contain both Y-joint ferrors and same-row effective limits. Independently calculate minimum limit margin for each side from raw data.

### Gate H — architecture-specific discriminator

**A:** select at least one row in P3/P4/P6 with `abs(corr_applied) > 1e-6`. Verify from raw fields that `ref1 = r1 - corr_applied` and `ref2 = r2 + corr_applied` within `2e-6`. Report the same-row nominal motion ferrors `r1-y1` and `r2-y2` and retained joint ferrors. Explicitly state whether the reference bias reduces side-to-side error while consuming nominal motion-ferror margin; do not award PASS from a nonzero correction alone.

**B:** in P6 require at least one row where one final-saturation bit is true while the corresponding stock PID saturation bit is false. If none exists, the entire valid fixture result is **INCONCLUSIVE** under the already frozen rule. Do not strengthen P6 or change thresholds.

**C:** select at least one P3/P4/P6 row with nonzero requested differential correction. From same-row `r1/r2/y1/y2`, recompute common P effort `6 * (((r1-y1)+(r2-y2))/2)` and verify retained `prelimit1/2` equal common effort minus/plus applied differential correction within a numeric tolerance justified from printed precision. Verify final saturation from the same row.

### Gate I — recovery/disable

Recompute P5 recovery using the frozen requirement: continuously for 100 samples, `abs(e_diff)<=0.005` and `abs(e_common)<=0.01`; report `NOT OBSERVED` if absent. For P7 identify the first sampled true→false run transition and require both final commands exactly zero within `1e-12` and both final saturation flags clear on that first disabled cycle.

### Gate J — bounded conclusion

Any final result must remain software-fixture-only and must not recommend real hydraulic tuning, valve current, cylinder speed, tonnage, stopping distance, or functional-safety suitability.

## Adversarial cross-checks

Before accepting `VALID COMPARISON`, independently answer from raw evidence:

- Can final saturation be true with stock PID saturation false, and exactly which B/P6 row proves it?
- Does A's correction enter before the PID reference while motion retains the unmodified nominal duplicated-Y target?
- Can `e_diff` be small while common tracking remains wrong, and are both quantities independently derivable from raw rows?
- Are P6 motion-disable/ferror events reported only when observed rather than inferred from saturation?
- Is the plant update understood as sequential next-state evolution rather than a same-row algebraic equation between command and feedback?

## Classification discipline

Only these outcomes are permitted under the frozen contract: `VALID COMPARISON`, `PARTIAL VALID`, `INCONCLUSIVE`, `HARNESS INVALID`, or `BEHAVIORAL FAILURE`.

If 077 fails a construction/provenance/recorder predicate, take **no architecture verdict**. If the fixture is valid but B/P6 lacks downstream-only saturation, classify **INCONCLUSIVE**. No post-result retuning is permitted under PB-PREP-001.
