# Press-brake prep — QtPlasmaC realtime process-state analogue and evidence-gap audit

Date: 2026-09-11
LinuxCNC source revision: `8bf4605ae81042248add031e94c77300406e0413`
Status: **dependency-safe press-brake preparation; source comparison, not a press-brake implementation prescription**

## Why this source was selected

The current press-brake checkpoint asked for one executable LinuxCNC realtime state machine in which:

- an active process state is reevaluated every realtime invocation;
- physical completion/failure witnesses drive transitions;
- timeout/retry behavior is explicit rather than hidden inside a blocking wait;
- scheduling can be inspected.

A bounded search found `src/hal/components/plasmac.comp`. It is not hydraulic and therefore cannot establish a press-brake valve truth table, but it is a strong adjacent process-control analogue because the component owns a multistate physical process, is scheduled in the servo thread, consumes real process sensors, commands outputs, and implements bounded retries/fault transitions.

## Evidence ledger

### SOURCE-CONFIRMED — realtime execution context

Pinned source: `src/hal/components/plasmac.comp`.

The component is a HAL realtime component. The pinned QtPlasmaC simulation config `configs/sim/qtplasmac/sim_stepgen.tcl` schedules:

```text
stepgen.capture-position
motion-command-handler
motion-controller
plasmac
stepgen.update-freq
```

all in `servo-thread` (with pulse generation in the base thread).

This is useful architecture evidence: the process component can examine the current servo-cycle motion state and publish new stepgen-facing control state before `stepgen.update-freq` in that specific configuration. It is **not** proof that every real QtPlasmaC machine places every physical GPIO write after `plasmac`; final hardware-publication order remains machine/configuration specific.

### SOURCE-CONFIRMED — machine-off collapse is reevaluated every invocation

Before entering the active state switch, `plasmac.comp` checks `machine_is_on`. If it is false, the component clears X/Y/Z external-offset commands, resets stop/cut bookkeeping, clears program-pause/run helper outputs, turns `torch_on` false, clears the torch-pulse timer, and sets the process state to `IDLE`.

This is stronger than an entry-only interlock: the predicate sits outside the individual active-state cases and is therefore reconsidered every component invocation.

Press-brake lesson: a state-machine owner can have a global ordinary-authorization/fault gate that remains live during active states. This still does not establish a functional-safety function.

### SOURCE-CONFIRMED — sensor-driven probing transitions

`PROBE_DOWN` repeatedly evaluates physical/process witnesses rather than sleeping until one event is assumed:

- probe-test cancellation;
- breakaway input during a probe test;
- float-switch activation;
- ohmic detection;
- approach to the Z minimum limit.

A float or ohmic witness moves the state machine into the next probing state, while reaching the bottom limit without detecting material pauses/aborts the operation through an explicit failure path.

This is directly relevant to the press-brake review matrix: an active process state has a command, physical completion witnesses, failure witnesses, and explicit next states evaluated at the component's realtime invocation rate.

### SOURCE-CONFIRMED — arc-start completion, timeout, retry, and attempt cap

`TORCH_ON` and `ARC_OK` provide an even cleaner timeout example.

`TORCH_ON` initializes `arc_fail_timer = arc_fail_delay`, commands the torch on, and transfers to `ARC_OK`. `ARC_OK` then executes every invocation:

- if Arc OK becomes valid, transition toward the pierce-delay state;
- otherwise decrement `arc_fail_timer` by `fperiod`;
- when the timer expires, command the torch off, load `restart_timer`, increment `arc_starts`, and return to `TORCH_ON`;
- `TORCH_ON` caps repeated attempts using `arc_max_starts`; after the configured number of failures it stops a manual cut or pauses the program instead of retrying indefinitely.

This is an important distinction from a bare timer component: **the operation owner defines both the timeout detector and the timeout response/retry state transition.**

### DOC-CONFIRMED — public QtPlasmaC contract

