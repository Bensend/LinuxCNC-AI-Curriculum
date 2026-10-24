# 4400 — SICK deTec4 HG: muting, belt-stop timer suspension, override and return to protection
**Date:** 2026-10-24 | **Status:** original manufacturer source reading, NOT physical verification or safety certification.

## Frozen engineering question
Can a conveyor light curtain remain muted longer than a designer expects despite a configured timeout, and can an operator's override restore OSSD ON while the protective field remains obstructed? Which exact conditions and independent physical safeguards matter?

## Source and provenance
**DOC-CONFIRMED, original directly inspected:** SICK AG, *deTec4 HG Safety Light Curtain Operating Instructions*, document 8023856/1SWC/2026-02-05, 284-page English original, [manufacturer PDF](https://www.sick.com/media/docs/5/75/275/operating_instructions_detec4_hg_en_im0082275.pdf), printed pp.42–60 (PDF zero-based pages 41–59). This is the **HG** model and named function packages (SP2, DMM4, DCM4), not every deTec, S300, S3000 or AKAS variant. Sections 4.3.6 through 4.3.6.12 and 4.4.10. Full product/machine configuration UNKNOWN.

## Causal source findings
| ID | Manufacturer finding (page/section) | Why it changes an engineering decision |
|---|---|---|
| S-MUT-01 | p42 §4.3.6: muting temporarily bypasses the ESPE for material transport; at least two independent signals, not entirely software/PLC signals, are required. Before a new cycle the relevant sensor pair must reset. | A LinuxCNC recipe bit or ordinary FPGA output cannot substitute for the qualified material/person distinction. |
| S-MUT-02 | pp43–48 §4.3.6.1–.3: sensor geometry, direction and transport object matter; cross, exit and entry/exit variants differ. Sensor pairs and field need a valid sequence. | Material size, speed, sensor mounting, tailgating and alternate paths must be reviewed physically, not inferred from a 'muted' LED. |
| S-MUT-03 | pp49–50 §4.3.6.4: override is a *manual recovery after muting error*; when override required, at least one muting signal is active and ESPE interrupted. Actuation can turn OSSDs ON. Control must be outside hazard with full view. | OSSD ON during override does **not** mean clear optical field or a proven empty zone. Separate protected recovery/motion control required. |
| S-MUT-04 | p50: SP2 default successive override allowance is five; counter resets after an error-free cycle, startup, or muting reset. | 'Five overrides' is **not** a durable maintenance-attempt lockout across power cycles. Do not use it as personnel safety authority. |
| S-MUT-05 | pp51–53: sensor/ESPE gap monitoring tolerates short gaps; SP2 concurrence and total muting times are **24 hours**; Safety Designer can customize or deactivate the total-time monitor, which manufacturer warns can impair external-error detection. | The timer may be far longer than expected. Treat actual configuration and all sensor/field states as the evidence, not an assumed short automatic expiration. |
| S-MUT-06 | p53 §4.3.6.5.6: with both signals on receiver extension connection (without listed connector alternatives), cross-circuit monitor expects signals staggered **at least 50 ms**; simultaneous signals cause OSSD OFF. Other connection combinations do not require this offset. | This **50 ms is an OEM connection-specific sensor input rule**, not a generic safety stopping time or universal concurrence value. |
| S-MUT-07 | pp58–59 §4.3.6.10: belt-stop LOW pauses total-muting, concurrence and muting-hold timers; on resume HIGH they continue. A configured 24 h cap remains when total-time monitor exists. | 'The 4 s hold timer has expired' may be false if belt stop paused it. A jam can leave the field bypassed longer. |
| S-MUT-08 | p59: while belt stopped, previously active sensor/ESPE state changes are monitored and can end muting, after a configurable monitoring start delay; IO-Link may carry belt-stop for a **non-safety-related** use. | **Do not claim belt stop unconditionally keeps muting ON.** Identify monitored changes, delay and safety relevance of the signal. Ordinary IO-Link is not independent protective authority. |
| S-MUT-09 | pp59–60: fixed blanking can coexist with muting; blanking fault resets muting and requires a fresh complete cycle. Mode changes usually require inactive muting/override and all sensors inactive, with enumerated immediate-change exceptions. | Do not equate temporary muting with permanent blanking, or assume mode change always waits for the same condition. |
| S-MUT-10 | p51: 'Muting end by ESPE' can be delayed/ineffective on first power-on with auto field-width measurement and interrupted field; OEM recommends manual width setting in this condition. | A successful restart is not proof that a protection-restoration rule was active from first scan. |

## Predeclared predictions and documentary checks
These predictions are **engineering hypotheses recorded for future physical qualification**, not claims of tests performed: (P1) an unchanged belt-stop LOW may pause a configured hold timer; (P2) override may produce OSSD ON with blocked ESPE; (P3) power cycling can reset the consecutive-override counter. The original manual independently supports the **configured device behavior**, not installed-machine outcome. Physical behavior, actual timing, firmware and final-element stop/hold remain UNKNOWN. Do not count this as TEST-CONFIRMED.

## Failure-path reconstruction (conceptual, not a fabricated hydraulic/electrical truth table)
Material stalls in sensing field -> muting sensors remain active -> ordinary belt-stop indicates stationary -> timer pauses, but sensor/field changes still monitored -> operator may request override to clear material -> OSSD can re-energize while field blocked -> downstream safety controller/final elements and separate hold-to-run/exclusion must prevent person exposure -> after clearing, protection, reset/rearm and **fresh normal start** must be established independently.

Unsafe shortcuts: jumper muting sensors, force a software 'material present' bit, leave override keyswitch latched, assume light curtain ON proves empty cell, turn off all timers to eliminate nuisance stops, rely on reset to clear a retained LinuxCNC move, or bypass side guarding. Each defeats a distinct barrier.

## Evidence and transfer limits
**DOC-CONFIRMED:** S-MUT-01..10 for the exact cited product/version. **SOURCE-CONFIRMED:** no LinuxCNC implementation examined here; this safety logic is *not* LinuxCNC. **TEST-CONFIRMED:** none. **INFERENCE:** tailgating, stuck sensor, maintenance and convenience-driven bypass risk require independent geometric and physical review. **UNKNOWN:** selected installation, exact configuration, machine risk assessment, actual stop time/distance, performance level, energy removal, personnel occupancy and restart response.

**Minimum operating boundary:** no personnel-exposed operation when the independent stop/hold, physical access closure and reset/restart function have not been qualified. If experimentation is essential, isolate/operate remotely with people outside the hazard and explicitly account for residual motion/energy.

## Next information gain
Obtain exact as-built variant, package, plug, safety-controller inputs/outputs, configured timer/IO-Link/mode mapping, muting-sensor mounting geometry, test-object coverage, access paths, stop/hold and fresh-start proof. Do not run a simulation simply to restate this manual.
