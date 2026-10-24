# 4400 — Pilz PNOZ m B0: safe output versus auxiliary/test-pulse substitution during retrofit

**Original OEM source inspected:** Pilz **PNOZ m B0 Operating Manual 1002660-EN-13**, 55 pages, valid for **product version 3.3 onward** (§1.1 p.6). Official manufacturer PDF: https://www.pilz.com/download/open/PNOZ_m_B0_Operating_Manual_1002660-EN-13.pdf . Examined text and wiring diagram on printed pp. 8–13, 19–20, 26–31, 45 and 49–50; original p.29 diagram visually checked. **Status:** DOC-CONFIRMED for **this exact product/edition only**; no selected machine installation is asserted. No live lab, no safety certification of an assembly.

## Why this source matters after a CNC replacement

A terminal carrying 24 V or a PLC variable named `safety` does not establish that it is a safety-related output. The manufacturer distinguishes **safe semiconductor outputs**, **standard auxiliary outputs**, and **input diagnostic test-pulse outputs** within the same base unit. Reusing an existing terminal name or simply routing a high signal into the new FPGA can silently change the safety authority boundary.

## Manufacturer-specific distinctions

| Interface | Exact manufacturer source | DOC-CONFIRMED meaning | Incorrect inference to reject |
|---|---|---|---|
| `O0..O3` | §2.2 pp.8–9; §7.1 p.26; §11 p.45 | Four safety-related semiconductor outputs, subject to product/application requirements. | Any 24 V output can substitute for one of these. |
| `IM*` configurable I/O | §2.2 p.8; §3.1 p.11 | Can be safe inputs or **auxiliary** outputs by configuration. Manufacturer warns that standard I/O must not be used for safety-related applications. | A programmable standard status output is a qualified safety cut-off. |
| `T0M20..T3M23` | §2.2 pp.8–10; §5.6 p.20; §7.2 pp.28–29 | Configurable as auxiliary or diagnostic **test-pulse** outputs; pulses are used for input cross-short detection. | Test pulse source equals safety output or ordinary constant 24 V. |
| `A1/A2` versus `24V/0V` | §7.2 pp.26–27 | Separate controller and semiconductor-output supply terminals; output supply must be present even if SC outputs are unused; separate supply option described. | A green PLC RUN LED establishes final-element power/withdrawal. |
| `K1/K2` external feedback | §7.2 printed pp.28–29 | OEM example shows monitored external contactor feedback and a special single-output advanced-fault-detection case with **specific prerequisites**. | Any two connected coils or a closed feedback contact prove independent physical stopping. |

**Do not reproduce the manufacturer's diagram as a generic press-brake wiring recipe.** The printed p.29 single-output/two-load advanced fault-detection example requires a feedback loop and exclusion of external power sources/shorts across contacts, including a wiring segregation example. This is a conditional OEM application, not a universal way to achieve a machine-level integrity target.

## A numerical trap: similar outputs have different pulses and leakage

The original **printed p.45** technical table gives the following **product-specific** figures:

- Safe semiconductor outputs: maximum self-test OFF duration **330 µs**, OFF residual current **0.05 mA**, maximum capacitive load **1 µF**.
- Test-pulse outputs: maximum self-test OFF duration **5 ms**, output current **0.1 A**.
- Configurable auxiliary outputs: OFF residual current **0.5 mA** and a separate current specification.

These are different signal **roles** and specifications. **INFERENCE:** copying a generic pulse filter or receiver threshold between them can mask a diagnostic pulse or create an unexpected actuator response. Actual receiver thresholds, loads, wiring, current, test configuration, pulse timing and safety reaction must be established from both product ends. The listed values are **not** stop time, response time, allowed bypass duration or OpenPressBrake acceptance criteria. Residual current is not proof of a de-energized coil, safe pressure or a physically open final element.

## OEM wiring and commissioning constraints that change the cutover review

