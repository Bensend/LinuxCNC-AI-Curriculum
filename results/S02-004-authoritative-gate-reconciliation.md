# S02-004 — authoritative observability gate reconciliation

Date: 2026-09-09
Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`
Workflow: `34395556653`
Job: `102614270967`
Artifact: `10121464851`
Source commit: `1a916e7ea4fb567d9606e6d46767031ca09163ad`
Exact job runtime: 2026-09-09T19:31:25Z–2026-09-09T19:34:37Z = **3.2 min**
Frozen gate source: `guides/S02-feedback-integrity-common-cause-research.md`

## Evidence integrity

The artifact was downloaded and unpacked independently of workflow status. It contains the authoritative evidence package under `run-34395556653-1/s02-024-authoritative-evidence/`, including:

- 89,890-byte `atomic.samples`;
- `analysis.txt`;
- `predeclared-model.txt`;
- test-only `s02_model.comp` and generated `s02.hal`;
- pinned LinuxCNC SHA;
- topology/thread-order records;
- producer recorder-health record;
- HAL/realtime setup logs;
- empty `halsampler.stderr`.

Fresh offline parsing found exactly **1,400** samples with tags **0..1399 contiguous** and `sampler-overruns=0`.

Retained phase counts: P0=181, P1=200, P2=200, P3=200, P4=200, P5=419. Transport health is true in every retained phase row.

## Frozen Gates A–J

| Gate | Result | Authoritative retained evidence |
|---|---|---|
| A | PASS | One sampler record contains phase, synthetic physical A/B, reported A/B, transport, quadrature diagnostic, pair-disagreement, oracle-stale, freshness-unknown, restricted-detector and common-mode oracle fields; recorder health is retained separately. |
| B | PASS | P0 has zero pair-disagreement, stale, restricted-detector, common-mode and quadrature assertions. |
| C | PASS | P1 pair disagreement is true at phase-relative sample 0, within the frozen `<=1` servo-cycle bound, while transport remains healthy. |
| D | PASS | P2 synthetic physical B moves 2.000..2.398 while reported B remains exactly 2.000 and transport stays healthy; oracle-stale first asserts at phase-relative sample 26, within the frozen `<=30` bound. |
| E | PASS | All 200 P3 rows explicitly assert `freshness_unknown`; stationary equal values are not declared fresh/healthy from value-only evidence. |
| F | PASS | In all 200 P4 rows reported A == reported B exactly while each differs from synthetic physical truth by 0.5 and transport remains healthy; pair-disagreement and the detector restricted to reported A/B + transport remain false. |
| G | PASS | P5 quadrature diagnostic is asserted independently while pair-disagreement/restricted detector are false; analysis explicitly limits it to a modeled diagnostic rather than physical-truth/independence proof. |
| H | PASS | Retained analysis states synthetic `physical_*` / oracle values are laboratory-only truth signals, not LinuxCNC production validity signals. |
| I | PASS | Tags are exactly contiguous 0..1399, producer overruns are zero, and userspace sampler stderr is empty; exact phase transitions and declared latency bounds are therefore scoreable from the retained stream. |
| J | PASS | The frozen/retained analysis makes no functional-safety, real-machine independence, or universal-version claim. Conclusions are bounded to the synthetic experiment and pinned source context. |

**Authoritative gate score: 10/10 PASS.**

## TEST-CONFIRMED S02 conclusions

1. Pairwise disagreement is detectable in the modeled differential-fault class without requiring a transport fault.
2. A current/healthy transport transaction can coexist with a stale reported channel relative to an independent laboratory oracle.
3. At stationarity, unchanged/equal reported values plus healthy transport are insufficient to establish sensor freshness; the defensible classification is `UNKNOWN` absent an independent freshness witness.
4. A detector restricted to two agreeing reports plus transport health cannot guarantee detection of a common-mode physical error that is observationally identical at those inputs.
5. A limited diagnostic can be independently useful without becoming a universal channel-validity, independence, coupling, or physical-truth oracle.

## Safety/evidence boundary

The synthetic physical oracle exists solely to make observability limits testable. S02 does **not** establish actual machine sensor diversity, mechanical coupling, stopping performance, diagnostic coverage factor, or functional-safety integrity. Those require architecture-specific and, for physical claims, appropriate independent/physical evidence.

The frozen adversarial exam was committed before authoritative-result review in `evaluation/S02-2000-adversarial-exam-frozen.md`. Proceed to its immutable learner answer next.