Current QtPlasmaC documentation describes the same public controls:

- **Start Fail Timer**: time between Torch On and Arc OK before timeout;
- **Max. Starts**: maximum arc-start attempts;
- **Retry Delay**: delay before another start attempt;
- Arc OK is the physical/process witness that the cutting arc has been established and motion may proceed.

Official documentation: https://linuxcnc.org/docs/devel/html/plasma/qtplasmac.html

### COMMUNITY-REPORTED — a real retry-delay failure exposed state/timing behavior

LinuxCNC forum thread, 14–16 Dec 2022, `qtplasmac lost arc = turn off and on again?`:

https://forum.linuxcnc.org/plasmac/47678-qtplasmac-lost-arc-turn-off-and-on-again

A user reported that a failed pierce appeared to prevent further arc starts until QtPlasmaC was restarted. Another user noticed a 60-second retry delay; a QtPlasmaC contributor then reported finding a code issue and pushed a fix. The field report is not source truth for the pinned revision, but it is useful longitudinal evidence that timeout/retry parameters and state transitions are operator-visible failure behavior, not merely theoretical implementation details.

## Call-flow reconstruction

### Arc-start path

```text
servo-thread invokes plasmac
  -> global machine_is_on authorization checked
  -> TORCH_ON
      -> feed hold asserted
      -> attempt count checked
      -> restart delay expires
      -> arc_fail_timer loaded
      -> torch_on output asserted
      -> state = ARC_OK
  -> next servo invocations: ARC_OK
      -> Arc OK witness acquired/qualified elsewhere in same component
      -> if witness valid:
           -> pierce timers loaded
           -> state = PIERCE_DELAY
      -> else:
           -> arc_fail_timer -= fperiod
           -> timeout:
                torch_on = false
                restart_timer loaded
                arc_starts++
                state = TORCH_ON
  -> later TORCH_ON invocation
      -> if attempts exhausted:
           manual cut: cutting_stop + MAX_HEIGHT path
           running program: program_pause
```

The timeout is therefore not an observer guessing that a state took too long. It is explicit state-owned bookkeeping driven by `fperiod` and paired with a defined state transition.

### Probe-down path

```text
servo-thread invokes plasmac
  -> machine_is_on gate
  -> PROBE_DOWN
      -> maintain probe-related outputs
      -> inspect cancellation/breakaway
      -> inspect float and ohmic material witnesses
      -> inspect bottom-limit condition
      -> completion witness => PROBE_UP
      -> invalid/bottom failure => explicit pause/test-failure path
      -> otherwise advance Z offset request
  -> next invocation repeats the same checks
```

This is the process-control shape the press-brake matrix should demand for dwell/decompression-like states: remain interruptible and keep evaluating the physical witness while the state is active.

## Score against the press-brake hydraulic-mode review matrix

| Review surface | QtPlasmaC evidence | Press-brake transfer lesson |
|---|---|---|
| Semantic state owner | **EVIDENCED** — explicit C state machine | Give approach/bend/dwell/decompression/return one explicit owner. |
| Abstract process mode | **EVIDENCED in plasma-specific form** — probing, torch-on, arc-wait, pierce | A press should use abstract hydraulic/process modes without pretending they are universal valve bits. |
| Ordinary authorization during active state | **EVIDENCED** — `machine_is_on` global gate each invocation; state-specific checks also exist | Do not check enable/interlock only when a state begins. |
| Physical completion witness | **EVIDENCED** — Arc OK, float, ohmic, position/limit witnesses | Command emission never substitutes for plant completion evidence. |
| Timeout detector | **EVIDENCED** — fperiod-based arc-fail/restart timers | Use realtime elapsed-state bookkeeping where timing class requires it. |
| Timeout response | **EVIDENCED** — torch off, retry transition, attempt count, eventual pause/stop | A timer without a transition policy is incomplete. |
| Bounded retry | **EVIDENCED** — `arc_max_starts` | If retry exists, bound it and retain a terminal failure state. |
| Final actuator publication order | **PARTIAL** — sim stepgen order is inspectable; generic real-hardware GPIO order is not established here | Trace each real machine's read/state/decoder/final-write order; never infer it from thread membership. |
| Intermediate actuator-state witness | **NOT GENERICALLY EVIDENCED** | The 2018 press-brake valve-stepper disturbance remains the stronger warning that commanded actuator state can differ from physical state. |
| Hydraulic decompression mode | **NOT APPLICABLE / NOT EVIDENCED** | Plasma source cannot tell us spool combinations, dump thresholds, or pressure-decay criteria. |
| Functional safety | **EXPLICITLY NOT ESTABLISHED** | Ordinary realtime control remains separate from safety-rated safeguarding. |

