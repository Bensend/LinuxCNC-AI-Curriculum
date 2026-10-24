# 4400 technician card — Safe output, auxiliary status, or diagnostic test pulse?

**PAPER ONLY / NOT SCORED / NOT A MACHINE TEST.** Source: [original Pilz PNOZ m B0 1002660-EN-13 exact-manual audit](../research/4400_PILZ_PNOZ_MB0_SAFE_VS_AUX_OUTPUT_TEST_PULSE_CUTOVER_SOURCE_AUDIT_2026-10-24.md). Read manufacturer [original manual](https://www.pilz.com/download/open/PNOZ_m_B0_Operating_Manual_1002660-EN-13.pdf), printed pp.8–11, 26–30 and 45. The example is **not** evidence that this product is installed on any selected press brake.

## Ten adversarial cases

For every case: identify `producer → receiver → final element`, classify the exact source proposition, name an independent physical witness, and state which `ARC/DEP/PHY/VAL/PT/CHG` evidence remains UNKNOWN.

| Case | Scenario | Required discriminator |
|---|---|---|
| PO-01 | A 24 V `IM` auxiliary status is connected to a new FPGA pin labeled SAFETY_ENABLE. | Manufacturer explicitly excludes standard I/O from safety-related applications. A status input is not final-element authority. |
| PO-02 | A technician moves an actuator wire from `O0` to `T0M20` because both are 24 V. | Safe output versus diagnostic test-pulse/auxiliary output; roles, pulse and current are not interchangeable. |
| PO-03 | A reviewer applies a 5 ms OFF-pulse tolerance from a test output to the safe semiconductor output. | Exact PNOZ m B0 manual specifies **different** product-specific maximum OFF intervals: 5 ms versus 330 µs; neither is machine stop time. |
| PO-04 | A PLC output reads OFF but a sensitive electronic receiver still detects a signal. | Check product-specific residual current, receiver thresholds and load; OFF label is not physical final-element open proof. |
| PO-05 | The new cabinet bundles test-pulse and actuator wires in one unprotected cable to simplify installation. | Manufacturer §7.1 warns against this routing; cross-short diagnostic coverage must be re-reviewed. |
| PO-06 | The PLC RUN LED remains green while the output supply wiring is modified. | Controller status does not establish output supply, output withdrawal or machine safe state. |
| PO-07 | The project CRC matches after a chip-card exchange; commissioning test is skipped. | OEM §7.5 requires safety-device function check after card exchange/project download/delete. CRC does not validate wiring or physical reaction. |
| PO-08 | A suppressor is added across a DC contactor coil; stop time is assumed unchanged. | Source lead: DC coil suppression can affect dropout. Require exact OEM/selected-device data and new physical stopping proof, not a guessed delay. |
| PO-09 | The OEM's two-load/single-safe-output example is copied without a feedback loop or wiring segregation. | The printed p.29 example has explicit prerequisites; do not transplant its integrity claim or schematic. |
| PO-10 | The safety PLC's ordinary network output reports STOP; the HMI automatically resets and restarts after reconnect. | Separate network diagnostic status, independent safety reset, occupancy, final-element state and fresh local ordinary start. |

## Small design task

Draw three *distinct* signal chains: (1) protective input and **qualified safety output** to a physical final element; (2) ordinary auxiliary status to LinuxCNC/HMI; (3) diagnostic test pulse through the correct sensor/input path. Annotate which terminal/configuration identity must be captured. Add the separate lockable service-energy path. Do **not** assign a generic PL/SIL or a numerical stop criterion.

## Human-factor redesign

A harness that permits swapping safe, auxiliary and test-pulse terminals without warning is an error-prone design. Prefer unmistakable terminal role labels, controlled pin maps, keyed/segregated connectors where appropriate, configuration review and a simple post-change witness checklist. Make it faster to restore the correct guard and connector than to bypass it.

## Gate

`PO-01..10 PAPER ONLY`; selected product presence **UNKNOWN**, independent physical witnesses **NOT RUN**, fresh external competency **NOT SCORED**. No person-exposed operation or unsafe energized fault injection is authorized. If a different PLC model is installed, **do not** transplant the PNOZ m B0 numerical data; obtain its own original manual.
