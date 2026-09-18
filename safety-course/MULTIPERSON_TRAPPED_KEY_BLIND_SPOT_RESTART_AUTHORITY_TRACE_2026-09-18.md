# Multiperson trapped-key / blind-spot restart-authority trace

Date: 2026-09-18
Session start UTC: 2026-09-18T21:34:45Z

## Question

Can professional evidence close the Lane-B gap from multiple energy/access keys through multiple person-carried keys and bodily entry to a restart attempt with one person still inside, then restoration only after personnel accounting is complete?

## Evidence labels

- **SOURCE-CONFIRMED** — directly supported by authoritative manufacturer material cited below.
- **DOC-CONFIRMED** — supported by a repository-retained source trace.
- **TEST-CONFIRMED** — demonstrated by execution. None in this study.
- **COMMUNITY-REPORTED** — none relied upon.
- **INFERENCE** — engineering conclusion from confirmed architecture.
- **UNKNOWN** — machine/application-specific fact not established by the sources.

## Professional trace 1 — Fortress component-transfer-line access system

**SOURCE-CONFIRMED:** Fortress Safety's Industrial Access Control brochure shows a component transfer line where an authorized operator requests release of an isolation key; turning/removing that key isolates control to the manufacturing cells. The isolation key is inserted into a key-exchange unit to release multiple access keys.

**SOURCE-CONFIRMED:** At the access-lock units, personnel keys are extracted for operators entering the safeguarded space. The brochure explicitly depicts maintenance personnel in blind spots. It states that the access key remains trapped and the actuator cannot lock until all safety personnel keys are returned, and that the isolation key remains trapped in the exchange until all access keys are returned.

Source: https://fortress-safety.com/wp-content/uploads/2021/03/EN-Frank-Brochure-October-2021-v1.6-Digital-Version-1.pdf

This is stronger than a generic trapped-key description because one professional application joins authorization, isolation-token release, exchange, multiple access keys, multiple personnel keys, bodily entry/blind spots, and reverse-sequence restoration.

## Professional trace 2 — Fortress steel-processing entry looper

**SOURCE-CONFIRMED:** Fortress's entry-looper application uses a key-operated switch to isolate power, transfers the key to a key exchange, releases access keys, then releases a personnel key at each access lock. The operator keeps the personnel key until the task ends. Machine restart is possible only after the sequence is reversed.

Source: https://fortress-safety.com/application/entry-looper-in-steel-processing/

## Independent comparison — Pilz safety-side personnel accounting

**SOURCE-CONFIRMED:** Pilz Key-in-pocket records each authenticated entrant's security ID in a safe list in the PNOZmulti 2 or PSS 4000 safety controller. Multiple operators can sign in and enter, including through different safety gates. Production release requires every person to exit and sign out so the safe list becomes empty. For large or poorly visible installations Pilz additionally describes a blind-spot check before restart.

Sources:
- https://www.pilz.com/en-US/company/news/articles/238605
- https://www.pilz.com/de-CH/zugangsmanagement
- https://www.pilz.com/download/open/Fly_Flyer_IAM_1006692-EN-02.pdf

The mechanical and electronic implementations therefore independently support the same safety proposition: **one remaining person/token is sufficient reason to preserve restart inhibition**.

## Architecture freeze

`ALL ENERGY/ISOLATION TOKENS RELEASED != ALL ACCESS TOKENS RELEASED != ALL PERSONNEL TOKENS EXTRACTED != PERSONNEL ACCOUNTED FOR != HAZARD PHYSICALLY ABSENT`.

For restoration:

`ONE PERSON EXITS != ONE PERSONNEL TOKEN RETURNED != ALL PERSONNEL TOKENS RETURNED != ALL ACCESS LOCKS RESTORED != ALL ACCESS TOKENS RETURNED != ISOLATION TOKEN RECOVERABLE != ENERGY RESTORATION PERMITTED != PERSONNEL-CLEAR/BLIND-SPOT CHECK COMPLETE != SAFETY REARM != FRESH ORDINARY START`.

### Critical multiperson rule

**SOURCE-CONFIRMED + INFERENCE:** If two required personnel keys are extracted and only one is returned, the Fortress access-lock sequence cannot be fully restored. Pilz independently makes the equivalent state explicit: production release is withheld until the last person's safe-list entry is removed.

Freeze:

**N-1 PERSONNEL KEYS RETURNED != PERSONNEL CLEAR != RESTART AUTHORITY.**

