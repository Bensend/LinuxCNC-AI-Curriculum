# 4400 ROPE-PULL-01 — cable-pull E-stop mechanical coverage, tension margins and restart: original OEM audit

**Study date:** 2026-10-26. **Status:** SOURCE/DOCUMENTARY RESEARCH; not a selected-machine design or physical validation. **Novelty check:** `safety-course/SAFETY_COURSE_INDEX.md` contained no dedicated rope-pull/cable-pull branch; prior E-stop, pendant, pedal, conveyor and reset lessons remain prerequisites, not rediscoveries.

## Engineering question

Can an apparently available red emergency-stop cable protect its *whole intended span*, detect a broken/slack cable, and remain safe when temperature, maintenance, routing, or reset behavior changes? **A green indication at the sensor is not a whole-span coverage or physical-stop witness.**

## Original manufacturer and regulator provenance

1. **Rockwell Automation**, *Lifeline 5 Cable-pull Safety Switch Installation Instructions*, **440E-IN008H-EN-P, February 2026**, original 20-page PDF: https://literature.rockwellautomation.com/idc/groups/literature/documents/in/440e-in008_-en-p.pdf . Directly inspected PDF pp. 1–6 and 18; p. 5 status/output tables and spring drawing visually inspected. Exact product family: single-head 440E-LL5SS8/SS5/SE8/SE5/SN8/SN5; dual-head 440E-LL5DSE5/DSN5/DSS5. Product-specific electronic rope monitoring; do not generalize to every mechanical switch.
2. **Schneider Electric / Telemecanique Sensors**, *Emergency Stop Rope Pull Switch XY2CE*, original **S1A6956103-06, December 2017**, 2-page instructions: https://iportal2.schneider-electric.com/Contents/docs/XY2CE2A290H7_INSTRUCTION%20SHEET.PDF . Directly inspected text pp. 1–2. Exact XY2CE family; model/accessory selection matters.
3. **Schneider Electric / Telemecanique Sensors**, *Emergency stop rope pull switches, XY2C range*, original manufacturer catalog, pp. 2–5: https://iportal2.schneider-electric.com/Contents/docs/EMERGENCY%20STOP%20ROPE%20PULL%20SWITCHES%20XY2C%20RANGE_CATALOG.PDF . Directly inspected text. Catalog distinguishes XY2CJ/CH/CE and double-anchor XY2CED, cable size, spring and indicator options.
4. **OSHA**, 29 CFR **1926.555(a)(3),(7)** (construction conveyors): https://www.osha.gov/laws-regs/regulations/standardnumber/1926/1926.555 ; 29 CFR **1910.269(v)(11)(xi)** (specified electric-power operations): https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.269_2 ; **1917.48** marine terminals: https://www.osha.gov/laws-regs/regulations/standardnumber/1917/1917.48 . Directly inspected published text. **Do not transfer their scope as a universal press-brake or all-industry mandate.**

## Directly established mechanisms and precise boundaries

