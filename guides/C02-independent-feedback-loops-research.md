# C02 — independent feedback loops: first research/source pass

Status: **RESEARCH**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Prerequisite: C01 1000-level graduation.

## Learning target

Establish the difference between C01's duplicated command fan-out and two genuinely independent feedback/control channels. At 1000 level the learner must be able to construct and observe two realtime loop instances with a shared position-command premise but separate feedback state, explain how each controller computes its own error/output, and demonstrate that disturbing one feedback path can produce a different loop result without pretending that this is already cross-coupled synchronization logic.

C02 must not collapse into C03. C03 owns explicit synchronization/cross-coupling between the two sides; C02 first proves that independent feedback loops are actually independent state/evidence paths.

## Official documentation pass

Current LinuxCNC PID documentation describes `pid` as a realtime component and says each loaded loop is completely independent. For position loops its core interface is:

```text
pid.N.command   desired position
pid.N.feedback  measured position from feedback device
pid.N.error     command - feedback
pid.N.output    controller effort / velocity-like command
```

Disabling a loop forces output to zero and resets the integrator. This makes `enable` a useful failure-path oracle for C02, but it is not a safety-rated drive-disable claim.

Official documentation also contains a "Dual Feedback PID" example, but that example addresses two feedback devices for one machine axis by summing two PID outputs. C02's dual-actuator teaching problem is different: it needs two separately observable loop instances before C03 adds a synchronization relationship between them. The example is useful evidence that LinuxCNC supports distinct feedback signals and multiple PID instances, not a ready-made dual-actuator synchronization architecture.

References:

- https://www.linuxcnc.org/docs/stable/html/man/man9/pid.9.html
- https://www.linuxcnc.org/docs/stable/html/hal/rtcomps.html
- https://www.linuxcnc.org/docs/master/html/es/motion/dual-pid-example.html

## Pinned source pass — `src/hal/components/pid.c`

### Instance ownership

`rtapi_app_main()` allocates an array of `hal_pid_t`, one structure per configured channel, and calls `export_pid()` separately for each instance. The structure contains its own command, feedback, error, integral/derivative state, gains, output, saturation state, previous command, and previous feedback.

This is stronger than merely having differently named HAL pins: each configured channel receives distinct runtime storage.

### Realtime call flow

For one PID channel:

```text
servo thread
  -> pid.N.do-pid-calcs / calc_pid(instance N, period)
      -> read instance enable
      -> read instance command once
      -> read instance feedback once
      -> compute error from that instance's command/feedback
      -> update that instance's integral/derivative/history state
      -> compute that instance's output and limits
      -> write that instance's output/error/saturation pins
```

Pinned `calc_pid()` explicitly reads `command` and `feedback` once into local values before calculating the error. A disturbance applied only to one channel's feedback can therefore create a different error/output in that channel even when both channels receive the same command signal.

### Disabled-loop failure path

Pinned source preserves error observation but, when `enable` is false, resets the integrator and later forces output to zero. Therefore the durable boundary is:

```text
feedback disagreement observed by a PID instance
!= actuator command necessarily issued
```

because disabled state can suppress output. Conversely:

```text
nonzero pid.N.error
!= automatic cross-loop disagreement trip
```

because the PID instance only reasons about its own command/feedback state. No source evidence inspected so far shows one PID channel reading the other PID channel's feedback or error.

## C01-to-C02 architecture boundary

C01 established:

```text
one world Y command
 -> duplicated software joint commands
```

C02 must add:

```text
shared command premise
 -> controller A -> feedback A -> error/output A
 -> controller B -> feedback B -> error/output B
```

and experimentally prove that feedback B can diverge without silently becoming feedback A.

C03 will later add an explicit cross-channel term/comparator/fault rule. C02 must not claim that two independent loops synchronize themselves merely because they share a command.

## Community-research lead

LinuxCNC gantry discussions repeatedly distinguish commanding two joints together from keeping a mechanically coupled gantry square, particularly around homing and individually moving joints. These reports remain investigation leads rather than architectural authority. The source-backed C02 question is narrower: when two feedback/control instances are built, what exact state belongs to each loop, and what changes when only one feedback path is disturbed?

## Failure modes to test

1. **One feedback path lags** while command remains shared: affected loop error/output should differ from the undisturbed loop.
2. **One loop disabled:** its output should be forced to zero while the other loop can continue according to its own state; whether a machine should permit that is a later sequencing/safety policy question.
3. **Feedback frozen:** PID error can grow, but PID alone is not evidence of a cross-loop trip or machine shutdown.
4. **Observation tear:** C01 demonstrated that sequential userspace reads can invent transient disagreement. C02 comparisons that claim simultaneity must preserve a common realtime observation domain.

## Claims ledger

| Claim | Classification | Evidence | Confidence | Verification needed |
|---|---|---|---|---|
| Multiple `pid` channels have separate runtime state | SOURCE-CONFIRMED | pinned `rtapi_app_main()`, `hal_pid_t`, `export_pid()` | high | runtime fixture useful |
| Each channel computes error from its own command/feedback | SOURCE-CONFIRMED | pinned `calc_pid()` | high | runtime disturbance experiment |
| Disabled channel forces output zero and resets integral state | SOURCE-CONFIRMED + DOC | pinned `calc_pid()`, PID manpage | high | include in adversarial/failure test |
| Shared command does not itself create cross-coupling | SOURCE-INFERENCE | no inspected per-instance path reads peer loop state | high for stock PID | prove with two-channel disturbance fixture |
| Two independent loops are sufficient to keep a physical dual actuator aligned | REJECTED | no such evidence; contradicted by course boundary | high | belongs C03/hardware validation |

## Experiment direction — not yet frozen

Build on the C01 `XYZY` simulation but replace ideal command-to-feedback identity on the duplicated Y sides with two deliberately separate simple simulated plant/feedback paths and two PID instances. Use same-cycle realtime capture. Apply a deterministic disturbance/lag to exactly one feedback path and prove:

- both loops receive the same command premise;
- feedback A and feedback B remain separate signals/state;
- only the disturbed loop develops the corresponding extra error/control response;
- no implicit cross-loop correction/trip is credited to stock PID;
- disabling one channel demonstrates the documented zero-output/reset behavior without making a safety conclusion.

Before implementation, source-trace the candidate simulated plant component and define whether outputs drive independent plant states or accidentally rejoin through a shared HAL signal.

## Exact next-work checkpoint

Continue C02 at SOURCE: inventory a minimal pinned realtime plant component suitable for two independent deterministic channels (prefer a simple first-order/integrator-style HAL component already shipped upstream), trace its per-instance state and scheduling semantics, and document the full `duplicated command -> pid A/B -> separate plant A/B -> separate feedback A/B` thread order. Then freeze C02-024 with same-cycle observation gates and an asymmetric one-feedback disturbance **before** writing the harness.
