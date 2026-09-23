# 2540 — Relays, contactors, and the real meaning of a “safety relay” — source preparation

Session source-prep artifact. The governing course plan defines 2540 as the next module after 2530.

## Learning problem

A learner must not infer safety performance from the word **relay**, from a red/yellow housing, from two channels, or from a familiar-looking schematic. The useful question is: **what physical failure modes, diagnostic mechanisms, reliability assumptions, architecture, application constraints, and validation evidence make the claimed safety function defensible?**

This module therefore separates four things that are often collapsed:

1. an ordinary electromechanical relay;
2. a relay with force-guided / mechanically linked contacts;
3. a safety relay module that contains monitoring/diagnostic logic and documented application assumptions;
4. the complete machine safety function, including sensors, wiring, logic, outputs, final elements, machine physics, reset/restart behavior, and validation.

A component may support a safety function without proving the complete function.

## Authoritative/current manufacturer source trace

### Siemens — force-guided coupling relays and B10d

**DOC-CONFIRMED (manufacturer):** Siemens' current SIRIUS coupling-relay material explains mechanically linked / force-guided operation as contact linkage that prevents NO and NC contacts from being closed simultaneously. Siemens states that this makes failures to open detectable and identifies force-guided coupling relays as useful for fail-safe coupling/output expansion and reliable feedback/NC-contact diagnosis.

Source: https://www.siemens.com/en-gb/products/sirius/coupling-relays-signal-converters/

**DOC-CONFIRMED (manufacturer):** Siemens separately describes verified B10d values as supporting functional-safety planning. Its published explanation treats B10d as a switching-cycle reliability quantity used with operating frequency to derive reliability measures; it also states that PL evaluation combines reliability with diagnostic coverage and architecture. This is important because **B10d alone is not PL**.

### Rockwell Automation — ordinary versus forced-guided relay distinction

**DOC-CONFIRMED (manufacturer):** Rockwell's current 700-HPSXZ24 product page explicitly identifies that device as a safety relay and marks `With forced-guided contacts: True`; the otherwise relay-like 700-HP32Z24 product page marks `With forced-guided contacts: False`. This is a useful concrete learner comparison: similar packaging/contact function does not make two relays equivalent for a safety-related diagnostic architecture.

Sources:
- https://www.rockwellautomation.com/en-us/products/details.700-HPSXZ24.html
- https://www.rockwellautomation.com/en-us/products/details.700-HP32Z24.html

### Pilz — safety relay module scope

**DOC-CONFIRMED (manufacturer):** Pilz describes PNOZ safety relays as monitoring safety functions including emergency stop, safety gates, light barriers/light curtains, two-hand control, speed and standstill. That is evidence that a commercial safety relay is a monitoring/control subsystem with defined application functions—not merely a specially colored power relay.

Source: https://www.pilz.com/en-US/products/relay-modules/safety-relays-protection-relays

## Derived teaching model

Use this chain when reading any safety-relay application:

`hazard / PROP -> input device -> input wiring -> monitoring logic -> diagnostic hypothesis -> output switching -> external final element -> feedback/witness -> physical machine proposition -> reset/restart -> validation`

For every claimed feature, ask:

- What fault does it address?
- What exact state does it observe?
- What faults can defeat both the function and its diagnostic?
- Is the observation electrical, mechanical, or truly a witness of the required machine physics?
- What application assumptions are required?
- What remains UNKNOWN until machine-specific evidence exists?

## Force-guided contacts: what they buy, and what they do not

A force-guided contact set is valuable because mechanically linked contact behavior can make certain contact failures observable through an oppositely acting feedback contact. That supports diagnostic designs such as feedback/EDM.

It does **not** by itself prove:

- that two independent safety channels exist;
- that a contactor actually removed all hazardous energy;
- that a spindle has stopped;
- that a gravity load is held;
- that pneumatic/hydraulic pressure is exhausted;
- that the feedback wiring and logic are fault tolerant;
- that common-cause failures are controlled;
- that the complete safety function achieves a particular Category, PL, SIL, PFHd or PFD.

