# STEPGEN-154 — HostMot2 firmware N+1 pulse semantics reconcile host ns-to-tick conversion
**2026-11-02 | 4000 LinuxCNC + FPGA implementation | NON-GRADUATED**

## Why this continuation matters
The immediately preceding [STEPGEN-153 host-C audit](4400_LINUXCNC_STEPGEN_153_MESA_NS_TO_TICKS_TRUNCATION_AND_MAXVEL_LATCH_SOURCE_AUDIT_2026-11-02.md) proved integer register truncation but correctly left FPGA pulse interpretation UNKNOWN. The first source-only hazard hypothesis (a 15 ns request encoding register 1 could imply 10 ns output) is **not supported by the newly inspected firmware register contract**. This document supplies the missing firmware-side evidence and corrects that inference; do not repeat the old hypothesis as a machine fault.

## Original-source provenance
- LinuxCNC v2.9.10 commit `86cdca76fa2a36274c432caa21952b23c267989a`, `src/hal/drivers/mesa-hostmot2/stepgen.c` blob `8eb43d9a7d8e42573ef653cb82460609d2864ae4`, functions `hm2_stepgen_update_pulse_width`, `hm2_stepgen_update_pulse_idle_width`, `hm2_stepgen_instance_prepare_tram_write`.
- LinuxCNC development snapshot `67437d8865e431a9a33f74cee912dbf891d3b4c5`, same path blob `4daaa54f3fb63b6af2dc2d83a31ebfbb7b47ca23`: same relevant conversions and `maxvel` cap behavior.
- **LinuxCNC/hostmot2-firmware**, `src/regmap`, inspected GitHub default-branch blob **`b3a2a77c27de0c71278dc910992efeddd7deb577`**, [source](https://github.com/LinuxCNC/hostmot2-firmware/blob/master/src/regmap), lines 270–326. It explicitly defines StepGen `Pulse length = Active time of output pulse (N+1 clocks)` and `Pulse Idle = Inactive time of output pulse (N+1 clocks)` for the 14-bit registers at 0x2500/0x2600; it also documents DIR setup/hold as 14-bit timing registers at 0x2300/0x2400 and warns **do not use 0** for setup/hold. This is a **register-map contract**, not a waveform capture from the installed bitfile.
- Official [HostMot2 driver manual](https://linuxcnc.org/docs/master/html/en/man/man9/hostmot2.9.html) describes HAL `steplen`/`stepspace` in ns and `maxvel=0` as timing-derived maximum.

## Reconciled source arithmetic
Host driver stores `N = floor(request_ns × f_clk / 1e9)` for `steplen` and `stepspace` (until 0x3FFF saturation). Under the pinned firmware regmap's N+1 semantics, the **nominal register-contract duration** is `(N+1)/f_clk`, not `N/f_clk`.

For hypothetical **100 MHz** (10 ns ticks):

| HAL request | Host integer N | Regmap nominal N+1 clocks | Regmap nominal duration |
|---:|---:|---:|---:|
| 9 ns | 0 | 1 | 10 ns |
| 10 ns | 1 | 2 | 20 ns |
| 15 ns | 1 | 2 | 20 ns |
| 25 ns | 2 | 3 | 30 ns |
| 100 ns | 10 | 11 | 110 ns |
| 500 ns | 50 | 51 | 510 ns |

Thus the earlier **conditional N-clock/short-pulse** example must be replaced: for the firmware described by this regmap, a 15 ns request maps to a **nominal 20 ns**, not 10 ns, active pulse. The register-map semantics are not yet verified against a particular synthesized firmware bitfile or scope trace.

## New cross-layer mismatch: host maxvel uses requested ns, not N+1 pulse time
The HostMot2 driver computes `physical_maxvel = 1e9 / ((steplen_ns + stepspace_ns) × abs(position_scale))`. It does **not** use the two integer register values or the regmap's `N+1` interpretation. At 100 MHz and 15 ns/15 ns, host formula permits **33.333 million steps/s**; the regmap's minimum 20 ns active + 20 ns idle corresponds to **25 million steps/s**. At 1000 ns/1000 ns, host formula gives **500,000 steps/s**; regmap nominal 1010 ns+1010 ns gives approximately **495,050 steps/s**. This is a **SOURCE+REGMAP-CONFIRMED mismatch between two formulas**, not a claim that a particular FPGA outputs too-fast pulses, loses steps, or exceeds a drive limit. Actual DDS rate enforcement, hardware behavior and exact module clock must be verified.

The independent STEPGEN-153 persistent `maxvel` HAL rewrite finding **still stands**: an explicit oversized cap is clipped in place and remains clipped after timing relaxation; zero cap recomputes.

## Engineering implications and bounded falsifiers
1. Treat both **HAL request** and **integer register plus firmware interpretation** as distinct quantities. If a drive requires a minimum high/low duration, this N+1 contract is more conservative than an N-clock interpretation for nonnegative requests, but zero-count and board-version behavior must still be validated.
2. Do not automatically patch the driver to `ceil` or `round`: a register containing N yields N+1 nominal periods for these two pulse registers. Correctness depends on intended minimum, module clock and firmware revision.
3. A future max-rate correction would need to use the *effective* pulse and idle durations, account for other StepGen constraints, and avoid changing existing `maxvel=0` behavior without regression tests.
4. Falsifiers: selected bitfile differs from this regmap; HDL uses different N+1 semantics; firmware clamps zero; DDS/stepgen rate independently saturates; or the actual clock is not the one used in the worksheet. Inspect exact HDL/bitfile and a disconnected hardware waveform before asserting physical consequences.

**Evidence:** SOURCE-CONFIRMED host C; SOURCE-CONFIRMED firmware register-map text; calculated cross-layer INFERENCE for nominal rate; TEST-CONFIRMED none. No builds, HDL simulation, FPGA, HAL, runner, machine or Actions. Independent safety authority and existing OpenPressBrake G0/G1 HOLD unchanged.
