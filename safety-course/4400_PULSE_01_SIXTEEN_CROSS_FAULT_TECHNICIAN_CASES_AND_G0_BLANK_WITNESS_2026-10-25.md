# 4400-PULSE-01 — Sixteen unscored wiring-fault technician cases and blank G0 witness
**2026-10-25. PAPER ONLY; no physical fault injection, no independent score.** Pair with [module](4400_PULSE_01_DUAL_CHANNEL_TEST_SOURCE_IDENTITY_AND_CROSS_FAULT_MODULE_2026-10-25.md) and [original OEM audit](../research/4400_ROCKWELL_PILZ_TEST_PULSE_SHARED_SOURCE_CROSS_SHORT_AND_SAFETY_INPUT_VARIANT_AUDIT_2026-10-25.md).

## Learner instructions
For **each** case state (a) exact evidence classification, (b) which fault can escape or be detected **only if the exact OEM says so**, (c) what is still unknown about physical machine safety, (d) safest practical no-energy next action, and (e) how to make correct repair simpler than bypass. **Do not assign a numerical PL, SIL, DC, pulse timing, pressure, stopping distance or load rating.** These cases are learner-readable practice, not sealed blind evaluator material.

| # | Scenario | Critical distinction to investigate |
|---|---|---|
| 1 | 5034-IB8S SI0 and SI1 both powered by TO0 in Safety Pulse Mode; cable crushed together | Exact same-TO cross-short detection exception |
| 2 | Same module, dual inputs use TO0 and TO1 but cable damage is suspected | OEM mode/diagnostic evidence still needed; no automatic whole-function release |
| 3 | Safety Pulse Mode disabled during replacement to suppress nuisance trips | Configuration change invalidates assumed diagnostic behavior |
| 4 | Two SI channels have identical green LEDs after a known field cable disturbance | LED state is not an independent cable fault proof |
| 5 | Technician connects a PNOZ m0p test output to a cabinet lamp | Exact OEM forbids driving loads from test output |
| 6 | Technician routes PNOZ m0p test pulse conductors with actuator wiring in unprotected multicore cable | OEM routing restriction and common-cause hazard |
| 7 | Safety-mat test pulse reused for a second protective input on PNOZ m0p | Exact OEM non-reuse rule for mat test pulses |
| 8 | Builder substitutes ordinary +24 V for a failed test-output terminal | Difference between input supply and configured fault testing |
| 9 | Guard switch replaced with active OSSD device, old dry-contact wiring retained | Sensor/receiver interface and pulse compatibility must be requalified |
| 10 | New safety controller accepts dual inputs but has no documented test-source mapping | Unknown diagnostic coverage, not a claimed PASS |
| 11 | A contactor mirror contact reads closed after reset | EDM electrical witness does not establish hydraulic Y1/Y2 hold |
| 12 | LinuxCNC UI shows E-stop asserted, but independent safety relay status is missing | Ordinary status cannot authorize exposure |
| 13 | Operator asks to suppress test-pulse fault during setup to avoid downtime | Remove bypass incentive by fixing routing, configuration and service access |
| 14 | New guard harness has an undocumented splice joining two signal conductors | Common-cause bridge and configuration traceability |
| 15 | Safety receiver swapped for similar catalog suffix with different terminals | Exact part, mode and qualified application examples required |
| 16 | Safety circuit tests fine on paper; press-brake Y2 drifts under gravity | Electrical input integrity is separate from physical ram restraint |

## G0 restricted as-built evidence worksheet — NOT RUN
| Evidence ID | Requested qualified witness | Status now | Owner / restricted reference |
|---|---|---|---|
| PULSE-IN-01 | Selected machine identity, revision, protective functions, exposure modes | UNKNOWN | — |
| PULSE-IN-02 | Exact sensor contact/OSSD parts and safety SI/TO module/firmware | UNKNOWN | — |
| PULSE-IN-03 | Complete as-built channel-to-test-output terminal assignment | UNKNOWN | — |
| PULSE-IN-04 | Saved receiver mode/config checksum and exact OEM application pages | UNKNOWN | — |
| PULSE-IN-05 | Field-cable routing, splices, common supply and short/open fault exclusions | UNKNOWN | — |
| PULSE-IN-06 | Independent safety outputs, EDM, final elements and feedback witnesses | UNKNOWN | — |
| PULSE-IN-07 | Independent Y1/Y2 stop, gravity hold, pressure zones and energy isolation | UNKNOWN | — |
| PULSE-IN-08 | Reset/rearm, fresh motion request, guard restoration and bypass inventory | UNKNOWN | — |
| PULSE-IN-09 | Qualified documentary review, later separately authorized physical plan | NOT RUN | — |

**Acceptance:** a drawing without exact TO/SI identity does not prove cross-short coverage; a correct TO/SI identity does not prove final-element or hydraulic safety. G0/G1 remain HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED. No personnel-exposed operation. Public repo stores only status and anonymized evidence IDs, not proprietary machine drawings.

## Independent evaluation protocol
A separate evaluator must privately precommit a **novel** manufacturer/version/wiring problem and reference result before learner exposure; then collect learner answer, score externally, classify errors, require new transfer and delayed retention. Do not self-score these 16 public practice cases. Current evaluator **NOT RUN**.
