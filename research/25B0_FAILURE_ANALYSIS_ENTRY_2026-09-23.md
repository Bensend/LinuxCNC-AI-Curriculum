# 25B0 — Failure analysis and fault injection: entry map

## Scope

25B0 begins after 25A0's programmable-safety release gate. Its job is not to create theatrical fault tests. It teaches how to derive fault injection from the safety function and fault model, then compare the predicted reaction with observable machine evidence.

## Core analysis chain

`SRS/safe-state proposition -> functional decomposition -> credible fault -> expected detection -> expected reaction -> maximum tolerated detection/reaction interval -> observable evidence -> injection method -> result -> redesign/revalidation`

A test is justified only when it resolves a concrete uncertainty that source/engineering reasoning cannot adequately resolve.

## FMEA, FMEDA and fault-tree roles

- **FMEA:** component/subsystem-up reasoning: if this item fails in this mode, what local and system effects follow?
- **FMEDA:** extends failure-mode analysis with quantitative failure-rate/diagnostic treatment where valid source data and method assumptions exist. Do not invent rates or diagnostic coverage.
- **Fault tree:** hazard/top-event-down reasoning: what combinations of failures or conditions can produce the dangerous event?

These are complementary. A spreadsheet containing many component rows is not automatically a machine safety argument.

## Fault classes to preserve independently

1. single dangerous faults;
2. latent faults that remain hidden until demand or a second fault;
3. common-cause/common-dependency faults defeating nominal redundancy;
4. power-supply faults and brownout/restart behavior;
5. broken wires, shorts to rails and cross-shorts;
6. welded/stuck final elements;
7. stuck hydraulic/pneumatic valves;
8. sensor disagreement, frozen or plausible-but-wrong feedback;
9. frozen software/task/watchdog failure;
10. safety-network loss, delay, stale/replayed/corrupted-message handling as applicable;
11. corrupted/stale configuration or wrong replacement parameters;
12. maintenance/proof-test omissions that allow latent faults to accumulate.

## First fault-tree teaching example

Top event: `guard opens while hazardous spindle motion remains accessible`.

Potential branches include:

- guard-unlock logic incorrectly asserts safe;
- speed/stopped-state sensing fails dangerously or is misconfigured;
- safety communication/output path fails without required safe reaction;
- guard-lock final element fails mechanically;
- stop command succeeds but spindle coast exceeds the assumed release interval;
- two nominal evidence channels share one sensor/power/mechanical dependency;
- maintenance parameter change lengthens a monitoring interval without revalidation.

The example deliberately avoids invented stopping time, PL/SIL, diagnostic coverage or failure-rate values. Those remain application evidence questions.

## Fault-injection design rule

Do not inject a fault merely because it is easy to simulate. For each proposed injection, record:

- safety requirement being challenged;
- fault model and provenance;
- why analysis/documentation is insufficient;
- injection boundary and whether the injection itself creates uncontrolled hazard;
- predicted safe reaction and observable signals;
- timeout/acceptance criterion only when sourced or measured;
- personnel isolation required;
- result provenance (`TEST-CONFIRMED` only after authoritative execution);
- residual uncertainty.

If minimum safe-to-operate conditions are not already established, physical fault injection with people exposed is prohibited; use isolated/remote testing or a low-energy/simulated model.

## Initial freezes

- **FAULT INJECTION COUNT != DIAGNOSTIC COVERAGE.**
- **FAULT DETECTED != PHYSICAL SAFE STATE ACHIEVED.**
- **SINGLE-FAULT TEST PASS != COMMON-CAUSE RESILIENCE PROVED.**
- **SOFTWARE-INJECTED FAULT != PHYSICAL FAILURE EQUIVALENCE PROVED.**
- **EXPECTED ALARM OBSERVED != FINAL ELEMENT SUCCESS PROVED.**
- **FMEA COMPLETE != FAULT TREE COMPLETE.**
- **NO SURPRISES IN TEST != NO LATENT FAULTS.**
- **SIMULATED SAFE REACTION != MACHINE VALIDATION.**

## LinuxCNC boundary

LinuxCNC/HAL/FPGA diagnostics can provide useful observability and can request normal stopping behavior. They do not acquire personnel-safety authority because 25B0 injects or monitors faults through them. Independent safety-related control and physical energy-removal/restraint mechanisms remain authoritative.

## Exact next work

1. Build a machine-neutral fault-injection matrix spanning power, wiring, sensor, logic, communication, final-element and physical-state faults.
2. Add latent-fault and CCF examples showing why sequential single-fault testing can miss dangerous combinations.
3. Develop a safe test-selection hierarchy: source inspection -> static reasoning -> low-energy model -> isolated simulation/bench -> guarded/remote machine test only when justified.
4. Create adversarial cases for frozen plausible feedback, welded output plus misleading feedback, stuck valve, corrupted parameter set and network timeout.
5. Only freeze an executable lab if one of those questions cannot be resolved adequately from authoritative evidence.

## Compute

No executable compute is justified at this entry stage. No GitHub-hosted runner is authorized or used.
