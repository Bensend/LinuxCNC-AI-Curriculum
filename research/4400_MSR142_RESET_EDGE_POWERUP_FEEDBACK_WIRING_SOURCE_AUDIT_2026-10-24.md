# 4400 — Rockwell MSR142RTP reset-edge, power-up and feedback-loop source audit

**Date:** 2026-10-24 UTC. **Status:** original documentary safety research; NOT selected-machine validation. **Question:** when can a seemingly manual reset permit an output to reenergize on power restoration, and what does the downstream feedback loop actually establish?

## Primary authoritative evidence (exact editions)

1. **Rockwell Automation**, *Minotaur MSR142RTP Monitoring Safety Relay Installation Instructions*, **440R-IN089A-EN-P, July 2022**, original four-page PDF: https://literature.rockwellautomation.com/idc/groups/literature/documents/in/440r-in089_-en-p.pdf . Printed p. 2, **Reset** and **Safety Input**; printed p. 3, Table 2; printed p. 4, **Safety Specifications**. Manufacturer identifies catalog family **440R-G23214 / G23215 / G23216** and MSR142RTP. The document supersedes 440R-IN064A-MU-P (April 2011). **DOC-CONFIRMED** for this family/edition, not OpenPressBrake hardware.
2. **Pilz**, *PNOZ — Automatic, manual, monitored start* manufacturer FAQ: https://www.pilz.com/en-INT/support/faq/products-solutions/articles/180991 . The PNOZ X terminology distinguishes automatic (input closed), manual (rising edge) and monitored (falling edge). **DOC-CONFIRMED** for the FAQ's product family; it is **not** a substitute for the Rockwell model-specific reset circuit.
3. **IEC**, *IEC 60204-1:2016*, edition 6, published 2016-10-13, with consolidated **2016+AMD1:2021** edition 6.1 listed by the publisher: https://webstore.iec.ch/en/publication/26037 . **DOC-CONFIRMED** publication, scope and edition only; full normative clause 7.5/9 wording was not independently licensed/inspected here. No invented normative quote.
4. **OSHA**, 29 CFR 1910.147 (maintenance hazardous energy): https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147 . **DOC-CONFIRMED** maintenance isolation and stored-energy framework. A reset circuit is not a lockable energy-isolating device.

## Critical manufacturer-specific observations

| ID | Manufacturer evidence and exact scope | Consequence / what it does **not** establish |
|---|---|---|
| RST-01 | Rockwell p. 2: **T** automatic/manual start does **not** monitor an S33–S34 reset edge. If safety inputs and reset circuit close together on power-up, the relay can activate immediately. | A physical momentary-looking button or an HMI label “manual reset” is not evidence of edge-monitored restart. A maintained/bridged reset input may enable immediately when other conditions return. |
| RST-02 | Rockwell p. 2: **R** manual monitored reset requires a signal change. **Positive-edge** variant activates after safety inputs close and reset circuit closes; **negative-edge 440R-xxxxxM** requires reset closure **and release**, with reset upon button release. | A field test must use the **exact installed catalog suffix and wiring**; do not generalize a press/release event across product families. |
| RST-03 | Rockwell p. 2: reset is only valid when the feedback circuit is closed; **Y1–Y2** receives normally closed contacts of controlled actuators. | The loop monitors those contacts and their wiring, **not** hydraulic cylinder movement, trapped pressure, mechanical brake load or a person's absence. A welded power contact may be diagnosed only to the extent the chosen feedback arrangement actually covers it. |
| RST-04 | Rockwell p. 2: cross-loop monitoring is available for **two-channel, four-wire** input wiring and disabled for listed single-channel, three-wire dual-channel and external 24 V signal arrangements. | “Dual channel” or a published device maximum rating does not prove the installed input fault coverage. Record exact topology. |
| RST-05 | Rockwell pp. 1–2: 0.85–1.1 times rated supply range; p. 1 lists power-on delay and p. 2 response/recovery specifications. | These are **device** characteristics, not a machine-wide brownout threshold, stopping time, valve reaction or safe separation distance. No OpenPressBrake numerical value is transferred. |
| RST-06 | Rockwell p. 3: Y35 is an input-state status output, Y32 and auxiliary contact 41–42 are safety-output-state diagnostics; Start indicator lights when reset circuit closes. | Green LEDs / diagnostics establish only indicated circuit state, not a fresh local operator intent, actual ram stop, mechanical restraint or energy isolation. |
| RST-07 | Rockwell p. 4: safety specifications are maxima dependent on operating mode and wiring; manufacturer states safety function demanded at least once per six months for its stated specification assumptions. | Do **not** copy the device's advertised PLe/SIL or diagnostic coverage into an unverified complete safety function or derive a universal proof-test interval. |
| RST-08 | Pilz PNOZ X FAQ uses different naming (automatic/manual/monitored = no edge/rising/falling). | Terminology itself is product-specific. Transfer **the question about the required edge**, not a guessed label-to-terminal mapping. |

## Counterexample: a “manual reset” that is not edge monitored

A hypothetical relay of the **Rockwell T** reset configuration has closed safety inputs and an S33–S34 circuit held closed by wiring or a failed/stuck control. After a power interruption, both inputs become closed again. The original manufacturer instructions permit immediate relay activation when those conditions close together. This is **DOC-CONFIRMED for the relay's described behavior**, **INFERENCE** as a possible retrofit failure path; no selected OpenPressBrake relay is identified and no physical machine has been energized.

