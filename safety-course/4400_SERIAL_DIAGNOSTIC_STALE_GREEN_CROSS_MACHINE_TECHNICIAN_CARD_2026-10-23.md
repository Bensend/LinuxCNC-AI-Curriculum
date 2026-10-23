# 4400 — Serial diagnostic freshness and false-green safety states: technician transfer card

**2026-10-23 | Learner-facing, open-book, unscored.** Companion: [AKAS-5M serial diagnostic source audit](../research/4400_AKAS5M_SERIAL_DIAGNOSTIC_REPETITION_FRESHNESS_AND_HMI_AUTHORITY_2026-10-23.md). No machine tests or blind evaluator answers are included.

## Exercise objective

Distinguish a *correctly decoded, historically valid device message* from a *currently established, physical personnel-safety proposition*. Explain why a safety-capable device's ordinary serial/fieldbus diagnostic output is not automatically a safety-rated channel.

**Pinned documentary source:** Fiessler AKAS-5M manual document 1581, 2024-02-15, printed pp. 3–5, 25–26, 29–34, https://www.fiessler.de/default-wAssets/docs/download/AKAS/bdh-akas-5-original-engl-doc1581-v1.0.pdf . The manufacturer documents repeated RS-232 status/error messages and a separate safety-PLC integration. These details apply to the named device, not every industrial protocol. **DOC-CONFIRMED.**

## Case A — Press brake

At 10:00:00 an ordinary PC UI receives a valid AKAS diagnostic indicating a normal condition. The RS-232 cable disconnects at 10:00:01. At 10:00:20 the UI still displays green `Laser OK`. The operator has switched to box-bending mode and changed the upper tool. No independent stop-distance or holding evidence is provided.

**Questions:** (1) Which propositions can the old message still establish? (2) Which are stale after cable loss, mode and tooling change? (3) Can the UI command an independent safety rearm? (4) What machine-specific evidence is missing before personnel-exposed bending?

## Case B — Lathe

A VFD's non-safety communications register says `speed=0` after a network stall. The chuck has a possible coast-down hazard, and a guard lock is requested to release. Distinguish `commanded zero`, `reported zero`, `physical standstill`, and `guard access safe`. State which independent safety-related function and physical witness must be selected and validated.

## Case C — Plasma gantry

An ordinary HMI reports `torch off`, but the gas supply and high-voltage/arc energy controls have not been independently inspected. Does this establish maintenance isolation? Identify separate electrical, pneumatic, thermal and motion energy paths, and the appropriate LOTO verification boundary.

## Case D — Robot cell

The safety system requests a protective stop; a diagnostics gateway goes offline while the arm carries a suspended payload. What can a last-known `stop requested` tag establish? Which holding, gravity, restart and inside-escape propositions remain unproved?

## Required answer structure

For **each** case produce a four-row evidence table:

| Evidence layer | Source/owner | Observed or assumed? | Physical proposition actually supported? |
|---|---|---|---|
| Ordinary controller/HMI | LinuxCNC, VFD, gateway or app | Timestamp + quality | Not automatically |
| Diagnostic interface | Identified device/protocol | Fresh/late/stale/unknown | Only documented diagnostic scope |
| Independent safety function | Selected safety logic + final elements | Selected design + validated status | Machine-specific |
| Physical/maintenance witness | Qualified independent instrumentation and energy controls | Measured or NOT RUN | Requires actual evidence |

Mark each claim `DOC-CONFIRMED`, `SOURCE-CONFIRMED`, `INFERENCE`, `UNKNOWN`, or `TEST-CONFIRMED` only when a test really exists. Record `BND/HAZ/ENE/SF/PHY/SRS/AUTH/DEP/HF/VAL/PT/CHG/UNK/RR` changes. A false-green UI is a human-factors defect; prefer explicit `LAST OBSERVED`, `STALE`, `MUTED`, `STOP REQUESTED` and `PHYSICAL STATE UNVERIFIED` rather than a single `SAFE` indicator.

**Minimum threshold:** no hazardous operation with people exposed if the required safety function and physical evidence are missing. A proposed isolated/remote test requires its own qualified plan, exclusion boundary and residual-risk statement; this worksheet is not an authorization to energize a machine.

## Reviewer checks (not a hidden key)

A satisfactory learner must avoid assuming that a healthy diagnostic packet, OSSD state, normal software inhibit, CRC, padlock, gauge or stop request by itself establishes every physical hazard controlled. The learner must also distinguish access/escape from maintenance isolation, identify a stale-data path, and propose a usable UI that discourages bypass. Any numeric stop/hold/pressure or PL/SIL claim without selected-machine evidence fails the exercise.

**Status:** documentary transfer exercise only; external 2520–25F0 fresh/blind competency gates remain OPEN; no physical `VAL/PT` or local/hosted compute was run.
