# 4400 — Cable-pull emergency stop: tension-margin warnings, safety-path versus diagnostic tags, and reset sightline

**Status:** manufacturer-document research / NOT a selected-machine safety design, NOT TEST-CONFIRMED. **Scope:** long conveyors, feeders, plasma/router tables, automation cells, and any machine where an assessed cable-pull E-stop is appropriate. **Not a claim that a cable switch is installed on OpenPressBrake.** Read alongside 2530 E-stop span/restart and the existing 4400 GuardLink authority study; this investigation adds the *mechanical cable span and tension-margin state* that the GuardLink lesson did not establish.

## Engineering question

Does a green electronic rope-pull E-stop and a diagnostic tension warning prove that the full cable can be pulled effectively and the machine will reach a physical safe state? Can a LinuxCNC HMI consume a GuardLink tag or send a reset and thereby own the protective function?

**Answer:** No. The OEM explicitly documents a *warning margin with safety outputs still ON*, a separate safety signal path, and standard/non-safety-rated GuardLink device tags. Mechanical reachability and activation along the entire cable, selected safety logic/final elements, downstream physical stopping/holding, occupancy and deliberate restart must each be demonstrated.

## Original manufacturer sources inspected, revision and scope

1. **Rockwell Automation, 440E-IN008H-EN-P, February 2026, *Lifeline 5 Cable-pull Safety Switch Installation Instructions*, 20 pp.** Official PDF: https://literature.rockwellautomation.com/idc/groups/literature/documents/in/440e-in008_-en-p.pdf . Inspected printed pp. 1–6, 9–11, 17–18: device/output specs, tables 3–7, installation, GuardLink 432ES device-tag warning, OSSD-series wiring. **DOC-CONFIRMED** only for the named Lifeline 5 variants/firmware/connection mode. The manufacturer says 432ES Series B and exact variant/revision matter. Its February 2026 document edition is not evidence of the revision on a selected installed device.
2. **Rockwell Automation, 440E-IN006D-EN-P, September 2022, *Lifeline 4 Cable-pull Safety Switch Installation Instructions*, 4 pp.** Official PDF: https://literature.rockwellautomation.com/idc/groups/literature/documents/in/440e-in006_-en-p.pdf . Inspected printed pp. 1–2 and mounting/maintenance. **DOC-CONFIRMED** Lifeline 4 mechanical/NC-contact model; do not transfer Lifeline 5 electronic OSSD or diagnostic behavior to Lifeline 4.
3. **Schmersal, 103000117-EN/G, SISS 11.2023, *ZQ 900 Pull-wire Emergency Stop Switch Operating Instructions*, 5 pp.** Official PDF: https://products.schmersal.com/media/documents/DOC_MAN_MEC_siss-mrl-zq900_SEN_AIN_V4.pdf . Inspected printed pp. 2–4, §§2.1–2.3, 3.1, 4.2, 5.1–5.2. **DOC-CONFIRMED** mechanical positive-opening NC and latching release, wire-break stop, tensioning and inspection. Its different catalog variants have different NC/NO contact counts.

Public ISO 13850 and IEC 60947-5-5 references in these manuals are **manufacturer claims of conformity/application**, not independent inspection of the full normative standards. No normative numerical formula or universal cable layout is inferred.

## Distinguish physical cable state from safety output

| Physical/electrical state | Lifeline 5 OEM table 6/7 (printed p.5) | Engineering interpretation |
|---|---|---|
| Properly tensioned | Safety outputs ON, tension indication OFF, green status | **DOC-CONFIRMED** switch is locally ready; **UNKNOWN** whether the entire cable is accessible and will actuate, or the machine stops. |
| **Low tension warning** | **Safety outputs ON**, tension indication ON/flashing, green status | **DOC-CONFIRMED:** warning is **not** an automatic protective trip. **INFERENCE:** ignoring warnings can create a latent human-factors/maintenance problem. Require a defined prompt inspection/repair policy, not invented trip timing. |
| **High tension warning** | **Safety outputs ON**, tension indication ON/flashing, green status | Same; high tension is not evidence of healthy pull geometry. |
| Cable cut/not tensioned | Safety outputs OFF, auxiliary ON, red status | **DOC-CONFIRMED** for the specified product. **UNKNOWN** downstream physical stop, hydraulic/drive holding and restart. |
| Rope pulled or local E-stop pressed | Safety outputs OFF, red status | **DOC-CONFIRMED** device state; the machine-level safety reaction must be separately verified. |
| OSSD upstream inputs not connected (8-pin) | Safety outputs OFF, green-flashing status | **DOC-CONFIRMED** wiring/series-path issue, not proof of mechanical cable pull. |

