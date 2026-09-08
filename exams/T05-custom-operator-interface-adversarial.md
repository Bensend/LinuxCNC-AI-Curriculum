# T05 — Custom operator interface patterns — adversarial exam and correction audit

Course level: **1000**  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Purpose

Test whether the T05 material supports engineering decisions rather than vocabulary recall. Answers below are checked against pinned T03/T04/T05 source artifacts and the T05-022 attempt-1 correction.

## Q1 — Misleading startup premise

**Premise:** “QtVCP has already constructed its shared `Status` object before a handler's `initialized__()` callback, so reading a cached Task state in `initialized__()` is equivalent to reading a validated current controller state.” Correct or reject, and identify the relevant source boundary.

### Answer

Reject. Pinned `_GStat.__init__()` may perform a best-effort `stat.poll()+merge()` during construction, but that path does not set `_status_active=True`. Separately, pinned QtVCP screen startup calls handler `initialized__()` before its explicit `STATUS.forced_update()` synchronization point. Therefore object construction/cached state and a validated post-handler observation are distinct. A controller-dependent action should start fail-defined and require an explicit successful/current observation under the UI's freshness contract.

**Result:** PASS. This incorporates the correction exposed by T05-022 attempt 1 rather than preserving the earlier overbroad “first poll” wording.

## Q2 — HALUI lamp freshness

A physical panel lamp is wired to `halui.machine.is-on`. An engineer says, “Because it is a HAL pin, it is realtime proof that the drive power is physically on.” Diagnose the claim and trace the value's representative source path.

### Answer

Wrong on both realtime and physical-proof claims. The representative path is controller NML status -> HALUI `updateStatus()` snapshot -> `modify_hal_pins()` -> `halui.machine.is-on`. HALUI is a userspace operator-interface process. The pin projects its latest received controller status; it is not direct physical drive feedback and is not safety-rated evidence. If the operator decision requires actual contactor/drive state, use the appropriate independent HAL/hardware feedback and preserve its own freshness/fault assumptions.

**Result:** PASS.

## Q3 — Multi-producer command ownership

A QtVCP screen, HALUI pendant, and remote Python service can all send commands. The QtVCP code calls its own `wait_complete()` immediately after seeing the pendant initiate MDI and treats the return as proof that the pendant's command completed. What is structurally wrong, and what architecture should replace it?

### Answer

`wait_complete()` belongs to a command producer's command/serial context; it is not a universal completion oracle for another producer's command. Multiple producers need an explicit ownership/correlation design. Prefer one command gateway where practical. Otherwise identify each producer, correlate semantic results to the matching command/serial/status transition, and never infer another producer's completion from the local producer's `wait_complete()`. Physical effects remain a separate oracle.

**Result:** PASS. Full race behavior is appropriately promoted to 2000-level study, but the 1000-level ownership rule is sufficient.

## Q4 — Diagnostic ownership failure

Two custom processes independently call `linuxcnc.error_channel().poll()` and each assumes it will see every operator error. What failure is possible and what robust pattern should be used?

### Answer

Treat the error channel as a diagnostic-consumer ownership problem, not as an assumed broadcast log. Competing consumers can make “absence of a message” an invalid success oracle. Assign one deliberate consumer and fan diagnostics out explicitly if multiple presentations need them, or otherwise define the exact supported arbitration mechanism. Grade command success from matching semantic status/result, not from whether a popup appeared.

**Result:** PASS. Detailed fan-out mechanics remain promoted 2000 HIGH.

## Q5 — Status-loss after a previously good observation

A custom action was correctly enabled after a valid observation. Status polling then fails for three seconds while the screen remains responsive and retains the old state. Should the action remain enabled because “it was valid once”?

### Answer

Not by default. Freshness is temporal. The UI needs a validity/age policy: on observation failure or expiry of the allowed age, controller-dependent advisory actions should transition to their declared fail-defined state, typically disabled, and stale/unknown presentation should be visible. This does not replace Task/controller enforcement or a safety system.

**Result:** PASS.

## Q6 — Safety-function trap