**Freeze:** FORCE-GUIDED CONTACTS != COMPLETE SAFETY FUNCTION.

## Reliability quantities: keep the denominator honest

B10d is a component/cycle reliability input under stated conditions. Application switching frequency matters. A relay that cycles once per shift and a relay that cycles many times per minute do not consume mechanical life in the same way.

The curriculum must not turn a catalog B10d number into an application PL/SIL claim without the rest of the applicable method: architecture, dangerous failure assumptions, diagnostics, common-cause/systematic controls, mission/use profile, downstream elements and validation.

**Freeze:** B10d DATA PRESENT != ACHIEVED PL/SIL.

## Ordinary relay vs force-guided relay vs safety relay module

| Question | Ordinary relay | Force-guided relay | Safety relay module |
|---|---|---|---|
| Switches contacts from a coil/input? | yes | yes | typically owns/controls safety outputs |
| Mechanical linkage intended to make covered contact failure observable? | not inherently | yes, for the specified contact set | may use internal force-guided architecture and/or other certified architecture |
| Input discrepancy/cross-fault logic? | no inherent claim | no inherent claim | may provide it for documented input/application types |
| Monitored reset/start behavior? | no inherent claim | no inherent claim | may provide documented modes |
| EDM/external-device feedback support? | requires external design | requires external design | often application-dependent and documented |
| Complete machine physical safe state proved? | no | no | no |
| PL/SIL transfers automatically to a lookalike circuit? | no | no | no |

The table is a conceptual discriminator, not a universal datasheet for every product. Product-specific behavior remains tied to its manual and application conditions.

## Fault-driven exercise seed

Give the learner a machine safety function whose final switching uses two ordinary relays with one auxiliary contact each. Ask them to attack these claims:

1. “There are two relays, therefore it is redundant.”
2. “Both auxiliary contacts say open, therefore hazardous energy is removed.”
3. “The relays have high mechanical life, therefore the circuit is PL e.”
4. “Adding a safety relay module makes the external contactors irrelevant to the integrity calculation.”
5. “A welded contact will always be detected.”

Required response: state the physical safe-state proposition first, identify dangerous single/latent/common-cause faults, identify what each feedback path actually witnesses, then state what evidence is still missing. Do not assign a PL/SIL without the required application-specific inputs.

## Human-factors connection

Diagnostics that merely say `SAFETY FAULT` without identifying the affected device/path encourage bypass and parts-swapping. A maintainable design should make the safer repair path easy: clear device labeling, inspectable feedback path, useful diagnostic indication, captive/replaceable wiring where practical, and a defined post-repair validation step. Diagnostic convenience is not a substitute for integrity, but poor maintainability can create a predictable defeat incentive.

## Evidence status

- Manufacturer force-guided-contact principle: **DOC-CONFIRMED**.
- Manufacturer B10d/reliability role: **DOC-CONFIRMED**.
- PNOZ safety-relay monitoring scope: **DOC-CONFIRMED**.
- Exact internal architecture of a particular safety relay: **UNKNOWN unless its product manual/safety data establishes it**.
- Machine-specific switching frequency, load utilization, B10d applicability, DC, CCF, MTTFd/PFH/PFD, required/achieved PL/SIL: **UNKNOWN until derived from the actual application and selected method**.
- Physical final-element success: **UNKNOWN until supported by the appropriate machine-level witness/test**.

## Next evidence-gain task

Build the 2540 commercial-family comparison required by the course plan using at least five current families. Capture only documented values/behaviors and their assumptions: claimed Category/PL/SIL where published, PFHd where published, response time, contact/load ratings, reset modes, input cross-fault behavior, EDM/external feedback, mission/use assumptions and reliability data. Reverse-map each feature to the fault it can actually address. Treat unavailable values as UNKNOWN rather than filling them from another family or a lookalike model.
