# Safety Fault-Injection / Diagnostic-Evidence Catalog

Status: SAFETY CURRICULUM WORKING CONTRACT — machine-agnostic; no PL/SIL/DC claim

Purpose: teach and validate what a safety architecture can actually observe when realistic faults are introduced. This catalog deliberately separates **physical hazardous outcome**, **safety-function response**, **diagnostic observation**, **reset/rearm permission**, and **ordinary LinuxCNC/FPGA telemetry**. A diagnostic bit is never substituted for physical interruption evidence.

## Evidence vocabulary

Use the curriculum evidence classes without promotion:

- `SOURCE-CONFIRMED` — directly supported by inspectable source/standard text.
- `DOC-CONFIRMED` — directly supported by manufacturer/product documentation.
- `TEST-CONFIRMED` — deliberately stimulated and independently observed on the identified implementation.
- `COMMUNITY-REPORTED` — reported implementation behavior not independently reproduced.
- `INFERENCE` — engineering conclusion from identified evidence; state assumptions.
- `UNKNOWN` — not established. `UNKNOWN` must never be silently converted to safe/healthy.

## Architecture boundary

For every injection, record these independently:

1. **Fault stimulus** — what was deliberately changed or failed.
2. **Physical state** — actual contacts, energy path, actuator state, motion/pressure/energy where relevant.
3. **Safety demand path** — what independent safety circuitry should command.
4. **Diagnostic witness** — what feedback or discrepancy is actually observable.
5. **Normal-control telemetry** — LinuxCNC/FPGA/HMI observation, which may aid diagnosis but does not manufacture safety authority.
6. **Reset eligibility** — whether the safety function may accept reset.
7. **Restart/rearm eligibility** — separate deliberate action after reset; restoration alone is not restart.
8. **Evidence class** — what justifies each conclusion.

Do not calculate or imply diagnostic-coverage percentage, Category, PL, SIL, PFHd, stopping distance, or machine suitability from this catalog.

## Source-backed diagnostic principles

`DOC-CONFIRMED` principles used by this catalog:

- Rockwell Guardmaster examples use separately pulsed safety-input channels so loose/open wiring, shorts to 24 V, shorts to ground, and cross-channel faults can be detected; detected faults open safety outputs and can prevent reset until the fault is corrected.
- Rockwell documents contactor feedback using N.C. contacts so a welded contact can hold the feedback path open and help prevent safety-relay reset.
- Schneider TM3 safety-module documentation states that two-channel interlock behavior requires both channels to be observed open before a new safety cycle, helping expose a channel that cannot open because of contact malfunction or a short circuit.
- Schneider EDM documentation uses N.C. external-contactor feedback in the start condition; the start condition is valid only when the required feedback is closed. It also explicitly limits what that implementation observes: its external-device state is checked while validating start, not continuously while outputs are active.
- Pilz describes feedback-loop monitoring as checking N.C. contacts to establish that external relays/contactors reached their safe state before they are operated again.

These are topology/behavior examples, not a declaration that every safety relay detects every listed fault. Detection capability must be tied to the exact device, wiring and test-pulse architecture.

## Fault-injection catalog

