# Trapped-key / personnel-key restart-inhibit authority study

Date: 2026-09-18
Lane: independent safety curriculum Lane B

## Question

How should the curriculum reason about trapped-key access and personnel-key systems for bodily-entry maintenance without confusing an ordinary control stop, an isolation command, an access key, a person-carried key, and actual hazardous-energy control?

This is intentionally independent of the primary lane's current press-brake maintenance gravity/hydraulic isolation trace. It studies the access/restart-inhibit sequencing architecture rather than a press-brake hydraulic service procedure.

## Evidence labels

- **SOURCE-CONFIRMED** — directly supported by authoritative manufacturer material cited below.
- **DOC-CONFIRMED** — supported by a repository-retained document/source trace.
- **TEST-CONFIRMED** — demonstrated by an executed test. None in this study.
- **COMMUNITY-REPORTED** — community experience not independently verified. None relied on here.
- **INFERENCE** — engineering conclusion derived from the confirmed architecture, not a quoted machine-specific requirement.
- **UNKNOWN** — must be established for the actual machine/application.

## Architecture freeze

`STOP REQUEST != HAZARDOUS ENERGY ISOLATED != ISOLATION KEY RELEASED != ACCESS KEY RELEASED != GUARD OPEN AUTHORIZED != PERSONNEL KEY EXTRACTED != PERSON RETAINED/ACCOUNTED FOR != RESTART INHIBITED != HAZARD PHYSICALLY ABSENT`.

For restoration:

`PERSON EXITS != PERSONNEL KEY RETURNED != ACCESS LOCK RESTORED != ALL ACCESS KEYS RETURNED != ISOLATION KEY RELEASED != ENERGY RESTORATION PERMITTED != SAFETY FUNCTION REVALIDATED != SAFETY REARM != FRESH ORDINARY START`.

A key is therefore an **authority token in a constrained sequence**, not proof that every hazardous energy is absent.

## Source trace

### Fortress Safety — complete trapped-key sequence

**SOURCE-CONFIRMED:** Fortress's current steel-processing entry-looper example describes a key-operated switch that isolates machine power, transfer of the released key to a key exchange, release of access keys, and an access lock that releases a personnel key. The operator retains the personnel key while inside; the access key remains trapped until the personnel key is returned. Machine restart becomes possible only after reversing the sequence.

Source: https://fortress-safety.com/application/entry-looper-in-steel-processing/

**SOURCE-CONFIRMED:** Fortress's trapped-key overview explains that where multiple hazardous-energy sources are part of the interlocking design, each associated energy-source key must be inserted into the key exchange before access keys can be released. It also explains that a personnel key can be extracted before access; until that personnel key is returned, the upstream access key remains trapped and the access lock cannot be reset.

Source: https://fortress-safety.com/news/understanding-trapped-key-systems/

**SOURCE-CONFIRMED:** Fortress's mGard application brochure shows a two-cell machine example with request-to-enter, controlled stop/run-down, zero-motion/voltage-sensing elements, key exchange, access locks, and extracted personnel keys. The diagram states that the isolation key remains trapped until the safety/access keys are returned.

Source: https://fortress-safety.com/wp-content/uploads/2022/06/mGard-Overview-Brochure-June-2020-v1.5-EN-QR-Download-Digital-Version.pdf

### Pilz — electronic key-in-pocket comparison

**SOURCE-CONFIRMED:** Pilz's PSS 4000 key-in-pocket maintenance-safeguarding material states that restart is prevented while people remain in the danger zone. Its access-management description records authenticated personnel in a safety-side list, allows multiple people to enter with personal transponder keys, and does not release production mode until all people have exited and logged out; for large/obscured installations it additionally describes a blind-spot check.

Sources:
- https://www.pilz.com/en-US/company/news/articles/238605
- https://www.pilz.com/de-CH/zugangsmanagement

This is useful as an independent architecture comparison: a mechanical trapped-key chain and an electronic key-in-pocket system use different technology but both preserve a safety-side restart-inhibit state associated with personnel entry.

## What this proves — and what it does not

**SOURCE-CONFIRMED:** A trapped-key system can enforce a sequence in which an upstream isolation/access token cannot be recovered while a downstream personnel key is absent.

**INFERENCE:** That sequencing property is valuable because a person carrying the personnel key makes ordinary restart harder to achieve through a single stale PLC/LinuxCNC command or casual guard closure.

