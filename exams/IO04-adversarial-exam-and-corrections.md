# IO04 adversarial exam, graded answer and corrections

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Exam

### Q1 — call-chain reconstruction

A HAL servo thread contains a HostMot2 board's `write` function. `hm2_7iXX.0.pwmgen.00.value` changes from +0.2 to -0.4 while scale is 1, enable stays true and no configuration parameter changes. Trace the host path to the hardware-facing boundary and identify which PWMGen writes are expected to be cyclic versus change-detected.

### Q2 — misleading premise

"When `pwmgen.00.enable` goes false, the PWM output must become 0% duty immediately, so observing 50% duty proves HostMot2 ignored enable." Explain why this premise is unsafe.

### Q3 — same-cycle state change

In one servo invocation both `value` changes and `enable` changes true→false. Is this one atomic PWMGen register operation? Describe source ordering and what can and cannot be concluded about physical timing.

### Q4 — failure path

HAL command is correct, but `llio->io_error` is already asserted when `hm2_write()` begins. What PWMGen host work occurs? What stale state might still be visible in HAL or hardware-facing registers, and what must the debugger not conclude?

### Q5 — configuration repair

A user writes an invalid `output-type`. What does pinned source do, and why is that different from silently accepting a new firmware mode?

### Q6 — version-sensitive reasoning

Current documentation describes dither and centered offset behavior. What evidence is required before asserting identical register semantics on an old LinuxCNC/HostMot2 revision or a different firmware descriptor version?

### Q7 — bounded modification task

You need stronger runtime evidence for host PWM encoding but have no Mesa hardware. Propose the minimum useful extension to `hm2_test` and define at least five acceptance gates. State what the experiment still would not prove.

### Q8 — numeric adversarial case

A configuration sets `scale=0`. Is it valid to state that pinned HostMot2 safely clips the command to ±100%? Why or why not?

## Graded answer

### A1 — PASS

The thread invokes generic `hm2_write()`. With no `io_error`, `hm2_pwmgen_prepare_tram_write()` reads value/scale/enable and encodes the command into the PWM value TRAM image. `hm2_tram_write()` publishes the combined cyclic region. Later `hm2_pwmgen_write()` sees no configuration/enable change and returns without `hm2_pwmgen_force_write()`. Thus the changed command follows the cyclic TRAM path; mode/enable/rate registers are not rewritten solely because the command changed.

### A2 — PASS; correction-worthy distinction preserved

Disable first forces the host scaled command to zero. In offset mode, zero is then encoded at the centered midpoint, i.e. 50% duty. The separate PWMGen enable bit is also updated on the slow path. Therefore 50% duty can be the intended centered command image while the downstream hardware enable is deasserted. Physical zero volts / high impedance / pin-low behavior is board/interface-specific.

Correction incorporated into the guide: use the four separate concepts **HAL enable**, **zero command**, **PWM duty**, and **physical analog/output state** rather than the ambiguous phrase "PWM off".

### A3 — PASS

`hm2_pwmgen_prepare_tram_write()` sees the new enable state before the combined TRAM write and encodes a zero command (or midpoint in offset mode). Only afterward does `hm2_pwmgen_write()` detect the changed enable and call `hm2_pwmgen_force_write()` for the enable/mode/rate direct writes. These are distinct host transactions. Exact transport/FPGA/electrical timing is not established by this source-level ordering alone.

### A4 — PASS

Generic `hm2_write()` returns immediately when `io_error` is set, so PWM prepare/TRAM/configuration publication does not begin. Existing HAL inputs may still show the user's command because HAL state is not proof of successful board publication; hardware-facing state may remain from the last successful cycle or evolve according to transport/watchdog/firmware behavior. A debugger must not infer successful output from a correct HAL command.

### A5 — PASS

`hm2_pwmgen_force_write()` diagnoses an unsupported output type, rewrites the HAL parameter to standard PWM+Direction and constructs that known mode. This is explicit error repair, not extensible acceptance of unknown firmware modes.

### A6 — PASS

Need source inspection at the target LinuxCNC revision plus applicable firmware/module-descriptor documentation or HDL. Current documentation is DOC-CONFIRMED for the current public interface; pinned source is SOURCE-CONFIRMED only at its recorded SHA. Firmware version differences, especially dither support, must not be generalized silently.

### A7 — PASS

Minimum legitimate synthetic fixture:

1. add a valid PWMGen module descriptor/pin map to a fake-board pattern so normal `hm2_pwmgen_parse_md()` runs;
2. instrument LLIO write/TRAM capture with address+payload while preserving production HostMot2 execution;
3. drive HAL pins/params through normal exported interfaces.

Acceptance gates should include command scaling/clipping, sign encoding, disabled normal-mode zero, disabled offset-mode midpoint, output-type mode bits, PDM/PWM width distinction, changed-enable slow write, unchanged-config no duplicate slow write, invalid-mode repair and `io_error` retry behavior.

It would still not prove FPGA waveform generation, physical duty timing, Ethernet/PCI behavior, daughtercard voltage/current, watchdog electrical state or safety.

### A8 — PASS; guide strengthened

No. Pinned source performs `value / scale` without an explicit zero guard. Floating exceptional values can therefore flow into clipping tests and later floating-to-integer conversion. It is unsafe to promote a deterministic supported behavior without a targeted compiler/runtime experiment. The correct engineering rule at 1000 level is: **do not use zero/non-finite scale; treat that behavior as unresolved/adversarial**.

## Adversarial correction summary

The exam did not overturn the main call flow. It did expose wording that could encourage a fresh AI to collapse several states into "PWM off." Durable correction:

- `enable=false` is not defined here as physical pin-low;
- zero command is not always 0% duty;
- 50% duty can intentionally mean zero analog command in offset mode;
- successful HAL command state is not proof of successful board output;
- `scale=0` is not assigned a made-up safe semantic.

## Result

**PASS.** The IO04 1000-level host command-path understanding survived misleading-premise, failure-path, version, fixture-design and numeric-adversarial questions without requiring unsupported physical claims.