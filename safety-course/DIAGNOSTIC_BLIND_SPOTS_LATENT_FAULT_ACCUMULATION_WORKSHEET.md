# Diagnostic Blind Spots / Latent-Fault Accumulation Worksheet

Date: 2026-09-16
Lane: independent safety curriculum lane B
Status: durable architecture worksheet

## Purpose

A channel that reports `healthy` has only proven what its diagnostics actually challenged and observed. This worksheet forces the designer to identify faults that remain hidden during steady operation, the demand or proof-test stimulus that exposes them, and the second fault that could turn a latent defect into loss of the intended safety function.

Frozen rule: **`no diagnostic fault` is not proof that the physical safety path is healthy. A diagnostic is evidence only for the path it actually stimulates and observes.**

Evidence labels used here: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, `UNKNOWN`.

## Authority boundary

LinuxCNC, HAL, the ordinary FPGA, HMI, recorder, and network diagnostics may provide useful normal-control inhibition, sequencing, visibility, freshness checks, and maintenance evidence. They do not become personnel-safety authority merely because they detect a discrepancy or run a startup test. Safety authority must remain in the independently justified safety architecture.

Do not infer PL, SIL, category, diagnostic-coverage percentage, proof-test interval, stopping distance, hydraulic pressure threshold, valve truth table, or other machine-specific performance from this worksheet. Those remain `UNKNOWN` until supported by the required device documentation, engineering analysis, and/or physical test.

## 1. Diagnostic timing classification

For every safety-significant channel or final element, classify each credible fault by when it can be detected:

| Fault | Immediate/continuous | On state change | On startup/restart challenge | On deliberate proof test | Potentially latent | Evidence |
|---|---|---|---|---|---|---|
| Input stuck in one state |  |  |  |  |  |  |
| Cross-short / common conductor fault |  |  |  |  |  |  |
| Output/final element fails to change state |  |  |  |  |  |  |
| Feedback contact/sensor stuck |  |  |  |  |  |  |
| Mechanical actuator/target loose or misaligned |  |  |  |  |  |  |
| Shared power/reference failure |  |  |  |  |  |  |
| Stale network/register value |  |  |  |  |  |  |
| Configuration mismatch |  |  |  |  |  |  |
| Diagnostic itself disabled/misconfigured |  |  |  |  |  |  |

`INFERENCE`: steady-state agreement often cannot expose a component that is stuck in the state currently expected. A transition or deliberate stimulus may be necessary. Whether a specific device performs such a test is `UNKNOWN` until its documentation is traced.

## 2. Latent-first-fault / second-fault matrix

Do not stop at “single fault detected.” Ask what happens while a first fault is hidden.

| Latent first fault | Why it can remain hidden | Second fault/demand | Possible consequence | What should reveal first fault before second? | Current evidence |
|---|---|---|---|---|---|
| Channel A input stuck safe | Channel never challenged away from safe state | Channel B fails or is bypassed | Loss of intended two-channel protection | Independent transition/proof challenge |  |
| Feedback witness stuck in expected state | Command and feedback remain apparently consistent | Final element fails physically | False proof of de-energized/disabled state | Challenge feedback through actual final-element state change |  |
| One output path welded/failed ON | Other path still removes energy in routine stops | Remaining path fails | Hazardous output authority may persist | Test each path's ability to remove authority and observe independent result |  |
| Shared mechanical target loosened | Both sensors continue to agree with target rather than guard/member | Target shifts relative to protected object | Two channels agree falsely | Physical inspection plus challenge of protected object relationship |  |
| Stale communication value | Consumer does not distinguish fresh from old | Physical state changes after link loss | Frozen safe-looking state | Session/freshness invalidation and independent physical witness |  |

The examples are architecture patterns, not claims that any particular OpenPressBrake hardware has these faults.

## 3. Stimulus-to-observation trace

For every diagnostic or proof test, write the complete chain:

`test request -> actual stimulus -> sensing element -> electrical channel -> diagnostic logic -> independent observation -> pass/fail decision`

Then answer:

