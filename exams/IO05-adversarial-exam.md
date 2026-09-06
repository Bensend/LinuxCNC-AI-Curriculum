# IO05 adversarial exam — analog-servo interface patterns

Pinned revision: `8bf4605ae81042248add031e94c77300406e0413`

## Questions

1. A 7I77 `analogout0` HAL pin changes from 0 to 5, but the voltage at the drive input remains 0 V. Explain why that observation does **not** prove a bug in LinuxCNC's numeric scaling code. Give the host-side call path and at least four downstream/failure boundaries that must be separated.

2. Misleading premise: "All Mesa +/-10 V outputs are HostMot2 PWMGen outputs, so `offset-mode=1` is required for a 7I77." Refute this using the pinned architecture.

3. For a writable `LBP_SIGNED` Smart Serial field, trace how a HAL real command becomes packed bits. Where are `minlim`, `maxlim`, `scalemax`, `DataLength`, and descriptor order used?

4. How is a writable boolean field such as `analogena` related to `analogoutN` in the generic host implementation? Is its absolute bit offset a LinuxCNC constant?

5. Failure-path trace: the previous Smart Serial Do-It command has not cleared before the next servo-thread execution. What does `hm2_sserial_write_pins()` do, and why can HAL still display the requested analog value while the remote has not received a fresh command?

6. Persistent Smart Serial faults exceed `fault-lim`. What state transition occurs and what is required for the state machine to leave the serious-error state?

7. Version/evidence question: current `sserial(9)` documents full-scale voltage examples for 7I77. Does that make physical +/-10 V behavior TEST-CONFIRMED at pinned revision? Explain the evidence class and boundary.

8. Small modification task: you want to add a diagnostic HAL pin indicating that normal Smart Serial output packing was skipped because the previous Do-It had not cleared. Identify the production function/branch where the diagnostic should be updated and explain why adding it in the generic `hm2_write()` function would be less precise.

9. A user sets `analogout0-scalemax = 0`. What does the pinned source guarantee? What should 1000-level guidance say, and why should exact floating-point/cast fallout be promoted rather than relied upon?

10. A fresh AI sees `hm2_7i92.0.7i77.0.1.analogena=true` and concludes the servo drive is safely enabled. Identify at least four distinct layers that statement improperly collapses.

## Answer/correction key

1. Host path is HAL command -> `hm2_sserial_prepare_tram_write()` -> `hm2_sserial_write_pins()` -> clamp/scale/pack into `chan->write[]` -> Do-It command image -> HostMot2 TRAM -> LLIO. Separate Smart Serial state/faults, generic transport `io_error`, FPGA/remote protocol, remote DAC/electronics, wiring/power, analog enable, amplifier enable/fault, and physical drive behavior.

2. 7I77 analog outputs are Smart Serial numeric outputs, not generic PWMGen. `offset-mode` belongs to HostMot2 PWMGen interfaces where centered duty is the correct board-level representation. Projecting that parameter onto a 7I77 is architecturally wrong.

3. The HAL real is clamped to `minlim/maxlim`, divided by `scalemax`, converted to a signed full-scale integer, shifted/masked to `DataLength`, then inserted by `setbits()` at the running bit offset established by preceding writable descriptors.

4. Generic writable booleans are packed in the same descriptor walk. `analogena` therefore shares the process-data image when represented as a writable boolean descriptor, but its exact offset/order is remote-descriptor data, not a universal LinuxCNC constant.

5. The fault accumulator is incremented, the command image is marked ignored with bit 31, and the function returns before fresh normal packing. HAL pin storage is independent of whether the remote accepted a new transfer.

6. The port enters state 10 and queues a stop. State 10 remains inert until the Smart Serial `run` pin is cleared; then the state machine returns to idle and can later restart.

7. No. It is DOC-CONFIRMED intended/public board behavior, not cloud TEST-CONFIRMED physical output. The current module does not energize representative hardware.

8. Update the diagnostic in `hm2_sserial_write_pins()` at the branch where `*inst->command_reg_read` remains nonzero and the function returns. Generic `hm2_write()` does not know the Smart Serial protocol-specific reason a remote update was skipped.

9. The local signed/unsigned output path has no explicit zero/NaN/Inf guard before division/cast. The guide must require finite nonzero scale and must not promise pathological behavior. Exact compiler/runtime consequences belong in 2000-level fault/adversarial testing.

10. It collapses HAL requested state, Smart Serial packing/transfer, remote board enable-output electronics, drive enable input/electrical wiring, drive fault/STO state, and functional-safety architecture.

## Grade

PASS for the 1000-level objective. The correction pass reinforced that analog-enable semantics, command freshness, and physical/safety behavior must remain separate from the HAL value and from generic Smart Serial packing.
