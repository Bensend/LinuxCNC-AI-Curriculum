# LinuxCNC lincurve commissioning — calibration curves, PID gains and HAL table ordering

**4000 implementation / 3100 mills / 3300 plasma / 3400 routers / 3600 press brakes.** Practical handoff for the pinned [LINC-159 source investigation](../research/4400_LINUXCNC_LINCURVE_159_UNSORTED_BREAKPOINT_HISTORY_DEPENDENCE_SOURCE_AUDIT_2026-11-02.md). All executable checks **NOT RUN**.

## Why this matters

`lincurve` is a small realtime component that converts a measured/commanded scalar X into a calibrated Y. It is useful for a non-linear sensor, a lookup-driven feed-forward or an environment-dependent PID gain. It is **not** a trajectory planner, a motion limit, an EtherCAT drive monitor or a safety-rated permissive. The public [lincurve manual](https://linuxcnc.org/docs/devel/html/ru/man/man9/lincurve.9.html) says values are interpolated and clamped at endpoints; the pinned implementation assumes an ordered table and caches its segment index between servo callbacks.

An invalid X sequence can make identical sensor readings map to different Y outputs depending on previous readings. The [disconnected A–H fixture](../examples/4000_lincurve_159/README.md) predicts X4→X8→X4 giving 40→157.142857→271.428571 with unsorted X `0,5,3,10`; sorting **paired points** gives 175→80→175.

## Configuration design contract

1. Record input/output units and physical meaning, table provenance, date and machine model. **Never infer a universal calibration** from this numerical teaching example.
2. Choose `personality` 2–16 and set every X/Y pair; the stable source's `EXTRA_SETUP` clamps personality to this range. X must be **finite and strictly increasing**. Y may rise and fall, but must be finite and engineering-range checked separately.
3. Validate all paired points before enabling a consuming control loop. Use the [read-only preflight script](../examples/4000_lincurve_159/validate_lincurve_table.py) for a single literal HAL file. It does **not** expand includes or verify a running HAL network.
4. Use a floating-point servo thread. For a stand-alone fixture: `loadrt threads name1=servo-thread period1=1000000 fp1=1`, `loadrt lincurve count=1 personality=4`, `addf lincurve.0 servo-thread`, `start`. For real systems, ensure the source signal is produced **before** the lincurve callback and its consumer runs **after** it in the same thread, or document the extra-cycle delay.
5. Verify both endpoint clamps and interior points with known expected Y values. A flat endpoint value is not evidence of an actual sensor saturation: the lookup deliberately clamps.
6. Avoid multi-`setp` edits to live X/Y tables while the output controls an actuator. The component provides no atomic table-commit handshake. A new design could stage a complete table in a separate component and swap at a controlled state boundary; this is a **design option**, not a LinuxCNC stock feature.
7. Do not connect an invalid-table test to a live PID, spindle, torch-height, backgauge or hydraulic control. A LinuxCNC HAL output is ordinary machine control; independent personnel-safety authority remains separate.

## Machine-class transfer exercises (no compulsory product builds)

| Application | Plausible X→Y | Engineering question to answer before adoption |
|---|---|---|
| 3100 mill | spindle temperature → permissible ordinary feed correction | Is the input fresh, and is feed correction bounded by the controller/drive? |
| 3300 plasma | measured arc voltage → a *diagnostic* height estimate | How do material, consumables, torch-off state and QtPlasmaC THC modes affect validity? Do not replace QtPlasmaC's own process logic by assumption. |
| 3400 router | measured load → ordinary feed-forward correction | What happens when input falls outside calibrated endpoints or sensor feedback freezes? |
| 3600 press brake | measured sensor reading → display-only calibration estimate | What independent hardware/functional-safety path remains authoritative for ram/hydraulic stopping? |

These are **integration research exercises**, not claims that any cited machine actually uses `lincurve`, and not an instruction to change an OpenPressBrake release gate.

## Verification walk-through

**A. Source navigation:** inspect stable `src/hal/components/lincurve.comp` blob `2c6306828aba70f557461ed422d68abffddec041`, development blob `46ce4a46c2e61f1db0d8072adc81e263a11b71bb`, and the upstream [personality test](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/halcompile/personalities_mod/test.sh). Explain why a personality-export test is not an interpolation correctness test.

**B. Preflight:** inspect the two HAL tables and invoke the read-only validator. Reject the unsorted table, accept the paired sorted table. Do not claim that this validates dynamic `setp` edits, Tcl HAL or source includes.

**C. Disconnected runtime (qualified local runner only):** use `halrun -I` on the unsorted table and sorted control, follow the frozen commands in the fixture README, retain raw stdout/stderr, and compare to the predeclared numbers. Verify `out` and `out-io` agree. Report any harness failures separately.

**D. Adversarial source questions:** (1) If X/Y pairs are ordered but Y falls, is the table invalid? **No**: Y need not be monotonic. (2) If X=4 produces 40 after startup and 271.43 after X=8, did the input sensor necessarily drift? **No**: persistent segment index and invalid X order suffice. (3) Does the endpoint clamp search for global max X? **No**: it compares against `x_val(personality-1)`. (4) Can the offline validator certify live updates? **No**. (5) Does a HAL pin named `out-io` make a PID gain safety-rated? **No**.

## Version, evidence and next checkpoint

The two pinned revisions preserve the persistent-index search; development changes HAL real types and setter syntax and contains an explicit buffer-read FIXME, but this case does **not** establish a buffer overflow. **SOURCE-CONFIRMED** control flow; **DOC-CONFIRMED** intended interpolation; **INFERENCE** numeric trace and machine consequences; **TEST-CONFIRMED none**. No runtime, physical-machine or FPGA evidence, no Actions dispatch, and no external evaluator score.

The first justified executable work remains the separately qualified, disconnected **MOTION-144** amplifier-fault/re-enable test; this lookup regression is a low-cost alternative only after isolation is independently verified. If compute is unavailable, investigate a distinct LinuxCNC subsystem with new information gain. Preserve all graduated levels and independent OpenPressBrake G0/G1 HOLD.
