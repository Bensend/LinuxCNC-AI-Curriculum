# C05-029 Attempt 11 — ACCEPTED / TEST-CONFIRMED

## Authority
- Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`
- Harness source: `374e4c159a18e340a70b014a375f8e1fe7edb04d`
- Workflow: `34263426729`
- Job: `102186773618`
- Artifact: `10070970999`

## Observation validity
Attempt 11 uses the predeclared single-FIFO atomic observer. The retained trace contains 6,568 strictly ordered 20-field realtime samples with zero sampler overruns. The checkout provenance is exact. The only LinuxCNC observer modification is the predeclared userspace `sampler_usr.c` serialization precision change from `%f` to `%.17g`; it does not change realtime control, fault injection, PID, plant, or cross-coupler behavior.

This observer-only precision correction was required because the frozen residual tolerance is `1e-9` while `%f` text serialization quantizes HAL_REAL observations at about `1e-6`. The tolerance was not weakened.

## Frozen-gate reconciliation
All predeclared Gates A–H PASS with the previously frozen transforms and parameters unchanged:

- normal measurement: `measured_B = true_B`
- wrong-scale measurement: `measured_B = 1.20 * true_B`
- jump/offset measurement: `measured_B = true_B + 0.50 in`
- cross-coupler remains `Kc = 0.5`
- PID/plant gains, phase durations, and gate thresholds are unchanged.

Arithmetic verification:
- scale-phase maximum transform residual: exactly `0`
- jump-phase maximum transform residual: approximately `4.44e-16`, below frozen `1e-9`

## Result
**TEST-CONFIRMED.** The same simulated plant state can be presented to LinuxCNC through a deliberately wrong feedback scale or an injected feedback jump, and the controller/cross-coupler reacts to that corrupted measurement. Together with accepted C05-028 frozen-feedback evidence, this demonstrates the current-level mechanism required by C05.

## What this does not prove
The fixture's `true_B` is a simulation reference, not physical metrology. In a real machine, disagreement between commanded/observed channels alone does not identify whether the cause is actuator motion, encoder mechanics, wiring, electronics, scaling/configuration, transport, or another common-mode error. Independent reference evidence is required to distinguish measurement truth from plant truth.

`wrong/frozen/jumped feedback != proven wrong/frozen/jumped physical position`

Ordinary HAL/PID logic and this diagnostic experiment are not safety-rated sensor-fault handling.

## Attempt history
Attempts 1–10 remain retained with their original harness-invalid classifications. Their failures are not retroactively converted into LinuxCNC behavioral evidence.