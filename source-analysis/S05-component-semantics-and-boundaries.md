# S05 — component semantics, observability, and boundary analysis

- LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
- Module: S05

## Official documentation context

Current LinuxCNC HAL documentation describes realtime signal-processing components as components that must be loaded and explicitly added to threads; the order is configuration, not an implicit dependency scheduler.

References:

- HAL Component Generator: https://www.linuxcnc.org/docs/html/hal/comp.html
- HAL Component List: https://linuxcnc.org/docs/html/hal/components.html

This supports the S05 requirement to make acquisition/comparison/persistence/response `addf` order explicit.

## Community lead retained for failure reasoning

A 2022 LinuxCNC forum thread on DC servo runaway described a field case where an encoder feedback malfunction could leave only a small apparent position error initially, allowing ordinary following-error logic to miss the problem until the actuator moved. This is retained only as COMMUNITY-REPORTED motivation for independent diagnostic reasoning, not proof of any S05 architecture.

Reference: https://forum.linuxcnc.org/24-hal-components/46092-hal-component-for-dc-motor-runaway-protection

## Pinned source findings

### `wcomp.comp`

Source: https://github.com/LinuxCNC/linuxcnc/blob/8bf4605ae81042248add031e94c77300406e0413/src/hal/components/wcomp.comp

The implementation reads one real input and computes `under = in <= min`, `over = in >= max`, and `out = !(under || over)`. Thus `out` is strict interior only. For symmetric valid bounds, `under OR over` gives a clean raw disagreement predicate whose exact threshold belongs to the fault side.

### `maj3.comp`

Source: https://github.com/LinuxCNC/linuxcnc/blob/8bf4605ae81042248add031e94c77300406e0413/src/hal/components/maj3.comp

The implementation counts true inputs and emits normal `out = sum >= 2` (or the inverse when `invert` is set). There is no intrinsic dissent identity, quality, age, sequence, or provenance state.

### `timedelay.comp`

Source: https://github.com/LinuxCNC/linuxcnc/blob/8bf4605ae81042248add031e94c77300406e0413/src/hal/components/timedelay.comp

When input differs from output, the internal timer accumulates `fperiod` and the `elapsed` pin is updated. Once the appropriate delay is met, output changes and the internal timer is reset. When input already equals output, the internal timer is reset to zero, but the source does **not** call `elapsed_set(0)` in that branch.

Engineering consequence: `timedelay.elapsed` can retain a previously published nonzero value after the internal timer has reset. Therefore S05 uses the boolean `out` as the acceptance oracle for qualified fault/recovery state; `elapsed` is diagnostic instrumentation, not an authoritative current-timer-zero predicate.

This subtle observability distinction is SOURCE-CONFIRMED at the pinned revision and should be preserved for 2000-level investigation if version comparisons or UI interpretation become important.

## Chosen 1000-level numeric architecture

Use signed `sum2(A-B)` → `wcomp(-T,+T)` → `or2(under,over)` → `timedelay`.

Reasons:

1. exact threshold behavior is explicit;
2. `under` versus `over` preserves which direction the disagreement lies;
3. no extra absolute-value transform is needed;
4. the production persistence component is tested directly;
5. the design makes the distinction between raw threshold state and qualified/persisted state visible.

This architecture is a diagnostic pattern only. Its correctness still depends on chosen tolerance, sampling alignment, scaling, sensor validity, and stated independence/common-cause assumptions.
