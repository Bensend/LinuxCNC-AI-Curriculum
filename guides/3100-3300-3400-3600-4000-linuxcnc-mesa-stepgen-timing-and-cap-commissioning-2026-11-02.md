# Mesa HostMot2 stepgen timing and velocity-cap commissioning — STEPGEN-153
**LinuxCNC 4000 implementation guide | mill, plasma, router, press-brake transfer | 2026-11-02**

Use alongside [STEPGEN-153 pinned source investigation](../research/4400_LINUXCNC_STEPGEN_153_MESA_NS_TO_TICKS_TRUNCATION_AND_MAXVEL_LATCH_SOURCE_AUDIT_2026-11-02.md). This guide is a **disconnected design review**, not a machine startup authorization. Do not change live pulse timing on an energized drive.

> **Firmware contract correction:** [STEPGEN-154](../research/4400_LINUXCNC_STEPGEN_154_FIRMWARE_NPLUS1_PULSE_AND_HOST_MAXRATE_RECONCILIATION_2026-11-02.md) inspected pinned HostMot2 firmware `src/regmap` and found pulse active/idle registers encode **N+1 clock periods**. At hypothetical 100 MHz, HAL 15 ns → host register 1 → **nominal 20 ns**, not 10 ns. This is register-map evidence, **not an actual bitfile waveform measurement**. Host `physical_maxvel` still uses the original requested ns and can exceed the rate inferred from N+1 pulse periods.

## Architecture and parameter ownership
`joint.N.motor-pos-cmd` (motion) → optional PID/position control HAL → `hm2_<board>.0.stepgen.NN.position-cmd` → HostMot2 velocity planning/limit → step-rate DDS TRAM → Mesa FPGA → STEP/DIR output → external stepper/servo drive. The HAL `stepgen.NN.position-fb` and `velocity-fb` do **not** independently confirm actual motor travel. For a real wiring example, follow the existing [MR-1 7i96S source/config audit](../research/4400_LINUXCNC_HAL_20_MR1_7I96S_PID_PROBE_SSR_POSTGUI_ORDER_SOURCE_AUDIT_2026-10-31.md); do not assume its timing values or pin assignments match another board.

The driver uses four independent unsigned nanosecond HAL parameters (`steplen`, `stepspace`, `dirsetup`, `dirhold`) and a separate `maxvel` in position-units/second. It converts ns to **integer FPGA clock counts** in `stepgen.c`. A requested ns number is not the integer register count, and a software feedback pin is not an oscilloscope.

## Worksheet: freeze machine-specific inputs first
Record: LinuxCNC tag/commit; HostMot2 board and FPGA bitfile/version; module-descriptor clock in Hz; drive model and manufacturer STEP-high/STEP-low/DIR-setup/DIR-hold minima; polarity; `position-scale` in steps/machine-unit; `[JOINT_N]MAX_VELOCITY`/`MAX_ACCELERATION`; `stepgen.NN.maxvel`/`maxaccel`; four timing HAL values; actual HAL `addf` order; isolated test/measurement setup. **Do not substitute** a nominal Ethernet-link rate, servo-thread frequency, or PC CPU clock for the FPGA stepgen module clock.

For a hypothetical 100 MHz module, tick period is 10 ns. The stable and inspected development C implementations encode `floor(requested_ns / 10 ns)` (subject to the 0x3FFF register limit). A 15 ns input becomes host count 1; under the inspected firmware register-map contract, that means **2 nominal clock periods = 20 ns** for STEP active/idle. The exact selected bitfile/waveform remains unmeasured.

