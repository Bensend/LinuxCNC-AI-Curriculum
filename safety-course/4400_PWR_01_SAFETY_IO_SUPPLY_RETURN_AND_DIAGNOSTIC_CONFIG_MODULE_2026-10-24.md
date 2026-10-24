# 4400-PWR-01 — Safety I/O power, 0 V return and diagnostic configuration

**Level:** 4000 safety implementation, source-reading module. **Status: NOT GRADUATED; no external competency test, selected machine, simulation or physical test.** Prerequisites: 2520 hazard/SRS, 2540 safety final elements, 25A0 programmable safety, 25B0 common-cause faults, 4400-RET-01 brownfield safety cutover.

## Learning outcome

A fresh AI engineer should recognize that a safety controller's **logic** and its **wiring, returns, output loads and diagnostics** form one safety-related system. It should detect when a seemingly harmless power-supply, ground-jumper, output-test or capacitor change invalidates another safety function; identify the missing source/version evidence; and design a low-friction, separately authorized validation route without placing personnel-safety authority in LinuxCNC or the ordinary FPGA.

## Primary original-source route

1. [SICK Flexi Soft common 0 V and reverse-current source audit](../research/4400_SICK_FLEXISOFT_LOST_0V_REVERSE_CURRENT_COMMON_CAUSE_SOURCE_AUDIT_2026-10-24.md): original OEM 8012478 hardware instructions §§6.1, 6.2, 11.3–11.5; Safe Linear Positioning 8020941 §13.2.
2. [SICK FX3-XTIO pulse-disable/all-output-degradation source audit](../research/4400_SICK_XTIO_DISABLED_TEST_PULSE_ALL_OUTPUTS_DEGRADE_AND_TRANSIENT_HIGH_AUDIT_2026-10-24.md): OEM §§4.4.6.2–4.4.6.4 and output technical table.
3. [Pilz PNOZ m B0 safe/aux/test-pulse source audit](../research/4400_PILZ_PNOZ_MB0_SAFE_VS_AUX_OUTPUT_TEST_PULSE_CUTOVER_SOURCE_AUDIT_2026-10-24.md): compare *terminal role* to SICK's *output diagnostic configuration*.
4. [Rockwell coil suppression/long AC cable source audit](../research/4400_ROCKWELL_COIL_SUPPRESSION_LONG_CABLE_FALSE_HOLD_RETROFIT_AUDIT_2026-10-24.md): compare *coil physical release* to SICK's *output level/fault response*.
5. [Selected-machine physical evidence intake](4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md): `IN-03/IN-04/IN-04k/l`, `PHY`, `VAL/PT` and G0–G5.

The original SICK PDF URL is mutable; parsed source and some web page renders exposed different edition footers. A qualified machine-specific study must save and identify the **actual PDF bytes and exact module/hardware/firmware** before using any numerical or wiring condition.

## Causal model — four separate authorities

| Layer | Legitimate job | Invalid substitution |
|---|---|---|
| Ordinary LinuxCNC/FPGA | Motion requests, operator workflow, telemetry and ordinary inhibits | `SAFETY_OK` bit or software E-stop as sole personnel-safety cut-off |
| Safety-related control | Qualified safety input/output channels, diagnostic coverage, discrepancy and reset logic | Green CPU LED or unqualified status output as evidence that a final element has switched |
| Physical final element and load | Actual contactor, drive/STO, hydraulic valve, mechanical restraint; independently witnessed stop/hold | Q=LOW or EDM auxiliary contact as proof the ram cannot fall |
| Maintenance isolation | Lockable electrical/hydraulic isolators, trapped-energy management, mechanical blocking and qualified verification | A safety relay/PLC output or emergency-stop pushbutton as LOTO |

## Five mechanism propositions

**P1 — Common return is a common-cause failure:** In specified SICK wiring, losing a shared actuator 0 V with mixed high/low Q outputs can switch a relay unintentionally. A different parallel-input topology can produce a false-high through reverse current. *DOC-CONFIRMED possibility*, **not** selected fault reproduction.