A designer disables the GUI “Cycle Start” button whenever a guard-open status is displayed and calls this the machine's guard safety function. Identify at least four independent reasons the claim is unsound.

### Answer

1. Widget enablement is presentation state and can be stale or incorrectly initialized.
2. The displayed controller status may not be a fresh observation.
3. Another command producer may bypass that widget entirely.
4. Command rejection/acceptance is a controller-semantic boundary below the GUI.
5. Physical actuator state is separate again.
6. Nothing in the ordinary GUI/HALUI architecture establishes a safety integrity level or safety-rated enforcement.

The actual guard safety function requires a separately justified safety architecture appropriate to the machine hazard.

**Result:** PASS.

## Q7 — Failure-path trace

Trace a failed `GStat.update()` observation at the level T05 needs and explain what a custom handler must not infer from it.

### Answer

Representative pinned path:

```text
GStat.update()
 -> self.stat.poll()
 -> exception
 -> _status_active = False
 -> emit generic periodic
 -> return without merge/state-change signal processing
```

The handler must not treat retained `old[...]` cache contents, the generic periodic callback, a responsive event loop, or an enabled widget as proof that current controller state was observed successfully.

**Result:** PASS.

## Q8 — Bounded implementation task

Sketch a safe-by-default advisory enablement rule for an action that should be offered only when Task is `STATE_ON`. It must survive startup and later status loss.

### Answer

Maintain independently:

```text
last_observation_valid
last_success_time
observed_task_state
```

Initialize action disabled. Only enable when a status observation succeeds, its age is below the declared freshness bound, and `observed_task_state == STATE_ON`. On poll failure, disconnect/reconnect uncertainty, or freshness expiry, invalidate the observation and disable the action. On click, still issue the command through the designated command owner and judge acceptance from matching semantic result; never claim that advisory enablement proves physical action or safety.

**Result:** PASS.

## Q9 — Novel architecture scenario

A machine has a hardwired pendant through HALUI, a local QtVCP screen, and a remote maintenance service. The local screen loses status communication, but the pendant remains capable of sending machine-state requests. The screen is still rendering. What should the local screen display/enable, and what claims can it make about the pendant?

### Answer

The local screen should mark its controller-derived presentation invalid/stale and fail-define controller-dependent controls according to its policy. It may report that its own observation path is unavailable; it cannot conclude that the controller is down, that HALUI is down, that the pendant request was accepted/rejected, or that physical state is unchanged unless it has separate evidence for those domains. Multi-producer correlation requires architecture beyond local presentation state.

**Result:** PASS.

## Q10 — Version-sensitive reasoning

A future LinuxCNC revision changes `_GStat.__init__()` so it no longer polls at construction. Which T05 conclusions survive and what must be reverified?

### Answer

The general design rule survives: construction/default presentation must not substitute for a declared fresh controller observation, and GUI state is not semantic/physical/safety truth. The exact startup call flow, constructor-cache behavior, `_status_active` lifecycle, and T05-022 harness assumptions are version-sensitive and must be re-read/re-run at that revision before claiming the pinned implementation behavior still applies.

**Result:** PASS.

## Score and correction audit

Score: **10/10 course-level reasoning checks passed** against the pinned evidence available at this checkpoint.

The exam itself exposed no additional contradiction. The important correction had already been found adversarially by T05-022 attempt 1: the original guide's loose phrase that handler initialization precedes the “first valid status poll” was too strong because `_GStat.__init__()` performs a best-effort poll/merge. The guide and harness were corrected to distinguish constructor cache from the explicit post-handler forced-update/freshness boundary.

## Remaining higher-level uncertainty

- exact multi-producer race/correlation behavior: 2000 HIGH;
- error-channel fan-out/arbitration design: 2000 HIGH;
- remote reconnect/timing faults: 2000 HIGH;
- physical pendant latency/failure: 2000 MEDIUM;
- safety-HMI certification/integrity architecture: specialized higher level.

None changes the 1000-level rule that presentation, observation freshness, semantic command result, physical truth and safety authority are separate domains.
