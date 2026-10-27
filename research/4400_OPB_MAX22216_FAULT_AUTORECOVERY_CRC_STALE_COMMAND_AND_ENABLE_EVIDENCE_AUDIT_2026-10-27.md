# 4400-OPB-DRV-05 — MAX22216 hardware ENABLE, diagnostic persistence, automatic recovery and SPI stale-command boundaries

**2026-10-27 | Original Analog Devices Rev. 2 source-depth audit against pinned OpenPressBrake Rev 1 design | NON-GRADUATED | NO HARDWARE TEST**

## Bounded engineering question and predecessor reconciliation

Does a MAX22216 fault indication prove that the proportional coil was disabled, that its current command was rejected, or that a prior fault remains observable after the retained Pilz permission withdraws and later restores the ordinary driver ENABLE? Can a communications CRC error be assumed to zero the old current command? **No such general implication follows from the manufacturer datasheet.** The exact behavior depends on the fault type, configuration, enable state and independent machine safety chain.

Predecessors read directly: [OPB-CUTOVER-02 wire-75 and Pilz boundary](4400_OPB_CUTOVER_02_PILZ_MUTE_GATE_POWER_DOMAIN_CROSS_REPOSITORY_SOURCE_AUDIT_2026-10-27.md), [four-prerequisite MAX22216 enable/fanout source audit](4400_OPB_CUTOVER_02_MAX22216_FOUR_INPUT_GATE_FANOUT_AND_STALE_AUTHORITY_RECONCILIATION_2026-10-27.md), [OPB-ISO-03 field-power diagnostic validity](4400_OPB_L7_L07_ISOLATOR_POWER_LOSS_FAULT_DIAGNOSTIC_POLARITY_SOURCE_AUDIT_2026-10-27.md), [OUT-01 detected fault/load still energized](4400_ROCKWELL_POINTMAX_SAFETY_OUTPUT_SA_BACKFEED_DETECTED_NOT_SAFE_OEM_AUDIT_2026-10-25.md), and [safety-course canonical index](../safety-course/SAFETY_COURSE_INDEX.md)/[research plan](../SAFETY_COURSE_RESEARCH.md)/[progress](../PROGRESS.md). These already establish independent safety authority and the two-MAX22216 ENABLE topology. **Increment here:** original MAX22216 fault-by-fault behavior and fault-history loss at ENABLE withdrawal; precise CRC rejection semantics; manufacturer distinctions between an automatically recovering OVT, a diagnostic-only HHF, a latching OCP, and a VM brownout preserving volatile registers. This is *source-depth on an existing mechanism*, not a new safety function or a fresh paper-exam bank.

## Primary sources, version and confidence

**DOC-CONFIRMED original manufacturer:** Analog Devices, *MAX22216/MAX22217 Quad Smart Serial-Controlled Solenoid and Motor Driver with Advanced Diagnostic*, **Rev. 2, 20 October 2023**, official PDF https://www.analog.com/media/en/technical-documentation/data-sheets/max22216-max22217.pdf . Directly inspected printed pp. **11–14, 22, 43–47** (web PDF pp. 10–13, 21, 42–46). Product identity/edition independently shown at https://www.analog.com/en/products/max22216.html . This is an ordinary driver datasheet, **not** a functional-safety certification or proof of a press-brake stop.

**SOURCE-CONFIRMED public design, not installed machine:**
- OpenPressBrake `hardware/integration/REV1_OUTPUT_INHIBIT_AUTHORITY.yaml`, Git blob `91e1a64c502c8cd7001b8c13d0933f591b824147`: schema v3, four prerequisites `PILZ_VALVE_ENABLE_LOGIC && WATCHDOG_OK && FPGA_CONFIGURED && CORE_POWER_GOOD`, one hardware gate to **both** MAX22216 ENABLE pins, local fail-low biases; implementation proof **OPEN** and wire-75 field electrical qualifier **VERIFY_AT_MACHINE**.
- `hardware/integration/REV1_PROPORTIONAL_ENABLE_FANOUT_CONTRACT.md`, blob `0c0d5fa48cc81dbdc334d31d0673088299fb1fa4`: independent wire-75 conditioning, two sinks, and no ordinary software override.
- `hardware/blocks/proportional_valve_driver/manifest.yaml`, blob `3a01642a19766e4342e8c900ad934de1d386a566`: two MAX22216 devices, six logical proportional channels, two unused forced inactive, shared SPI and per-device `N_FAULT`, `CNTL0..3` physically low, per-channel software CNTL, ordinary OFF by CNTL clear, no safety credit.
- `hardware/blocks/proportional_valve_driver/STATUS_CHECKLIST.md`, blob `c21f4c7b1aa2d9313fea940fa85abef33b8d196c`: **NOT YET SCHEMATIC-READY**; CRC_EN tied high / 32-bit SPI, fault handling intended to clear affected CNTL, readback/fresh command after ENABLE restoration. FPGA CRC regression and physical implementation not yet accepted.

