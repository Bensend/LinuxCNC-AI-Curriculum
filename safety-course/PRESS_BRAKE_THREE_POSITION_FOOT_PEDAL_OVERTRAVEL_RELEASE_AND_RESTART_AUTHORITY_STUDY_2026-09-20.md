# Press-Brake Three-Position Foot-Pedal Overtravel, Release, and Restart Authority Study

Date: 2026-09-20
Lane: independent safety curriculum Lane B

## Question

What safety authority should a press-brake three-position foot control have, and what must happen after release or panic overtravel before hazardous closing motion can be authorized again?

This branch is intentionally independent of the primary lane's current post-maintenance/change-impact work.

## Evidence

### Fiessler FE-FS safety foot pedals — DOC-CONFIRMED

Fiessler documents FE-FS safety foot controls specifically for dangerous press/lifting/bending movement. The three-position overtravel mechanism has a deliberate pressure point. Actuation to the working position switches the operating contacts; pressing beyond the pressure point returns the operating contacts to their idle state and actuates positive-opening safety contact(s), initiating the machine stop and providing redundant information to the safety circuit. Fiessler further states that machine restart is possible only after the foot switch has been completely released.

Sources retrieved 2026-09-20:
- Fiessler Elektronik, Safety foot pedals FE-FS: https://www.fiessler.de/en/products/safety-products/safety-footpedals/safety-foot-pedals-fe-fs.php
- Fiessler Elektronik, FE-FS product brochure: https://www.fiessler.de/default-wAssets/docs/download/FE-FS/prd-fe-fs-engl-doc1908.pdf

Evidence classification: `DOC-CONFIRMED`.

### Lazer Safe Defender Stop-at-Mute sequencing — DOC-CONFIRMED

Lazer Safe's Defender press-brake guarding installation manual documents a distinct release-and-repress sequence in Stop-at-Mute mode: the press beam is forced to stop at the mute point, and the operator must release and re-press the foot pedal to complete the bend. This is not the same safety function as Fiessler's panic-overtravel element, but it independently demonstrates a press-brake control architecture in which a continuously held ordinary foot command is intentionally insufficient after a safety-relevant stop boundary.

Source retrieved 2026-09-20:
- Lazer Safe, Defender Press Brake Guarding System Installation Manual LS-CS-M-070, rev. 1.08: https://support.lazersafe.com/assets/files/Manuals-and-Guides/Registered-users/ls-cs-m-070-defender-press-brake-guarding-system-installation-manual-1-08.pdf

Evidence classification: `DOC-CONFIRMED`.

## Authority model

The evidence supports keeping these states distinct:

1. **Pedal released** — no ordinary closing request.
2. **Pedal deliberately in working position** — ordinary closing request exists, but this alone does not establish every independent safety prerequisite.
3. **Pedal pressed through the pressure point / overtravel** — safety stop demand; ordinary working contacts return to idle and positive-opening safety contact(s) provide the safety-circuit demand/witness.
4. **Pedal returning from overtravel** — must not be treated as a new valid start merely because it passes through the working position.
5. **Pedal completely released after overtravel** — prerequisite for a later restart, not production authority by itself.
6. **Fresh subsequent pedal actuation** — a new ordinary request, still subordinate to independent safety readiness, safeguards, final-element qualification, and machine-specific operating-mode rules.

## Curriculum freezes

**PEDAL IN WORKING POSITION != PERSONNEL-SAFETY AUTHORITY.**

**OVERTRAVEL/PANIC DEMAND != ORDINARY SOFTWARE STOP REQUEST.**

**OVERTRAVEL RELEASED != RESTART AUTHORIZED.**

**RETURN THROUGH THE WORKING POSITION AFTER OVERTRAVEL != FRESH START.**

**COMPLETE PEDAL RELEASE != MACHINE SAFE/READY; IT IS ONLY A PREREQUISITE TO A LATER FRESH REQUEST.**

**FRESH PEDAL REQUEST != SAFETY READY; INDEPENDENT SAFETY CONDITIONS STILL GOVERN HAZARDOUS MOTION.**

## Failure-path / commissioning worksheet

A machine-specific implementation should challenge, without inventing its acceptance numbers:

- normal released -> working-position actuation and expected closing request;
- working position -> release and actual hazardous-motion stopping response;
- working position -> full overtravel/panic actuation and actual safety/final-element response;
- slow return from full overtravel through the working position, proving no hazardous restart occurs on the intermediate state;
- complete release after overtravel, proving release alone does not start motion;
- a new deliberate pedal actuation after complete release, proving it is treated as a fresh ordinary request;
- held/stuck ordinary pedal input across a safety demand/reset/requalification, proving stale ordinary demand cannot silently become restart authority;
- disagreement/open/short fault cases for redundant pedal/safety contacts when the selected architecture claims those diagnostics;
- pedal replacement or rewiring, including physical contact-state mapping and positive-opening safety path rather than trusting a LinuxCNC/HAL bit;
- power restoration with the pedal already depressed, with machine-specific restart behavior validated from authoritative design requirements;
- side/rear/optical safeguard demand while the pedal remains held, proving the pedal cannot override an independent protective function;
- actual final-element response and physical machine stopping where the safety claim depends on it.

## LinuxCNC / FPGA boundary

LinuxCNC may consume a normal pedal request for sequence control, diagnostics, UI state, or recording. An ordinary FPGA may report contact states. Neither becomes the personnel-safety authority merely because it can see the pedal.

Where the machine architecture relies on the positive-opening overtravel safety contacts, their safety path must remain independent and must command/prove the required final-element behavior through the safety architecture. A displayed `PEDAL_OK`, `FOOT_DOWN`, or equivalent software bit is not a substitute for the safety circuit or physical stop witness.

## Evidence status

- Three-position pressure-point/overtravel behavior: `DOC-CONFIRMED`.
- Positive-opening safety contact behavior in the cited Fiessler pedal family: `DOC-CONFIRMED`.
- Restart only after complete pedal release for that family: `DOC-CONFIRMED`.
- Lazer Safe release-and-repress requirement after Stop-at-Mute: `DOC-CONFIRMED`.
- OpenPressBrake pedal type/contact topology: `UNKNOWN`.
- OpenPressBrake required safety performance, stop time/distance, PL/SIL/category/DC/CCF: `UNKNOWN`.
- OpenPressBrake hydraulic/final-element response to pedal overtravel: `UNKNOWN`.
- Any claim that OpenPressBrake must use this exact Fiessler device: `UNKNOWN` / not established.

No `SOURCE-CONFIRMED`, `TEST-CONFIRMED`, or `COMMUNITY-REPORTED` claim is made in this artifact.

## Information-gain decision / next work

The state-machine distinction is now strong enough for curriculum use. The next high-value Lane-B evidence is a manufacturer/OEM commissioning or functional-test procedure that deliberately tests **working position -> release stop -> working position -> panic overtravel stop -> slow return through the working position with no restart -> complete release -> fresh re-actuation**, preferably while also proving the physical final-element/machine response and a redundant-contact fault. If authoritative sources stop at component switching diagrams, mark this branch source-limited and rotate rather than inventing a machine acceptance sequence.

No executable verification was needed for this documentation/source-tracing question. No GitHub-hosted runner was used.