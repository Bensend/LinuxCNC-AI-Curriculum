# 4400-WJ-01 — Technician pressure, access and restart decision card
**2026-10-25 | PAPER ONLY / UNEXECUTED / UNSCORED | NOT A LIVE TEST PLAN**

For each case record: (a) hazardous energy and access zone, (b) what is known, (c) what is *not* proved, (d) correct hold/next documentary witness, (e) restart and medical implications. Do not attempt live faults, pressurized leak searches, or service operations from this card.

| # | Scenario / misleading premise | Expected reasoning target (not an evaluator answer key) |
|---|---|---|
| 01 | CNC feed hold is active and PUMP READY is false. | Separate gantry stop, jet suppression, stored pressure and guard release. |
| 02 | Pump display says bleed valve OPEN. | Distinguish commanded/presented state from actual UHP pressure discharge. |
| 03 | Both filter pressure gauges read zero. | Identify their low-pressure placement before inferring UHP line condition. |
| 04 | Operator selects pierce pressure from cut mode. | Separate pressure-mode transition from service-safe isolation. |
| 05 | 809790 bleed duration changed to shorten cycle. | Flag head-pressure mismatch risk and change control, no invented safe time. |
| 06 | Flow MotoJet claims 1-second bleed. | Reject transfer of marketing/model claim to a different pump or line. |
| 07 | A 810040 startup stage raises yellow warning but continues. | Do not assume warning always hard-inhibits energy generation. |
| 08 | PLC firmware reboot has restored defaults. | Require saved configuration identity and independent revalidation. |
| 09 | Remote CNC can request pump ON. | Separate local/remote process ownership from safety reset/start authority. |
| 10 | Guard is open but pump is in cooling mode. | Account for residual pressure and separate motion/energy paths. |
| 11 | Dump path is blocked; HMI still says safe. | Demand independent physical evidence, not software self-attestation. |
| 12 | Air pilot supply is absent. | Do not assume physical bleed without exact valve fail position and pressure witness. |
| 13 | A small puncture follows waterjet contact. | Recognize surgical emergency; immediate emergency medical treatment and medical card. |
| 14 | Service person wants to loosen a UHP fitting after E-stop. | Require qualified full energy isolation and point-of-work pressure proof. |
| 15 | CNC M66 waited for PUMP READY. | Explain normal program wait versus protective/safety authority. |
| 16 | Guard was temporarily removed for nozzle access. | Require guard restoration, usability redesign, independent rearm and proof. |

## Blank selected-machine evidence record — do not fabricate
| Field | Qualified entry | Status |
|---|---|---|
| Machine/pump model, serial class, firmware/config revision | ____ | UNKNOWN |
| Safety requirements/standards edition adopted | ____ | UNKNOWN |
| Hazard-zone map: pump, attenuator, UHP line, nozzle, gantry, jet catcher | ____ | UNKNOWN |
| Pressure-generation and isolation points per OEM/as-built | ____ | UNKNOWN |
| Independent guard/E-stop/final-element and reset path | ____ | UNKNOWN |
| Actual pressure-sensor/gauge location and calibration | ____ | UNKNOWN |
| Qualified isolated/remote test plan, witnesses and instruments | ____ | NOT RUN |
| Stop/bleed physical results and worst-case residuals | ____ | NOT RUN |
| Guard reinstatement and deliberate restart proof | ____ | NOT RUN |
| Independent reviewer, change hash, acceptance decision | ____ | HOLD |

**Decision:** without selected evidence, no physical acceptance and no personnel-exposed operation. A competent independent evaluator must issue a novel unseen transfer problem and score separately; this public card is practice only.
