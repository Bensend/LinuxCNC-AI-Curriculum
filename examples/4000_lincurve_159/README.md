# LINC-159 — disconnected lincurve table-order reproduction

This is a **software-only, NOT RUN** teaching fixture. The source investigation is [LINC-159](../../research/4400_LINUXCNC_LINCURVE_159_UNSORTED_BREAKPOINT_HISTORY_DEPENDENCE_SOURCE_AUDIT_2026-11-02.md). It does not command motion or connect to any machine HAL. **Do not run it on a machine controller with physical I/O.**

## 1. Offline preflight (no LinuxCNC required)

From repository root:

```sh
python3 examples/4000_lincurve_159/validate_lincurve_table.py --personality 4 --sample 4 examples/4000_lincurve_159/lincurve_unsorted.hal
# Expected: exit 2, X not strictly increasing at 01/02: 5 >= 3
python3 examples/4000_lincurve_159/validate_lincurve_table.py --personality 4 --sample 4 --sample 8 examples/4000_lincurve_159/lincurve_sorted.hal
# Expected: exit 0, sample 4 -> 175; sample 8 -> 80
```

The preflight only parses **literal** `setp <instance>.x-val-NN` / `y-val-NN` values from the selected file. It rejects missing/duplicate/nonfinite entries and non-increasing X. It does not expand `source`, INI variables, Tcl, live HAL changes or machine-specific wiring. This is a **configuration preflight**, not a runtime behavioral test or an upstream fix.

## 2. Actual LinuxCNC HAL oracle (requires separately qualified disconnected self-hosted compute)

Only after positive physical-disconnection and runner qualification, use LinuxCNC v2.9.10 (`86cdca76...`) or the pinned development revision (`06864e235...`) and record `linuxcnc -v`, `uname -a`, exact source/build revision and the full terminal trace. Do **not** dispatch hosted Actions or assume a runner label proves isolation.

```sh
halrun -I examples/4000_lincurve_159/lincurve_unsorted.hal
```

At the `halcmd:` prompt, enter these **one at a time** (the 1 ms thread runs between human commands):

```text
setp lincurve.0.in 4
getp lincurve.0.out
setp lincurve.0.in 8
getp lincurve.0.out
setp lincurve.0.in 4
getp lincurve.0.out
getp lincurve.0.out-io
exit
```

**Frozen source-derived prediction, not measured output:** 40; 157.142857; 271.428571; final out-io=271.428571 (floating-point tolerance ±0.0001). If a pin/function name or HAL environment fails, classify **HARNESS INVALID**, not component behavior.

Run a **fresh process** with `halrun -I examples/4000_lincurve_159/lincurve_sorted.hal`; repeat inputs 4→8→4. Frozen prediction: 175; 80; 175. A fresh unsorted process with input 4 alone predicts 40; this is the cold-start control.

## 3. Acceptance gates

| Gate | Evidence | Pass condition |
|---|---|---|
| A | file provenance | Exact LinuxCNC revision, HAL fixture SHA and disconnected host recorded |
| B | preflight invalid | Unsorted fixture rejected for 5 >= 3 |
| C | preflight valid | Sorted fixture accepted, X4=175 and X8=80 |
| D | unsorted cold | First X4 produces 40 |
| E | unsorted excursion | X8 produces 157.142857 |
| F | unsorted return | X4 produces 271.428571, not 40 |
| G | sorted control | X4→X8→X4 produces 175→80→175 |
| H | retention | Full stdout/stderr and commands saved; no physical/machine/functional-safety claim |

No gate has been executed or scored in this curriculum session. A result must distinguish `SOURCE-CONFIRMED`, `INFERENCE` and `TEST-CONFIRMED`. Do not add this fixture to a workflow that uses GitHub-hosted runners.

## 4. Engineering interpretation

This reproduces a **misconfigured nonmonotonic table**, not a defect in a valid ordered table. Sort complete **(X,Y) pairs**, do not independently sort X or Y, and verify the actual machine engineering units and permissible output range before integrating a lookup into PID gain scheduling, sensor linearization or a machine setpoint. For live calibration updates, a static preflight cannot establish atomic replacement; use an independent design review and commissioning procedure.
