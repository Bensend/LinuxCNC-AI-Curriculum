# 4400-PULSE-01 — Do not confuse OSSD output tests with controller input-test pulses
**2026-10-26 | NON-GRADUATED | practical documentary safety lesson**

Read the [original Pilz PSEN opII4H / PNOZ m0p source audit](../research/4400_PILZ_PSEN_OSSD_300US_VS_PNOZ_TEST_OUTPUT_5MS_SCOPE_AUDIT_2026-10-26.md).

## Learning objective
Given a proposed guard/curtain and safety-controller interface, a fresh engineer must identify **which device is sending the test pulse, what fault it detects, which receiver must tolerate it, and which physical safety function it actually protects**. A pulse timing figure from one port must not be applied to another.

| Question | PSEN opII4H OSSD self-test | PNOZ m0p test-source output |
|---|---|---|
| Direction | Sensor safety output to qualified evaluation input | Safety controller test source to selected monitored inputs |
| Why pulse? | Sensor output self-diagnosis | Detection of input wiring faults (including cross-shorts in specified wiring) |
| Manufacturer number | Up to 300 µs pulse for examined PSEN variants | Up to 5 ms OFF interval for examined PNOZ m0p test outputs |
| Qualified requirement | Receiver must bridge short OSSD pulse **and** evaluate genuine protective change | Test source only for specified inputs; not for load driving; preserve wiring and assignment |
| Unsafe shortcut | Use arbitrary LinuxCNC debounce or infer safety from digital input | Drive a valve/contactor from test-source output or reuse mat pulse supply |

These are **different OEM devices and different circuits**. Do not treat 300 µs versus 5 ms as a design trade-off or select a generic filter threshold from this table. Exact compatibility and system safety performance require product-specific qualified design.

## Machine boundary
Ordinary LinuxCNC/FPGA may display an OSSD-related diagnostic and inhibit normal commands, but it is not the independent personnel-safety evaluator. A safety-rated input/controller must retain hazard-demand detection and appropriate fault monitoring. Physical stopping, gravity holding, hydraulic isolation and reset/restart remain independently witnessed. Guard/beam coding changes can also change response time, requiring new protective-distance analysis.

## Practical human factors
A nuisance-trip problem must be diagnosed at the exact source/receiver interface, not fixed by an undocumented jumper or progressively increasing a software filter until the alarm disappears. Provide readable fault indication, appropriate connectors and routing, and an easy documented path for replacing the exact configured safety device. Changes reopen the safety function's validation.

## Adversarial prompt (UNSCORED)
An integrator sees a 5 ms test-output OFF interval in a safety controller manual and uses it as the allowed OSSD pulse duration for a different light curtain, then sends the curtain's OSSD to LinuxCNC and adds a 10 ms debounce. Identify the two category errors, the missing independent safety path, the first exact documents needed, and the qualified no-exposure verification gates. Do not propose a live experiment.

**Evidence:** DOC-CONFIRMED OEM product numbers, INFERENCE architecture, UNKNOWN installed machine and physical proof. TEST-CONFIRMED none; independent evaluator not run. G0/G1 HOLD; no personnel-exposed operation.
