# HostMot2 StepGen archived HDL timing review — STEPGEN-155

**4000 implementation walkthrough | 2026-11-02 | NON-GRADUATED | all executable cases NOT RUN.** Pair with [pinned VHDL investigation](../research/4400_LINUXCNC_STEPGEN_155_ARCHIVED_VHDL_ZERO_PULSE_DDS_HOLD_AND_FEEDBACK_SOURCE_AUDIT_2026-11-02.md) and [STEPGEN-153/154 C/regmap commissioning worksheet](3100-3300-3400-3600-4000-linuxcnc-mesa-stepgen-timing-and-cap-commissioning-2026-11-02.md). Do not connect this exercise to a real drive or machine.

## Reproducible inspection path

1. Open archived `LinuxCNC/hostmot2-firmware` commit `c15c0c3c0af826fd2996aa1eddb8669f154bb2a5`: `Makefile` lines 10–20 → `src/hostmot2.vhd` lines 552–856 → `src/kubstepgenz.vhd` lines 179–305. Verify each file's blob SHA against the research document. `hostmot2.vhd` maps `clklow` and optional `basicrate` prescaler to the stepgen. Do not assume this archived firmware is installed in a contemporary 7i96S.
2. Draw a four-signal timing table for `pulsewidthcount`, `pulsewait`, `dpulsewait`, `steppulse`. First use a settled idle state and `pulseactivetime=1`: at event edge E0 the count loads 1 and STEP rises; at E1 count becomes 0; at E2 the delayed wait permits STEP to fall. Expected nominal high time: **two module-clock periods**.
3. Repeat with `pulseactivetime=0` from the same settled state. E0 loads 0 and sets STEP; `pulsewait` never asserts, `dpulsewait` stays zero, and the normal falling-edge branch cannot fire. **Predicted conditional stuck-high**, not a measured pin state. Do not label this a valid one-clock pulse.
4. In LinuxCNC stable v2.9.10 `stepgen.c`, find the C-to-register conversion. At 100 MHz, `steplen=9ns` → count 0; `steplen=15ns` → count 1. A fake-LLIO register test alone cannot validate HDL behavior.
5. Trace `wewouldcount` → `ddshold` → gated `stepaccum`, then `hm2_stepgen_process_tram_read` → `position-fb` and `hm2_stepgen_instance_prepare_tram_write` → `velocity-fb`. State why commanded velocity, generated-step accumulator, actual STEP edges, and measured motor/axis travel are **four different witnesses**.
6. Read `hm2_stepgen_parse_md` in the host driver: firmware v0 and v1 have explicit warnings; v2 is accepted. Identify the selected module descriptor, exact clock, and installed firmware provenance before extending any archived-HDL inference to hardware.

## Bounded verification matrix (not dispatched)

| Case | Setup | Frozen predicted discriminator | Evidence required |
|---|---|---|---|
| A | HDL isolated, active count 1, idle nonzero, slow DDS | Two `clklow` high periods in simple settled-state trace | HDL simulation waveform, testbench hash |
| B | HDL isolated, active count 2 | Three high periods in same regime | HDL simulation waveform |
| C | HDL isolated, active count 0 from settled idle | No normal falling-edge transition; possible persistent high | HDL simulation waveform and reset-state log |
| D | HDL isolated, active count 1, idle 0 | Do not infer zero idle means zero physical inter-edge spacing | Actual edge timestamps |
| E | Request step rate above timing capacity, nonzero active/idle | `ddshold` stalls accumulator updates when an event would violate waits | Internal `ddshold`, `stepaccum`, output edge timestamps |
| F | Same rate but prescaler on/off | Rate and timing may differ due to `basicrate` gating | Clock/prescaler config and waveform |
| G | Stable host fake-LLIO, 100 MHz, 9ns/15ns | Registers 0/1 respectively; host does not reject zero | Host register write log, not physical pulse |
| H | Exact board bitfile differs from archived source | **No transfer of A–F results to board without equivalence evidence** | Bitfile source/version and disconnected scope |

Only consider execution after a frozen source/testbench review and positively verified, physically disconnected `[self-hosted, openpressbrake]` compute. Never dispatch hosted Actions. An HDL testbench is not evidence of actual output pin electrical behavior; a scope capture is not evidence of physical motor motion.

## Practical commissioning decision

The safe engineering default is to calculate a **nonzero pulse-active register** with margin relative to the drive's minimum high time and module clock, verify the exact board firmware semantics, and keep the stepgen rate within independently validated capacity. A live `stepgen.position-fb` value is not an external encoder; a live `stepgen.velocity-fb` value is not a tachometer. This guide does not authorize machine motion or change independent personnel-safety gates.

**Transfer question:** If a driver reports a positive `velocity-fb`, the FPGA accumulator advances, but a logic analyzer sees a STEP line remain high, what distinct states should be inspected? **Reviewer answer:** actual active-width register (including zero), `pulsewait/dpulsewait`, DDS hold, pin routing/polarity, selected bitfile, and independent motor feedback; do not conclude the axis moved or that a step occurred per accumulator increment.

**Next:** [STEPGEN-155 checkpoint](../checkpoints/20261102T0930Z-4000-linuxcnc-stepgen-vhdl-next.md).
