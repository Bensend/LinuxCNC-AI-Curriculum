# STEPGEN-155 — Actual archived HostMot2 StepGen VHDL: nonzero N+1 pulses, zero-width edge case and DDS backpressure

**2026-11-02 | 4000 LinuxCNC implementation, 3100/3300/3400/3600 transfer | NON-GRADUATED.** **SOURCE-CONFIRMED archived HDL control flow; conditional waveform INFERENCE; TEST-CONFIRMED none; NOT RUN.** No installed Mesa bitfile, FPGA, drive, or machine was exercised.

## Incremental question and predecessor boundary

[STEPGEN-153](4400_LINUXCNC_STEPGEN_153_MESA_NS_TO_TICKS_TRUNCATION_AND_MAXVEL_LATCH_SOURCE_AUDIT_2026-11-02.md) established the LinuxCNC C driver's integer timing conversion and persistent explicit `maxvel` rewrite. [STEPGEN-154](4400_LINUXCNC_STEPGEN_154_FIRMWARE_NPLUS1_PULSE_AND_HOST_MAXRATE_RECONCILIATION_2026-11-02.md) found the archived **register-map** statement that active/idle pulse time is N+1 clocks, but could not inspect actual HDL. [STEPGEN-97](4400_LINUXCNC_STEPGEN_97_MESA_POSITION_FEEDBACK_VS_PHYSICAL_AXIS_MR1_SOURCE_AUDIT_2026-11-01.md) already established that `velocity-fb` is a selected command and `position-fb` is derived from FPGA accumulator, not an external axis encoder. **New here:** trace the archived VHDL timer and DDS hold, including the register-zero state where the generic N+1 statement cannot be applied blindly. No new independent feedback-discovery claim.

## Pinned provenance and actual build linkage

