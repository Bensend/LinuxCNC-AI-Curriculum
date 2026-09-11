# Adjacent hydraulic-machine evidence — lubrication pressure witness and blocking-wait audit

Date: 2026-09-11
Course context: **3600 Press Brakes — adjacent architecture evidence only**
Pinned LinuxCNC source baseline used for `timedelay`: `8bf4605ae81042248add031e94c77300406e0413`
Status: BOUNDED EXECUTABLE-CODE / COMMUNITY / SOURCE ANALYSIS; not press-brake implementation evidence

## Objective

The preceding 3600 audit found command/interlock evidence in the public `powerchuck` example but no visible physical completion witness. This pass searches for a LinuxCNC hydraulic/fluid actuator example that explicitly observes a physical process result and branches to a fault when the commanded result is absent.

The September 2024 LinuxCNC forum thread `lube - time component` supplies two useful patterns:

1. executable userspace Python that commands a lubrication pump, checks a pressure/float input and latches a fault if pressure is absent;
2. a proposed realtime HAL implementation using standard logic plus `timedelay`.

Thread:
https://forum.linuxcnc.org/49-basic-configuration/53756-lube-time-component

This is lubrication machinery, **not a press brake**. Transfer only the control-architecture lessons.

## Executable userspace Python path

The first post includes complete enough Python to trace the control flow:

```python
lube['run'], lube['fault'] = 0, 0
while 1:
    time.sleep(0.5)
    lube['delay'] = 0
    if(lube['machine_status'] and lube['spindle_status'] and not lube['fault']):
        lube['run'] = 1
        time.sleep(10)
        if(lube['pressuresw_floatsw']):
            time.sleep(50)
            lube['run'] = 0
            lube['delay'] = 1
            time.sleep(720)
        else:
            lube['run'] = 0
            lube['fault'] = 1

    if(lube['reset']):
        lube['fault'] = 0
        lube['reset'] = 0
```

### Call/control flow

```text
userspace loop
  -> poll machine/spindle/fault predicates
  -> set pump run = 1
  -> block 10 s
  -> sample pressure/float witness
      -> witness true: block 50 s, stop pump, block 720 s rest
      -> witness false: stop pump and latch fault
  -> eventually poll reset
```

**Evidence class:** `COMMUNITY-POSTED EXECUTABLE CODE` for the shown userspace logic. It is not upstream LinuxCNC source and was not independently executed in this curriculum.

## Strong positive pattern: command -> process witness -> fault

Unlike a bare solenoid-output example, this code explicitly distinguishes:

- **command:** `run = 1`;
- **expected physical/process result:** pressure/float input becomes true;
- **bounded observation point:** after the 10-second pump-on interval;
- **failed completion:** witness still false;
- **response:** `run = 0`, `fault = 1`;
- **manual recovery:** reset input clears the fault.

This is the architectural pattern sought by the prior checkpoint.

For a press brake, the transferable concept is not the 10-second value or the specific switch. It is that a process-mode command needs an independent success witness when command completion cannot be inferred from the command itself.

Examples at 3600 level can include:

- pressure-dump command -> measured pressure falls below the machine-defined completion condition;
- pressure-build/bend mode -> pressure changes in the expected direction/range;
- stateful valve-position request -> actuator-position/current witness if needed;
- ram request -> independent physical scale motion and Y1/Y2 differential remains bounded.

## Adversarial finding: blocking sleeps destroy responsive state ownership

The same code is a useful negative example.

While the process is inside `time.sleep(10)`, `time.sleep(50)`, or `time.sleep(720)`, this userspace loop does **not** re-evaluate:

- `machine_status`;
- `spindle_status`;
- `reset`;
- any newly appearing `fault` predicate other than the pressure input sampled after the first sleep.

Therefore the outer `if(machine_status && spindle_status && !fault)` is an **entry condition**, not a continuously enforced authorization.

If `machine_status` becomes false one second after entering the 10-second sleep, the shown Python code does not execute a branch that immediately clears `run`; it remains blocked until the sleep returns. The same structural issue is worse during the subsequent 50- or 720-second sleeps.

**Evidence class:** `SOURCE-LEVEL REASONING FROM POSTED EXECUTABLE CODE` (community source, not upstream).

### 3600 transfer rule

A press-brake process state that must respond promptly to machine disable, pedal release, Y1/Y2 mismatch, field-I/O loss, or hydraulic fault must not implement its waiting semantics as one long blocking userspace sleep.

Instead, model the wait as a state with:

- monotonic/realtime elapsed-time bookkeeping;
- predicates re-evaluated on every required control iteration;
- explicit success transition;
- explicit timeout/fault transition;
- explicit disable/abort transition;
- retained diagnostic reason.

Fast hydraulic synchronization/fault handling belongs in the appropriate realtime path; this adjacent userspace pattern is not evidence for servo-rate control.

## Community redesign discussion

Another participant reports a custom realtime `lube.comp` design with adjustable `lubeon`, `lubeoff`, and `pressuretime`. The stated behavior is:

- start output when enabling inputs are true;
- after the lubrication interval, expect pressure-switch confirmation within a pressure window;
- raise an alarm if pressure is not high;
- later revise the timing so the pressure switch is checked **before** pump-off because pressure falls immediately after the pump stops.

That revision is an important measurement-placement lesson: a completion witness must be sampled while the physical condition is still expected to exist.

**Evidence class:** `COMMUNITY-REPORTED SIMULATOR BEHAVIOR`; the attached `lube.comp` body was not available in the inspected page text, so do not claim its internal source path.

## Pinned upstream `timedelay.comp` behavior

LinuxCNC pinned source `src/hal/components/timedelay.comp` exports:

