# 4400-PULSE-01 — Two different safety test-pulse paths are not interchangeable
**2026-10-26 | original manufacturer source | DOC-CONFIRMED product-specific | NON-GRADUATED**

## Question
Can a generic digital input or arbitrary software debounce be used to receive a safety light curtain's short OSSD diagnostic pulses? Does a safety controller's test-pulse output mean the same thing as the OSSD's output test? **No universal answer.** The manufacturer documents different purposes, electrical directions, time limits and evaluation requirements.

## Directly inspected original manufacturer documentation
1. **Pilz PSEN opII4H Series**, *Operating Manual 1003501-EN-12*, https://www.pilz.com/download/open/PSEN_opII4H_Operat_Man_1003501-EN-12.pdf , PDF p.40 §8.1 and technical-data pp.54–64. Exact product/order-code scope, not all OSSDs.
2. **Pilz PNOZ m0p (ETH)**, *Operating Manual 1002053-EN-08*, https://www.pilz.com/download/open/PNOZ_m0p_Operating_Manual_1002053-EN-08.pdf , PDF p.17 §6.1 and p.30 technical data. Exact 773110/773113 variant context.
3. **Pilz manufacturer's test-pulse lexicon**, https://www.pilz.com/en-US/support/lexicon/articles/072903 , conceptual description of short-detection via pulsed test outputs. Product manual remains authoritative for wiring.

## Evidence ledger
| ID | Classification | Direct manufacturer fact | Boundary |
|---|---|---|---|
| P01 | DOC-CONFIRMED | PSEN opII4H p.40 requires the selected evaluation device to evaluate both OSSD channels and **bridge diagnostic pulses up to 300 µs**. | That requirement is for this exact light-curtain family, not an arbitrary input filter setting or proof of machine PL/SIL. |
| P02 | DOC-CONFIRMED | PSEN opII4H technical data lists **300 µs maximum safety-output test pulse duration** for examined variants. | The pulse is a diagnostic interruption of a safety output; it is not a real protective-field interruption or a machine stop-distance value. |
| P03 | DOC-CONFIRMED | PSEN opII4H p.40 specifies qualified example evaluation devices and a PNOZmulti light-curtain switch-type configuration. | Simply wiring an OSSD to a LinuxCNC digital input does not implement the required independent safety evaluation. |
| P04 | DOC-CONFIRMED | PNOZ m0p p.17 says **test pulse outputs are only for input testing, not load driving** and must not share unprotected multicore routing with actuator cables. | These test **source** outputs are not interchangeable with an ESPE's two OSSD safety **outputs**. |
| P05 | DOC-CONFIRMED | PNOZ m0p p.17 restricts reuse of test pulses supplying short-circuit-acting safety mats. | Sharing a diagnostic source with unrelated loads/inputs can invalidate intended fault detection. Exact circuit review required. |
| P06 | DOC-CONFIRMED | PNOZ m0p p.30 gives **5 ms maximum OFF time during self-test** for its test-pulse outputs. | Do **not** substitute this 5 ms number for the PSEN opII4H OSSD's 300 µs; different product, port direction and purpose. |
| P07 | DOC-CONFIRMED | PSEN opII4H p.41 warns beam coding changes response time and requires renewed risk assessment/hazard analysis. | Input-pulse compatibility is only one part of total protective response/geometry. |

## Two causal paths
**Path A — light curtain OSSD output self-test:** the sensor briefly pulses an output OFF for internal checking. Its qualified receiving safety input must tolerate the specified pulse without treating it as a protective trip, while still responding correctly to genuine protective demands and detecting required faults. **INFERENCE:** arbitrary long filtering may hide real hazards; a normal PLC or LinuxCNC digital input is not personnel-safety authority.

**Path B — controller test-source output:** the safety controller intentionally pulses a *source* wired to selected inputs to detect cross-shorts or related wiring faults. Manufacturer forbids using that source as a load driver and restricts cable routing/reuse. **INFERENCE:** confusing it with OSSD output or feeding actuators from it undermines the assumed safety architecture.

## Scope limits and open questions
- **DOC-CONFIRMED** P01–P07 for original OEM editions only.
- **INFERENCE** mismatched pulse handling may cause nuisance trips or invalid fault coverage; no specific selected-machine outcome is established.
- **UNKNOWN** OpenPressBrake actual sensor, controller, wiring, filter/response-time configuration, selected machine PL/SIL, stop distance, Y1/Y2 physical stop/hold and personnel protection.
- **SOURCE-CONFIRMED new LinuxCNC:** none; **TEST-CONFIRMED:** none; **COMMUNITY-REPORTED:** none relied on.
- No live fault injection, sensor rewiring, bypass, arbitrary software pulse filter or machine operation is authorized. G0/G1 HOLD.

## Next discriminating evidence
Obtain exact installed safety input/ESPE part and editions, both electrical interfaces and wiring topology, source-test assignment and timing compatibility, plus machine-level qualified response-time/stop/hold validation. Do not generalize the 300 µs or 5 ms product numbers. If machine-specific evidence remains absent, preserve this as a documentary module and rotate.
