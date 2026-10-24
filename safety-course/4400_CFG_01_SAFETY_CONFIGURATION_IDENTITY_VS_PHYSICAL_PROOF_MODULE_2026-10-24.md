# 4400-CFG-01 — Configuration verified does not mean machine verified
**Level:** 4000 independent safety architecture | **Status:** SOURCE-READING / NOT GRADUATED | **2026-10-24**

## Objective and prerequisites
Build on 2520 hazard/SRS, 2540 final elements, 2570/2580 maintenance/change control, 2590 ESPE and 4400-RET-01 retained-safety-PLC retrofit. A fresh AI engineer must explain the **four independent evidence layers**: (A) approved safety design, (B) controller program/device configuration identity, (C) actual wired final-element authority, and (D) physically validated safe state. A PASS at one layer cannot silently stand in for the next.

Read the [original SICK/Rockwell source investigation](../research/4400_SAFETY_CONFIGURATION_SIGNATURE_SCOPE_AND_PHYSICAL_OUTPUT_TRUTH_AUDIT_2026-10-24.md), then this module and the [technician card](4400_SAFETY_CONFIGURATION_CHECKSUM_PHYSICAL_OUTPUT_TECHNICIAN_CARD_2026-10-24.md).

## Four-layer evidence contract
| Layer | Evidence needed | Examples of misleading substitutes | Owner / status |
|---|---|---|---|
| A — Intended safety requirements | Current hazard map, SRS, modes, required safe state, change history | Old drawing without change review | Qualified designer / selected machine UNKNOWN |
| B — Controller configuration identity | Exact device and firmware, safety logic/configuration, checksum/signature **scope**, readback, verified revision | Yellow CV LED alone; checksum without connected EFI/ACR scope; safety signature without standard-interface review | Qualified controls engineer / UNKNOWN |
| C — Physical authority and diagnostic chain | As-built wiring, input devices, independent safety controller, output terminal, monitored final elements, gravity holding, fault response | Standard network output bit, HAL pin, HMI green indicator, controller internal output image | Qualified electrical/hydraulic engineer / UNKNOWN |
| D — Actual safe-state performance | Controlled qualified physical stop/hold/isolation/guard coverage/reset/restart evidence, measured limits where required | Paper case, checksum, SIL/PL label, source audit | Independent qualified witness / NOT RUN |

**Non-negotiable:** physical energy-removal or load-retention mechanisms must not depend solely on ordinary LinuxCNC/HAL/FPGA decisions. Safety status may be mirrored to LinuxCNC for operator clarity but must not be promoted to authority.

## Two concrete manufacturer traps
1. **SICK 2023 gateway p.112**: network output value represents a *logic result*, not guaranteed terminal voltage. An overload/cross-circuit can inhibit the physical terminal. Read the module diagnostics and prove the final element independently.
2. **SICK 2023 gateway p.113**: a four-byte verified checksum checks a particular configuration scope. A separate older Flexi Soft Designer manufacturer-indexed section 16.5 says firmware/hardware version and connected EFI-device configuration can be outside its Flexi Soft checksum. **Never generalize across versions**. Capture the product/manual/revision and compare the relevant configuration domains.
3. **Rockwell GuardLogix 5580 official safety-signature guidance**: record signature and compare after every download; deleting it triggers revalidation. A signature is not proof of physical safety; even a standard-only change can alter handshakes requiring review.

## Worked fault chain: “Green software, hazardous physical machine”
A retrofit replaces the normal motion controller. The existing safety controller still has its validated program and reports a good signature. The new FPGA is mistakenly allowed to maintain an actuator enable through an unreviewed interposing relay, while a safety-controller output is no longer in series with the real energy-removal element. The safety signature is still correct; the **physical safety function has been bypassed**. This is a *hypothetical INFERENCE*, not a known OpenPressBrake wiring defect.

Trace: hazard HAZ-ram-motion -> SF-independent stop/hold -> safety input -> safety logic -> actual output terminal -> final contactor/valve/holding element -> independent feedback -> qualified physical stop and deliberate rearm. Any missing link is UNKNOWN/HOLD.

## Technician decision exercise
For each of the [18 scenarios](4400_SAFETY_CONFIGURATION_CHECKSUM_PHYSICAL_OUTPUT_TECHNICIAN_CARD_2026-10-24.md), state:
- what the displayed status actually measures and what it does **not** measure;
- whether there is an as-built configuration, output, final-element or physical-evidence gap;
- whether maintenance/revalidation is required;
- how to keep people out of the hazard while the gap remains;
- what would falsify the current diagnosis.

Do not test with a person under a press-brake ram or inside a robot cell. A blank witness is not permission to energize. No machine-specific values or PL/SIL claims are supplied.

## Practical low-friction release gate
Use a single service packet: laminated approved-revision card + secure project backup + controller readback report + diagram with highlighted physical safety chain + independent final-element feedback checklist + reset/restart witness. Make it easy to retrieve and compare; make any mismatch conspicuous and inhibit exposed operation. Guard panels should have captive fasteners and obvious correct reinstallation, not tedious temporary jumpers.

**Stop condition:** if physical stop/hold/guard/reset evidence is missing, mark selected-machine **G0/G1 HOLD; G3/G4 NOT AUTHORIZED**. Experimental motion only in a qualified isolated/remote setup, people outside the danger zone, residual risks stated.

## Claim/competency status
SICK 2023 gateway and Rockwell current documentation **DOC-CONFIRMED**; SICK older checksum scope **manufacturer-indexed only**; source-level LinuxCNC and selected-machine physical behavior **UNKNOWN/NOT RUN**. Paper cases are teaching only, not a blind score or proof of mastery. External information-separated evaluator and qualified physical validation remain OPEN. No GitHub-hosted or local compute required.

## Promotion / unresolved
- Exact controller model/firmware, safety-program image and sensor configuration: **CRITICAL for selected machine**, cannot promote into a safe-to-operate claim.
- Full original SICK Designer manual for exact older checksum/ACR scope: **MEDIUM**; version-specific OEM inspection when needed.
- Physical output/final-element feedback, Y1/Y2 stop/hold and rearm: **CRITICAL**; independent qualified physical proof required.
- Independent fresh-AI transfer and delayed retention: **HIGH**, evaluation OPEN; do not self-grade.