**Date discipline:** OpenPressBrake design artifacts above are historical published source first audited/extended here, not claimed to be new board commits on 2026-10-27. The latest observed OpenPressBrake `main` commit is `92cf5424be90f45f664ba2652dc725b38e1895f9` dated **2026-09-24T13:23:20Z**; a public source tree is not an as-built machine.

## Six exact manufacturer distinctions

| State/event | Rev. 2 manufacturer behavior | Invalid inference to reject |
|---|---|---|
| `ENABLE=0` | Disables the device; dedicated internal pull-down; after an ENABLE rising edge, **at least 0.8 ms high** is required for the documented enable sequence (pp. 11, 14, 22). The fault registers can be **cleared by driving ENABLE low** (p. 43). | `ENABLE LOW` proves Pilz hydraulic final elements, gravity holding or pressure safe; or the last fault remains available after inhibit. |
| `VM` below UVLO while digital core has not POR-reset | All output channels tri-state; UVM indicated. Logic registers **retain content until VDD falls below its separate digital POR threshold** (pp. 43–44). | Supply dip necessarily resets old commands/configuration, or any output state after restoration is established without reading the exact state and hardware gate. |
| Overtemperature `OVT` | All outputs disabled while too hot; **operation automatically resumes after cooling**, with fault flag retained until cleared (p. 45). | Every asserted fault is a latched OFF requiring a human reset. This is an ordinary IC thermal recovery, not a permitted machine restart. |
| `HHF` hit-current-not-reached | Sets diagnostic flag and optionally FAULT; **does not tri-state the driver** (p. 45). | `N_FAULT` asserted guarantees that all coil current is gone. |
| Overcurrent `OCP` | Affected channel tri-stated; fault flag cleared separately; return to normal requires the prescribed channel-off transition (p. 45). | Clearing the bit alone energizes/re-enables a channel, or the behavior of OCP can be generalized to OVT/HHF. |
| SPI CRC error with `CRC_EN` high | Erroneous transaction **does not change configuration**; `COMER` is reported on **next** SPI status byte (pp. 46–47). The read data for a read request arrives on a **subsequent** SPI transaction (p. 46). | CRC failure necessarily commands zero current; the response to a read is same-transaction data; a single successful status read proves fresh current setpoint. |

Additional **DOC-CONFIRMED** diagnostic nuance: `FAULT` is **active-low open drain**, needing a pull-up (p. 14). Its assertion can be **masked** by configurable bits; `IND` and `RES` are not presented on FAULT even without masking (p. 43). UVM/OVT can use comparator-versus-latched selection and optional fault-stretch timing; an interrupt pin is not a complete fault log. These distinctions are ordinary electronics, not safety-rated diagnostic coverage.

The manufacturer's **20 µs ENABLE falling-edge-to-OUT-tristated** and **0.8 ms enable** table values (p. 11) describe the IC under stated test conditions. They are **not** an assembled-board timing bound, valve movement time, hydraulic stop, ram stopping distance or protective-device response. No such numbers are transferred to the selected machine.

## Cross-layer failure-path review (INFERENCE, NOT observed OpenPressBrake behavior)

**A — Inhibit can erase the diagnostic witness.** Suppose an ordinary `N_FAULT` was asserted just before independent permission withdrawal. The wire-75-derived hardware permit goes LOW, which the manufacturer says can clear device fault registers. The normal controller also loses SPI access while ENABLE is LOW under the existing Rev23 design contract. A later absence of a fault indication **cannot** establish that the preceding fault never occurred. A non-safety diagnostic logger should capture any already-available fault/status and power-valid context *before or independently of* the inhibit where feasible, but **must never delay, override or condition the hardware inhibit**. Do not add an unsafe hold-high just to preserve logs.

