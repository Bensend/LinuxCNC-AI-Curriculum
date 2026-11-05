# SPINDLE-235 — Spindle-at-speed gate and Skyfire Mesa scheduling (3100, NON-GRADUATED)

2026-11-05 UTC. Continues PROBE-234's concrete servo-order finding; does not reopen probing. Scope: LinuxCNC **v2.9.10** and Skyfire-community/SVM2-LinuxCNC **0fabfe4ba7baeea8f60ed39b66fc68c5ca5b3123**. This is source/config inspection, **not** an executed test.

## Source provenance
- LinuxCNC [src/hal/components/near.comp](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/components/near.comp): exact comparison predicate.
- LinuxCNC [src/emc/motion/control.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/control.c): copies `spindle.%d.at-speed` HAL bit into `emcmotStatus->spindle_status[spindle_num].at_speed` (around line 359).
- LinuxCNC [src/emc/motion/motion.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/motion.c): creates HAL_IN `spindle.%d.at-speed`, initializes it to true (around lines 735–736). Default true is **not** an independent measurement of spindle RPM.
- LinuxCNC [src/emc/tp/tp.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c): `tpCheckAtSpeed` (around 2798–2830), first-activation gate (around 2894), and `tpRunCycle` (around 3445).
- Pinned Skyfire [init.hal](https://github.com/Skyfire-community/SVM2-LinuxCNC/blob/0fabfe4ba7baeea8f60ed39b66fc68c5ca5b3123/init.hal) (blob `84ad49cf7474e8c725e652faeed29db69a7c1c00`), [spindle.hal](https://github.com/Skyfire-community/SVM2-LinuxCNC/blob/0fabfe4ba7baeea8f60ed39b66fc68c5ca5b3123/spindle.hal) (blob `1abd0f24f5563afdfc6f1524548b2c105c335d7e`).

## Exact at-speed predicate
`near.comp` sets output true when **either** `scale > 1 && in1/scale <= in2 <= in1*scale` (with both inputs sign-flipped when in1 is negative) **or** `abs(in1-in2) <= difference`. Defaults are `scale=1`, `difference=0`. Skyfire sets `n-spindle-at-speed.scale=1.05`, but does not set its `difference` in the inspected spindle HAL. The two inputs are commanded **absolute RPM** and filtered encoder-derived **absolute RPM**. Thus a positive 1000 RPM command accepts 952.38–1050 RPM, approximately, *if* the filter output has reached that band; a zero command with difference=0 accepts **only exact zero**. A command of 0 does not gain a 5% tolerance: its multiplicative band collapses to zero. This is a logical comparator, not an independently verified spindle-stop detector.

The separate `n-spindle-at-zero-for-disable` is **not** the same predicate: Skyfire sets `in1=100`, `difference=110`, leaving default `scale=1`; with nonnegative measured RPM this permits 0–210 RPM. Despite the HAL comment saying 'under 100 RPM', the actual configured absolute-difference band reaches **210 RPM**. At 211 RPM the near output becomes false. This is a **configuration/source discrepancy**, not a measured machine defect.

## Servo-cycle ordering and two distinct paths
Skyfire `init.hal` orders `hm2_7i76e.0.read → motion-command-handler → motion-controller → pid.* → scale.spindle → abs.spindle → lowpass.spindle → hm2_7i76e.0.write → n-spindle-at-speed → n-spindle-at-zero-for-disable → spindle-enabled-or-spinning → not-spindle-at-zero-for-disable → spindle-ramp → spindle-enable-delay → spindle-enable-or-override-cmd`.

`spindle.hal` connects `n-spindle-at-speed.out → spindle.0.at-speed`; `spindle-ramp.out → hm2_7i76e.0.stepgen.05.velocity-cmd`; and the delayed enable/or logic to stepgen and GPIO outputs. Consequences of the explicit ordering:
1. Motion controller samples the **previous** execution of `near`, since `near` runs later in the same servo thread. Therefore a newly calculated at-speed transition cannot affect the controller in that pass.
2. `hm2.write` precedes `spindle-ramp`, enable-delay and OR logic. Newly computed stepgen velocity/enable/physical GPIO values are available for the **next** write, not the preceding write. No measured Ethernet/FPGA latency is claimed.
3. `lowpass` executes before `near`, so the comparator sees the current pass's filtered encoder feedback. But motion still sees its previously published comparator result.
4. `n-spindle-at-zero-for-disable` executes before `not-spindle-at-zero-for-disable`, but `spindle-enabled-or-spinning` runs **before** the `not` producer. Its stop-hold decision can therefore use a one-pass-old inversion even though the near output is fresh. This matters for the 'keep spindle enabled while slowing' logic.

## Trajectory planner gate
`tpCheckAtSpeed` returns `TP_ERR_WAITING` when a motion is waiting for at-speed and **any** configured spindle's `at_speed` is false; it clears `waiting_for_atspeed` only after all pass. On segment activation, `needs_atspeed` is true for a segment's `atspeed` flag or the first position-synchronized move when spindle synchronization is not already active. The same all-spindle loop can arm the wait for that segment. This is not proof that every G1 waits, nor that an arbitrary spindle-ready bit verifies encoder correctness. Exact canonical/Task conditions setting the segment `atspeed` flag remain a separate trace.

## Disconnected reproducible exercise (analytical, not executed)
At pinned revisions, inspect the listed files. Draw producer→consumer arrows in servo-thread order and annotate the previous-cycle dependencies. Calculate the `near` output for (command, filtered actual) RPM: (1000,950)=false; (1000,1000)=true; (1000,1051)=false; (0,0)=true; (0,0.01)=false. For the stop comparator with in1=100/difference=110: actual 0=true, 100=true, 210=true, 211=false. Predict that flipping the near output after `motion-controller` cannot release its wait until a later pass. A disconnected virtual-HAL fixture could log the signals at servo-cycle boundaries; do **not** connect this exercise to a real spindle or claim measured cycle delay without a trace.

## Evidence ledger / unresolved
- **SOURCE-CONFIRMED:** near predicate, motion HAL pin initial true, controller status sampling, TP wait conditions, all-spindle check.
- **CONFIG-CONFIRMED:** Skyfire pin wiring, 1.05 ratio, 100/110 stop threshold, HAL addf order, spindle stepgen/encoder topology.
- **DERIVED:** numeric comparison cases, potential one-pass age boundaries, comment/threshold mismatch.
- **UNKNOWN:** actual spindle hardware response, lowpass transient, FPGA write latency, real M3/M4/M5/M6 sequencing, Task/canonical flag propagation, whether other included runtime scripts change pins.
- **TEST-CONFIRMED:** none. No lab compute, builds, hosted Actions or machine operations.

## Next decision
Follow LinuxCNC v2.9.10 M3/M4 and M6 Task/interpreter sequencing into the segment `atspeed` flag; then inspect Skyfire tool-change/orient signals against a complete real configuration. Prefer a disconnected virtual HAL comparison of producer-before/after-controller ordering if independent evidence is needed. Preserve blind/evaluation and independent personnel-safety gates. No change to graduated levels.
