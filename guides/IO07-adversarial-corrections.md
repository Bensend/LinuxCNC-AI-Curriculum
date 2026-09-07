# IO07 — adversarial exam answer key and correction pass

Course level: 1000  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Checked answers

1. `emcmotController()` runs in the motion servo context. `process_inputs()` samples HAL `joint.0.amp-fault-in` into JOINT_FAULT. `check_for_faults()` sees the active+enabled joint fault, reports the amplifier fault, sets JOINT_ERROR, and clears desired enabling. `set_operating_mode()` then disables active joints and clears motion-enable state. Later `output_to_hal()` publishes the joint enable flag as `joint.0.amp-enable-out = FALSE` and publishes fault/error/motion status.

2. `amp-enable-out = FALSE` proves only LinuxCNC command intent at that HAL boundary. A physical claim additionally needs the downstream HAL net, module/transport delivery, drive input semantics, actual drive reaction, stored-energy behavior, timing, and—if a safety claim is intended—certified devices/architecture and hazard/PL/SIL validation. The original source guide already states this correctly; no safety correction was required.

3. No. LLIO `io_error` is a HostMot2 transport/recovery state and is not automatically transformed into motion's `joint.N.amp-fault-in`. An unchanged amp-fault input can be stale if the hardware input path is no longer updating. Debug transport freshness and any separately wired watchdog/fault logic before treating FALSE as fresh proof of drive health.

4. The pinned controller order samples inputs, checks faults, changes operating mode, and publishes outputs during the same `emcmotController()` invocation. Therefore an input sampled TRUE can produce disabled published motion/joint state that invocation. A later HAL function observes it according to thread order; asynchronous/userspace tools add scheduling/query latency, so “same controller invocation” is not a universal wall-clock response guarantee.

5. Clearing the external source permits `process_inputs()` to clear the current JOINT_FAULT flag on a later cycle, but that does not imply automatic re-enable. Joint error/disabled machine state exists to preserve the reason for shutdown and normal recovery/re-enable command semantics must be followed. Observe `faulted`, `error`, `motion.motion-enabled`, and `amp-enable-out`; do not infer all from one bit.

6. A HAL net may feed a generic output-module enable such as PWMGen/related HostMot2 command logic, or feed an enable-like descriptor field on a Smart-Serial servo interface. IO04/IO05 establish these as command/data paths. Their electrical disabled state and actual torque behavior are device/firmware/interface dependent, and neither is automatically a certified STO channel.

7. Historical/community behavior is an investigation lead. Verify current official documentation and pinned source, then reproduce the behavior if material and practical. Record any real version difference explicitly with both revisions/evidence; never silently import historical semantics into `8bf4605...`.

8. A suitable simulation uses one HAL output pin as the sole writer to a named signal, with that signal connected to `joint.0.amp-fault-in`; e.g. a realtime logic component whose input is toggled by `setp`, while its output owns the fault signal. Require a demonstrably enabled baseline, proof of source/signal/destination connectivity, pre-injection fault FALSE, and after injection require fault/error TRUE plus motion/amp-enable FALSE. Capture the amplifier-fault diagnostic and exact revision/run metadata. This is the arrangement implemented by lab job `010` using `or2.0.out` as the single writer.

9. First establish LinuxCNC motion/error state and why it disabled; then verify the HAL net to the downstream enable; then verify HostMot2/Smart-Serial/transport health and whether the disable command was actually delivered; then inspect drive alarm/status and device-specific enable/STO inputs; finally investigate power stage/contactors/STO and stored energy electrically. A FALSE software enable bit is neither proof of a LinuxCNC defect nor proof of safe torque removal.

10. A passing headless simulation may TEST-CONFIRM that the pinned LinuxCNC software/HAL path, in that simulation, changes from an enabled baseline to joint fault/error asserted and motion/joint amplifier-enable intent deasserted after the synthetic amp-fault signal is asserted, with the expected diagnostic. It may not establish HostMot2 transport delivery, FPGA behavior, drive disable, physical torque-removal time, STO, contactor behavior, electrical fail state, realtime physical latency, or functional-safety compliance.

## Adversarial correction findings

The source guide and call-flow guide survived the safety and transport-boundary challenges. One wording precision is reinforced for future handoffs: **“same controller invocation” describes source ordering, not a measured physical or even userspace-observation response time.** Another reinforced point is that a FALSE fault input during communication failure can be stale and must not be treated as fresh negative evidence.

The experiment design was checked against the exam's single-writer requirement before launch. `lab-jobs/010-io07-amp-fault-disable.sh` uses `or2.0.out` as the sole writer of `io07-amp-fault`, and toggles only `or2.0.in0` for injection.

## Exam result

**PASS — source/call-flow reasoning and safety-boundary reasoning.** Final IO07 graduation remains contingent on reconciling the planned experiment result and producing the fresh-AI handoff; the exam does not substitute for experiment evidence.
