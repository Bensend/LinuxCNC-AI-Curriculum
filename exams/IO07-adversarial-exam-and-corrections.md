# IO07 adversarial exam and corrections

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

## Exam

A passing answer must preserve evidence boundaries and must not silently promote software state to physical or safety evidence.

1. A machine is enabled and `joint.0.amp-fault-in` becomes TRUE. Give the pinned controller call-flow from HAL input sampling through the published disabled outputs.
2. The final userspace poll after the fault reports `joint.0.faulted=TRUE`, `joint.0.error=FALSE`, `motion.motion-enabled=FALSE`, and `joint.0.amp-enable-out=FALSE`. Does `error=FALSE` disprove the fault-disable path? Explain.
3. `joint.0.amp-enable-out` becomes FALSE. What exactly is confirmed, and what important physical conclusion is *not* confirmed?
4. A HostMot2 Ethernet communication failure asserts LLIO `io_error`. May this automatically be described as `joint.0.amp-fault-in`? Why or why not?
5. A drive offers STO inputs. Is routing LinuxCNC `amp-enable-out` to an ordinary drive-enable input equivalent to using STO? State the evidence needed for a safety claim.
6. The GitHub Actions run for a lab is red, but the lab artifact contains exit code 0 and all experiment assertions passed. What should be classified as failed?
7. Why did IO07 use a realtime sampler rather than asynchronous `halcmd getp` as the oracle for the transient `joint.0.error` state?
8. What preconditions make the accepted IO07 fault injection stronger than merely setting a HAL bit and observing a later disabled state?
9. An operator says, “LinuxCNC disabled the drive in the same servo period, therefore torque was removed within one servo period.” Identify the inference error.
10. A diagnostic display shows an unchanged `amp-enable-out` or feedback value during an I/O communication fault. What freshness question must be answered before interpreting it as current hardware state?

## Correction key

### 1 — Correct call flow

`joint.0.amp-fault-in` is sampled by `process_inputs()` into the internal joint fault state. `check_for_faults()` sees the active+enabled joint fault, reports an amplifier-fault diagnostic, sets joint error and clears desired enabling. `set_operating_mode()` then disables active joint/motion state. `output_to_hal()` publishes the resulting `joint.0.amp-enable-out=FALSE` and `motion.motion-enabled=FALSE` later in that controller invocation.

Correction: do not skip directly from the HAL input to the output bit; the intermediate fault/enabling/state-machine stages are the behavior being taught.

### 2 — `joint.error` is not a permanent latch oracle

No. The corrected realtime capture observed two servo samples with `faulted=1`, `error=1`, motion disabled, and amp enable false, followed by many samples with `faulted=1`, `error=0`, motion disabled, and amp enable false. A late userspace poll can therefore miss the transient error assertion.

Correction: an asynchronous snapshot cannot disprove a transient state that occurred between polls.

### 3 — Command intent versus physical result

Confirmed: LinuxCNC's HAL command/state says the amplifier path should be disabled. Not confirmed: voltage at a connector, remote-register delivery, drive input state, output-stage disable, zero torque, STO action, or safe energy removal.

Correction: `amp-enable-out=0` is software command evidence, not a torque sensor or safety proof.

### 4 — Communication faults are a separate fault domain

No. `io_error` is LLIO/HostMot2 communication state. The ordinary motion amplifier-fault path is driven by `joint.N.amp-fault-in`. A machine configuration may deliberately connect/translate communication diagnostics into motion fault logic, but that mapping must be shown rather than assumed.

### 5 — Ordinary enable is not STO

No. STO is a drive/device safety function whose validity depends on certified hardware, specified wiring and architecture, diagnostic coverage, reaction time, required PL/SIL/category, and machine hazard/risk analysis. Naming or netting an ordinary HAL signal does not confer those properties.

### 6 — Infrastructure failure versus experiment failure

The result-publication/commit infrastructure failed; the experiment passed. The accepted run had lab exit code 0 and passed its assertions. The workflow's final red conclusion came from the later repository-commit step. Both outcomes must be recorded independently.

### 7 — Sampling reason

The state of interest can exist for only a small number of servo periods. `sampler` executes in the realtime servo thread after the motion controller and captures each cycle deterministically. Userspace `halcmd` polling has uncontrolled phase and latency and can miss that state.

### 8 — Required preconditions

The lab proved a clean enabled baseline; proved the injection signal's writer/consumer wiring; established servo-thread execution order (`motion-controller` before injector, injector before sampler); captured pre- and post-injection samples with zero sampler overruns; and required both the state transition and the LinuxCNC amplifier-fault diagnostic.

Correction: without the enabled baseline, a disabled result is not causal evidence for the injected fault.

### 9 — Same host cycle does not bound physical torque reaction

The source/test establish host controller state publication timing only. Additional latency and failure modes exist in HAL downstream functions, HostMot2/TRAM, transport, FPGA/remote hardware, drive electronics, motor/current dynamics, and safety circuitry. Physical torque-removal time requires hardware measurement and system-level validation.

### 10 — Freshness must be proven

Determine whether the relevant transport/read/write cycle actually completed successfully and whether the observed HAL value is newly published from fresh I/O. During `io_error` or skipped/failed reads, old values may remain visible.

## Adversarial verdict

**PASS after corrections.** The lesson survives the main adversarial traps:

- command intent is not physical state;
- ordinary enable/fault logic is not STO;
- `io_error` is not automatically an amplifier fault;
- late polling is not a valid oracle for a transient realtime state;
- a workflow-infrastructure failure is not automatically an experiment failure;
- same-controller-cycle publication does not establish physical stop time.

No IO07 claim is promoted beyond the evidence actually collected.