- Archived `LinuxCNC/hostmot2-firmware` master **commit `c15c0c3c0af826fd2996aa1eddb8669f154bb2a5`** (last commit 2021-03-08; repository archived 2021), [`src/kubstepgenz.vhd`](https://github.com/LinuxCNC/hostmot2-firmware/blob/c15c0c3c0af826fd2996aa1eddb8669f154bb2a5/src/kubstepgenz.vhd), **blob `682af62b5057bde6594694040939513b9a868042`**, `stepgen` architecture lines 179–305, 338–345.
- Same archived commit [`src/hostmot2.vhd`](https://github.com/LinuxCNC/hostmot2-firmware/blob/c15c0c3c0af826fd2996aa1eddb8669f154bb2a5/src/hostmot2.vhd), blob `bf01eefc8f1ec712d11ab060ee9dfd352b941e42`, lines 552–856: instantiates `work.stepgen` with `clk => clklow`; `basicrate` comes from optional `RateGen`, or is constant 1 without prescaler. Register write decodes feed `loadpulseactivetime` and `loadpulseidletime`.
- [`Makefile`](https://github.com/LinuxCNC/hostmot2-firmware/blob/c15c0c3c0af826fd2996aa1eddb8669f154bb2a5/Makefile) blob `6395b722b23f136dc0cee62d373fa5a0a53c2117`, lines 10–20, includes `kubstepgenz.vhd` and `hostmot2.vhd` in `COMMON_VHDL`; [`IDROMConst.vhd`](https://github.com/LinuxCNC/hostmot2-firmware/blob/c15c0c3c0af826fd2996aa1eddb8669f154bb2a5/src/IDROMConst.vhd) blob `8ac9e0fef90bc66850c9df2feaf29663426f4330` sets `KUBStepGenRev=x"02"` and the pulse register addresses `0x25/0x26`. This is source linkage, **not proof that any modern installed board uses this HDL**. A separate `kubstepgenzi.vhd` exists for index/probe; its precise build inclusion and installed firmware provenance remain unresolved.
- [`src/regmap`](https://github.com/LinuxCNC/hostmot2-firmware/blob/c15c0c3c0af826fd2996aa1eddb8669f154bb2a5/src/regmap) blob `b3a2a77c27de0c71278dc910992efeddd7deb577`, lines ~270–326: N+1 active/idle periods and explicit warning not to use zero for pulse width.
- LinuxCNC stable v2.9.10 [`stepgen.c`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/stepgen.c), blob `8eb43d9a7d8e42573ef653cb82460609d2864ae4`: `hm2_stepgen_update_pulse_width` lines ~379–387, `hm2_stepgen_instance_prepare_tram_write` ~250–327, `hm2_stepgen_process_tram_read` ~38–120, and firmware-revision checks ~690–710.

## Clock-by-clock control flow — why nonzero N+1 is plausible

In the `stepgen` VHDL, a DDS overflow/underflow event loads `pulsewidthcount <= pulseactivetime` and sets `steppulse <= '1'` (lines 204–209). The combinational `pulsewait` is TRUE **only while the count is nonzero** (291–295). Each clock while `pulsewait` is TRUE decrements the counter (191–193). `dpulsewait` samples the previous `pulsewait` on every rising edge (264). When `pulsewait=0 AND dpulsewait=1 AND steppulse=1`, the synchronous process clears the pulse and loads `pulseidletime` (195–198). In the normal settled case with a nonzero active count N, the STEP signal remains high for **N+1 `clklow` periods**, consistent with the regmap. For a hypothetical 100 MHz module clock, N=1 gives a nominal 20 ns high pulse. This is a source-derived edge sequence, **not a simulator or scope observation**.

### Material zero-width corner: the regmap's N+1 row is not an unconditional HDL guarantee

If the active register is **zero** and the prior pulse timer is idle (`pulsewait=0, dpulsewait=0`), a new DDS step event sets `steppulse=1` while loading `pulsewidthcount=0`. The combinational `pulsewait` never asserts; `dpulsewait` therefore never captures a TRUE pulse-wait state. The **only normal STEP falling-edge condition** at lines 195–198 is never reached. Repeated DDS step events can keep the STEP output high without generating corresponding new rising edges. This is a **conditional HDL-state inference**; reset/initialization, previous timer history, output routing and exact bitfile can change the observed result. It explains why the regmap warns against pulse-width zero and **supersedes** any interpretation that register 0 necessarily produces a valid one-clock STEP pulse.

The stable C driver converts `steplen_ns` to an unsigned integer count using truncation and only clips counts above `0x3FFF`; it does **not** enforce a minimum nonzero count. A request below one module clock period (e.g., 9 ns at 100 MHz) therefore yields register zero. This is a cross-layer **configuration acceptance gap in the inspected C/archived-HDL combination**, not proof of a deployed failure. The archived regmap's warning is not an executable input validator.

Do **not** automatically generalize this active-zero failure to `stepspace=0`: the zero idle count removes the timer's enforced wait, but the transition/next-step behavior depends on `dpulsewait`, DDS phase and other gates. Likewise, direction setup/hold use a separate counter and must be independently analyzed.

## Rate-limit behavior is backpressure, not proof of dropped step events

`stepaccum <= nextaccum` occurs only if `basicrate=1 AND hold=0 AND ddshold=0` (186–189). Combinational `ddshold` asserts when `wewouldcount=1` and pulse/idle/direction waits or direction changes block the next event (270–289). Thus this archived HDL **holds the DDS accumulator** during an output-timing restriction rather than blindly advancing it through every blocked step event. This qualifies STEPGEN-154's comparison between the host-requested rate and N+1 nominal periods: it does **not** by itself prove pulses are dropped; a too-high command may result in a lower achieved generated-step rate. Exact maximum throughput also depends on the `dpulsewait` transition and optional `RateGen` prescaler, so the simple 1/(N+1 active + N+1 idle) rate is a *bound/worksheet*, not a verified saturation rate.

The stable host driver assigns `velocity-fb = new_vel` before writing the DDS rate register (stepgen.c ~310–327), while `position-fb` comes from the readback accumulator (lines ~38–120). Under conditional HDL timing backpressure, `velocity-fb` can remain at the **requested clipped command** even as the accumulator advances more slowly. Under the **active-zero edge case**, accumulator progress may not imply separate STEP rising edges at all. Neither signal proves physical motor/axis travel. The exact joint following-error response depends on the machine's HAL wiring, scale and controller state; no runtime claim.

## Evidence matrix and falsifiers

| Proposition | Evidence | Status |
|---|---|---|
| Nonzero active count N uses counter/deferred clear, nominal N+1 clocks | `kubstepgenz.vhd` 191–209, 264, 291–295 + regmap | SOURCE-CONFIRMED control flow; waveform NOT RUN |
| Active count zero can leave STEP high after an event from settled idle | Same HDL, absence of a falling-edge path without `dpulsewait=1` | Conditional INFERENCE; no simulation |
| C can encode zero for a sub-tick nonzero `steplen` | stable `stepgen.c` ~379–387 | SOURCE-CONFIRMED |
| Timing waits stall DDS accumulator updates | HDL 186–189, 270–289 | SOURCE-CONFIRMED |
| Actual maximum pulse rate, bitfile, motor response, lost steps | Requires exact synthesized firmware and independent observations | UNKNOWN / NOT RUN |

**Engineering boundary:** Never try the zero-width condition on an enabled drive or installed machine. Before commissioning, identify the actual firmware/clock/drive datasheet, use a nonzero register with margin, and separately verify STEP-high, STEP-low and direction timing. This is ordinary LinuxCNC control engineering; independent personnel-safety authority and OpenPressBrake G0/G1 HOLD remain unchanged. No hosted or self-hosted job was dispatched.

See [disconnected source/HDL walkthrough](../guides/4000-linuxcnc-hostmot2-stepgen-vhdl-zero-width-disconnected-review-2026-11-02.md) and [continuation checkpoint](../checkpoints/20261102T0930Z-4000-linuxcnc-stepgen-vhdl-next.md).