**P2 — Input and output hardware revisions matter:** The OEM XTIO reverse-input-current maximum differs between hardware <V1.10 and ≥V1.10. This does not establish actual receiver voltage, current or safe state. Do not copy these product numbers into another machine.

**P3 — Diagnostic choices couple channels:** Disabling output test pulses on one SICK FX3-XTIO Q can degrade **all Q channels on that module**. Output capacitance, wiring and receiver compatibility must be checked as a coupled safety function.

**P4 — A diagnostic response number is not stopping distance:** The OEM's 3/43 ms output-LOW fault-detection allowance and 10/50 ms internal fault detection/reaction values are configuration-specific electrical timing, **not** a press-brake ram stop-time measurement. A physical machine validation must separately account for sensor, safety logic, output, actuator, hydraulics, mechanics and load.

**P5 — Recovery must be deliberate:** Power dips, module restarts, lost 0 V, diagnostic reconfiguration and ordinary queued LinuxCNC commands are distinct events. Safety reset must not itself start hazardous motion; ordinary restart requires a fresh intentional start with the independent safety chain healthy and the physical hazard controlled.

## Paper architecture task (not executable)

Hypothetical retrofit: an old safety PLC stays in place while LinuxCNC and a new FPGA take over ordinary motion. A shared 24 V supply powers safety CPU and a relay bank; two guard inputs share a return; the installer replaces an output card with a capacitive receiver and disables one SICK XTIO output test pulse to prevent nuisance trips. A power dip occurs during a pump start, the safety controller later reports RUN, and the LinuxCNC HMI shows a retained AUTO request.

The learner must produce:

1. A supply/return and final-element map showing every shared 0 V, A1/A2, protective earth, functional earth, shield, sensor and actuator connection **without inventing a machine drawing**.
2. A failure-path table for shared-return open, reverse-current false-high, pulse-disabled cross-circuit, capacitor hold-up, supply dip and stale AUTO request.
3. A configuration/version inventory for the exact module, hardware Step, firmware, pulse settings, input/output receiver and suppressor.
4. A safe change-control plan with separate physical stop/hold/occupancy/restart and maintenance-energy witnesses.
5. An ergonomic proposal making correct guard operation, cable repair and maintenance inspection easier than bypass.
6. A defensible HOLD decision while actual Y1/Y2, guard, safety wiring and physical proof remain UNKNOWN.

## Adversarial practice

Work [12-case lost-ground/power-dip card](4400_LOST_GROUND_FALSE_HIGH_AND_POWER_DIP_TECHNICIAN_CARD_2026-10-24.md) and the eight TP cases in the pulse-disable audit. **Do not** count these as a blind external evaluation; their key discriminators are learner-visible.

An independent fresh evaluator should present a **different** controller and receiver combination with a withheld original-source solution, require a precommitted mechanism/falsifier/confidence response, then score only after independent source verification. No evaluator run or score is claimed.

## Engineering sufficiency and blockers

| Gate | Status |
|---|---|
| Exact OEM statements traced | **DOC-CONFIRMED** (see source audits; mutable PDF edition warning) |
| Ordinary LinuxCNC versus independent safety boundary | **SOURCE-CONFIRMED in earlier pinned LinuxCNC traces only**, not newly executed |
| Novel independent fresh-AI transfer | **NOT RUN** |
| Selected safety-controller/supply/return schematic | **UNKNOWN** |
| Selected physical stop/hold/occupancy/restart | **NOT RUN / UNKNOWN** |
| Lab simulation justified? | **NO** — OEM source resolves the present question; no unresolved source behavior requiring compute |
| Personnel-exposed operation / maintenance entry | **NOT AUTHORIZED** |

**Next evidence:** selected as-built safety supply/0 V/FE/PE, exact safety output and diagnostic configuration, physical Y1/Y2/guard/final-element evidence, independent fresh-AI transfer. Do not perform energized wire-disconnect fault injection. If selected evidence is unavailable, rotate to another open 4400 safety source gap without reopening graduated 3000 tracks.
