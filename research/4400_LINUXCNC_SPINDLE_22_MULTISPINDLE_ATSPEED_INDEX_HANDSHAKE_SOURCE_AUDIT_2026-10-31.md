# 4000-LC-SPINDLE-22 — Multi-spindle G33 readiness and index handshake source audit

**Session:** 2026-10-31T04:31:53Z. **Status:** SOURCE-CONFIRMED static analysis; DOC-CONFIRMED as marked; NON-GRADUATED. No HAL load, simulation, build or physical test.

## Engineering question / pre-source hypothesis

Does G33 selecting spindle 0 using $0 depend only on spindle 0 at-speed and index? The initial hypothesis was selected-spindle-only readiness. The pinned LinuxCNC source instead checks **every configured spindle's at-speed** while requesting and waiting for **only the selected spindle's index**. A published upstream two-spindle simulation additionally wires both index-enable requests to encoder 0, leaving encoder 1 index-enable unconnected.

## Immutable provenance

- LinuxCNC development commit [24e84c4506b41634240f7087f0295e361a954886](https://github.com/LinuxCNC/linuxcnc/tree/24e84c4506b41634240f7087f0295e361a954886), published 2026-10-30: [src/emc/tp/tp.c](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/tp/tp.c) blob 2b4024c9ab131f708cc22760300231878c9b0fdc, tpCheckAtSpeed lines 3447–3503, tpActivateSegment 3510–3600, tpRunCycle 4289–4360; [src/emc/motion/control.c](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/motion/control.c) blob 7c9a35c237ba05326372294587c33d53aff1a6a9, process_inputs around line 417, index handshake around 2098.
- [src/emc/rs274ngc/interp_convert.cc](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/rs274ngc/interp_convert.cc) blob 379b21eaba65840ce4160e7ea70df60c12fad9ff, convert_straight G33/G33.1 lines 5794–5853; [src/emc/task/emccanon.cc](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/task/emccanon.cc) blob 5ad736c59e85495aa06573ebcad2d49d59145583, START_SPEED_FEED_SYNCH lines 1409–1419.
- Stable [v2.9.10 tp.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c) blob 5768d6e6880569f72156ed9a761b5eee531c9fcf, tpCheckAtSpeed 2798–2843 and tpActivateSegment 2851–2935: same all-spindle readiness loops.
- Upstream [configs/sim/axis/lathe_multispindle/lathe.hal](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/configs/sim/axis/lathe_multispindle/lathe.hal), blob 1d9ea534687cce89ddbca4d06b0acf8b609becb5, identical in stable v2.9.10; [lathe.ini](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/configs/sim/axis/lathe_multispindle/lathe.ini) blob c6fdd47c1ebfced4e1b51c92ead5b0e795ac946c, TRAJ SPINDLES=2.
- Official [G33/G33.1 docs](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/gcode/g-code.adoc), blob 46386681cce284fa0cc43e27192bee0aca208766, lines 1190–1332; [motion HAL pins](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/man/man9/motion.9.adoc), blob d24119c1ff6a3b61f3b1bcbd5bd85127d5b550ea, lines 505–518; [encoder index-enable](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/man/man9/encoder.9.adoc), blob 2a4226cf1e573c26f4aa7eb475f1535bdb26233a, lines 70–76.

## Interpreter to realtime TP

**SOURCE-CONFIRMED:** Interp::convert_straight validates G33/G33.1 $N, selected spindle turning state and pitch, then emits START_SPEED_FEED_SYNCH(active_spindle,...). Canonical code writes EMC_TRAJ_SET_SPINDLESYNC with spindle and feed per revolution. control.c::process_inputs reads every spindle's revs, speed-in and at-speed into motion status.

**Unexpected dependency:** tpActivateSegment computes needs_atspeed from tc->atspeed or a new position-synchronized segment. Its for-loop from s=0 to numSpindles returns WAITING when **any** spindle's at_speed is FALSE, storing waiting_for_atspeed=tc->id. tpCheckAtSpeed repeats the same all-spindles loop on subsequent cycles. Only the subsequent index-enable request and index-clear check address tp->spindle.spindle_num (the selected spindle). Both stable and pinned development implement this same distinction.

**Conditional counterexample (NOT EXECUTED):** numSpindles=2, G33 selected spindle 0, at_speed[0]=TRUE, at_speed[1]=FALSE. The segment remains waiting for speed even if spindle 0 is ready. An idle spindle may report TRUE when commanded and measured speeds are both zero; merely being stopped does not establish the blocking condition.

**DOC-SOURCE scope:** G33 docs explain $N selection and the spindle.N.at-speed requirement, but do not describe the stronger all-spindles TP gate. Whether that gate is intentional is UNKNOWN; do not label it a field-proven defect.

## Upstream multi-spindle HAL index-enable discrepancy

**SOURCE-CONFIRMED:** the two-spindle sample uses these lines (lathe.hal lines 38, 41, 61, 64):

    net spindle-index-enable spindle.0.index-enable <=> encoder_0.index-enable
    net spindle.0.pos encoder_0.position => spindle.0.revs
    net spindle-index-enable spindle.1.index-enable <=> encoder_0.index-enable
    net spindle.1.pos encoder_1.position => spindle.1.revs

The second index-enable line repeats the **same signal and encoder_0.index-enable**, not encoder_1.index-enable. The sample has separate phase-Z input and position feedback for encoder 1, but no encoder_1.index-enable connection. Official encoder docs specify that index-enable is IO: at a qualifying phase-Z rising edge it resets the corresponding counter and clears the enable flag. control.c propagates motion index requests and observes the falling HAL IO flag to clear motion's request. The sample as written does not establish independent spindle-1 index reset and acknowledgement.

**INFERENCE:** depending on HAL duplicate-link/IO-writer behavior, this may cause a HAL load error or incorrect spindle-1 index origin/acknowledgement. Actual HAL loading, output behavior, threading error and hardware effects are **UNKNOWN**; no test was run. Proposed review-only topology (NOT TESTED):

    net spindle-index-enable.0 spindle.0.index-enable <=> encoder_0.index-enable
    net spindle-index-enable.1 spindle.1.index-enable <=> encoder_1.index-enable

## Distinguish three separate conditions

1. **At-speed:** all configured spindle flags are inspected by the pinned TP readiness gate.
2. **Index:** selected spindle's index-enable request must clear on its encoder's qualifying index event.
3. **Position tracking:** tpSyncPositionMode uses selected spindle revolutions and pitch to command axis motion. Neither at-speed nor index acknowledgement independently proves accurate position following or a good thread.

The sample has separate near_speed.0 and near_speed.1 comparators; its actual idle-spindle flag depends on command and feedback. Do not force at-speed TRUE on a real machine to bypass a wait without validating readiness.

## Minimal reproducible discriminator (PENDING, NOT RUN)

1. On a verified isolated software-only host, load a copy of the pinned upstream lathe_multispindle simulation and first preserve whether the original HAL loads successfully.
2. Observe all spindle.N.at-speed flags. With spindle 0 selected and TRUE, deliberately make spindle 1 FALSE under controlled simulation, request a G33, and record whether TP waits before index; repeat with both TRUE. Record G-code, HAL/INI, version and pin values.
3. Separately correct only the index-enable topology in a copy and verify spindle 1's own request, phase-Z, clear and encoder 1 position reset. Do not conflate with speed gating.
4. Falsifier: a revision where both at-speed loops select only the requested spindle, or an independent controlled runtime trace contradicting the source-derived wait.

**Claims ledger:** G33 selected-spindle interpreter path, all-spindles TP readiness, selected index wait and sample miswiring SOURCE-CONFIRMED; encoder IO index clear DOC-CONFIRMED; actual HAL load, runtime, timing and thread accuracy UNKNOWN; TEST-CONFIRMED none. This is new cross-spindle coupling plus an exact upstream example inconsistency, not a repeated HAL scheduling lesson. No compute, workflow, build, simulation, machine operation, independent evaluator or graduation. Existing personnel-safety authority and OpenPressBrake G0/G1 HOLD unchanged.

**Next:** inspect upstream history/issues for intentional gating or corrected example; if no new evidence, rotate to G33.1 rigid-tap reversal or homing/index sequencing.