- Does the test physically move/change the element whose failure matters, or merely toggle a software bit?
- Does it challenge both polarities/states where applicable?
- Does the observation come from the same command path that generated the stimulus?
- Could a stuck feedback value pass because the expected state never changes?
- Could both channels pass because they share the same inadequate stimulus, target, power, reference, cable, controller, or software representation?
- Does loss of communication invalidate the prior result, or can `healthy` remain latched indefinitely?
- Does a failed or incomplete challenge prevent safety reset/rearm, or is it merely logged?

Frozen rule: **software self-consistency is not a physical proof test.**

## 4. Startup/restart diagnostic gate

A startup or restart challenge is valuable only when it answers a defined question. Record:

1. What prior `healthy` evidence became invalid at power loss/reboot?
2. Which safety-significant inputs must be observed changing state before accepting them as live?
3. Which final elements must be challenged, and what independent witness confirms response?
4. What cannot be safely challenged automatically at startup and therefore requires a controlled/manual test?
5. What happens when a channel begins already in the expected safe state and never transitions?
6. Are stale network/HAL/FPGA values explicitly invalid until a fresh session/generation is established?
7. Can reset/rearm occur while a required diagnostic is incomplete?
8. Does restarting ordinary LinuxCNC create any authority to clear a safety diagnostic? It must not unless the independently justified safety architecture explicitly provides that relationship.

## 5. Events that invalidate prior health

Treat prior `healthy` as suspect after events that can change the evidence path. At minimum review:

- controller, safety device, I/O, sensor, actuator, contactor, valve, drive, cable, connector, or power-supply replacement;
- field-wiring repair or terminal movement;
- guard, actuator, sensor target, bracket, linkage, blocking device, tooling, or machine-geometry work;
- safety configuration/firmware/parameter change;
- loss of power where diagnostic state is not retained with trustworthy identity;
- communication loss/reconnect or controller session change;
- maintenance bypass/override use;
- fault reset without proof that the causal fault was removed;
- evidence of intermittent behavior or disagreement;
- any change that invalidates the independence/common-cause assumptions documented for the witness.

A previous test report may remain historical evidence, but it does not automatically prove the current configuration.

## 6. Common-cause diagnostic blind spots

Two channels can both “pass” an inadequate diagnostic. Explicitly challenge these patterns:

- two inputs driven by one simulated software test bit;
- two sensors mounted to one loose target/bracket;
- two feedback values copied from one register/ADC;
- two channels sharing a failed reference or supply that biases both toward the expected state;
- two displays receiving one stale network value;
- two output paths whose diagnostic observes only controller commands, not final-element behavior;
- redundant devices configured by the same incorrect parameter/template;
- a proof test that checks both channels simultaneously and therefore cannot identify whether either alone can perform its intended function.

Use the separate sensor/feedback independence worksheet to trace dependencies rather than counting channels.

## 7. Proof-test question template

A proof test must begin with a question, not with available compute or instrumentation.

**Claim being tested:**

**Failure mode the test is intended to expose:**

**Why normal operation may not expose it:**

**Physical stimulus required:**

**Independent observation required:**

**Preconditions / hazard boundary:**

**Pass conclusion that is justified:**

**Claims the result does NOT justify:**

**Configuration/session identity:**

**Raw evidence retained:**

**Provenance:** `SOURCE-CONFIRMED` / `DOC-CONFIRMED` / `TEST-CONFIRMED` / `COMMUNITY-REPORTED` / `INFERENCE` / `UNKNOWN`

**Machine-specific acceptance value:** leave `UNKNOWN` unless independently established.

## 8. Cross-machine examples

### Press brake
A controller may command a hydraulic or electrical output OFF and see its command bit OFF. That does not prove a valve, contactor, brake, support, or ram state. Which physical diagnostics and proof challenges are appropriate is machine-specific and remains `UNKNOWN` until the actual architecture and measurements are available.

### CNC mill/lathe
A spindle-enable command going false is not the same evidence as an independently observed stopped spindle or removed drive authority. A feedback path that is only evaluated while the spindle is already stopped can conceal a stuck-safe indication.