**Important distinction:** The tension output is a **maintenance/diagnostic indication**, not a replacement for the two qualified OSSD outputs. The manufacturer's device-specific **60 ms OFF response** and additional **5 ms per series switch** (for its documented OSSD mode) are not complete machine stopping times. The full physical response includes all downstream safety logic, final elements and actual mechanics. Do not insert 60 ms into a press-brake protective-distance calculation without a verified complete timing chain.

## Contact-based versus electronic devices: do not copy wiring by appearance

- **Schmersal ZQ 900:** cable properly pre-tensioned -> NC contacts closed; pulling **or breaking** the wire actuates the latched emergency-stop command; manual blue release only when properly pre-tensioned (Schmersal §§2.3, 4.2). Contact options differ by `-11/-13/-22/-02/-04`; verify *actual* terminal numbering and selected safety-input fault detection.
- **Rockwell Lifeline 4:** original 2022 manual specifies direct-opening NC safety contacts (variant-dependent), not Lifeline 5 GuardLink status tags. Mechanical geometry and qualified installation remain necessary.
- **Rockwell Lifeline 5:** M12 **8-pin is OSSD-only** and exposes a separate tension output. M12 **5-pin changes pin meanings by OSSD versus GuardLink mode** (Rockwell table 4, p.3); do not interchange harnesses or treat the same conductor as the same safety function after a mode change. The 4-pin cordset option in the manual **cannot be used for GuardLink**.
- **Rockwell Lifeline 5 GuardLink + 432ES:** the OEM calls the device input tags **standard, none safety-rated** (printed p.10). The I/O tree's `Data` connection is explicitly **non-safety-rated** (p.9). The supported *safety* decision must be traced through the actual qualified GuardLink/CIP Safety controller path and final elements, **not** the convenient LinuxCNC HMI/ordinary Ethernet tag.
- **Electronic keying:** the OEM distinguishes compatible/exact/disabled keying; disabled is only for troubleshooting. Its worked discovery example finds a physically installed model different from the configured catalog entry and directs correction. **INFERENCE:** a green HMI and populated I/O tree do not prove the right device/variant is installed or that a safe replacement has been validated.

## Reset and restart are separate events

- Schmersal ZQ 900 (§2.3): determine the cause before blue-button release; correct cable pre-tension is required. Its mounting section requires the full cable visible from the reset position.
- Rockwell Lifeline 5 (printed pp. 5–6): local rope reset requires a **125 ms–3 s** press for this exact model; OEM requires full cable length visible from reset or inspection of the whole length **before and after** reset. This is a **device-specific reset input window**, not a safety PLC rearm interval or stopping time.
- Rockwell's **432ES GuardLink device-tag HMI `Reset` example** (printed p.10) is a command to recover an **internal recoverable device fault** by device reset/power-cycle, with a momentary OFF→ON sequence. **DOC-CONFIRMED:** these tags are *standard* class. **INFERENCE:** a remote HMI `Reset` cannot substitute for local rope release, span inspection, safety-controller rearm, cleared occupancy or a separate fresh production start.
- Even when the rope switch has locally reset, **do not automatically restart** the machine. Retained LinuxCNC program/MDI/jog requests are ordinary control state and must not be credited with independent restart prevention.

## Mechanical/human factors and failure-path table

