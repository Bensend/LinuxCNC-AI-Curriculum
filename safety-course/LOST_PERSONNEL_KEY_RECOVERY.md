# Lost Personnel Key / Administrative Safety-State Recovery

Session start: 2026-09-16T07:36:05Z

## Purpose

Teach recovery from a lost, damaged, duplicated, or administratively inconsistent personnel/trapped key without turning administrative recovery into proof that a safeguarded space is physically clear.

## Evidence labels

- **DOC-CONFIRMED — Fortress mGard:** mechanical trapped-key systems enforce predetermined sequences and can control electrical, pneumatic, and hydraulic hazardous-energy sources. Keys/access locks are part of the enforced physical sequence.
- **DOC-CONFIRMED — Fortress key-code guidance:** unintentional duplication of trapped-key codes must be prevented; duplicate keys are intended only for replacement of lost/damaged keys; spare/master keys used in a key-exchange system require management control and must be considered in the risk assessment.
- **DOC-CONFIRMED — Fortress RFID Safety Key (RSK):** a personnel key is retained by a person to prevent unexpected startup. When a lost RSK is replaced by reteaching a blank key, the pod code changes so the lost key no longer operates that pod.
- **DOC-CONFIRMED — Fortress application examples:** personnel retain access/personnel keys while inside; restart is prevented until keys are returned and the required sequence is reversed.
- **INFERENCE:** recovering the key/accounting system cannot by itself prove that no person remains in the protected space. A separate physical/administrative space-clear procedure is required before restart permission is restored.
- **UNKNOWN:** the required PL/SIL/category, number of keys, exact recovery authorization, search procedure, timing, guard geometry, hazardous-energy isolation method, and restart procedure for any particular machine until application-specific risk assessment and design evidence exist.

## Core state model

Keep these states separate:

1. `hazardous_energy_controlled`
2. `guard_access_state`
3. `personnel_key_expected`
4. `personnel_key_present_or_accounted`
5. `key_identity_valid`
6. `key_system_integrity_valid`
7. `whole_space_checked`
8. `reset_request`
9. `safety_permission`
10. `ordinary_machine_rearm`
11. `ordinary_start_request`

Never collapse them into one `safe` bit.

## Lost-key rule

A missing personnel key is an unresolved occupancy/startup-inhibit condition until a defined recovery procedure is completed. The easiest recovery path must fail closed: do not permit an HMI checkbox, LinuxCNC HAL bit, ordinary FPGA input, database edit, controller reboot, or maintenance password to simply mark the missing key returned.

For a conventional mechanical trapped-key system, introducing a duplicate/replacement key without controlling the old key creates the possibility that two valid keys exist for one intended single-key state. Fortress's published guidance explicitly treats duplicate keys as a management-controlled exception for lost/damaged replacement, not an ordinary convenience spare.

For a reprogrammable coded personnel-key system such as Fortress RSK, replacement can invalidate the lost key by changing the accepted code. That resolves **key identity/integrity**, not automatically **space occupancy**. Before restart, the protected space still requires the application's valid space-clear/reset/restart process.

## Recovery contract

A defensible generic recovery sequence is:

`missing_key_detected -> inhibit_restart -> preserve hazardous-energy control -> authorized investigation -> physical whole-space check -> resolve/invalidate lost key identity -> validate key-system state -> close/restore safeguarding -> deliberate reset -> safety permission -> ordinary rearm -> separate start request`

The ordering is application-dependent, especially where access itself requires energy isolation, but the following invariants are not negotiable:

- lost-key administrative recovery does not equal person-clear proof;
- restoring a guard does not equal person-clear proof;
- rebooting/replacing the controller does not erase unresolved personnel accounting;
- replacing a key must not leave an uncontrolled second valid key;
- reset must not itself command hazardous motion;
- ordinary LinuxCNC/FPGA logic must not become the sole personnel-safety authority merely because it stores convenient state.

## Controller replacement / corrupted state

If personnel accounting depends partly on electronic state and that state is corrupted, lost, restored from backup, or transferred to a replacement controller, treat the personnel-accounting claim as invalid until reconciled by the defined recovery procedure. A fresh controller starting with `all keys present` is an unsafe default when the physical system cannot prove that condition.

Persisting a software flag across reboot is also insufficient by itself: persistence can preserve stale or wrong state. Recovery needs evidence tied to the actual key/interlock system and protected space.

## Adversarial cases

The learner/evaluator must reason through at least these cases:

- A technician loses a personnel key while outside the cell and asks for a spare so production can resume.
- The lost key may still be inside the cell.
- A duplicate mechanical key exists in a supervisor drawer.
- A coded key is lost and a replacement is taught, but nobody performs the whole-space check.
- A lost coded key is later found after the system was re-coded.
- The safety controller is replaced and its key-accounting database is empty/defaulted.
- A backup restores yesterday's personnel-key state.
- A network/HMI says every person is out while one physical key is missing.
- A maintenance bypass allows key-accounting inputs to be simulated and is accidentally left active.
- Production pressure encourages operators to keep convenience duplicates.
- The recovery procedure is so slow or inaccessible that workers predictably bypass it.

For each case identify: what is physically known, what is only administratively asserted, what evidence is invalid, what must remain inhibited, and what independent action/evidence is needed before rearm.

## Human-factors requirement

Replacement and recovery must be practical enough that the normal safe path is easier than hiding a lost key, borrowing an uncontrolled duplicate, defeating an interlock, or falsifying an HMI state. Keep controlled blanks/replacement hardware and the recovery instructions accessible to authorized maintainers, but do not keep active convenience duplicates that undermine the one-person/one-key accounting claim.

A safeguard whose routine recovery process predictably motivates defeat has a design problem. Improve recovery ergonomics without weakening the physical safety invariant.

## LinuxCNC / ordinary FPGA boundary

LinuxCNC and the ordinary controller may:

- display key/interlock diagnostics;
- log missing-key events;
- inhibit normal machine commands;
- discard stale start/rearm commands after recovery;
- require an ordinary rearm after independent safety permission returns.

They must not be taught as independently proving personnel absence, invalidating a physical duplicate key, or replacing the independent safety-related control/interlock architecture.

## Minimum-safe-operation statement

If the system cannot establish a trustworthy restart-prevention state after a missing/duplicate key or corrupted personnel-accounting condition, do not operate with people exposed to the hazard. Experimental operation, if genuinely necessary, must keep people outside the danger zone and use an independently established isolated/remote condition with residual risk stated explicitly.

## Sources

- Fortress Safety, `mGard` mechanical trapped-key product documentation: https://fortress-safety.com/fortress-range/mgard/
- Fortress Safety, `Key Information When Designing Fortress Trapped Key` (includes key-code/duplicate/master-key guidance and cites ISO/TS 19837:2018): https://fortress-safety.com/wp-content/uploads/2021/08/Key-Information-When-Designing-Fortress-Trapped-Key.pdf
- Fortress Safety, `RFID Safety Keys (RSK)` product page: https://fortress-safety.com/fortress-range/amgardpro/rfid-safety-key-rsk/
- Fortress Safety, `RFID Safety Keys` brochure: https://fortress-safety.com/app/uploads/2025/04/RFID-Safety-Keys-Brochure-RSK.pdf
- Fortress Safety, entry-looper application example: https://fortress-safety.com/application/entry-looper-in-steel-processing/

## Next evidence question

Develop the companion **maintenance bypass / override lifecycle** lesson: authorization, indication, scope limitation, timeout/removal, configuration retention, post-maintenance validation, and recovery when bypass state is unknown after power loss/controller replacement. Preserve the distinction between a safety-rated designed override and an improvised defeat.