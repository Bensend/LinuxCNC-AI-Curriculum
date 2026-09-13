# 3600 — Quantitative angle interface producer search / information-gain stop — 2026-09-13

## Scope

Continuation of the pinned comparative source trace in `machinepilot/FANUC_dev` at `23392889558240370cc0755ce5be4c72b181387f`.

The prior pass established interface declarations for phase-specific realtime angle values and separate dynamic BDC corrections for Y1/Y2. This pass tested the highest-value next question: does the public repository expose actual producers/consumers or the correction kernel behind those declarations?

## Repository search result

Targeted code searches for the interface identifiers and semantic phrase `Dynamic Correction BDC Y1` returned:

- `LDJ/Kvara/PLC/Ioleng.inc` and its DiscoC copy;
- `LDJ/reference/LDJ_REF_PLC_Signals.txt`;
- duplicated copies under `TeachPendant/.../integration_notes/raw_docs`;
- unrelated substring collisions such as material-table `C9` text.

The useful declaration remains:

- C7: realtime angle value from sensor during descent;
- C8: dynamic BDC correction Y1 for angle measurement;
- C9: dynamic BDC correction Y2 for angle measurement;
- C11/C12/C13: additional realtime angle channels distinguished by phase/path.

No search result exposed executable logic that calculates C8/C9 from the angle channels, applies those corrections to Y1/Y2 targets, timestamps/generates measurements, limits correction magnitude/rate, or handles sensor failure/recovery.

## Comparative external reconciliation

Fresh public documentation/research reinforces that quantitative angle systems may affect more than one correction surface, but it does not fill the missing implementation kernel. A public Accurpress angle-measurement patent states that measured bend-angle/deflection information may be used to adjust crowning or Y1/Y2. Lazer Safe IRIS Plus documentation separately describes final-angle measurement during decompression and an end-view angle-difference quantity that can reveal Y1/Y2 imbalance/crowning and be delivered to the CNC. These are useful architecture comparators, not evidence for the pinned repository's implementation and not LinuxCNC behavior.

## Evidence classification

- **SOURCE-CONFIRMED (comparative artifact):** named interface channels distinguish phase-specific quantitative angle observations and independent Y1/Y2 dynamic BDC correction values.
- **SOURCE-CONFIRMED negative search result:** targeted default-branch search exposed declarations/reference copies, not the producer/calculation/application implementation.
- **DOC-CONFIRMED (external comparator):** commercial/patent material supports the general separation of angle observation, final-angle/phase semantics, Y1/Y2 imbalance and correction surfaces.
- **UNKNOWN:** measurement freshness/generation, filtering, correction formula, correction sign, insertion point, saturation/rate limiting, interaction with tandem synchronization/crowning, sensor disagreement, failure/recovery, and functional-safety behavior.

## Function / call-flow boundary

The strongest defensible call-flow remains an interface contract, not an implementation trace:

`phase-qualified angle acquisition (producer unavailable) -> exposed angle channel(s) -> target/recalculation logic (unavailable) -> C8/C9 dynamic Y1/Y2 corrections -> correction application (unavailable) -> physical beam-control path (unavailable)`

Do not collapse these stages into a single 'angle PID'. In particular, the existence of C8/C9 does not prove where or how they are inserted into the beam controller.

## Adversarial boundary test — 7/7 PASS

1. Can we derive the C8/C9 formula? **No.**
2. Can we claim the angle values are fresh merely because they are called realtime? **No; no timestamp/generation contract was found.**
3. Can we claim C8/C9 are directly summed into Y1/Y2 position commands? **No.**
4. Can we infer correction limits or safe saturation behavior? **No.**
5. Can we infer tandem synchronization interaction? **No.**
6. Can we treat the public artifact as verified vendor/deployed behavior or LinuxCNC behavior? **No.**
7. Would a toy synthetic angle loop verify any of those missing implementation facts? **No.**

## Information-gain decision

This source branch has reached a bounded information-gain stop on the public/default-branch material currently exposed. Repeating identifier searches or constructing a synthetic correction loop would manufacture implementation assumptions rather than verify them.

Reopen only if new inspectable material exposes at least one of: angle-channel producer with freshness semantics, C8/C9 calculation, correction insertion/limiting, Y1/Y2 interaction, sensor-error recovery, or tandem coordination.

PB-PREP-001 remains **INCONCLUSIVE / NO ARCHITECTURE RECOMMENDATION**.