The relay's **output reenergizing** is not automatically the same as **hazardous motion**: a properly independent downstream start/hold architecture may still inhibit motion. Conversely, if a maintained ordinary LinuxCNC/FPGA/drive/valve command survives and the relay's output is the only missing enabling element, the combined architecture may create unexpected motion. That combined sequence is a **design hypothesis**, not TEST-CONFIRMED.

## Distinct safety propositions that must survive a power event

1. **Safety input validity:** correct protective device, channels, fault detection and configuration after supply recovery.
2. **Reset edge / local intent:** exact selected reset mode, wiring and monitored edge; an automatic reenable is not deliberate operator reset.
3. **Feedback loop:** actual NC auxiliary contacts and monitored final elements; not just the relay's status lamp.
4. **Independent physical safety:** actual hazardous load stopped and held, with gravity, hydraulic and residual energy controlled.
5. **Fresh production start:** a new intentional local command distinct from safety reset, with old normal commands not replayed.
6. **Maintenance:** lockable physical isolation, stored-energy discharge/containment and mechanical restraint; not a relay output.

**Required authority separation:** safety relay/controller decides only the safety-related output function it is qualified to implement; ordinary LinuxCNC/FPGA supplies production commands and diagnostics; physical valves/drive/contactors and mechanical restraints act on actual energy; independent sensors/measurements witness physical stopping/holding. A remote status exporter is diagnostic, never reset or personnel-safety authority.

## Paper-only failure-path matrix (not a wiring instruction)

| Scenario | Potential unsafe inference | Qualified response / proof needed |
|---|---|---|
| Power returns with T reset loop already closed | “A human must have pressed Reset” | **False.** Check exact relay type, installed links and monitored-edge requirement; require separate fresh start if hazard exists. |
| R reset button stuck high before inputs recover | “R always energizes” | **Not established.** Original R mode monitors change and documents a reset fault when inputs open while reset closed. Determine exact sequence/variant; no blanket verdict. |
| R negative-edge model receives button press but not release | “Press equals reset” | **False for documented 440R-xxxxxM**: release is the reset event. |
| Feedback Y1–Y2 closes while ram drifts | “EDM proves load held” | **False**: contact feedback does not witness hydraulic drift. Keep PHY-HOLD separate. |
| Safety relay remains powered while field coil supply drops/returns | “Safety output state tells us valve power state” | **Not established**: trace coil supply, contactors, pilot pressure and load separately. |
| Only host/FPGA restarts; safety relay stays enabled | “Safety relay healthy means old command safe” | **False**: normal-command freshness/rearm is independent; actual machine behavior UNKNOWN. |
| Two-wire or external PNP safety input replaces four-wire circuit | “Fault detection unchanged” | **False**: Rockwell documents different cross-loop monitoring coverage. Revalidate the changed function. |
| Rockwell relay is replaced by a Pilz PNOZ X labeled manual | “Manual means same edge” | **False**: check exact device manuals, installed circuit, output monitoring and startup tests. |

## Minimum practical retrofit inspection (deenergized/documentary first)

Capture the **actual** catalog suffix, manufacturer edition, terminal photograph, signed wiring revision, reset pushbutton contacts, Y1–Y2 controlled-actuator NC feedback wiring, input channel arrangement, output loads, power domains, and upstream/downstream start logic. Record **who can see the danger zone from reset**, how a reset button can be reached, and whether guards are easy to restore rather than defeat. Do not open an energized enclosure or command a live machine to answer a paper question. An independent qualified tester may later define isolated/remote validation with people excluded from the hazard zone, proper restraints and documented abort conditions. **No physical test is authorized by this worksheet.**

## Evidence / open gates

- **DOC-CONFIRMED:** RST-01..08 only within cited original manufacturer/publisher scope.
- **SOURCE-CONFIRMED (prior repository evidence):** LinuxCNC v2.9.10 network/Task reset and machine enable are ordinary software requests; no new LinuxCNC source trace claimed here.
- **INFERENCE:** compound brownout, maintained command and reset-loop failure sequences; safer human workflow suggestions.
- **UNKNOWN:** OpenPressBrake actual safety relay model/reset configuration, dual Y1/Y2 final elements, safety wiring, field supplies, contact feedback targets, pilot pressure, guard occupancy and fresh-start implementation.
- **TEST-CONFIRMED:** none. No software simulation, self-hosted or GitHub-hosted compute, machine test, safety PL/SIL, stop time or distance.
- **Gate:** `IN-03/03a`, `IN-04/04a`, `IN-05`, `IN-06`, `IN-10/10a`, `AUTH/DEP/PHY/VAL/PT` remain UNKNOWN/NOT RUN. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No personnel-exposed operation without minimum independently proven safeguards.

## Next discriminating evidence

First resolve **which reset mode/edge the installed device actually implements** and whether a maintained reset input can cause output activation on power restoration; then trace **actual downstream actuator feedback** and **fresh production start** separately. A complete selected-machine safety circuit, qualified risk assessment and independent physical evidence are necessary before writing an actual acceptance test. If those inputs remain unavailable, rotate to another unblocked safety module; do not simulate guessed circuits.
