# 4000 implementation guide — G33 multi-spindle speed and index diagnostics

**Baseline:** [SPINDLE-22 pinned audit](../research/4400_LINUXCNC_SPINDLE_22_MULTISPINDLE_ATSPEED_INDEX_HANDSHAKE_SOURCE_AUDIT_2026-10-31.md). Static review only; not a machine acceptance record.

**Command path:** G33/G33.1 $N selects the spindle in the interpreter; START_SPEED_FEED_SYNCH carries it to motion. control.c reads spindle.N.revs, speed-in and at-speed. In both inspected stable and development TP sources, activation and wait check **all configured at-speed pins** but the index request targets the **selected spindle**. Encoder index-enable is an IO handshake that clears on a qualifying phase-Z edge.

**Upstream sample issue:** configs/sim/axis/lathe_multispindle/lathe.hal sets TRAJ SPINDLES=2 but connects spindle.1.index-enable to encoder_0.index-enable, while spindle.1.revs is sourced from encoder_1.position. A review-only independent topology is:

    net spindle-index-enable.0 spindle.0.index-enable <=> encoder_0.index-enable
    net spindle-index-enable.1 spindle.1.index-enable <=> encoder_1.index-enable

Do not apply to hardware without checking actual encoder/FPGA pins, phase-Z, scale and direction.

| Symptom | Discriminator |
|---|---|
| Selected G33 waits before index | Inspect **every** spindle.N.at-speed pin, not only the selected one. |
| Selected G33 waits at index | Inspect selected spindle.N.index-enable, its encoder index-enable and phase-Z. |
| Thread phase/pitch looks wrong | Inspect selected spindle.N.revs, encoder scale/index reset, commanded/actual axis positions and following error. |

An idle spindle can legitimately report at-speed TRUE for zero command and feedback; idle alone does not prove a blocking FALSE. Do not force at-speed TRUE on installed machinery to defeat a wait.

**Pending controlled simulation:** first record whether the original upstream HAL loads. In an isolated copy, correct only the index-enable net, vary at-speed flags independently and observe a selected-spindle G33; then exercise spindle 1 index clear. Preserve exact logs before claiming TEST-CONFIRMED. No hosted Actions or unverified machine-connected local runner. LinuxCNC motion readiness is not independent personnel-safety authority.