### Plasma/router cell
A guard input that remains closed for months can conceal a stuck input if no controlled transition/proof challenge is ever observed. A second failure or bypass can then expose the latent defect.

### Automation cell / robot-like custom kinematics
Multiple HMI indicators can agree while all derive from one stale safety-status gateway. Freshness/session identity and independent physical observations must be preserved.

## 9. Adversarial review cases

Reject or escalate designs that answer these incorrectly:

1. “Both guard channels are ON, therefore both are healthy.”
2. “The E-stop was never pressed during commissioning, but its input reads healthy.”
3. “The contactor command is OFF, so EDM is unnecessary.”
4. “The feedback bit changed because the PLC test routine forced it.”
5. “Both redundant sensors passed, but both read the same simulated register.”
6. “The machine rebooted and restored the last `healthy` flag from storage.”
7. “A cable was replaced; no retest is needed because the safety program signature did not change.”
8. “A fault was reset and did not immediately recur, so the causal fault is gone.”
9. “A proof test checks the controller input but never exercises the physical switch/actuator/final element.”
10. “The diagnostic test is inconvenient, so operators have a maintenance flag that skips it.”
11. “Two channels share one mechanical target, therefore they are fully independent.”
12. “We need a proof-test interval, so use an industry-looking number.” The interval remains `UNKNOWN` until justified for the architecture/device/application.

## 10. Source-confirmed regulatory anchors

`SOURCE-CONFIRMED` — OSHA 29 CFR 1910.147(c)(1) requires an energy-control program including procedures, training, and periodic inspections. Paragraph (c)(6) requires periodic inspection of the energy-control procedure at least annually and correction of deviations/inadequacies. This supports the broader curriculum principle that a procedure's continued effectiveness requires deliberate verification rather than permanent trust in an old result.

`SOURCE-CONFIRMED` — OSHA 29 CFR 1910.147(c)(4)(ii)(D) requires specific requirements for testing to determine and verify effectiveness of lockout/tagout and other energy-control measures; paragraph (d)(6) requires the authorized employee to verify isolation and deenergization before work.

`SOURCE-CONFIRMED` — OSHA 29 CFR 1910.147(d)(5)(ii) requires continued verification where hazardous stored energy can reaccumulate. This is a useful example of why one past-safe observation cannot be treated as indefinitely fresh.

`SOURCE-CONFIRMED` — OSHA's enforcement guidance describes periodic inspections as an essential check on continued utilization/effectiveness of procedures and requires correction of deficiencies.

`SOURCE-CONFIRMED` — OSHA's 2008 PLC interpretation warns against assuming ordinary PLC control is effective hazardous-energy protection for servicing, citing component failure, program error, interference, surges, and improper use/maintenance; the minor-servicing exception requires a case-specific effective-protection demonstration. This reinforces the LinuxCNC/ordinary-FPGA authority boundary rather than assigning safety authority to normal control software.

These sources do not establish a diagnostic-coverage percentage, a proof-test interval for a safety device, or OpenPressBrake-specific safety performance.

## 11. Minimum completion gate

Do not call a diagnostic strategy adequate until the design record can answer:

- What faults are continuously detected?
- What faults require a state transition or demand?
- What faults require a deliberate proof test?
- What faults can remain latent?
- What second fault/demand makes each important latent fault dangerous?
- Does each test stimulate the physical path that matters?
- Is the observation independent enough for the claim?
- What common causes can let redundant channels pass together falsely?
- What events invalidate a previous `healthy` result?
- What prevents stale/rebooted state from being treated as fresh evidence?
- What machine-specific values remain `UNKNOWN`?
- Is LinuxCNC/ordinary FPGA clearly outside independent personnel-safety authority?

## Next independent work

If the primary lane remains elsewhere, build a **proof-test stimulus and observability matrix** that maps safety-significant sensors/final elements to the minimum physical stimulus, independent witness, stale-state invalidation, safe test preconditions, and bounded conclusion. Keep it cross-machine and do not invent intervals, diagnostic coverage, pressure/speed thresholds, stopping distances, or hydraulic truth tables. If the primary lane takes that topic, switch to a distinct **fault-reset causal-clearance / recurring-fault escalation** study.