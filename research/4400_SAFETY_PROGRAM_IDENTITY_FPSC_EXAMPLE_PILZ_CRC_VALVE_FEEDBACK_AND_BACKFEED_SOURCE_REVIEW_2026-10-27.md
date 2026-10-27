# 4400-SAFE-PROGRAM-04 — real safety-controller examples, active-project identity, valve feedback and AKAS backfeed

**Session start:** 2026-10-27T10:36:38.385Z UTC. **Status:** source/documentary transfer, NON-GRADUATED; no installed-machine proof. **Scope:** 4400 safety course, selected OpenPressBrake Stage A/B documentary readiness. No new physical test or public exam bank.

## The question and predecessor check

How can a reviewer distinguish an ordinary CNC "OK"/"MUTE" command, an independently executed safety program, a monitored external valve/contactor, and an actual stopped/held ram? More importantly, what **evidence of the active program** is needed before treating a safety-controller drawing as applicable to the machine?

Before claiming novelty, inspected the full canonical index and research plan, historical PROGRESS, and the 2026-10-23 three-position-pedal/dual-pedal work, 2026-10-27 AKAS-M/AMS3 and OPB-CUTOVER/OPB-ISO-03 work. The principles of independent safety authority, EDM, reset/new start, retained AKAS and wire-44 muting were **already taught**. The incremental contribution here is a **real, manufacturer-attributed but third-party-transcribed 2006 press-brake safety-program example** plus an **original, directly opened Pilz PNOZ m B0 manual's active-project/feedback/commissioning witnesses**. This is **implementation and provenance transfer**, not a new safety function or proof of the installed Pilz variant.

## Evidence ledger — do not upgrade a mirror to an original manual

| Source and exact scope | Directly observed content | Classification / limitation |
|---|---|---|
| Fiessler *FPSC Operating Instructions* Version 1.27-01 E00, document `BA FPSC_GB_1008_V1.27_01`, 2006-12-11; **third-party HTML transcription**, §§5.6.23, 5.7, 8.4 | Illustrative bending-press architecture with CNC request, FPSC safety checks, AKAS, guarded/rear access, three-stage pedal, external valve feedback, reset; read-back of function macros and shutdown table; explicit example-only caveat. | **COMMUNITY-REPORTED / mirrored manufacturer text**, not directly inspected original Fiessler PDF. Page transcription and graphics may be inaccurate. Do **not** call it DOC-CONFIRMED for exact terminals or installed behavior. https://manualzilla.com/doc/6875583/operating-instructions |
| Same FPSC mirrored manual §5.6.23, printed p.5-64, and §8.4 | Describes possible backfeed through AKAS FUO/FUS when receiver is switched off and an FPSC output remains driven, producing an F19 fault; §8.4 uses monitored valve-rest feedback before a new press request. | **COMMUNITY-REPORTED** exact legacy example, corroboration needed from original and selected circuit; not a measured failure and not a Pilz error-code interpretation. https://manualzilla.com/doc/6875583/operating-instructions |
| Pilz **original** `PNOZ m B0` operating manual `1002660-EN-13`, §§7.2–7.5, 8.2.2.2, 8.2.3 | Device project menu shows name, overall CRC and dates; device info includes hardware/firmware/software; commissioning demands safety-function check after chip-card exchange or project download; feedback-loop and supply faults have distinct diagnostics. Advanced output example specifies feedback and external-source exclusions as prerequisites. | **DOC-CONFIRMED**, **PNOZ m B0 only**. No evidence this exact base unit or menu is installed. https://www.pilz.com/download/open/PNOZ_m_B0_Operating_Manual_1002660-EN-13.pdf |
| Pilz official relay-function explanation and PNOZ 1 operating manual `21114-EN-06` | A monitored feedback loop checks downstream actuator/contact status; PNOZ 1 warns certain start arrangements can re-enable outputs when a safeguard resets and require separate prevention of unexpected restart. | **DOC-CONFIRMED** for the illustrated product/family; cannot transfer terminal names or start modes to an unknown Pilz application. https://www.pilz.com/en-INT/support/lexicon/articles/072106 ; https://www.pilz.com/download/open/PNOZ_1_Operating_Manual_21114-EN-06.pdf |
| Public OpenPressBrake `hardware/REV1_BOARD_INTEGRATION.yaml`, Git blob `271e2d94a75e11858288efb3375a639fbf188dc8` | Proposed ordinary DO2 `CTRL_MUTE_COMMAND` on wire 44 and DO6 `CTRL_CNC_OK` on wire 45, both on switched L7/L07; retained Pilz/AKAS are listed. | **SOURCE-CONFIRMED public design**, **not** as-built, not the actual Pilz program or a machine safety truth table. https://github.com/Bensend/OpenPressBrake/blob/main/hardware/REV1_BOARD_INTEGRATION.yaml |