- boolean `in`;
- boolean `out`;
- `on-delay` and `off-delay` seconds;
- `elapsed`;
- an internal realtime timer.

On every scheduled invocation it snapshots `in`. When `in != out`, it accumulates `fperiod`; after the relevant delay it updates `out` and clears the timer. When `in == out`, the timer resets to zero.

**Evidence class:** `SOURCE-CONFIRMED` at `8bf4605ae81042248add031e94c77300406e0413`.

This makes `timedelay` a deterministic realtime persistence/qualification primitive. It is **not** by itself a process state machine or fault policy.

## Forum HAL proposal and polarity caveat

A later forum reply proposes standard realtime HAL blocks:

```text
and2 x2
message
not
timedelay
```

scheduled in `servo-thread`, with a 10-second `timedelay.0.on-delay`. It connects a hardware input to `timedelay.in`, `timedelay.out` to both `not.in` and a message trigger, and uses the resulting `no-fault` signal to gate the lube/spindle output logic.

This is useful evidence that the behavior can be decomposed into ordinary realtime HAL primitives.

However, the visible excerpt does not establish the electrical polarity of the pressure/float switch. Since `timedelay.out` follows a sustained **true** input after `on-delay`, whether that means `pressure confirmed` or `fault persisted` depends entirely on the physical input polarity and any inversion outside the excerpt.

Therefore do **not** claim from signal names alone that the posted HAL correctly implements “missing pressure for 10 seconds => fault.” The pin/switch polarity must be traced.

This is a direct application of the curriculum rule: **names are not provenance or semantics**.

## Failure/ownership matrix

| Condition | Detector shown | Timing class | State/response owner | Response shown | Limitation |
|---|---|---|---|---|---|
| machine/spindle not authorized at cycle entry | Python HAL input predicates | userspace, 0.5 s polling before entry | Python loop | do not start pump | not rechecked during blocking sleeps |
| no pressure after pump-on interval | pressure/float input | userspace sample after 10 s | Python loop | pump off + fault latch | only one sample after blocking wait |
| manual recovery | reset input | userspace | Python loop | clears fault | delayed while sleeping |
| persistent boolean condition in `timedelay` | realtime input/output mismatch | servo-thread function, accumulates `fperiod` | `timedelay` only | delayed boolean output | does not define fault policy |
| community custom-component pressure timeout | pressure input + `pressuretime` | claimed realtime/simulator | custom component | alarm | component body not inspected |

## Press-brake call-flow pattern derived from this evidence

The adjacent evidence supports the following generic 3600 review pattern:

```text
semantic state enters process mode
    -> ordinary authorization checked
    -> hydraulic command emitted
    -> each control iteration:
         recheck authorization/fault predicates
         observe physical/process completion witness
         update elapsed time
         if witness succeeds -> next semantic state
         if timeout -> fault/abort state
         if authorization lost -> defined abort/decompression/inhibit path
    -> diagnostic reason retained
```

For fast Y1/Y2 and final actuator authorization, the loop period must be appropriate to the hazard/control requirement; a userspace lube loop is only an adjacent conceptual example.

## Adversarial tests

### Trap 1 — “The outer `if(machine_status)` keeps the output disabled whenever the machine turns off.”

**Reject.** It only guards entry into the blocking section. Once sleeping, the code does not poll `machine_status` again until the sleep returns.

### Trap 2 — “A 10-second sleep is a timeout state machine.”

**Reject.** It delays execution but does not provide periodic abort/fault checks, intermediate diagnostics, or bounded reaction to other state changes.

### Trap 3 — “Pressure-switch high after the pump shuts off is the right verification point.”

**Reject as a general claim.** The forum implementer observed pressure falling immediately after pump-off and moved the expected-pressure check earlier. Measurement timing must correspond to the physical condition being verified.

### Trap 4 — “`timedelay` provides hydraulic fault handling.”

**Reject.** Pinned source proves only delayed boolean qualification. The surrounding logic owns fault meaning, output inhibition, recovery and diagnostics.

### Trap 5 — “The posted realtime HAL definitely detects missing pressure.”

**Reject without input-polarity provenance.** The visible net names do not establish whether `true` means pressure-good or fault/low-fluid.

## Durable 3600 lesson

The combined powerchuck and lube examples now give two independent adjacent patterns:

1. **interlock/authorization ordering:** compute the final allowed actuator state before the hardware-write function that publishes it;
2. **process completion:** do not equate command with completion; observe a physical/process witness and provide a bounded failure transition.

The lube example adds a third rule:

3. **a wait is not merely elapsed time.** The operation owner must remain able to process abort/disable/fault predicates during the wait at the required control rate.

These patterns strengthen the press-brake decoder review contract without supplying or inventing any machine-specific press-brake valve combination.

## Precise next-work checkpoint

1. Convert the current 3600 findings into a compact **hydraulic mode transition review matrix** covering at minimum: fast approach, slow bend, dwell, pressure dump/decompression, return, halt, and homing/reference mode.
2. For each mode record: semantic owner, command outputs, required physical witnesses, same-cycle authorization inputs, completion predicate, timeout owner, abort path, retained diagnostic, and what remains machine-specific/UNKNOWN.
3. Cross-check the matrix against the executable Accurpress pressure-limit state and the community-reported Ursviken pressure-dump interface without synthesizing unavailable Pullmax valve truth tables.
4. Add an adversarial scenario for mid-decompression enable loss and one for a valve-command/pressure-witness disagreement.
5. No lab experiment is justified yet: the missing information is machine-specific decoder source/plant behavior, not generic LinuxCNC execution semantics. Preserve PB-PREP-001 INCONCLUSIVE.
6. Preserve information separation: S02/E20/X01/X02 fresh-AI handoffs remain pending and F02 remains blocked.