| Hazard/failure | OEM basis | Safer, easier design and evidence |
|---|---|---|
| Cable trapped behind stock, guide, pulley or structure | Rockwell Lifeline 4 p.2 warns that choosing one/two switches requires assessing **trapped-rope probability**; Lifeline 5 requires functional test of **all pull directions along full span** | Route cable where a panicked operator can reach/pull it; minimize snag points; assess need for dual-ended devices. No hidden unreachable spans. |
| Cable stretch or temperature drift | Rockwell Lifeline 5 pp.5–6; Schmersal §3.1 | Use OEM tension spring/anchors/guides; accessible indicators; post-install retension and seasonal inspection; avoid nuisance alarms that operators predictably defeat. |
| Pull direction/deflection obstructed | Rockwell Lifeline 5 printed p.5 eyebolts first 300 mm and subsequent 2–3 m; Schmersal ZQ 900 max. 3 m support spacing for >10 m (different OEM rules) | Follow **selected** product's geometry; prove actuation at accessible locations and worst-case directions. Do not transplant dimensions between models. |
| Warning ignored because machine still runs | Rockwell table 6/7: warning with OSSDs ON | Local maintenance flag, accessible adjustment and time-bounded owner escalation based on risk/OEM; never call warning an automatic stop. |
| Diagnostic/status tag substituted for safety | Rockwell 432ES `Data` non-safety, device tags standard | Independent safety path, safety I/O ownership, correct configured module, physical final-element witness. |
| Remote reset after hidden access | Rockwell cable inspection requirement | Put local reset where whole span is visible or require explicit inspection procedure and occupancy protection. Reset is not start. |
| Rope cut or switch housing damaged | Both OEMs | Stop state and defect quarantine; replace damaged switch per OEM, revalidate. No temporary tie-off/bypass. |

## Evidence ledger and unanswered questions

| Claim | Classification | Source/verification | Selected-machine status |
|---|---|---|---|
| Lifeline 5 low/high tension warnings can coexist with safety outputs ON | **DOC-CONFIRMED** | 440E-IN008H pp.5, table 6/7 | **UNKNOWN** installation and downstream effects |
| Lifeline 5 432ES device tags and `Data` connection are standard, not safety-rated | **DOC-CONFIRMED** | 440E-IN008H pp.9–10 | **UNKNOWN** selected controller |
| Lifeline 5 8-pin OSSD-only; 5-pin pin roles depend on mode | **DOC-CONFIRMED** | 440E-IN008H p.3 tables 3/4 | **UNKNOWN** selected harness |
| ZQ 900 broken rope actuates latched emergency stop | **DOC-CONFIRMED** | 103000117-EN/G §2.3 | **UNKNOWN** selected device |
| Cable route/visibility/maintenance affects usability and failure probability | **DOC-CONFIRMED** OEM guidance; **INFERENCE** risk effect | Both manuals, no physical observation | **UNKNOWN** selected route |
| Full-span actuation, safe final-element withdrawal, load holding and separate restart | **UNKNOWN** until selected physical proof | `SF/SRS/ARC/DEP/PHY/VAL/PT` | **NOT RUN** |

No SOURCE-CONFIRMED LinuxCNC code claim, TEST-CONFIRMED lab result, physical E-stop exercise, new PL/SIL, stopping distance, rope tension threshold, or machine-specific installation is asserted here.

## Practical machine transfer / non-equivalence

A cable-pull E-stop can be a practical supplementary device along **conveyors, feeders and long machine perimeters** when selected by risk assessment; it is not a substitute for fixed guards, interlocked gates, press-brake point-of-operation protective devices, safe load holding, or lockable energy isolation. For a press brake, whether a cable belongs at all is **UNKNOWN** until the real interaction geometry and hazards are assessed. A rope switch cannot by itself prevent a gravity-loaded ram from falling after energy removal.

**Minimum threshold:** if required protection, span accessibility, final-element reaction, restart prevention or gravity-load restraint cannot be established, **no personnel-exposed hazardous operation**. Experimental machine operation, if justified, must be isolated/remote with people outside the danger zone and residual risk documented; no live cable fault injection or physical testing is authorized by this research note.

## Precise next evidence

1. If selected machine has a cable E-stop: collect exact catalog/variant/firmware/connection mode, as-built wire/harness and safety I/O, full-span route/anchors/pulleys, environment, reset sightline and maintenance policy; preserve in restricted machine records, not public curriculum.
2. Map cable pull, cut/slack, high/low tension, local reset, GuardLink device fault/reset, safety PLC rearm, final elements, physical stop/hold and distinct start as **separate** propositions.
3. Qualified reviewer to define physical validation under a safe, isolated test envelope; record `PHY/VAL/PT` only from actual independent witnesses, not paper scenarios or status bits.
4. For curriculum, administer an **information-separated novel** external transfer task; learner-visible technician practice below is **not** a blind benchmark.
