# S01 Adversarial Exam, Corrections, and Fresh-AI Handoff

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

## Exam

1. An external safety relay opens the signal feeding `iocontrol.0.emc-enable-in`. Source and Lab 011 show Task ESTOP and `motion.motion-enabled=FALSE`. May an engineer conclude that motor torque is removed? Explain the missing boundary.
2. During the same external assertion, `iocontrol.0.user-enable-out` remains TRUE. Does that falsify the E-stop response? Explain using the source path.
3. After the external input returns TRUE, Task reports ESTOP OFF but `motion.motion-enabled` remains FALSE. Is this a bug or the expected restart boundary?
4. A design uses a HostMot2 watchdog bite as its only emergency-stop safety function. What evidence would be required before calling that function safety-rated, and what does the 1000-level curriculum currently establish?
5. Misleading premise: “LinuxCNC is realtime, therefore its E-stop response time is deterministic enough to assign a machine stopping time.” Identify at least three unsupported steps in that claim.
6. Debugging scenario: an operator reports that the GUI says ESTOP while a drive still produces torque. Give the first three evidence layers to inspect without assuming which layer failed.
7. Bounded modification task: add a diagnostic lamp that indicates LinuxCNC controller ESTOP. State why its label/documentation must not call it an STO or safe-torque indicator.

## Correction key

1. **No.** The experiment ends at controller/HAL state. Physical torque removal depends on downstream HAL/HostMot2/drive wiring and, for a safety function, independently designed and validated safety hardware such as appropriate STO/contactor/brake architecture.
2. **No.** Pinned source shows external `emc-enable-in=FALSE` is sampled into `io.aux.estop` and handled by Task subordinate-state synchronization. That path does not call `emcAuxEstopOn()`, which is the controller-originated path that drives `user-enable-out`. Lab 011 predicted and observed `user-enable-out=TRUE` during external assertion.
3. **Expected.** Lab 011 confirms release clears the external ESTOP condition but does not automatically restore Machine ON. A deliberate enable action remains required.
4. A safety-rated claim needs applicable standards/hazard analysis, hardware/firmware safety data, architecture/category/diagnostic-coverage evidence, failure-mode analysis, and validation on the actual machine. Current work establishes ordinary HostMot2 watchdog host behavior and documented fail behavior boundaries, not a certified safety function.
5. Unsupported conversions include: realtime scheduling -> bounded Task response; controller response -> transport/output response; output response -> drive torque removal; and torque removal -> machine stopping time. Physical inertia, hydraulics/mechanics, brakes/contactors and validation are outside the software experiment.
6. Inspect (a) controller state and external-input provenance, (b) HAL/output command and communication freshness/fault state, and (c) drive/STO/contactor/brake physical state. Do not infer the third from the first.
7. A controller-ESTOP lamp may truthfully display controller state. Calling it STO/safe torque would assert a physical safety state that the source and software experiment do not observe.

## Fresh-AI novel scenario

Scenario: A machine has two independent servo drives. LinuxCNC receives a common external E-stop input and Lab-011-like testing shows `motion.motion-enabled` falls. One drive's STO wiring is later found disconnected.

Required reasoning: S01 predicts that LinuxCNC can still show a correct ESTOP/controller-disable state even though the physical safety function is defective. The controller observation is useful diagnostic evidence but cannot validate the disconnected drive's torque-removal path. The fresh engineer must trace the physical safety chain separately and must not “fix” the discrepancy by changing LinuxCNC semantics.

**Fresh-AI result: PASS.** The source guide + call flow + accepted experiment let a new engineer distinguish command/status/diagnostic state from physical risk reduction and handle a novel downstream safety failure without inventing a LinuxCNC guarantee.

## Graduation decision

S01 **GRADUATES at 1000 level**. Core mechanism is source traced; Lab 011 independently verifies the representative external-input controller transition and predeclared prediction; failure/misinterpretation boundaries are explicit; adversarial questions pass; and the fresh-AI scenario preserves the functional-safety boundary.

Promotions remain valid because even if their detailed outcomes differ, the central S01 teaching remains: LinuxCNC controller state is not itself evidence of a validated physical functional-safety function. Machine-specific standards applicability, physical E-stop/STO/brake/contactor reaction, stopping time, and controller latency distributions therefore do not overturn this 1000-level conclusion.