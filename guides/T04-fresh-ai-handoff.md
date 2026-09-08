# T04 fresh-AI handoff — GUI integration boundaries

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Core model

A LinuxCNC GUI is a userspace presentation/control client, not the owner of controller, physical, or safety truth.

Keep these evidence domains separate:

1. **Local GUI state** — widget enabled/checked state, cached values, preview/backplot, notifications, preferences and local helper policy.
2. **Observed controller status** — the last successfully polled `linuxcnc.stat()` snapshot and GUI signals derived from it.
3. **HAL observations** — values read from HAL may have different source/provenance/freshness semantics than NML status fields.
4. **Command semantic result** — commands issued through `linuxcnc.command()` still require the T03 DONE/ERROR evidence boundary.
5. **Physical-device truth** — actual actuator/sensor state requires appropriate field feedback and provenance.
6. **Safety truth** — requires the machine's validated safety architecture; ordinary GUI state is not a safety-rated proof channel.

The durable rule is: **what the GUI currently renders is a presentation claim. Before treating it as current controller or machine state, identify the source and prove the observation is fresh enough for the intended decision.**

## Representative pinned paths

### QtVCP status

```text
GLib timer
 -> GStat.update()
 -> linuxcnc.stat().poll()
 -> merge controller/HAL observations into local cache
 -> compare old/new
 -> emit STATUS signals
 -> widgets/handlers render or change enabled/checked state
```

On failed `stat.poll()`:

```text
_status_active = False
emit periodic
skip merge/state signals
reschedule
```

`GStat.is_status_valid()` exposes this observation-health state.

### QtVCP command

```text
widget/handler
 -> local STATUS-based guard/policy
 -> Action method
 -> linuxcnc.command()
 -> NML command channel
 -> Task semantic acceptance/rejection
```

An enabled button is therefore a local policy result, not a controller authorization token.

### AXIS

Pinned AXIS uses a different UI framework but the same architectural separation. `LivePlotter.update()` periodically polls `linuxcnc.stat()`, projects the snapshot into Tk variables/redraw caches and returns on poll failure. Helpers such as `manual_ok()` and `ensure_mode()` poll, apply userspace policy and issue controller commands.

## Independent verification — T04-021

Workflow `34186879941`, authoritative job `101936899842`, artifact `10040862703`, exit `0`, passed frozen Gates A-H.

The decisive observation was:

```text
controller independently observed = STATE_ESTOP_RESET
GUI adapter poll deliberately failed
GStat _status_active              = False
GStat cached state                = prior STATE_ESTOP
presentation state                = prior STATE_ESTOP
GUI event from failed cycle       = periodic only
```

Removing only the poll failure produced:

```text
GStat _status_active = True
cache/presentation   = STATE_ESTOP_RESET
state-estop-reset signal emitted
```

This directly proves that a responsive/periodic GUI can retain stale controller-derived presentation during an observation failure.

## Practical integration rule

For a custom operator interface, every machine-relevant display/control should have an answer to:

- What is the value's source?
- When was it last successfully observed?
- What is the stale/invalid presentation policy?
- Does widget enablement merely advise the operator, or is a lower controller interlock still required?
- What evidence proves command success?
- What separate evidence proves physical/safety state where needed?

Where stale information could mislead, consider explicit last-known/stale indication, disabling applicable controls, blanking/annotating values, or another documented failure policy. The correct policy depends on machine risk and does not turn an ordinary GUI into a safety function.

## Novel scenario

A custom screen polls normally, enables a spindle-start button, then loses its status observation path. The GUI remains responsive and the button remains enabled. Another controller client puts LinuxCNC in ESTOP. The operator presses the still-enabled button.

Expected reasoning:

1. The button's enabled state is stale local presentation/policy, not current authorization.
2. Check the GUI status-valid/freshness path and timestamp of last successful observation.
3. The command must still be graded by matching Task semantic DONE/ERROR, not by the button click or serial echo.
4. Any claim about the actual spindle/energy state needs independent physical evidence.
5. Safety behavior belongs to the validated safety system, not the stale GUI.

A fresh AI passes T04 when it diagnoses this as a layered freshness/TOCTOU/evidence problem rather than assuming the controller accepted the command because the GUI allowed the click.

## Promotion queue / counterfactual audit

- Actual full-screen QtVCP widget stale-state test under display-server failure/status disconnect — **2000, MEDIUM**. T04-021 exercises the real pinned `GStat` branch and listener semantics; full visual rendering can refine UX but cannot reverse the source/runtime result.
- GUI time-of-check/time-of-use race with a competing command producer — **2000, HIGH**. Important for complex HMIs; the 1000-level model already bounds local enablement versus Task authority.
- Multiple error-channel consumers within custom GUI/subprocess ecosystems — **2000, HIGH**, inherited from T03 transport/consumer study.
- Remote GUI/NML reconnect and stale-status recovery — **2000, HIGH**, inherited from T03 remote transport study.
- Gmoccapy/other GUI implementation comparison — **2000, MEDIUM**. AXIS + QtVCP establish the architecture class at 1000 level without claiming identical implementation details everywhere.
- Safety-HMI design, diagnostics and required integrity levels — **specialized safety curriculum**, HIGH importance but outside ordinary LinuxCNC GUI semantics.
- Version drift beyond pinned SHA — **2000, MEDIUM**.

Counterfactual test: even if a later GUI blanks instead of retaining stale values, a remote reconnect behaves differently, or another framework has different callbacks, none can invalidate the bounded result that GUI presentation has its own ownership/freshness semantics and must not be collapsed into controller/physical/safety truth.

## 1000-level graduation audit

- Official documentation baseline: PASS — AXIS, QtVCP and Python UI interfaces establish GUIs as userspace front-ends/status/command clients.
- Community research: PASS — customization/race reports were used as field hypotheses, not exact-version authority.
- Pinned source analysis: PASS — QtVCP `core.py`, `common/hal_glib.py`, `qt_action.py`, `action_button.py`, and AXIS `axis.py` were traced.
- Representative command flow: PASS — widget/helper -> local status policy -> `linuxcnc.command()` -> Task.
- Representative display flow: PASS — status poll -> local cache/diff -> GUI signal -> widget/render path; AXIS periodic projection independently documented.
- State ownership/freshness matrix: PASS — controller status, HAL, GUI-local, preview, physical and safety sources explicitly separated.
- Failure path: PASS — failed GUI status poll preserves stale cache/presentation while periodic GUI activity continues.
- Independent experiment: PASS — T04-021 workflow `34186879941`, job `101936899842`, frozen Gates A-H all PASS.
- Predeclared prediction: PASS — experiment plan was frozen before harness implementation.
- Adversarial exam: PASS — `exams/T04-adversarial-exam.md`, 10/10.
- Fresh-AI transfer: PASS — novel stale-enabled spindle control scenario requires layered reasoning and T03 transfer.
- Corrections: PASS — terminology distinguishes current presentation, last-known controller state and valid/fresh observation path.
- Promotion/counterfactual audit: PASS — deeper GUI/transport/concurrency/safety topics are explicit and cannot invalidate the bounded 1000-level conclusion.

**Decision: T04 GRADUATED at 1000 level.**

## Next dependency checkpoint

T05 — custom operator interface patterns is now the next Phase-9 module. Before leaving the Phase-9 cluster for a later major cluster, the development-bank blind baseline required after T03 must be executed with genuine information separation; do not create a contaminated score merely to satisfy the ledger.