| ID | Injection | Required independent observation | Safe curriculum expectation | Evidence result to record |
|---|---|---|---|---|
| FI-01 | Open one conductor in safety input channel A | Raw A/B states plus safety output state | Fault/disagreement must not be hidden by normal-control software; safety response follows exact device/wiring contract | detected / not detected / UNKNOWN, latency if measured |
| FI-02 | Open channel B | Same as FI-01 | Symmetric exercise; do not assume symmetry without evidence | same fields |
| FI-03 | Short one safety input to 24 V | Pulsed/test-output witness where implemented | A device documented to detect this wiring fault must inhibit unsafe continuation/reset according to its contract | exact fault indication + output response |
| FI-04 | Short one safety input to 0 V/ground | Independent input/output observation | Same evidence discipline as FI-03 | exact indication/response |
| FI-05 | Cross-short dual channels | Channel/test-pulse states | Detection is only claimed when the exact architecture supports cross-fault detection | detected / undetected / UNKNOWN |
| FI-06 | One input contact stuck closed while the protective device is actuated | Both physical contact state and evaluator input state | A dual-channel/interlock architecture should expose failure to complete the required transition if documented to do so; reset/restart remains inhibited when required transition evidence is absent | transition evidence and reset result |
| FI-07 | One input contact stuck open | Input states + output state | Must not be auto-promoted to healthy after other channel changes | response + diagnostic state |
| FI-08 | Both input channels forced to the same plausible state by a common-cause wiring fault | Independent wiring/test-pulse evidence | Do not claim detection merely because two channels exist; record common-cause detectability honestly | detected / undetected / UNKNOWN |
| FI-09 | K1 main power contact welded closed after stop demand | K1 documented mirror/feedback contact + K2 state + abstract energy path | Commanded coil OFF is not proof of main-pole opening; documented feedback discrepancy inhibits rearm where EDM contract requires it | main state, feedback, rearm |
| FI-10 | K2 main welded | Same as FI-09 | Same discipline | same fields |
| FI-11 | Both redundant interruption devices fail closed | Physical main-pole/energy-path observation | Report failure of interruption; never hide it behind a generic `safe` diagnostic flag | hazardous path state + diagnostics |
| FI-12 | EDM/feedback conductor open while contactor physically released | Physical contactor state separated from observed feedback circuit | Physical path may be interrupted while proof is unavailable; reset/rearm remains inhibited when feedback is required | `physical_open`, `feedback_unknown/open`, rearm result |
| FI-13 | EDM/feedback shorted or bypassed so it appears healthy | Physical main state + independent inspection/test | A healthy-looking feedback bit cannot be accepted when the witness circuit itself is defeated | false-safe witness captured |
| FI-14 | Ordinary auxiliary contact substituted for a documented mirror/forced-guided witness | Main-pole state + auxiliary relationship documentation | Reject semantic substitution unless the exact contact relationship is documented for the intended monitoring function | evidence gap / correct witness |
| FI-15 | Reset input held active through a safety demand/recovery | Reset input edge/history + output state | Monitored-reset architecture must require its documented deliberate transition; held reset must not become automatic restart | reset acceptance/rejection |
| FI-16 | Start/cycle command held active while safety condition restores | Start history + machine normal-control state | Safety restoration/reset must remain distinct from machine restart; stale/held normal command must not create unexpected motion | restart result |
| FI-17 | Safety-device power loss | Safety output + diagnostic state | Fail according to documented de-energized behavior; no automatic production rearm on restoration | power-loss and restore traces |
| FI-18 | Safety evaluator internal fault indication, where safely injectable/simulatable | Safety outputs and diagnostic indication | Independent safety output should enter documented fault response; ordinary FPGA/HMI may report but not override it | exact device response |
| FI-19 | Normal FPGA watchdog expires while independent safety chain remains healthy | FPGA output gate + independent safety state | Normal actuator authority is removed by FPGA contract, but this is **not** evidence that independent personnel-safety functions operated | separate normal/safety states |
| FI-20 | LinuxCNC/host communications lost | command-generation/freshness witness + safety chain | Stale normal commands lose ordinary output authority per controller contract; comms loss alone does not prove physical energy isolation | freshness/gate state + safety state |
| FI-21 | Communications restore with stale nonzero actuator command cached | command generation ID/freshness + physical output | Require explicit normal rearm and fresh command; do not replay stale actuator demand | no-replay evidence |
| FI-22 | HMI/PLC diagnostic bit falsely forced `SAFETY_OK` while independent safety output is false | Independent safety-output wiring/state | HMI/normal software cannot manufacture permission; contradiction must remain visible | authority-source comparison |
| FI-23 | Feedback sensor disagreement (two channels disagree) | Both raw channels, evaluator output, diagnostic | Preserve disagreement as a fault/unknown state; do not average or vote it away unless exact certified architecture says so | raw + evaluated states |
| FI-24 | Feedback sensor frozen at last-good value | Independent stimulus/physical state + sensor value | A plausible stale value is not fresh evidence; record whether exact architecture detects freshness/stuck state | freshness witness or UNKNOWN |
| FI-25 | Guard/interlock mechanically defeated while electrical switch remains satisfied | Physical inspection/independent guard-state evidence | Electrical `guard_closed` alone is not proof the physical safeguard remains effective | defeated-guard evidence |
| FI-26 | Stored hydraulic/electrical/mechanical energy remains after safety outputs open | Energy-source-specific verification | Safety-output opening is not LOTO/zero-energy proof; residual energy remains a separate hazard state | energy verification evidence |
| FI-27 | Reaccumulating energy after initial verification | Repeated energy-specific observation | Maintenance-isolated state cannot rely on one stale verification where reaccumulation is credible | repeated verification result |
| FI-28 | Power cycle after a latent fault | Physical fault state + reset/rearm state | Power cycle must not erase the physical fault or convert missing evidence to healthy | persistent-fault witness |
| FI-29 | Configuration/wiring changed after previous PASS | configuration identity + change-control record | Prior evidence is reopened according to dependency impact; do not inherit PASS blindly | invalidated evidence IDs |
| FI-30 | Diagnostic indicator/LED reports healthy while independent feedback disagrees | Indicator plus independent witness | Treat indication as diagnostic only; contradiction fails closed for claims requiring the independent witness | discrepancy record |