**B — Recovery can occur without a fresh external safety decision at the IC.** OVT cooling automatically resumes ordinary IC operation; a VM brownout can preserve register content if the digital POR threshold is not crossed. Whether this causes actual coil current depends on ENABLE, ACTIVE, CNTL, VM, SPI configuration and circuit; **no physical re-energization is asserted**. The proposed board must keep the independent permission dominant and its separate fresh-command/readback policy effective after any recovery.

**C — A rejected SPI write may leave the prior command in effect.** With CRC enabled, a corrupted OFF/setpoint write does **not** replace the previous configuration. If the previous accepted command was nonzero, an ordinary controller that treats COMER as mere telemetry might retain unintended current. This is a **conditional design hazard**, not a measured current. Normal firmware should verify command acceptance/readback, withdraw ordinary permission or enter a defined fault state as justified, and avoid claiming a communications CRC is a personnel-safety function. The independent Pilz/physical final elements remain required.

**D — A fault pin is not a physical valve-position sensor.** HHF can report without disabling a channel; OVT can automatically recover; OCP follows different restart logic. None proves a hydraulic on/off safety valve, gravity load restraint, pressure-zone isolation, or the actual Y1/Y2 safe state. Likewise a diagnostic pin masked or cleared by ENABLE cannot be the sole event-history witness.

**E — Driver enable and safety program reset are different transactions.** Even if the Rev 1 board implements the four-prerequisite gate correctly, its `HARDWARE_OUTPUT_ENABLE` remains ordinary-control hardware, not an independent safety controller. Wire 75 actual electrical polarity/conditioning, Pilz active program, 11K2, hydraulic final elements, guarding and deliberate new start are still unverified. Do not allow an HMI `clear fault` or driver re-enable to function as a machine safety reset.

## Minimum non-energized acceptance review — reuse existing intake, no new questionnaire

Under the existing [OPB-D04/D08 restricted card](../safety-course/4400_OPB_CUTOVER_02_RESTRICTED_HANDSHAKE_AND_POWER_DELTA_CARD_2026-10-27.md), qualified reviewers should request only revision-matched **existing** design/as-built evidence for:
1. Both MAX22216 ENABLE pin nets and local pull-downs; physical wire-75 conditioning; no host/SPI bypass; source-of-truth schema v3; no stale netlist renderer.
2. `CRC_EN` strapping and SPI 32-bit frame implementation, subsequent-transaction status/readback interpretation, command-acknowledgment/error handling, and explicit fresh-command policy. Confirm these are implemented, not just specified.
3. Fault-type table distinguishing OCP/OVT/HHF/UVM/COMER; `N_FAULT` pull-up, masking and validity; how event history survives an ENABLE-low cycle *outside the driver*, without delaying inhibit.
4. Separate qualified safety-program/final-element/physical STOP, HOLD, ENERGY, GUARD, REARM and occupancy witnesses. No assertion that a driver status or CRC equals physical safe state.

No energized fault injection, forcing outputs, bypassing safety hardware or operator-exposed tests follow from this review. Board-design implementation and any later bounded local-runner firmware tests belong to the separate OpenPressBrake board lane. A local test becomes justified only when a frozen implementation question exists; **zero** GitHub-hosted or local compute used here.

## Evidence ledger and release

- **DOC-CONFIRMED:** MAX22216 Rev. 2 pp. 11–14, 22, 43–47 exact behaviors above.
- **SOURCE-CONFIRMED:** OpenPressBrake published schema v3, manifest and status checklist at stated blobs.
- **INFERENCE:** conditional stale-command, erased-event and recovery failure paths; mitigation/diagnostic policy.
- **TEST-CONFIRMED:** none for this investigation. **COMMUNITY-REPORTED:** none relied upon.
- **UNKNOWN:** fabricated PCB, active firmware/CRC/readback, actual wire-75 level, Pilz/AKAS program, 11K2 field wiring, valve currents, hydraulic safe state, stopping/holding/pressure, PL/SIL, independent evaluator and physical validation.

**G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** No personnel-exposed hazardous operation. Any experimental operation must be separately authorized, isolated/remote with people outside the danger zone and residual risk stated explicitly.