**UNKNOWN:** Whether the actual OpenPressBrake application should use trapped keys, electronic key-in-pocket, LOTO, guard locking, escape release, another method, or a combination.

**UNKNOWN:** Which OpenPressBrake energy sources would have to be physically isolated or otherwise controlled before an access key could be released.

**UNKNOWN:** Whether a future OpenPressBrake cell would permit full bodily entry, how many people may enter, what blind areas exist, what physical energy-isolating devices exist, and whether run-down/standstill sensing is needed.

**UNKNOWN:** Required PL/SIL/category/DC/CCF, key coding, key-exchange topology, timing, stopping distance/time, hydraulic pressure criteria, gravity-load support, or restart procedure.

## LinuxCNC / FPGA authority boundary

Ordinary LinuxCNC/HAL/FPGA may request a stop, display access state, log key/interlock diagnostics, and refuse ordinary motion when safety permission is absent. It must not be treated as the sole personnel-safety authority that remembers who is inside or decides that returning one ordinary software bit is equivalent to returning all personnel keys.

The useful design boundary is:

`ordinary stop/request -> independent safety/isolation evaluation -> physical energy/final-element action as required -> trapped-key/key-exchange sequence -> access/personnel-key state -> restart inhibit`.

Only after the independent safety/access sequence is legitimately restored should ordinary control regain the possibility of motion, and restoration must not manufacture a stale LinuxCNC `START/JOG/CYCLE` into fresh intent.

## Failure-path worksheet

Commissioning/validation should deliberately challenge at least these questions where applicable:

1. Can an access key be obtained before every required upstream isolation/standstill condition is satisfied?
2. Can the guard be closed and upstream key recovered while a personnel key is still absent?
3. With two people inside, does returning one person's key leave restart inhibited?
4. Can a duplicate, wrong, spare, or master key defeat the intended personnel accounting? What administrative/technical controls govern such keys?
5. Does loss/breakage of a personnel key fail toward continued restart inhibition rather than silently recreating production authority?
6. Can a guard actuator or access lock be mechanically defeated while the key sequence appears complete?
7. Can power loss/recovery, controller reboot, or network recovery bypass the mechanical/electronic personnel-retention state?
8. If ordinary LinuxCNC reports `ON`, `READY`, or `START`, does the independent safety system still prevent hazardous motion while any required personnel/access token is absent?
9. Does returning all keys prove only that the key sequence is complete, or is a separate area-clear/blind-spot check required for the actual geometry?
10. After restoration, is deliberate safety reset/rearm separated from a fresh ordinary production-start action?

## Maintenance and bypass risks

**INFERENCE:** The strongest property of a trapped-key sequence can become its weakness if uncontrolled spare/master keys exist, keys are duplicated, locks are defeated, or the installed sequence no longer matches modified energy paths. Key-control configuration therefore belongs in change management and periodic validation, not just initial commissioning.

**SOURCE-CONFIRMED:** Fortress product/application material explicitly supports personnel-key and escape-release functions, showing that trapped-key access and emergency egress are separate concerns that may need to coexist.

An escape route must not be inferred merely because a personnel key exists.

## Practical teaching rule

Teach the learner to draw **tokens and physical states separately**. For every key transition, ask:

- What physical or safety-side condition permits this key to be released?
- What key becomes trapped as a consequence?
- What hazardous energy/final element has actually changed state?
- What prevents restart while a person retains a key?
- What independent witness, if any, proves the physical hazard is controlled?
- What must happen after all people exit before motion authority can return?

Do not draw `key removed = machine safe` without tracing the actual energy and final-element path.

## Compute

No executable verification is justified for this source/architecture study. No GitHub-hosted or self-hosted compute is consumed.

## Precise next work

Find a professional implementation or commissioning manual exposing `multiple hazardous-energy isolation keys -> key exchange -> multiple access/personnel keys -> bodily entry -> one person/key intentionally remains inside -> restart attempt inhibited -> all personnel keys returned -> access keys returned -> isolation token restored -> energy restoration -> safety reset/rearm -> separate fresh ordinary START`. Prefer evidence that also documents wrong/missing/duplicate key handling, escape release, or a blind-area/personnel-clear check. Preserve UNKNOWN rather than inferring machine-specific energy isolation from the key sequence.