| Proposition | Classification and exact evidence | What it does NOT establish |
|---|---|---|
| The Rockwell Lifeline 5 is an electronically monitored cable-pull E-stop with **manual reset** | **DOC-CONFIRMED**, 440E-IN008H p. 1 introduction, pp. 4–5 | It does not certify the installed final elements or physical stopping/holding. |
| **Cable cut/not tensioned** turns safety outputs **OFF**, status red and tension amber flashing in the published OSSD output tables | **DOC-CONFIRMED**, Rockwell p. 5 Tables 6–7; p. 5 screenshot inspected | It is the exact monitored-product behavior, not a guarantee for arbitrary rope switches, bypassed safety inputs, or downstream wiring. |
| **Low or high tension margin** can show **green status + amber flashing**, with safety outputs still **ON** | **DOC-CONFIRMED**, Rockwell p. 5 Tables 6–7 and margin description | Green/ON does **not** prove full cable accessibility, reliable pull in every direction, or that maintenance can be postponed indefinitely. This is a diagnostic warning state, not a safety trip. |
| Rockwell requires the specified **tension spring**, initial eyebolt **300 mm** from sensor, further supports **2–3 m** apart, and inside/outside pulleys where direction changes | **DOC-CONFIRMED**, Rockwell p. 5 installation instructions | Not universal cable geometry, force or span for Schneider/Banner or a particular machine. |
| Rockwell asks for a functional test of **all types and directions of pull along the full span**; full cable must be visible from reset or inspected before/after reset according to its stated EN ISO 13850 guidance | **DOC-CONFIRMED**, Rockwell p. 5; this is **manufacturer's standards description**, not a separately inspected ISO normative clause | A single pull near the switch or green LED is insufficient to validate remote corners. No numerical stopping-distance claim. |
| Rockwell example: a correctly adjusted **20 m** span accommodates a cited **−32 to +48 °C** example without retensioning | **DOC-CONFIRMED**, Rockwell p. 6 Figure 6 and example | **Not** a general ambient rating or guarantee for arbitrary cable length, construction or sensor. |
| Rockwell lists **60 ms device off response** and **+5 ms per additional OSSD-mode series switch** | **DOC-CONFIRMED**, Rockwell p. 2 specifications | Does not include safety-controller, contactor, drive, coastdown, conveyor runout or gravity load; no physical stop time derived. |
| Schneider XY2CE requires its specified **end spring XY2CZ702**, 5 mm cable, guides/pulleys **2.5–5 m** apart, full traction-zone access and inspection after installation/work | **DOC-CONFIRMED**, S1A6956103-06 p. 2 | Rockwell 2–3 m guide spacing cannot replace this model's instructions; Schneider's 2017 sheet does not prove a 2026 installation. |
| Schneider catalog identifies positive-opening **NC safety contacts**; NO is signaling only; latch/reset re-closes safety contacts but **separate manual machine-start command** is required | **DOC-CONFIRMED**, XY2C catalog p. 3 basic principles | Local mechanical reset must not itself start conveyor or reauthorize CNC motion. |
| Cable can be blocked, masked, tied back, incorrectly supported, snagged around a corner, or displaced by temperature | **INFERENCE**, based on the exact installation/accessibility/thermal instructions | Failure probabilities, diagnostic coverage, permissible reach, PL/SIL and physical stopping remain **UNKNOWN** until selected design and validation. |

### Crucial source distinction: warning vs trip

The **Rockwell Lifeline 5 p. 5 table** separates three states:
- Proper tension: safety outputs ON; status green; tension lamp off.
- Low/high tension margin: **safety outputs ON**; status green; amber warning flashes.
- Cable cut/not tensioned or deliberate pull: **safety outputs OFF**; status red.

A controller that maps *any amber* to an emergency trip may nuisance-stop, inviting bypass; a controller that ignores amber entirely may allow deterioration. Design a maintenance response to a warning **without treating the warning as evidence of a verified stop**. An HMI display may convey it; independent safety logic/final elements must enforce the actual safety function.

### Independent machine safety boundary

Normal LinuxCNC/HAL/FPGA: may show rope status, request normal stop and inhibit future commands. Safety-related controller/relay: must own validated protective-device inputs, stop and restart interlock. Final elements: motor/drive/brake/valves and any load-holding mechanics must be proven to reach the physical safe state. A cable-pull switch does **not** establish safe Y1/Y2 gravity holding, hydraulic isolation, conveyor coastdown or personnel rescue.

### Regulatory scope

OSHA 1926.555(a)(3) requires conveyor E-stop reset before restart **in construction**; (a)(7) covers maintenance LOTO. OSHA 1910.269(v)(11)(xi) addresses specified power-generation conveyor arrangements and requires stop devices at certain remote/unmanned locations, with restrictions on overrides. OSHA 1917.48 covers **marine terminals**. Do not imply these exact paragraphs regulate all LinuxCNC mills, lathes, press brakes or every conveyor; determine applicable machine/task/jurisdiction first.

## Adversarial failure paths and falsifiers

1. **Visible green, amber flashing:** Rockwell safety outputs may remain ON. Reject the inference “green means all cable conditions accepted.” Request maintenance before further degradation, preserve the independent stop function.
2. **Cut rope vs blocked rope:** the monitored sensor can report cut/slack, but a physically masked/immobilized section may prevent a human pull from reaching it. Only installed-span geometry and direction-by-direction proof address coverage.
3. **Reset behind blind corner:** the switch can rearm while a person is in the hazardous area. Manufacturer's full-span visibility/inspection instruction and independently designed deliberate start/zone-clear process are separate requirements.
4. **New turnbuckle, spring or pulley:** changed leverage/thermal behavior can invalidate an old functional test even with unchanged electrical safety relay.
5. **E-stop demand with heavy moving conveyor:** safety OSSD OFF is not proof that hazardous motion stopped. Validate actual final elements, stopping response and stored kinetic energy separately.
6. **Shop shortcut:** technician ties cable high to clear forklift traffic. Fix cable routing/protection and service access; do not accept tied-up rope as an operating mode.