## Architecture discriminator: request, safety decision, final element, physical result

1. **Normal CNC/FPGA request:** `CNC OK`, `MUTE COMMAND`, and cycle/start are ordinary upstream information unless the qualified installed safety application establishes their precise permitted role. The Fiessler example's similar labels are **not** evidence that OpenPressBrake uses the example program.
2. **Independent safety program:** identify the **exact active** project from the **installed** safety controller, not merely a laptop file, cabinet label, HMI green lamp or proposed schematic. The reviewed PNOZ m B0 supports project name/CRC/date and device info. A CRC is a *matching/identity aid*, **not** proof that logic or physical wiring is safe.
3. **Safety-related final element and feedback:** distinguish the output demand from contactor/valve feedback and its fault coverage. An NC feedback contact may prove a specific auxiliary contact state; it cannot alone establish hydraulic pressure, gravity holding, ram velocity or absence of a dangerous alternate flow path.
4. **Physical safe state:** independent qualified evidence of Y1/Y2 stop/hold, energy isolation, guarded access and fresh restart is required. Even correct software, active CRC and valve auxiliary contacts do not substitute for it.

## Four failure paths and discriminating evidence

| Conditional path (not observed) | False-safe inference to reject | Minimal qualified documentary discriminator |
|---|---|---|
| A workstation holds a valid-looking Pilz project, but a different project/chip card is active in the cabinet. | `project file reviewed` ⇒ `installed safety logic verified`. | Installed device identity, active program identity/CRC/firmware as supported by **actual model**, revision-matched reviewed export and change record. |
| A controller output requests a hydraulic valve OFF but a valve/contactor fails to return, or feedback is incorrectly wired/shorted. | `command OFF` or `one auxiliary NC closed` ⇒ `ram held`. | Qualified selected valve/feedback arrangement, fault-response logic, actual independent final elements, physical stop/hold witness. |
| AKAS receiver supply is absent but an ordinary/misapplied command drives its control input; a legacy example warns of FUO/FUS backfeed. | `ordinary mute low` or `no FPGA fault` ⇒ `AKAS and Pilz valid`. | Exact installed AKAS variant, receiver supply/return, safety PLC output mapping and protective fault behavior; **do not** reproduce legacy F19 by energized injection. |
| L7/L07 is restored with a held CNC OK/MUTE request, and a safety reset is accepted. | `CRC matches` or `reset succeeded` ⇒ `new safe start`. | Installed safety-program edge/release/rearm behavior and final-element/occupancy witness; existing restricted OPB-D02/D03/D06/D08. |

**Source ambiguity to preserve:** the mirrored FPSC §8.4 overview has awkward wording around whether CNC or FPSC grants the final enable. Its example diagram places both roles, but the HTML transcription is **not sufficient to assign a safety authority**. Use the original Fiessler PDF if recovered, then the actual selected Pilz application. Do not copy FPSC macro IDs or terminal numbers into Pilz.

## Human-factors and anti-defeat design

A useful maintenance screen can display **active project identity**, **which independent safety prerequisite is blocking rearm**, **field power/diagnostic validity**, and **the last qualified fault category**, but only as ordinary read-only diagnostics. Make the approved program backup/recovery procedure straightforward; make the guard, pedal and reset device easier to use correctly than bypass. Never offer an HMI "force safe" or "override Pilz" command. A stopped/disabled controller cannot certify safe maintenance access; use isolation and physical restraint appropriate to the actual machine.

## Next evidence / lab decision

Existing Stage A A–G and Stage B OPB-D01/D02/D03/D06/D08 requests already cover the required private evidence. **Do not create another owner questionnaire.** Ask a qualified reviewer to identify the **actual** Pilz model and active program/version/CRC using that model's official instructions, reconcile six ordinary CNC inputs and each independently credited output, and provide the actual hydraulic stop/hold/guard/restart validation. This is **UNKNOWN** until supplied privately. The 2006 Fiessler example and current PNOZ m B0 are **different product families**, and neither is asserted installed.

No LinuxCNC/FPGA/personnel-safety code changes, tests, simulation or runner compute were justified. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** No personnel-exposed hazardous operation. Experimental operation, if later necessary, requires qualified isolated/remote conditions with people outside the danger zone and residual risk explicitly evaluated.
