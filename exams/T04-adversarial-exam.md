# T04 adversarial exam — GUI integration boundaries

Status: **PASSED — 10/10 after T04-021 reconciliation**  
Pinned source basis: LinuxCNC `8bf4605ae81042248add031e94c77300406e0413`

## Purpose

Test whether an AI can reason about GUI state without collapsing local widget presentation, last-polled controller status, HAL observations, physical-device truth, or safety state.

## Q1 — responsive-screen fallacy

A custom QtVCP screen clock continues updating and buttons respond to mouse clicks. The DRO has not changed for several seconds. Can the operator infer that the displayed controller position is fresh because the GUI is responsive?

### Required answer

No. GUI/event-loop responsiveness is independent of successful LinuxCNC status polling. Pinned `GStat.update()` can emit generic periodic activity and reschedule after a failed status poll while retaining old controller-derived values. Check explicit status validity/freshness and the relevant independent feedback domain.

## Q2 — T04-021 witness

The independent observer reports ESTOP_RESET, while the GUI adapter reports `_status_active=False` and still caches/presents ESTOP. What is the correct interpretation?

### Required answer

The GUI is displaying a last-known controller state, not current controller state. The failed observation path is directly identified by `_status_active=False`; the retained ESTOP value must be treated as stale until a successful poll refreshes it.

## Q3 — enabled-button fallacy

A Run button is enabled because earlier status events said machine ON, homed, file loaded, and interpreter idle. Does enabled mean Task will accept Run now?

### Required answer

No. Enabled is local widget policy driven by the last observed state. Controller state may have changed after that observation or another producer may have acted. Task remains the semantic authority; command result must be checked through the proper command/status evidence path.

## Q4 — mixed-source screen

A QtVCP screen shows Task state from `linuxcnc.stat()` and spindle actual speed from a HAL pin. Can a single GUI freshness flag prove both values are physically current?

### Required answer

No. The screen aggregates multiple observation sources. `GStat.is_status_valid()` describes the LinuxCNC status adapter's latest poll path, not universal provenance or physical freshness for every HAL/device value. Each field's source and freshness semantics must be traced.

## Q5 — AXIS preview fallacy

AXIS preview/backplot shows the tool at a point on the programmed path. Can that be used as encoder proof that the physical machine is there?

### Required answer

No. Preview/backplot is GUI/interpreter/presentation state. Even controller-reported actual position is a different evidence domain from physical encoder truth unless the feedback path/provenance is established. Preview is never a substitute for field feedback.

## Q6 — stale safety indication

A custom HMI keeps its previous green “E-stop clear” indicator when status polling fails because the designer prefers not to flash the screen. What is the integration risk?

### Required answer

The HMI can visually represent a last-known state as current during an observation failure. For safety-relevant presentation, the design needs an explicit stale/invalid policy appropriate to the machine and safety architecture; ordinary LinuxCNC GUI status must not be represented as a safety-rated proof channel.

## Q7 — command rejection after fresh enable

A status poll succeeds, a button enables, and 20 ms later another process puts the controller in ESTOP before the user action reaches Task. The button click is rejected. Is that evidence that the GUI status poll was wrong?

### Required answer

Not necessarily. The poll could have been correct at its observation time. This is a time-of-check/time-of-use race between userspace observation/policy and later controller command evaluation. Preserve timestamps and matching command result before diagnosing stale polling.

## Q8 — empty error popup area

A screen shows no error popup after a command. May it assume the command succeeded?

### Required answer

No. Error reporting is a separate consumed channel and local popup policy. Semantic command DONE/ERROR must be checked independently. T03 already established that diagnostics, acknowledgement and semantic result are distinct.

## Q9 — custom widget transfer

A third-party widget stores `last_machine_on=True` after a status signal and never handles a status-invalid condition. It continues enabling spindle controls after the status connection fails. Diagnose the defect without blaming LinuxCNC motion.

### Required answer

The defect is presentation/freshness ownership: the widget treats retained local state as current controller truth. It should consume an explicit status-valid/freshness signal or equivalent timeout/failure policy, distinguish last-known from current, and still rely on controller semantic rejection as a lower boundary rather than assuming local enablement authorizes the action.

## Q10 — novel architecture review

An engineer proposes: “All safety-critical indicators in our custom UI will be driven from `STATUS.connect(...)`; if QtVCP says status is valid, they are safe to trust.” What should the AI say?

### Required answer

Reject the overclaim. QtVCP status signals are ordinary userspace controller observations. `is_status_valid()` only says the status poll path succeeded; it does not establish physical sensor provenance, failure independence, diagnostic coverage, or functional-safety integrity. Safety-critical indicators/actions must be derived from the machine's validated safety architecture, with the GUI used as presentation unless the full safety case establishes otherwise.

## Passing rubric

Pass requires all of the following:

1. Distinguish GUI-local state from current controller status.
2. Treat poll freshness/validity explicitly.
3. Recognize time-of-check/time-of-use races between UI enable policy and Task command acceptance.
4. Distinguish status, HAL, preview, physical feedback and safety evidence.
5. Carry T03's semantic command-result boundary through the GUI layer without duplicating it.
6. Solve Q9/Q10 as evidence/ownership architecture problems rather than controller-motion bugs.

Any answer that equates a responsive GUI, enabled widget or status-valid flag with physical/safety truth is a fail at 1000 level.

## Post-experiment grading

**Score: 10/10 — PASS.**

T04-021 supplied the core adversarial runtime witness: a generic periodic GUI callback occurred while the independently observed controller had already changed to ESTOP_RESET, yet the GUI adapter was invalid and still retained/presented ESTOP. The next successful poll emitted the state-reset signal and caught up.

The exam transfers that mechanism to button enablement, preview, mixed HAL/status sources, TOCTOU command rejection, custom widget caching and safety-HMI overclaiming. No conceptual correction beyond explicit freshness terminology was required.