## Evidence status and handoff

- **SOURCE-CONFIRMED LinuxCNC:** none new. Prior pinned HALUI/NML ordinary command boundary remains relevant.
- **DOC-CONFIRMED:** exact OEM/manual/regulatory statements above; PDF p. 5 Rockwell output table visually verified.
- **TEST-CONFIRMED:** none; no bench, simulation or machine operation.
- **COMMUNITY-REPORTED:** none relied upon.
- **INFERENCE:** failure paths and proposed usability improvements.
- **UNKNOWN:** installed machine uses rope switch at all, actual cable route/tension/contacts, selected safety controller, PL/SIL, stopping time, physical load hold, reset visibility, independent validation.
- **Gate:** G0/G1 HOLD for OpenPressBrake. This study is broadly useful for long conveyors, material handling, woodworking and automated cells; **not** evidence of an installed OpenPressBrake rope system.
- **Compute:** zero GitHub-hosted and zero local Actions minutes; no compute question requiring a lab.


## Second source pass — electronic keying, diagnostic tag class, and mixed series contacts

The same **Rockwell 440E-IN008H-EN-P (February 2026)** was independently examined at **printed pp. 9–11**, with original p. 10 and p. 11 figures visually inspected. These findings **extend existing 4400 GuardLink diagnostic and series-interlock lessons**, not a new discovery that ordinary diagnostics are safety-rated.

- **DOC-CONFIRMED, printed p. 9:** for the 432ES module definition, `Compatible Module` verifies product variant and major revision; `Exact` verifies variant plus major/minor; `Disabled` omits electronic keying and the manual restricts it to troubleshooting. The `Data` connection is expressly **standard non-safety-rated**. Do not infer that an unkeyed replacement or a discovered I/O tree proves the selected safety function.
- **DOC-CONFIRMED, printed p. 10:** Rockwell explicitly states that the 440E-LL5 controller input tags are **standard class, none safety-rated, and must not be used as part of a safety function**. A `reset` command over the documented HMI path can address a recoverable device fault; it is **not** physical zone-clear, independent stop/hold, or authorization for CNC motion. These exact source claims reinforce the earlier `4400_GUARDLINK_AUTHORITY_AND_RESET_ARCHITECTURE_CARD_2026-10-23.md` and `4400_GUARDLINK_DIAGNOSTIC_DECODER_ADVERSARIAL_WORKSHEET_2026-10-23.md`.
- **DOC-CONFIRMED, printed p. 11 timing and series-circuit figures:** three 8-pin OSSD devices are illustrated with **60 ms** first-device OSSD OFF and **5 ms** additional per downstream device, for **65/70 ms**. The manufacturer states **OSSD-only** series arrangements can be used in safety functions up to **PLe** per ISO 13849-1; a distinct illustrated series containing **voltage-free contacts** is described as reaching a maximum **PLd**, depending on installation details. **Neither example assigns a PL to OpenPressBrake or any other complete installation.** Do not treat the drawings as universal series-wiring approval; selected device and system assessment remain necessary.
- **INFERENCE/adversarial transfer:** a technician inserts a dry-contact device into an otherwise OSSD-only chain, observes green status on the first two switches, and retains a prior PLe claim. That claim requires fresh architecture/fault/wiring review; green diagnostics, successful enumeration, and serial I/O status cannot substitute for qualified integrity allocation and independent physical stop/hold.
- **Source-version note:** the printed p. 11 screenshot/footer appears to retain **July 2025** while the PDF cover and terminal publication footer say **February 2026, 440E-IN008H**. Preserve that page-level artifact provenance; do not silently infer a new physical test or change to the series rating from this editorial discrepancy.

**No new test, independent evaluator, selected machine, or compute.** Existing ROPE-PULL-01 12 public PAPER cases and ten documentary gates remain unscored/not run.