## Adversarial checks

### 1. “The timer expired, therefore the physical torch/valve failed.”

Rejected. In QtPlasmaC, arc timeout establishes only that the required Arc OK witness did not arrive before the deadline. It does not by itself distinguish power-source failure, field-I/O failure, incorrect configuration, stale acquisition, or process failure. The analogous press-brake conclusion is `requested mode did not achieve its completion witness in time`, not a guessed failed valve.

### 2. “A global machine-off check means this is a safety-rated stop.”

Rejected. It is ordinary software control. The component itself carries an explicit warning against relying on software alone for safety. A press-brake safeguard/E-stop architecture must remain separately justified.

### 3. “Because plasmac is in the servo thread, its output always reaches hardware in the same servo period.”

Rejected. The pinned simulation gives one concrete order for motion/plasmac/stepgen. Real hardware-facing read/write functions are configuration-dependent. Same-thread membership alone does not prove data age or same-cycle publication.

### 4. “Retrying is always better than faulting.”

Rejected. QtPlasmaC bounds arc starts and enters a terminal pause/stop behavior. A press-brake retry must be justified per mode; some faults require reconciliation rather than automatic repetition.

## Evidence-gap assessment after bounded search

The source hunt has now reached a useful stopping boundary.

### Strong enough to teach generically

The accumulated public evidence is sufficient to teach these architecture rules without another machine-specific source hunt:

1. Process states should be explicit and nonblocking when they must remain responsive.
2. Active states must continue to evaluate their relevant ordinary authorization/fault predicates at the required control rate.
3. Completion should be based on physical/process witnesses, not on the fact that a command was sent.
4. Timeout detection and timeout response are distinct surfaces; the operation owner needs an explicit failure transition.
5. Retry behavior must be bounded and have a terminal disposition.
6. Final hardware publication order must be traced from actual `addf`/thread ordering.
7. State/command/plant-witness/diagnostic layers must be kept separate from functional safety.

### Still legitimately unknown / machine-specific

A further generic source search is unlikely to justify inventing any of the following:

- a universal hydraulic spool/coil truth table;
- a universal pressure-dump command;
- decompression pressure threshold or time;
- safe hydraulic state on ordinary enable loss or emergency stop;
- whether a particular manifold traps, vents, counterbalances, or allows ram motion during dump;
- allowable tandem Y1/Y2 mismatch or correction gain;
- whether a valve actuator needs its own inner feedback loop on a specific machine.

Those depend on the actual hydraulic/electrical machine design and physical validation.

## Sufficiency decision

**STOP repeated public-source hunting for a generic hydraulic truth table.** The evidence is now sufficient to define a generic ownership/state-transition contract. Additional press-brake source remains valuable only if it supplies a genuinely new surface—especially a mature downloadable tandem Y1/Y2 implementation or executable decompression decoder—not merely another variation of state names.

The next useful step is a small generic mode-ownership/failure-transition experiment that tests architecture semantics only. It should not model valve flow, cylinder dynamics, pressure equations, or machine-specific safety behavior.
