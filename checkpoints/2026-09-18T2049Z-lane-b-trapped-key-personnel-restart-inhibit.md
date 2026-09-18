# Safety checkpoint — Lane B trapped-key / personnel-key restart-inhibit authority

Date: 2026-09-18

## Completed

Created `safety-course/TRAPPED_KEY_PERSONNEL_KEY_RESTART_INHIBIT_AUTHORITY_STUDY_2026-09-18.md`; substantive commit `d840fac66922e347ccce6ca5c9d19635c3643f5e`.

## Parallel-lane reconciliation

Before selection, the newest primary durable checkpoint was `0874131bc00d68107f6f77727d391ecf15193821`, tracing same-machine press-brake maintenance gravity/hydraulic isolation with TRUMPF evidence. Lane B deliberately did not extend that hydraulic service procedure or modify its files. It selected the independent trapped-key/personnel-key access and restart-inhibit architecture.

Immediately after the substantive write, `main` was re-read: `d840fac...` was directly above `a73f164...`; no intervening overlapping primary write appeared. Shared `PROGRESS.md` was left untouched to avoid parallel collision.

## Frozen result

`STOP REQUEST != HAZARDOUS ENERGY ISOLATED != ISOLATION KEY RELEASED != ACCESS KEY RELEASED != GUARD OPEN AUTHORIZED != PERSONNEL KEY EXTRACTED != PERSON RETAINED/ACCOUNTED FOR != RESTART INHIBITED != HAZARD PHYSICALLY ABSENT`.

Restoration remains separately staged: `PERSON EXITS != PERSONNEL KEY RETURNED != ACCESS LOCK RESTORED != ALL ACCESS KEYS RETURNED != ISOLATION KEY RELEASED != ENERGY RESTORATION PERMITTED != SAFETY FUNCTION REVALIDATED != SAFETY REARM != FRESH ORDINARY START`.

Fortress professional application material source-confirms physical key exchange, multi-energy-source key exchange, access locks, person-carried personnel keys, and restart inhibition until the sequence is reversed. Pilz key-in-pocket material independently confirms the architectural principle that safety-side personnel accounting can prevent restart until the last person leaves, with blind-spot checking additionally relevant on large/obscured installations.

A key/token is an authority element in a sequence, not physical proof that every hazardous energy is absent.

## Evidence limits

No OpenPressBrake trapped-key requirement, key topology, number of entrants, isolation points, energy paths, blind areas, PL/SIL/category/DC/CCF, run-down time, hydraulic pressure criterion, gravity restraint, or restart procedure was invented. All remain UNKNOWN pending actual machine/application evidence.

## Compute

No executable verification was justified. No GitHub-hosted or self-hosted compute was consumed.

## Precise next work

Find a professional implementation or commissioning manual exposing `multiple hazardous-energy isolation keys -> key exchange -> multiple access/personnel keys -> bodily entry -> one person/key intentionally remains inside -> restart attempt inhibited -> all personnel keys returned -> access keys returned -> isolation token restored -> energy restoration -> safety reset/rearm -> separate fresh ordinary START`. Prefer evidence with wrong/missing/duplicate-key handling, escape release, or blind-area/personnel-clear checking. If that evidence path stalls, rotate to another independent open safety module rather than infer machine behavior.