- **DOC-CONFIRMED §7.1 p.26:** the safety system and input circuits must be supplied from a single supply as specified by this OEM; separate controller and semiconductor-output supply arrangements are described in §7.2. Preserve the manufacturer's actual power architecture rather than inventing a generic isolation rule.
- **DOC-CONFIRMED §7.1 p.26:** do not route diagnostic test-pulse cables with actuator cables in an unprotected sheathed cable. An apparently harmless cable consolidation during retrofit can change diagnostic coverage.
- **DOC-CONFIRMED §3.1 p.11:** standard inputs/outputs are not for safety-related applications.
- **DOC-CONFIRMED §7.5 p.30:** the manufacturer calls for checking safety devices after chip-card exchange, project download or project deletion. The displayed project name, date and CRC (§7.3 p.29) are configuration-identification aids, **not** machine physical validation.
- **DOC-CONFIRMED §3.4.1 p.13:** component functional-safety capability does not establish functional safety of the whole machine; each required safety function must be evaluated.
- **DOC-CONFIRMED §4.2 p.18:** the manufacturer notes Modbus/TCP lacks security mechanisms and prescribes network protections; a read-only ordinary HMI is not a substitute for protected safety-controller configuration.

## Failure-path table — hypotheses, not observed faults

| Hypothesis | Plausible failure if ignored | Minimum review evidence |
|---|---|---|
| Standard `IM` auxiliary output mistaken for `O0` safety output | FPGA sees green status while no qualified independent final-element withdrawal exists | Actual terminal label, configured function, safety logic and downstream final-element path |
| Test pulse `T0` treated as steady 24 V | Cross-short diagnostic assumptions fail; receiver may interpret pulse differently | Pulse source, sensor/receiver pair, wiring segregation, OEM test configuration |
| Safe output drives inductive coil with new suppressor | Release time may change, altering stop reaction | Exact suppressor, coil, manufacturer data, machine-level physical stopping witness |
| Controller RUN while SC-output supply/wiring changed | Apparent controller health but final-element state unknown | Both supply rails, output load path, feedback target and independent physical witness |
| New project downloaded with same visible name | Changed output mapping, reset or fault response unnoticed | Exact project identity/checksum, terminal map, affected `CHG/VAL/PT`, qualified functional check |
| EDM/contact feedback is healthy while physical motion continues | Feedback target narrower than claimed physical stop/hold | Independent physical motion/load/energy witness and machine fault analysis |

For inductive-load suppression, original [Rockwell Safebook](https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/safebk-rm002_-en-p.pdf) notes DC coil suppression can increase contactor dropout time; **the Rockwell original PDF was not independently page-inspected in this session**, so this item remains a secondary documentary lead rather than a cross-product numeric claim. The Pilz manual itself requires adequate inductive-load protection (§3.4.5 and §7.1).

## Low-friction retrofit design rule

Provide a **terminal-role inventory** with three explicit labels: `SAFETY-OUTPUT`, `STANDARD-STATUS`, and `TEST-PULSE`. Put physical connector/terminal identity, safety PLC configuration identity, producer and receiver, expected pulse/off behavior, supply and final-element target in the change-control worksheet. Color/key and separate wiring to make the correct connection easiest. Reject a substitution where a safety output becomes a standard status output or where an unverified diagnostic pulse is treated as steady 24 V. Retain independent safety final-element authority; use ordinary FPGA only for coordination/diagnostics.

## Provenance and open gates

- **DOC-CONFIRMED:** original Pilz 1002660-EN-13 exact edition and printed pages listed above.
- **INFERENCE:** particular retrofit substitution/coil/supply failure paths and proposed label/control scheme.
- **UNKNOWN:** whether any PNOZ m B0 exists on selected machine; actual safety PLC family/version, configuration, final elements, receiver electrical compatibility, stopping/holding, diagnostic coverage, power-up and reset behavior.
- **SOURCE-CONFIRMED:** no new LinuxCNC source claim in this document; prior pinned `estop_latch` source remains a separate ordinary-control trace.
- **TEST-CONFIRMED:** none. No simulation or lab justified without a selected unresolved interface question.
- **Release:** `VAL/PT NOT RUN`, `G0/G1 HOLD`, `G3/G4 NOT AUTHORIZED`. A real machine must not operate with people exposed unless its minimum independent safety function is established. No personnel-exposed test or bypass is authorized.

**Freeze:** `24V STATUS OUTPUT != SAFE SEMICONDUCTOR OUTPUT`; `TEST PULSE OUTPUT != STEADY ENABLE`; `CONFIGURATION CRC != PHYSICAL SAFETY VALIDATION`; `COIL SUPPRESSION CHANGE != STOPPING PERFORMANCE UNCHANGED`.
