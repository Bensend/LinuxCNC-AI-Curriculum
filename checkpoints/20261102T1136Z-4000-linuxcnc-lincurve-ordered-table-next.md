# 2026-11-02 ~11:36Z — LINC-159 continuation checkpoint

**Active 4000 LinuxCNC-first, NON-GRADUATED.** START_HERE, master mission, level order, work selection, curriculum, source policy, module template, progress, blind protocol/score, compute ledger, previous LIMIT3-158 checkpoint and lesson history inspected. Full PROGRESS predecessor scan found no `lincurve` work; existing HAL/LIMIT3/PID/CAM/QtPlasmaC topics remain distinct. No new external blind score or lab runtime.

## New source result

[LINC-159 pinned source audit](../research/4400_LINUXCNC_LINCURVE_159_UNSORTED_BREAKPOINT_HISTORY_DEPENDENCE_SOURCE_AUDIT_2026-11-02.md) compares LinuxCNC stable v2.9.10 `86cdca76fa2a36274c432caa21952b23c267989a` blob `2c6306828aba70f557461ed422d68abffddec041` and development `06864e23559e70463fc7112d5ce77138bcbc288c` blob `46ce4a46c2e61f1db0d8072adc81e263a11b71bb`. A **non-monotonic** four-point X table `0,5,3,10` and Y `0,50,300,100` plus persistent `i` predicts **X4=40 (cold) → X8=157.142857 → X4=271.428571**; same X maps differently after an excursion. Correctly sorted paired points predict **X4=175 → X8=80 → X4=175**. Do not call this a failure of a valid sorted table or claim an observed HAL/drive result.

[Machine-class commissioning guide](../guides/3100-3300-3400-3600-4000-linuxcnc-lincurve-calibration-table-commissioning-2026-11-02.md), [disconnected fixtures/acceptance](../examples/4000_lincurve_159/README.md), [read-only HAL table preflight](../examples/4000_lincurve_159/validate_lincurve_table.py), and [seven-added-line stable manpage clarification candidate](../examples/4000_lincurve_159/lincurve_ordered_breakpoints_doc_v2910.patch) are reviewable. Static patch context matches exact v2.9.10 lines 13–18 and hunk count; **patch not applied upstream or compiled**. Preflight does not expand HAL includes/Tcl or certify live edits.

**Evidence:** SOURCE/DOC-CONFIRMED static; numeric sequence INFERENCE; TEST-CONFIRMED none; ALL acceptance gates NOT RUN. No LinuxCNC/HAL execution, physical machine, independent evaluator or Actions compute; hosted/self-hosted 0/0 minutes. Blind and lab ledgers unchanged.

## Next highest-value work

1. If and only if **independently qualified, physically disconnected** `[self-hosted, openpressbrake]` compute exists, execute existing MOTION-144 amplifier-fault/re-enable A–F first; retain raw same-servo-cycle output and prove no machine I/O path. No GitHub-hosted runners or unqualified local panel PC.
2. If that remains blocked, do **not** accumulate redundant unrun variants of MOTION-144. A qualified isolated LINC-159 A–H run is a lower-priority inexpensive regression. Otherwise rotate to a distinct source-grounded LinuxCNC implementation issue (e.g., HAL signal processing or machine-specific post behavior) with full predecessor check.
3. Before any upstream documentation proposal, validate patch application and the table-order explanation on an isolated build, confirm developer conventions and seek maintainer review; the current candidate is static only.

Preserve 1000/2000/F02/3000 graduation, independent personnel-safety authority, OpenPressBrake G0/G1 HOLD, evaluator separation and the enabled hourly curriculum. No workflow or scheduling change.

## Same-session second source-depth continuation: BIQUAD-160

[BIQUAD-160 pinned stable/development audit](../research/4400_LINUXCNC_BIQUAD_160_NEGATIVE_CUTOFF_VALID_NONFINITE_COEFFICIENT_SOURCE_AUDIT_2026-11-02.md) finds a **distinct** `biquad.comp` generated-filter validity gap: with 1 ms period, `type=1, f0=-250 Hz, Q=0.5`, the rejection predicate accepts the negative cutoff; `alpha≈-1`, `a0≈0`, and coefficients are divided by `a0` before `valid=1`. This is a source-derived potential nonfinite filter state, **NOT an observed HAL output**. The official manpage incorrectly describes `f0>sampleRate/2` as required while the source rejects that range; `enable` only recalculates on a FALSE→TRUE edge. [A–H commissioning guide](../guides/4000-linuxcnc-biquad-filter-coefficient-validity-commissioning-2026-11-02.md) reuses upstream `tests/biquad/test.hal`, which covers direct default identity but not the new invalid-cutoff case. No new runtime/evaluator/compute evidence; all cases NOT RUN. Preserve LINC-159 as the primary session topic and both artifacts as non-graduated.
