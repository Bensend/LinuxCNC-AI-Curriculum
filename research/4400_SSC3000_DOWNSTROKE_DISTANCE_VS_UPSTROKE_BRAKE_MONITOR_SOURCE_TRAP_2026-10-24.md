# 4400 — Rockford SSC3000: downstroke distance measurement versus upstroke brake-monitor thresholds
**2026-10-24 | Original manufacturer-source trace | 4400 safety | Machine-class and measurement-purpose boundaries.**

## Question and result
Does a manufacturer's advice to ignore an unusually high stopping-time measurement authorize deleting the longest credible stop from a safeguard separation-distance assessment? **No such transfer is established.** The source instructions concern *different tests with different purposes* on a **part-revolution clutch/brake mechanical press**. The published upstroke brake-monitor warning/fault-setting procedure must not silently replace downstroke point-of-operation protective-distance evidence.

## Pinned document and direct sections
- **Rockford Systems, SSC3000 Press Automation Control System**, installation manual **KSL252**, ©2025, [original manufacturer PDF](https://rockfordsystems.com/wp-content/uploads/SSC-3000-Press-Automation-Control-System_KSL252.pdf), inspected 2026-10-24; printed pp. 69–71, PDF pp. 68–70. No machine hardware or configuration inspected.
- Printed p. 69 (PDF p. 68): brake monitor and integrated STM described separately. **DOC-CONFIRMED**: a *downstroke* measurement, usually near a particular crank angle in this device, is used for two-hand/light-curtain safety-distance work; an *upstroke* measurement near top stop is used to determine brake-monitor warning and fault settings.
- Printed p. 70 (PDF p. 69): STM user interface allows repeated measurements and shows different prompts for downstroke separation distance versus upstroke monitor settings. Example display values are **illustrations only**, not thresholds for any other press.
- Printed p. 71 (PDF p. 70): for *upstroke brake-monitor warning/fault* configuration, the manual describes at least ten readings and an instruction to disregard a measurement that is excessively high relative to others; the next-highest result is used for the device's threshold calculation. **DOC-CONFIRMED exact context**, not a general measurement-data exclusion rule.
- Printed p. 4 (PDF p. 3), p. 7 (PDF p. 6): product targets a part-revolution clutch/brake press with resolver/pulser and monitored pneumatic clutch/brake control; this is **not** a verified hydraulic press-brake controller, and its crankshaft angle method is not a generic Y1/Y2 ram method.
- [SICK US ANSI B11.19-2019 manufacturer explanation (2021)](https://sickconnect.com/calculate-safety-distance/) says to account for sensing/interface/control/machine/monitor time and suggests selecting the larger of ten-sample maximum or mean + 3 standard deviations. [Pilz overrun guidance](https://www.pilz.com/en-US/support/lexicon/articles/231033) uses the worst of ten in its example. These are separate **DOC-CONFIRMED manufacturer descriptions**, not the full normative ISO 13855:2024 or a reconciliation of Rockford's product-specific threshold-setting procedure.
- OSHA [1910.217(a)(5)](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.217) excludes press brakes from that mechanical-power-press standard. It is not sound to use the SSC3000 manual's mechanical-press settings or OSHA 1910.217 numerical method as a press-brake acceptance criterion.

## Exact causal fork
| Case | Trigger/observation | Intended question | Invalid extrapolation |
|---|---|---|---|
| `STM-DISTANCE` | Stop request during the machine's selected hazardous downstroke; physically observed crank/slide run-down | Can a person reach the hazard before normal dangerous motion ends under a qualified device/geometry/mode? | Upstroke top-stop threshold proves downstroke approach safety. |
| `STM-BRAKE-MONITOR` | Stop command timed for upstroke near the selected top-stop condition | Does this particular mechanical press's brake monitor warn/fault as stopping performance deteriorates relative to configured thresholds? | Monitor warning/fault value is a physical safety-distance measurement, or proof of all hazards. |
| `STM-FAULT` | One credible, substantially longer stop, sporadic slip, missed stop, resolver fault, or thermal degradation | Is the protective stopping function still adequate, and what caused the anomalous event? | Deleting the long result without independently proving instrument invalidity restores safe operation. |

**INFERENCE:** a valid high stop time may be the very fault a protection system needs to detect. The OEM's context-specific outlier instruction cannot serve as an independent justification to discard that result in a different safety claim. Preserve raw data, timestamps, sensor identity, operating condition and instrument validity. A proven sensor acquisition fault should be separately documented rather than silently erasing evidence. Even if a brake-monitor threshold-setting method is followed for that exact product, the independent safety-distance argument still requires its own qualified physical evidence and applicable edition.

## Distinct end-of-motion witnesses
A crankshaft resolver, slide encoder, Y1/Y2 ram sensors, drive encoder and independent displacement transducer do not necessarily observe the same physical object. A broken coupling, slip, eccentric mechanism, brake defect, hydraulic leakage or asymmetric load can invalidate a proxy. **INFERENCE:** record both the stop-demand origin and the *last hazardous movement* end event, and independently establish which sensor is mechanically linked to the actual hazard. For a press brake, Y1/Y2, workpiece sweep and gravity-load restraint cannot be inferred from an SSC3000 crankshaft stop test. A safety output OFF is not the last-motion timestamp.

## Change/retest and human factors
Rockford's p. 69 explicitly connects changed stop settings or deteriorated stopping to reassessing the distance and potentially moving protective devices. A guard that is so far away it is routinely bypassed is a human-factors failure: improve layout, usable tooling access and a correctly engineered safeguarding concept, **not** hide a long stop result or shrink a distance by choosing an optimistic statistic. Device-specific monitoring thresholds, physical stopping acceptance, guard geometry, maintenance isolation and fresh restart remain separate contracts.

## Adversarial evidence requirements
1. What exact *machine class*, product variant and brake architecture is this manual describing? `DOC-CONFIRMED` only for SSC3000's described architecture; selected OpenPressBrake `UNKNOWN`.
2. Was the measurement for downstroke point-of-operation distance or upstroke brake-monitor setting? Record each independently.
3. Does the instrument measure actual hazardous movement, not just controller request or motor encoder? `UNKNOWN` without selected-machine physical mapping.
4. Was an outlier a credible long stop or a documented instrument failure? If unresolved, **HOLD**, not deletion.
5. Which standard edition, device response time, approach route and type-C rule apply? Full ISO 13855:2024 clauses not available; no numeric acceptance.
6. Are gravity/pressure/energy isolation, hidden occupancy and deliberate restart separately protected? If not, separation distance does not close those hazards.
7. Was an OEM change, service or brake wear event recorded? Invalidate stale `VAL/PT` and re-evaluate the actual selected safeguard.

## Status and next work
`DOC-CONFIRMED` manufacturer text at KSL252 printed pp. 4, 7, 69–71. `INFERENCE` conservative source-transfer and physical-witness method. `TEST-CONFIRMED` **none**. OpenPressBrake `IN-01..10`, safety hardware, Y1/Y2 stopping, gravity holding, guard geometry, mode and PL/SIL **UNKNOWN/NOT RUN**. No machine operation, test, simulation or safety release. The historic six original archive files remain pending exact bytes. 2520–25F0 information-separated competency gates remain OPEN.
