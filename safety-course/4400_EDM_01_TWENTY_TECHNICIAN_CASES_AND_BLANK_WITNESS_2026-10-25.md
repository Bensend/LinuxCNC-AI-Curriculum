# 4400-EDM-01 — 20 technician decision cases and blank evidence witness
**2026-10-25 | PAPER ONLY / UNSCORED / NOT A MACHINE TEST**

For each case, learner records (1) the **first dangerous inference**, (2) correct narrow source proposition, (3) affected safety function/physical energy path, (4) required evidence, (5) HOLD or paper-ready disposition. Do not fill the witness as if a test was performed.

| Case | Situation requiring a decision |
|---|---|
| 01 | PNOZ s4 manual start circuit has a permanently bridged S34 path; E-stop is released. |
| 02 | PNOZ s4 configured for monitored rising edge; operator holds reset before guard closes. |
| 03 | PNOZ s4 configured for monitored falling edge; reset button opens while guard becomes clear. |
| 04 | A relay's green POWER LED is on, but no safety output state was measured. |
| 05 | Auxiliary 41–42 is routed to a “safe” LED; main safety contact wiring is unknown. |
| 06 | Two motor contactors are wired but their NC feedback is omitted from EDM. |
| 07 | One power pole welds and a mechanically linked NC feedback contact stays open. |
| 08 | Feedback loop is bridged after a nuisance trip and the machine resumes production. |
| 09 | OMRON G9SE manual reset input never performs the documented OFF→ON→OFF sequence. |
| 10 | OMRON G9SE-221-T automatic mode input returns during off-delay. |
| 11 | OMRON manual-reset configuration is replaced by auto-reset without SRS review. |
| 12 | A vendor PL e statement is used to declare the whole press brake PL e. |
| 13 | SICK C4000 internal reset turns OSSDs green while external machine interlock is unknown. |
| 14 | SICK C4000 receiver is replaced with matching plug; EDM factory setting not read back. |
| 15 | SICK C4000 EDM alarm follows a protective-field interruption; operator repeatedly resets. |
| 16 | Reset button is behind the machine where the front die zone cannot be seen. |
| 17 | Foot pedal remains held through E-stop release and safety rearm. |
| 18 | A pump motor contactor drops out, but a pressurized accumulator and gravity load remain. |
| 19 | A contactor's NC auxiliary indicates de-energized while a hydraulic valve is stuck open. |
| 20 | A maintenance worker sees READY after an isolator is switched off but cylinder pressure is not verified. |

## Blank witness — repeat for every case
| Field | Learner / evaluator entry |
|---|---|
| Case number / time / source edition | __________________ |
| Source claim and page / DOC vs INFERENCE vs UNKNOWN | __________________ |
| Expected electrical/safety-controller behavior | __________________ |
| Actual physical stop/hold/energy path known? | __________________ |
| Reset vs fresh ordinary start distinguished? | __________________ |
| Shared-fault / bypass / power-return consequence | __________________ |
| Evidence missing and exact qualified owner | __________________ |
| Disposition (HOLD / document-only) | __________________ |
| External evaluator identity, independent reference and score | **NOT RUN** |

**Pass criteria (not yet evaluated):** do not grant personnel-exposed release from EDM, green HMI, a single relay, a component PL rating or a simulated software state. Require exact selected part/config, independently traced final elements, guarded hazard map, independent physical witness, deliberate fresh start and maintenance isolation. A wrong claim that ordinary LinuxCNC or the FPGA performs the personnel-safety function is a critical miss.

**Status:** 20 unscored PAPER scenarios; zero TEST-CONFIRMED observations; no physical machine tests, no hosted/local compute and no evaluator score.