## Required test record

For each executed case record:

```text
Test ID:
Safety function / hazard boundary:
Exact hardware + firmware/config revision:
Fault stimulus:
Preconditions:
Expected physical response:
Expected independent safety response:
Expected diagnostic response:
Expected reset behavior:
Expected restart/rearm behavior:
Observed physical response:
Observed independent safety response:
Observed diagnostic response:
Observed reset/restart behavior:
Evidence class for each observation:
Contradictions / UNKNOWNs:
PASS / FAIL / INCONCLUSIVE:
Restoration proof before return to service:
```

`PASS` requires the predeclared physical and authority-boundary expectations to be observed. A useful diagnostic message with the wrong physical response is FAIL. A physically safe result with unavailable required diagnostic/rearm evidence may still be FAIL or INCONCLUSIVE for the diagnostic requirement; do not collapse those dimensions.

## Safety Sandbox acceptance set

The simulator/evaluator should eventually include at least these adversarial checks without assigning real-machine PL/SIL claims:

1. single-channel open;
2. cross-channel short with and without a topology capable of detecting it;
3. one welded contactor with the redundant contactor opening;
4. both contactors welded;
5. broken EDM wire with physically open main poles;
6. bypassed EDM giving a false healthy witness;
7. held reset through recovery;
8. held normal start command through safety restoration;
9. FPGA watchdog trip while independent safety remains healthy;
10. stale network command after reconnect;
11. HMI-forged safety status contradicting the independent chain;
12. residual/reaccumulating energy after electrical interruption.

The teaching objective is not `detect everything`. It is to make learners state **which fault is detectable, by what physical witness, at what time, and what remains unknown**.

## Practical design rules frozen by this catalog

- Prefer diagnostic wiring that fails conspicuously rather than plausibly healthy when a conductor opens.
- Keep raw channel observations available for diagnosis; do not expose only a combined `safe` bit.
- Preserve test-pulse/channel identity when the selected safety device uses it for cross-fault detection.
- Use the exact documented feedback relationship for final switching elements; do not casually substitute an unrelated auxiliary contact.
- A latent fault caught before reset is still a real fault requiring correction; redundancy surviving one demand does not justify routine continued operation.
- Reset clears an eligible latched state; it does not repair a welded contact, broken wire, defeated guard, residual energy source, or stale normal command.
- Power restoration, network restoration, watchdog recovery and safety reset do not by themselves authorize production restart.
- Ordinary LinuxCNC and OpenPressBrake FPGA diagnostics should be rich and useful, but independent safety authority stays independent.

## Boundaries / VERIFY_AT_MACHINE

Before any machine-specific use, identify the exact safety evaluator, wiring topology, test-pulse scheme, contactor/valve feedback relationship, energy paths, guard devices, reset/restart architecture and manufacturer instructions. Press-brake hydraulic behavior, valve safe states, stopping distance, pressure thresholds, accumulator behavior and final safety performance remain `VERIFY_AT_MACHINE` until supported by machine documentation, measurements and the actual safety design.

## Next independent branch

Build a **fault-injection coverage map by safety function**: E-stop, guard/interlock, final-element EDM, reset/restart, hazardous-energy isolation and ordinary-controller watchdog. Link each function to the smallest meaningful adversarial test set and identify explicitly untestable/UNKNOWN failure modes. Do not convert test-count coverage into a diagnostic-coverage percentage.
