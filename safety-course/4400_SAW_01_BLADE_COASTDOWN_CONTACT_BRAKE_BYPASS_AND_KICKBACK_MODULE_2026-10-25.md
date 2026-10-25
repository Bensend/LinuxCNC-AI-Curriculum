# 4400-SAW-01 — Saw blade coast-down, contact protection, bypass and kickback
**2026-10-25 | 4000 safety curriculum | NON-GRADUATED / paper only**

## Objective
Distinguish ordinary motor OFF, still-spinning blade, contact-detection power, contact-brake/retraction response, bypass state, blade compatibility, kickback protection, guard access and maintenance isolation. The aim is to prevent unsafe 'motor off = safe' assumptions across LinuxCNC saws, spindles, mills and press brakes.

Prerequisites: 2520 SRS, 2530 E-stop, 2570 drives/coasting, 2590 guards, 4400-MON-01 safe-speed source, 4400-SET-01 setup mode, 4400-GUARD-01 anti-bypass. Read [original OEM/OSHA source audit](../research/4400_SAWSTOP_FELDER_COASTDOWN_BRAKE_BYPASS_AND_KICKBACK_OEM_AUDIT_2026-10-25.md).

## Separate propositions
| Proposition | Actual engineering question | Not proved by |
|---|---|---|
| Motor OFF | Has drive torque command ceased? | HMI red stop icon alone |
| Blade stopped | Has dangerous rotation physically ceased? | motor power OFF or command zero |
| Contact protection active | Does the selected detection/brake/retraction function remain enabled in this mode and supply state? | blade spinning, green generic LED |
| Blade compatible | Does exact blade/insert match selected OEM brake and sensor limitations? | diameter alone |
| Kickback protected | Can stock bind, eject or strike an operator? | contact-brake presence |
| Guard/access | Can a person reach blade/under-table drive before safe state? | operator training alone |
| Maintenance isolated | Is electrical/mechanical stored energy rendered safe for hands-on work? | contact protection enabled |
| Restart safe | Are bypass and prior commands cleared, deliberate new start and guard state validated? | reapplying main power |

## Primary OEM findings
SawStop PCS official FAQ states that with its **red motor paddle** switched off, the cartridge still monitors the coasting blade **provided the yellow main power remains on**. This is a specific monitored-coast-down state, not proof that power removal instantly stops the blade. The manufacturer also describes a **Bypass Mode that disables braking** and blade-dependent limitations. Felder PCS product documentation describes contactless detection/retraction and **key-switch deactivation** for special materials. Both are exact OEM statements, not transferable safety performance ratings.

OSHA separates blade contact, below-table exposure, **kickback** and flying debris. No skin-contact brake can be assumed to solve kickback or guard the drive train.

## Abstract state and authority review — not executable logic
- **RUN_PROTECTED:** selected normal feed, guards, detection/retention verified; no blanket permission for hands near blade.
- **STOP_REQUESTED:** CNC/drive torque command OFF, blade may still coast; protection state depends on exact selected system.
- **COASTING_MONITORED:** selected monitoring may remain active with appropriate power (documented PCS case); physical standstill not yet established.
- **STANDSTILL_CONFIRMED:** qualified evidence of zero hazardous rotation, guard/access separately evaluated.
- **BYPASS_AUTHORIZED:** special-mode exception, separate risk controls and conspicuous status; never silently equivalent to protected mode.
- **SERVICE_ISOLATED:** energy isolated, residual rotation verified stopped, guards/restraints addressed. Distinct from monitored coasting.
- **RESTORE_REVALIDATE:** blade, brake cartridge, bypass and guards checked, then deliberate fresh start only.

Normal LinuxCNC spindle speed commands and HAL indicators can support diagnostics and process coordination but are **not the sole personnel-safety authority**. Actual final element, independent safety function and physical blade/stock witnesses are separate.

## Practical human-factors rules
A guard must be convenient to lift/reinstall for legitimate stock and blade changes; a bypass mode must be obvious and limited, not the easiest permanent operating mode. Provide quick material compatibility information, clear cartridge/blade identification, a predictable reset procedure and understandable fault feedback. Avoid instructions that encourage using a hazardous moving blade to test protective functions.

**Minimum safe-to-operate:** if selected machine lacks appropriate point-of-operation/under-table guarding, credible kickback control, stop/coast/access behavior, maintenance isolation or restart controls, do not operate with personnel exposed. Any engineering test requires separate qualified remote/isolation planning; none is authorized here.

## Evidence and graduation
[12 PAPER scenarios](4400_SAW_01_COASTDOWN_BYPASS_BLADE_CHANGE_TECHNICIAN_CARD_2026-10-25.md) exercise states and selected witness requirements. **DOC-CONFIRMED** exact OEM/OSHA; **INFERENCE** state model; **UNKNOWN** any selected saw, brake, runtime or safety performance; **TEST-CONFIRMED none**; **SOURCE-CONFIRMED no new LinuxCNC code**. No external evaluator scored. Do not invent a stop distance, coasting duration, bypass threshold, PL/SIL or independent brake response.

**Promotion:** actual selected saw source, guard, blade/cartridge identity, coast-down/standstill witness, bypass mode/return, kickback geometry and independent competency; these block selected machine operation release, not general source-study publication. No installed SawStop/Felder on OpenPressBrake asserted.