## Practical source/review exercise
1. Open pinned LinuxCNC v2.9.10 `src/hal/drivers/mesa-hostmot2/stepgen.c` blob `8eb43d9a7d8e42573ef653cb82460609d2864ae4`. Find `hm2_stepgen_parse_md` (module clock), `hm2_stepgen_instance_prepare_tram_write` (physical limit, clamp and `velocity-fb`), `hm2_stepgen_update_pulse_width` (ns-to-register conversion), `hm2_stepgen_write` (changed-register output), and `hm2_stepgen_force_write` (startup/replay).
2. On paper, compute register counts for requested `steplen` = 9, 10, 15, 25 and 100 ns with 100 MHz; expected = **0, 1, 1, 2, 10**. Calculate corresponding counts for the other three timing parameters independently.
3. Calculate `physical_maxvel = 1e9 / ((steplen_ns + stepspace_ns) * abs(position_scale))`. For 1000 ns + 1000 ns and 1000 steps/mm, the cap is **500 mm/s**. An explicit HAL `maxvel=600` is rewritten to 500; changing the two timing parameters to 500 ns each raises the *calculated* physical cap to 1000 but leaves explicit `maxvel=500`. `maxvel=0` uses the newly calculated cap.
4. Trace the actual `llio->write` transport separately for PCI versus Ethernet. Do not infer simultaneous register application or actual electrical pulse width from one host callback.
5. Identify which observed value is **HAL request**, **HAL mutated readback**, **host integer register**, **FPGA pin waveform**, and **drive feedback**. Treat each as a separate witness.

## Bounded qualified-compute acceptance (all NOT RUN)
Only after verifying an actually isolated `[self-hosted, openpressbrake]` runner, use a fake LLIO or simulation without physical drive outputs. No hosted fallback. Freeze expected values before execution.

| Case | Input/change | Predicted C-side witness | Distinct question |
|---|---|---|---|
| A | 100 MHz, `steplen=15` | pulse-width register = 1 | fractional truncation |
| B | `steplen=10` | register = 1 | exact boundary |
| C | `steplen=9` | register = 0 | zero-count firmware interpretation remains UNKNOWN |
| D | `dirsetup=25`, `dirhold=25`, `stepspace=25` | each corresponding register = 2 | all four conversions |
| E | `maxvel=600`, 1000/1000 ns, scale 1000 | HAL cap rewritten 500 | persistent explicit cap |
| F | after E, relax to 500/500 ns | HAL cap still 500 | no automatic restoration |
| G | set `maxvel=0` at 500/500 ns | effective cap 1000, HAL parameter remains 0 | auto-cap mode |
| H | `maxvel` smaller than calculated cap | no upward rewrite | user-imposed cap |

Preserve source/bitfile SHA, clock, register captures, parameter readbacks, test harness hash, runner isolation, stdout/stderr, and actual job start/end metadata. A fake LLIO validates the **C-side oracle**, not pulse timing. Physical scope verification would require a separately authorized, isolated engineering test and exact FPGA firmware; it is **not** a personnel-safety proof.

## Commissioning decision tree
If the drive datasheet specifies minimum pulse widths, first calculate clock-period-aligned **conservative** HAL requests with headroom; then verify what the specific FPGA actually emits. If the desired `maxvel` is meant to follow step-timing changes, set `maxvel=0` and independently limit machine motion in joint/trajectory settings. If a fixed explicit cap is required, recheck and reapply it after timing changes. A postprocessor's feed rate is **not** an actuator pulse timing guarantee.

For plasma/routers with long travel, high `position-scale` magnifies the impact of a pulse-rate cap. For mills/lathes, compare against axis acceleration and stepper drive timing. For OpenPressBrake, this is ordinary controller engineering only: do not weaken independent safety authority or the current G0/G1 hold.

## Transfer questions for another AI engineer
1. A 125 MHz module receives a 17 ns `steplen` request. What integer register and regmap nominal duration are predicted? **Answer for reviewer:** N=2, nominal **3×8 ns = 24 ns** for STEP active. This is not a measured waveform. DIR setup semantics need separate HDL verification.
2. An operator increases STEP pulse width and sees `maxvel` silently reduced. Later they restore the old pulse width, but the speed remains limited. Which function writes back the cap, and what HAL parameter must be checked?
3. Why would a successful fake-LLIO test and a firmware N+1 register map still be insufficient to claim that the installed drive receives a compliant STEP pulse?
4. Why would blindly changing the host conversion to upward rounding be unjustified under an N+1 pulse register contract? What actual bitfile/HDL and measurement evidence is still needed?

**Evidence status:** SOURCE/DOC-CONFIRMED for formulas, types and branch logic; numerical oracles computed from source; TEST-CONFIRMED none. Earlier graduated levels and independent safety/evaluation gates unchanged.
