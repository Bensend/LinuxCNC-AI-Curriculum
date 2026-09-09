# C09 — architecture handoff answer

## Architecture

Use LinuxCNC as the ordinary machine-control system and keep the external safety system independent of LinuxCNC's normal control/status path.

The realtime servo graph owns the two actuator loops. A common coordinate/trajectory command may feed both loops, but actuator A and actuator B retain separate feedback, controller state and hardware command paths. Any synchronization/cross-coupling term whose correctness depends on servo-period timing runs in the same realtime graph with an explicitly documented function order. Hardware read occurs early enough to provide the intended cycle's feedback; control/cross-coupling consumes that state; hardware write follows the computed outputs. The exact order must be verified in the implementation rather than inferred from component names.

Task/NML/userspace owns supervisory command sequencing, modes, program/operator interaction and status distribution. The UI requests operations and displays returned state; it does not close the actuator servo loops or become the only fault-response path.

## Feedback and disagreement

Compute A/B measured disagreement from the two independent feedback channels and retain both raw feedback values as well as the derived disagreement. Cross-coupling may bias the two actuator commands to reduce measured disagreement, subject to bounded controller/output authority.

Do not call either encoder a truth sensor for the other. Agreement means the reported measurements agree; it does not prove both sensors are mechanically coupled correctly or that the physical structure is aligned. Likewise disagreement identifies a measurement/control inconsistency but does not by itself distinguish asymmetric plant response, sensor error, mechanical decoupling, drive limitation or another physical cause. Physical conclusions require independent evidence.

## Requests, achieved state and authorization

Model request, achieved state and cycle authorization separately.

A start/enable operation creates a fresh request edge only when current prerequisites and a fresh cycle authorization permit it. The sequencer does not advance merely because it emitted that request. It waits for the corresponding achieved/returned state. If the controller rejects the request, or a prerequisite remains false, the sequence remains blocked.

When an active fault occurs, revoke the current cycle authorization immediately in the ordinary control state machine and command the appropriate non-safety recovery/stop behavior. Clearing the fault or restoring a prerequisite does not recreate that authorization and does not silently retry an earlier request. A new operator/supervisor authorization is required, followed by a new request and confirmation of the new achieved state.

## Transport and watchdog handling

Maintain separate fault records for Ethernet/transport health and watchdog evidence. Packet/read failures may escalate to an `io_error`-class state. Watchdog bite evidence is accepted from the watchdog status path when communication is healthy enough to observe/process it.

Do not synthesize `watchdog.has_bit` merely from packet loss. Communication loss can prevent watchdog service and therefore can cause a later watchdog bite, but the two states are not identical. During broken transport, a false/unchanged watchdog indication is not proof the FPGA watchdog did not bite because its current status may be unavailable. Restored Ethernet proves only that communication has recovered sufficiently for the observed operation; it does not prove watchdog recovery, achieved machine state, fresh authorization, actuator condition or physical safety.

## Diagnostics

Retain an ordered realtime trace containing the minimal discriminating state: phase/state identifier, A/B commands, A/B feedback, disagreement/cross-coupling term, relevant enables/fault bits, transport fault state, watchdog state when observable, and authorization/achieved-state projections that are legitimately available at that boundary. Record the sampler's function order relative to producers and retain producer-side overrun/loss telemetry plus collector attach/exit/error information.

Use Task/NML/error-channel/process logs as additional correlated evidence. Do not claim that nearby log timestamps and realtime samples form one atomic global timeline unless an explicit synchronization mechanism establishes that relationship. Sequential `halcmd` reads are diagnostic snapshots, not same-cycle evidence. Contiguous consumer sample tags alone are not a no-loss proof at the pinned capstone revision without producer-overrun evidence.

## Safety boundary

The external safety system owns safety-rated stop/interlock/restart authority. LinuxCNC can request ordinary controlled stops, inhibit ordinary sequence progression, expose fault diagnostics and withhold normal actuator commands, but those mechanisms are not treated as functional-safety certification. A LinuxCNC logical reset, clean encoder reading, cleared `io_error`, cleared watchdog indication or successful new state request does not prove the physical plant is safe to restart.

## First verification tests

1. Run both loops with a common command and an asymmetric plant response; verify retained same-cycle evidence shows independent feedback/control and expected disagreement behavior.
2. Inject feedback freeze, jump and common-mode/plausible agreement faults; verify the diagnostic logic does not claim physical alignment solely from sensor agreement.
3. Issue an ON/start request with a prerequisite blocked; verify the request occurs but achieved state does not, then restore the prerequisite and verify no silent retry occurs.
4. During an authorized cycle inject a fault, restore the prerequisite, and verify the old authorization remains consumed until a fresh authorization and request produce a newly confirmed achieved state.
5. Inject transport failure without independently asserting watchdog status, then independently exercise watchdog status when observable; verify the records remain distinct and network recovery does not auto-resume state.
6. Force recorder pressure/overflow in a bounded diagnostic test; verify producer-side overrun evidence prevents a false no-loss conclusion even when retained consumer tags appear contiguous.
7. Break or stall the UI/status presentation while observing controller state independently; verify UI freshness failure does not become controller-state truth.
8. On physical hardware, separately validate sensor coupling, actuator authority, mechanical response and the external safety system before commissioning. Software-lab success is not substituted for those tests.

## End-to-end failure/recovery trace

Assume a cycle has fresh authorization and both actuators are running from achieved enabled state. Ethernet reads then begin failing. Transport error evidence escalates and the ordinary control sequencer revokes the current cycle authorization and inhibits continued sequence progression. The diagnostic record marks transport failure; it does not invent a watchdog bite. Because communication is unavailable, current watchdog status may be unknown even if the last software-visible `has_bit` value was false. The independent safety system remains the authority for any safety-rated removal of hazardous energy.

Ethernet communication later returns. The software may now reacquire board/watchdog state and perform the documented ordinary recovery path, but it does not resume the old cycle. The pre-fault authorization remains consumed. The system re-establishes prerequisites and checks returned/achieved state. Only after a new authorization is issued does it emit a fresh start/enable request, and it waits for achieved-state confirmation before normal sequencing advances. Even then, the architecture makes no claim that software recovery alone proves the physical machine safe; commissioning/safety policy may require additional external or physical checks.

## Explicit unknowns

Exact hardware drive semantics, sensor diversity/common-cause behavior, physical stopping performance, network electrical robustness, watchdog firmware/version details beyond the pinned evidence, and external safety-system certification are hardware/version-specific. They require their own source, vendor, physical or certification evidence and are not invented here.
