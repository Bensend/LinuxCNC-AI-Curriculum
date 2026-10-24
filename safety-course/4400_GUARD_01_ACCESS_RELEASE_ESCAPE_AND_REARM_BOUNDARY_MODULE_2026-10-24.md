# 4400-GUARD-01 — Guarded access: unlock requests, escape and fresh rearm
**Level 4000 | 2026-10-24 | SOURCE-READING / NOT GRADUATED / NO MACHINE TEST**

## Prerequisites and purpose
Use 2520 SRS, 2530 E-stop, 2540 final elements, 2570/2580 maintenance/LOTO, 2590 protective devices, 4400-SET-01 setup mode and 4400-CFG-01 configuration identity. This module teaches that **guard-closed**, **guard-locked**, **machine stopped**, **safe to unlock**, **personnel clear**, **reset complete**, and **motion start authorized** are distinct predicates. An apparently green guard indicator must never merge them.

Read [original Pilz/Rockwell manufacturer investigation](../research/4400_PILZ_PSENMLOCK_AUXILIARY_RELEASE_SDD_NONSAFETY_GUARD_AUTHORITY_AUDIT_2026-10-24.md) and [14 paper cases](4400_GUARD_LOCK_RELEASE_INSIDE_ESCAPE_REARM_TECHNICIAN_CARD_2026-10-24.md).

## State/authority contract (design pattern, not a selected-machine truth table)
1. **Access requested:** ordinary HMI/LinuxCNC may ask for access; this is not a safety permission.
2. **Independent safe-state evaluation:** safety-related logic and physical elements must ensure the hazard is stopped/held and safe to expose before permitting unlock. A controller “motion complete” bit is not enough.
3. **Guard unlocking:** exact OEM S31/S41/OSSD logic and hardware must be evaluated. Standard SDD fieldbus unlock commands are non-safety in the cited Pilz device and must remain gated by safety inputs.
4. **Person inside:** assess whole-body entry, trapped-person risk, escape release accessible from inside, means to prevent unexpected restart and appropriate energy isolation. An access-side *auxiliary* release is not automatically an inside emergency escape.
5. **Reclosing:** even if the guard automatically relocks and OSSDs return high, require zone-clear confirmation, reset and separate deliberate fresh start. No old queued LinuxCNC command may reanimate motion.
6. **Service/replacement:** verify coding/teach-in and authorized replacement, return auxiliary release to normal, inspect guard and perform qualified functional check before release.

## OEM evidence limits
Pilz PSENmlock mini 1005801-EN-05 pp18–29/31/51–53 **DOC-CONFIRMED**: SDD fieldbus is non-safety; active mode requires safety input conditions; auxiliary release only at standstill, not a safety function; 12/22 are safety outputs while Y32 is diagnostic; actuator coding and recommissioning vary. Rockwell 442G official product information distinguishes power-to-release versus power-to-lock and optional escape release. Pilz product page describes a bistable family. **None** establishes the installed OpenPressBrake variant, selected PL, stop distance or actual egress.

## Human factors and affordable architecture
A gate that needs an inconvenient tool every normal cycle will invite bypass. Prefer well-aligned captive-hardware guards, a clearly labeled access request, readily understandable “waiting for safe state” indication, visible lock condition, safe trapped-person exit provisions where required, and simple authorized maintenance procedure. Make the service path shorter than a jumper. Never substitute convenience for physical stopping and holding.

## Failure and verification table
| Failure | Consequence | Required check |
|---|---|---|
| Safety lock relocks automatically and queued move resumes | unexpected restart | independent reset/fresh-start interlock |
| Standard fieldbus request bypasses safety input gate | access before stop | exact wiring/logic/final-element authority review |
| Power fails with someone inside | trapping or unintended opening | selected power-loss state and escape route |
| Auxiliary release not restored | defeated/unavailable locking | OEM recommissioning and qualified functional test |
| Replacement actuator not accepted or spoofed | bypass temptation | coding/teach-in inventory, mechanical alignment, service workflow |
| Guard opens while ram/load still moves | crush/shear hazard | physical independent stop and load holding, measured where required |

**Selected machine:** IN-04z UNKNOWN; G0/G1 HOLD, G3/G4 NOT AUTHORIZED; no physical validation or independent evaluator score. No personnel-exposed hazardous operation. No local or GitHub-hosted compute justified.
