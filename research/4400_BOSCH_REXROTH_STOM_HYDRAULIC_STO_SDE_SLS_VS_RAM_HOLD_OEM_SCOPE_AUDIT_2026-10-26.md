# 4400-HYD-STOM-01 — Hydraulic STO manifold is not automatically a gravity-load holding device
**Original OEM source and architectural scope audit | 2026-10-26 | NON-GRADUATED / PAPER ONLY.**

## Source
Bosch Rexroth, **22 October 2024**, press release PI 034/24, *Functional safety out of the box — STO manifolds STOM*, https://www.boschrexroth.com/en/de/company/press/sto-manifolds-27520.html (direct manufacturer page inspected 2026-10-26). Distinguish this 2024 STOM family from the separately marketed IH04 press manifold and from Parker HAS hydraulic load-control products. A manufacturer press release is evidence of the described portfolio and stated capability, **not** the actual certificate, application validation, installed machine, or safety calculation.

## DOC-CONFIRMED exact manufacturer statements
- STOM is an **area hydraulic supply shut-off** manifold for presses, test benches and other systems, not a description of OpenPressBrake hardware.
- Manufacturer describes hydraulic partial safety functions **STO (supply shut-off), SDE (safe de-energizing/depressurization) and SLS (safe limited speed/flow)** as distinct functions; exact combination depends on variant.
- The press release describes **three variants**: a double position-monitored series shut-off claimed Cat 4 PL e, with bypass functions for SDE/SLS; a Cat 3 PL d variant whose bypass is validated using an integrated pressure sensor; and a no-bypass redundant shut-off variant claimed Cat 4 PL e. These are **manufacturer-stated partial-function capabilities** only, not an assembled-machine PL.
- Manufacturer's **under 300 ms** closing-time statement is conditional on pressure, oil viscosity and configuration. It is **not** a press-brake stopping-distance, Y1/Y2 synchronization or gravity-holding measurement.
- Main P1-to-P2 shut-off is described as leakage-free in the press release. That statement does not establish downstream actuator-side retained pressure, physical holding, no crossfeed, rescue release or personnel access.

## Distinct safety propositions (INFERENCE from source architecture)
1. **Stop generating motion energy:** supply interruption can prevent further commanded hydraulic drive energy, but a gravity-loaded ram may still move if an actuator chamber can exhaust or leak.
2. **Retain a suspended load:** requires a verified load path/valve/mechanical support under foreseeable faults, independent of an upstream supply shut-off.
3. **Remove hazardous stored energy for maintenance:** SDE/depressurization must be mapped by pressure zone; indiscriminate venting of the load-bearing chamber may cause descent unless independent support exists.
4. **Monitor the safety final elements:** valve position or pressure monitoring can diagnose particular faults; it is not a direct proof of ram position, load restraint or complete pressure isolation.
5. **Restart safely:** reset of a safety controller/manifold cannot itself authorize renewed ram motion. Require deliberate local start after hazard-zone clear and qualified verification.

## Adversarial failure paths
| Condition | Why a supply shut-off alone is insufficient | Required qualified evidence |
|---|---|---|
| Hose failure between holding valve and cylinder | Supply can be isolated while load chamber drains | Actual line/valve placement and independent retention |
| Single stuck-open isolation valve | Partial-function architecture must detect/mitigate | Exact redundant valve and monitoring proof, not logo or rating |
| Trapped pilot or accumulator pressure | Unexpected holding-valve release can remain possible | Actual hydraulic pressure-zone map |
| Depressurize the load chamber | Gravity can move the ram without commanded supply | Positive mechanical support and validated sequence |
| Two cylinders descend unequally | Common supply shut-off does not establish independent Y1/Y2 balance | Each-axis hold, mechanical/structural path and measured evidence |
| Reset restores power | Safety reset ≠ operator start | Independent reset/restart state machine |
| Model variant swapped | Bypass, diagnostic, claimed PL can differ | Exact part/revision/certificate, MOC review |

## Cross-reference and limits
Read [Parker HAS valve-option/retained-pressure audit](4400_PARKER_HAS_LOAD_HOLD_CODE_N_MANUAL_RELEASE_PO_CHECK_AND_TRAPPED_PRESSURE_OEM_AUDIT_2026-10-26.md). **DOC-CONFIRMED** Bosch STOM published claims; **INFERENCE** system-level hazards; **SOURCE-CONFIRMED new LinuxCNC none; TEST-CONFIRMED none; COMMUNITY-REPORTED none; UNKNOWN** selected OpenPressBrake manifold, cylinder, pressure and safety performance. No fabricated hydraulic truth table, safety rating, response time, or release approval.

**Safety boundary:** LinuxCNC/FPGA may request motion or report diagnostics, but independent safety-related logic and physical hydraulic/mechanical final elements must own personnel-safety functions. G0/G1 HOLD; no people-exposed hazardous operation or live test authorized.