# Next checkpoint — MOTION-193 — 2026-11-03 18:34 UTC

Start at START_HERE.md and required governance/evaluation/compute ledgers. Read [MOTION-193](../research/4400_LINUXCNC_MOTION_193_BASIC_SIM_MUX_AND_MESA_FEEDBACK_COMPARISON_2026-11-03.md), MOTION-192 and MESA-177.

**Highest-value unblocked next source trace:** identify a real pinned LinuxCNC 2.9.10 Mesa encoder-backed servo HAL/INI pair (not the 7i96S stepgen example), map hm2.read -> encoder position -> PID feedback/command -> amplifier/PWM output -> hm2.write. Verify units, scaling, addf order, enable gating, and how following error relates to actual encoder location. If no credible encoder config, rotate to plasma/press-brake DXF→CAM→G-code source; avoid repeated synthetic examples.

**Execution oracle when isolation is independently qualified:** compare direct core_sim.hal loopback and basic_sim.tcl's PID-FF0 + mux sample/hold on the same short G61/G64 program; preserve canonical message counts, command, feedback, enable and same-cycle timestamps. The Tcl simulated feedback is NOT a physical plant. Check historical lab predecessor before any new execution. MOTION-144 remains the first executable priority after qualified self-hosted runner isolation. Never hosted Actions.

**Preserve:** 1000–3000 graduated closed; blind/independent safety gates unchanged; no physical operation. Update PROGRESS, LESSON_LOG, precise checkpoint, commit. Hourly remains enabled.
