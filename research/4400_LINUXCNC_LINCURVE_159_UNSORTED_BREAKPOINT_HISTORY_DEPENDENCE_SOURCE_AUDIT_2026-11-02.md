# LINC-159 — LinuxCNC lincurve: unsorted X breakpoints make a calibration table history-dependent

**2026-11-02; 4000 LinuxCNC implementation, with 3100 mill / 3300 plasma / 3400 router / 3600 press-brake transfer. NON-GRADUATED.**

## Scope and novelty

The previous 2026-11-02 LIMIT3-158 checkpoint requests distinct LinuxCNC source work when isolated compute is unqualified. Direct full-PROGRESS predecessor search found no `lincurve` entry; this is a new **HAL lookup-table configuration and state** mechanism, not a reclassification of LIMIT3, PID-152, QtPlasmaC or an existing source-only test. It does not reopen the graduated 3000 series. A current upstream code search returned the component and **personality/halcompile** tests, but no identified interpolation-behavior test; a search negative is not proof of test absence.

## Immutable sources / intended behavior

- LinuxCNC **v2.9.10**, commit `86cdca76fa2a36274c432caa21952b23c267989a`, `src/hal/components/lincurve.comp`, blob `2c6306828aba70f557461ed422d68abffddec041`: [exact source](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/components/lincurve.comp).
- LinuxCNC **development snapshot**, commit `06864e23559e70463fc7112d5ce77138bcbc288c`, same path, blob `46ce4a46c2e61f1db0d8072adc81e263a11b71bb`: [exact source](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/hal/components/lincurve.comp).
- Official [lincurve(9)](https://linuxcnc.org/docs/devel/html/ru/man/man9/lincurve.9.html) describes up to 16 points, straight-line interpolation, endpoint clamping and `out-io` for PID gains; the manpage does **not explicitly say** that X breakpoints must be strictly increasing, although its “largest X” and curve model imply an ordered lookup.
- Official [HAL basics](https://www.linuxcnc.org/docs/html/es/hal/basic-hal.html) defines `loadrt`, `addf`, `setp` and floating-point realtime thread requirements; [halrun(1)](https://www.linuxcnc.org/docs/master/html/en/man/man1/halrun.1.html) documents `halrun -I file.hal`.
- Upstream [`tests/halcompile/personalities_mod/test.sh`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/halcompile/personalities_mod/test.sh) blob `94f085d50b6e341f21786d833e2368f0629975b9` installs the component under a two-personality build and runs HAL files to check exported names; [4count fixture](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/halcompile/personalities_mod/4count_2pers.hal) blob `62a9c178680a676b3ab7760cb279f6ce271b5e72` does **not** vary X input to establish interpolation history independence.

## Source call/state trace

`loadrt lincurve count=1 personality=4` instantiates four `x-val-NN` and `y-val-NN` RW parameters; `EXTRA_SETUP` clamps personality to [2,16]. `addf lincurve.0 servo-thread` schedules `FUNCTION(_)` in a floating-point realtime callback. The function reads `in`, checks `x >= x_val(last)` then `x <= x_val(0)` and returns endpoint Y for either. For an interior input, it uses a **persistent per-instance unsigned `i` initialized to zero**, moves it right with `while (x > x_val(i+1)) i++`, moves it left with `while (x < x_val(i)) i--`, then interpolates using indices `i,i+1`. Stable writes `out` and `out-io`; development writes the same two values via `out_io_set(out__set(...))`. No monotonicity validation, explicit reset of `i` on table updates, or invalid-table status pin is visible in either inspected implementation. Development includes `// FIXME: potential buffer overflow read` before the first loop; **do not infer an out-of-bounds event from the example below**.

**Execution context:** a HAL realtime component, not Task, NML, the G-code interpreter, a hardware feedback witness or a personnel-safety channel. The HAL thread period determines when changed inputs and parameters are observed. A `setp` modifies a live RW parameter; no atomic multi-parameter table replacement is provided by this component.

## Hand-traced counterexample: same X, different Y

Use `personality=4`, **invalid non-monotonic** X table `[0,5,3,10]`, Y table `[0,50,300,100]`. All values are finite and the endpoints are ordered; the interior points are not.

| Callback | X input | `i` before | Segment after loops | Calculated Y | `i` after |
|---|---:|---:|---|---:|---:|
| cold start | 4 | 0 | (0,0)→(5,50) | **40** | 0 |
| next | 8 | 0 | (3,300)→(10,100) | **157.142857** | 2 |
| next | 4 | 2 | (3,300)→(10,100) | **271.428571** | 2 |

The first X=4 does not advance past breakpoint X=5. X=8 advances twice because X=8 exceeds X=5 and X=3. On returning to X=4, the second loop checks X<3 (FALSE), so it **does not return** to the earlier segment. Same X=4 thus has two source-derived Y values depending on input history. These are arithmetic predictions, **not HAL runtime measurements**.

**Ordered control:** Sort point pairs, not just X values: X `[0,3,5,10]`, Y `[0,300,50,100]`. At X=4 the unique intended interpolation is **175** regardless of whether X=8 was visited first. Y need not be monotonic; X must be **strictly increasing** for an unambiguous single-valued piecewise-linear function.

**Additional boundaries:** The endpoint tests use the first and last **array entries**, not a search for global min/max. Duplicates, NaN/Inf and live partially updated tables are not validated; their runtime outcomes require distinct tests rather than being conflated with this demonstrated arithmetic case. This audit does not claim that a correctly sorted, fixed table is history-dependent.

## Integration implications and provenance limits

A table can drive sensor linearization, a commanded calibration value or `out-io` into a PID gain. A silently misordered X list could therefore create a gain/command discontinuity after an input excursion, without a visible configuration error. This is an **INFERENCE about potential integration effects**, not evidence of an installed machine fault, actual actuator motion or a safety-rated mechanism. For mills/routers/plasma/press-brake controls, validate complete paired X/Y tables offline and do not hot-edit multiple breakpoints while the control loop is live without a separately designed atomic/supervised transfer.

The [paired HAL fixtures](../examples/4000_lincurve_159/README.md) and [strict table preflight](../examples/4000_lincurve_159/validate_lincurve_table.py) distinguish invalid and ordered cases. **TEST-CONFIRMED: none; fixtures NOT RUN.** No LinuxCNC build, HAL runtime, physical machine, independent evaluator or Actions job was used. Self-hosted and hosted compute **0/0 minutes**. Existing `LAB_COMPUTE_LOG.md` and blind score ledger remain unchanged.

## Evidence ledger / unresolved questions

- **SOURCE-CONFIRMED** (two pinned revisions): persistent `i`, endpoint checks, two search loops, interpolation, no input-table validation; development type/assignment syntax differs without removing this mechanism.
- **DOC-CONFIRMED**: intended interpolation, endpoint clamping, HAL interfaces and floating-point thread.
- **INFERENCE**: exact 40→157.142857→271.428571 sequence and downstream gain effects.
- **UNKNOWN**: actual installed configuration, runtime traces, concurrent parameter-update timing, malformed-table memory behavior, any downstream drive response.
- **Follow-up:** on a **positively qualified, physically disconnected** `[self-hosted, openpressbrake]` runner, run invalid and sorted fixtures, retain `getp` snapshots and exact source/version; only then consider a narrowly scoped upstream validation/documentation proposal. The preflight is a course artifact, **not an upstream patch**. Do not dispatch GitHub-hosted Actions.