A stale LinuxCNC `START`, `JOG`, `DOWN`, `ENABLE`, cycle request, or ordinary PLC bit cannot legitimately bridge this missing-person state.

## Blind-area rule

**SOURCE-CONFIRMED:** Fortress's component-transfer-line example explicitly depicts personnel in blind spots. Pilz states that large/poorly visible installations may require an additional blind-spot check before restart.

Freeze:

**ALL TOKENS RETURNED != BLIND AREA PROVED CLEAR.**

Token/accounting completion and visual/other personnel-clear verification are different propositions. The actual machine risk assessment determines whether an additional clear-zone check is required.

## Wrong / duplicate / spare-key boundary

**INFERENCE:** A duplicate or uncontrolled master/spare key can defeat the causal link between a physical person retaining a token and the upstream sequence remaining trapped. Key identity, duplication control, replacement and change management therefore belong to validation and maintenance of the safety function.

**UNKNOWN:** The cited public Fortress application does not expose a detailed wrong-key/duplicate-key fault table or administrative spare-key procedure. Do not claim that it does.

## Escape-release boundary

**SOURCE-CONFIRMED:** Fortress separately documents escape release as a reactive inhibit/egress function that must allow exit from inside the safeguarded space, including after power failure; personnel keys are a proactive restart-inhibit function. These are distinct safety functions.

Source: https://fortress-safety.com/news/difference-between-proactive-and-reactive-inhibit-functions/

Freeze:

**PERSONNEL KEY PRESENT != ESCAPE PATH PROVIDED.**

and

**ESCAPE RELEASE OPERATED/RESTORED != PERSONNEL CLEAR != RESTART AUTHORITY.**

## LinuxCNC / ordinary FPGA boundary

Ordinary LinuxCNC/HAL/FPGA may display key/accounting state, request stop, and consume a safety permissive. It must not be the sole authority that decides an absent personnel key can be ignored, synthesizes `all clear`, or turns restored safety permission into motion without fresh ordinary intent.

The safety-side chain remains:

`ordinary stop/access request -> required hazard control/isolation -> token exchange/access authority -> person-carried restart inhibit -> personnel-clear/blind-area validation where required -> reverse token sequence -> safety rearm -> fresh ordinary START`.

## Commissioning / adversarial worksheet

1. Extract two personnel keys; return only one; attempt reset/restart. Restart authority must remain absent where both keys are required.
2. Use different access points for two entrants; verify one restored gate cannot erase the other entrant's restart inhibit.
3. Close a guard while a required personnel key is absent; verify the upstream access/isolation token cannot be recovered through the intended sequence.
4. Restore all keys but intentionally leave an obscured test target in a blind area; where the risk assessment requires a blind-spot check, verify key completion alone does not bypass it.
5. Operate escape release from inside; verify egress is possible and restoration of the escape mechanism does not itself assert personnel clear or fresh START.
6. Power-cycle ordinary LinuxCNC/PLC/HMI while a personnel token is absent; verify ordinary reboot cannot recreate production authority.
7. Inject stale ordinary START/JOG/ENABLE across the complete access cycle; verify restored safety authority does not replay stale motion intent.
8. Challenge wrong/spare/duplicate-key handling according to the actual installed key-control procedure; if that procedure is absent, record a commissioning/change-management gap rather than assuming key uniqueness.

## What remains UNKNOWN

No OpenPressBrake requirement for trapped keys, number of entrants, access points, blind spots, energy-isolation topology, hydraulic isolation, gravity restraint, run-down time, safe-state witness, PL/SIL/category/DC/CCF, escape hardware, or restart sequence is established here.

The cited examples do not prove that key removal alone makes a hydraulic press brake safe. Physical hazard control and its witnesses must be traced separately.

## Compute

No executable verification is justified for this source/architecture question. No GitHub-hosted or self-hosted compute was consumed.

## Precise next work

Find a professional implementation that joins the multiperson/personnel-clear sequence to explicit physical final-element or hazard-state evidence and then exposes `all personnel clear -> reverse access/isolation sequence -> energy restoration -> safety reset/rearm -> separate fresh production START`. Prefer a complete accessible cell, robot cell, press or transfer line with an injected missing-person, wrong-key, escape-release, or blind-spot failure. If that source path stalls, rotate to the highest-value open safety branch rather than infer machine-specific behavior.